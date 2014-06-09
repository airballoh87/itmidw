select 
	sub.sourceSystemIDLabel
	,org.organizationName
	,eve.eventType
	,CONVERT(varchar(10),eveRule.eventRuleOrder) + ' - ' + eve.eventName
	,eve.eventDate
from ITMIDW.[dbo].[tblEvent] eve
	inner join ITMIDW.[dbo].tblsubject sub
		on sub.subjectID = eve.subjectID
	inner join ITMIDW.[dbo].tblSubjectOrganizationMap orgMap
		on orgMap.subjectID = sub.subjectID
	INNER JOIN ITMIDW.[dbo].tblOrganization org
		on org.organizationID = orgMap.organizationID
	INNER JOIN ITMIDW.[dbo].tblOrganizationType orgType
		on orgType.organizationTypeID = org.organizationTypeID
			AND orgType.organizationTypeName = 'Family'
	INNER JOIN ITMIDW.[dbo].tblEventRules eveRule
		on eveRule.eventName = eve.eventName	
			AND eveRule.eventRuleName = 'Event Order'
ORDER BY org.organizationName,eve.eventDate, eve.eventType,eve.eventName


