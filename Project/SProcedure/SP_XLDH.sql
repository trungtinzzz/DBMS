-- Tạo stored procedure SP_ApDungKhuyenMaiTotNhat để lựa chọn khuyến mãi tốt nhất cho sản phẩm trong đơn hàng
CREATE PROCEDURE SP_ApDungKhuyenMaiTotNhat
    @MaDonHang CHAR(15)  -- Mã đơn hàng cần áp dụng khuyến mãi
AS
BEGIN
    DECLARE @MaKhachHang CHAR(10);
    DECLARE @LoaiKhachHang CHAR(10);
    DECLARE @MaSanPham CHAR(10);
    DECLARE @GiaSP INT;
    DECLARE @SoLuong INT;
    DECLARE @GiamGia INT;
    DECLARE @LoaiKhuyenMai NVARCHAR(50);
    DECLARE @ThoiGianBatDau DATE;
    DECLARE @ThoiGianKetThuc DATE;

    -- Lấy mã khách hàng và phân hạng khách hàng từ đơn hàng
    SELECT @MaKhachHang = DonHang.MaKhachHang
    FROM DonHang
    WHERE MaDonHang = @MaDonHang;

    -- Lấy phân hạng khách hàng
    SELECT @LoaiKhachHang = MaLoaiKhachHang
    FROM KhachHang
    WHERE SDT = @MaKhachHang;

    -- Lặp qua từng sản phẩm trong đơn hàng
    DECLARE product_cursor CURSOR FOR
        SELECT MaSanPham, Gia, SoLuong
        FROM ChiTietDonHang
        WHERE MaDonHang = @MaDonHang;

    OPEN product_cursor;
    FETCH NEXT FROM product_cursor INTO @MaSanPham, @GiaSP, @SoLuong;

    -- Lặp qua các sản phẩm và áp dụng khuyến mãi tốt nhất
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Lựa chọn khuyến mãi tốt nhất cho từng sản phẩm
        -- Kiểm tra khuyến mãi và tính giá trị giảm giá
        SELECT TOP 1 @GiamGia = CASE 
                                    WHEN KhuyenMai.LoaiKhuyenMai = 'Flash-sale' THEN @GiaSP * 0.20 -- Giảm 20% cho Flash-sale
                                    WHEN KhuyenMai.LoaiKhuyenMai = 'Combo-sale' THEN @GiaSP * 0.15 -- Giảm 15% cho Combo-sale
                                    WHEN KhuyenMai.LoaiKhuyenMai = 'Member-sale' AND @LoaiKhachHang = 'KIMCUONG' THEN @GiaSP * 0.30 -- Giảm 30% cho Kim cương
                                    WHEN KhuyenMai.LoaiKhuyenMai = 'Member-sale' AND @LoaiKhachHang = 'BACHKIM' THEN @GiaSP * 0.25 -- Giảm 25% cho Bạch kim
                                    WHEN KhuyenMai.LoaiKhuyenMai = 'Member-sale' AND @LoaiKhachHang = 'VANG' THEN @GiaSP * 0.20 -- Giảm 20% cho Vàng
                                    ELSE 0
                                 END,
               @LoaiKhuyenMai = KhuyenMai.LoaiKhuyenMai,
               @ThoiGianBatDau = KhuyenMai.ThoiGianBatDau,
               @ThoiGianKetThuc = KhuyenMai.ThoiGianKetThuc
        FROM KhuyenMai
        WHERE @MaSanPham IN (SELECT MaSP FROM ChiTietKhuyenMai WHERE MaKhuyenMai = KhuyenMai.MaKhuyenMai)
          AND GETDATE() BETWEEN KhuyenMai.ThoiGianBatDau AND KhuyenMai.ThoiGianKetThuc
          AND KhuyenMai.MaKhuyenMai NOT IN (SELECT MaKhuyenMai FROM ChiTietDonHang WHERE MaDonHang = @MaDonHang AND MaSP = @MaSanPham);

        -- Cập nhật giá trị giảm giá cho sản phẩm trong đơn hàng
        UPDATE ChiTietDonHang
        SET Gia = @GiaSP - @GiamGia,  -- Áp dụng giảm giá cho sản phẩm
            GiamGiaTheoPhieu = @GiamGia
        WHERE MaDonHang = @MaDonHang AND MaSanPham = @MaSanPham;

        FETCH NEXT FROM product_cursor INTO @MaSanPham, @GiaSP, @SoLuong;
    END

    -- Đóng con trỏ
    CLOSE product_cursor;
    DEALLOCATE product_cursor;

    -- Đảm bảo rằng các thay đổi được commit vào cơ sở dữ liệu
    COMMIT;
END;
GO
-- Thực thi stored procedure để áp dụng khuyến mãi tốt nhất cho đơn hàng
EXEC SP_ApDungKhuyenMaiTotNhat @MaDonHang = 'DH0001';

