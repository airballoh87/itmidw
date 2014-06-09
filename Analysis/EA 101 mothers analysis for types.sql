--SELECT CONVERT(Varchar(100),'RNAseq') as analysisType INTO #analyisType 
--INSERT INTO #analyisType SELECT 'microRNA'
--INSERT INTO #analyisType SELECT 'WGS'
DROP TABLE #subjectList

--(1)  subject list cross join to analysistype
SELECT sub.sourceSystemIDLabel, a.analysisType, sub.subjectID, case when withD.subjectID IS NOT NULL THEN 'Withdrew' ELSE '' END as WithDrawl, sub.cohortRole
 INTO #subjectList
from itmidw.tblsubject sub
	LEFT JOIN itmidw.tblSubjectWithDrawal withD
		ON withD.subjectID = sub.subjectID
	CROSS Join #analyisType a
where sub.cohortrole IN ( 'Mother', 'Father','Infant')
	and sub.studyID = 1
	ORDER BY sourceSystemIDLabel

--select * FROM  #subjectList	

--****************
--**Set of unions**
--****************
--(2)  AWS

DROP TABLE  #detail

select WithDrawl,SubjectID, sourceSystemIDLabel, eventName, EventSpecification, family
INTO #detail
	FROM (
--Big UNION ALL statement

	select sl.WithDrawl,sl.SubjectID, sl.sourceSystemIDLabel, eve.eventName, ISNULL(CONVERT(varchar(100),eve.eventDate,101),'') as EventSpecification
	, RIGHT(sourceSystemIDLabel,3) as Family
	from #subjectList sl
	LEFT  JOIN itmidw.tblevent eve
		on eve.subjectiD = sl.subjectID
			AND eve.eventName in ('Mother -  Bio file type: RNAseq','Mother -  Bio file type: microRNA','Mother -  Bio file type: WGS','Father -  Bio file type: WGS','Infant -  Bio file type: WGS')

	UNION ALL
	--(3) Manifests
--DNA
	select sl.WithDrawl,sl.SubjectID, sl.sourceSystemIDLabel,'EA Manifest - Outbound - ' + CONVERT(varchar(100),ISNULL(mani.specimenType,'')),ISNULL(mani.specimenType,'')
	, RIGHT(sourceSystemIDLabel,3) as Family
	from #subjectList sl
		LEFT JOIN [dbo].[manifestEa] mani
			On mani.convertedITMISubjectID = sl.sourceSystemIDLabel
	WHERE mani.specimenType = 'DNA'



UNION ALL
	--total RNA
	select sl.WithDrawl,sl.SubjectID, sl.sourceSystemIDLabel,'EA Manifest - Outbound - ' + CONVERT(varchar(100),ISNULL(mani.specimenType,'')),ISNULL(mani.specimenType,'')
	, RIGHT(sourceSystemIDLabel,3) as Family
	from #subjectList sl
		LEFT JOIN [dbo].[manifestEa] mani
			On mani.convertedITMISubjectID = sl.sourceSystemIDLabel
	WHERE mani.specimenType = 'total RNA'
UNION ALL
--Paxgene vial
		select sl.WithDrawl,sl.SubjectID, sl.sourceSystemIDLabel,'2 - EA Manifest - Outbound - ' + CONVERT(varchar(100),ISNULL(mani.specimenType,'')),ISNULL(mani.specimenType,'')
		, RIGHT(sourceSystemIDLabel,3) as Family
	from #subjectList sl
		LEFT JOIN [dbo].[manifestEa] mani
			On mani.convertedITMISubjectID = sl.sourceSystemIDLabel
	WHERE mani.specimenType = 'Paxgene vial'

	UNION ALL	
	--(4) Failures

	select sl.WithDrawl,sl.SubjectID, sl.sourceSystemIDLabel,'1 - EA Specimen Failures at EA',ISNULL(ea.failReason,'')
	, RIGHT(sourceSystemIDLabel,3) as Family
	from #subjectList sl
		LEFT JOIN [dbo].[eaSpecimenFailures] ea
			ON ea.itmiSpecimenID = sl.sourceSystemIDLabel

	UNION ALL

	--(5) EA rolling manifests
--Genotyping - Illumina IN methylation
	select sl.WithDrawl,sl.SubjectID, sl.sourceSystemIDLabel,'EA Recieved Specimen Status - ' +CONVERT(varchar(100),ISNULL([Service Type],'')),ISNULL([Service Type],'')+ ' - ' + Delivered
	, RIGHT(sourceSystemIDLabel,3) as Family
		from #subjectList sl
			LEFT JOIN [dbo].[eaRollingShipmentDocument] eaDoc
				on eaDoc.convertSpecimentID = sl.sourceSystemIDLabel
	WHERE eaDoc.[Service Type] = 'Genotyping - Illumina IN methylation'

	UNION ALL

--Seq - Illumina TS RNA
	select sl.WithDrawl,sl.SubjectID, sl.sourceSystemIDLabel,'EA Recieved Specimen Status - ' +CONVERT(varchar(100),ISNULL([Service Type],'')),ISNULL([Service Type],'')+ ' - ' + Delivered
	, RIGHT(sourceSystemIDLabel,3) as Family
		from #subjectList sl
			LEFT JOIN [dbo].[eaRollingShipmentDocument] eaDoc
				on eaDoc.convertSpecimentID = sl.sourceSystemIDLabel
	WHERE eaDoc.[Service Type] = 'Seq - Illumina TS RNA'

	UNION ALL

--Seq - Illumina TS Small RNA
	select sl.WithDrawl,sl.SubjectID, sl.sourceSystemIDLabel,'EA Recieved Specimen Status - ' +CONVERT(varchar(100),ISNULL([Service Type],'')),ISNULL([Service Type],'') + ' - ' + Delivered
	, RIGHT(sourceSystemIDLabel,3) as Family
		from #subjectList sl
			LEFT JOIN [dbo].[eaRollingShipmentDocument] eaDoc
				on eaDoc.convertSpecimentID = sl.sourceSystemIDLabel
	WHERE eaDoc.[Service Type] = 'Seq - Illumina TS Small RNA'
--CGI manifest
UNION ALL
--mother
select 
	sl.WithDrawl,sl.SubjectID
	, sl.sourceSystemIDLabel
	, 'CGI Manifest -  Outbound - Mother'
	, 'Barcode: ' + cgi.plateRowCol
	, RIGHT(sourceSystemIDLabel,3) as Family
		from #subjectList sl
			INNER JOIN  dbo.manifestCGI cgi 
				ON cgi.subjectID = sl.sourceSystemIDLabel
WHERE cohortRole = 'Mother'
UNION ALL
--father
select 
	sl.WithDrawl,sl.SubjectID
	, sl.sourceSystemIDLabel
	, 'CGI Manifest -  Outbound - Father'
	, 'Barcode: ' + cgi.plateRowCol
	, RIGHT(sourceSystemIDLabel,3) as Family
		from #subjectList sl
			INNER JOIN  dbo.manifestCGI cgi 
				ON cgi.subjectID = sl.sourceSystemIDLabel
WHERE cohortRole = 'Father'

UNION ALL
--infant
select 
	sl.WithDrawl,sl.SubjectID
	, sl.sourceSystemIDLabel
	, 'CGI Manifest - Outbound - Infant'
	, 'Barcode: ' + cgi.plateRowCol
	, RIGHT(sourceSystemIDLabel,3) as Family
		from #subjectList sl
			INNER JOIN  dbo.manifestCGI cgi 
				ON cgi.subjectID = sl.sourceSystemIDLabel
WHERE cohortRole = 'Infant'		
		
	

	) as A

exec [dbo].[CrossTab] 	
'
select WithDrawl,SubjectID,ISNULL(eventName,''na'') as eventName, ISNULL(EventSpecification,''na'') as EventSpecification, family
FROM #detail
'

, 'eventName'--column headers

, 'MAX(EventSpecification)' --detail listing

, 'Family,WithDrawl' --GROUP BY




