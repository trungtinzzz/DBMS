--Mô tả: Kiểm tra và áp dụng khuyến mãi cho khách hàng khi mua sản phẩm, đảm bảo tính hợp lệ của khuyến mãi.
--Kiểm tra xem khách hàng có đủ điều kiện nhận khuyến mãi không (Ví dụ: khách hàng có tham gia chương trình khách hàng thân thiết, hay khuyến mãi còn hiệu lực).
--Nếu hợp lệ, áp dụng giá trị khuyến mãi vào đơn hàng.
CREATE PROCEDURE SP_KiemTraKhuyenMai
    @MaKhachHang CHAR(10),
    @MaSanPham CHAR(10)
AS
BEGIN
    -- Kiểm tra khuyến mãi áp dụng cho sản phẩm và khách hàng
    -- Ví dụ: Kiểm tra nếu khách hàng là thành viên "Kim cương", áp dụng 20% giảm giá
    DECLARE @GiamGia INT;
    SELECT @GiamGia = 
        CASE 
            WHEN KhachHang.MaLoaiKhachHang = 'KIMCUONG' THEN 20 
            ELSE 0 
        END
    FROM KhachHang
    WHERE KhachHang.SDT = @MaKhachHang;

    -- Cập nhật giá trị khuyến mãi trong đơn hàng
    IF @GiamGia > 0
    BEGIN
        PRINT 'Áp dụng ' + CAST(@GiamGia AS NVARCHAR(10)) + '% giảm giá cho sản phẩm';
    END
    ELSE
    BEGIN
        PRINT 'Không có khuyến mãi áp dụng cho sản phẩm này';
    END
END;
GO

--Mô tả: Tìm và thống kê các sản phẩm bán chạy nhất trong một khoảng thời gian xác định.
--Thống kê các sản phẩm có số lượng bán lớn nhất trong tháng/tuần.
CREATE PROCEDURE SP_TimSanPhamHot
    @StartDate DATE,   -- Ngày bắt đầu
    @EndDate DATE      -- Ngày kết thúc
AS
BEGIN
    -- Thống kê sản phẩm bán chạy nhất trong khoảng thời gian
    SELECT TOP 10 SanPham.MaSP, SanPham.TenSP, SUM(ChiTietDonHang.SoLuong) AS TongSoLuongBan
    FROM ChiTietDonHang
    JOIN SanPham ON ChiTietDonHang.MaSanPham = SanPham.MaSP
    JOIN DonHang ON ChiTietDonHang.MaDonHang = DonHang.MaDonHang
    WHERE DonHang.ThoiGianMua BETWEEN @StartDate AND @EndDate
    GROUP BY SanPham.MaSP, SanPham.TenSP
    ORDER BY TongSoLuongBan DESC;
END;
GO

--Mô tả: Cập nhật thông tin khách hàng, ví dụ như thay đổi số điện thoại, địa chỉ, hoặc loại khách hàng.
--Cập nhật thông tin khách hàng sau khi họ thực hiện thay đổi (thông tin cá nhân hoặc trạng thái thành viên).
CREATE PROCEDURE SP_CapNhatThongTinKhachHang
    @MaKhachHang CHAR(10),
    @SoDienThoaiMoi CHAR(10),
    @DiaChiMoi NVARCHAR(200),
    @MaLoaiKhachHang CHAR(10)
AS
BEGIN
    -- Cập nhật thông tin khách hàng
    UPDATE KhachHang
    SET SDT = @SoDienThoaiMoi, DiaChi = @DiaChiMoi, MaLoaiKhachHang = @MaLoaiKhachHang
    WHERE SDT = @MaKhachHang;

    PRINT 'Thông tin khách hàng đã được cập nhật thành công.';
END;
GO

--Mô tả: Tạo báo cáo doanh thu cho một tháng, bao gồm tổng doanh thu và số lượng đơn hàng.
--Tính tổng doanh thu trong tháng và số lượng đơn hàng đã xử lý.
CREATE PROCEDURE SP_TaoBaoCaoDoanhThuThang
    @Thang INT,      -- Tháng cần thống kê
    @Nam INT         -- Năm cần thống kê
AS
BEGIN
    DECLARE @TongDoanhThu INT;
    DECLARE @SoLuongDonHang INT;

    -- Tính tổng doanh thu trong tháng
    SELECT @TongDoanhThu = SUM(ChiTietDonHang.Gia * ChiTietDonHang.SoLuong)
    FROM ChiTietDonHang
    JOIN DonHang ON ChiTietDonHang.MaDonHang = DonHang.MaDonHang
    WHERE MONTH(DonHang.ThoiGianMua) = @Thang AND YEAR(DonHang.ThoiGianMua) = @Nam;

    -- Tính số lượng đơn hàng trong tháng
    SELECT @SoLuongDonHang = COUNT(DISTINCT DonHang.MaDonHang)
    FROM DonHang
    WHERE MONTH(DonHang.ThoiGianMua) = @Thang AND YEAR(DonHang.ThoiGianMua) = @Nam;

    PRINT 'Tổng doanh thu trong tháng ' + CAST(@Thang AS NVARCHAR(2)) + '/' + CAST(@Nam AS NVARCHAR(4)) + ': ' + CAST(@TongDoanhThu AS NVARCHAR(50)) + ' VND';
    PRINT 'Số lượng đơn hàng trong tháng: ' + CAST(@SoLuongDonHang AS NVARCHAR(50));
END;
GO



