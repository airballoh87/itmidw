--(select sourcesystemID  from itmidw.tblSourceSystem where sourceSystemShortName = 'epicInova')
--ALTER TABLE [EPIC].[epicMOMDiags]  add matchSubjectID int
--ALTER TABLE [EPIC].[epicMOMDemo]  add matchSubjectID int
--ALTER TABLE [EPIC].[epicMOMDiagsI3E]  add matchSubjectID int
--ALTER TABLE [EPIC].[epicMOMLabs] add matchSubjectID INT

update [EPIC].[epicMOMDiags]  set matchSubjectID = NULL
update [EPIC].epicMOMDemo  set matchSubjectID = NULL
update [EPIC].epicMOMDiagsI3E  set matchSubjectID = NULL
update [EPIC].epicMOMLabs  set matchSubjectID = NULL

--**TDL - better way to reset the counter for the diagnosis \ lab orders.
GO
DROP TABLE #encounter
DROP TABLE #subjectDemo
DROP TABLE #obscureRef
DROP TABLE #encounterIe3
DROP TABLE #encounterLab
DROP TABLE #DiagInsert --**
DROP TABLE #LabInsert--**
GO
--/*
---*********************************
--delivery Date - PREP For Obscuring
---*********************************

--***********************
--*****prep**************
--***********************

Select cfrA.fieldValue as obscureDate,sub.subjectID, sub.sourceSystemIDLabel
into #obscureRef
from itmidw.tblCrfEventAnswers cfrA
	inner join itmidw.tblsubject sub
		on sub.subjectID = cfra.subjectID
Where sub.studyID =1
	and sub.cohortRole = 'Mother'
	and cfrA.sourceSystemFieldDataLabel = 'Date and Time of Delivery'

INSERT INTO #obscureRef (obscureDate,subjectID,sourceSystemIDLabel)
Select cfrA.fieldValue as obscureDate,sub.subjectID, sub.sourceSystemIDLabel
from itmidw.tblCrfEventAnswers cfrA
	inner join itmidw.tblsubject sub
		on sub.subjectID = cfra.subjectID
Where sub.studyID =1
	and sub.cohortRole = 'Father'
	and cfrA.sourceSystemFieldDataLabel = 'Date of Birth'


INSERT INTO #obscureRef (obscureDate,subjectID,sourceSystemIDLabel)
Select cfrA.fieldValue as obscureDate,sub.subjectID,sub.sourceSystemIDLabel
from itmidw.tblCrfEventAnswers cfrA
	inner join itmidw.tblsubject sub
		on sub.subjectID = cfra.subjectID
Where sub.studyID =1
	and sub.cohortRole = 'Infant'
	and cfrA.sourceSystemFieldDataLabel = 'Date of Birth'

--****************
--**[epicMOMDemo]
--****************
--put in temp table
select 
	sub.sourceSystemIDLabel
	, LAST_NAME
	, FIRST_NAME
	, sex
	, zip
	, race
	, ETHNIC_GROUP
	, mrn
	, sub.subjectID
INTO #subjectDemo
from epic.[epicMOMDemo] demo
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

--****************
--**[epicMOMDiags]
--****************
update [EPIC].[epicMOMDiags] set matchSubjectID = sub.subjectID
FROM [EPIC].[epicMOMDiags] Diag
	INNER join itmidw.tblSubjectIdentifer id
		on id.subjectIdentifier = CONVERT(varchar(100),diag.mrn)
			and id.subjectIdentifierType = 'MRN'
	INNER join itmidw.tblsubject sub
		on sub.subjectID = id.subjectID
where diag.matchSubjectID is null


update [EPIC].[epicMOMDiags] set matchSubjectID = sub.subjectID
FROM [EPIC].[epicMOMDiags] Diag
	INNER join itmidw.tblSubjectIdentifer id
		on id.subjectIdentifier = CONVERT(varchar(100),diag.provided_mrn)
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
	, ROW_NUMBER() OVER(PARTITION BY subjectID ORDER BY subjectID,max(admit_date))diagencounterOrder
INTO #encounter
FROM [EPIC].[epicMOMDiags] Diag 
	INNER join itmidw.tblsubject sub
		on sub.subjectID = diag.matchsubjectID
GROUP BY sub.subjectID, csn

--put records into insert table
select 
	sub.sourceSystemIDLabel
	, CONVERT(varchar(100),NULL) as encounterType --****need to determine if Epic has this.
	, diag.admit_date
	, diag.disch_date
	, DATEDIFF(dd, ref.obscureDate, diag.admit_date) daysToencounterAdmitDate
	, DATEDIFF(dd, ref.obscureDate,  diag.disch_date) daysToencounterDischargeDate
	, DATEDIFF(dd,e.minAdminDate, e.maxAdminDate) as encounterLengthInDays
	, diag.diag_id as epicDiagnosisID
	, diag.diag_Priority as encounterDiagnosisPriority
	, diag.diag_name as encounterDiagnosisName
	, diag.diag_ICD9 as encounterICD9
	, e.diagencounterOrder
	, e.DiagnosisCnt encounterDiagnosisCnt
	, headerMatchID as SourceSystemEventID --**
	, sub.subjectID
INTO #DiagInsert--**
FROM [EPIC].[epicMOMDiags] Diag 
	INNER join itmidw.tblsubject sub
		on sub.subjectID = diag.matchsubjectID
	INNER JOIN #encounter e
		on e.headerMatchID = diag.csn
			and e.subjectID = sub.subjectID
	INNER JOIN #obscureRef ref
		on ref.subjectID = sub.subjectID

--** all new
/*
--INSERT INTO itmidw.[tblEvent]([sourceSystemEventID],[eventType],[eventName],[studyID],[orgSourceSystemID],[createDate],[createdBy], SubjectID)
SELECT 
	di.SourceSystemEventID
	, 'EHR Ecounter'
	, ISNULL(di.encounterType,'No Encounter Type Specified') 
	, (SELECT stud.studyID FROM itmidw.tblStudy stud WHERE stud.studyshortID like '%101%') AS StudyID
	, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'INFOPATH') AS orgSourceSystemID
	, GETDATE()
	, 'usp_Study101Event'  
	,di.subjectID
	--select *
FROM #DiagInsert di
*/
--****************
--**[epicMOMDiagI3E]
--****************
--Match SubjectID
update [EPIC].[epicMOMDiagsI3E] set matchSubjectID = sub.subjectID
FROM [EPIC].[epicMOMDiagsI3E] diag
	inner join itmidw.tblSubjectIdentifer id
		on LTRIM(RTRIM(id.subjectIdentifier)) = RTRIM(LTRIM(diag.I3E_PAT_MRN))
			and id.subjectIdentifierType = 'MRN'
	INNER join itmidw.tblsubject sub
		on sub.subjectID = id.subjectID
