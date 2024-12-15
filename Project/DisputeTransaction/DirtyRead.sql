CREATE PROCEDURE SP_ApDungKMchoKH
    @MaKhachHang CHAR(10),          -- Mã khách hàng
    @MaKhuyenMai CHAR(15),          -- Mã khuyến mãi
    @GiaTriGiamGia INT              -- Giá trị giảm giá
AS
BEGIN
    -- Áp dụng giảm giá cho khách hàng, chưa commit
    UPDATE KhachHang
    SET GiaTriGiamGia = @GiaTriGiamGia
    WHERE MaKhachHang = @MaKhachHang;

    PRINT 'Giảm giá đã được áp dụng cho khách hàng (Chưa commit)';
END;
GO
CREATE PROCEDURE SP_TaoDonHangMoi
    @MaDonHang CHAR(15),           -- Mã đơn hàng
    @MaKhachHang CHAR(10),         -- Mã khách hàng
    @ThoiGianMua DATETIME          -- Thời gian mua
AS
BEGIN
    -- Đọc thông tin giảm giá cho khách hàng chưa commit
    DECLARE @GiaTriGiamGia INT;

    -- Lấy thông tin giảm giá của khách hàng
    SELECT @GiaTriGiamGia = GiaTriGiamGia
    FROM KhachHang
    WHERE MaKhachHang = @MaKhachHang;

    -- Tạo đơn hàng mới (có thể sử dụng giảm giá chưa commit)
    INSERT INTO DonHang (MaDonHang, MaKhachHang, ThoiGianMua, GiaTriGiamGia)
    VALUES (@MaDonHang, @MaKhachHang, @ThoiGianMua, @GiaTriGiamGia);

    PRINT 'Đơn hàng đã được tạo với giảm giá (Có thể sử dụng giá trị không chính xác)';
END;
GO

CREATE PROCEDURE SP_ApDungKMchoKH
    @MaKhachHang CHAR(10),          -- Mã khách hàng
    @MaKhuyenMai CHAR(15),          -- Mã khuyến mãi
    @GiaTriGiamGia INT              -- Giá trị giảm giá
AS
BEGIN
    BEGIN TRANSACTION;  -- Bắt đầu transaction

    -- Áp dụng giảm giá cho khách hàng
    UPDATE KhachHang
    SET GiaTriGiamGia = @GiaTriGiamGia
    WHERE MaKhachHang = @MaKhachHang;

    COMMIT;  -- Commit transaction để dữ liệu có hiệu lực
    PRINT 'Giảm giá đã được áp dụng cho khách hàng và đã commit';
END;
GO
CREATE PROCEDURE SP_TaoDonHangMoi
    @MaDonHang CHAR(15),           -- Mã đơn hàng
    @MaKhachHang CHAR(10),         -- Mã khách hàng
    @ThoiGianMua DATETIME          -- Thời gian mua
AS
BEGIN
    -- Đảm bảo chỉ đọc dữ liệu đã được commit
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;  -- Chỉ đọc dữ liệu đã commit

    BEGIN TRANSACTION;  -- Bắt đầu transaction

    -- Đọc thông tin giảm giá cho khách hàng đã được commit
    DECLARE @GiaTriGiamGia INT;

    -- Lấy thông tin giảm giá của khách hàng
    SELECT @GiaTriGiamGia = GiaTriGiamGia
    FROM KhachHang
    WHERE MaKhachHang = @MaKhachHang;

    -- Tạo đơn hàng mới với giảm giá đã commit
    INSERT INTO DonHang (MaDonHang, MaKhachHang, ThoiGianMua, GiaTriGiamGia)
    VALUES (@MaDonHang, @MaKhachHang, @ThoiGianMua, @GiaTriGiamGia);

    COMMIT;  -- Xác nhận transaction
    PRINT 'Đơn hàng đã được tạo với giảm giá đã commit';
END;
GO

EXEC SP_ApDungKMchoKH 
    @MaKhachHang = 'KH0001', 
    @MaKhuyenMai = 'KM001', 
    @GiaTriGiamGia = 15;  -- 15% giảm giá
EXEC SP_TaoDonHangMoi 
    @MaDonHang = 'DH0001', 
    @MaKhachHang = 'KH0001', 
    @ThoiGianMua = '2024-12-15 10:00:00';
