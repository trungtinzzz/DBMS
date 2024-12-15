-- Tạo stored procedure SP_ThemSanPhamMoi để thêm sản phẩm mới vào kho
CREATE PROCEDURE SP_ThemSanPhamMoi
    @MaSP CHAR(10),               -- Mã sản phẩm
    @TenSP NVARCHAR(100),         -- Tên sản phẩm
    @GiaSP INT,                   -- Giá sản phẩm
    @MoTa NVARCHAR(200),          -- Mô tả sản phẩm
    @PhanLoai NVARCHAR(50),       -- Phân loại sản phẩm
    @NhaSanXuat NVARCHAR(50),     -- Nhà sản xuất
    @SoLuongConLai INT,           -- Số lượng tồn kho hiện tại
    @SoLuongToiDa INT             -- Số lượng tối đa có thể lưu trữ trong kho
AS
BEGIN
    -- Kiểm tra nếu sản phẩm đã tồn tại trong hệ thống
    IF EXISTS (SELECT 1 FROM SanPham WHERE MaSP = @MaSP)
    BEGIN
        PRINT 'Sản phẩm đã tồn tại trong kho!';
        RETURN; -- Nếu sản phẩm đã tồn tại, không thêm mới
    END

    -- Thêm sản phẩm mới vào kho
    INSERT INTO SanPham (MaSP, TenSP, GiaSP, MoTa, PhanLoai, NhaSanXuat, SoLuongConLai, SoLuongToiDa)
    VALUES (@MaSP, @TenSP, @GiaSP, @MoTa, @PhanLoai, @NhaSanXuat, @SoLuongConLai, @SoLuongToiDa);

    -- Đảm bảo rằng các thay đổi được commit vào cơ sở dữ liệu
    COMMIT;

    PRINT 'Sản phẩm đã được thêm vào kho thành công!';
END;
GO
-- Thực thi stored procedure để thêm sản phẩm mới vào kho
EXEC SP_ThemSanPhamMoi 
    @MaSP = 'SP0051', 
    @TenSP = N'Giày thể thao nữ', 
    @GiaSP = 700000, 
    @MoTa = N'Giày thể thao nữ, thiết kế thời trang, phù hợp cho các hoạt động thể thao.', 
    @PhanLoai = N'Quần áo', 
    @NhaSanXuat = N'Adidas', 
    @SoLuongConLai = 150, 
    @SoLuongToiDa = 300;

-- Tạo stored procedure SP_CapNhatTonKho để cập nhật số lượng tồn kho khi nhập hoặc xuất kho sản phẩm
CREATE PROCEDURE SP_CapNhatTonKho
    @MaSP CHAR(10),               -- Mã sản phẩm
    @SoLuong INT,                 -- Số lượng thay đổi (có thể là âm hoặc dương)
    @LoaiGiaoDich NVARCHAR(50)    -- Loại giao dịch (Nhập kho hoặc Xuất kho)
AS
BEGIN
    DECLARE @SoLuongConLai INT;  -- Số lượng tồn kho hiện tại

    -- Lấy số lượng tồn kho hiện tại của sản phẩm
    SELECT @SoLuongConLai = SoLuongConLai
    FROM SanPham
    WHERE MaSP = @MaSP;

    -- Kiểm tra nếu sản phẩm không tồn tại trong kho
    IF @SoLuongConLai IS NULL
    BEGIN
        PRINT 'Sản phẩm không tồn tại trong kho!';
        RETURN; -- Nếu sản phẩm không tồn tại, dừng procedure
    END

    -- Cập nhật số lượng tồn kho dựa trên loại giao dịch
    IF @LoaiGiaoDich = 'Nhap kho'
    BEGIN
        -- Nếu là nhập kho, cộng thêm số lượng vào tồn kho hiện tại
        UPDATE SanPham
        SET SoLuongConLai = @SoLuongConLai + @SoLuong
        WHERE MaSP = @MaSP;

        PRINT 'Đã cập nhật số lượng tồn kho sau khi nhập kho.';
    END
    ELSE IF @LoaiGiaoDich = 'Xuat kho'
    BEGIN
        -- Nếu là xuất kho, kiểm tra nếu số lượng xuất không vượt quá số lượng tồn kho
        IF @SoLuongConLai < @SoLuong
        BEGIN
            PRINT 'Số lượng xuất kho vượt quá số lượng tồn kho!';
            RETURN; -- Dừng procedure nếu số lượng xuất kho không hợp lệ
        END

        -- Cập nhật số lượng tồn kho sau khi xuất kho
        UPDATE SanPham
        SET SoLuongConLai = @SoLuongConLai - @SoLuong
        WHERE MaSP = @MaSP;

        PRINT 'Đã cập nhật số lượng tồn kho sau khi xuất kho.';
    END
    ELSE
    BEGIN
        PRINT 'Loại giao dịch không hợp lệ. Vui lòng chọn "Nhap kho" hoặc "Xuat kho".';
    END

    -- Đảm bảo rằng các thay đổi được commit vào cơ sở dữ liệu
    COMMIT;
