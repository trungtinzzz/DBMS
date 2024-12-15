--TH1
CREATE PROCEDURE SP_CapNhatPhanHangKH
    @MaKhachHang CHAR(10),          -- Mã khách hàng
    @TieuChiChiTieu INT             -- Tổng chi tiêu của khách hàng
AS
BEGIN
    -- Đọc và cập nhật phân hạng khách hàng mà không sử dụng khóa, có thể xảy ra Unrepeatable Read
    SELECT MaKhachHang, MaLoaiKhachHang, TieuChiChiTieu
    FROM KhachHang
    WHERE MaKhachHang = @MaKhachHang;

    -- Cập nhật phân hạng khách hàng
    IF @TieuChiChiTieu >= 1000000
    BEGIN
        UPDATE KhachHang
        SET MaLoaiKhachHang = 'Vàng'
        WHERE MaKhachHang = @MaKhachHang;
    END

    PRINT 'Phân hạng khách hàng đã được cập nhật';
END;
GO
CREATE PROCEDURE SP_TaoVoucherSN
    @MaKhachHang CHAR(10)          -- Mã khách hàng
AS
BEGIN
    -- Thay đổi thông tin khách hàng khi tạo voucher sinh nhật mà không sử dụng khóa
    UPDATE KhachHang
    SET TieuChiChiTieu = TieuChiChiTieu + 500000  -- Thêm vào số tiền chi tiêu khách hàng cho voucher
    WHERE MaKhachHang = @MaKhachHang;

    PRINT 'Voucher sinh nhật đã được tạo và thông tin khách hàng đã được cập nhật';
END;
GO

CREATE PROCEDURE SP_CapNhatPhanHangKH
    @MaKhachHang CHAR(10),          -- Mã khách hàng
    @TieuChiChiTieu INT             -- Tổng chi tiêu của khách hàng
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;  -- Đảm bảo dữ liệu không bị thay đổi khi đọc lại

    BEGIN TRANSACTION;  -- Bắt đầu transaction

    -- Đọc dữ liệu khách hàng với Share Lock (khóa đọc, tránh thay đổi trong khi đọc)
    SELECT MaKhachHang, MaLoaiKhachHang, TieuChiChiTieu
    FROM KhachHang WITH (HOLDLOCK, ROWLOCK)
    WHERE MaKhachHang = @MaKhachHang;

    -- Cập nhật phân hạng khách hàng
    IF @TieuChiChiTieu >= 1000000
    BEGIN
        UPDATE KhachHang
        SET MaLoaiKhachHang = 'Vàng'
        WHERE MaKhachHang = @MaKhachHang;
    END

    COMMIT;  -- Xác nhận transaction
    PRINT 'Phân hạng khách hàng đã được cập nhật';
END;
GO
CREATE PROCEDURE SP_TaoVoucherSN
    @MaKhachHang CHAR(10)          -- Mã khách hàng
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;  -- Đảm bảo dữ liệu không bị thay đổi khi đọc lại

    BEGIN TRANSACTION;  -- Bắt đầu transaction

    -- Thay đổi thông tin khách hàng khi tạo voucher sinh nhật
    UPDATE KhachHang WITH (XLOCK)
    SET TieuChiChiTieu = TieuChiChiTieu + 500000  -- Thêm vào số tiền chi tiêu khách hàng cho voucher
    WHERE MaKhachHang = @MaKhachHang;

    COMMIT;  -- Xác nhận transaction
    PRINT 'Voucher sinh nhật đã được tạo và thông tin khách hàng đã được cập nhật';
END;
GO

EXEC SP_CapNhatPhanHangKH 
    @MaKhachHang = 'KH0001', 
    @TieuChiChiTieu = 1200000;  -- Tổng chi tiêu của khách hàng
EXEC SP_TaoVoucherSN 
    @MaKhachHang = 'KH0001';  -- Mã khách hàng


--TH2
CREATE PROCEDURE SP_QuanLyKM
    @MaKhuyenMai CHAR(15),          -- Mã khuyến mãi
    @GiaTriGiamGia INT,              -- Giá trị giảm giá mới
    @ThoiGianBatDau DATE,            -- Thời gian bắt đầu khuyến mãi
    @ThoiGianKetThuc DATE            -- Thời gian kết thúc khuyến mãi
AS
BEGIN
    -- Thay đổi thông tin khuyến mãi mà không sử dụng khóa, có thể xảy ra Unrepeatable Read
    UPDATE KhuyenMai
    SET GiaTriGiamGia = @GiaTriGiamGia,
        ThoiGianBatDau = @ThoiGianBatDau,
        ThoiGianKetThuc = @ThoiGianKetThuc
    WHERE MaKhuyenMai = @MaKhuyenMai;

    PRINT 'Khuyến mãi đã được cập nhật';
