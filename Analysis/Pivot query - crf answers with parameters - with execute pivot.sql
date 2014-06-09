--need to create upper query that counts the distinct number of subject rows, and then compare to make sure 
--the subject has all the criteria.
--from there 

DECLARE @question1 varchar(100)
DECLARE @question2 varchar(100)
DECLARE @question3 varchar(100)
DECLARE @value1 varchar(100)
DECLARE @value2 varchar(100)
DECLARE @value3 varchar(100)
DECLARE @sql varchar(8000)

Set @question1 = 'ENFNAMEMO'
Set @value1 = 'JENIFER'

Set @question2 = 'ENMET'
Set @value2 = 'C49488'

Set @question3 = 'ENLNAMEMO'
Set @value3 = 'WAINWRIGHT'

SET @sql = 
 '
 
 select DISTINCT
	subject.sourceSystemIDLabel as subjectID
	,study.studyname  
	,crfA.FieldValue as itemValue
	,crfA.sourceSystemFieldDataLabel as itemLabel
from dbo.tblCrfEventAnswers crfA
	INNER JOIN tblsubject subject
		ON subject.subjectID = crfA.subjectID
	INNER JOIN tblstudy study
		ON study.studyID = subject.STUDYid
	left JOIN dbo.tblCrfDataDictionary crfDD
		ON crfDD.studyID = subject.subjectID	
			AND crfDD.fieldName = crfA.sourceSystemFieldDataLabel
WHERE ISNULL(crfa.FieldValue,'''') <> ''''
	AND
	(
		(crfa.sourceSystemFieldDataLabel = ''' + CONVERT(Varchar(100),@Question1) +  '''AND crfA.fieldValue = ''' +  CONVERT(VARCHAR(100),@value1) + ''')'
		 +  ' OR
		(crfa.sourceSystemFieldDataLabel = ''' + CONVERT(Varchar(100),@Question2) +  '''AND crfA.fieldValue = ''' +  CONVERT(VARCHAR(100),@value2) + ''')'
		+  '  OR
		(crfa.sourceSystemFieldDataLabel = ''' + CONVERT(Varchar(100),@Question3) +  '''AND crfA.fieldValue = ''' +  CONVERT(VARCHAR(100),@value3) + ''')
	)'

SET @sql = LTRIM(RTRIM(@sql))

print @SQL

exec [dbo].[CrossTab] @sql ,'itemLabel', 'MAX(itemValue)', 'subjectID'


--select *
--from dbo.tblCrfEventAnswers crfA
--	INNER JOIN tblsubject subject
--		ON subject.subjectID = crfA.subjectID
--	INNER JOIN tblstudy study
--		ON study.studyID = subject.STUDYid
--where subject.subjectID = '2663'


select DISTINCT
	subject.sourceSystemIDLabel as subjectID
	,study.studyname  
	,crfA.FieldValue as itemValue
	,crfA.sourceSystemFieldDataLabel as itemLabel
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
		(crfa.sourceSystemFieldDataLabel = 'ENFNAMEMO'AND crfA.fieldValue = 'JENIFER') AND 
	--	(crfa.sourceSystemFieldDataLabel = 'ENMET'AND crfA.fieldValue = 'C49488') AND
		--(crfa.sourceSystemFieldDataLabel = 'ENLNAMEMO'AND crfA.fieldValue = 'WAINWRIGHT')
	)
