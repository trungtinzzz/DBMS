﻿USE QLPK_CSDL
GO

--XEM THÔNG TIN CÁ NHÂN HỒ SƠ BỆNH NHÂN CÓ BÁC SĨ MẶC ĐỊNH
GO
CREATE OR ALTER PROC xemchitiethosobenhnhan @IDBENHNHAN CHAR(8)
AS
BEGIN
	BEGIN TRY
		BEGIN TRAN
			IF (@IDBENHNHAN IS NULL)
			BEGIN
				PRINT N'KHÔNG TÌM THẤY NGƯỜI DÙNG'
				ROLLBACK TRAN
				RETURN;
			END
			DECLARE @TONGTIENDATRA FLOAT
			SELECT @TONGTIENDATRA = SUM(TONGTIEN)
			FROM HOADON HD
			WHERE HD.IDBENHNHAN = @IDBENHNHAN
			GROUP BY HD.IDBENHNHAN

			DECLARE @TONGTIENDIEUTRI FLOAT
			SELECT @TONGTIENDIEUTRI = SUM(BDT.TONGTIEN)
			FROM BUOIDIEUTRI BDT
			WHERE BDT.BNKHAMLE = @IDBENHNHAN
			GROUP BY BDT.BNKHAMLE

			SELECT BN.*, NV.TENNV, @TONGTIENDIEUTRI AS TONGTIENDIEUTRI, @TONGTIENDATRA AS TONGTIENDATRA
			FROM HOSOBENHNHAN BN
				left JOIN NHANVIEN NV
			ON NV.IDNHANVIEN = BN.BACSIMD 
			WHERE BN.IDBENHNHAN = @IDBENHNHAN
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		PRINT N'LỖI HỆ THỐNG'
		ROLLBACK TRAN
		RETURN;
	END CATCH
END
GO
--EXEC xemchitiethosobenhnhan 'BN100001'
GO
CREATE OR ALTER PROC timhosobenhnhanquaten @TEN NVARCHAR(50)
AS
BEGIN
	BEGIN TRY
		BEGIN TRAN
			IF (@TEN IS NULL)
			BEGIN
				PRINT N'KHÔNG CÓ THÔNG TIN TÌM KIẾM'
				ROLLBACK TRAN
				RETURN;
			END
			SELECT *
			FROM HOSOBENHNHAN BN
			WHERE BN.TENBN LIKE '%' + @TEN + '%'
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		PRINT N'LỖI HỆ THỐNG'
		ROLLBACK
	END CATCH
END
GO
--EXEC timhosobenhnhanquaten 'toan ti phu'