END;
GO
-- Thực thi stored procedure để nhập sản phẩm vào kho
EXEC SP_CapNhatTonKho 
    @MaSP = 'SP0001', 
    @SoLuong = 50, 
    @LoaiGiaoDich = 'Nhap kho';
-- Thực thi stored procedure để xuất sản phẩm khỏi kho
EXEC SP_CapNhatTonKho 
    @MaSP = 'SP0001', 
    @SoLuong = 20, 
    @LoaiGiaoDich = 'Xuat kho';

	-- Tạo stored procedure SP_KiemTraTonKho để kiểm tra số lượng tồn kho và quyết định cần đặt hàng bổ sung
CREATE PROCEDURE SP_KiemTraTonKho
    @MaSP CHAR(10)        -- Mã sản phẩm cần kiểm tra tồn kho
AS
BEGIN
    DECLARE @SoLuongConLai INT;      -- Số lượng tồn kho hiện tại
    DECLARE @SoLuongToiDa INT;       -- Số lượng tối đa có thể lưu trữ trong kho
    DECLARE @ThongBao NVARCHAR(200); -- Thông báo về tình trạng tồn kho

    -- Lấy số lượng tồn kho hiện tại và số lượng tối đa có thể lưu trữ của sản phẩm
    SELECT @SoLuongConLai = SoLuongConLai, @SoLuongToiDa = SoLuongToiDa
    FROM SanPham
    WHERE MaSP = @MaSP;

    -- Kiểm tra nếu sản phẩm không tồn tại trong kho
    IF @SoLuongConLai IS NULL
    BEGIN
        PRINT 'Sản phẩm không tồn tại trong kho!';
        RETURN; -- Dừng procedure nếu sản phẩm không tồn tại
    END

    -- Kiểm tra tình trạng tồn kho và quyết định có cần đặt hàng bổ sung hay không
    IF @SoLuongConLai < (@SoLuongToiDa * 0.2) -- Nếu tồn kho hiện tại nhỏ hơn 20% số lượng tối đa
    BEGIN
        SET @ThongBao = 'Sản phẩm cần đặt hàng bổ sung.';
        PRINT @ThongBao;
    END
    ELSE
    BEGIN
        SET @ThongBao = 'Tồn kho sản phẩm đủ, không cần đặt hàng bổ sung.';
        PRINT @ThongBao;
    END

    -- Đảm bảo rằng các thay đổi được commit vào cơ sở dữ liệu
    COMMIT;
END;
GO
-- Thực thi stored procedure để kiểm tra số lượng tồn kho và quyết định có cần đặt hàng bổ sung
EXEC SP_KiemTraTonKho @MaSP = 'SP0001';

-- Tạo stored procedure SP_DatHangNhaSanXuat để đặt hàng từ nhà sản xuất
CREATE PROCEDURE SP_DatHangNhaSanXuat
    @MaSP CHAR(10),               -- Mã sản phẩm cần đặt hàng
    @SoLuongYeuCau INT            -- Số lượng yêu cầu cần đặt hàng từ nhà sản xuất
