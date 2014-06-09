/*

exec [dbo].[CrossTab] 
'select
	study.studyName
	, crfa.crfDataDictionaryID
	, dd.preferredFieldName as ddname
	, study.studyShortID
	, subject.sourceSystemIDLabel subjectID
	, analy.crfQuestion analysisQuestion
	, analy.crfAnswer analysisAnswer
	, crfa.fieldValue importedDataValueRaw
	, crfa.sourceSystemFieldDataID importedDataLabelRaw
	, deets.fieldName as difzName
	, deets.fieldValue as difzValue  
FROM itmidw.[tblCrfAnswersForAnalysis] analy
	INNER JOIN itmidw.tblCrfEventAnswers crfA
		on crfA.crfEventAnswersID = analy.crfEventAnswersID
	INNER JOIN itmidw.tblsubject subject
		on analy.subjectID = subject.subjectID
	INNER JOIN itmidw.tblstudy study
		on study.studyID = subject.studyID
	LEFT JOIN difzDBcopy.PatientDataPointDetail deets
		on CONVERT(Varchar(100),deets.patientDataPointDetailID) = crfa.sourceSystemFieldDataID
	INNER JOIN itmidw.tblCrfDataDictionary dd
		on dd.crfDataDictionaryID = crfa.crfDataDictionaryID
	WHERE subject.cohortrole = 'infant'
		and analy.crfQuestion  NOT like  ( 'Cranial Image Worst Grade%')
'
 , 'analysisQuestion'
 , 'MAX(analysisAnswer)'
 , 'subjectID'


exec [dbo].[CrossTab] 	
'select 
	CASE WHEN withD.subjectID IS NOT NULL THEN 'Withdrawal' ELSE ' END +  sub.sourceSystemIDLabel as  sourceSystemIDLabel
	, eve.eventname
	, case when eve.eventDate IS NULL THEN 0 ELSE 1 END as EventConfirmed
	, REPLACE(org.organizationName,'102-',') organizationName
	, study.studyShortID
	, max(sub.subjectID) as subjectID
from itmidw.tblevent eve
	INNER JOIN itmidw.tblsubject sub
		on sub.subjectId = eve.subjectId
	INNER JOIN itmidw.tblstudy study
		on study.studyID = sub.studyID
	INNER JOIN itmidw.tblSubjectOrganizationMap map
		on map.subjectId = sub.subjectID
	INNER JOIN itmidw.tblorganization org
		on org.organizationID = map.organizationID
	INNER JOIN itmidw.tblOrganizationType orgType
		on orgType.organizationTypeID = org.organizationTypeID
			and orgType.organizationTypeName = 'Family'
	LEFT JOIN itmidw.tblSubjectWithDrawal withD
		on withD.subjectID = sub.subjectID
WHERE sub.studyID = 1
GROUP BY  	
	CASE WHEN withD.subjectID IS NOT NULL THEN 'Withdrawal' ELSE ' END +  sub.sourceSystemIDLabel
	, eve.eventname
	, case when eve.eventDate IS NULL THEN 0 ELSE 1 END 
	, organizationName
	, study.studyShortID
'
, 'eventname'
 , 'MAX(EventConfirmed)'
 , 'organizationName, studyShortID'
 

	


*/

exec [dbo].[CrossTab] 	

'SELECT
	sub.subjectID
	, sub.sourceSystemIDLabel
	, case when withD.subjectID IS NULL THEN ' ELSE 'Withdrawal' END as withDrew
	, case when fail.itmiSpecimenID IS NULL THEN ' ELSE 'EA Specimen Fail' END as eaRecordedFailure
	, study.studyName
	, ISNULL(bioFile.eventName,'None')  eventName
	, CONVERT(VARCHAR(100),bioFile.eventDate,101)  eventDate	
	, REPLACE(org.organizationName,'102-',') familyID
FROM itmidw.tblsubject sub	
	INNER JOIN itmidw.tblStudy study
		ON study.studyID = sub.studyID
	INNER JOIN itmidw.tblSubjectOrganizationMap map
		on map.subjectId = sub.subjectID
	INNER JOIN itmidw.tblorganization org
		on org.organizationID = map.organizationID
	INNER JOIN itmidw.tblOrganizationType orgType
		on orgType.organizationTypeID = org.organizationTypeID
			and orgType.organizationTypeName = 'Family'
	LEFT JOIN dbo.eaSpecimenFailures fail
		ON fail.itmiSpecimenID = sub.sourceSystemIDLabel
	LEFT JOIN itmidw.tblSubjectWithDrawal withD
		on withD.subjectID = sub.subjectID
	LEFT JOIN (
			select 
			sub.subjectID
			, eve.eventName
			, eve.eventDate
			from itmidw.tblevent eve 
				INNER JOIN itmidw.tblSubject sub
					ON sub.SubjectID = eve.subjectID
				WHERE eve.eventType IN ('Biological File Received')
			) as bioFile
		ON bioFile.subjectID = sub.subjectID
-WHERE left(sub.sourceSystemIDLabel,3) <> '101'
WHERE study.studyshortID  = '101'
	-and sub.cohortRole = 'Mother'
'

, 'eventname'
, 'MAX(eventDate)'
, 'familyID, withDrew,eaRecordedFailure' 


