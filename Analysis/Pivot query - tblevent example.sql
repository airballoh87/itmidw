/*

                  @SQL varchar(8000),   
            @PivotCol varchar(8000),
            @Summaries varchar(8000), 
            @GroupBy varchar(8000),
            @OtherFields varchar(8000) = Null,
                  @OrderBy varchar(8000) = Null)
 
 

 
Put the SELECT statement in the first parameter.
Put in the second parameter the column name you want to pivot on (for the column headings).
Put in the third parameter the aggregate column expression for the crosstab values
Put in the fourth parameter the column name you want to group on (for the row headings).
If you want additional columns shown besides the pivot values and the row headings, 
      list additional column expressions (within appropriate aggregate functions) in the fifth parameter.

*/
 


 /*exec [dbo].[CrossTab] 'select subjectID, eventtype, eventName, dbo.dateonly(createDate) as eventDate from itmidw.dbo.tblevent where eventName is not null'
 , 'eventName'
 , 'MAX(eventDate)'
 , 'subjectID'
 */

 ALTER Procedure  usp_ITMIEvents
 AS
 SET NO_BROWSETABLE OFF
  exec [dbo].[CrossTab] 'select 
	sub.sourceSystemIDLabel
	,org.organizationName
	,eve.eventType
	,ISNULL(CONVERT(varchar(10),eveRule.eventRuleOrder),''99'') + '' - '' +  eve.eventName as eventName
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
			AND orgType.organizationTypeName = ''Family''
	LEFT JOIN ITMIDW.[dbo].tblEventRules eveRule
		on eveRule.eventName = eve.eventName	
			AND eveRule.eventRuleName = ''Event Order'''
, 'eventName'
, 'MAX(eventDate)'
, 'organizationName'



--select 
--	sub.sourceSystemIDLabel
--	,org.organizationName
--	,eve.eventType
--	,ISNULL(CONVERT(varchar(10),eveRule.eventRuleOrder),'99') + ' - ' +  eve.eventName as eventName
--	,eve.eventDate

--from ITMIDW.[dbo].[tblEvent] eve
--	inner join ITMIDW.[dbo].tblsubject sub
--		on sub.subjectID = eve.subjectID
--	inner join ITMIDW.[dbo].tblSubjectOrganizationMap orgMap
--		on orgMap.subjectID = sub.subjectID
--	INNER JOIN ITMIDW.[dbo].tblOrganization org
--		on org.organizationID = orgMap.organizationID
--	INNER JOIN ITMIDW.[dbo].tblOrganizationType orgType
--		on orgType.organizationTypeID = org.organizationTypeID
--			AND orgType.organizationTypeName = 'Family'
--	LEFT JOIN ITMIDW.[dbo].tblEventRules eveRule
--		on eveRule.eventName = eve.eventName	
--			AND eveRule.eventRuleName = 'Event Order'




'select 
	sub.sourceSystemIDLabel
	,org.organizationName
	,eve.eventType
	,ISNULL(CONVERT(varchar(10),eveRule.eventRuleOrder),''99'') + '' - '' +  eve.eventName as eventName
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
			AND orgType.organizationTypeName = ''Family''
	LEFT JOIN ITMIDW.[dbo].tblEventRules eveRule
		on eveRule.eventName = eve.eventName	
			AND eveRule.eventRuleName = ''Event Order'''
, 'eventName'
, 'MAX(eventDate)'
, 'organizationName'
