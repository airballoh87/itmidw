

TRUNCATE TABLE  [dbo].[tblCrfAnswersForAnalysis]

INSERT INTO [dbo].[tblCrfAnswersForAnalysis]
           (
           [crfEventAnswersID]
           ,[crfAnswerPivot]
           ,[crfQuestion]
           ,[crfAnswer]
           ,[SubjectID])
     SELECT
           --(,<crfEventAnswersID, int,>
		ans.crfEventAnswersID
           --,<crfAnswerPivot, int,>
		, ans.eventCrfID
           --,<crfQuestion, varchar(100),>
		, dd.preferredFieldName
           --,<crfAnswer, varchar(250),>
		, ans.fieldValue
           --,<SubjectID, int,>)
		, ans.subjectID
FROM tblCrfEventAnswers ans
	INNER JOIN tblCrfDataDictionary dd
		ON dd.crfDataDictionaryID  = ans.crfDataDictionaryID
WHERE dd.preferredFieldName IS NOT NULL
	AND ans.fieldValue <> ''



/*
UPDATE tblCrfDataDictionary SET preferredFieldName = 'RACE' where crfDataDictionaryID IN (286,331 ,2087)


*/

select crfQuestion, crfAnswer, COUNT(*)
from  [dbo].[tblCrfAnswersForAnalysis]
GROUP BY crfQuestion, crfAnswer
ORDER BY crfQuestion desc, crfAnswer 

