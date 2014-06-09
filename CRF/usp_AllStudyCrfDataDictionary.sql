
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
select  * FROM ITMIDW.[tblCrfDataDictionary] 
PREP
delete
from [dbo].[crfFieldsForAnalysis20140522] ana	
	where ana.[preferred name] IS NULL

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
--update to preferred name for correct aggregation




select  crfa.sourceSystemFieldDataLabel,dd.questionText,crf.crfName
,MIN(crfa.fieldValue) as minVal
,MAX(crfa.fieldValue) as maxVal
,COUNT(*) as cnt
,SUM(CASE WHEN ISNULL(crfa.fieldValue,'') <>  '' THEN 1 ELSE 0 END) as FilledIn
,ROUND(((SUM(CASE WHEN ISNULL(crfa.fieldValue,'') <>  '' THEN 1 ELSE 0 END)+0.00)/COUNT(*)+0.00)*100,2) pctFilledIn
, MIN(distinctValue.cnt) as distinctValue
, MIN(dd.[crfTranslationFieldID]) as minDDid
, MAX(dd.[crfTranslationFieldID]) as maxDDid
into #tt
from itmidw.tblCrfEventAnswers crfA
	inner join itmidw.[tblCrfTranslationField] dd
		on dd.[crfTranslationFieldID] = crfa.[crfTranslationFieldID]
	INNER JOIN itmidw.Tblcrf crf
		on crf.crfID = dd.crfID
	INNER JOIN 
		(select sourceSystemFieldDataLabel, COUNT(*) as cnt FROM 
		(
		SELECT sourceSystemFieldDataLabel,FieldValue FROM itmidw.tblCrfEventAnswers GROUP BY sourceSystemFieldDataLabel,FieldValue
		) as A GROUP BY sourceSystemFieldDataLabel)   
			as distinctValue
		ON distinctValue.sourceSystemFieldDataLabel = crfA.sourceSystemFieldDataLabel
GROUP BY crfa.sourceSystemFieldDataLabel,dd.questionText,crf.crfName

--select * from #tt where sourceSystemFieldDataLabel = 'FPFHGUPUNK'

UPDATE itmidw.[tblCrfTranslationField]  SET [preferredFieldName] =  ana.[preferred Name]
--select t.*
from [dbo].[crfFieldsForAnalysis20140603] ana	
	INNER JOIN #tt t
		on t.crfName = ana.crfname
		and t.sourceSystemFieldDataLabel = ana.sourceSystemFieldDataLabel
		and t.questionText = ana.questionText
	INNER JOIN itmidw.[tblCrfTranslationField] map
		on map.crfTranslationFieldID = t.maxDDid
ORDER BY t.sourceSystemFieldDataLabel

WHERE t.sourceSystemFieldDataLabel = 'FPFHGUPUNK'
	

select * FROM itmidw.[tblCrfTranslationField]	where preferredFieldName = 'FPFHGUPUNK'
		
INSERT INTO ITMIDW.[tblCrfDataDictionary]
           (
            [questionText]
           ,[preferredFieldName]
		   ,[orgSourceSystemID]
           ,[createDate]
           ,[createdBy])
select  
	MAX(transF.questionText) as QuestionText
	, transF.preferredFieldName as preferredName
   , (SELECT ss.sourceSystemID FROM ITMIDW.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS [orgSourceSystemID]
    , GETDATE() [createDate]
    ,'usp_AllStudyCrfDataDictionary' AS [createdBy]
--select *
FROM ITMIDW.[tblCrfTranslationField] transF
	INNER JOIN ITMIDW.tblcrfversion vers
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

--**write update statement and vlookup on translationcode id in excel

PRINT CAST(@@ROWCOUNT AS VARCHAR(10))+'row(s) updated.'

--update data dictionary
--102
UPDATE itmidw.tblCrfEventAnswers set crfDataDictionaryID = dd.[crfDataDictionaryID]
		FROM itmidw.tblCrfEventAnswers crfA
	INNER JOIN [itmidw].[tblCrfTranslationField] map
		on map.crfTranslationFieldID = crfa.CrfTranslationFieldID
	INNER JOIN itmidw.[tblCrfDataDictionary]  dd
		on dd.preferredFieldName = map.preferredFieldName




PRINT CAST(@@ROWCOUNT AS VARCHAR(10))+'update to crfDD tblCrfEventAnswers row(s) updated.'

--for re-creation purposes only
UPDATE ITMIDW.[tblCrfDataDictionary] set displayName = 'Subject Race'
where preferredFieldName = 'RACE';

UPDATE ITMIDW.[tblCrfDataDictionary] set displayName = preferredFieldName
where DISPLAYnAME IS NULL

--study 101 hand procured name
UPDATE itmidw.[tblCrfTranslationField]
	SET preferredFieldName = 'FPCOUNTRYBRTH'
FROM ITMIDW.[tblCrfTranslationField] transF
where questiontext= 'Country of Birth'
	and crftype = 'Study101 Father'

UPDATE itmidw.[tblCrfTranslationField]
	SET preferredFieldName = 'FPFHFBRTHCO'
FROM ITMIDW.[tblCrfTranslationField] transF
where questiontext = 'Country of Birth'
	and crftype = 'Study101 Father'




END