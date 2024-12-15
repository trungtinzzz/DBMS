--TH1
-- SP_CapNhatPhanHangKH (Cập nhật thông tin phân hạng khách hàng và giá sản phẩm)
CREATE PROCEDURE SP_CapNhatPhanHangKH
    @MaSP CHAR(10),  -- Mã sản phẩm
    @MaKhachHang CHAR(10),  -- Mã khách hàng
    @MoiLoaiKhachHang CHAR(10)  -- Mã loại khách hàng mới
AS
BEGIN
    -- Không có cơ chế khoá, có thể xảy ra tranh chấp
    -- Cập nhật phân hạng khách hàng
    UPDATE KhachHang
    SET MaLoaiKhachHang = @MoiLoaiKhachHang
    WHERE SDT = @MaKhachHang;

    -- Cập nhật thông tin sản phẩm (ví dụ: giá sản phẩm)
    UPDATE SanPham
    SET GiaSP = GiaSP * 1.1  -- Tăng giá sản phẩm 10%
    WHERE MaSP = @MaSP;
    
    PRINT 'Cập nhật phân hạng khách hàng và giá sản phẩm thành công';
END;
GO

-- SP_CapNhatThongTinSP (Cập nhật thông tin sản phẩm)
CREATE PROCEDURE SP_CapNhatThongTinSP
    @MaSP CHAR(10),  -- Mã sản phẩm
    @GiaSP INT,  -- Giá sản phẩm mới
    @MoTa NVARCHAR(200)  -- Mô tả sản phẩm mới
AS
BEGIN
    -- Không có cơ chế khoá, có thể xảy ra tranh chấp
    -- Cập nhật thông tin sản phẩm
    UPDATE SanPham
    SET GiaSP = @GiaSP, MoTa = @MoTa
    WHERE MaSP = @MaSP;

    PRINT 'Cập nhật thông tin sản phẩm thành công';
END;
GO

-- SP_CapNhatPhanHangKH (Cập nhật thông tin phân hạng khách hàng và giá sản phẩm)
CREATE PROCEDURE SP_CapNhatPhanHangKH
    @MaSP CHAR(10),  -- Mã sản phẩm
    @MaKhachHang CHAR(10),  -- Mã khách hàng
    @MoiLoaiKhachHang CHAR(10)  -- Mã loại khách hàng mới
AS
BEGIN
    BEGIN TRANSACTION;  -- Bắt đầu transaction

    -- Đặt khoá Exclusive lên sản phẩm để tránh xung đột khi cập nhật cùng một lúc
    SELECT * FROM SanPham WITH (XLOCK, ROWLOCK)
    WHERE MaSP = @MaSP;

    -- Cập nhật phân hạng khách hàng
    UPDATE KhachHang
    SET MaLoaiKhachHang = @MoiLoaiKhachHang
    WHERE SDT = @MaKhachHang;

    -- Cập nhật thông tin sản phẩm (ví dụ: giá sản phẩm)
    UPDATE SanPham
    SET GiaSP = GiaSP * 1.1  -- Tăng giá sản phẩm 10%
    WHERE MaSP = @MaSP;

    COMMIT;  -- Xác nhận transaction
    PRINT 'Cập nhật phân hạng khách hàng và giá sản phẩm thành công';
END;
GO

-- SP_CapNhatThongTinSP (Cập nhật thông tin sản phẩm)
CREATE PROCEDURE SP_CapNhatThongTinSP
    @MaSP CHAR(10),  -- Mã sản phẩm
    @GiaSP INT,  -- Giá sản phẩm mới
    @MoTa NVARCHAR(200)  -- Mô tả sản phẩm mới
AS
BEGIN
    BEGIN TRANSACTION;  -- Bắt đầu transaction

    -- Đặt khoá Exclusive lên sản phẩm để tránh xung đột khi cập nhật cùng một lúc
    SELECT * FROM SanPham WITH (XLOCK, ROWLOCK)
    WHERE MaSP = @MaSP;

    -- Cập nhật thông tin sản phẩm (ví dụ: giá và mô tả sản phẩm)
    UPDATE SanPham
    SET GiaSP = @GiaSP, MoTa = @MoTa
    WHERE MaSP = @MaSP;

    COMMIT;  -- Xác nhận transaction
    PRINT 'Cập nhật thông tin sản phẩm thành công';
END;
GO