AS
BEGIN
    DECLARE @SoLuongConLai INT;       -- Số lượng tồn kho hiện tại
    DECLARE @SoLuongToiDa INT;        -- Số lượng tối đa có thể lưu trữ trong kho
    DECLARE @SoLuongCanDat INT;       -- Số lượng cần đặt thêm
    DECLARE @MaDonDat CHAR(15);       -- Mã đơn đặt hàng
    DECLARE @MaNhaSanXuat CHAR(10);   -- Mã nhà sản xuất

    -- Lấy số lượng tồn kho và số lượng tối đa có thể lưu trữ của sản phẩm
    SELECT @SoLuongConLai = SoLuongConLai, @SoLuongToiDa = SoLuongToiDa, @MaNhaSanXuat = NhaSanXuat
    FROM SanPham
    WHERE MaSP = @MaSP;

    -- Kiểm tra nếu sản phẩm không tồn tại trong kho
    IF @SoLuongConLai IS NULL
    BEGIN
        PRINT 'Sản phẩm không tồn tại trong kho!';
        RETURN; -- Dừng procedure nếu sản phẩm không tồn tại
    END

    -- Kiểm tra xem số lượng tồn kho có dưới ngưỡng yêu cầu hay không
    IF @SoLuongConLai < @SoLuongYeuCau
    BEGIN
        -- Tính số lượng cần đặt thêm
        SET @SoLuongCanDat = @SoLuongYeuCau - @SoLuongConLai;

        -- Tạo mã đơn đặt hàng mới
        SET @MaDonDat = 'DDK' + CAST(DATEPART(YEAR, GETDATE()) AS VARCHAR(4)) + RIGHT('0000' + CAST(NEWID() AS VARCHAR(50)), 4);

        -- Thêm đơn đặt hàng vào bảng DonDatKho
        INSERT INTO DonDatKho (MaDonDat, TrangThaiGiao, SoLuongDaNhan, SoLuongDat, GiaTriDat, NgayDat, MaSanPham)
        VALUES (@MaDonDat, N'Chưa giao', 0, @SoLuongCanDat, @SoLuongCanDat * (SELECT GiaSP FROM SanPham WHERE MaSP = @MaSP), GETDATE(), @MaSP);

        PRINT 'Đã tạo đơn đặt hàng mới cho sản phẩm. Mã đơn đặt hàng: ' + @MaDonDat;
    END
    ELSE
    BEGIN
        PRINT 'Sản phẩm không cần đặt hàng bổ sung. Tồn kho hiện tại đủ đáp ứng yêu cầu.';
    END

    -- Đảm bảo rằng các thay đổi được commit vào cơ sở dữ liệu
    COMMIT;
END;
GO
-- Thực thi stored procedure để đặt hàng từ nhà sản xuất cho sản phẩm có số lượng dưới ngưỡng yêu cầu
EXEC SP_DatHangNhaSanXuat 
    @MaSP = 'SP0001', 
    @SoLuongYeuCau = 100;

	-- Tạo stored procedure SP_CapNhatDonHang để cập nhật trạng thái đơn đặt hàng và số lượng nhận được
CREATE PROCEDURE SP_CapNhatDonHang
    @MaDonDat CHAR(15),            -- Mã đơn đặt hàng
    @SoLuongNhan INT,              -- Số lượng nhận được
    @TrangThaiGiao NVARCHAR(50),   -- Trạng thái giao hàng (VD: "Đang giao", "Hoàn thành", "Chưa giao")
    @SoLuongConLai INT             -- Số lượng còn thiếu (nếu có)
AS
BEGIN
    DECLARE @SoLuongDat INT;      -- Số lượng đặt trong đơn hàng
    DECLARE @SoLuongDaNhan INT;   -- Số lượng đã nhận được từ nhà cung cấp
    DECLARE @TrangThaiDonDat NVARCHAR(50);  -- Trạng thái hiện tại của đơn đặt hàng

    -- Lấy thông tin số lượng đặt và số lượng đã nhận từ bảng DonDatKho
    SELECT @SoLuongDat = SoLuongDat, 
           @SoLuongDaNhan = SoLuongDaNhan, 
           @TrangThaiDonDat = TrangThaiGiao
    FROM DonDatKho
    WHERE MaDonDat = @MaDonDat;

    -- Kiểm tra nếu đơn đặt hàng không tồn tại
    IF @SoLuongDat IS NULL
    BEGIN
        PRINT 'Đơn đặt hàng không tồn tại!';
        RETURN; -- Dừng procedure nếu đơn đặt hàng không tồn tại
    END

    -- Cập nhật số lượng đã nhận được trong đơn đặt hàng
    UPDATE DonDatKho
    SET SoLuongDaNhan = @SoLuongDaNhan + @SoLuongNhan, 
        SoLuongConLai = @SoLuongDat - (@SoLuongDaNhan + @SoLuongNhan)
    WHERE MaDonDat = @MaDonDat;

    -- Cập nhật trạng thái giao hàng dựa vào số lượng nhận được
    IF @SoLuongConLai <= 0
    BEGIN
        -- Nếu đã nhận đủ số lượng hoặc thừa, cập nhật trạng thái là "Hoàn thành"
        UPDATE DonDatKho
        SET TrangThaiGiao = 'Hoàn thành'
        WHERE MaDonDat = @MaDonDat;
    END
    ELSE
    BEGIN
        -- Nếu còn thiếu số lượng, cập nhật trạng thái là "Đang giao"
        UPDATE DonDatKho
        SET TrangThaiGiao = 'Đang giao'
        WHERE MaDonDat = @MaDonDat;
    END

    -- Cập nhật trạng thái giao hàng cho bảng DonDatKho
    UPDATE DonDatKho
    SET TrangThaiGiao = @TrangThaiGiao
    WHERE MaDonDat = @MaDonDat;

    -- Đảm bảo rằng các thay đổi được commit vào cơ sở dữ liệu
    COMMIT;

    PRINT 'Đơn đặt hàng đã được cập nhật thành công!';