END;
GO
CREATE PROCEDURE SP_ApDungKM
    @MaKhuyenMai CHAR(15),          -- Mã khuyến mãi
    @MaSP CHAR(10)                  -- Mã sản phẩm
AS
BEGIN
    -- Áp dụng khuyến mãi cho sản phẩm mà không sử dụng khóa, có thể xảy ra Unrepeatable Read
    DECLARE @GiaTriGiamGia INT;

    -- Lấy thông tin giảm giá của khuyến mãi
    SELECT @GiaTriGiamGia = GiaTriGiamGia
    FROM KhuyenMai
    WHERE MaKhuyenMai = @MaKhuyenMai;

    -- Áp dụng giảm giá cho sản phẩm
    UPDATE SanPham
    SET GiaSP = GiaSP - (@GiaTriGiamGia * GiaSP / 100)
    WHERE MaSP = @MaSP;

    PRINT 'Khuyến mãi đã được áp dụng cho sản phẩm';
END;
GO

CREATE PROCEDURE SP_QuanLyKM
    @MaKhuyenMai CHAR(15),          -- Mã khuyến mãi
    @GiaTriGiamGia INT,              -- Giá trị giảm giá mới
    @ThoiGianBatDau DATE,            -- Thời gian bắt đầu khuyến mãi
    @ThoiGianKetThuc DATE            -- Thời gian kết thúc khuyến mãi
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;  -- Đảm bảo không có thay đổi trong khi đọc

    BEGIN TRANSACTION;  -- Bắt đầu transaction

    -- Thay đổi thông tin khuyến mãi với khóa
    UPDATE KhuyenMai WITH (XLOCK)
    SET GiaTriGiamGia = @GiaTriGiamGia,
        ThoiGianBatDau = @ThoiGianBatDau,
        ThoiGianKetThuc = @ThoiGianKetThuc
    WHERE MaKhuyenMai = @MaKhuyenMai;

    COMMIT;  -- Xác nhận transaction
    PRINT 'Khuyến mãi đã được cập nhật và đã commit';
END;
GO
CREATE PROCEDURE SP_ApDungKM
    @MaKhuyenMai CHAR(15),          -- Mã khuyến mãi
    @MaSP CHAR(10)                  -- Mã sản phẩm
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;  -- Đảm bảo không có thay đổi trong khi đọc

    BEGIN TRANSACTION;  -- Bắt đầu transaction

    -- Đọc thông tin giảm giá của khuyến mãi với Share Lock để tránh thay đổi
    DECLARE @GiaTriGiamGia INT;
    
    SELECT @GiaTriGiamGia = GiaTriGiamGia
    FROM KhuyenMai WITH (HOLDLOCK)
    WHERE MaKhuyenMai = @MaKhuyenMai;

    -- Áp dụng khuyến mãi cho sản phẩm
    UPDATE SanPham
    SET GiaSP = GiaSP - (@GiaTriGiamGia * GiaSP / 100)
    WHERE MaSP = @MaSP;

    COMMIT;  -- Xác nhận transaction
    PRINT 'Khuyến mãi đã được áp dụng cho sản phẩm và đã commit';
END;
GO

EXEC SP_QuanLyKM 
    @MaKhuyenMai = 'KM001', 
    @GiaTriGiamGia = 15, 
    @ThoiGianBatDau = '2024-01-01', 
    @ThoiGianKetThuc = '2024-12-31';
EXEC SP_ApDungKM 
    @MaKhuyenMai = 'KM001', 
    @MaSP = 'SP0001';


--TH3
CREATE PROCEDURE SP_CapNhatTonKho
    @MaSP CHAR(10),               -- Mã sản phẩm
    @SoLuong INT                  -- Số lượng thay đổi (có thể là âm hoặc dương)
AS
BEGIN
    -- Đọc và cập nhật số lượng tồn kho mà không sử dụng khóa, có thể xảy ra Unrepeatable Read
    SELECT SoLuongConLai
    FROM SanPham
    WHERE MaSP = @MaSP;

    -- Cập nhật số lượng tồn kho sau khi đã đọc
    UPDATE SanPham
    SET SoLuongConLai = SoLuongConLai + @SoLuong
    WHERE MaSP = @MaSP;

    PRINT 'Số lượng tồn kho đã được cập nhật';
