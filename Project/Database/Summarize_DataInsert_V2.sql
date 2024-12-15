-- Nạp dữ liệu vào bảng LoaiKhachHang
INSERT INTO LoaiKhachHang (MaLoaiKhachHang, YeuCauMuaSam, TenLoai, GiaTriQuaTang)
VALUES 
    ('KIMCUONG', 50000000, N'Kim cương', 1200000),
    ('BACHKIM', 30000000, N'Bạch kim', 700000),
    ('VANG', 15000000, N'Vàng', 500000),
    ('BAC', 5000000, N'Bạc', 200000),
    ('DONG', 0, N'Đồng', 100000),
    ('THANTHIET', NULL, N'Thân thiết', 0);

-- Nạp dữ liệu vào bảng KhachHang
INSERT INTO KhachHang (SDT, TenKhachHang, NgayDangKy, NgaySinhNhat, MaLoaiKhachHang)
VALUES 
    ('0901234567', N'Nguyễn Văn A', '2022-05-10', '1990-03-15', 'KIMCUONG'),
    ('0902345678', N'Phan Thị B', '2023-02-12', '1985-07-22', 'BACHKIM'),
    ('0903456789', N'Nguyễn Thị C', '2021-07-05', '1995-01-10', 'VANG'),
    ('0904567890', N'Trần Minh D', '2020-11-18', '1988-12-25', 'BAC'),
    ('0905678901', N'Phạm Thị E', '2022-09-20', '1992-05-30', 'DONG'),
    ('0906789012', N'Hoàng Đức F', '2023-06-14', '1993-04-10', 'THANTHIET'),
    ('0907890123', N'Vũ Ngọc G', '2021-03-15', '1980-11-28', 'KIMCUONG'),
    ('0908901234', N'Nguyễn Đức H', '2022-08-01', '1998-02-20', 'BACHKIM'),
    ('0909012345', N'Lê Thị I', '2023-04-11', '1997-06-17', 'VANG'),
    ('0910123456', N'Trần Phú J', '2021-12-23', '1994-09-12', 'BAC'),
    ('0911234567', N'Phan Kim K', '2022-01-30', '1986-03-03', 'DONG'),
    ('0912345678', N'Nguyễn Minh L', '2023-07-10', '1991-08-05', 'THANTHIET'),
    ('0913456789', N'Lê Minh M', '2020-02-19', '1983-10-13', 'KIMCUONG'),
    ('0914567890', N'Hoàng Kim N', '2021-06-21', '1996-05-15', 'BACHKIM'),
    ('0915678901', N'Phạm Tuấn O', '2022-04-03', '1989-11-27', 'VANG'),
    ('0916789012', N'Vũ Lê P', '2023-03-08', '1990-02-01', 'BAC'),
    ('0917890123', N'Nguyễn Tấn Q', '2020-10-27', '1992-07-18', 'DONG'),
    ('0918901234', N'Lê Hoàng R', '2022-11-13', '1994-05-22', 'THANTHIET'),
    ('0919012345', N'Hoàng Đức S', '2023-09-30', '1996-12-05', 'KIMCUONG');

