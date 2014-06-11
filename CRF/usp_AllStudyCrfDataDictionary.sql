
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ITMIDW.usp_AllStudyCrfDataDictionary') AND type in (N'P', N'PC'))
DROP PROCEDURE ITMIDW.usp_AllStudyCrfDataDictionary
GO
/**************************************************************************
Created ON : 4/12/2014
Created By : AarON Black
Team Name : Informatics
Object name : usp_AllStudyCrfDataDictionary
Functional : ITMI SSIS for Insert AND Update for study 102 crf data dictionary

History : Created ON 4/12/2014
**************************************************************************
Date Modified By QC# Purposes
**************************************************************************
#Date #Comment
**************************************************************************
USE CASE:
EXEC itmidw.usp_AllStudyCrfDataDictionary
--TRUNCATe table ITMIDW.[tblCrfDataDictionary] 
SELECT* FROM ITMIDW.[tblCrfDataDictionary] 
PREP
delete
FROM [dbo].[crfFieldsForAnalysis20140522] ana	
	WHERE ana.[preferred name] IS NULL

**************************************************************************/
CREATE PROCEDURE ITMIDW.usp_AllStudyCrfDataDictionary
AS
BEGIN
SET NOCOUNT ON;
DECLARE @UpdatedON SMALLDATETIME
SET @UpdatedON = CAST(GETDATE() AS SMALLDATETIME)
PRINT CONVERT(CHAR(23), @UpdatedOn, 121) +'usp_AllStudyCrfDataDictionary['+ @@SERVERNAME +']['+ SYSTEM_USER +']'
PRINT'INSERT ITMIDW.usp_AllStudyCrfDataDictionary...'

 IF OBJECT_ID('tempdb..#tt') IS NOT NULL
DROP TABLE #tt

--*************************************
--******************102****************
--*************************************

--*************************************--*************************************
--update to preferred name for correct aggregation--**************************
--*************************************--*************************************

--*************************************
--**********Insert into temp table ****
--*************************************

SELECT 
	crfa.sourceSystemFieldDataLabel
	, dd.questionText
	, crf.crfName
	, MIN(crfa.fieldValue) AS minVal
	, MAX(crfa.fieldValue) AS maxVal
	, COUNT(*) AS cnt
	, SUM(CASE WHEN ISNULL(crfa.fieldValue,'') <>  '' THEN 1 ELSE 0 END) AS FilledIn
	, ROUND(((SUM(CASE WHEN ISNULL(crfa.fieldValue,'') <>  '' THEN 1 ELSE 0 END)+0.00)/COUNT(*)+0.00)*100,2) pctFilledIn
	, MIN(distinctValue.cnt) AS distinctValue
	, MIN(dd.[crfTranslationFieldID]) AS minDDid
	, MAX(dd.[crfTranslationFieldID]) AS maxDDid
INTO #tt
FROM itmidw.tblCrfEventAnswers crfA
	INNER JOIN itmidw.[tblCrfTranslationField] dd
		ON dd.[crfTranslationFieldID] = crfa.[crfTranslationFieldID]
	INNER JOIN itmidw.Tblcrf crf
		ON crf.crfID = dd.crfID
	INNER JOIN 
		(select sourceSystemFieldDataLabel, COUNT(*) AS cnt FROM 
		(
		SELECT sourceSystemFieldDataLabel,FieldValue FROM itmidw.tblCrfEventAnswers GROUP BY sourceSystemFieldDataLabel,FieldValue
		) AS A GROUP BY sourceSystemFieldDataLabel)   
			AS distinctValue
		ON distinctValue.sourceSystemFieldDataLabel = crfA.sourceSystemFieldDataLabel
GROUP BY crfa.sourceSystemFieldDataLabel,dd.questionText,crf.crfName


--*************************************
--**********Update preferred name  ****
--*************************************

UPDATE itmidw.[tblCrfTranslationField]  SET [preferredFieldName] =  ana.[preferred Name]
FROM [dbo].[crfFieldsForAnalysis20140603] ana	
	INNER JOIN #tt t
		ON t.crfName = ana.crfname
		AND t.sourceSystemFieldDataLabel = ana.sourceSystemFieldDataLabel
		AND t.questionText = ana.questionText
	INNER JOIN itmidw.[tblCrfTranslationField] map
		ON map.crfTranslationFieldID = t.maxDDid
WHERE t.sourceSystemFieldDataLabel = 'FPFHGUPUNK'
	
--*************************************
--**********Insert into dd   table ****
--*************************************
		
INSERT INTO ITMIDW.[tblCrfDataDictionary]
   (
	[questionText]
   ,[preferredFieldName]
   ,[orgSourceSystemID]
   ,[createDate]
   ,[createdBy])
SELECT
	MAX(transF.questionText) AS QuestionText
	, transF.preferredFieldName AS preferredName
    , (SELECT ss.sourceSystemID FROM ITMIDW.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS [orgSourceSystemID]
    , GETDATE() [createDate]
    ,'usp_AllStudyCrfDataDictionary' AS [createdBy]
FROM ITMIDW.[tblCrfTranslationField] transF
	INNER JOIN ITMIDW.tblcrfversiON vers
		ON vers.crfVersionID = transF.crfVersionID
	INNER JOIN ITMIDW.tblStudy study
		ON study.studyID = transF.studyID
	INNER JOIN ITMIDW.tblcrf crf
		ON crf.crfID = vers.crfID
	LEFT JOIN ITMIDW.[tblCrfDataDictionary] dd
		ON dd.preferredFieldName = transF.preferredFieldName
WHERE transF.preferredFieldName IS NOT NULL
	AND dd.crfDataDictionaryID IS NULL --only bringing in new records that are not in DD already
GROUP BY transF.preferredFieldName

PRINT CAST(@@ROWCOUNT AS VARCHAR(10))+'row(s) updated.'

--*************************************
--update data dictionary--*************
--*************************************
UPDATE itmidw.tblCrfEventAnswers set crfDataDictionaryID = dd.[crfDataDictionaryID]
		FROM itmidw.tblCrfEventAnswers crfA
	INNER JOIN [itmidw].[tblCrfTranslationField] map
		ON map.crfTranslationFieldID = crfa.CrfTranslationFieldID
	INNER JOIN itmidw.[tblCrfDataDictionary]  dd
		ON dd.preferredFieldName = map.preferredFieldName

PRINT CAST(@@ROWCOUNT AS VARCHAR(10))+'update to crfDD tblCrfEventAnswers row(s) updated.'
--*************************************
--for re-creatiON purposes only--******
--*************************************
UPDATE ITMIDW.[tblCrfDataDictionary] set displayName = 'Subject Race'
WHERE preferredFieldName = 'RACE';

--*************************************
--**************preferred Name*********
--*************************************
UPDATE ITMIDW.[tblCrfDataDictionary] set displayName = preferredFieldName
WHERE DISPLAYnAME IS NULL

--*************************************
--study 101 hAND procured name--*******
--*************************************

UPDATE itmidw.[tblCrfTranslationField]
	SET preferredFieldName = 'FPCOUNTRYBRTH'
FROM ITMIDW.[tblCrfTranslationField] transF
WHERE questiontext= 'Country of Birth'
	AND crftype = 'Study101 Father'

UPDATE itmidw.[tblCrfTranslationField]
	SET preferredFieldName = 'FPFHFBRTHCO'
FROM ITMIDW.[tblCrfTranslationField] transF
WHERE questiontext = 'Country of Birth'
	AND crftype = 'Study101 Father'




END