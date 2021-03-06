USE [ITMIStaging]
GO
/****** Object:  StoredProcedure [itmidw].[usp_Study102Event]    Script Date: 6/9/2014 1:31:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/**************************************************************************
Created ON : 3/29/2014
Created By : AarON Black
Team Name : Informatics
Object name : [usp_Study102Event]
Functional : ITMI SSIS for Insert AND Update for event table
Purpose : Import of study 102 events for reporting AND analysis
History : Created ON 3/29/2014
**************************************************************************
Date Modified By QC# Purposes
**************************************************************************
#Date #Comment
**************************************************************************
USE CASE:
Truncate table itmidw.[tblEvent] 
EXEC [usp_Study102Event]
--testing update AND delete
--SELECT * FROM itmidw.[tblEvent] ORDER BY subjectID, eventdate
**************************************************************************/
ALTER PROCEDURE [itmidw].[usp_Study102Event]
AS
BEGIN
SET NOCOUNT ON;
DECLARE @UpdatedON SMALLDATETIME
SET @UpdatedON = CAST(GETDATE() AS SMALLDATETIME)
PRINT CONVERT(CHAR(23), @UpdatedOn, 121) + ' [usp_Study102Event][' + @@SERVERNAME + '][' + SYSTEM_USER + ']'
PRINT 'INSERT [ITMIDW].itmidw.[usp_Study102Event]...'


--****************************************
--drop table--****************************
--****************************************

IF OBJECT_ID('tempdb..#sourceEvent') IS NOT NULL
DROP TABLE #sourceEvent  

--****************************************
--Consent--*******************************
--****************************************
SELECT 
	subject.subjectID AS [subjectID]
	, CONVERT(varchar(100), SubjectConsent.ParticipantConsentID) AS [sourceSystemEventID]
	, CONVERT(varchar(100),'Consent') AS [eventType]
	, CONVERT(varchar(100),'Subject Consent') AS [eventName]
	, SubjectConsent.ConsentSigneddate AS  eventDate
	, subject.studyID AS [studyID]
	, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS orgSourceSystemID
	, GETDATE() AS createDate
	, CONVERT(VARCHAR(100),'usp_Study102Event')  AS createdBy
INTO #sourceEvent
FROM difzDBcopy.ParticipantConsent AS SubjectConsent --(3924) - tblclinicalDataDates
	INNER JOIN itmidw.tblSubject subject
		ON CONVERT(VARCHAR(100),subject.sourceSystemSubjectID) = CONVERT(VARCHAR(100),SubjectConsent.ParticipantID)

DELETE FROM #sourceEvent WHERE eventName = 'Subject Consent'

--****************************************
--Enroll (mom \ Baby)--*******************
--****************************************	
INSERT INTO #sourceEvent ([subjectID],[sourceSystemEventID],[eventType],[eventName],EventDate,[studyID],[orgSourceSystemID],[createDate],[createdBy])
SELECT  	
	subject.subjectID
	, CONVERT(varchar(100),deets.patientDataPointDetailID) AS [sourceSystemEventID]
	, CONVERT(varchar(100),'Mother Enrollment') AS [eventType]
	, CONVERT(varchar(100),'RAVE - Mother Enrollment') AS [eventName]
	, CONVERT(DATETIME,deets.fieldValue) AS EventDate
	, (SELECT stud.studyID FROM itmidw.tblStudy stud WHERE stud.studyshortID LIKE '%102%') AS StudyID
	, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS orgSourceSystemID
	, GETDATE() AS createDate
	, 'usp_Study102Event'  AS createdBy
--INTO #sourceEvent
FROM difzDBcopy.PatientDataPointDetail AS deets
	INNER JOIN itmidw.tblSubject subject
		ON subject.subjectId = deets.itmidwSubjectID
WHERE deets.isactive = 1	
	AND CASE WHEN CHARINDEX(' -',deets.dataPageName) = 0 THEN deets.datapageName ELSE 
	LEFT(deets.dataPageName,CHARINDEX(' -',deets.dataPageName)) END = 'Enrollment'
	AND deets.fieldName = 'ENICDATMO'
	AND ISDATE(deets.fieldValue) = 1


--****************************************
--Enroll (dad)--**************************
--****************************************
INSERT INTO #sourceEvent ([subjectID],[sourceSystemEventID],[eventType],[eventName],EventDate,[studyID],[orgSourceSystemID],[createDate],[createdBy])
SELECT  	
	subject.subjectID
	, deets.patientDataPointDetailID AS [sourceSystemEventID]
	,  CASE SUBSTRING(subject.sourcesystemIDlabel,11,2) 
		WHEN '01' THEN 'Mother '
		WHEN '02' THEN 'Father '
		WHEN '03' THEN 'New Born '
		ELSE 'Other' END + 
		 'Consent' AS [eventType]
	, 'RAVE - ' +CASE SUBSTRING(subject.sourcesystemIDlabel,11,2) 
		WHEN '01' THEN 'Mother '
		WHEN '02' THEN 'Father '
		WHEN '03' THEN 'New Born '
		ELSE 'Other' END + 
			'Informed Consent' AS [eventName]
	, deets.fieldValue AS EventDate
	, (SELECT stud.studyID FROM itmidw.tblStudy stud WHERE stud.studyshortID LIKE '%102%') AS StudyID
	, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS orgSourceSystemID
	, GETDATE() AS createDate
	, 'usp_Study102Event'  AS createdBy
