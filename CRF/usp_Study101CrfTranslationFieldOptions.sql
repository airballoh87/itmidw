IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'itmidw.[usp_Study101CrfTranslationFieldOptions]') AND type in (N'P', N'PC'))
DROP PROCEDURE itmidw.[usp_Study101CrfTranslationFieldOptions]
GO
/**************************************************************************
Created ON : 4/12/2014
Created By : AarON Black
Team Name : Informatics
Object name : [usp_Study101CrfTranslationFieldOptions]
Functional : ITMI SSIS for Insert AND Update for study 102 for translating fields from multiple data sources

History : Created ON 4/12/2014
**************************************************************************
Date Modified By QC# Purposes
**************************************************************************
#Date #Comment
**************************************************************************
USE CASE:
EXEC [usp_Study101CrfTranslationFieldOptions]
--TRUNCATe table itmidw.[tblCrfDataDictionary] 
select  * FROM itmidw.[tblCrfDataDictionary] 
**************************************************************************/
CREATE PROCEDURE itmidw.[usp_Study101CrfTranslationFieldOptions]
AS
BEGIN
SET NOCOUNT ON;
DECLARE @UpdatedON SMALLDATETIME
SET @UpdatedON = CAST(GETDATE() AS SMALLDATETIME)
PRINT CONVERT(CHAR(23), @UpdatedOn, 121) + ' [usp_Study101CrfTranslationFieldOptions][' + @@SERVERNAME + '][' + SYSTEM_USER + ']'
PRINT 'INSERT [ITMIDW].itmidw.[usp_Study101CrfTranslationFieldOptions]...'

--*************************************
--******************102****************
--*************************************

DELETE FROM itmidw.[tblCrfTranslationFieldOptions] WHERE orgSourceSystemID = (SELECT ss.sourceSystemID FROM ITMIDW.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'INFOPATH')

--*************************************
--*************Insert *****************
--*************************************

INSERT INTO itmidw.[tblCrfTranslationFieldOptions]
   ([CrfTranslationFieldID]
   ,[FieldValue]
   ,[CodedData]
   ,[Ordinal]
   ,[orgSourceSystemID]
   ,[createDate]
   ,[createdBy])
SELECT 
	transF.CrfTranslationFieldID
	,fo.optionLabel
	,fo.optionValue
	,NULL AS Ordinal
    ,(SELECT ss.sourceSystemID FROM ITMIDW.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'INFOPATH') AS [orgSourceSystemID]
    ,GETDATE() [createDate]
    ,'usp_Study101CrfTranslationFieldOptions' AS [createdBy]
FROM itmidw.tblcrfFieldOptions fo
	INNER JOIN itmidw.tblCrfTranslationField transF
		ON transF.fieldID = fo.fieldID
	WHERE fo.orgSourceSystemID  =(SELECT ss.sourceSystemID FROM ITMIDW.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'INFOPATH')


	PRINT CAST(@@ROWCOUNT AS VARCHAR(10))+ ' row(s) updated.'

END