-- Nạp dữ liệu vào bảng SanPham
INSERT INTO SanPham (MaSP, TenSP, GiaSP, MoTa, PhanLoai, NhaSanXuat, SoLuongConLai, SoLuongToiDa)
VALUES 
    ('SP0001', N'Áo thun Nam', 250000, N'Áo thun cotton cao cấp cho nam, thoáng mát.', N'Quần áo', N'Thời trang ABC', 100, 200),
    ('SP0002', N'Áo sơ mi Nữ', 300000, N'Áo sơ mi nữ thời trang, phù hợp với công sở.', N'Quần áo', N'Thời trang XYZ', 150, 300),
    ('SP0003', N'Giày thể thao', 600000, N'Giày thể thao nam, đế êm, hỗ trợ chạy bộ.', N'Thể thao', N'Nike', 50, 100),
    ('SP0004', N'Máy tính xách tay', 15000000, N'Máy tính xách tay HP, RAM 8GB, ổ cứng SSD 512GB.', N'Công nghệ', N'HP', 30, 50),
    ('SP0005', N'Tai nghe Bluetooth', 900000, N'Tai nghe Bluetooth chất lượng cao, âm thanh sống động.', N'Phụ kiện', N'Sony', 200, 400),
    ('SP0006', N'Thiết bị phát Wi-Fi', 1200000, N'Thiết bị phát Wi-Fi tốc độ cao, dùng cho văn phòng hoặc gia đình.', N'Công nghệ', N'TP-Link', 80, 160),
    ('SP0007', N'Loa Bluetooth', 650000, N'Loa Bluetooth di động, âm thanh mạnh mẽ, dễ dàng kết nối.', N'Phụ kiện', N'JBL', 120, 240),
    ('SP0008', N'Chảo chống dính', 350000, N'Chảo chống dính cao cấp, dễ dàng vệ sinh.', N'Gia dụng', N'Tefal', 150, 300),
    ('SP0009', N'Máy pha cà phê', 2500000, N'Máy pha cà phê Espresso, phù hợp cho gia đình và văn phòng.', N'Gia dụng', N'Delonghi', 60, 120),
    ('SP0010', N'Tủ lạnh 2 cửa', 5000000, N'Tủ lạnh 2 cửa, dung tích 300L, tiết kiệm điện.', N'Gia dụng', N'Samsung', 40, 80),
    ('SP0011', N'Điện thoại di động', 8000000, N'Điện thoại thông minh, màn hình 6.5 inch, RAM 6GB.', N'Công nghệ', N'Samsung', 120, 250),
    ('SP0012', N'Váy đầm Nữ', 450000, N'Váy đầm thời trang, thích hợp cho dạo phố hoặc tiệc tùng.', N'Quần áo', N'Thời trang XYZ', 200, 400),
    ('SP0013', N'Bình nước giữ nhiệt', 250000, N'Bình giữ nhiệt inox, giữ nóng lạnh lâu.', N'Phụ kiện', N'Shopee', 250, 500),
    ('SP0014', N'Bàn phím cơ', 1000000, N'Bàn phím cơ gaming, độ bền cao, cảm giác gõ tốt.', N'Phụ kiện', N'Corsair', 100, 200),
    ('SP0015', N'Máy xay sinh tố', 1200000, N'Máy xay sinh tố, công suất mạnh mẽ, dễ dàng sử dụng.', N'Gia dụng', N'Oster', 180, 360),
    ('SP0016', N'Bộ đồ thể thao', 500000, N'Bộ đồ thể thao nam, vải thoáng mát, thoải mái khi tập luyện.', N'Quần áo', N'Reebok', 300, 600),
    ('SP0017', N'Máy giặt', 7000000, N'Máy giặt cửa trên, công nghệ Inverter, tiết kiệm điện.', N'Gia dụng', N'LG', 50, 100),
    ('SP0018', N'Túi xách nữ', 800000, N'Túi xách nữ, thiết kế thời trang, phù hợp với nhiều phong cách.', N'Phụ kiện', N'Charles & Keith', 220, 440),
    ('SP0019', N'Kính mát', 250000, N'Kính mát thời trang, chống UV tốt, phù hợp cho mùa hè.', N'Phụ kiện', N'Oakley', 200, 400),
    ('SP0020', N'Bàn là', 400000, N'Bàn là hơi nước, làm thẳng quần áo nhanh chóng, dễ sử dụng.', N'Gia dụng', N'Philips', 150, 300),
    ('SP0021', N'Kệ sách', 600000, N'Kệ sách gỗ, thiết kế hiện đại, phù hợp cho không gian phòng khách.', N'Gia dụng', N'IKEA', 90, 180),
    ('SP0022', N'Áo khoác Nam', 700000, N'Áo khoác nam dày dặn, ấm áp cho mùa đông.', N'Quần áo', N'Mercedes', 180, 360),
    ('SP0023', N'Giày cao gót Nữ', 550000, N'Giày cao gót nữ, thiết kế tinh tế, phù hợp với nhiều kiểu trang phục.', N'Quần áo', N'Christian Louboutin', 150, 300),
    ('SP0024', N'Máy chiếu', 3500000, N'Máy chiếu mini, kết nối Bluetooth, chất lượng hình ảnh 4K.', N'Công nghệ', N'Epson', 40, 80),
    ('SP0025', N'Áo khoác nữ', 800000, N'Áo khoác nữ, thiết kế trẻ trung, phù hợp với mùa lạnh.', N'Quần áo', N'Uniqlo', 200, 400),
    ('SP0026', N'Bộ đồ bơi', 350000, N'Bộ đồ bơi nữ, thiết kế thời trang, thoải mái khi bơi.', N'Quần áo', N'Aerie', 250, 500),
    ('SP0027', N'Máy nướng bánh mì', 700000, N'Máy nướng bánh mì, công suất mạnh, nướng nhanh và đều.', N'Gia dụng', N'Tefal', 80, 160),
    ('SP0028', N'Loa kéo', 1200000, N'Loa kéo di động, âm thanh mạnh mẽ, phù hợp cho các buổi tiệc ngoài trời.', N'Phụ kiện', N'Sony', 90, 180),
    ('SP0029', N'Thiết bị định vị GPS', 1500000, N'Thiết bị định vị GPS, hỗ trợ di chuyển chính xác.', N'Công nghệ', N'Garmin', 60, 120),
    ('SP0030', N'Bàn làm việc', 2000000, N'Bàn làm việc văn phòng, thiết kế đơn giản, tiết kiệm không gian.', N'Gia dụng', N'IKEA', 100, 200),
    ('SP0031', N'Tivi 4K', 10000000, N'Tivi LED 4K, màn hình rộng, chất lượng hình ảnh sắc nét.', N'Công nghệ', N'Samsung', 30, 60),
    ('SP0032', N'Sữa rửa mặt', 250000, N'Sữa rửa mặt làm sạch da, phù hợp với mọi loại da.', N'Mỹ phẩm', N'Lancome', 500, 1000),
    ('SP0033', N'Kem dưỡng da', 500000, N'Kem dưỡng da ban đêm, giúp da mềm mại và trắng sáng.', N'Mỹ phẩm', N'Sk-II', 300, 600),
    ('SP0034', N'Quạt điều hòa', 3000000, N'Quạt điều hòa, làm mát nhanh chóng, tiết kiệm điện.', N'Gia dụng', N'Sanyo', 50, 100),
    ('SP0035', N'Bàn phím không dây', 600000, N'Bàn phím không dây, kết nối Bluetooth, thích hợp cho các thiết bị di động.', N'Phụ kiện', N'Logitech', 120, 240),
    ('SP0036', N'Giày boots', 800000, N'Giày boots nữ, thiết kế mạnh mẽ, ấm áp cho mùa đông.', N'Quần áo', N'UGG', 100, 200),
    ('SP0037', N'Kệ treo tường', 350000, N'Kệ treo tường bằng gỗ, thiết kế hiện đại và tiện lợi.', N'Gia dụng', N'Home24', 200, 400),
    ('SP0038', N'Bình sữa', 200000, N'Bình sữa cho bé, chất liệu an toàn, dễ sử dụng.', N'Mẹ & Bé', N'Pigeon', 300, 600),
    ('SP0039', N'Áo sơ mi Nam', 400000, N'Áo sơ mi nam thời trang, thiết kế đơn giản, phù hợp cho công sở.', N'Quần áo', N'Thời trang XYZ', 150, 300),
    ('SP0040', N'Bình giữ nhiệt', 250000, N'Bình giữ nhiệt inox, giữ nhiệt lâu.', N'Phụ kiện', N'Thermos', 250, 500),
    ('SP0041', N'Máy cắt tóc', 800000, N'Máy cắt tóc, dễ sử dụng, hiệu quả nhanh chóng.', N'Phụ kiện', N'Panasonic', 100, 200),
    ('SP0042', N'Kính áp tròng', 300000, N'Kính áp tròng thời trang, dễ chịu, phù hợp cho mọi dịp.', N'Phụ kiện', N'Bausch & Lomb', 200, 400),
    ('SP0043', N'Khẩu trang', 50000, N'Khẩu trang y tế, bảo vệ sức khỏe.', N'Phụ kiện', N'3M', 1000, 2000),
    ('SP0044', N'Stand cho điện thoại', 150000, N'Stand điện thoại tiện lợi, giúp sử dụng điện thoại dễ dàng hơn.', N'Phụ kiện', N'MobileFun', 300, 600),
    ('SP0045', N'Bình lọc nước', 800000, N'Bình lọc nước gia đình, công nghệ lọc sạch, đảm bảo sức khỏe.', N'Gia dụng', N'Aquafina', 100, 200),
    ('SP0046', N'Máy làm kem', 1500000, N'Máy làm kem tự động, làm kem tươi tại nhà.', N'Gia dụng', N'Samsung', 60, 120),
    ('SP0047', N'Chổi quét nhà', 50000, N'Chổi quét nhà, thiết kế tiện dụng, dễ dàng vệ sinh nhà cửa.', N'Gia dụng', N'Pigeon', 300, 600),
    ('SP0048', N'Máy lọc không khí', 3000000, N'Máy lọc không khí, giúp loại bỏ bụi bẩn và vi khuẩn.', N'Gia dụng', N'LG', 50, 100),
    ('SP0049', N'Bàn chải điện', 800000, N'Bàn chải điện giúp làm sạch răng miệng hiệu quả.', N'Mỹ phẩm', N'Oral-B', 150, 300),
    ('SP0050', N'Giày thể thao nữ', 650000, N'Giày thể thao nữ, thiết kế thời trang, phù hợp với mọi hoạt động.', N'Quần áo', N'Adidas', 180, 360);

