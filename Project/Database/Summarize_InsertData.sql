INSERT INTO LoaiKhachHang (MaLoaiKhachHang, YeuCauMuaSam, TenLoai, GiaTriQuaTang) VALUES
('LK001', 50000000, 'Kim cương', 1200000),
('LK002', 30000000, 'Bạch kim', 700000),
('LK003', 15000000, 'Vàng', 500000),
('LK004', 5000000, 'Bạc', 200000),
('LK005', 0, 'Đồng', 100000),
('LK006', NULL, 'Thân thiết', NULL);
GO

INSERT INTO KhachHang (SDT, TenKhachHang, NgayDangKy, NgaySinhNhat, MaLoaiKhachHang) VALUES
('0909123456', 'Nguyen Van A', '2023-01-15', '1990-06-20', 'LK002'),
('0912345678', 'Tran Thi B', '2023-05-12', '1995-09-15', 'LK003'),
('0923456789', 'Le Van C', '2024-03-10', '1988-01-30', 'LK001'),
('0934567890', 'Pham Minh D', '2022-10-05', '1992-03-12', 'LK004'),
('0945678901', 'Nguyen Thi E', '2023-07-22', '1997-12-25', 'LK005'),
('0956789012', 'Tran Van F', '2024-01-01', '1985-11-15', 'LK006');
GO

INSERT INTO SanPham (MaSP, TenSP, GiaSP, MoTa, PhanLoai, NhaSanXuat, SoLuongConLai, SoLuongToiDa) VALUES
-- Điện tử
('SP001', 'Điện thoại XYZ', 15000000, 'Điện thoại thông minh, 128GB', 'Điện tử', 'Công ty ABC', 200, 500),
('SP002', 'Laptop ABC', 25000000, 'Laptop 15 inch, RAM 16GB', 'Điện tử', 'Công ty DEF', 150, 400),
('SP003', 'Tai nghe Bluetooth', 1200000, 'Tai nghe không dây, chống ồn', 'Điện tử', 'Công ty GHI', 300, 600),
('SP004', 'TV LED 50 inch', 12000000, 'Tivi màn hình LED 4K', 'Điện tử', 'Công ty JKL', 100, 300),
('SP005', 'Máy ảnh KLM', 22000000, 'Máy ảnh chuyên nghiệp', 'Điện tử', 'Công ty MNO', 50, 100),

-- Gia dụng
('SP006', 'Máy giặt 8kg', 7000000, 'Máy giặt lồng ngang, tiết kiệm điện', 'Gia dụng', 'Công ty PQR', 80, 200),
('SP007', 'Tủ lạnh 300L', 10000000, 'Tủ lạnh hai cửa, làm lạnh nhanh', 'Gia dụng', 'Công ty STU', 60, 150),
('SP008', 'Lò vi sóng 30L', 3000000, 'Lò vi sóng đa chức năng', 'Gia dụng', 'Công ty VWX', 120, 300),
('SP009', 'Máy xay sinh tố', 800000, 'Máy xay đa năng', 'Gia dụng', 'Công ty YZA', 200, 400),
('SP010', 'Quạt điều hòa', 5000000, 'Quạt làm mát không khí', 'Gia dụng', 'Công ty BCD', 90, 180),

-- Thực phẩm
('SP011', 'Gạo thơm 5kg', 150000, 'Gạo chất lượng cao, hương thơm tự nhiên', 'Thực phẩm', 'Công ty EFG', 300, 500),
('SP012', 'Dầu ăn 1L', 50000, 'Dầu thực vật nguyên chất', 'Thực phẩm', 'Công ty HIJ', 500, 800),
('SP013', 'Sữa tươi 1L', 30000, 'Sữa nguyên chất, không đường', 'Thực phẩm', 'Công ty KLM', 200, 400),
('SP014', 'Thịt bò 1kg', 250000, 'Thịt bò tươi loại 1', 'Thực phẩm', 'Công ty NOP', 100, 200),
('SP015', 'Trứng gà 10 quả', 30000, 'Trứng gà tươi sạch', 'Thực phẩm', 'Công ty QRS', 400, 600),

-- Thời trang
('SP016', 'Áo thun nam', 200000, 'Áo thun cotton, thoáng mát', 'Thời trang', 'Công ty TUV', 150, 300),
('SP017', 'Quần jeans nữ', 500000, 'Quần jeans co giãn', 'Thời trang', 'Công ty WXY', 100, 250),
('SP018', 'Giày thể thao', 1200000, 'Giày chạy bộ, bền đẹp', 'Thời trang', 'Công ty ZAB', 80, 200),
('SP019', 'Túi xách da', 2000000, 'Túi xách thời trang', 'Thời trang', 'Công ty CDE', 50, 150),
('SP020', 'Mũ lưỡi trai', 150000, 'Mũ thể thao', 'Thời trang', 'Công ty FGH', 200, 400),