END;
GO
-- Thực thi stored procedure để cập nhật đơn đặt hàng
EXEC SP_CapNhatDonHang 
    @MaDonDat = 'DDK0001', 
    @SoLuongNhan = 50, 
    @TrangThaiGiao = 'Đang giao',
    @SoLuongConLai = 0;

	-- Tạo stored procedure SP_ThongKeHangTonKho để thống kê số lượng hàng hóa hiện có trong kho
-- và tính toán số lượng cần đặt nếu có thiếu hụt
CREATE PROCEDURE SP_ThongKeHangTonKho
AS
BEGIN
    -- Biến để lưu trữ thông tin
    DECLARE @MaSP CHAR(10);             -- Mã sản phẩm
    DECLARE @TenSP NVARCHAR(100);       -- Tên sản phẩm
    DECLARE @SoLuongConLai INT;         -- Số lượng tồn kho hiện tại
    DECLARE @SoLuongToiDa INT;          -- Số lượng tối đa có thể lưu trữ
    DECLARE @SoLuongCanDat INT;         -- Số lượng cần đặt thêm nếu thiếu hụt
    DECLARE @ThongBao NVARCHAR(200);    -- Thông báo tình trạng sản phẩm

    -- Truy vấn thông tin các sản phẩm và số lượng tồn kho
    DECLARE product_cursor CURSOR FOR
        SELECT MaSP, TenSP, SoLuongConLai, SoLuongToiDa
        FROM SanPham;

    OPEN product_cursor;
    FETCH NEXT FROM product_cursor INTO @MaSP, @TenSP, @SoLuongConLai, @SoLuongToiDa;

    -- Lặp qua các sản phẩm để kiểm tra tình trạng tồn kho
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Kiểm tra xem có cần đặt hàng bổ sung hay không
        IF @SoLuongConLai < (@SoLuongToiDa * 0.2) -- Nếu tồn kho hiện tại nhỏ hơn 20% số lượng tối đa
        BEGIN
            -- Tính số lượng cần đặt thêm
            SET @SoLuongCanDat = @SoLuongToiDa - @SoLuongConLai;
            SET @ThongBao = 'Cần đặt thêm ' + CAST(@SoLuongCanDat AS NVARCHAR(50)) + ' sản phẩm ' + @TenSP;
            PRINT @ThongBao;  -- In thông báo cần đặt hàng bổ sung
        END
        ELSE
        BEGIN
            -- Nếu không cần đặt thêm, in thông báo tồn kho đủ
            SET @ThongBao = 'Tồn kho đủ cho sản phẩm ' + @TenSP;
            PRINT @ThongBao;  -- In thông báo đủ tồn kho
        END

        FETCH NEXT FROM product_cursor INTO @MaSP, @TenSP, @SoLuongConLai, @SoLuongToiDa;
    END

    -- Đóng và giải phóng con trỏ
    CLOSE product_cursor;
    DEALLOCATE product_cursor;

    -- Đảm bảo rằng các thay đổi được commit vào cơ sở dữ liệu
    COMMIT;
END;
GO
-- Thực thi stored procedure để thống kê số lượng hàng hóa hiện có trong kho và tính toán số lượng cần đặt nếu thiếu hụt
EXEC SP_ThongKeHangTonKho;