FROM difzDBcopy.PatientDataPointDetail AS deets
	INNER JOIN itmidw.tblSubject subject
		ON subject.subjectId = deets.itmidwSubjectID
WHERE deets.isactive = 1	
 AND deets.itmiFormName = 'Informed Consent' 
 AND deets.fieldName = 'ICDAT'
 AND ISDATE(deets.fieldValue) = 1


 --****************************************
--Specimen CollectiON \ mom dad baby--****
--****************************************
INSERT INTO #sourceEvent ([subjectID],[sourceSystemEventID],[eventType],[eventName],EventDate,[studyID],[orgSourceSystemID],[createDate],[createdBy])
SELECT  	
	subject.subjectID
	, deets.patientDataPointDetailID AS [sourceSystemEventID]
	, CASE SUBSTRING(subject.sourcesystemIDlabel,11,2) 
		WHEN '01' THEN 'Mother '
		WHEN '02' THEN 'Father '
		WHEN '03' THEN 'New Born '
		ELSE 'Other' END + 
		 'Specimen Collection' AS [eventType]
	, 'RAVE - ' +CASE SUBSTRING(subject.sourcesystemIDlabel,11,2) 
		WHEN '01' THEN 'Mother '
		WHEN '02' THEN 'Father '
		WHEN '03' THEN 'New Born '
		ELSE 'Other' END + 
			'Specimen Collection' AS [eventName]
	, deets.fieldValue AS EventDate
	, (SELECT stud.studyID FROM itmidw.tblStudy stud WHERE stud.studyshortID LIKE '%102%') AS StudyID
	, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS orgSourceSystemID
	, GETDATE() AS createDate
	, 'usp_Study102Event'  AS createdBy
FROM difzDBcopy.PatientDataPointDetail AS deets
	INNER JOIN itmidw.tblSubject subject
		ON subject.subjectId = deets.itmidwSubjectID
WHERE deets.isactive = 1	
AND deets.itmiFormName ='Specimen Collection'
AND deets.fieldName = 'SC2DAT'
AND ISDATE(deets.fieldValue) = 1

--****************************************
--mom \ baby specimen collection--********
--****************************************
INSERT INTO #sourceEvent ([subjectID],[sourceSystemEventID],[eventType],[eventName],EventDate,[studyID],[orgSourceSystemID],[createDate],[createdBy])
SELECT  	
	subject.subjectID
	, deets.patientDataPointDetailID AS [sourceSystemEventID]
	, CASE SUBSTRING(subject.sourcesystemIDlabel,11,2) 
		WHEN '01' THEN 'Mother '
		WHEN '02' THEN 'Father '
		WHEN '03' THEN 'New Born '
		ELSE 'Other' END + 
		 'Specimen Collection' AS [eventType]
	, 'RAVE - ' +CASE SUBSTRING(subject.sourcesystemIDlabel,11,2) 
		WHEN '01' THEN 'Mother '
		WHEN '02' THEN 'Father '
		WHEN '03' THEN 'New Born '
		ELSE 'Other' END + 
			'Specimen Collection' AS [eventName]
	, deets.fieldValue AS EventDate
	, (SELECT stud.studyID FROM itmidw.tblStudy stud WHERE stud.studyshortID LIKE '%102%') AS StudyID
	, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS orgSourceSystemID
	, GETDATE() AS createDate
	, 'usp_Study102Event'  AS createdBy
FROM difzDBcopy.PatientDataPointDetail AS deets
	INNER JOIN itmidw.tblSubject subject
		ON subject.subjectId = deets.itmidwSubjectID
WHERE deets.isactive = 1	
AND deets.itmiFormName ='Mother AND Infant Specimen Collection'
AND deets.fieldName = 'SCDAT'
AND ISDATE(deets.fieldValue) = 1

--****************************************
--WithDrawal--**add --********************
--****************************************

--****************************************
--Delivery--******************************
--****************************************
INSERT INTO #sourceEvent ([subjectID],[sourceSystemEventID],[eventType],[eventName],EventDate,[studyID],[orgSourceSystemID],[createDate],[createdBy])
SELECT  	
	subject.subjectID
	, deets.patientDataPointDetailID AS [sourceSystemEventID]
	, 'Infant Date of Birth' AS [eventType]
	, 'RAVE - Infant Date of Birth' AS [eventName]
	, deets.fieldValue AS EventDate
	, (SELECT stud.studyID FROM itmidw.tblStudy stud WHERE stud.studyshortID LIKE '%102%') AS StudyID
	, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS orgSourceSystemID
	, GETDATE() AS createDate
	, 'usp_Study102Event'  AS createdBy
FROM difzDBcopy.PatientDataPointDetail AS deets
	INNER JOIN itmidw.tblSubject subject
		ON subject.subjectId = deets.itmidwSubjectID
WHERE deets.isactive = 1	
AND deets.itmiFormName = 'Infant Birth'
AND deets.fieldName  = 'NBBRTHDAT'
AND ISDATE(deets.fieldValue) = 1

