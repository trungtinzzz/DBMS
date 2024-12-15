-- Tạo stored procedure SP_DailySalesReport để tính tổng doanh thu và số lượng khách hàng mua trong ngày
CREATE PROCEDURE SP_DailySalesReport
    @Ngay DATE  -- Ngày cần thống kê doanh thu
AS
BEGIN
    DECLARE @TongDoanhThu INT;           -- Tổng doanh thu trong ngày
    DECLARE @SoLuongKhachHang INT;       -- Số lượng khách hàng trong ngày

    -- Tính tổng doanh thu trong ngày
    SELECT @TongDoanhThu = SUM(ChiTietDonHang.Gia * ChiTietDonHang.SoLuong)
    FROM ChiTietDonHang
    JOIN DonHang ON ChiTietDonHang.MaDonHang = DonHang.MaDonHang
    WHERE CAST(DonHang.ThoiGianMua AS DATE) = @Ngay;

    -- Tính số lượng khách hàng trong ngày
    SELECT @SoLuongKhachHang = COUNT(DISTINCT DonHang.MaKhachHang)
    FROM DonHang
    WHERE CAST(DonHang.ThoiGianMua AS DATE) = @Ngay;

    -- In ra kết quả tổng doanh thu và số lượng khách hàng
    PRINT 'Tổng doanh thu trong ngày ' + CAST(@Ngay AS NVARCHAR(10)) + ': ' + CAST(@TongDoanhThu AS NVARCHAR(50)) + ' VND';
    PRINT 'Số lượng khách hàng trong ngày ' + CAST(@Ngay AS NVARCHAR(10)) + ': ' + CAST(@SoLuongKhachHang AS NVARCHAR(50));

    -- Đảm bảo rằng các thay đổi được commit vào cơ sở dữ liệu
    COMMIT;
END;
GO
-- Thực thi stored procedure để thống kê doanh thu và số lượng khách hàng trong ngày
EXEC SP_DailySalesReport @Ngay = '2023-12-15';

-- Tạo stored procedure SP_ProductSalesStats để thống kê số lượng sản phẩm bán ra và số lượng khách hàng mua theo mặt hàng
CREATE PROCEDURE SP_ProductSalesStats
    @Ngay DATE  -- Ngày cần thống kê
AS
BEGIN
    -- Biến để lưu trữ thông tin thống kê
    DECLARE @MaSP CHAR(10);                -- Mã sản phẩm
    DECLARE @TenSP NVARCHAR(100);          -- Tên sản phẩm
    DECLARE @SoLuongBanRa INT;             -- Số lượng sản phẩm bán ra
    DECLARE @SoLuongKhachHang INT;         -- Số lượng khách hàng mua sản phẩm
    DECLARE @ThongBao NVARCHAR(200);       -- Thông báo cho từng sản phẩm

    -- Truy vấn thông tin thống kê cho các sản phẩm bán ra trong ngày
    DECLARE product_cursor CURSOR FOR
        SELECT DISTINCT ChiTietDonHang.MaSanPham, SanPham.TenSP
        FROM ChiTietDonHang
        JOIN DonHang ON ChiTietDonHang.MaDonHang = DonHang.MaDonHang
        JOIN SanPham ON ChiTietDonHang.MaSanPham = SanPham.MaSP
        WHERE CAST(DonHang.ThoiGianMua AS DATE) = @Ngay;

    OPEN product_cursor;
    FETCH NEXT FROM product_cursor INTO @MaSP, @TenSP;

    -- Lặp qua từng sản phẩm để thống kê số lượng bán ra và số lượng khách hàng
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Tính số lượng sản phẩm bán ra
        SELECT @SoLuongBanRa = SUM(ChiTietDonHang.SoLuong)
        FROM ChiTietDonHang
        JOIN DonHang ON ChiTietDonHang.MaDonHang = DonHang.MaDonHang
        WHERE CAST(DonHang.ThoiGianMua AS DATE) = @Ngay
          AND ChiTietDonHang.MaSanPham = @MaSP;

        -- Tính số lượng khách hàng mua sản phẩm
        SELECT @SoLuongKhachHang = COUNT(DISTINCT DonHang.MaKhachHang)
        FROM ChiTietDonHang
        JOIN DonHang ON ChiTietDonHang.MaDonHang = DonHang.MaDonHang
        WHERE CAST(DonHang.ThoiGianMua AS DATE) = @Ngay
          AND ChiTietDonHang.MaSanPham = @MaSP;

        -- In thông báo về sản phẩm
        SET @ThongBao = 'Sản phẩm: ' + @TenSP + ' - Số lượng bán ra: ' + CAST(@SoLuongBanRa AS NVARCHAR(50)) + 
                        ', Số lượng khách hàng mua: ' + CAST(@SoLuongKhachHang AS NVARCHAR(50));
        PRINT @ThongBao;

        FETCH NEXT FROM product_cursor INTO @MaSP, @TenSP;
    END

    -- Đóng và giải phóng con trỏ
    CLOSE product_cursor;
    DEALLOCATE product_cursor;

    -- Đảm bảo rằng các thay đổi được commit vào cơ sở dữ liệu
    COMMIT;
END;
GO
-- Thực thi stored procedure để thống kê số lượng sản phẩm bán ra và số lượng khách hàng mua theo mặt hàng
EXEC SP_ProductSalesStats @Ngay = '2023-12-15';
