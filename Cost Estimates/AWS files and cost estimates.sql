select avg(subjectCount) as avgByMonth
, sum(subjectCount) 
FROM (
	select  
		 CONVERT(varchar(100),year(a.fieldValue)) + '-' + CASE LEN(montH(a.fieldValue)) WHEN 1 Then '0' + CONVERT(varchar(100),MONTH(a.fieldValue)) ELSE CONVERT(varchar(100),MONTH(a.fieldValue)) end as DateLabel
		 , COUNT(*) subjectCount
	from itmidw.tblsubject sub
		inner join itmidw.tblCrfEventAnswers a
			on a.subjectID = sub.subjectID
		inner join itmidw.tblcrfversion v
			on v.crfversionID = a.crfVersionID
		inner join itmidw.tblcrf crf
			on crf.crfid = v.crfID
		inner join itmidw.tblCrfFields f
			on f.fieldID = a.fieldID
		WHere sub.studyID  = 2
		and crf.crfName = 'enrollment'
		and a.fieldvalue <> ''
		and a.sourceSystemFieldDataLabel = 'ENICDATMO'
		and CONVERT(varchar(100),year(a.fieldValue)) + '-' + CASE LEN(montH(a.fieldValue)) WHEN 1 Then '0' + CONVERT(varchar(100),MONTH(a.fieldValue)) ELSE CONVERT(varchar(100),MONTH(a.fieldValue)) end not IN ('2012-04','2014-05')
	GROUP  BY   CONVERT(varchar(100),year(a.fieldValue)) + '-' + CASE LEN(montH(a.fieldValue)) WHEN 1 Then '0' + CONVERT(varchar(100),MONTH(a.fieldValue)) ELSE CONVERT(varchar(100),MONTH(a.fieldValue)) end
	
) as a


--60 per month
-- 96 * 
select 96*10

select SUM(fileSizeInMB)/1024/1024 as fileSizeInMB
FROM (
select matchSubjectID,COUNT(*) fileCnt, sum(fileSizeInMB) fileSizeInMB
from itmidw.tblfile f
where awsVolume = 'itmi.ptb.illumina'
	
	GROUP BY matchSubjectID
	)as a


--select * from itmidw.tblfile f