--****************************************
--SubjectSpecimenCollection--*************
--****************************************

--****************************************
--blood--*********************************
--****************************************
INSERT INTO #sourceEvent ([subjectID],[sourceSystemEventID]
,[eventType],[eventName],EventDate,[studyID],[orgSourceSystemID],[createDate],[createdBy])
SELECT  	
	sub.subjectID
	, exer.participantSpecimenCollectionID
	, pv.codedescriptiON + ' - ' + CASE SUBSTRING(sub.sourcesystemIDlabel,11,2) 
		WHEN '01' THEN 'Mother '
		WHEN '02' THEN 'Father '
		WHEN '03' THEN 'New Born '
		ELSE 'Other' END + 
		 'Specimen Collection' AS [eventType]
	, 'RAVE - ' +  pv.codedescriptiON + ' - ' + CASE SUBSTRING(sub.sourcesystemIDlabel,11,2) 
		WHEN '01' THEN 'Mother '
		WHEN '02' THEN 'Father '
		WHEN '03' THEN 'New Born '
		ELSE 'Other' END + 
			'Specimen CollectiON - Blood' AS [eventName]
	, exer.eventDate AS EventDate
	, (SELECT stud.studyID FROM itmidw.tblStudy stud WHERE stud.studyshortID LIKE '%102%') AS StudyID
	, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS orgSourceSystemID
	, GETDATE() AS createDate
	, 'usp_Study102Event'  AS createdBy
FROM difzDBcopy.ParticipantSpecimenCollectiON exer
	INNER JOIN difzDBcopy.[PermissibleValues] pv --***06-09-2014
		ON pv.permissibleValuesID = exer.eventTypeCode
    INNER JOIN difzDBcopy.participant part
		ON part.participantID = exer.ParticipantID
	INNER JOIN itmidw.tblSubject sub ON 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1
		AND exer.bloodIndicator = 1
		
--****************************************
--saliva--********************************
--****************************************
INSERT INTO #sourceEvent ([subjectID],[sourceSystemEventID],[eventType],[eventName],EventDate,[studyID],[orgSourceSystemID],[createDate],[createdBy])
SELECT  	
	sub.subjectID
	, exer.participantSpecimenCollectionID
, pv.codedescriptiON + ' - ' + CASE SUBSTRING(sub.sourcesystemIDlabel,11,2) 
		WHEN '01' THEN 'Mother '
		WHEN '02' THEN 'Father '
		WHEN '03' THEN 'New Born '
		ELSE 'Other' END + 
		 'Specimen Collection' AS [eventType]
	,'RAVE - ' +  pv.codedescriptiON + ' - ' + CASE SUBSTRING(sub.sourcesystemIDlabel,11,2) 
		WHEN '01' THEN 'Mother '
		WHEN '02' THEN 'Father '
		WHEN '03' THEN 'New Born '
		ELSE 'Other' END + 
			'Specimen CollectiON - Saliva' AS [eventName]
	, exer.eventDate AS EventDate
	, (SELECT stud.studyID FROM itmidw.tblStudy stud WHERE stud.studyshortID LIKE '%102%') AS StudyID
	, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS orgSourceSystemID
	, GETDATE() AS createDate
	, 'usp_Study102Event'  AS createdBy
FROM difzDBcopy.ParticipantSpecimenCollectiON exer
	INNER JOIN difzDBcopy.[PermissibleValues] pv
		ON pv.permissibleValuesID = exer.eventTypeCode
    INNER JOIN difzDBcopy.participant part
		ON part.participantID = exer.ParticipantID
	INNER JOIN itmidw.tblSubject sub ON 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1
		AND exer.salivaIndicator = 1

--****************************************
--urine--*********************************
--****************************************
INSERT INTO #sourceEvent ([subjectID],[sourceSystemEventID],[eventType],[eventName],EventDate,[studyID],[orgSourceSystemID],[createDate],[createdBy])
SELECT  	
	sub.subjectID
	, exer.participantSpecimenCollectionID
, pv.codedescriptiON + ' - ' + CASE SUBSTRING(sub.sourcesystemIDlabel,11,2) 
		WHEN '01' THEN 'Mother '
		WHEN '02' THEN 'Father '
		WHEN '03' THEN 'New Born '
		ELSE 'Other' END + 
		 'Specimen Collection' AS [eventType]
	, 'RAVE - ' + pv.codedescriptiON + ' - ' + CASE SUBSTRING(sub.sourcesystemIDlabel,11,2) 
		WHEN '01' THEN 'Mother '
		WHEN '02' THEN 'Father '
		WHEN '03' THEN 'New Born '
		ELSE 'Other' END + 
			'Specimen CollectiON - Urine' AS [eventName]
	, exer.eventDate AS EventDate
	, (SELECT stud.studyID FROM itmidw.tblStudy stud WHERE stud.studyshortID LIKE '%102%') AS StudyID
	, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS orgSourceSystemID
	, GETDATE() AS createDate
	, 'usp_Study102Event'  AS createdBy
FROM difzDBcopy.ParticipantSpecimenCollectiON exer
	INNER JOIN difzDBcopy.[PermissibleValues] pv
		ON pv.permissibleValuesID = exer.eventTypeCode
    INNER JOIN difzDBcopy.participant part
		ON part.participantID = exer.ParticipantID
	INNER JOIN itmidw.tblSubject sub ON 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1
		AND exer.urineIndicator = 1