EXEC SP_CapNhatPhanHangKH 
    @MaSP = 'SP0001', 
    @MaKhachHang = 'KH0001', 
    @MoiLoaiKhachHang = 'VANG';
EXEC SP_CapNhatThongTinSP 
    @MaSP = 'SP0001', 
    @GiaSP = 500000, 
    @MoTa = 'Sản phẩm mới với giá và mô tả cập nhật.';

--TH2
CREATE PROCEDURE SP_CapNhatTonKho
    @MaSP CHAR(10),               -- Mã sản phẩm
    @SoLuong INT,                 -- Số lượng thay đổi (có thể là âm hoặc dương)
    @LoaiGiaoDich NVARCHAR(50)    -- Loại giao dịch (Nhập kho hoặc Xuất kho)
AS
BEGIN
    -- Cập nhật số lượng tồn kho mà không sử dụng cơ chế khoá
    UPDATE SanPham
    SET SoLuongConLai = SoLuongConLai + @SoLuong
    WHERE MaSP = @MaSP;

    PRINT 'Cập nhật tồn kho thành công';
END;
GO
CREATE PROCEDURE SP_DatHangNhaSanXuat
    @MaSP CHAR(10),               -- Mã sản phẩm
    @SoLuongYeuCau INT            -- Số lượng yêu cầu cần đặt hàng từ nhà sản xuất
AS
BEGIN
    -- Cập nhật số lượng tồn kho mà không sử dụng cơ chế khoá
    UPDATE SanPham
    SET SoLuongConLai = SoLuongConLai + @SoLuongYeuCau
    WHERE MaSP = @MaSP;

    PRINT 'Đặt hàng nhà sản xuất thành công';
END;
GO
CREATE PROCEDURE SP_CapNhatTonKho
    @MaSP CHAR(10),               -- Mã sản phẩm
    @SoLuong INT,                 -- Số lượng thay đổi (có thể là âm hoặc dương)
    @LoaiGiaoDich NVARCHAR(50)    -- Loại giao dịch (Nhập kho hoặc Xuất kho)
AS
BEGIN
    BEGIN TRANSACTION;  -- Bắt đầu transaction

    -- Đặt khoá Exclusive lên sản phẩm để tránh xung đột khi cập nhật cùng một lúc
    SELECT * FROM SanPham WITH (XLOCK, ROWLOCK)
    WHERE MaSP = @MaSP;

    -- Cập nhật số lượng tồn kho
    UPDATE SanPham
    SET SoLuongConLai = SoLuongConLai + @SoLuong
    WHERE MaSP = @MaSP;

    COMMIT;  -- Xác nhận transaction
    PRINT 'Cập nhật tồn kho thành công';
END;
GO
CREATE PROCEDURE SP_DatHangNhaSanXuat
    @MaSP CHAR(10),               -- Mã sản phẩm
    @SoLuongYeuCau INT            -- Số lượng yêu cầu cần đặt hàng từ nhà sản xuất
AS
BEGIN
    BEGIN TRANSACTION;  -- Bắt đầu transaction

    -- Đặt khoá Exclusive lên sản phẩm để tránh xung đột khi cập nhật cùng một lúc
    SELECT * FROM SanPham WITH (XLOCK, ROWLOCK)
    WHERE MaSP = @MaSP;

    -- Cập nhật số lượng tồn kho khi đặt hàng bổ sung
    UPDATE SanPham
    SET SoLuongConLai = SoLuongConLai + @SoLuongYeuCau
    WHERE MaSP = @MaSP;

    COMMIT;  -- Xác nhận transaction
    PRINT 'Đặt hàng nhà sản xuất thành công';
END;
GO
-- Thực thi procedure SP_CapNhatTonKho (Cập nhật tồn kho) mà không sử dụng khóa
EXEC SP_CapNhatTonKho 
    @MaSP = 'SP0001', 
    @SoLuong = -10,  -- Giảm số lượng tồn kho
    @LoaiGiaoDich = 'Xuất kho';
-- Thực thi procedure SP_DatHangNhaSanXuat (Đặt hàng nhà sản xuất) mà không sử dụng khóa
EXEC SP_DatHangNhaSanXuat 
    @MaSP = 'SP0001', 
    @SoLuongYeuCau = 50;  -- Số lượng cần đặt hàng từ nhà sản xuất