-- Nạp dữ liệu vào bảng KhuyenMai
INSERT INTO KhuyenMai (MaKhuyenMai, TenKhuyenMai, LoaiKhuyenMai, ThoiGianBatDau, ThoiGianKetThuc)
VALUES 
    ('KM0001', N'Flash Sale Áo Thun Nam', N'Flash-sale', '2023-01-01', '2023-01-07'),
    ('KM0002', N'Combo Sale Giày và Áo', N'Combo-sale', '2023-02-01', '2023-02-15'),
    ('KM0003', N'Member Sale Cho Khách Kim Cương', N'Member-sale', '2023-03-01', '2023-03-31'),
    ('KM0004', N'Flash Sale Điện Thoại', N'Flash-sale', '2023-04-01', '2023-04-07'),
    ('KM0005', N'Combo Sale Tai Nghe và Loa', N'Combo-sale', '2023-05-01', '2023-05-10'),
    ('KM0006', N'Member Sale Cho Khách Bạch Kim', N'Member-sale', '2023-06-01', '2023-06-30'),
    ('KM0007', N'Flash Sale Máy Tính Xách Tay', N'Flash-sale', '2023-07-01', '2023-07-15'),
    ('KM0008', N'Combo Sale Tivi và Loa', N'Combo-sale', '2023-08-01', '2023-08-15'),
    ('KM0009', N'Member Sale Cho Khách Vàng', N'Member-sale', '2023-09-01', '2023-09-30'),
    ('KM0010', N'Flash Sale Tủ Lạnh', N'Flash-sale', '2023-10-01', '2023-10-07');