--****************************************
--cordblood--*****************************
--****************************************
INSERT INTO #sourceEvent ([subjectID],[sourceSystemEventID],[eventType],[eventName],EventDate,[studyID],[orgSourceSystemID],[createDate],[createdBy])
SELECT  	
	sub.subjectID
	, exer.participantSpecimenCollectionID
, pv.codedescriptiON + ' - ' + CASE SUBSTRING(sub.sourcesystemIDlabel,11,2) 
		WHEN '01' THEN 'Mother '
		WHEN '02' THEN 'Father '
		WHEN '03' THEN 'New Born '
		ELSE 'Other' END + 
		 'Specimen Collection' AS [eventType]
	, 'RAVE - ' + pv.codedescriptiON + ' - ' + CASE SUBSTRING(sub.sourcesystemIDlabel,11,2) 
		WHEN '01' THEN 'Mother '
		WHEN '02' THEN 'Father '
		WHEN '03' THEN 'New Born '
		ELSE 'Other' END + 
			'Specimen CollectiON - Cord Blood' AS [eventName]
	, exer.eventDate AS EventDate
	, (SELECT stud.studyID FROM itmidw.tblStudy stud WHERE stud.studyshortID LIKE '%102%') AS StudyID
	, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS orgSourceSystemID
	, GETDATE() AS createDate
	, 'usp_Study102Event'  AS createdBy
FROM difzDBcopy.ParticipantSpecimenCollectiON exer
	INNER JOIN difzDBcopy.[PermissibleValues] pv
		ON pv.permissibleValuesID = exer.eventTypeCode
    INNER JOIN difzDBcopy.participant part
		ON part.participantID = exer.ParticipantID
	INNER JOIN itmidw.tblSubject sub ON 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1
		AND exer.cordBloodIndicator = 1

--****************************************
--placenta--******************************
--****************************************
INSERT INTO #sourceEvent ([subjectID],[sourceSystemEventID],[eventType],[eventName],EventDate,[studyID],[orgSourceSystemID],[createDate],[createdBy])
SELECT  	
	sub.subjectID
	, exer.participantSpecimenCollectionID
	, pv.codedescriptiON + ' - ' + CASE SUBSTRING(sub.sourcesystemIDlabel,11,2) 
		WHEN '01' THEN 'Mother '
		WHEN '02' THEN 'Father '
		WHEN '03' THEN 'New Born '
		ELSE 'Other' END + 
		 'Specimen Collection' AS [eventType]
	, 'RAVE - ' + pv.codedescriptiON + ' - ' + CASE SUBSTRING(sub.sourcesystemIDlabel,11,2) 
		WHEN '01' THEN 'Mother '
		WHEN '02' THEN 'Father '
		WHEN '03' THEN 'New Born '
		ELSE 'Other' END + 
			'Specimen CollectiON - Placenta' AS [eventName]
	, exer.eventDate AS EventDate
	, (SELECT stud.studyID FROM itmidw.tblStudy stud WHERE stud.studyshortID LIKE '%102%') AS StudyID
	, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS orgSourceSystemID
	, GETDATE() AS createDate
	, 'usp_Study102Event'  AS createdBy
FROM difzDBcopy.ParticipantSpecimenCollectiON exer
	INNER JOIN difzDBcopy.[PermissibleValues] pv
		ON pv.permissibleValuesID = exer.eventTypeCode
    INNER JOIN difzDBcopy.participant part
		ON part.participantID = exer.ParticipantID
	INNER JOIN itmidw.tblSubject sub ON 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1
		AND exer.placentaIndicator = 1

--****************************************		
--birthEvent--****************************
--****************************************

--****************************************
--birth time--****************************
--****************************************
INSERT INTO #sourceEvent ([subjectID],[sourceSystemEventID],[eventType],[eventName],EventDate,[studyID],[orgSourceSystemID],[createDate],[createdBy])
SELECT  DISTINCT
	sub.subjectID
	, exer.InfantBirthEventID
	, 'Birth Event' AS [eventType]
	, 'RAVE - Birth Event - Birth Date and Time' AS [eventName]
	, REPLACE(CONVERT(VARCHAR(20),se.eventDate),'00:00:00.','') +  CONVERT(VARCHAR(20),exer.birthTime) AS EventDate
	, (SELECT stud.studyID FROM itmidw.tblStudy stud WHERE stud.studyshortID LIKE '%102%') AS StudyID
	, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS orgSourceSystemID
	, GETDATE() AS createDate
	, 'usp_Study102Event'  AS createdBy
FROM difzDBcopy.InfantBirthEvent exer
    INNER JOIN difzDBcopy.participant part
		ON part.participantID = exer.ParticipantID
	INNER JOIN itmidw.tblSubject sub ON 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	INNER JOIN #sourceEvent se
		ON se.subjectID = sub.subjectID
			AND se.eventName = 'Infant Date of Birth Entered in Rave'
	WHERE exer.isactive = 1
		--below validates length
	AND LEN(REPLACE(CONVERT(VARCHAR(20),se.eventDate),'00:00:00.','') +  CONVERT(VARCHAR(20),exer.birthTime)) = 27