-- Tạo stored procedure SP_TaoDonHangMoi để tạo đơn hàng mới
CREATE PROCEDURE SP_TaoDonHangMoi
    @MaDonHang CHAR(15),               -- Mã đơn hàng
    @MaKhachHang CHAR(10),             -- Mã khách hàng (SDT)
    @NgayMua DATETIME,                 -- Thời gian mua hàng
    @GiamGia INT,                      -- Tổng giá trị giảm giá của đơn hàng (nếu có)
    @ChiTietDonHang NVARCHAR(MAX)      -- Danh sách các sản phẩm trong đơn hàng (dạng chuỗi JSON hoặc CSV)
AS
BEGIN
    DECLARE @TongTien INT;

    -- Tính tổng tiền đơn hàng trước khi áp dụng giảm giá
    SELECT @TongTien = SUM(SanPham.GiaSP * ChiTietDonHang.SoLuong)
    FROM ChiTietDonHang
    JOIN SanPham ON ChiTietDonHang.MaSanPham = SanPham.MaSP
    WHERE ChiTietDonHang.MaDonHang = @MaDonHang;

    -- Kiểm tra nếu đơn hàng đã tồn tại
    IF EXISTS (SELECT 1 FROM DonHang WHERE MaDonHang = @MaDonHang)
    BEGIN
        PRINT 'Đơn hàng đã tồn tại!';
        RETURN;  -- Dừng procedure nếu đơn hàng đã tồn tại
    END

    -- Tạo đơn hàng mới trong bảng DonHang
    INSERT INTO DonHang (MaDonHang, MaKhachHang, ThoiGianMua, GiamGiaTheoPhieu)
    VALUES (@MaDonHang, @MaKhachHang, @NgayMua, @GiamGia);

    -- Thêm các sản phẩm vào bảng ChiTietDonHang từ danh sách sản phẩm
    -- (Dữ liệu danh sách sản phẩm phải được phân tách đúng cách, ví dụ CSV hoặc JSON)
    -- Giả sử thông tin sản phẩm được cung cấp là dạng CSV: 'SP001,2,SP002,3'
    DECLARE @ProductList TABLE (MaSanPham CHAR(10), SoLuong INT);

    -- Giải mã dữ liệu CSV thành các bản ghi
    INSERT INTO @ProductList (MaSanPham, SoLuong)
    SELECT * FROM STRING_SPLIT(@ChiTietDonHang, ',');

    -- Thêm chi tiết sản phẩm vào đơn hàng
    INSERT INTO ChiTietDonHang (MaDonHang, MaSanPham, Gia, SoLuong)
    SELECT @MaDonHang, MaSanPham, SanPham.GiaSP, SoLuong
    FROM @ProductList
    JOIN SanPham ON @ProductList.MaSanPham = SanPham.MaSP;

    -- Cập nhật tổng tiền đơn hàng sau khi áp dụng giảm giá
    UPDATE DonHang
    SET TongTien = @TongTien - @GiamGia
    WHERE MaDonHang = @MaDonHang;

    -- Đảm bảo rằng các thay đổi được commit vào cơ sở dữ liệu
    COMMIT;

    PRINT 'Đơn hàng đã được tạo thành công!';
END;
GO
-- Thực thi stored procedure để tạo đơn hàng mới
EXEC SP_TaoDonHangMoi
    @MaDonHang = 'DH001', 
    @MaKhachHang = '0901234567', 
    @NgayMua = '2023-12-15', 
    @GiamGia = 100000, 
    @ChiTietDonHang = 'SP0001,2,SP0003,1';

-- Tạo stored procedure SP_TinhTongGiaTriDonHang để tính tổng giá trị cuối cùng của đơn hàng sau khi áp dụng khuyến mãi
CREATE PROCEDURE SP_TinhTongGiaTriDonHang
    @MaDonHang CHAR(15)  -- Mã đơn hàng cần tính tổng giá trị
AS
BEGIN
    DECLARE @TongTien INT;           -- Tổng giá trị ban đầu của đơn hàng
    DECLARE @TongTienGiam INT;       -- Tổng tiền sau khi áp dụng giảm giá
    DECLARE @GiamGia INT;            -- Tổng giá trị giảm giá cho đơn hàng

    -- Tính tổng tiền đơn hàng ban đầu (không giảm giá)
    SELECT @TongTien = SUM(ChiTietDonHang.Gia * ChiTietDonHang.SoLuong)
    FROM ChiTietDonHang
    WHERE ChiTietDonHang.MaDonHang = @MaDonHang;

    -- Lấy tổng giá trị giảm giá áp dụng cho đơn hàng
    SELECT @GiamGia = ISNULL(SUM(ChiTietDonHang.GiamGiaTheoPhieu), 0)
    FROM ChiTietDonHang
    WHERE ChiTietDonHang.MaDonHang = @MaDonHang;

    -- Tính tổng tiền sau khi áp dụng giảm giá
    SET @TongTienGiam = @TongTien - @GiamGia;

    -- Cập nhật lại tổng tiền sau giảm giá vào bảng DonHang
    UPDATE DonHang
    SET TongTien = @TongTienGiam
    WHERE MaDonHang = @MaDonHang;

    -- Đảm bảo rằng các thay đổi được commit vào cơ sở dữ liệu
    COMMIT;

    PRINT 'Tổng giá trị đơn hàng sau khi áp dụng khuyến mãi: ' + CAST(@TongTienGiam AS NVARCHAR(50)) + ' VND';