where diag.matchSubjectID is null


--SELECT * FROM epic.[epicMOMDiagsI3E] diag where diag.matchSubjectID is null

--find counter for date
select 
	sub.subjectID
	, acct as headerMatchID
	, COUNT(*) as DiagnosisCnt
	, MIN(admit_dt) as minAdminDate
	, MAX(disch_dt) as maxAdminDate
	, ROW_NUMBER() OVER(PARTITION BY subjectID ORDER BY subjectID,max(admit_dt) ) diagencounterOrder
INTO #encounterIe3
FROM [EPIC].epicMOMDiagsI3E Diag 
	INNER join itmidw.tblsubject sub
		on sub.subjectID = diag.matchsubjectID
GROUP BY sub.subjectID, acct


INSERT INTO #DiagInsert (	
sourceSystemIDLabel, encounterType, admit_date, disch_date, daysToencounterAdmitDate, daysToencounterDischargeDate, encounterLengthInDays, epicDiagnosisID, encounterDiagnosisPriority, encounterDiagnosisName, encounterICD9, diagencounterOrder, encounterDiagnosisCnt, SourceSystemEventID, subjectID
)
select 
	sub.sourceSystemIDLabel
	, diag.ENC_TYPE as encounterType
	, diag.admit_dt
	, diag.disch_dt
	, DATEDIFF(dd, ref.obscureDate, diag.admit_dt) daysToencounterAdmitDate
	, DATEDIFF(dd, ref.obscureDate,  diag.disch_dt) daysToencounterDischargeDate
	, DATEDIFF(dd,e.minAdminDate, e.maxAdminDate) as encounterLengthInDays
	, NULL as epicDiagnosisID  --does not exist on I3E
	, diag.diag_Priority as encounterDiagnosisPriority
	, diag.diag_desc as encounterDiagnosisName
	, diag.ICD9 as encounterICD9
	, e.diagencounterOrder
	, e.DiagnosisCnt encounterDiagnosisCnt
	, headerMatchID as SourceSystemEventID --**
	, sub.subjectID
FROM [EPIC].[epicMOMDiagsI3E] Diag 
	INNER join itmidw.tblsubject sub
		on sub.subjectID = diag.matchsubjectID
	INNER JOIN #encounterIe3 e
		on e.headerMatchID = diag.acct
			and e.subjectID = sub.subjectID
	INNER JOIN #obscureRef ref
		on ref.subjectID = sub.subjectID


--create select statement
SELECT  * FROM #DiagInsert

--need to create these tables
--tblEHREventEncounter (EHREncounterID, eventID, sourcesystemEventID, subjectID, encounterStartDate, encounterEndDate,encounterLengthInDays, encounterOrder, diagnosisCnt, [orgSourceSystemID],[createDate],[createdBy])
--tblEHRDiagnosis (EHRDiagnosisID,sourceSystemDiagnosisID, subjectId, EHREncounterID, diagnosisPriority, diagnosisName, diagnosisICD9, [orgSourceSystemID],[createDate],[createdBy])