--****************************************
--dischargeDate--*************************
--****************************************
INSERT INTO #sourceEvent ([subjectID],[sourceSystemEventID],[eventType],[eventName],EventDate,[studyID],[orgSourceSystemID],[createDate],[createdBy])
SELECT  	
	sub.subjectID
	, exer.InfantBirthEventID
	, 'Birth Event' AS [eventType]
	, 'RAVE - Birth Event - Discharge AND Time' AS [eventName]
	,  REPLACE(CONVERT(VARCHAR(20),exer.dischargeDate),'00:00:00.','') +  CONVERT(VARCHAR(20),exer.dischargeTime) AS EventDate
	, (SELECT stud.studyID FROM itmidw.tblStudy stud WHERE stud.studyshortID LIKE '%102%') AS StudyID
	, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS orgSourceSystemID
	, GETDATE() AS createDate
	, 'usp_Study102Event'  AS createdBy
FROM difzDBcopy.InfantBirthEvent exer
    INNER JOIN difzDBcopy.Participant part
		ON part.participantID = exer.ParticipantID
	INNER JOIN itmidw.tblSubject sub ON 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1
		AND exer.dischargeDate IS NOT NULL
		--below validates length
		AND LEN(REPLACE(CONVERT(VARCHAR(20),exer.dischargeDate),'00:00:00.','') +  CONVERT(VARCHAR(20),exer.dischargeTime)) = 27



--****************************************
--Subject follow up--*********************
--****************************************
INSERT INTO #sourceEvent ([subjectID],[sourceSystemEventID],[eventType],[eventName],EventDate,[studyID],[orgSourceSystemID],[createDate],[createdBy])
SELECT  	
	sub.subjectID
	, exer.ParticipantFollowUpID
	, 'Subject Follow up' AS [eventType]
	, 'RAVE - ' + pv.codeDescriptiON AS [eventName]
	, exer.followUpDate AS EventDate
	, (SELECT stud.studyID FROM itmidw.tblStudy stud WHERE stud.studyshortID LIKE '%102%') AS StudyID
	, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS orgSourceSystemID
	, GETDATE() AS createDate
	, 'usp_Study102Event'  AS createdBy
FROM difzDBcopy.ParticipantFollowUp exer
    INNER JOIN difzDBcopy.Participant part
		ON part.participantID = exer.ParticipantID
	INNER JOIN itmidw.tblSubject sub ON 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	INNER JOIN difzDBcopy.PermissibleValues pv
		ON pv.PermissibleValuesID = exer.followUpTypeCode
WHERE exer.isactive = 1

--****************************************--****************************************
--MotherPregnancyLaborDelivery --admissiondate --***********************************
--****************************************--****************************************
INSERT INTO #sourceEvent ([subjectID],[sourceSystemEventID],[eventType],[eventName],EventDate,[studyID],[orgSourceSystemID],[createDate],[createdBy])
SELECT  	
	sub.subjectID
	, exer.motherPregnancyLaborDeliveryID
	, 'Mother Delivery' AS [eventType]
	, 'RAVE - Mother Delivery - AdmissiON AND Time' AS [eventName]
	, REPLACE(CONVERT(VARCHAR(20),exer.admissionDate),'00:00:00.','') +  CONVERT(VARCHAR(20),exer.admissionTime) AS EventDate
	, (SELECT stud.studyID FROM itmidw.tblStudy stud WHERE stud.studyshortID LIKE '%102%') AS StudyID
	, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS orgSourceSystemID
	, GETDATE() AS createDate
	, 'usp_Study102Event'  AS createdBy
FROM difzDBcopy.MotherPregnancyLaborDelivery exer
    INNER JOIN difzDBcopy.Participant part
		ON part.participantID = exer.ParticipantID
	INNER JOIN itmidw.tblSubject sub ON 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1
		AND exer.admissionDate IS NOT NULL
		--below validates length
		AND LEN(REPLACE(CONVERT(VARCHAR(20),exer.admissionDate),'00:00:00.','') +  CONVERT(VARCHAR(20),exer.admissionTime)) = 27

--****************************************--****************************************
--MotherPregnancyLaborDelivery  dischargeDate--*************************************
--****************************************--****************************************
INSERT INTO #sourceEvent ([subjectID],[sourceSystemEventID],[eventType],[eventName],EventDate,[studyID],[orgSourceSystemID],[createDate],[createdBy])
SELECT  	
	sub.subjectID
	, exer.motherPregnancyLaborDeliveryID
	, 'Mother Delivery' AS [eventType]
	, 'RAVE - Mother Delivery - Discharge AND Time' AS [eventName]
	, REPLACE(CONVERT(VARCHAR(20),exer.dischargeDate),'00:00:00.','') +  CONVERT(VARCHAR(20),exer.dischargeTime) AS EventDate
	, (SELECT stud.studyID FROM itmidw.tblStudy stud WHERE stud.studyshortID LIKE '%102%') AS StudyID
	, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS orgSourceSystemID
	, GETDATE() AS createDate
	, 'usp_Study102Event'  AS createdBy