-- Sách và văn phòng phẩm
('SP021', 'Sách Tiếng Anh', 150000, 'Sách học từ vựng', 'Sách', 'Nhà xuất bản ABC', 100, 200),
('SP022', 'Bút bi', 5000, 'Bút bi mực xanh', 'Văn phòng phẩm', 'Công ty XYZ', 500, 1000),
('SP023', 'Vở 100 trang', 20000, 'Vở kẻ ngang', 'Văn phòng phẩm', 'Công ty GHI', 300, 600),
('SP024', 'Máy in', 3000000, 'Máy in laser đa năng', 'Văn phòng phẩm', 'Công ty DEF', 50, 100),
('SP025', 'Sách lịch sử', 120000, 'Sách lịch sử Việt Nam', 'Sách', 'Nhà xuất bản KLM', 200, 300),

-- Khác
('SP026', 'Đồ chơi trẻ em', 300000, 'Đồ chơi an toàn, nhiều màu sắc', 'Khác', 'Công ty NOP', 200, 500),
('SP027', 'Balo học sinh', 400000, 'Balo chống nước, nhẹ', 'Khác', 'Công ty QRS', 100, 200),
('SP028', 'Đèn bàn LED', 250000, 'Đèn bàn tiết kiệm điện', 'Khác', 'Công ty STU', 120, 300),
('SP029', 'Thảm yoga', 500000, 'Thảm yoga chống trượt', 'Khác', 'Công ty VWX', 150, 250),
('SP030', 'Xe đạp trẻ em', 2000000, 'Xe đạp dành cho trẻ em 3-5 tuổi', 'Khác', 'Công ty YZA', 50, 100);

-- Tiếp tục thêm các sản phẩm khác nếu cần
GO

INSERT INTO KhuyenMai (MaKhuyenMai, TenKhuyenMai, LoaiKhuyenMai, ThoiGianBatDau, ThoiGianKetThuc) VALUES
('KM001', 'Flash Sale - Điện tử', 'Flash-sale', '2024-12-01', '2024-12-05'),
('KM002', 'Combo Sale - Nội thất', 'Combo-sale', '2024-12-01', '2024-12-10'),
('KM003', 'Member Sale - Thực phẩm', 'Member-sale', '2024-12-01', '2024-12-31'),
('KM004', 'Flash Sale - Gia dụng', 'Flash-sale', '2024-12-05', '2024-12-07'),
('KM005', 'Combo Sale - Thời trang', 'Combo-sale', '2024-12-10', '2024-12-15'),
('KM006', 'Member Sale - Mỹ phẩm', 'Member-sale', '2024-12-01', '2024-12-20'),
('KM007', 'Flash Sale - Đồ chơi', 'Flash-sale', '2024-12-15', '2024-12-17'),
('KM008', 'Combo Sale - Sách', 'Combo-sale', '2024-12-20', '2024-12-25'),
('KM009', 'Member Sale - Thể thao', 'Member-sale', '2024-12-01', '2024-12-15'),
('KM010', 'Flash Sale - Thiết bị nhà bếp', 'Flash-sale', '2024-12-08', '2024-12-09'),
('KM011', 'Combo Sale - Đồ uống', 'Combo-sale', '2024-12-05', '2024-12-10'),
('KM012', 'Member Sale - Công nghệ', 'Member-sale', '2024-12-01', '2024-12-25'),
('KM013', 'Flash Sale - Điện lạnh', 'Flash-sale', '2024-12-12', '2024-12-14'),
('KM014', 'Combo Sale - Trang sức', 'Combo-sale', '2024-12-18', '2024-12-22'),
('KM015', 'Member Sale - Dụng cụ học tập', 'Member-sale', '2024-12-01', '2024-12-31'),
('KM016', 'Flash Sale - Ô tô đồ chơi', 'Flash-sale', '2024-12-09', '2024-12-10'),
('KM017', 'Combo Sale - Điện thoại', 'Combo-sale', '2024-12-01', '2024-12-20'),
('KM018', 'Member Sale - Xe đạp', 'Member-sale', '2024-12-01', '2024-12-30'),
('KM019', 'Flash Sale - Máy tính', 'Flash-sale', '2024-12-03', '2024-12-06'),
('KM020', 'Combo Sale - Tivi', 'Combo-sale', '2024-12-07', '2024-12-15'),
('KM021', 'Member Sale - Nội thất cao cấp', 'Member-sale', '2024-12-01', '2024-12-18'),
('KM022', 'Flash Sale - Đồ bếp', 'Flash-sale', '2024-12-11', '2024-12-13'),
('KM023', 'Combo Sale - Đồ trang trí', 'Combo-sale', '2024-12-19', '2024-12-26'),
('KM024', 'Member Sale - Thú cưng', 'Member-sale', '2024-12-01', '2024-12-20'),
('KM025', 'Flash Sale - Phụ kiện xe hơi', 'Flash-sale', '2024-12-04', '2024-12-06'),
('KM026', 'Combo Sale - Đồ gia dụng nhỏ', 'Combo-sale', '2024-12-09', '2024-12-11'),
('KM027', 'Member Sale - Dụng cụ thể thao', 'Member-sale', '2024-12-01', '2024-12-22'),
('KM028', 'Flash Sale - Đồng hồ', 'Flash-sale', '2024-12-15', '2024-12-18'),
('KM029', 'Combo Sale - Laptop', 'Combo-sale', '2024-12-20', '2024-12-30'),
('KM030', 'Member Sale - Du lịch', 'Member-sale', '2024-12-01', '2024-12-25');
GO