-- Nạp dữ liệu vào bảng DonHang
INSERT INTO DonHang (MaDonHang, MaKhachHang, GiamGiaTheoPhieu, ThoiGianMua)
VALUES 
    ('DH0001', '0901234567', 1200000, '2023-01-10 14:30:00'),  -- Khách hàng Kim cương
    ('DH0002', '0902345678', 700000, '2023-02-15 16:00:00'),   -- Khách hàng Bạch kim
    ('DH0003', '0903456789', 500000, '2023-03-20 10:15:00'),   -- Khách hàng Vàng
    ('DH0004', '0904567890', 200000, '2023-04-05 18:00:00'),   -- Khách hàng Bạc
    ('DH0005', '0905678901', 100000, '2023-05-12 11:45:00'),   -- Khách hàng Đồng
    ('DH0006', '0907890123', 1200000, '2023-06-02 13:30:00'),   -- Khách hàng Kim cương
    ('DH0007', '0908901234', 700000, '2023-07-18 15:30:00'),   -- Khách hàng Bạch kim
    ('DH0008', '0909012345', 500000, '2023-08-01 17:00:00'),   -- Khách hàng Vàng
    ('DH0009', '0910123456', 200000, '2023-09-22 12:30:00'),   -- Khách hàng Bạc
    ('DH0010', '0911234567', 100000, '2023-10-10 14:45:00'),   -- Khách hàng Đồng
    ('DH0011', '0901234567', 1200000, '2023-01-25 09:00:00'),   -- Khách hàng Kim cương
    ('DH0012', '0902345678', 700000, '2023-02-10 16:45:00'),   -- Khách hàng Bạch kim
    ('DH0013', '0903456789', 500000, '2023-03-15 10:30:00'),   -- Khách hàng Vàng
    ('DH0014', '0904567890', 200000, '2023-04-03 19:15:00'),   -- Khách hàng Bạc
    ('DH0015', '0905678901', 100000, '2023-05-06 13:00:00'),   -- Khách hàng Đồng
    ('DH0016', '0907890123', 1200000, '2023-06-10 10:00:00'),   -- Khách hàng Kim cương
    ('DH0017', '0908901234', 700000, '2023-07-20 12:30:00'),   -- Khách hàng Bạch kim
    ('DH0018', '0909012345', 500000, '2023-08-05 11:00:00'),   -- Khách hàng Vàng
    ('DH0019', '0910123456', 200000, '2023-09-28 13:15:00'),   -- Khách hàng Bạc
    ('DH0020', '0911234567', 100000, '2023-10-14 10:30:00');   -- Khách hàng Đồng