FROM difzDBcopy.MotherPregnancyLaborDelivery exer
    INNER JOIN difzDBcopy.Participant part
		ON part.participantID = exer.ParticipantID
	INNER JOIN itmidw.tblSubject sub ON 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1
		AND exer.dischargeDate IS NOT NULL
		--below validates length
		AND LEN(REPLACE(CONVERT(VARCHAR(20),exer.dischargeDate),'00:00:00.','') +  CONVERT(VARCHAR(20),exer.dischargeTime)) = 27

		
--****************************************--****************************************
--MotherPregnancyLaborDelivery  cervicalCerclageProcedureDate--*********************
--****************************************--****************************************
INSERT INTO #sourceEvent ([subjectID],[sourceSystemEventID],[eventType],[eventName],EventDate,[studyID],[orgSourceSystemID],[createDate],[createdBy])
SELECT  	
	sub.subjectID
	, exer.motherPregnancyLaborDeliveryID
	, 'Mother Delivery' AS [eventType]
	, 'RAVE - Mother Delivery - Cervical Cerclage Procedure Date' AS [eventName]
	, exer.cervicalCerclageProcedureDate AS EventDate
	, (SELECT stud.studyID FROM itmidw.tblStudy stud WHERE stud.studyshortID LIKE '%102%') AS StudyID
	, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS orgSourceSystemID
	, GETDATE() AS createDate
	, 'usp_Study102Event'  AS createdBy
FROM difzDBcopy.MotherPregnancyLaborDelivery exer
    INNER JOIN difzDBcopy.Participant part
		ON part.participantID = exer.ParticipantID
	INNER JOIN itmidw.tblSubject sub ON 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
WHERE exer.isactive = 1
	AND exer.cervicalCerclageProcedureDate IS NOT NULL
	
--****************************************--****************************************
--PregnancyConcomitantMedicatiON - startDate--**************************************
--****************************************--****************************************
INSERT INTO #sourceEvent ([subjectID],[sourceSystemEventID],[eventType],[eventName],EventDate,[studyID],[orgSourceSystemID],[createDate],[createdBy])
SELECT  	
	sub.subjectID
	, exer.pregnancyConcomitantMedicationID
	, 'Medications' AS [eventType]
	, 'RAVE - Medications - Start Date' AS [eventName]
	, exer.startDate AS EventDate
	, (SELECT stud.studyID FROM itmidw.tblStudy stud WHERE stud.studyshortID LIKE '%102%') AS StudyID
	, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS orgSourceSystemID
	, GETDATE() AS createDate
	, 'usp_Study102Event'  AS createdBy
FROM difzDBcopy.PregnancyConcomitantMedicatiON exer
	INNER JOIN difzDBcopy.MotherPregnancyLaborDelivery labor
		ON labor.motherPregnancyLaborDeliveryID = exer.motherPregnancyLaborDeliveryID
    INNER JOIN difzDBcopy.Participant part
		ON part.participantID = labor.ParticipantID
	INNER JOIN itmidw.tblSubject sub ON 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
WHERE exer.isactive = 1
	AND exer.startDate IS NOT NULL

--****************************************--****************************************
--PregnancyConcomitantMedicatiON - EndDate--****************************************
--****************************************--****************************************
INSERT INTO #sourceEvent ([subjectID],[sourceSystemEventID],[eventType],[eventName],EventDate,[studyID],[orgSourceSystemID],[createDate],[createdBy])
SELECT  	
	sub.subjectID
	, exer.pregnancyConcomitantMedicationID
	, 'Medications' AS [eventType]
	, 'RAVE - Medications - Stop Date' AS [eventName]
	, exer.stopDate AS EventDate
	, (SELECT stud.studyID FROM itmidw.tblStudy stud WHERE stud.studyshortID LIKE '%102%') AS StudyID
	, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS orgSourceSystemID
	, GETDATE() AS createDate
	, 'usp_Study102Event'  AS createdBy
FROM difzDBcopy.PregnancyConcomitantMedicatiON exer
	INNER JOIN difzDBcopy.MotherPregnancyLaborDelivery labor
		ON labor.motherPregnancyLaborDeliveryID = exer.motherPregnancyLaborDeliveryID
    INNER JOIN difzDBcopy.Participant part
		ON part.participantID = labor.ParticipantID
	INNER JOIN itmidw.tblSubject sub ON 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
WHERE exer.isactive = 1
	AND exer.stopDate IS NOT NULL


