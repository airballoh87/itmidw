SELECT distinct deets.itmiFormName, deets.itmiFieldName, deets.fieldName
FROM itmiDIFZ.genesis.PatientDataPointDetail as deets
	INNER JOIN ITMIDW.dbo.tblSubject subject
		ON subject.subjectId = deets.itmidwSubjectID
WHERE deets.isactive = 1	
	aND ISDATE(DEETS.fieldValue) = 1
	--and deets.itmiformname = 'Trio Contact'
ORDER BY deets.itmiFormName, deets.itmiFieldName