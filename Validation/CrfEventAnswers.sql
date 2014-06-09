--Drop table #t
--GO
--Detail
WITH tableDetail as (
select o.name as tableName,c.name as fieldName
from sys.sysobjects o
	inner join sys.columns c
		on c.object_id = o.id
where o.name IN ('EDC101NEWBORN', 'EDC101Mother','EDC101Father')
	and c.name NOT IN ('pkid')
)
, 
questionDetail as (
	select 
		CASE crf.crfName
			WHEN 'Sharepoint: Father: 101' THEN 'EDC101Father'
			WHEN 'Sharepoint: Mother: 101' THEN 'EDC101Mother'
			WHEN 'Sharepoint: Newborn: 101' THEN 'EDC101NewBorn'
			ELSE  crf.crfName
			END as crfName
		, ans.sourceSystemFieldDataLabel as question
		, COUNT(*) as questionCnt
	from itmidw.tblCrfEventAnswers ans
		inner join itmidw.tblsubject sub
			on sub.subjectID = ans.subjectID
		inner join itmidw.tblcrfversion v
			on v.crfVersionID = ans.crfVersionID
		inner join itmidw.tblcrf crf
			on crf.crfID = v.crFId
	WHERE sub.studyID = 1
		GROUP BY
				CASE crf.crfName
			WHEN 'Sharepoint: Father: 101' THEN 'EDC101Father'
			WHEN 'Sharepoint: Mother: 101' THEN 'EDC101Mother'
			WHEN 'Sharepoint: Newborn: 101' THEN 'EDC101NewBorn'
			ELSE  crf.crfName
			END 
		, ans.sourceSystemFieldDataLabel 
)
--GROUP

,  tableSummary as (
select o.name as tableName, COUNT(*) as columnCnt
from sys.sysobjects o
	inner join sys.columns c
		on c.object_id = o.id
where o.name IN ('EDC101NEWBORN', 'EDC101Mother','EDC101Father')
	and c.name NOT IN ('pkid')
GROUP BY o.name 
)

, questionSummary as ( 
select crfName, COUNT(*) as cnt
FROM (
	select 
		CASE crf.crfName
			WHEN 'Sharepoint: Father: 101' THEN 'EDC101Father'
			WHEN 'Sharepoint: Mother: 101' THEN 'EDC101Mother'
			WHEN 'Sharepoint: Newborn: 101' THEN 'EDC101NewBorn'
			ELSE  crf.crfName
			END as crfName
		, ans.sourceSystemFieldDataLabel as question
		, COUNT(*) as cnt
	from itmidw.tblCrfEventAnswers ans
		inner join itmidw.tblsubject sub
			on sub.subjectID = ans.subjectID
		inner join itmidw.tblcrfversion v
			on v.crfVersionID = ans.crfVersionID
		inner join itmidw.tblcrf crf
			on crf.crfID = v.crFId
	WHERE sub.studyID = 1
		GROUP BY crf.crfName, ans.sourceSystemFieldDataLabel
) as a
GROUP BY 
	crfName
	)

--detail 
--/*
select fieldname, tablename, *
--into #t 
from questionDetail qd
	FULL OUTER JOIN tableDetail td
		on td.tableName = qd.crfName	
			and td.fieldName = qd.question
	WHERE qd.question IS NULL or td.fieldName IS NULL
		
ORDER BY td.tableName, td.fieldName
--*/		



--Summary
/*
select * 
	from tableSummary ts
	INNER JOIN questionSummary qs
		on ts.tableName = qs.crfName
*/
--select 
--'INSERT INTO itmidw.[tblCrfEventAnswers]([sourceSystemFieldDataID],[eventCrfID],[crfVersionID],[fieldValue],[hadQuery],[openQuery],[fieldValueOrdinal],[orgSourceSystemID],[createDate],	[createdBy], [sourceSystemFieldDataLabel])' + 
--'SELECT f.fieldID, Event.crfeventID,  event.crfVersionID, [' +
--CONVERT(VARCHAR(100),fieldname) +
--'], 0, 0, NULL, 6, GETDATE(), ''usp_Study101CrfEventAnswers'', '+ 
--''''+
--CONVERT(VARCHAR(100),fieldname) +
--''''+
--' FROM spoint101.EDC101Mother INNER JOIN ITMIDW.tblModelObjects ob on  ob.dmObjectIDName = ''EDC101Mother'' INNER JOIN itmidw.tblCrfEvent event ON event.[sourceSystemCrfEventID] = LTRIM(RTRIM(ob.dmObjectCode)) + '': ''  + CONVERT(varchar(100), EDC101Mother.pkid) INNER JOIN itmidw.tblCrfFields f ON f.sourceSystemFieldID = '
-- + 
--''''+
--CONVERT(VARCHAR(100),fieldname) +
--'''' +  
--' and event.crfVersionID = f.crfVersionID   WHERE '+ 
--''''+
--CONVERT(VARCHAR(100),fieldname) + 
--''''+
--' IS NOT NULL and crfeventID IS NOT NULL '

--from #t
--where tablename like '%MOTHER%'






--select F.*
--from itmidw.tblCrfFields f
--	inner join itmidw.tblcrf c
--		on c.crfID = f.crfversionID
--where f.orgSourceSystemID = 6
--	AND F.crfVersionID = 28
