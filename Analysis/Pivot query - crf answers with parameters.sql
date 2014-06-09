--TODo 
-- make sure data dictionary brings in all ellements
-- put the questions text into preferred name, and that's what should print on this
-- find the 'codes' IE the I5424 type numberse, and translate into the actual answers, translate with the data dictioary values
-- pivot this view based on the answers 1,2,3 and expand this queyr to 5
-- see if there can be a translater to number, date, text, and do greater than, less than as well as equal to, and make those parameters
-- create procedure
--create connection in excel via sql server sources
--put in parameter locations into excel and find ways to do lookup based on those values, make them dynamic if possible



DECLARE @question1 varchar(100)
DECLARE @question2 varchar(100)
DECLARE @question3 varchar(100)
DECLARE @value1 varchar(100)
DECLARE @value2 varchar(100)
DECLARE @value3 varchar(100)

Set @question1 = 'CMDOS'
Set @value1 = '0.2'

Set @question2 = 'CMIND'
Set @value2 = 'C-SECTION'

Set @question3 = 'Participant Supplement'
Set @value3 = 'Nutritional Supplements'
 select  DISTINCT
	subject.sourceSystemIDLabel as subject
	,study.studyname
	, @question1 + ': "' + @value1 +'"'as Q1A1
	, @question2 + ': "' + @value2 +'"'as Q2A2
	, @question3 + ': "' + @value3 +'"'as Q3A3	
	
from dbo.tblCrfEventAnswers crfA
	INNER JOIN tblsubject subject
		ON subject.subjectID = crfA.subjectID
	INNER JOIN tblstudy study
		ON study.studyID = subject.STUDYid
	left JOIN dbo.tblCrfDataDictionary crfDD
		ON crfDD.studyID = subject.subjectID	
			AND crfDD.fieldName = crfA.sourceSystemFieldDataLabel
WHERE ISNULL(crfa.FieldValue,'') <> ''
	AND
	(
		(crfa.sourceSystemFieldDataLabel = @Question1 AND crfA.fieldValue = @value1)
			OR
		(crfa.sourceSystemFieldDataLabel = @Question2 AND crfA.fieldValue = @value2)
			OR
		(crfa.sourceSystemFieldDataLabel = @Question3 AND crfA.fieldValue = @value3)
	)
ORDER BY subject.sourceSystemIDLabel