--TH3
CREATE PROCEDURE SP_QuanLyKM
    @MaKhuyenMai CHAR(15),           -- Mã khuyến mãi
    @ThoiGianBatDau DATE,             -- Thời gian bắt đầu của khuyến mãi
    @ThoiGianKetThuc DATE,            -- Thời gian kết thúc của khuyến mãi
    @GiaTriGiamGia INT                -- Giá trị giảm giá
AS
BEGIN
    -- Không sử dụng khoá, có thể xảy ra tranh chấp
    UPDATE KhuyenMai
    SET ThoiGianBatDau = @ThoiGianBatDau,
        ThoiGianKetThuc = @ThoiGianKetThuc,
        GiaTriGiamGia = @GiaTriGiamGia
    WHERE MaKhuyenMai = @MaKhuyenMai;

    PRINT 'Cập nhật thông tin khuyến mãi thành công';
END;
GO
CREATE PROCEDURE SP_ApDungKM
    @MaKhuyenMai CHAR(15),           -- Mã khuyến mãi
    @MaSP CHAR(10)                   -- Mã sản phẩm
AS
BEGIN
    -- Không sử dụng khoá, có thể xảy ra tranh chấp
    UPDATE ChiTietKhuyenMai
    SET GiaTriGiamGia = (SELECT GiaTriGiamGia FROM KhuyenMai WHERE MaKhuyenMai = @MaKhuyenMai)
    WHERE MaKhuyenMai = @MaKhuyenMai AND MaSP = @MaSP;

    PRINT 'Áp dụng khuyến mãi cho sản phẩm thành công';
END;
GO
CREATE PROCEDURE SP_QuanLyKM
    @MaKhuyenMai CHAR(15),           -- Mã khuyến mãi
    @ThoiGianBatDau DATE,             -- Thời gian bắt đầu của khuyến mãi
    @ThoiGianKetThuc DATE,            -- Thời gian kết thúc của khuyến mãi
    @GiaTriGiamGia INT                -- Giá trị giảm giá
AS
BEGIN
    BEGIN TRANSACTION;  -- Bắt đầu transaction

    -- Đặt khoá Exclusive lên bảng KhuyenMai để tránh tranh chấp khi cập nhật
    SELECT * FROM KhuyenMai WITH (XLOCK, ROWLOCK)
    WHERE MaKhuyenMai = @MaKhuyenMai;

    -- Cập nhật thông tin khuyến mãi
    UPDATE KhuyenMai
    SET ThoiGianBatDau = @ThoiGianBatDau,
        ThoiGianKetThuc = @ThoiGianKetThuc,
        GiaTriGiamGia = @GiaTriGiamGia
    WHERE MaKhuyenMai = @MaKhuyenMai;

    COMMIT;  -- Xác nhận transaction
    PRINT 'Cập nhật thông tin khuyến mãi thành công';
END;
GO
CREATE PROCEDURE SP_ApDungKM
    @MaKhuyenMai CHAR(15),           -- Mã khuyến mãi
    @MaSP CHAR(10)                   -- Mã sản phẩm
AS
BEGIN
    BEGIN TRANSACTION;  -- Bắt đầu transaction

    -- Đặt khoá Exclusive lên bảng ChiTietKhuyenMai để tránh tranh chấp khi áp dụng khuyến mãi
    SELECT * FROM ChiTietKhuyenMai WITH (XLOCK, ROWLOCK)
    WHERE MaKhuyenMai = @MaKhuyenMai AND MaSP = @MaSP;

    -- Áp dụng khuyến mãi cho sản phẩm
    UPDATE ChiTietKhuyenMai
    SET GiaTriGiamGia = (SELECT GiaTriGiamGia FROM KhuyenMai WHERE MaKhuyenMai = @MaKhuyenMai)
    WHERE MaKhuyenMai = @MaKhuyenMai AND MaSP = @MaSP;

    COMMIT;  -- Xác nhận transaction
    PRINT 'Áp dụng khuyến mãi cho sản phẩm thành công';
END;
GO
-- Thực thi SP_QuanLyKM để cập nhật thông tin khuyến mãi
EXEC SP_QuanLyKM 
    @MaKhuyenMai = 'KM001',          -- Mã khuyến mãi
    @ThoiGianBatDau = '2024-01-01',   -- Thời gian bắt đầu
    @ThoiGianKetThuc = '2024-12-31',  -- Thời gian kết thúc
    @GiaTriGiamGia = 20;              -- Giá trị giảm giá (ví dụ: 20%)