END;
GO
CREATE PROCEDURE SP_DatHangNhaSanXuat
    @MaSP CHAR(10),               -- Mã sản phẩm
    @SoLuongYeuCau INT            -- Số lượng yêu cầu cần đặt hàng từ nhà sản xuất
AS
BEGIN
    -- Đặt hàng từ nhà sản xuất và thay đổi số lượng tồn kho mà không sử dụng khóa, có thể xảy ra Unrepeatable Read
    UPDATE SanPham
    SET SoLuongConLai = SoLuongConLai + @SoLuongYeuCau
    WHERE MaSP = @MaSP;

    PRINT 'Sản phẩm đã được đặt hàng từ nhà sản xuất';
END;
GO

CREATE PROCEDURE SP_CapNhatTonKho
    @MaSP CHAR(10),               -- Mã sản phẩm
    @SoLuong INT                  -- Số lượng thay đổi (có thể là âm hoặc dương)
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;  -- Đảm bảo không có thay đổi khi đọc lại

    BEGIN TRANSACTION;  -- Bắt đầu transaction

    -- Đọc số lượng tồn kho của sản phẩm với Share Lock (khóa đọc, tránh thay đổi trong khi đọc)
    SELECT SoLuongConLai
    FROM SanPham WITH (HOLDLOCK, ROWLOCK)
    WHERE MaSP = @MaSP;

    -- Cập nhật số lượng tồn kho
    UPDATE SanPham
    SET SoLuongConLai = SoLuongConLai + @SoLuong
    WHERE MaSP = @MaSP;

    COMMIT;  -- Xác nhận transaction
    PRINT 'Số lượng tồn kho đã được cập nhật';
END;
GO
CREATE PROCEDURE SP_DatHangNhaSanXuat
    @MaSP CHAR(10),               -- Mã sản phẩm
    @SoLuongYeuCau INT            -- Số lượng yêu cầu cần đặt hàng từ nhà sản xuất
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;  -- Đảm bảo không có thay đổi khi đọc lại

    BEGIN TRANSACTION;  -- Bắt đầu transaction

    -- Đặt hàng từ nhà sản xuất và thay đổi số lượng tồn kho
    UPDATE SanPham WITH (XLOCK, ROWLOCK)
    SET SoLuongConLai = SoLuongConLai + @SoLuongYeuCau
    WHERE MaSP = @MaSP;

    COMMIT;  -- Xác nhận transaction
    PRINT 'Sản phẩm đã được đặt hàng từ nhà sản xuất';
END;
GO

EXEC SP_CapNhatTonKho 
    @MaSP = 'SP0001', 
    @SoLuong = 50;  -- Thay đổi số lượng tồn kho (có thể là âm hoặc dương)
EXEC SP_DatHangNhaSanXuat 
    @MaSP = 'SP0001', 
    @SoLuongYeuCau = 100;  -- Đặt hàng từ nhà sản xuất với số lượng yêu cầu

--TH4
CREATE PROCEDURE SP_TaoDonHangMoi
    @MaDonHang CHAR(15),           -- Mã đơn hàng
    @MaKhachHang CHAR(10),         -- Mã khách hàng
    @ThoiGianMua DATETIME          -- Thời gian mua
AS
BEGIN
    -- Đọc trạng thái đơn hàng mà không sử dụng khóa, có thể xảy ra Unrepeatable Read
    SELECT MaDonHang, TrangThai
    FROM DonHang
    WHERE MaDonHang = @MaDonHang;

    -- Tạo đơn hàng mới
    INSERT INTO DonHang (MaDonHang, MaKhachHang, ThoiGianMua, TrangThai)
    VALUES (@MaDonHang, @MaKhachHang, @ThoiGianMua, 'Đang xử lý');

    PRINT 'Đơn hàng đã được tạo';
END;
GO
CREATE PROCEDURE SP_CapNhatTrangThaiDonHang
    @MaDonHang CHAR(15),          -- Mã đơn hàng
    @TrangThai NVARCHAR(50)       -- Trạng thái mới của đơn hàng
AS
BEGIN
    -- Cập nhật trạng thái đơn hàng mà không sử dụng khóa, có thể xảy ra Unrepeatable Read
    UPDATE DonHang
    SET TrangThai = @TrangThai
    WHERE MaDonHang = @MaDonHang;

    PRINT 'Trạng thái đơn hàng đã được cập nhật';
END;
GO

