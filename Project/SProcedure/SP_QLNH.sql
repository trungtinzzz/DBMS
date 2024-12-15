-- Tạo stored procedure SP_CapNhatThongTinSP
CREATE PROCEDURE SP_CapNhatThongTinSP
    @MaSP CHAR(10),              -- Mã sản phẩm cần cập nhật
    @GiaSP INT,                  -- Giá sản phẩm mới
    @MoTa NVARCHAR(200),         -- Mô tả sản phẩm mới
    @SoLuongConLai INT,          -- Số lượng tồn kho mới
    @SoLuongToiDa INT            -- Số lượng tối đa có thể lưu trữ trong kho mới
AS
BEGIN
    -- Cập nhật thông tin sản phẩm trong kho
    UPDATE SanPham
    SET
        GiaSP = @GiaSP,                        -- Cập nhật giá sản phẩm
        MoTa = @MoTa,                          -- Cập nhật mô tả sản phẩm
        SoLuongConLai = @SoLuongConLai,        -- Cập nhật số lượng tồn kho
        SoLuongToiDa = @SoLuongToiDa          -- Cập nhật số lượng tối đa có thể lưu trữ
    WHERE MaSP = @MaSP;                        -- Điều kiện tìm sản phẩm theo mã

    -- Đảm bảo rằng các thay đổi được commit vào cơ sở dữ liệu
    COMMIT;
END;
GO
-- Thực thi stored procedure để cập nhật thông tin sản phẩm
EXEC SP_CapNhatThongTinSP 
    @MaSP = 'SP0001', 
    @GiaSP = 300000, 
    @MoTa = N'Áo thun nam, chất liệu cotton cao cấp, thoáng mát.', 
    @SoLuongConLai = 120, 
    @SoLuongToiDa = 200;

-- Tạo stored procedure SP_QuanLyKM để quản lý chương trình khuyến mãi
CREATE PROCEDURE SP_QuanLyKM
    @Action NVARCHAR(10),            -- Tham số hành động (Tạo, Sửa, Xóa)
    @MaKhuyenMai CHAR(15),           -- Mã khuyến mãi
    @TenKhuyenMai NVARCHAR(100),     -- Tên chương trình khuyến mãi
    @LoaiKhuyenMai NVARCHAR(50),     -- Loại khuyến mãi (Flash-sale, Combo-sale, Member-sale)
    @ThoiGianBatDau DATE,            -- Thời gian bắt đầu
    @ThoiGianKetThuc DATE            -- Thời gian kết thúc
AS
BEGIN
    -- Kiểm tra hành động và thực hiện thao tác tương ứng
    IF @Action = 'Tao'  -- Tạo chương trình khuyến mãi mới
    BEGIN
        INSERT INTO KhuyenMai (MaKhuyenMai, TenKhuyenMai, LoaiKhuyenMai, ThoiGianBatDau, ThoiGianKetThuc)
        VALUES (@MaKhuyenMai, @TenKhuyenMai, @LoaiKhuyenMai, @ThoiGianBatDau, @ThoiGianKetThuc);
    END
    ELSE IF @Action = 'Sua'  -- Sửa thông tin chương trình khuyến mãi
    BEGIN
        UPDATE KhuyenMai
        SET TenKhuyenMai = @TenKhuyenMai,
            LoaiKhuyenMai = @LoaiKhuyenMai,
            ThoiGianBatDau = @ThoiGianBatDau,
            ThoiGianKetThuc = @ThoiGianKetThuc
        WHERE MaKhuyenMai = @MaKhuyenMai;
    END
    ELSE IF @Action = 'Xoa'  -- Xóa chương trình khuyến mãi
    BEGIN
        DELETE FROM KhuyenMai
        WHERE MaKhuyenMai = @MaKhuyenMai;
    END
    ELSE
    BEGIN
        PRINT 'Hành động không hợp lệ. Vui lòng chọn "Tao", "Sua", hoặc "Xoa".';
    END

    -- Đảm bảo rằng các thay đổi được commit vào cơ sở dữ liệu
    COMMIT;
END;
GO
EXEC SP_QuanLyKM 
    @Action = 'Tao',
    @MaKhuyenMai = 'KM0011',
    @TenKhuyenMai = N'Khuyến mãi mùa hè 2023',
    @LoaiKhuyenMai = N'Flash-sale',
    @ThoiGianBatDau = '2023-06-01',
    @ThoiGianKetThuc = '2023-06-30';
EXEC SP_QuanLyKM 
    @Action = 'Sua',
    @MaKhuyenMai = 'KM0011',
    @TenKhuyenMai = N'Khuyến mãi hè 2023 điều chỉnh',
    @LoaiKhuyenMai = N'Combo-sale',
    @ThoiGianBatDau = '2023-06-05',
    @ThoiGianKetThuc = '2023-06-25';
EXEC SP_QuanLyKM 
    @Action = 'Xoa',
    @MaKhuyenMai = 'KM0011',
    @TenKhuyenMai = NULL, 
    @LoaiKhuyenMai = NULL,
    @ThoiGianBatDau = NULL,
    @ThoiGianKetThuc = NULL;

