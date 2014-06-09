IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Study102CrfDataDictionary]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_Study102CrfDataDictionary]
GO
/**************************************************************************
Created ON : 4/12/2014
Created By : AarON Black
Team Name : Informatics
Object name : [usp_Study102CrfDataDictionary]
Functional : ITMI SSIS for Insert AND Update for study 102 crf data dictionary

History : Created ON 4/12/2014
**************************************************************************
Date Modified By QC# Purposes
**************************************************************************
#Date #Comment
**************************************************************************
USE CASE:
EXEC [usp_Study102CrfDataDictionary]
--TRUNCATe table [dbo].[tblCrfDataDictionary] 
select  * FROM [dbo].[tblCrfDataDictionary] 
**************************************************************************/
CREATE PROCEDURE [dbo].[usp_Study102CrfDataDictionary]
AS
BEGIN
SET NOCOUNT ON;
DECLARE @UpdatedON SMALLDATETIME
SET @UpdatedON = CAST(GETDATE() AS SMALLDATETIME)
PRINT CONVERT(CHAR(23), @UpdatedOn, 121) + ' [usp_Study102CrfDataDictionary][' + @@SERVERNAME + '][' + SYSTEM_USER + ']'
PRINT 'INSERT [ITMIDW].[dbo].[usp_Study102CrfDataDictionary]...'

--*************************************
--******************102****************
--*************************************
--DD values insert



INSERT INTO [dbo].[tblCrfDataDictionary]
           (
            [questionText]
           ,[preferredFieldName]
		   ,[orgSourceSystemID]
           ,[createDate]
           ,[createdBy])
select  
	MAX(transF.questionText) as QuestionText
	, transF.preferredFieldName as preferredName
   , (SELECT ss.sourceSystemID FROM DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS [orgSourceSystemID]
    , GETDATE() [createDate]
    ,'usp_Study102CrfDataDictionary' AS [createdBy]
--select *
FROM [tblCrfTranslationField] transF
	INNER JOIN tblcrfversion vers
		ON vers.crfVersionID = transF.crfVersionID
	INNER JOIN tblStudy study
		ON study.studyID = transF.studyID
	INNER JOIN dbo.tblcrf crf
		ON crf.crfID = vers.crfID
	LEFT JOIN [dbo].[tblCrfDataDictionary] dd
		ON dd.preferredFieldName = transF.preferredFieldName
WHERE transF.preferredFieldName IS NOT NULL
	AND dd.crfDataDictionaryID IS NULL --only bringing in new records that are not in DD already
GROUP BY transF.preferredFieldName
	
END


