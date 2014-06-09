IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'itmidw.[usp_Study102CrfTranslationField]') AND type in (N'P', N'PC'))
DROP PROCEDURE itmidw.[usp_Study102CrfTranslationField]
GO
/**************************************************************************
Created ON : 4/12/2014
Created By : AarON Black
Team Name : Informatics
Object name : [usp_Study102CrfTranslationField]
Functional : ITMI SSIS for Insert AND Update for study 102 for translating fields from multiple data sources
this updates the preferred name that helps with flooding the data dictionary tables


History : Created ON 4/12/2014
**************************************************************************
Date Modified By QC# Purposes
**************************************************************************
#Date #Comment
**************************************************************************
USE CASE:
EXEC [usp_Study102CrfTranslationField]
--TRUNCATe table itmidw.[tblCrfDataDictionary] 
select  * FROM itmidw.[tblCrfDataDictionary] 
**************************************************************************/
CREATE PROCEDURE itmidw.[usp_Study102CrfTranslationField]
AS
BEGIN
SET NOCOUNT ON;
DECLARE @UpdatedON SMALLDATETIME
SET @UpdatedON = CAST(GETDATE() AS SMALLDATETIME)
PRINT CONVERT(CHAR(23), @UpdatedOn, 121) + ' [usp_Study102CrfTranslationField][' + @@SERVERNAME + '][' + SYSTEM_USER + ']'
PRINT 'INSERT [ITMIDW].itmidw.[usp_Study102CrfTranslationField]...'

--*************************************
--******************102****************
--*************************************



TRUNCATE TABLE itmidw.[tblCrfTranslationField]
--
INSERT INTO itmidw.[tblCrfTranslationField]
           ([studyID]
           ,[studyName]
           ,[crfID]
           ,[crfType]
           ,[crfVersionName]
           ,[questionText]
           ,[preferredFieldName]
           ,[fieldOrder]
           ,[fieldID]
           ,[fieldName]
           ,[fieldDescription]
           ,[crfVersionID]
           ,[orgSourceSystemID]
           ,[createDate]
           ,[createdBy])
select  DISTINCT
	sub.studyID
	, study.studyName
	, crf.crfID
	, vers.crfVersionName
	, crfA.sourceSystemFieldDataLabel
	, fields.questionText as QuestionText
	, NULL as preferredName
	, fields.crfSourceSystemFieldOrder as FieldOrder
    , fields.fieldID as [fieldID]
    , fields.fieldName as [fieldName]
    , fields.fieldDescription as [fieldDescription]
	, vers.crfVersionID as [crfVersionID]
	, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS [orgSourceSystemID]
    , GETDATE() [createDate]
    ,'usp_Study102CrfTranslationField' AS [createdBy]
FROM itmidw.[tblCrfEventAnswers] crfA
	INNER JOIN itmidw.tblSubject sub
		ON sub.subjectID = crfA.subjectID
	INNER JOIN itmidw.tblStudy study
		ON study.studyID= sub.studyID
	INNER JOIN tblcrfversion vers
		ON vers.crfVersionID = crfA.crfVersionID
	INNER JOIN itmidw.tblcrf crf
		ON crf.crfID = vers.crfID
	LEFT JOIN tblCrfFields fields
		ON Fields.sourceSystemFieldID = crfA.sourceSystemFieldDataLabel

		PRINT CAST(@@ROWCOUNT AS VARCHAR(10))+ ' row(s) updated.'

--update to tblCrfTranslationField
UPDATE itmidw.tblCrfEventAnswers set CrfTranslationFieldID = transF.CrfTranslationFieldID
		FROM itmidw.tblCrfEventAnswers crfA
			left JOIN itmidw.tblcrfversion vers
		ON vers.crfVersionID = crfA.crfVersionID
	INNER JOIN ITMIDW.tblcrf crf
		ON crf.crfID = vers.crfID
	INNER JOIN itmidw.tblCrfFields fields
		ON fields.sourceSystemFieldID = crfA.sourceSystemFieldDataLabel
			and fields.cdeID = crf.crfShortName
	INNER JOIN itmidw.tblCrfTranslationField  transF
		on fields.questionText = transF.questionText
		and crf.crfID = transF.crfID
		and transF.orgsourcesystemID= 3

PRINT CAST(@@ROWCOUNT AS VARCHAR(10))+ ' update to crfTranslation tblCrfEventAnswers row(s) updated.'

UPDATE itmidw.tblCrfEventAnswers set CrfTranslationFieldID =  transF.CrfTranslationFieldID 
FROM itmidw.tblCrfEventAnswers crfa
	INNER JOIN itmidw.tblCrfTranslationField  transF
		on transF.QuestionText = crfa.sourceSystemFieldDataLabel
where crfa.CrfTranslationFieldID IS NULL
and crfa.orgsourcesystemID= 3


PRINT CAST(@@ROWCOUNT AS VARCHAR(10))+ ' 2nd update to crfTranslation tblCrfEventAnswers  row(s) updated.'



END


