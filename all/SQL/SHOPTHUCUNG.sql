CREATE DATABASE SHOPTHUCUNG
GO
USE SHOPTHUCUNG
Go
----------Tạo Bảng -tạo Khóa Chính --Tạo Kháo Phụ Cho Bản--
set dateformat dmy
create table NhaSanXuat
(
	MaNSX int not null primary key identity,
	TenNSX nvarchar(255),
	DiaChi nvarchar(255),
	SDT varchar(12)
)
create table LoaiSanPham
(
	MaLoaiSP int primary key identity,
	TenLoaiSP nvarchar(MAX),
)
create table SanPham
(
	MaSP int not null primary key identity,
	TenSP nvarchar(255),
	HinhAnh nvarchar(MAX),
	DonGia decimal(18,0),
	SoLuongTon int,
	DaBan int,
	MaNSX int,
	MaLoaiSP int,
	foreign key (MaNSX) references NhaSanXuat(MaNSX) on delete cascade,
	foreign key (MaLoaiSP) references LoaiSanPham(MaLoaiSP),
)
create table NhanVien
(
	MaNV nvarchar(30) primary key not null,
	HoTen nvarchar(100),
	DiaChi nvarchar(255),
	NgaySinh datetime,
	ChucVu nvarchar(50),
	Luong int,
	SoDienThoai nvarchar(20),
)
create table TaiKhoan
(
	MaTK int identity primary key not null,
	TK nvarchar(50),
	MK varchar(50),
	MaNV nvarchar(30),
	Quyen nvarchar(10),
	TrangThai nvarchar(10),
	foreign key (MaNV) references NhanVien(MaNV) on delete cascade
)
create table KhachHang
(
	MaKH int identity primary key not null,
	Hoten nvarchar(255),
	DiaChi nvarchar(255),
	NgaySinh datetime,
	SoDienThoai nvarchar(20),
)
create table PhieuNhap
(
	MaPN int not null primary key identity,
	MaNSX int,
	NgayNhap datetime,
	foreign key (MaNSX) references NhaSanXuat(MaNSX) on delete cascade,
)
create table ChiTietPhieuNhap
(
	MaChiTietPN int not null primary key identity,
	MaPN int,
	MaSP int,
	DonGiaNhap decimal(18,0),
	SoLuongNhap int,
	foreign key (MaPN) references PhieuNhap(MaPN) on delete cascade,
	foreign key (MaSP) references SanPham(MaSP)
)
create table HoaDon
(
	MaHD nvarchar(10) primary key not null,
	NgayBan datetime,
	MaKH int,
	MaNV nvarchar(30),
	TongTien decimal(18,0),
	foreign key (MaKH) references KhachHang(MaKH) on delete cascade,
	foreign key (MaNV) references NhanVien(MaNV) on delete cascade,
)
create table ChiTietHoaDon
(
	MaCTHD int identity primary key not null,
	MaHD nvarchar(10),
	MaSP int,
	TenSP nvarchar(255),
	SoLuong int,
	DonGia decimal(18,0),
	foreign key (MaHD) references HoaDon(MaHD) on delete cascade,
	foreign key (MaSP) references SanPham(MaSP) on delete cascade,
)

---Thêm Dữ Liệu Bản Tài Khoản--
insert into TaiKhoan values('admin','123',null,'Admin','Offline')


---Thủ Tục sửa Hóa Đơn----
CREATE PROC UPDATE_HD (@MaHD nvarchar(10), @NgayBan datetime, @MaKH int, @MaNV nvarchar(30), @TongTien decimal(18,0))
AS
BEGIN
     UPDATE HoaDon SET MaHD=@MaHD,MaNV=@MaNV,NgayBan=@NgayBan,TongTien=@TongTien Where MaHD=@MaHD
END
GO
----------Thủ Tục Xóa Hóa Đơn--
CREATE PROC DELETE_DH (@MaHD nvarchar(10))
AS
BEGIN
     DELETE FROM HoaDon WHERE MaHD = @MaHD
END
GO

--------------TRIGGER------------
---thêm hóa đơn khách hàng
CREATE PROC INSERT_HD_KH(@MaHD nvarchar(10),@NgayBan datetime,@MaKH int,@MaNV nvarchar(30),@TongTien decimal(18,0)) 
AS 
BEGIN 
INSERT INTO HoaDon (MaHD, NgayBan, MaKH, MaNV, TongTien) VALUES (@MaHD, @NgayBan, @MaKH, @MaNV,@TongTien) 
END 
GO
--Trigger cập nhật số lượng sản phẩm sau khi lập hóa đơn 
CREATE TRIGGER capnhatsanpham ON ChiTietHoaDon FOR INSERT 
AS 
BEGIN UPDATE SanPham SET SoLuongTon = SoLuongTon - (SELECT DaBan FROM inserted WHERE SanPham.MaSP=MaSP) 
FROM SanPham 
JOIN inserted ON SanPham.MaSP = inserted.MaSP 
END 
GO
--Trigger cập nhật số lượng sản phẩm sau khi lập hóa đơn
CREATE TRIGGER capnhatsanpham ON ChiTietHoaDon FOR INSERT 
AS 
BEGIN UPDATE SanPham SET SoLuongTon = SoLuongTon + (SELECT DaBan FROM inserted WHERE SanPham.MaSP = MaSP) 
FROM SanPham 
JOIN inserted ON SanPham.MaSP = inserted.MaSP 
END GO