-- Nạp dữ liệu vào bảng ChiTietDonHang
INSERT INTO ChiTietDonHang (MaDonHang, MaSanPham, Gia, SoLuong)
VALUES 
    ('DH0001', 'SP0001', 250000, 2),   -- Áo thun Nam, 2 chiếc
    ('DH0001', 'SP0003', 600000, 1),   -- Giày thể thao, 1 đôi
    ('DH0002', 'SP0002', 300000, 3),   -- Áo sơ mi Nữ, 3 chiếc
    ('DH0002', 'SP0004', 15000000, 1), -- Máy tính xách tay, 1 chiếc
    ('DH0003', 'SP0005', 900000, 2),   -- Tai nghe Bluetooth, 2 chiếc
    ('DH0003', 'SP0008', 350000, 1),   -- Chảo chống dính, 1 chiếc
    ('DH0004', 'SP0011', 8000000, 1),  -- Điện thoại di động, 1 chiếc
    ('DH0004', 'SP0010', 5000000, 1),  -- Tủ lạnh 2 cửa, 1 chiếc
    ('DH0005', 'SP0006', 1200000, 1),  -- Thiết bị phát Wi-Fi, 1 chiếc
    ('DH0005', 'SP0012', 450000, 2),   -- Váy đầm Nữ, 2 chiếc
    ('DH0006', 'SP0013', 250000, 3),   -- Bình nước giữ nhiệt, 3 bình
    ('DH0006', 'SP0015', 1200000, 1),  -- Máy xay sinh tố, 1 chiếc
    ('DH0007', 'SP0020', 400000, 1),   -- Bàn là, 1 chiếc
    ('DH0007', 'SP0035', 600000, 1),   -- Bàn phím không dây, 1 chiếc
    ('DH0008', 'SP0025', 800000, 2),   -- Áo khoác nữ, 2 chiếc
    ('DH0008', 'SP0031', 10000000, 1), -- Tivi 4K, 1 chiếc
    ('DH0009', 'SP0022', 700000, 1),   -- Áo khoác Nam, 1 chiếc
    ('DH0009', 'SP0042', 300000, 1),   -- Kính áp tròng, 1 đôi
    ('DH0010', 'SP0033', 500000, 2),   -- Kem dưỡng da, 2 hộp
    ('DH0010', 'SP0040', 250000, 3);   -- Bình giữ nhiệt, 3 bình

