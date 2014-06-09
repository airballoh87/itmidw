DROP TABLE #t
GO

--'Ill Data Recieved'
SELECT 
	'Illumina' as filetype, 
	CONVERT(VARCHAR(100),sub.sourceSystemIDLabel) as sourceSystemIDLabel
	, case when eve.eventID is NULL THEN 'No Files' ELSE 'Files Received' END as doesFileExist
	, case when eve.eventID is NULL THEN 0 ELSE 1 END as doesFileExistCnt
INTO #T
FROM tblsubject sub
	LEFT JOIN [dbo].[tblEvent] eve
		ON eve.subjectID = sub.subjectID
			and eventtype = 'Ill Data Recieved'
WHERE sub.studyID  in (2)
	--and eve.eventID IS NOT NULL

INSERT INTO #t (filetype, sourceSystemIDLabel, doesFileExist,doesFileExistCnt)
SELECT 
	'CGI' as filetype
	, sub.sourceSystemIDLabel
	, case when eve.eventID is NULL THEN 'No Files' ELSE 'Files Received' END as doesFileExist
	, case when eve.eventID is NULL THEN 0 ELSE 1 END as doesFileExistCnt
FROM tblsubject sub
	LEFT JOIN [dbo].[tblEvent] eve
		ON eve.subjectID = sub.subjectID
			and eventtype = 'cgiData Recieved'
WHERE sub.studyID  = 1
	--and eve.eventID IS NULL


--'EA File Recieved'
INSERT INTO #t (filetype, sourceSystemIDLabel, doesFileExist,doesFileExistCnt)
SELECT 'EA' as filetype, sub.sourceSystemIDLabel, case when eve.eventID is NULL THEN 'No Files' ELSE 'Files Received' END as doesFileExist
	, case when eve.eventID is NULL THEN 0 ELSE 1 END as doesFileExistCnt
FROM tblsubject sub
	LEFT JOIN [dbo].[tblEvent] eve
		ON eve.subjectID = sub.subjectID
			and eventtype = 'EA File Recieved'
WHERE sub.studyID  in (1,2)
	--and eve.eventID IS NOT NULL
--**Validation

select filetype ,COUNT(*) as cntOfFileTypes,sum(doesFileExistCnt) as FileCnt
from #t 
GROUP BY filetype 
ORDER BY filetype 


select sourceSystemIDLabel,COUNT(*) as cntOfFileTypes,sum(doesFileExistCnt) as FileCnt
from #t 
GROUP BY sourceSystemIDLabel
ORDER BY sourceSystemIDLabel


select * from #t 
order by sourceSystemIDLabel

--** total subjects

Select 
COUNT(*) as totalSubjects
from tblsubject

Select 
studyID, COUNT(*) as SubjectsByStudy
from tblsubject
GROUP BY studyID

SELECT COUNT(*) as Family101Count
FROM (
	Select 
	COUNT(*) as FamilyMembers,
	LEFT( REPLACE(REPLACE(REPLACE(SUBSTRING(sourceSystemIDLabel,charindex('-',sourcesystemIDLabel)+1,10),'C-',''),'A-',''),'B-',''),7) as FamilyID
	from tblsubject
	where studyID = 1
	GROUP BY LEFT( REPLACE(REPLACE(REPLACE(SUBSTRING(sourceSystemIDLabel,charindex('-',sourcesystemIDLabel)+1,10),'C-',''),'A-',''),'B-',''),7)
) AS A

SELECT COUNT(*) as Family102Count
FROM (
	SELECT COUNT(*) as FamilyMembers,
	LEFT(sourceSystemIDLabel,9) as FamilyID
	from tblsubject
	where studyID = 2
	GROUP BY LEFT(sourceSystemIDLabel,9) 
) AS A


--**manifest # by subject
--** CGI
select 'CGI - Cannot match to subject',cgi.*
from itmistaging.dbo.manifestCGI cgi
	LEFT JOIN tblsubject sub
		on sub.sourceSystemIDLabel = cgi.subjectID
WHERE sub.subjectID is null
order by cgi.subjectID

--** EA
select 'EA - Cannot match to subject',ea.*
from itmistaging.dbo.manifestea ea
	LEFT JOIN tblsubject sub
		on sub.sourceSystemIDLabel = 
		case sub.studyID 
				WHEN 1 THEN ea.convertedITMISubjectID    
				WHEN 2 THEN LEFT(ea.convertedITMISubjectID ,4) + SUBSTRING(ea.convertedITMISubjectID ,8,10) 
			END
WHERE sub.subjectID is NULL
and LEFT(convertedITMISUBJECTID,4) NOT IN ('103-')
order by ea.itmiSubjectID

--** Illumina
select 'Illumina - Cannot match to subject',ill.*
from itmistaging.dbo.ManifestWGSIllumina ill
	LEFT JOIN tblsubject sub
		on sub.sourceSystemIDLabel =
				case sub.studyID 
				WHEN 1 THEN ill.ITMISubjectID    
				WHEN 2 THEN LEFT(ill.ITMISubjectID ,4) + SUBSTRING(ill.ITMISubjectID ,8,10) 
			END
WHERE sub.subjectID is null
and LEFT(ITMISUBJECTID,4) NOT IN ('103-')
order by ill.itmisubjectID


--**specimen # by subject
GO
DROP TABLE #specimen
DROP TABLE #numOfSpecimenPerSubject
GO
select 
LEFT(specimen.EXTERNAL_REFERENCE ,4) + SUBSTRING(specimen.EXTERNAL_REFERENCE ,8,8)  as subjectID
, LEFT(specimen.EXTERNAL_REFERENCE ,4) + SUBSTRING(specimen.EXTERNAL_REFERENCE ,8,5)  as FamilyID
Into #specimen
FROM itmistaging.nautilus.aliquot al
	INNER JOIN  itmistaging.nautilus.sample specimen
		ON specimen.sample_ID = al.SAMPLE_ID
WHERE LEFT(specimen.EXTERNAL_REFERENCE ,4) = '102-'

SELECT subjectID,count(*) numOfSpecimenPerSubject
into #numOfSpecimenPerSubject
FROM #specimen
GROUP BY subjectID
ORDER BY subjectID


SELECT familyID,count(*) numOfSpecimenPerFamily
FROM #specimen
GROUP BY familyID
ORDER BY familyID

--find subjects that do not have samples in LIMS 102
select *
FROM tblSubject sub
	LEFT JOIN #numOfSpecimenPerSubject specSub
		ON specSub.subjectID = sub.sourceSystemIDLabel
where specSub.subjectID IS NULL
	and studyID = 2
ORDER BY sub.sourceSystemIDLabel


--find specimens that do not have subjects in subject table
SELECT *
FROM #numOfSpecimenPerSubject specSub
	LEFT JOIN tblSubject sub 
		ON sub.sourceSystemIDLabel = specSub.subjectID
WHERE sub.subjectID IS NULL
ORDER BY specSub.subjectID

--**aws file by subject - might be agregating by mom



select * FROM itmidw.dbo.[tblFile]