CREATE PROCEDURE SP_TaoDonHangMoi
    @MaDonHang CHAR(15),           -- Mã đơn hàng
    @MaKhachHang CHAR(10),         -- Mã khách hàng
    @ThoiGianMua DATETIME          -- Thời gian mua
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;  -- Đảm bảo không có thay đổi khi đọc lại

    BEGIN TRANSACTION;  -- Bắt đầu transaction

    -- Đọc trạng thái đơn hàng với Share Lock (khóa đọc, tránh thay đổi trong khi đọc)
    SELECT MaDonHang, TrangThai
    FROM DonHang WITH (HOLDLOCK, ROWLOCK)
    WHERE MaDonHang = @MaDonHang;

    -- Tạo đơn hàng mới với trạng thái "Đang xử lý"
    INSERT INTO DonHang (MaDonHang, MaKhachHang, ThoiGianMua, TrangThai)
    VALUES (@MaDonHang, @MaKhachHang, @ThoiGianMua, 'Đang xử lý');

    COMMIT;  -- Xác nhận transaction
    PRINT 'Đơn hàng đã được tạo';
END;
GO
CREATE PROCEDURE SP_CapNhatTrangThaiDonHang
    @MaDonHang CHAR(15),          -- Mã đơn hàng
    @TrangThai NVARCHAR(50)       -- Trạng thái mới của đơn hàng
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;  -- Đảm bảo không có thay đổi khi đọc lại

    BEGIN TRANSACTION;  -- Bắt đầu transaction

    -- Cập nhật trạng thái đơn hàng với Exclusive Lock
    UPDATE DonHang WITH (XLOCK, ROWLOCK)
    SET TrangThai = @TrangThai
    WHERE MaDonHang = @MaDonHang;

    COMMIT;  -- Xác nhận transaction
    PRINT 'Trạng thái đơn hàng đã được cập nhật';
END;
GO

EXEC SP_TaoDonHangMoi 
    @MaDonHang = 'DH0001', 
    @MaKhachHang = 'KH0001', 
    @ThoiGianMua = '2024-12-15 10:00:00';
EXEC SP_CapNhatTrangThaiDonHang 
    @MaDonHang = 'DH0001', 
    @TrangThai = 'Đã giao';


--TH5
CREATE PROCEDURE SP_TinhTongGiaTriDonHang
    @MaDonHang CHAR(15)           -- Mã đơn hàng
AS
BEGIN
    -- Tính tổng giá trị đơn hàng mà không sử dụng khóa, có thể xảy ra Unrepeatable Read
    DECLARE @TongGiaTri INT;
    
    SELECT @TongGiaTri = SUM(ChiTietDonHang.Gia * ChiTietDonHang.SoLuong)
    FROM ChiTietDonHang
    WHERE MaDonHang = @MaDonHang;

    -- Cập nhật tổng giá trị đơn hàng vào bảng DonHang
    UPDATE DonHang
    SET TongGiaTri = @TongGiaTri
    WHERE MaDonHang = @MaDonHang;

    PRINT 'Tổng giá trị đơn hàng đã được tính toán và cập nhật';
END;
GO
CREATE PROCEDURE SP_ApDungKhuyenMaiTotNhat
    @MaDonHang CHAR(15)           -- Mã đơn hàng
AS
BEGIN
    -- Áp dụng khuyến mãi cho sản phẩm mà không sử dụng khóa, có thể xảy ra Unrepeatable Read
    DECLARE @GiaTriKhuyenMai INT;

    -- Tính giá trị khuyến mãi cho đơn hàng (ví dụ: giảm giá 10%)
    SELECT @GiaTriKhuyenMai = SUM(ChiTietDonHang.Gia * 0.1)
    FROM ChiTietDonHang
    WHERE MaDonHang = @MaDonHang;

    -- Cập nhật giá trị khuyến mãi vào bảng DonHang
    UPDATE DonHang
    SET KhuyenMai = @GiaTriKhuyenMai
    WHERE MaDonHang = @MaDonHang;

    PRINT 'Khuyến mãi tốt nhất đã được áp dụng cho đơn hàng';
END;
GO

CREATE PROCEDURE SP_TinhTongGiaTriDonHang
    @MaDonHang CHAR(15)           -- Mã đơn hàng
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;  -- Đảm bảo không có thay đổi khi đọc lại

    BEGIN TRANSACTION;  -- Bắt đầu transaction

    -- Đọc tổng giá trị đơn hàng với Share Lock (khóa đọc, tránh thay đổi trong khi đọc)
    DECLARE @TongGiaTri INT;
    SELECT @TongGiaTri = SUM(ChiTietDonHang.Gia * ChiTietDonHang.SoLuong)
    FROM ChiTietDonHang WITH (HOLDLOCK)
    WHERE MaDonHang = @MaDonHang;

    -- Cập nhật tổng giá trị đơn hàng
    UPDATE DonHang
    SET TongGiaTri = @TongGiaTri
    WHERE MaDonHang = @MaDonHang;

    COMMIT;  -- Xác nhận transaction
    PRINT 'Tổng giá trị đơn hàng đã được tính toán và cập nhật';