-- Tạo stored procedure SP_ThemSP để thêm sản phẩm mới
CREATE PROCEDURE SP_ThemSP
    @MaSP CHAR(10),               -- Mã sản phẩm
    @TenSP NVARCHAR(100),         -- Tên sản phẩm
    @GiaSP INT,                   -- Giá sản phẩm
    @MoTa NVARCHAR(200),          -- Mô tả sản phẩm
    @PhanLoai NVARCHAR(50),       -- Phân loại sản phẩm
    @NhaSanXuat NVARCHAR(50),     -- Nhà sản xuất sản phẩm
    @SoLuongConLai INT,           -- Số lượng tồn kho hiện tại
    @SoLuongToiDa INT             -- Số lượng tối đa có thể lưu trữ trong kho
AS
BEGIN
    -- Kiểm tra nếu sản phẩm đã tồn tại trong hệ thống hay chưa
    IF EXISTS (SELECT 1 FROM SanPham WHERE MaSP = @MaSP)
    BEGIN
        PRINT 'Sản phẩm đã tồn tại trong hệ thống!';
        RETURN; -- Nếu sản phẩm đã tồn tại, không thêm mới
    END

    -- Thêm sản phẩm mới vào bảng SanPham
    INSERT INTO SanPham (MaSP, TenSP, GiaSP, MoTa, PhanLoai, NhaSanXuat, SoLuongConLai, SoLuongToiDa)
    VALUES (@MaSP, @TenSP, @GiaSP, @MoTa, @PhanLoai, @NhaSanXuat, @SoLuongConLai, @SoLuongToiDa);

    -- Đảm bảo rằng các thay đổi được commit vào cơ sở dữ liệu
    COMMIT;

    PRINT 'Sản phẩm đã được thêm thành công!';
END;
GO
-- Thực thi stored procedure để thêm sản phẩm mới
EXEC SP_ThemSP 
    @MaSP = 'SP0051', 
    @TenSP = N'Giày thể thao nữ', 
    @GiaSP = 700000, 
    @MoTa = N'Giày thể thao nữ, thiết kế thời trang, phù hợp cho các hoạt động thể thao.', 
    @PhanLoai = N'Quần áo', 
    @NhaSanXuat = N'Adidas', 
    @SoLuongConLai = 150, 
    @SoLuongToiDa = 300;

-- Tạo stored procedure SP_ApDungKM để áp dụng chương trình khuyến mãi cho sản phẩm
CREATE PROCEDURE SP_ApDungKM
    @MaKhuyenMai CHAR(15),             -- Mã chương trình khuyến mãi
    @MaSanPhamList NVARCHAR(MAX)       -- Danh sách mã sản phẩm, cách nhau bởi dấu phẩy
AS
BEGIN
    -- Xử lý danh sách mã sản phẩm
    DECLARE @SQL NVARCHAR(MAX);
    DECLARE @MaSanPham NVARCHAR(10);
    
    -- Bắt đầu tạo câu lệnh SQL động
    SET @SQL = 'UPDATE ChiTietKhuyenMai SET GiaTriGiamGia = ';

    -- Áp dụng khuyến mãi cho các sản phẩm
    -- Kiểm tra loại chương trình khuyến mãi (Flash-sale, Combo-sale, Member-sale) để tính giảm giá
    SET @SQL = @SQL + ' (CASE 
                            WHEN KhuyenMai.LoaiKhuyenMai = ''Flash-sale'' THEN ' + CAST(10 AS NVARCHAR) + ' * SanPham.GiaSP / 100
                            WHEN KhuyenMai.LoaiKhuyenMai = ''Combo-sale'' THEN ' + CAST(15 AS NVARCHAR) + ' * SanPham.GiaSP / 100
                            WHEN KhuyenMai.LoaiKhuyenMai = ''Member-sale'' THEN ' + CAST(20 AS NVARCHAR) + ' * SanPham.GiaSP / 100 
                            ELSE 0
                         END)
                         FROM ChiTietKhuyenMai
                         JOIN SanPham ON ChiTietKhuyenMai.MaSP = SanPham.MaSP
                         JOIN KhuyenMai ON ChiTietKhuyenMai.MaKhuyenMai = KhuyenMai.MaKhuyenMai
                         WHERE KhuyenMai.MaKhuyenMai = @MaKhuyenMai
                         AND SanPham.MaSP IN (' + @MaSanPhamList + ')';
    
    -- Thực thi câu lệnh SQL động
    EXEC sp_executesql @SQL, N'@MaKhuyenMai CHAR(15)', @MaKhuyenMai;

    -- Đảm bảo rằng các thay đổi được commit vào cơ sở dữ liệu
    COMMIT;
END;
GO
-- Thực thi stored procedure để áp dụng chương trình khuyến mãi cho một danh sách sản phẩm
EXEC SP_ApDungKM 
    @MaKhuyenMai = 'KM0001', 
    @MaSanPhamList = 'SP0001, SP0002, SP0004';

