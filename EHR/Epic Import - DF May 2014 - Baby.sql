--(select sourcesystemID  from itmidw.tblSourceSystem where sourceSystemShortName = 'epicInova')
--ALTER TABLE [EPIC].[EpicNBDiags]  add matchSubjectID int
--ALTER TABLE [EPIC].[EpicNBDemo]  add matchSubjectID int
--ALTER TABLE [EPIC].[EpicNBDiagsI3E]  add matchSubjectID int
--ALTER TABLE [EPIC].[EpicNBLabs] add matchSubjectID INT

--****************
--**[EpicNBDiags]
--****************

--delivery Date
update [EPIC].[epicNBDiags]  set matchSubjectID = NULL
update [EPIC].epicNBDemo  set matchSubjectID = NULL
update [EPIC].epicNBDiagsi3E  set matchSubjectID = NULL
update [EPIC].epicNBLabs  set matchSubjectID = NULL

--**TDL - better way to reset the counter for the diagnosis \ lab orders.

DROP TABLE #encounter
--DROP TABLE #subjectDemo
DROP TABLE #obscureRef
DROP TABLE #encounterIe3
DROP TABLE #encounterLab
GO
--/*
--****************
--**[epicNBDiags]
--****************

--delivery Date
Select cfrA.fieldValue as obscureDate,sub.subjectID, sub.sourceSystemIDLabel, right(sub.sourceSystemIDLabel,3) as itmiFamilyID
into #obscureRef
from itmidw.tblCrfEventAnswers cfrA
	inner join itmidw.tblsubject sub
		on sub.subjectID = cfra.subjectID
Where sub.studyID =1
	and sub.cohortRole = 'Mother'
	and cfrA.sourceSystemFieldDataLabel = 'Date and Time of Delivery'


update [EPIC].[EpicNBDiags] set matchSubjectID = sub.subjectID
FROM [EPIC].[EpicNBDiags] Diag
	INNER join itmidw.tblSubjectIdentifer id
		on id.subjectIdentifier = CONVERT(varchar(100),diag.mrn)
			and id.subjectIdentifierType = 'MRN'
	INNER join itmidw.tblsubject sub
		on sub.subjectID = id.subjectID
where diag.matchSubjectID is null



update [EPIC].[EpicNBDiags] set matchSubjectID = sub.subjectID
FROM [EPIC].[EpicNBDiags] Diag
	INNER join itmidw.tblSubjectIdentifer id
		on id.subjectIdentifier = CONVERT(varchar(100),diag.provided_mrn)
			and id.subjectIdentifierType = 'MRN'
	INNER join itmidw.tblsubject sub
		on sub.subjectID = id.subjectID
where diag.matchSubjectID is null



--****************
--**[EpicNBDemo]
--****************
--put in temp table
select 
	sub.sourceSystemIDLabel
	--, LAST_NAME
	--, FIRST_NAME
	, sex
	, zip
	, race
	, ETHNIC_GROUP
	--, mrn
	, sub.subjectID
--INTO #subjectDemo
from epic.[EpicNBDemo] demo
	INNER join itmidw.tblSubjectIdentifer id
		on id.subjectIdentifier = CONVERT(varchar(100),demo.mrn)
			and id.subjectIdentifierType = 'MRN'
	INNER join itmidw.tblsubject sub
		on sub.subjectID = id.subjectID
where demo.matchSubjectID is null

--update table person
--UPDATE itmidw.tblperson SET 
--	mrn = sb.mrn
--	, raceCode = sb.race
--	, ethnicityCode = sb.ETHNIC_GROUP
--	, sex = sb.sex
--	, zip = sb.zip
--	, lastName = sb.LAST_NAME
--	, firstName =sb.FIRST_NAME
--from itmidw.tblPerson person
--	INNER JOIN itmidw.tblsubject sub
--		on sub.personID = person.personID
--	INNER JOIN #subjectDemo sb
--		on sb.SubjectID = sub.subjectID

--Match SubjectID
update [EPIC].[EpicNBDiagsI3E] set matchSubjectID = sub.subjectID
FROM [EPIC].[EpicNBDiagsI3E] diag
	inner join itmidw.tblSubjectIdentifer id
		on LTRIM(RTRIM(id.subjectIdentifier)) = RTRIM(LTRIM(diag.PAT_MRN))
			and id.subjectIdentifierType = 'MRN'
	INNER join itmidw.tblsubject sub
		on sub.subjectID = id.subjectID
where diag.matchSubjectID is null



--find counter for date
select 
	sub.subjectID
	, csn as headerMatchID
	, COUNT(*) as DiagnosisCnt
	, MIN(admit_date) as minAdminDate
	, MAX(disch_date) as maxAdminDate
	, ROW_NUMBER() OVER(PARTITION BY sub.subjectID ORDER BY sub.subjectID,max(admit_date))diagencounterOrder
INTO #encounter
FROM [EPIC].[EpicNBDiags] Diag 
	INNER join itmidw.tblsubject sub
		on sub.subjectID = diag.matchsubjectID
GROUP BY sub.subjectID, csn


--find counter for date
select 
	sub.subjectID
	, acct as headerMatchID
	, COUNT(*) as DiagnosisCnt
	, MIN(admit_dt) as minAdminDate
	, MAX(disch_dt) as maxAdminDate
	, ROW_NUMBER() OVER(PARTITION BY sub.subjectID ORDER BY sub.subjectID,max(admit_dt))diagencounterOrder
INTO #encounterIe3
FROM [EPIC].EpicNBDiagsI3E Diag 
	INNER join itmidw.tblsubject sub
		on sub.subjectID = diag.matchsubjectID
GROUP BY sub.subjectID, acct



select 
	sub.sourceSystemIDLabel
	, NULL as encounterType --****need to determine if Epic has this.
	, DATEDIFF(dd, ref.obscureDate, diag.admit_date) daysToencounterAdmitDate
	, DATEDIFF(dd, ref.obscureDate,  diag.disch_date) daysToencounterDischargeDate
	, DATEDIFF(dd,e.minAdminDate, e.maxAdminDate) as encounterLengthInDays
	, diag.diag_id as epicDiagnosisID
	, diag.diag_Priority as encounterDiagnosisPriority
	, diag.diag_name as encounterDiagnosisName
	, diag.diag_ICD9 as encounterICD9
	, e.diagencounterOrder
	, e.DiagnosisCnt encounterDiagnosisCnt
--select COUNT(*)
FROM [EPIC].[EpicNBDiags] Diag 
	INNER join itmidw.tblsubject sub
		on sub.subjectID = diag.matchsubjectID
	INNER JOIN #encounter e
		on e.headerMatchID = diag.csn
			and e.subjectID = sub.subjectID
	INNER JOIN #obscureRef ref
		on ref.itmiFamilyID = RIGHT(sub.sourceSystemIDLabel,3)

UNION ALL

--detail record
select 
	sub.sourceSystemIDLabel
	, diag.ENC_TYPE as encounterType
	, DATEDIFF(dd, ref.obscureDate, diag.admit_dt) daysToencounterAdmitDate
	, DATEDIFF(dd, ref.obscureDate,  diag.disch_dt) daysToencounterDischargeDate
	, DATEDIFF(dd,e.minAdminDate, e.maxAdminDate) as encounterLengthInDays
	, NULL as epicDiagnosisID  --does not exist on I3E
	, diag.diag_Priority as encounterDiagnosisPriority
	, diag.diag_desc as encounterDiagnosisName
	, diag.ICD9 as encounterICD9
	, e.diagencounterOrder
	, e.DiagnosisCnt encounterDiagnosisCnt
--select *
FROM [EPIC].[EpicNBDiagsI3E] Diag 
	INNER join itmidw.tblsubject sub
		on sub.subjectID = diag.matchsubjectID
	INNER JOIN #encounterIe3 e
		on e.headerMatchID = diag.acct
			and e.subjectID = sub.subjectID
	INNER JOIN #obscureRef ref
		on ref.itmiFamilyID = RIGHT(sub.sourceSystemIDLabel,3)


update [EPIC].[EpicNBLabs] set matchSubjectID = sub.subjectID
FROM [EPIC].[EpicNBLabs] labs
	INNER join itmidw.tblSubjectIdentifer id
		on id.subjectIdentifier = CONVERT(varchar(100),labs.mrn)
			and id.subjectIdentifierType = 'MRN'
	INNER join itmidw.tblsubject sub
		on sub.subjectID = id.subjectID
where labs.matchSubjectID is null


update [EPIC].[EpicNBLabs] set matchSubjectID = sub.subjectID
FROM [EPIC].[EpicNBLabs] labs
	INNER join itmidw.tblSubjectIdentifer id
		on id.subjectIdentifier = CONVERT(varchar(100),labs.provided_mrn)
			and id.subjectIdentifierType = 'MRN'
	INNER join itmidw.tblsubject sub
		on sub.subjectID = id.subjectID
where labs.matchSubjectID is null


select 
sub.subjectID
, labs.PARENT_ORDER_ID
, labs.PARENT_ORDER_DESC
, labs.PARENT_ORDER_DATE
, labs.RESULT_TIME
, ROW_NUMBER() OVER(PARTITION BY sub.subjectID ORDER BY sub.subjectID, parent_order_id) diagencounterOrder
, COUNT(*) resultsPerOrder
INTO #encounterLab
FROM [EPIC].[EpicNBLabs] labs
	INNER join itmidw.tblsubject sub
		on sub.subjectID = labs.matchsubjectID
GROUP BY
	sub.subjectID
	, labs.PARENT_ORDER_ID
	, labs.PARENT_ORDER_DESC
	, labs.PARENT_ORDER_DATE
	, labs.RESULT_TIME




select 
	sub.sourceSystemIDLabel as subjectID
	, labs.PARENT_ORDER_ID
	, DATEDIFF(dd, ref.obscureDate,  labs.PARENT_ORDER_DATE) daysToEnounterOrderDate
	, labs.PARENT_ORDER_DESC
	, DATEDIFF(dd, ref.obscureDate, labs.RESULT_TIME) daysToEnounterOrderDate 
	, labs.COMPONENT_ID
	, labs.COMPONENT_NAME
	, labs.INTERP
	, labs.LAB_RESULT
	, labs.REF_HIGH
	, labs.REF_LOW
	, labs.REF_NORM_VALS
	, labs.REF_UNIT
	, ec.diagencounterOrder
	, ec.resultsPerOrder
FROM [EPIC].[EpicNBLabs] labs
	INNER join itmidw.tblsubject sub
		on sub.subjectID = labs.matchsubjectID
	INNER JOIN #encounterLab ec
		on ec.SubjectID = sub.subjectID
			and ec.PARENT_ORDER_ID = labs.PARENT_ORDER_ID
			and ec.PARENT_ORDER_DESC = labs.PARENT_ORDER_DESC
			and ec.PARENT_ORDER_DATE = labs.PARENT_ORDER_DATE
			and ec.RESULT_TIME = labs.RESULT_TIME
	INNER JOIN #obscureRef ref
		on ref.itmiFamilyID = RIGHT(sub.sourceSystemIDLabel,3)


---**validation
--select DISTINCT diag.MRN
--FROM [EPIC].[EpicNBDiags] Diag 
--	LEFT join itmidw.tblsubject sub
--		on sub.subjectID = diag.matchsubjectID
--where sub.sourceSystemIDLabel IS NULL
--ORDER BY diag.MRN


--select [NB MRN]
--from epic.epicMRN
--UNION ALL
--select [NBMRN2]
--from epic.epicMRN
--where [NBMRN2] IS NOT NULL
--order by [NB MRN]

--select *
--from itmidw.tblSubjectIdentifer si
--where si.subjectIdentiferID = '13146454' 

--select [NBMRN2],*
--from epic.epicMRN
--where [NBMRN2]  = '13146454'