INSERT INTO DonHang (MaDonHang, MaKhachHang, GiamGiaTheoPhieu, ThoiGianMua) VALUES
('DH001', '0909123456', 70000, '2024-11-20 10:30:00'),
('DH002', '0912345678', 50000, '2024-11-21 15:45:00'),
('DH003', '0923456789', 120000, '2024-11-22 09:15:00'),
('DH004', '0934567890', 20000, '2024-11-23 14:00:00'),
('DH005', '0945678901', 10000, '2024-11-24 17:50:00');
GO

INSERT INTO ChiTietDonHang (MaDonHang, MaSanPham, Gia, SoLuong) VALUES
('DH001', 'SP001', 15000000, 1),
('DH001', 'SP003', 1200000, 2),
('DH002', 'SP002', 25000000, 1),
('DH003', 'SP004', 12000000, 1),
('DH004', 'SP005', 22000000, 1),
('DH005', 'SP010', 5000000, 1);
GO

INSERT INTO ChiTietKhuyenMai (MaKhuyenMai, MaSP, SanPham1, SanPham2, GiaTriGiamGia, SoLuongToiDa) VALUES
('KM001', 'SP001', NULL, NULL, 1500000, 100),
('KM002', 'SP003', 'SP004', 'SP005', 2000000, 50),
('KM003', 'SP010', NULL, NULL, 500000, 30),
('KM004', 'SP002', NULL, NULL, 1200000, 70),
('KM005', 'SP006', 'SP007', 'SP008', 300000, 50);
GO

INSERT INTO PhieuQuaTang (MaPhieu, NgayBatDau, NgayKetThuc, GiaTriQuaTang, MaKhachHang) VALUES
('PQT001', '2024-01-01', '2024-01-31', 1200000, '0923456789'),
('PQT002', '2024-02-01', '2024-02-28', 700000, '0909123456'),
('PQT003', '2024-03-01', '2024-03-31', 500000, '0912345678'),
('PQT004', '2024-04-01', '2024-04-30', 200000, '0934567890'),
('PQT005', '2024-05-01', '2024-05-31', 100000, '0945678901');
GO

INSERT INTO DonDatKho (MaDonDat, TrangThaiGiao, SoLuongDaNhan, SoLuongDat, GiaTriDat, NgayDat, SanPham, NhaSanXuat, MaSanPham) VALUES
('DDK001', 'Đang giao', 0, 100, 15000000, '2024-12-01', 'Điện thoại XYZ', 'Công ty ABC', 'SP001'),
('DDK002', 'Đã giao', 200, 200, 30000000, '2024-11-15', 'Laptop ABC', 'Công ty DEF', 'SP002'),
('DDK003', 'Đang giao', 0, 50, 6000000, '2024-12-01', 'TV LED 50 inch', 'Công ty JKL', 'SP004'),
('DDK004', 'Đã giao', 30, 30, 2100000, '2024-11-20', 'Máy xay sinh tố', 'Công ty YZA', 'SP009'),
('DDK005', 'Đang giao', 0, 60, 4200000, '2024-12-03', 'Quạt điều hòa', 'Công ty BCD', 'SP010');
