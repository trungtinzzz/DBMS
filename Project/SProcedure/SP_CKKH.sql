-- Tạo stored procedure SP_CapNhatPhanHangKH
CREATE PROCEDURE SP_CapNhatPhanHangKH
AS
BEGIN
    -- Cập nhật phân hạng khách hàng dựa trên tổng chi tiêu hàng năm
    UPDATE KhachHang
    SET MaLoaiKhachHang = CASE
        WHEN TongChiTieu >= 50000000 THEN 'KIMCUONG'      -- Chi tiêu >= 50 triệu, hạng Kim cương
        WHEN TongChiTieu >= 30000000 THEN 'BACHKIM'       -- Chi tiêu >= 30 triệu, hạng Bạch kim
        WHEN TongChiTieu >= 15000000 THEN 'VANG'          -- Chi tiêu >= 15 triệu, hạng Vàng
        WHEN TongChiTieu >= 5000000 THEN 'BAC'            -- Chi tiêu >= 5 triệu, hạng Bạc
        ELSE 'DONG'                                       -- Chi tiêu < 5 triệu, hạng Đồng
    END
    FROM KhachHang KH
    INNER JOIN (
        SELECT MaKhachHang, SUM(ChiTietDonHang.Gia * ChiTietDonHang.SoLuong) AS TongChiTieu
        FROM DonHang
        INNER JOIN ChiTietDonHang ON DonHang.MaDonHang = ChiTietDonHang.MaDonHang
        WHERE YEAR(DonHang.ThoiGianMua) = YEAR(GETDATE()) -- Chi tiêu trong năm hiện tại
        GROUP BY MaKhachHang
    ) AS ChiTieu
    ON KH.SDT = ChiTieu.MaKhachHang;
    
    -- Đảm bảo rằng các thay đổi được commit vào cơ sở dữ liệu
    COMMIT;
END;
GO
-- Thực thi stored procedure để cập nhật phân hạng khách hàng
EXEC SP_CapNhatPhanHangKH;

-- Tạo stored procedure SP_TaoVoucherSN
CREATE PROCEDURE SP_TaoVoucherSN
AS
BEGIN
    DECLARE @NgayHienTai DATE = GETDATE();  -- Lấy ngày hiện tại
    DECLARE @ThangHienTai INT = MONTH(@NgayHienTai);  -- Lấy tháng hiện tại

    -- Kiểm tra và tạo voucher cho khách hàng có sinh nhật trong tháng này
    INSERT INTO PhieuQuaTang (MaPhieu, NgayBatDau, NgayKetThuc, GiaTriQuaTang, SDTKhachHang)
    SELECT 
        'VOUCHER_' + CAST(NEWID() AS VARCHAR(50)),  -- Tạo mã phiếu voucher duy nhất
        @NgayHienTai,                               -- Ngày bắt đầu voucher là ngày hiện tại
        DATEADD(DAY, 30, @NgayHienTai),             -- Ngày kết thúc voucher sau 30 ngày
        CASE
            WHEN LoaiKhachHang.MaLoaiKhachHang = 'KIMCUONG' THEN 1200000
            WHEN LoaiKhachHang.MaLoaiKhachHang = 'BACHKIM' THEN 700000
            WHEN LoaiKhachHang.MaLoaiKhachHang = 'VANG' THEN 500000
            WHEN LoaiKhachHang.MaLoaiKhachHang = 'BAC' THEN 200000
            WHEN LoaiKhachHang.MaLoaiKhachHang = 'DONG' THEN 100000
            ELSE 0
        END AS GiaTriQuaTang,  -- Quà tặng sinh nhật tùy theo hạng khách hàng
        KhachHang.SDT
    FROM KhachHang
    INNER JOIN LoaiKhachHang ON KhachHang.MaLoaiKhachHang = LoaiKhachHang.MaLoaiKhachHang
    WHERE MONTH(KhachHang.NgaySinhNhat) = @ThangHienTai  -- Kiểm tra sinh nhật trong tháng hiện tại
      AND DAY(KhachHang.NgaySinhNhat) = DAY(@NgayHienTai);  -- Kiểm tra ngày sinh nhật hôm nay

    -- Đảm bảo rằng các thay đổi được commit vào cơ sở dữ liệu
    COMMIT;
END;
GO
-- Thực thi stored procedure để tạo voucher quà tặng sinh nhật
EXEC SP_TaoVoucherSN;

-- Tạo stored procedure SP_ApDungKMchoKH
CREATE PROCEDURE SP_ApDungKMchoKH
    @MaDonHang CHAR(15) -- Mã đơn hàng cần áp dụng giảm giá
AS
BEGIN
    DECLARE @MaKhachHang CHAR(10);
    DECLARE @LoaiKhachHang CHAR(10);
    DECLARE @TongTien INT;
    DECLARE @GiamGia INT;

    -- Lấy mã khách hàng và phân hạng khách hàng từ đơn hàng
    SELECT @MaKhachHang = DonHang.MaKhachHang
    FROM DonHang
    WHERE MaDonHang = @MaDonHang;

    -- Lấy phân hạng khách hàng
    SELECT @LoaiKhachHang = MaLoaiKhachHang
    FROM KhachHang
    WHERE SDT = @MaKhachHang;

    -- Lấy tổng tiền của đơn hàng trước khi áp dụng giảm giá
    SELECT @TongTien = SUM(ChiTietDonHang.Gia * ChiTietDonHang.SoLuong)
    FROM ChiTietDonHang
    WHERE MaDonHang = @MaDonHang
    GROUP BY MaDonHang;

    -- Áp dụng giảm giá theo phân hạng khách hàng
    SET @GiamGia = CASE
        WHEN @LoaiKhachHang = 'KIMCUONG' THEN @TongTien * 0.20 -- Giảm 20% cho khách hàng Kim cương
        WHEN @LoaiKhachHang = 'BACHKIM' THEN @TongTien * 0.15  -- Giảm 15% cho khách hàng Bạch kim
        WHEN @LoaiKhachHang = 'VANG' THEN @TongTien * 0.10     -- Giảm 10% cho khách hàng Vàng
        WHEN @LoaiKhachHang = 'BAC' THEN @TongTien * 0.05      -- Giảm 5% cho khách hàng Bạc
        ELSE 0                                                  -- Không giảm cho khách hàng Đồng
    END;

    -- Cập nhật đơn hàng với giá trị giảm giá
    UPDATE DonHang
    SET GiamGiaTheoPhieu = @GiamGia
    WHERE MaDonHang = @MaDonHang;

    -- Cập nhật tổng tiền sau giảm giá
    UPDATE DonHang
    SET ThoiGianMua = GETDATE() -- Cập nhật thời gian mua lại
    WHERE MaDonHang = @MaDonHang;

    -- Đảm bảo rằng các thay đổi được commit vào cơ sở dữ liệu
    COMMIT;
END;
GO
-- Thực thi stored procedure để áp dụng giảm giá cho đơn hàng
EXEC SP_ApDungKMchoKH @MaDonHang = 'DH0001';