--****************************************
--***************specimen Events**********
--****************************************
INSERT INTO #sourceEvent ([subjectID],[sourceSystemEventID],[eventType],[eventName],EventDate,[studyID],[orgSourceSystemID],[createDate],[createdBy])
SELECT  	
	Sub.[subjectID] AS SubjectID
	, al.ALIQUOT_ID
	, 'Specimen CollectiON in Nautilus (LIMS)' AS [eventType]
	, 'LIMS - '+ sub.cohortRole + ' Specimen CollectiON - ' + al.matrix_type  AS [eventName]
	, au.U_COLLECTION_DATE
	, (SELECT stud.studyID FROM itmidw.tblStudy stud WHERE stud.studyshortID LIKE '%102%') AS StudyID
    , (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS [orgSourceSystemID]
    , GETDATE() [createDate]
    ,'usp_Study102Specimen_SpecimenFamily: Aliquot' AS [createdBy]
FROM [nautilus].[ALIQUOT] al
	INNER JOIN nautilus.ALIQUOT_USER AU 
		ON al.ALIQUOT_ID = AU.ALIQUOT_ID
	INNER JOIN nautilus.sample s
		ON s.SAMPLE_ID = al.SAMPLE_ID
	INNER JOIN nautilus.SAMPLE_USER SU 
		ON S.SAMPLE_ID = SU.SAMPLE_ID
	INNER JOIN [nautilus].[CONTAINER_TYPE] ct
		ON ct.CONTAINER_TYPE_ID = al.CONTAINER_TYPE_ID
	INNER JOIN nautilus.[ALIQUOT_TEMPLATe] alTemplate
		ON alTemplate.ALIQUOT_TEMPLATE_ID = al.ALIQUOT_TEMPLATE_ID
	LEFT JOIN itmidw.tblSpecimenSampleType st
		ON st.specimenTypeName = al.matrix_type
	INNER JOIN itmidw.tblSubject sub
		ON sub.sourceSystemIDLabel =  replace(LEFT(s.EXTERNAL_REFERENCE,4) + SUBSTRING(s.EXTERNAL_REFERENCE,8,10),'[','')
WHERE  s.group_id = 22 ---Study 102
	AND AU.U_COLLECTED = 'T'
	AND  au.U_COLLECTION_DATE IS NOT NULL

--********************************
--*********Surveys****************
--********************************
INSERT INTO #sourceEvent ([subjectID],[sourceSystemEventID],[eventType],[eventName],EventDate,[studyID],[orgSourceSystemID],[createDate],[createdBy])
SELECT  	
	Sub.[subjectID] AS SubjectID
	, ss.[family ID]
	, 'Survey' AS [eventType]
	, sub.cohortRole + ' - 6 Month'  AS [eventName]
	, CONVERT(DATETIME,ss.[date completed])
	, (SELECT stud.studyID FROM itmidw.tblStudy stud WHERE stud.studyshortID LIKE '%102%') AS StudyID
    , (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS [orgSourceSystemID]
    , GETDATE() [createDate]
    ,'usp_Study102Event' AS [createdBy]
FROM etl.SurveyBaby6_Stage ss
	INNER JOIN itmidw.tblsubject sub
		ON sub.sourceSystemIDLabel = ss.[family ID]

		
--****************************************
--*************baby 12 *******************
--****************************************
INSERT INTO #sourceEvent ([subjectID],[sourceSystemEventID],[eventType],[eventName],EventDate,[studyID],[orgSourceSystemID],[createDate],[createdBy])
SELECT  	
	Sub.[subjectID] AS SubjectID
	, ss.[family ID]
	, 'Survey' AS [eventType]
	, sub.cohortRole + ' - 12 Month'  AS [eventName]
	, CONVERT(DATETIME,ss.[date completed])
	, (SELECT stud.studyID FROM itmidw.tblStudy stud WHERE stud.studyshortID LIKE '%102%') AS StudyID
    , (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS [orgSourceSystemID]
    , GETDATE() [createDate]
    ,'usp_Study102Event' AS [createdBy]
FROM etl.SurveyBaby12_Stage ss
	INNER JOIN itmidw.tblsubject sub
		ON sub.sourceSystemIDLabel = ss.[family ID]

--****************************************
--*************baby 18 *******************
--****************************************
INSERT INTO #sourceEvent ([subjectID],[sourceSystemEventID],[eventType],[eventName],EventDate,[studyID],[orgSourceSystemID],[createDate],[createdBy])
SELECT  	
	Sub.[subjectID] AS SubjectID
	, ss.[family ID]
	, 'Survey' AS [eventType]
	, sub.cohortRole + ' - 18 Month'  AS [eventName]
	, CONVERT(DATETIME,ss.[date completed])
	, (SELECT stud.studyID FROM itmidw.tblStudy stud WHERE stud.studyshortID LIKE '%102%') AS StudyID
    , (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS [orgSourceSystemID]
    , GETDATE() [createDate]
    ,'usp_Study102Event' AS [createdBy]
FROM etl.SurveyBaby18_Stage ss
	INNER JOIN itmidw.tblsubject sub
		ON sub.sourceSystemIDLabel = ss.[family ID]

--****************************************
--*************mom  6  *******************
--****************************************
INSERT INTO #sourceEvent ([subjectID],[sourceSystemEventID],[eventType],[eventName],EventDate,[studyID],[orgSourceSystemID],[createDate],[createdBy])
SELECT  	
	Sub.[subjectID] AS SubjectID
	, ss.[family ID]
	, 'Survey' AS [eventType]
	, sub.cohortRole + ' - 6 Month'  AS [eventName]
	, CONVERT(DATETIME,ss.[date completed])
	, (SELECT stud.studyID FROM itmidw.tblStudy stud WHERE stud.studyshortID LIKE '%102%') AS StudyID
    , (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS [orgSourceSystemID]
    , GETDATE() [createDate]
    ,'usp_Study102Event' AS [createdBy]
FROM etl.SurveyMom6_Stage ss
	INNER JOIN itmidw.tblsubject sub
		ON sub.sourceSystemIDLabel = ss.[family ID]


--****************************************
--*************mom  12 *******************
--****************************************
INSERT INTO #sourceEvent ([subjectID],[sourceSystemEventID],[eventType],[eventName],EventDate,[studyID],[orgSourceSystemID],[createDate],[createdBy])
SELECT  	
	Sub.[subjectID] AS SubjectID
	, ss.[family ID]
	, 'Survey' AS [eventType]
	, sub.cohortRole + ' - 12 Month'  AS [eventName]
	, CONVERT(DATETIME,ss.[date completed])
	, (SELECT stud.studyID FROM itmidw.tblStudy stud WHERE stud.studyshortID LIKE '%102%') AS StudyID
    , (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS [orgSourceSystemID]
    , GETDATE() [createDate]
    ,'usp_Study102Event' AS [createdBy]
FROM etl.SurveyMom12_Stage ss
	INNER JOIN itmidw.tblsubject sub
		ON sub.sourceSystemIDLabel = ss.[family ID]


--****************************************
--*************mom  18 *******************
--****************************************
INSERT INTO #sourceEvent ([subjectID],[sourceSystemEventID],[eventType],[eventName],EventDate,[studyID],[orgSourceSystemID],[createDate],[createdBy])
SELECT  	
	Sub.[subjectID] AS SubjectID
	, ss.[family ID]
	, 'Survey' AS [eventType]
	, sub.cohortRole + ' - 18 Month'  AS [eventName]
	, CONVERT(DATETIME,ss.[date completed])
	, (SELECT stud.studyID FROM itmidw.tblStudy stud WHERE stud.studyshortID LIKE '%102%') AS StudyID
    , (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS [orgSourceSystemID]
    , GETDATE() [createDate]
    ,'usp_Study102Event' AS [createdBy]
FROM etl.SurveyMom18_Stage ss
	INNER JOIN itmidw.tblsubject sub
		ON sub.sourceSystemIDLabel = ss.[family ID]


--****************************************
--Slowly Changing dimension--*************
--****************************************
MERGE  itmidw.[tblEvent] AS targetEvent
USING #sourceEvent sp
	ON targetEvent.[sourceSystemEventID] = sp.[sourceSystemEventID]
	and targetEvent.orgSourceSystemID = sp.orgSourceSystemID
	and targetEvent.eventName = sp.eventName
	and targetEvent.subjectID = sp.subjectID
WHEN MATCHED
	AND (
	sp.subjectID <> targetEvent.subjectID OR
	sp.[eventType] <>targetEvent.[eventType] OR
	sp.EventDate <>targetEvent.EventDate OR
	sp.StudyID <>targetEvent.StudyID OR
	sp.createDate <> targetEvent.createDate OR 
	sp.createdBy <> targetEvent.createdBy
	)
THEN UPDATE SET
	subjectID = sp.subjectID
	, [eventType]=  sp.[eventType]
	, [eventName] = sp.[eventName]
	, EventDate = sp.EventDate
	, StudyID = sp.StudyID
	, createDate = sp.createDate
	, createdBy = sp.createdBy
WHEN NOT MATCHED THEN
INSERT ([subjectID],[sourceSystemEventID],[eventType],[eventName],eventDate,[studyID],[createDate],[createdBy] ,[orgSourceSystemID])
VALUES (sp.[subjectID],sp.[sourceSystemEventID],sp.[eventType],sp.[eventName],sp.eventDate,sp.[studyID],sp.[createDate],sp.[createdBy] ,sp.[orgSourceSystemID]);

PRINT CAST(@@ROWCOUNT AS VARCHAR(10))+ 'tblEvent row(s) updated.'

--****************************************
---**Wrap Up--****************************
--****************************************

--****************************************
--inserting into rules table--************
--****************************************

INSERT INTO itmidw.[tblEventRules]([eventName] ,[eventRuleName],[eventRuleValue],[eventRuleOrder],[studyID],[orgSourceSystemID],[createDate] ,[createdBy])
SELECT  
DISTINCT eve.eventName, 'Event Order', NULL, NULL
	, (SELECT stud.studyID FROM itmidw.tblStudy stud WHERE stud.studyshortID LIKE '%102%') AS StudyID
	, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS orgSourceSystemID
	, GETDATE() AS createDate
	, 'usp_Study102Event'  AS createdBy
FROM itmidw.[tblEvent] eve
	INNER JOIN itmidw.tblsubject sub
		ON sub.subjectID = eve.subjectID
	INNER JOIN itmidw.tblSubjectOrganizationMap orgMap
		ON orgMap.subjectID = sub.subjectID
	INNER JOIN itmidw.tblOrganizatiON org
		ON org.organizationID = orgMap.organizationID
	INNER JOIN itmidw.tblOrganizationType orgType
		ON orgType.organizationTypeID = org.organizationTypeID
			AND orgType.organizationTypeName = 'Family'
	LEFT JOIN itmidw.[tblEventRules] eveExist
		ON eveExist.eventName = eve.eventName	
			AND eveExist.eventRuleName = 'Event Order'
WHERE eveExist.eventRulesID IS NULL

--specimen collectiON date is LIMS

PRINT CAST(@@ROWCOUNT AS VARCHAR(10))+ ' row(s) updated.'

END



