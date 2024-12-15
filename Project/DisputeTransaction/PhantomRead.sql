CREATE PROCEDURE SP_ThongKeHangTonKho
AS
BEGIN
    -- Đọc danh sách sản phẩm mà không sử dụng khóa, có thể xảy ra Phantom Read
    SELECT MaSP, TenSP, SoLuongConLai
    FROM SanPham
    WHERE SoLuongConLai < 10;  -- Tìm sản phẩm có số lượng tồn kho thấp hơn 10
END;
GO
CREATE PROCEDURE SP_DatHangNhaSanXuat
    @MaSP CHAR(10),               -- Mã sản phẩm
    @SoLuongYeuCau INT            -- Số lượng yêu cầu cần đặt hàng từ nhà sản xuất
AS
BEGIN
    -- Thêm sản phẩm vào kho (có thể gây ra Phantom Read khi Procedure 1 đang thực hiện đọc)
    INSERT INTO SanPham (MaSP, TenSP, SoLuongConLai)
    VALUES (@MaSP, 'Sản phẩm mới', @SoLuongYeuCau);
    
    PRINT 'Đã thêm sản phẩm vào kho';
END;
GO

CREATE PROCEDURE SP_ThongKeHangTonKho
AS
BEGIN
    -- Sử dụng Serializable Isolation Level để ngăn chặn Phantom Read
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

    BEGIN TRANSACTION;  -- Bắt đầu transaction

    -- Đọc danh sách sản phẩm với Share Lock để ngăn không cho các thay đổi xảy ra
    SELECT MaSP, TenSP, SoLuongConLai
    FROM SanPham WITH (HOLDLOCK, ROWLOCK)
    WHERE SoLuongConLai < 10;  -- Tìm sản phẩm có số lượng tồn kho thấp hơn 10

    COMMIT;  -- Xác nhận transaction
    PRINT 'Danh sách sản phẩm cần đặt hàng đã được thống kê';
END;
GO
CREATE PROCEDURE SP_DatHangNhaSanXuat
    @MaSP CHAR(10),               -- Mã sản phẩm
    @SoLuongYeuCau INT            -- Số lượng yêu cầu cần đặt hàng từ nhà sản xuất
AS
BEGIN
    -- Sử dụng Exclusive Lock để đảm bảo không có thay đổi trong khi thực hiện cập nhật
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

    BEGIN TRANSACTION;  -- Bắt đầu transaction

    -- Thêm sản phẩm vào kho với Exclusive Lock để tránh tranh chấp
    INSERT INTO SanPham (MaSP, TenSP, SoLuongConLai)
    VALUES (@MaSP, 'Sản phẩm mới', @SoLuongYeuCau);

    COMMIT;  -- Xác nhận transaction
    PRINT 'Đã thêm sản phẩm vào kho';
END;
GO

EXEC SP_ThongKeHangTonKho;
EXEC SP_DatHangNhaSanXuat 
    @MaSP = 'SP001', 
    @SoLuongYeuCau = 50;
