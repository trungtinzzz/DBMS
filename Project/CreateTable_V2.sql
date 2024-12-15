USE master;
CREATE DATABASE DBMS;
GO
USE DBMS;
GO

-- DROP TABLE IF EXISTS LoaiKhachHang;
CREATE TABLE LoaiKhachHang (
    MaLoaiKhachHang CHAR(10) PRIMARY KEY,
    YeuCauMuaSam INT,
    TenLoai NVARCHAR(100) NOT NULL,
    GiaTriQuaTang INT CHECK (GiaTriQuaTang >= 0)
);

-- DROP TABLE IF EXISTS KhachHang;
CREATE TABLE KhachHang (
    SDT CHAR(10) PRIMARY KEY,
    TenKhachHang NVARCHAR(100) NOT NULL,
    NgayDangKy DATE,
    NgaySinhNhat DATE,
    MaLoaiKhachHang CHAR(10),
    FOREIGN KEY (MaLoaiKhachHang) REFERENCES LoaiKhachHang(MaLoaiKhachHang)
);

-- DROP TABLE IF EXISTS PhieuQuaTang;
CREATE TABLE PhieuQuaTang (
    MaPhieu CHAR(15) PRIMARY KEY,
    NgayBatDau DATE,
    NgayKetThuc DATE CHECK (NgayBatDau < NgayKetThuc),
    GiaTriQuaTang INT CHECK (GiaTriQuaTang >= 0),
    SDTKhachHang CHAR(10),
    FOREIGN KEY (SDTKhachHang) REFERENCES KhachHang(SDT)
);

-- DROP TABLE IF EXISTS SanPham;
CREATE TABLE SanPham (
    MaSP CHAR(10) PRIMARY KEY,
    TenSP NVARCHAR(100) NOT NULL,
    GiaSP INT,
    MoTa NVARCHAR(200),
    PhanLoai NVARCHAR(50),
    NhaSanXuat NVARCHAR(50),
    SoLuongConLai INT CHECK (SoLuongConLai >= 0),
    SoLuongToiDa INT CHECK (SoLuongToiDa >= 0)
);

-- DROP TABLE IF EXISTS DonHang;
CREATE TABLE DonHang (
    MaDonHang CHAR(15) PRIMARY KEY,
    MaKhachHang CHAR(10),
    GiamGiaTheoPhieu INT,
    ThoiGianMua DATETIME,
    FOREIGN KEY (MaKhachHang) REFERENCES KhachHang(SDT)
);

-- DROP TABLE IF EXISTS ChiTietDonHang;
CREATE TABLE ChiTietDonHang (
    MaDonHang CHAR(15),
    MaSanPham CHAR(10),
    Gia INT,
    SoLuong INT,
    PRIMARY KEY (MaDonHang, MaSanPham),
    FOREIGN KEY (MaDonHang) REFERENCES DonHang(MaDonHang),
    FOREIGN KEY (MaSanPham) REFERENCES SanPham(MaSP)
);

-- DROP TABLE IF EXISTS KhuyenMai;
CREATE TABLE KhuyenMai (
    MaKhuyenMai CHAR(15) PRIMARY KEY,
    TenKhuyenMai NVARCHAR(100),
    LoaiKhuyenMai NVARCHAR(50),
    ThoiGianBatDau DATE,
    ThoiGianKetThuc DATE CHECK (ThoiGianBatDau < ThoiGianKetThuc)
);

-- DROP TABLE IF EXISTS ChiTietKhuyenMai;
CREATE TABLE ChiTietKhuyenMai (
    MaKhuyenMai CHAR(15),
    MaSP CHAR(10),
    SanPham1 CHAR(10),
    SanPham2 CHAR(10),
    GiaTriGiamGia INT CHECK (GiaTriGiamGia >= 0),
    SoLuongToiDa INT CHECK (SoLuongToiDa >= 0),
    PRIMARY KEY (MaKhuyenMai, MaSP),
    FOREIGN KEY (MaKhuyenMai) REFERENCES KhuyenMai(MaKhuyenMai),
    FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP)
);

-- DROP TABLE IF EXISTS DonDatKho;
CREATE TABLE DonDatKho (
    MaDonDat CHAR(15) PRIMARY KEY,
    TrangThaiGiao NVARCHAR(50),
    SoLuongDaNhan INT CHECK (SoLuongDaNhan >= 0),
    SoLuongDat INT CHECK (SoLuongDat >= 0),
    GiaTriDat INT CHECK (GiaTriDat >= 0),
    NgayDat DATE,
    MaSanPham CHAR(10),
    FOREIGN KEY (MaSanPham) REFERENCES SanPham(MaSP)
);


