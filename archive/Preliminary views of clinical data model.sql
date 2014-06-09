/* Notes--**
Add crfVersionID to the crfEventAnswers and take way the crfID
get all the source crfField links working (102)
add maptype code to the tblSubjectOrganizationMap***
add clinicaldatadates table
clinical data dictionary  --- blank question text
clinical data dictionary values --- add the options (rave metadata
--clean up persontype

select 
--crf.crfName
--, subject.subjectID
--, ss.sourceSystemName
--, subject.sourceSystemIDLabel
--, study.studyName
--, a.sourceSystemFieldDataLabel
--, a.fieldValue as answer
--, org.*
Study.studyID
, org.organizationName
,COUNT(*)
from [dbo].[tblCrfEventAnswers] a
	INNER JOIN tblcrf crf
		on crf.crfID = a.crfID
	INNER JOIN tblCrfEvent crfEvent 
		on crfEvent.crfEventID = a.eventCrfID
	INNER JOIN tblSourceSystem ss
		on ss.sourceSystemID = a.orgSourceSystemID
	INNER JOIN tblSubject subject
		on subject.subjectID = crfEvent.subjectID
	LEFT JOIN tblCrfFields fields
		on fields.fieldID = a.sourceSystemFieldDataID
	INNER JOIN tblStudy study
		on study.studyID = subject.studyId
	LEFT JOIN tblSubjectOrganizationMap familyMap
		on familyMap.subjectID = subject.subjectID
	LEFT JOIN tblorganization org
		on org.organizationID = familyMap.organizationID and org.organizationTypeID = (select organizationTypeID from tblOrganizationType where organizationTypeName = 'Family')
WHERE ISNULL(org.organizationTypeID,'') = 2 --**Only Family relationships for organizations
GROUP BY Study.studyID, org.organizationName
ORDER BY Study.studyID, org.organizationName

*/



SELECT *
FROM [dbo].[tblCrfDataDictionaryValues]

