--tblEHREventLab (EHREventLabID, eventID, sourcesystemEventID, subjectID, labOrderDate, labResultDate,labLengthInDays, labOrder, labComponentCnt, [orgSourceSystemID],[createDate],[createdBy])
CREATE TABLE itmidw.tblEHREventLab 
	(EHREventLabID INT IDENTITY(1,1)
	, eventID INT  --FK to tblEvent
	, sourcesystemEventID VARCHAR(100) 
	, subjectID INT --FK to tblSubject
	, labOrderDate DATETIME 
	, labResultDate DATETIME
	, labLengthInDays INT
	, labOrder  VARCHAR(100)
	, labComponentCnt INT
	, [orgSourceSystemID] INT--FK to tblSourceSystem
	, [createDate] DATETIME
	, [createdBy]  VARCHAR(100)
	)

--tblEHRLabComponentResult (EHRLabComponentResultID,sourceSystemLabComponentResultID, subjectId, EHREventLabID, componentName, labInterpretation, labResult, refHigh, refLow, refNormValue, refUnit, [orgSourceSystemID],[createDate],[createdBy])
CREATE TABLE itmidw.tblEHRLabComponentResult 
	(EHRLabComponentResultID INT IDENTITY(1,1)
	, sourceSystemLabComponentResultID INT
	, subjectID INT
	, EHREventLabID INT
	, componentName  VARCHAR(100) 
	, labInterpretation  VARCHAR(100) 
	, labResult VARCHAR(100) 
	, refHigh VARCHAR(100) 
	, refLow VARCHAR(100) 
	, refNormValue VARCHAR(100) 
	, refUnit VARCHAR(100) 
	, [orgSourceSystemID]  INT
	, [createDate] DATETIME
	, [createdBy]  VARCHAR(100) 
	)
--tblEHREventEncounter (EHREncounterID, eventID, sourcesystemEventID, subjectID, encounterStartDate, encounterEndDate,encounterLengthInDays, encounterOrder, diagnosisCnt, [orgSourceSystemID],[createDate],[createdBy])
CREATE TABLE itmidw.tblEHREventEncounter 
	(EHREncounterID INT IDENTITY(1,1)
	, eventID INT
	, sourcesystemEventID    VARCHAR(100) 
	, subjectID INT
	, encounterType Varchar(50)
	, encounterStartDate DATETIME
	, encounterEndDate DATETIME
	, encounterLengthInDays INT
	, encounterOrder INT
	, diagnosisCnt INT
	, [orgSourceSystemID] INT
	, [createDate] DATETIME
	, [createdBy]   VARCHAR(100) 
	)
--tblEHRDiagnosis (EHRDiagnosisID,sourceSystemDiagnosisID, subjectId, EHREncounterID, diagnosisPriority, diagnosisName, diagnosisICD9, [orgSourceSystemID],[createDate],[createdBy])
 CREATE TABLE itmidw.tblEHRDiagnosis 
	(EHRDiagnosisID INT IDENTITY(1,1)
	, sourceSystemDiagnosisID INT
	, subjectID INT
	, EHREncounterID INT
	, diagnosisPriority INT
	, diagnosisName  VARCHAR(100) 
	, diagnosisICD9  VARCHAR(100) 
	, [orgSourceSystemID] INT
	, [createDate] DATETIME
	, [createdBy]  VARCHAR(100) 
	)