--detail record

---***************
---*****Labs*******
---***************


--*/
update [EPIC].[epicMOMLabs] set matchSubjectID = sub.subjectID
FROM [EPIC].[epicMOMLabs] labs
	INNER join itmidw.tblSubjectIdentifer id
		on id.subjectIdentifier = CONVERT(varchar(100),labs.mrn)
			and id.subjectIdentifierType = 'MRN'
	INNER join itmidw.tblsubject sub
		on sub.subjectID = id.subjectID
where labs.matchSubjectID is null


update [EPIC].[epicMOMLabs] set matchSubjectID = sub.subjectID
FROM [EPIC].[epicMOMLabs] labs
	INNER join itmidw.tblSubjectIdentifer id
		on id.subjectIdentifier = CONVERT(varchar(100),labs.provided_mrn)
			and id.subjectIdentifierType = 'MRN'
	INNER join itmidw.tblsubject sub
		on sub.subjectID = id.subjectID
where labs.matchSubjectID is null

--5156 still missing
--select * FROM [EPIC].[epicMOMLabs] labs where labs.matchSubjectID is null
select 
sub.subjectID
, labs.PARENT_ORDER_ID
, labs.PARENT_ORDER_DESC
, labs.PARENT_ORDER_DATE
, labs.RESULT_TIME
, ROW_NUMBER() OVER(PARTITION BY subjectID ORDER BY sub.subjectID, parent_order_id) diagencounterOrder
, COUNT(*) resultsPerOrder
INTO #encounterLab
FROM [EPIC].[epicMOMLabs] labs
	INNER join itmidw.tblsubject sub
		on sub.subjectID = labs.matchsubjectID
GROUP BY
	sub.subjectID
	, labs.PARENT_ORDER_ID
	, labs.PARENT_ORDER_DESC
	, labs.PARENT_ORDER_DATE
	, labs.RESULT_TIME



select 
	sub.sourceSystemIDLabel
	, labs.PARENT_ORDER_ID as sourceSystemEventID
	, DATEDIFF(dd, ref.obscureDate,  labs.PARENT_ORDER_DATE) daysToEnounterOrderDate
	, labs.PARENT_ORDER_DESC
	, DATEDIFF(dd, ref.obscureDate, labs.RESULT_TIME) daysToEnounterResultDate 
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
INTO #LabInsert
FROM [EPIC].[epicMOMLabs] labs
	INNER join itmidw.tblsubject sub
		on sub.subjectID = labs.matchsubjectID
	INNER JOIN #encounterLab ec
		on ec.SubjectID = sub.subjectID
			and ec.PARENT_ORDER_ID = labs.PARENT_ORDER_ID
			and ec.PARENT_ORDER_DESC = labs.PARENT_ORDER_DESC
			and ec.PARENT_ORDER_DATE = labs.PARENT_ORDER_DATE
			and ec.RESULT_TIME = labs.RESULT_TIME
	INNER JOIN #obscureRef ref
		on ref.subjectID = sub.subjectID

--SELECT * FROM epic.[epicMOMLabs] diag where diag.matchSubjectID is null

--INSERT INTO itmidw.[tblEvent]([sourceSystemEventID],[eventType],[eventName],[studyID],[orgSourceSystemID],[createDate],[createdBy], SubjectID)
--SELECT DISTINCT
--	lab.SourceSystemEventID
--	, 'EHR Lab Result'
--	, lab.PARENT_ORDER_DESC
--	, (SELECT stud.studyID FROM itmidw.tblStudy stud WHERE stud.studyshortID like '%101%') AS StudyID
--	, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'INFOPATH') AS orgSourceSystemID
--	, GETDATE()
--	, 'usp_Study101Event'  
--	,lab.subjectID
--	--select *
--FROM #LabInsert lab

select * from #LabInsert 
--need to create these tables
--tblEHREventLab (EHREventLabID, eventID, sourcesystemEventID, subjectID, labOrderDate, labResultDate,labLengthInDays, labOrder, labComponentCnt, [orgSourceSystemID],[createDate],[createdBy])
--tblEHRLabComponentResult (EHRLabComponentResultID,sourceSystemLabComponentResultID, subjectId, EHREventLabID, componentName, labInterpretation, labResult, refHigh, refLow, refNormValue, refUnit, [orgSourceSystemID],[createDate],[createdBy])
--tblEHREventEncounter (EHREncounterID, eventID, sourcesystemEventID, subjectID, encounterStartDate, encounterEndDate,encounterLengthInDays, encounterOrder, diagnosisCnt, [orgSourceSystemID],[createDate],[createdBy])
--tblEHRDiagnosis (EHRDiagnosisID,sourceSystemDiagnosisID, subjectId, EHREncounterID, diagnosisPriority, diagnosisName, diagnosisICD9, [orgSourceSystemID],[createDate],[createdBy])
