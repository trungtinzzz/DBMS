﻿--DEMO
--LICH HEN---
EXEC SP_XEM_LICH_HEN_BN 'BN005521', '2020-10-04'

EXEC SP_XEM_LICH_HEN_PK 'P01', '2023-12-09' 

--BUOI DIEU TRI VA KE HOACH DIEU TRI----
EXEC LAYBUOIDT_BN 'BN030190'				--INDEX BN_NGAY

EXEC LAYBUOIDT_NGAY '2023-12-7','2023-12-1' -- INDEX BUOIDT_NGAY

--ON LICHHEN;
DROP INDEX LICHHEN_PHONGKHAM_NGAYHEN
ON LICHHEN;

DROP INDEX LICHHEN_BENHNHAN_NGAYHEN
ON LICHHEN;

--ĐIỀU TRỊ
DROP INDEX BDT_NGAY
ON BUOIDIEUTRI;

DROP INDEX BDT_BN_NGAY
ON BUOIDIEUTRI;

--TẠO INDEX
--LỊCH HẸN
CREATE NONCLUSTERED INDEX LICHHEN_BENHNHAN_NGAYHEN
ON LICHHEN (BENHNHAN DESC, NGAYHEN DESC)

CREATE NONCLUSTERED INDEX LICHHEN_PHONGKHAM_NGAYHEN
ON LICHHEN (PHONG DESC, NGAYHEN DESC)

--BUỔI ĐIỀU TRỊ
CREATE NONCLUSTERED INDEX BDT_BN_NGAY
ON BUOIDIEUTRI (BNKHAMLE DESC,NGAYDT DESC)

CREATE NONCLUSTERED INDEX BDT_NGAY
ON BUOIDIEUTRI (NGAYDT DESC)