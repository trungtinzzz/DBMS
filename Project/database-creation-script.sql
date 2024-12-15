CREATE TABLE LoaiKhachHang (
    MaLoaiKhachHang CHAR(10) PRIMARY KEY,
    YeuCauMuaSam INT NOT NULL,
    TenLoai NVARCHAR(100) NOT NULL,
    GiaTriQuaTang INT
);

CREATE TABLE KhachHang (
    SDT CHAR(10) PRIMARY KEY,
    TenKhachHang NVARCHAR(100) NOT NULL,
    NgayDangKy DATE,
    NgaySinhNhat DATE,
    MaLoaiKhachHang CHAR(10),
    FOREIGN KEY (MaLoaiKhachHang) REFERENCES LoaiKhachHang(MaLoaiKhachHang)
);

CREATE TABLE PhieuQuaTang (
    MaPhieu CHAR(15) PRIMARY KEY,
    NgayBatDau DATE,
    NgayKetThuc DATE,
    GiaTriQuaTang INT,
    MaKhachHang CHAR(10),
    FOREIGN KEY (MaKhachHang) REFERENCES KhachHang(SDT)
);

CREATE TABLE SanPham (
    MaSP CHAR(10) PRIMARY KEY,
    TenSP NVARCHAR(100) NOT NULL,
    GiaSP INT,
    MoTa NVARCHAR(200),
    PhanLoai NVARCHAR(50),
    NhaSanXuat NVARCHAR(50),
    SoLuongConLai INT,
    SoLuongToiDa INT
);

CREATE TABLE DonHang (
    MaDonHang CHAR(15) PRIMARY KEY,
    MaKhachHang CHAR(10),
    GiamGiaTheoPhieu INT,
    ThoiGianMua DATETIME,
    FOREIGN KEY (MaKhachHang) REFERENCES KhachHang(SDT)
);

CREATE TABLE ChiTietDonHang (
    MaDonHang CHAR(15),
    MaSanPham CHAR(10),
    Gia INT,
    SoLuong INT,
    PRIMARY KEY (MaDonHang, MaSanPham),
    FOREIGN KEY (MaDonHang) REFERENCES DonHang(MaDonHang),
    FOREIGN KEY (MaSanPham) REFERENCES SanPham(MaSP)
);

CREATE TABLE KhuyenMai (
    MaKhuyenMai CHAR(15) PRIMARY KEY,
    TenKhuyenMai NVARCHAR(100),
    LoaiKhuyenMai NVARCHAR(50),
    ThoiGianBatDau DATE,
    ThoiGianKetThuc DATE
);

CREATE TABLE ChiTietKhuyenMai (
    MaKhuyenMai CHAR(15),
    MaSP CHAR(10),
    SanPham1 CHAR(10),
    SanPham2 CHAR(10),
    GiaTriGiamGia INT,
    SoLuongToiDa INT,
    PRIMARY KEY (MaKhuyenMai, MaSP),
    FOREIGN KEY (MaKhuyenMai) REFERENCES KhuyenMai(MaKhuyenMai),
    FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP)
);

CREATE TABLE DonDatKho (
    MaDonDat CHAR(15) PRIMARY KEY,
    TrangThaiGiao NVARCHAR(50),
    SoLuongDaNhan INT,
    SoLuongDat INT,
    GiaTriDat INT,
    NgayDat DATE,
    SanPham NVARCHAR(50),
    NhaSanXuat NVARCHAR(100),
    MaSanPham CHAR(10),
    FOREIGN KEY (MaSanPham) REFERENCES SanPham(MaSP)
);