-- Nạp dữ liệu vào bảng ChiTietKhuyenMai
INSERT INTO ChiTietKhuyenMai (MaKhuyenMai, MaSP, SanPham1, SanPham2, GiaTriGiamGia, SoLuongToiDa)
VALUES 
    ('KM0001', 'SP0001', 'SP0001', NULL, 100000, 50),   -- Flash Sale Áo Thun Nam, giảm 100k, tối đa 50 sản phẩm
    ('KM0001', 'SP0003', 'SP0003', NULL, 150000, 30),   -- Flash Sale Giày thể thao, giảm 150k, tối đa 30 sản phẩm
    ('KM0002', 'SP0002', 'SP0002', 'SP0001', 200000, 40),   -- Combo Sale Áo sơ mi Nữ và Áo thun Nam, giảm 200k, tối đa 40 bộ combo
    ('KM0002', 'SP0004', 'SP0004', 'SP0005', 500000, 20),   -- Combo Sale Máy tính xách tay và Tai nghe Bluetooth, giảm 500k, tối đa 20 bộ combo
    ('KM0003', 'SP0006', 'SP0006', NULL, 100000, 50),   -- Member Sale Cho Khách Kim Cương, giảm 100k, tối đa 50 sản phẩm
    ('KM0003', 'SP0012', 'SP0012', NULL, 150000, 40),   -- Member Sale Cho Khách Kim Cương, giảm 150k, tối đa 40 sản phẩm
    ('KM0004', 'SP0011', 'SP0011', NULL, 500000, 30),   -- Flash Sale Điện thoại di động, giảm 500k, tối đa 30 sản phẩm
    ('KM0004', 'SP0031', 'SP0031', NULL, 1000000, 25),   -- Flash Sale Tivi 4K, giảm 1 triệu, tối đa 25 sản phẩm
    ('KM0005', 'SP0020', 'SP0020', 'SP0025', 300000, 20),   -- Combo Sale Bàn là và Áo khoác nữ, giảm 300k, tối đa 20 bộ combo
    ('KM0005', 'SP0033', 'SP0033', 'SP0031', 400000, 10),   -- Combo Sale Kem dưỡng da và Tivi 4K, giảm 400k, tối đa 10 bộ combo
    ('KM0006', 'SP0009', 'SP0009', NULL, 150000, 50),   -- Member Sale Cho Khách Bạch Kim, giảm 150k, tối đa 50 sản phẩm
    ('KM0006', 'SP0028', 'SP0028', NULL, 200000, 30),   -- Member Sale Cho Khách Bạch Kim, giảm 200k, tối đa 30 sản phẩm
    ('KM0007', 'SP0007', 'SP0007', NULL, 100000, 30),   -- Flash Sale Loa Bluetooth, giảm 100k, tối đa 30 sản phẩm
    ('KM0007', 'SP0035', 'SP0035', NULL, 150000, 40),   -- Flash Sale Bàn phím không dây, giảm 150k, tối đa 40 sản phẩm
    ('KM0008', 'SP0039', 'SP0039', 'SP0041', 200000, 20),   -- Combo Sale Áo sơ mi Nam và Máy cắt tóc, giảm 200k, tối đa 20 bộ combo
    ('KM0008', 'SP0040', 'SP0040', 'SP0042', 250000, 10),   -- Combo Sale Bình giữ nhiệt và Kính áp tròng, giảm 250k, tối đa 10 bộ combo
    ('KM0009', 'SP0021', 'SP0021', NULL, 150000, 50),   -- Member Sale Cho Khách Vàng, giảm 150k, tối đa 50 sản phẩm
    ('KM0009', 'SP0045', 'SP0045', NULL, 200000, 40),   -- Member Sale Cho Khách Vàng, giảm 200k, tối đa 40 sản phẩm
    ('KM0010', 'SP0026', 'SP0026', NULL, 150000, 30),   -- Flash Sale Bộ đồ bơi, giảm 150k, tối đa 30 sản phẩm
    ('KM0010', 'SP0046', 'SP0046', NULL, 300000, 20);   -- Flash Sale Máy làm kem, giảm 300k, tối đa 20 sản phẩm