-- Thực thi SP_ApDungKM để áp dụng khuyến mãi cho sản phẩm
EXEC SP_ApDungKM 
    @MaKhuyenMai = 'KM001',  -- Mã khuyến mãi
    @MaSP = 'SP0001';         -- Mã sản phẩm

--TH4
CREATE PROCEDURE SP_TaoDonHangMoi
    @MaDonHang CHAR(15),           -- Mã đơn hàng
    @MaKhachHang CHAR(10),         -- Mã khách hàng
    @ThoiGianMua DATETIME          -- Thời gian mua
AS
BEGIN
    -- Tạo đơn hàng mà không có cơ chế khoá
    INSERT INTO DonHang (MaDonHang, MaKhachHang, ThoiGianMua, TrangThai)
    VALUES (@MaDonHang, @MaKhachHang, @ThoiGianMua, 'Đang xử lý');

    PRINT 'Đơn hàng mới đã được tạo';
END;
GO
CREATE PROCEDURE SP_CapNhatTrangThaiDonHang
    @MaDonHang CHAR(15),          -- Mã đơn hàng
    @TrangThai NVARCHAR(50)       -- Trạng thái đơn hàng mới
AS
BEGIN
    -- Cập nhật trạng thái đơn hàng mà không sử dụng khoá
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
    BEGIN TRANSACTION;  -- Bắt đầu transaction

    -- Đặt khoá Exclusive lên bảng DonHang để tránh tranh chấp khi cập nhật cùng một lúc
    SELECT * FROM DonHang WITH (XLOCK, ROWLOCK)
    WHERE MaDonHang = @MaDonHang;

    -- Tạo đơn hàng mới
    INSERT INTO DonHang (MaDonHang, MaKhachHang, ThoiGianMua, TrangThai)
    VALUES (@MaDonHang, @MaKhachHang, @ThoiGianMua, 'Đang xử lý');

    COMMIT;  -- Xác nhận transaction
    PRINT 'Đơn hàng mới đã được tạo';
END;
GO
CREATE PROCEDURE SP_CapNhatTrangThaiDonHang
    @MaDonHang CHAR(15),          -- Mã đơn hàng
    @TrangThai NVARCHAR(50)       -- Trạng thái đơn hàng mới
AS
BEGIN
    BEGIN TRANSACTION;  -- Bắt đầu transaction

    -- Đặt khoá Exclusive lên bảng DonHang để tránh tranh chấp khi cập nhật cùng một lúc
    SELECT * FROM DonHang WITH (XLOCK, ROWLOCK)
    WHERE MaDonHang = @MaDonHang;

    -- Cập nhật trạng thái đơn hàng
    UPDATE DonHang
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
    -- Tính tổng giá trị đơn hàng mà không sử dụng khóa
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
    -- Áp dụng khuyến mãi tốt nhất cho đơn hàng mà không sử dụng khóa
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
    BEGIN TRANSACTION;  -- Bắt đầu transaction

    -- Đặt khoá Exclusive lên bảng ChiTietDonHang để tránh tranh chấp khi tính tổng giá trị
    SELECT * FROM ChiTietDonHang WITH (XLOCK, ROWLOCK)
    WHERE MaDonHang = @MaDonHang;

    DECLARE @TongGiaTri INT;
    
    -- Tính tổng giá trị đơn hàng
    SELECT @TongGiaTri = SUM(ChiTietDonHang.Gia * ChiTietDonHang.SoLuong)
    FROM ChiTietDonHang
    WHERE MaDonHang = @MaDonHang;

    -- Cập nhật tổng giá trị đơn hàng vào bảng DonHang
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
    BEGIN TRANSACTION;  -- Bắt đầu transaction

    -- Đặt khoá Exclusive lên bảng DonHang để tránh tranh chấp khi áp dụng khuyến mãi
    SELECT * FROM DonHang WITH (XLOCK, ROWLOCK)
    WHERE MaDonHang = @MaDonHang;

    DECLARE @GiaTriKhuyenMai INT;

    -- Tính giá trị khuyến mãi cho đơn hàng
    SELECT @GiaTriKhuyenMai = SUM(ChiTietDonHang.Gia * 0.1)
    FROM ChiTietDonHang
    WHERE MaDonHang = @MaDonHang;

    -- Cập nhật giá trị khuyến mãi vào bảng DonHang
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

