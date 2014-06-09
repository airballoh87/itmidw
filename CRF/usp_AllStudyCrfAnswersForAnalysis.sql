--ALTER table [dbo].[tblCrfEventAnswers] add subjectID INT
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[itmidw].[usp_AllStudyCrfAnswersForAnalysis]') AND type in (N'P', N'PC'))
DROP PROCEDURE itmidw.[usp_AllStudyCrfAnswersForAnalysis]
GO
/**************************************************************************
Created ON : 4/18/2014

Created By : AarON Black
Team Name : Informatics
Object name : [usp_AllStudyCrfAnswersForAnalysis]
Functional : ITMI SSIS for Insert AND Update for all stdudies for analysis tables. This takes the 
crfEventAnalysis table, and layers the data dictionary with the values for better analysis 
 THis is the detail data
History : Created ON 4/18/2014fs
**************************************************************************
Date Modified By QC# Purposes
**************************************************************************
#Date #Comment
**************************************************************************
USE CASE:
EXEC itmidw.[usp_AllStudyCrfAnswersForAnalysis]
TRUNCATe table [itmidw].[tblCrfAnswersForAnalysis] 
select crfquestion, COUNT(*) from [itmidw].[tblCrfAnswersForAnalysis] GROUP BY crfquestion ORDER BY crfquestion
select * from  [itmidw].[tblCrfAnswersForAnalysis]

**************************************************************************/
CREATE PROCEDURE [itmidw].[usp_AllStudyCrfAnswersForAnalysis]
AS
BEGIN
SET NOCOUNT ON;
DECLARE @UpdatedON SMALLDATETIME
SET @UpdatedON = CAST(GETDATE() AS SMALLDATETIME)
PRINT CONVERT(CHAR(23), @UpdatedOn, 121) + ' [usp_AllStudyCrfAnswersForAnalysis][' + @@SERVERNAME + '][' + SYSTEM_USER + ']'
PRINT 'INSERT [ITMIDW].[dbo].[usp_AllStudyCrfAnswersForAnalysis]...'

--*************************************
--******************102****************
--*************************************

TRUNCATE TABLE  itmidw.[tblCrfAnswersForAnalysis]

INSERT INTO itmidw.[tblCrfAnswersForAnalysis]
           (
           [crfEventAnswersID]
           ,[crfAnswerPivot]
           ,[crfQuestion]
           ,[crfAnswer]
           ,[SubjectID]
		   ,sourceSystemFieldID)
     SELECT
--(,<crfEventAnswersID, int,>
	crfA.crfEventAnswersID
--,<crfAnswerPivot, int,>
	, crfA.eventCrfID
--,<crfQuestion, varchar(100),>
	, dd.displayName
--,<crfAnswer, varchar(250),>
	, ISNULL(opt.preferredName,crfa.fieldValue) as crfAnswer
--,<SubjectID, int,>)
	, crfa.subjectID
--sourceSystemFieldID
	, crfA.sourceSystemFieldDataID
--SELECT  *
FROM itmidw.tblCrfEventAnswers crfA
	INNER JOIN itmidw.tblCrfDataDictionary dd
		ON crfa.crfDataDictionaryID = dd.crfDataDictionaryID
	INNER JOIN itmidw.[tblCrfTranslationField] field
		ON field.crfTranslationFieldID = crfA.CrfTranslationFieldID
	LEFT JOIN itmidw.[tblCrfTranslationFieldOptions] opt
		ON opt.CrfTranslationFieldID = field.CrfTranslationFieldID
			AND opt.FieldValue = crfa.fieldValue
WHERE 
	dd.preferredFieldName IS NOT NULL
	AND ISNULL(crfA.fieldValue,'') <> ''

PRINT CAST(@@ROWCOUNT AS VARCHAR(10))+ ' row(s) updated.'

--****gestational age
--gestational age
;WITH gestWeeksInfant as (
SELECT
	sub.subjectID
	, MAX(CONVERT(int,cc.crfanswer)) as GestWeeks
	, MAX(cc.crfEventAnswersID) as answerID
	, cc.sourceSystemFieldID
FROM [itmidw].[tblCrfAnswersForAnalysis] cc
	inner join [itmidw].tblSubject sub
		on sub.subjectID = cc.subjectID
	INNER JOIN [itmidw].tblStudy study
		on study.studyID = sub.studyID
WHERE crfQuestion LIke '%GESTAGEWK%'
	and sub.cohortRole = 'infant'
	and ISNUMERIC(cc.crfanswer) = 1
GROUP BY sub.subjectID, cc.sourceSystemFieldID
)


INSERT INTO itmidw.[tblCrfAnswersForAnalysis]
           (
           [crfEventAnswersID]
           ,[crfAnswerPivot]
           ,[crfQuestion]
           ,[crfAnswer]
           ,[SubjectID]
		   ,sourceSystemFieldID)

SELECT 
	answerID
	, subjectID
	, 'Birth Gestation Type' 
	, CASE WHEN gestWeeks < 37 THEN 'Premature' ELSE 'Full Term' END AS birthGestationType
	, subjectID
	, sourceSystemFieldID
FROM gestWeeksInfant 
	


--cleanup
--All caps
UPDATE itmidw.[tblCrfAnswersForAnalysis] SET crfAnswer = UPPER(LTRIM(RTRIM(crfAnswer)))
--true \ false
UPDATE itmidw.[tblCrfAnswersForAnalysis] SET crfAnswer = 1  WHERE crfAnswer = 'TRUE'
UPDATE itmidw.[tblCrfAnswersForAnalysis] SET crfAnswer = 0  WHERE crfAnswer = 'FALSE'
--yes \ no
UPDATE itmidw.[tblCrfAnswersForAnalysis] SET crfAnswer = 1  WHERE crfAnswer = 'YES'
UPDATE itmidw.[tblCrfAnswersForAnalysis] SET crfAnswer = 0  WHERE crfAnswer = 'NO'




END

--select * from itmidw.tblCrfDataDictionaryValues