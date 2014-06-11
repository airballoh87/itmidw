IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'itmidw.[usp_Study102CrfTranslationFieldOptions]') AND type in (N'P', N'PC'))
DROP PROCEDURE itmidw.[usp_Study102CrfTranslationFieldOptions]
GO
/**************************************************************************
Created ON : 4/12/2014
Created By : AarON Black
Team Name : Informatics
Object name : [usp_Study102CrfTranslationFieldOptions]
Functional : ITMI SSIS for Insert AND Update for study 102 for translating fields from multiple data sources

History : Created ON 4/12/2014
**************************************************************************
Date Modified By QC# Purposes
**************************************************************************
#Date #Comment
**************************************************************************
USE CASE:
EXEC [usp_Study102CrfTranslationFieldOptions]
--TRUNCATe table itmidw.[tblCrfDataDictionary] 
select  * FROM itmidw.[tblCrfDataDictionary] 
***************************s***********************************************/
CREATE PROCEDURE itmidw.[usp_Study102CrfTranslationFieldOptions]
AS
BEGIN
SET NOCOUNT ON;
DECLARE @UpdatedON SMALLDATETIME
SET @UpdatedON = CAST(GETDATE() AS SMALLDATETIME)
PRINT CONVERT(CHAR(23), @UpdatedOn, 121) + ' [usp_Study102CrfTranslationFieldOptions][' + @@SERVERNAME + '][' + SYSTEM_USER + ']'
PRINT 'INSERT [ITMIDW].[usp_Study102CrfTranslationFieldOptions]...'

--*************************************
--***************Truncate and insert***
--*************************************

TRUNCATE TABLE itmidw.[tblCrfTranslationFieldOptions]


INSERT INTO itmidw.[tblCrfTranslationFieldOptions]
   ([CrfTranslationFieldID]
   ,[FieldValue]
   ,[createdBy])
   ,[CodedData]
   ,[Ordinal]
   ,[orgSourceSystemID]
   ,[createDate]
SELECT 
	transF.CrfTranslationFieldID
	, fo.optionLabel
	, fo.optionValue
	, NULL as Ordinal
    ,(SELECT ss.sourceSystemID FROM ITMIDW.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS [orgSourceSystemID]
    ,GETDATE() [createDate]
    ,'usp_Study102CrfTranslationFieldOptions' AS [createdBy]
FROM itmidw.tblcrfFieldOptions fo
	INNER JOIN itmidw.tblCrfTranslationField transF
		ON transF.fieldID = fo.fieldID
	AND fo.orgSourceSystemID  =(SELECT ss.sourceSystemID FROM ITMIDW.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ')



PRINT CAST(@@ROWCOUNT AS VARCHAR(10))+ ' row(s) updated.'



END