END;
GO
-- Thực thi stored procedure để tính tổng giá trị đơn hàng sau khi áp dụng khuyến mãi
EXEC SP_TinhTongGiaTriDonHang @MaDonHang = 'DH0001';

-- Tạo stored procedure SP_CapNhatTrangThaiDonHang để cập nhật trạng thái đơn hàng
CREATE PROCEDURE SP_CapNhatTrangThaiDonHang
    @MaDonHang CHAR(15),          -- Mã đơn hàng
    @TrangThai NVARCHAR(50)       -- Trạng thái mới của đơn hàng ("Đã giao", "Đang xử lý", "Đã hủy")
AS
BEGIN
    -- Kiểm tra nếu trạng thái mới là hợp lệ
    IF @TrangThai NOT IN ('Đã giao', 'Đang xử lý', 'Đã hủy')
    BEGIN
        PRINT 'Trạng thái không hợp lệ. Vui lòng chọn "Đã giao", "Đang xử lý" hoặc "Đã hủy".';
        RETURN;
    END

    -- Cập nhật trạng thái của đơn hàng
    UPDATE DonHang
    SET TrangThai = @TrangThai
    WHERE MaDonHang = @MaDonHang;

    -- Đảm bảo rằng các thay đổi được commit vào cơ sở dữ liệu
    COMMIT;

    PRINT 'Trạng thái đơn hàng đã được cập nhật thành công!';
END;
GO
-- Thực thi stored procedure để cập nhật trạng thái đơn hàng
EXEC SP_CapNhatTrangThaiDonHang 
    @MaDonHang = 'DH0001', 
    @TrangThai = 'Đã giao';

	-- Tạo stored procedure SP_KiemTraPhieuTangSinhNhat để kiểm tra và áp dụng phiếu tặng sinh nhật
CREATE PROCEDURE SP_KiemTraPhieuTangSinhNhat
    @MaKhachHang CHAR(10)  -- Mã khách hàng (Số điện thoại)
AS
BEGIN
    DECLARE @NgayHienTai DATE = GETDATE();         -- Ngày hiện tại
    DECLARE @NgaySinhNhat DATE;                    -- Ngày sinh nhật của khách hàng
    DECLARE @GiaTriQuaTang INT;                    -- Giá trị của phiếu quà tặng
    DECLARE @MaPhieu CHAR(15);                     -- Mã phiếu quà tặng
    DECLARE @ThoiGianBatDau DATE;                  -- Thời gian bắt đầu của phiếu quà tặng
    DECLARE @ThoiGianKetThuc DATE;                 -- Thời gian kết thúc của phiếu quà tặng

    -- Lấy ngày sinh nhật của khách hàng và thông tin phiếu quà tặng nếu có
    SELECT @NgaySinhNhat = NgaySinhNhat
    FROM KhachHang
    WHERE SDT = @MaKhachHang;

    -- Kiểm tra nếu ngày sinh nhật của khách hàng trùng với ngày hiện tại
    IF MONTH(@NgaySinhNhat) = MONTH(@NgayHienTai) AND DAY(@NgaySinhNhat) = DAY(@NgayHienTai)
    BEGIN
        -- Lấy phiếu quà tặng sinh nhật của khách hàng, nếu có và trong thời gian hiệu lực
        SELECT TOP 1 @MaPhieu = MaPhieu, @GiaTriQuaTang = GiaTriQuaTang, 
                     @ThoiGianBatDau = NgayBatDau, @ThoiGianKetThuc = NgayKetThuc
        FROM PhieuQuaTang
        WHERE SDTKhachHang = @MaKhachHang
          AND @NgayHienTai BETWEEN NgayBatDau AND NgayKetThuc;

        -- Kiểm tra xem phiếu quà tặng có hợp lệ hay không
        IF @MaPhieu IS NOT NULL
        BEGIN
            -- Nếu phiếu quà tặng hợp lệ, cập nhật thông tin vào bảng DonHang hoặc bảng liên quan
            -- (Giả sử cập nhật vào đơn hàng hoặc thêm vào bảng thông báo cho khách hàng)
            UPDATE DonHang
            SET GiamGiaTheoPhieu = @GiaTriQuaTang
            WHERE MaKhachHang = @MaKhachHang AND ThoiGianMua = @NgayHienTai;

            PRINT 'Phiếu quà tặng sinh nhật đã được áp dụng thành công!';
        END
        ELSE
        BEGIN
            PRINT 'Phiếu quà tặng sinh nhật không hợp lệ hoặc hết hiệu lực.';
        END
    END
    ELSE
    BEGIN
        PRINT 'Hôm nay không phải là ngày sinh nhật của khách hàng.';
    END

    -- Đảm bảo rằng các thay đổi được commit vào cơ sở dữ liệu
    COMMIT;
END;
GO
-- Thực thi stored procedure để kiểm tra và áp dụng phiếu tặng sinh nhật cho khách hàng
EXEC SP_KiemTraPhieuTangSinhNhat @MaKhachHang = '0901234567';
