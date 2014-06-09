IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Study102SpecimenType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_Study102SpecimenType]
GO
/**************************************************************************
Created On : 3/29/2014
Created By : Aaron Black
Team Name : Informatics
Object name : [usp_Study102SpecimenType]
Functional : ITMI SSIS for Insert and Update for study 102 tblSpecimen and TblSpecimenType
 SpecimenType
History : Created on 3/29/2014
**************************************************************************
Date Modified By QC# Purposes
**************************************************************************
#Date #Comment
**************************************************************************
USE CASE:
EXEC [usp_Study102SpecimenType]
**************************************************************************/
CREATE PROCEDURE [dbo].[usp_Study102SpecimenType]
AS
BEGIN
SET NOCOUNT ON;
DECLARE @UpdatedOn SMALLDATETIME
SET @UpdatedOn = CAST(GETDATE() AS SMALLDATETIME)
PRINT CONVERT(CHAR(23), @UpdatedOn, 121) + ' [usp_Study102SpecimenType][' + @@SERVERNAME + '][' + SYSTEM_USER + ']'
PRINT 'INSERT [ITMIDW].[dbo].[usp_Study102SpecimenType]...'

--*************************************
--******************102****************
--*************************************
--aliquote
INSERT INTO Itmidw.[dbo].[tblSpecimenSampleType]
           ([specimenTypeName]
           ,[qualificationCategory]
           ,[physicalCategory]
           ,[externalLabel])
     SELECT distinct 
           --(<specimenTypeName, varchar(200),>
		   matrix_type
           --,<qualificationCategory, varchar(20),>
		   , NULL 
           --,<physicalCategory, varchar(20),>
		   , NULL
           --,<externalLabel, varchar(20),>)
		   , NULL
	from [nautilus].[ALIQUOT] al
		inner join nautilus.sample sa
			on sa.SAMPLE_ID = al.SAMPLE_ID
		INNER JOIN [nautilus].[CONTAINER_TYPE] ct
			on ct.CONTAINER_TYPE_ID = al.CONTAINER_TYPE_ID
		INNER JOIN nautilus.[ALIQUOT_TEMPLATe] alTemplate
			on alTemplate.ALIQUOT_TEMPLATE_ID = al.ALIQUOT_TEMPLATE_ID
		LEFT JOIN Itmidw.[dbo].[tblSpecimenSampleType] st
			ON st.specimenTypeName = matrix_type
	WHERE st.specimenTypeName IS NULL


INSERT INTO Itmidw.[dbo].[tblSpecimenSampleType]
           ([specimenTypeName]
           ,[qualificationCategory]
           ,[physicalCategory]
           ,[externalLabel])
     SELECT distinct 
           --(<specimenTypeName, varchar(200),>
		   sa.SAMPLE_TYPE
           --,<qualificationCategory, varchar(20),>
		   , NULL 
           --,<physicalCategory, varchar(20),>
		   , NULL
           --,<externalLabel, varchar(20),>)
		   , NULL
	from nautilus.sample sa
		LEFT JOIN Itmidw.[dbo].[tblSpecimenSampleType] st
			ON st.specimenTypeName = sa.SAMPLE_TYPE
	WHERE st.specimenTypeName IS NULL

END