END;
GO
CREATE PROCEDURE SP_ApDungKhuyenMaiTotNhat
    @MaDonHang CHAR(15)           -- Mã đơn hàng
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;  -- Đảm bảo không có thay đổi khi đọc lại

    BEGIN TRANSACTION;  -- Bắt đầu transaction

    -- Đọc giá trị khuyến mãi của đơn hàng với Share Lock (khóa đọc, tránh thay đổi trong khi đọc)
    DECLARE @GiaTriKhuyenMai INT;
    SELECT @GiaTriKhuyenMai = SUM(ChiTietDonHang.Gia * 0.1)
    FROM ChiTietDonHang WITH (HOLDLOCK)
    WHERE MaDonHang = @MaDonHang;

    -- Áp dụng khuyến mãi cho đơn hàng
    UPDATE DonHang
    SET KhuyenMai = @GiaTriKhuyenMai
    WHERE MaDonHang = @MaDonHang;

    COMMIT;  -- Xác nhận transaction
    PRINT 'Khuyến mãi tốt nhất đã được áp dụng cho đơn hàng';
END;
GO

EXEC SP_TinhTongGiaTriDonHang 
    @MaDonHang = 'DH0001';
EXEC SP_ApDungKhuyenMaiTotNhat 
    @MaDonHang = 'DH0001';


--TH6
CREATE PROCEDURE SP_KiemTraPhieuTangSinhNhat
    @MaKhachHang CHAR(10)          -- Mã khách hàng
AS
BEGIN
    -- Đọc thông tin phiếu tặng sinh nhật mà không sử dụng khóa, có thể xảy ra Unrepeatable Read
    SELECT MaKhachHang, TieuChiChiTieu
    FROM KhachHang
    WHERE MaKhachHang = @MaKhachHang;

    PRINT 'Thông tin phiếu tặng sinh nhật đã được kiểm tra';
END;
GO
CREATE PROCEDURE SP_ApDungKMchoKH
    @MaKhachHang CHAR(10)          -- Mã khách hàng
AS
BEGIN
    -- Áp dụng khuyến mãi cho khách hàng mà không sử dụng khóa, có thể xảy ra Unrepeatable Read
    UPDATE KhachHang
    SET TieuChiChiTieu = TieuChiChiTieu + 500000  -- Thêm số tiền chi tiêu cho khách hàng khi áp dụng khuyến mãi
    WHERE MaKhachHang = @MaKhachHang;

    PRINT 'Khuyến mãi đã được áp dụng cho khách hàng';
END;
GO

CREATE PROCEDURE SP_KiemTraPhieuTangSinhNhat
    @MaKhachHang CHAR(10)          -- Mã khách hàng
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;  -- Đảm bảo không có thay đổi khi đọc lại

    BEGIN TRANSACTION;  -- Bắt đầu transaction

    -- Đọc thông tin khách hàng với Share Lock để ngăn không cho thay đổi trong khi đọc
    SELECT MaKhachHang, TieuChiChiTieu
    FROM KhachHang WITH (HOLDLOCK, ROWLOCK)
    WHERE MaKhachHang = @MaKhachHang;

    COMMIT;  -- Xác nhận transaction
    PRINT 'Thông tin phiếu tặng sinh nhật đã được kiểm tra và đã commit';
END;
GO
CREATE PROCEDURE SP_ApDungKMchoKH
    @MaKhachHang CHAR(10)          -- Mã khách hàng
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;  -- Đảm bảo không có thay đổi khi đọc lại

    BEGIN TRANSACTION;  -- Bắt đầu transaction

    -- Thay đổi thông tin khách hàng khi áp dụng khuyến mãi với Exclusive Lock
    UPDATE KhachHang WITH (XLOCK)
    SET TieuChiChiTieu = TieuChiChiTieu + 500000  -- Thêm số tiền chi tiêu cho khách hàng
    WHERE MaKhachHang = @MaKhachHang;

    COMMIT;  -- Xác nhận transaction
    PRINT 'Khuyến mãi đã được áp dụng cho khách hàng và đã commit';
END;
GO

EXEC SP_KiemTraPhieuTangSinhNhat 
    @MaKhachHang = 'KH0001';
EXEC SP_ApDungKMchoKH 
    @MaKhachHang = 'KH0001';
