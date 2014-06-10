/*
DROP TABLE #t
GO
SELECT itmisubjectID, CONVERT(Varchar(100),NULL) as convertedITMISubjectID
INTO #t
FROM [dbo].[df4List] list
	
UPDATE #t SET convertedITMISubjectID = 'NB-101-'+ SUBSTRING(itmisubjectID,5,3)
from #t
WHERE LEN(itmisubjectID) = 10

UPDATE #t SET convertedITMISubjectID =
'NB-' +
CASE RIGHT(itmisubjectID,1) 
	WHEN '1' THEN 'A'
	WHEN '2' THEN 'B'
	WHEN '3' THEN 'C'
	END +
'-101-'+
SUBSTRING(itmisubjectID,5,3)
from #t
WHERE convertedITMISubjectID IS NULL


INSERT INTO itmidw.tblSubjectDataFreeze ( subjectID , studyID, freezeID, freezeQualifier)
select 
	sub.subjectID
	, sub.studyID
	, 4
	, NULL
 FROM #t t
	INNER JOIN ITMIDW.tblsubject sub
		on sub.sourceSystemIDLabel = t.CONVERTeditmisubjectID
*/

		
		
		
		