-- Nạp dữ liệu vào bảng PhieuQuaTang
INSERT INTO PhieuQuaTang (MaPhieu, NgayBatDau, NgayKetThuc, GiaTriQuaTang, SDTKhachHang)
VALUES 
    ('PQ0001', '2023-01-01', '2023-12-31', 1200000, '0901234567'),  -- Kim cương
    ('PQ0002', '2023-02-01', '2023-12-31', 700000, '0902345678'),   -- Bạch kim
    ('PQ0003', '2023-03-01', '2023-12-31', 500000, '0903456789'),   -- Vàng
    ('PQ0004', '2023-04-01', '2023-12-31', 200000, '0904567890'),   -- Bạc
    ('PQ0005', '2023-05-01', '2023-12-31', 100000, '0905678901'),   -- Đồng
    ('PQ0006', '2023-06-01', '2023-12-31', 1200000, '0907890123'),   -- Kim cương
    ('PQ0007', '2023-07-01', '2023-12-31', 700000, '0908901234'),   -- Bạch kim
    ('PQ0008', '2023-08-01', '2023-12-31', 500000, '0909012345'),   -- Vàng
    ('PQ0009', '2023-09-01', '2023-12-31', 200000, '0910123456'),   -- Bạc
    ('PQ0010', '2023-10-01', '2023-12-31', 100000, '0911234567');   -- Đồng

-- Nạp dữ liệu vào bảng DonDatKho
INSERT INTO DonDatKho (MaDonDat, TrangThaiGiao, SoLuongDaNhan, SoLuongDat, GiaTriDat, NgayDat, MaSanPham)
VALUES 
    ('DDK0001', N'Đang giao', 50, 100, 5000000, '2023-01-10', 'SP0001'),   -- Đặt hàng cho Áo thun Nam, đã nhận 50 sản phẩm
    ('DDK0002', N'Hoàn thành', 100, 100, 8000000, '2023-02-12', 'SP0002'),  -- Đặt hàng cho Áo sơ mi Nữ, đã nhận đủ
    ('DDK0003', N'Đang giao', 30, 60, 9000000, '2023-03-05', 'SP0003'),   -- Đặt hàng cho Giày thể thao, đã nhận 30 sản phẩm
    ('DDK0004', N'Chưa giao', 0, 80, 4800000, '2023-04-01', 'SP0004'),   -- Đặt hàng cho Máy tính xách tay, chưa giao
    ('DDK0005', N'Hoàn thành', 150, 150, 7500000, '2023-05-20', 'SP0005'),  -- Đặt hàng cho Tai nghe Bluetooth, đã nhận đủ
    ('DDK0006', N'Đang giao', 60, 100, 6000000, '2023-06-03', 'SP0006'),   -- Đặt hàng cho Thiết bị phát Wi-Fi, đã nhận 60 sản phẩm
    ('DDK0007', N'Chưa giao', 0, 50, 10000000, '2023-07-15', 'SP0007'),   -- Đặt hàng cho Loa Bluetooth, chưa giao
    ('DDK0008', N'Hoàn thành', 100, 100, 3000000, '2023-08-10', 'SP0008'),  -- Đặt hàng cho Chảo chống dính, đã nhận đủ
    ('DDK0009', N'Đang giao', 40, 70, 2800000, '2023-09-22', 'SP0009'),   -- Đặt hàng cho Máy pha cà phê, đã nhận 40 sản phẩm
    ('DDK0010', N'Chưa giao', 0, 100, 5000000, '2023-10-05', 'SP0010');   -- Đặt hàng cho Tủ lạnh 2 cửa, chưa giao
