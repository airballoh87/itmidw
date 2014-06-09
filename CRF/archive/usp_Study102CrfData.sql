--ALTER table ITMIDW.[dbo].[tblCrfEventAnswers] add subjectID INT
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Study102CrfEventAnswers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_Study102CrfEventAnswers]
GO
/**************************************************************************
Created On : 3/29/2014

Created By : Aaron Black
Team Name : Informatics
Object name : [usp_Study102CrfEventAnswers]
Functional : ITMI SSIS for Insert and Update for study 102 tblCrfData
 THis is the detail data
History : Created on 3/29/2014
**************************************************************************
Date Modified By QC# Purposes
**************************************************************************
#Date #Comment
**************************************************************************
USE CASE:
EXEC [usp_Study102CrfEventAnswers]
--TRUNCATe table ITMIDW.[dbo].[tblCrfEventAnswers] 
--select * from ITMIDW.[dbo].[tblOrganization] 

**************************************************************************/
CREATE PROCEDURE [dbo].[usp_Study102CrfEventAnswers]
AS
BEGIN
SET NOCOUNT ON;
DECLARE @UpdatedOn SMALLDATETIME
SET @UpdatedOn = CAST(GETDATE() AS SMALLDATETIME)
PRINT CONVERT(CHAR(23), @UpdatedOn, 121) + ' [usp_Study102CrfEventAnswers][' + @@SERVERNAME + '][' + SYSTEM_USER + ']'
PRINT 'INSERT [ITMIDW].[dbo].[usp_Study102CrfEventAnswers]...'

--*************************************
--******************102****************
--*************************************
--drop table
IF OBJECT_ID('tempdb..#sourceCrfData') IS NOT NULL
DROP TABLE #sourceCrfDat


SELECT 
           deets.patientDataPointDetailID as [sourceSystemFieldDataID]
           ,deets.fieldName as [sourceSystemFieldDataLabel]
           ,eve.crfEventID as  [eventCrfID]
           ,crf.crfID as [crfVersionID]
		   , sub.subjectID as subjectID
           ,deets.fieldValue as [fieldValue]
           ,NULL as [hadQuery]
           ,case when deets.queryStatus = 'Open' Then 1 ELSE 0 END as [openQuery]
           ,NULL as [fieldValueOrdinal]
           ,(SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
           ,GETDATE() [createDate]
           ,'usp_Study102CrfEventAnswers' as [createdBy]
INTO #sourceCrfData
	FROM itmiDIFZ.genesis.PatientDataPointDetail as deets
		INNER JOIN ITMIDW.dbo.tblSubject subject
			ON subject.subjectId = deets.itmidwSubjectID
		INNER JOIn ITMIDW.dbo.tblCrf crf
			ON crf.crfName = deets.itmiFormName
		INNER JOIN ITMIDW.dbo.tblCrfEvent eve
			ON eve.sourceSystemCrfEventID = deets.recordID
		INNER JOIN ITMIDW.dbo.tblSubject sub
			on sub.subjectID = deets.itmidwSubjectID
	WHERE deets.isactive = 1	

--multi-select tables
--motherPregnancyLaborDeliveryID
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	reason.motherLaborDeliveryAdmissionReasonID
	, pv.codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, pv.codeDescription
	, 0 as hadQuery
	, 0 as [openQuery]
	, pv.sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select reason.*
FROM ITMIDIFZ.Genesis.MotherLaborDeliveryAdmissionReason reason
	INNER JOIN ITMIDIFZ.[Genesis].[MotherPregnancyLaborDelivery] deliver
		ON deliver.motherPregnancyLaborDeliveryID = reason.motherPregnancyLaborDeliveryID
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = deliver.participantID
	inner join ITMIDIFZ.genesis.PermissibleValues pv
		on pv.PermissibleValuesID = reason.admissionReasonCode
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
WHERE reason.isactive = 1

--OBHistory
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID],subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
--motherPregnancyLaborDeliveryID
SELECT 
	ob.motherPregnancyLaborDeliveryID
	, 'OBResultValue'
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, Ob.resultValue
	, 0 as hadQuery
	, 0 as [openQuery]
	, NULL as sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.OBHistory ob
	INNER JOIN ITMIDIFZ.[Genesis].[MotherPregnancyLaborDelivery] deliver
		ON deliver.motherPregnancyLaborDeliveryID = ob.motherPregnancyLaborDeliveryID
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = deliver.participantID
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE ob.isactive = 1
		

--ExerciseType
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])

SELECT 
	exer.exerciseTypeID
	, 'Exercise Type'
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, CASE WHEN pv.codeDescription = 'Other' THEN exerciseOtherSpecified ELSE pv.codeDescription END as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, pv.sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.ExerciseType exer
	INNER JOIN ITMIDIFZ.[Genesis].[MotherPregnancyLaborDelivery] deliver
		ON deliver.motherPregnancyLaborDeliveryID = exer.motherPregnancyLaborDeliveryID
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = deliver.participantID
	inner join ITMIDIFZ.genesis.PermissibleValues pv
		on pv.PermissibleValuesID = exer.exerciseTypeCode
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1

--PregnancyNutritionIntake
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])

SELECT 
	exer.pregnancyNutritionIntakeID
	, 'Pregnancy Nutrition' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, CONVERT(VARCHAR(10),exer.servingNumber)Value
	, 0 as hadQuery
	, 0 as [openQuery]
	, pv.sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.PregnancyNutritionIntake exer
	INNER JOIN ITMIDIFZ.[Genesis].[MotherPregnancyLaborDelivery] deliver
		ON deliver.motherPregnancyLaborDeliveryID = exer.motherPregnancyLaborDeliveryID
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = deliver.participantID
	inner join ITMIDIFZ.genesis.PermissibleValues pv
		on pv.PermissibleValuesID = exer.nutritionIntakeAnswerCode
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1
		AND exer.servingNumber IS NOT NULL

--PregnancyVaccination
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])

SELECT 
	exer.pregnancyVaccinationID
	, 'Pregnancy Vaccination' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, pv.codeDescription as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, pv.sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select p
FROM ITMIDIFZ.Genesis.PregnancyVaccination exer
	INNER JOIN ITMIDIFZ.[Genesis].[MotherPregnancyLaborDelivery] deliver
		ON deliver.motherPregnancyLaborDeliveryID = exer.motherPregnancyLaborDeliveryID
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = deliver.participantID
	inner join ITMIDIFZ.genesis.PermissibleValues pv
		on pv.PermissibleValuesID = exer.vaccinationCode
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1
		

--PregnancyPastSickness
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.pregnancyPastSicknessID
	, 'Pregnancy Sickness' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, pv.codeDescription as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, pv.sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.PregnancyPastSickness exer
	INNER JOIN ITMIDIFZ.[Genesis].[MotherPregnancyLaborDelivery] deliver
		ON deliver.motherPregnancyLaborDeliveryID = exer.motherPregnancyLaborDeliveryID
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = deliver.participantID
	inner join ITMIDIFZ.genesis.PermissibleValues pv
		on pv.PermissibleValuesID = exer.sicknessCode
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1
		

--PregnancyAssistanceType
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.pregnancyAssistanceTypeID
	, 'Pregnancy Assistance' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, pv.codeDescription as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, pv.sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.PregnancyAssistanceType exer
	INNER JOIN ITMIDIFZ.[Genesis].[MotherPregnancyLaborDelivery] deliver
		ON deliver.motherPregnancyLaborDeliveryID = exer.motherPregnancyLaborDeliveryID
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = deliver.participantID
	inner join ITMIDIFZ.genesis.PermissibleValues pv
		on pv.PermissibleValuesID = exer.assistanceCode
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1

--PregnancyMedicalCondition
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.pregnancyMedicalConditionID
	, 'Pregnancy Assistance' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, pv.codeDescription as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, pv.sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.PregnancyMedicalCondition exer
	INNER JOIN ITMIDIFZ.[Genesis].[MotherPregnancyLaborDelivery] deliver
		ON deliver.motherPregnancyLaborDeliveryID = exer.motherPregnancyLaborDeliveryID
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = deliver.participantID
	inner join ITMIDIFZ.genesis.PermissibleValues pv
		on pv.PermissibleValuesID = exer.medicalConditionCode
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1

--HRPAdmissionType
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.hRPAdmissionTypeID
	, 'Pregnancy Assistance' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, pv.codeDescription as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, pv.sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.HRPAdmissionType exer
	INNER JOIN ITMIDIFZ.[Genesis].[MotherPregnancyLaborDelivery] deliver
		ON deliver.motherPregnancyLaborDeliveryID = exer.motherPregnancyLaborDeliveryID
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = deliver.participantID
	inner join ITMIDIFZ.genesis.PermissibleValues pv
		on pv.PermissibleValuesID = exer.HRPAdmissionTypeCode
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1


--PregnancyConcomitantMedication  -medicationOnGoingIndicator
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.pregnancyConcomitantMedicationID  --this will group the medication fields together
	, 'Medication Ongoing Indicator' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, exer.medicationOngoingIndicator as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, NULL as sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
FROM ITMIDIFZ.Genesis.PregnancyConcomitantMedication exer
	INNER JOIN ITMIDIFZ.[Genesis].[MotherPregnancyLaborDelivery] deliver
		ON deliver.motherPregnancyLaborDeliveryID = exer.motherPregnancyLaborDeliveryID
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = deliver.participantID
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1
		AND exer.medicationOngoingIndicator IS NOT NULL

--PregnancyConcomitantMedication  -medicationDose
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.pregnancyConcomitantMedicationID  --this will group the medication fields together
	, 'Medication Ongoing Indicator' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, exer.dose as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, NULL as sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
FROM ITMIDIFZ.Genesis.PregnancyConcomitantMedication exer
	INNER JOIN ITMIDIFZ.[Genesis].[MotherPregnancyLaborDelivery] deliver
		ON deliver.motherPregnancyLaborDeliveryID = exer.motherPregnancyLaborDeliveryID
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = deliver.participantID
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1
		and exer.dose IS NOT NULL


--PregnancyConcomitantMedication  -medicationdoseUnit
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.pregnancyConcomitantMedicationID
	, 'Medication Unit' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, CASE WHEN pv.codeDescription = 'Other' THEN exer.doseUnitOtherSpecify ELSE pv.codeDescription END as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, pv.sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.PregnancyConcomitantMedication exer
	INNER JOIN ITMIDIFZ.[Genesis].[MotherPregnancyLaborDelivery] deliver
		ON deliver.motherPregnancyLaborDeliveryID = exer.motherPregnancyLaborDeliveryID
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = deliver.participantID
	inner join ITMIDIFZ.genesis.PermissibleValues pv
		on pv.PermissibleValuesID = exer.doseUnitCode
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1

--PregnancyConcomitantMedication  -medicationFrequency
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.pregnancyConcomitantMedicationID
	, 'Medication Frequency' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, CASE WHEN pv.codeDescription = 'Other' THEN exer.medicationFrequencyOtherSpecify ELSE pv.codeDescription END as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, pv.sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.PregnancyConcomitantMedication exer
	INNER JOIN ITMIDIFZ.[Genesis].[MotherPregnancyLaborDelivery] deliver
		ON deliver.motherPregnancyLaborDeliveryID = exer.motherPregnancyLaborDeliveryID
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = deliver.participantID
	inner join ITMIDIFZ.genesis.PermissibleValues pv
		on pv.PermissibleValuesID = exer.medicationFrequencyCode
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1


--PregnancyConcomitantMedication  -MedicationRoute
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.pregnancyConcomitantMedicationID
	, 'Medication Unit' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, CASE WHEN pv.codeDescription = 'Other' THEN exer.medicationRouteOtherSpecify ELSE pv.codeDescription END as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, pv.sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.PregnancyConcomitantMedication exer
	INNER JOIN ITMIDIFZ.[Genesis].[MotherPregnancyLaborDelivery] deliver
		ON deliver.motherPregnancyLaborDeliveryID = exer.motherPregnancyLaborDeliveryID
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = deliver.participantID
	inner join ITMIDIFZ.genesis.PermissibleValues pv
		on pv.PermissibleValuesID = exer.medicationRouteCode
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1

--PregnancyConcomitantMedication  -MedicationIndication
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.pregnancyConcomitantMedicationID
	, 'Medication Indication' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, exer.medicationIndication as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, NULL as sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.PregnancyConcomitantMedication exer
	INNER JOIN ITMIDIFZ.[Genesis].[MotherPregnancyLaborDelivery] deliver
		ON deliver.motherPregnancyLaborDeliveryID = exer.motherPregnancyLaborDeliveryID
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = deliver.participantID
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1

--LifeEventDetail
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.lifeEventDetailID
	, 'Life Event' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	,  pv.codeDescription as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, pv.sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.LifeEventDetail exer
	INNER JOIN ITMIDIFZ.[Genesis].[MotherPregnancyLaborDelivery] deliver
		ON deliver.motherPregnancyLaborDeliveryID = exer.motherPregnancyLaborDeliveryID
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = deliver.participantID
	inner join ITMIDIFZ.genesis.PermissibleValues pv
		on pv.PermissibleValuesID = exer.lifeEventCode
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1

--HistopathologyResult
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.histopathologyResultID
	, 'Histopathology Result' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	,  pv.codeDescription as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, pv.sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.HistopathologyResult exer
	INNER JOIN ITMIDIFZ.[Genesis].[MotherPregnancyLaborDelivery] deliver
		ON deliver.motherPregnancyLaborDeliveryID = exer.motherPregnancyLaborDeliveryID
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = deliver.participantID
	inner join ITMIDIFZ.genesis.PermissibleValues pv
		on pv.PermissibleValuesID = exer.histopathologyResultCode
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1

--PregnancyEarlyLaborOnsetDetail
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.pregnancyEarlyLaborOnsetDetailID
	, 'Pregnancy Early Labor' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	,  pv.codeDescription as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, pv.sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.PregnancyEarlyLaborOnsetDetail exer
	INNER JOIN ITMIDIFZ.[Genesis].[MotherPregnancyLaborDelivery] deliver
		ON deliver.motherPregnancyLaborDeliveryID = exer.motherPregnancyLaborDeliveryID
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = deliver.participantID
	inner join ITMIDIFZ.genesis.PermissibleValues pv
		on pv.PermissibleValuesID = exer.earlyLaborOnsetDetailCode
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1


--**Participant as parent
--ParticipantGrowthCountry
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.participantGrowthCountryID
	, 'Growth Country' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, pv.codeDescription as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, pv.sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.ParticipantGrowthCountry exer
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = exer.participantID
	inner join ITMIDIFZ.genesis.PermissibleValues pv
		on pv.PermissibleValuesID = exer.growthCountryCode
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1

--ParticipantVitals
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.participantVitalsID
	, 'Participant Vitals' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, pv.codeDescription as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, pv.sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.ParticipantVitals exer
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = exer.participantID
	inner join ITMIDIFZ.genesis.PermissibleValues pv
		on pv.PermissibleValuesID = exer.vitalTestCode
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1


--ParticipantEventComment
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.participantEventCommentID
	, 'Participant Event Comment' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, pv.codeDescription as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, pv.sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.ParticipantEventComment exer
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = exer.participantID
	inner join ITMIDIFZ.genesis.PermissibleValues pv
		on pv.PermissibleValuesID = exer.eventTypeCode
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1

--ParticipantSupplementDetail
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.participantSupplementDetailID
	, 'Participant Supplement' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, pv.codeDescription as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, pv.sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.ParticipantSupplementDetail exer
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = exer.participantID
	inner join ITMIDIFZ.genesis.PermissibleValues pv
		on pv.PermissibleValuesID = exer.supplementalCode
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1


--MotherPregnancyLaborDelivery - deliverTypeCode
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.motherPregnancyLaborDeliveryID
	, 'Mother Pregnancy Labor Delivery Type' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, pv.codeDescription as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, pv.sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.MotherPregnancyLaborDelivery exer
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = exer.participantID
	inner join ITMIDIFZ.genesis.PermissibleValues pv
		on pv.PermissibleValuesID = exer.deliveryTypeCode
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1

--MotherPregnancyLaborDelivery - cSectionTypeCode
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.motherPregnancyLaborDeliveryID
	, 'Mother Pregnancy Labor - cSectionTypeCode' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, pv.codeDescription as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, pv.sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.MotherPregnancyLaborDelivery exer
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = exer.participantID
	inner join ITMIDIFZ.genesis.PermissibleValues pv
		on pv.PermissibleValuesID = exer.CSectionTypeCode
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1

--MotherPregnancyLaborDelivery - cSectionScheduleCode
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.motherPregnancyLaborDeliveryID
	, 'Mother Pregnancy Labor - cSectionScheduleCode' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, pv.codeDescription as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, pv.sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.MotherPregnancyLaborDelivery exer
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = exer.participantID
	inner join ITMIDIFZ.genesis.PermissibleValues pv
		on pv.PermissibleValuesID = exer.CSectionScheduleCode
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1

--MotherPregnancyLaborDelivery - histopathologyPerformedCode
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.motherPregnancyLaborDeliveryID
	, 'Mother Pregnancy Labor - histopathologyPerformed' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, pv.codeDescription as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, pv.sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.MotherPregnancyLaborDelivery exer
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = exer.participantID
	inner join ITMIDIFZ.genesis.PermissibleValues pv
		on pv.PermissibleValuesID = exer.histopathologyPerformedCode
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1

--MotherPregnancyLaborDelivery - endometriosisDiagnosisCode
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.motherPregnancyLaborDeliveryID
	, 'Mother Pregnancy Labor - endometriosisDiagnosis' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, pv.codeDescription as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, pv.sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.MotherPregnancyLaborDelivery exer
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = exer.participantID
	inner join ITMIDIFZ.genesis.PermissibleValues pv
		on pv.PermissibleValuesID = exer.endometriosisDiagnosisCode
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1

--MotherPregnancyLaborDelivery - cervicalCerclageCode
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.motherPregnancyLaborDeliveryID
	, 'Mother Pregnancy Labor - cervicalCerclageCode' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, pv.codeDescription as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, pv.sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.MotherPregnancyLaborDelivery exer
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = exer.participantID
	inner join ITMIDIFZ.genesis.PermissibleValues pv
		on pv.PermissibleValuesID = exer.cervicalCerclageCode
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1

--MotherPregnancyLaborDelivery - gestationsCode
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.motherPregnancyLaborDeliveryID
	, 'Mother Pregnancy Labor - gestationsCode' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, pv.codeDescription as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, pv.sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.MotherPregnancyLaborDelivery exer
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = exer.participantID
	inner join ITMIDIFZ.genesis.PermissibleValues pv
		on pv.PermissibleValuesID = exer.gestationsCode
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1

--MotherPregnancyLaborDelivery - pregnancyModeCode
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.motherPregnancyLaborDeliveryID
	, 'Mother Pregnancy Labor - pregnancyModeCode' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, pv.codeDescription as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, pv.sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.MotherPregnancyLaborDelivery exer
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = exer.participantID
	inner join ITMIDIFZ.genesis.PermissibleValues pv
		on pv.PermissibleValuesID = exer.pregnancyModeCode
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1

--MotherPregnancyLaborDelivery - HRPAdmissionCode
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.motherPregnancyLaborDeliveryID
	, 'Mother Pregnancy Labor - HRPAdmissionCode' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, pv.codeDescription as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, pv.sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.MotherPregnancyLaborDelivery exer
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = exer.participantID
	inner join ITMIDIFZ.genesis.PermissibleValues pv
		on pv.PermissibleValuesID = exer.HRPAdmissionCode
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1

--MotherPregnancyLaborDelivery - pregnancyWeightGainCode
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.motherPregnancyLaborDeliveryID
	, 'Mother Pregnancy Labor - pregnancyWeightGainCode' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, pv.codeDescription as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, pv.sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.MotherPregnancyLaborDelivery exer
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = exer.participantID
	inner join ITMIDIFZ.genesis.PermissibleValues pv
		on pv.PermissibleValuesID = exer.pregnancyWeightGainCode
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1

--MotherPregnancyLaborDelivery - dietTypeCode
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.motherPregnancyLaborDeliveryID
	, 'Mother Pregnancy Labor - Diet Type' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, pv.codeDescription as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, pv.sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.MotherPregnancyLaborDelivery exer
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = exer.participantID
	inner join ITMIDIFZ.genesis.PermissibleValues pv
		on pv.PermissibleValuesID = exer.dietTypeCode
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1

--MotherPregnancyLaborDelivery - dietRecall24HoruCode
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.motherPregnancyLaborDeliveryID
	, 'Mother Pregnancy Labor - Diet Recall' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, pv.codeDescription as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, pv.sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.MotherPregnancyLaborDelivery exer
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = exer.participantID
	inner join ITMIDIFZ.genesis.PermissibleValues pv
		on pv.PermissibleValuesID = exer.dietRecall24HrCode
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1

--MotherPregnancyLaborDelivery - regularExerciseCode
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.motherPregnancyLaborDeliveryID
	, 'Mother Pregnancy Labor - Regular Exercise' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, pv.codeDescription as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, pv.sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.MotherPregnancyLaborDelivery exer
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = exer.participantID
	inner join ITMIDIFZ.genesis.PermissibleValues pv
		on pv.PermissibleValuesID = exer.regularExerciseCode
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1

--MotherPregnancyLaborDelivery - exerciseDurationCode
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.motherPregnancyLaborDeliveryID
	, 'Mother Pregnancy Labor - Exercise Duration' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, pv.codeDescription as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, pv.sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.MotherPregnancyLaborDelivery exer
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = exer.participantID
	inner join ITMIDIFZ.genesis.PermissibleValues pv
		on pv.PermissibleValuesID = exer.exerciseDurationCode
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1

--MotherPregnancyLaborDelivery - exerciseFrequencyCode
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.motherPregnancyLaborDeliveryID
	, 'Mother Pregnancy Labor - Exercise Frequency' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, pv.codeDescription as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, pv.sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.MotherPregnancyLaborDelivery exer
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = exer.participantID
	inner join ITMIDIFZ.genesis.PermissibleValues pv
		on pv.PermissibleValuesID = exer.exerciseFrequencyCode
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1

--MotherPregnancyLaborDelivery - earlyLaborOnsetCode
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.motherPregnancyLaborDeliveryID
	, 'Mother Pregnancy Labor - Early Labor Onset' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, pv.codeDescription as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, pv.sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.MotherPregnancyLaborDelivery exer
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = exer.participantID
	inner join ITMIDIFZ.genesis.PermissibleValues pv
		on pv.PermissibleValuesID = exer.earlyLaborOnsetCode
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1

--MotherPregnancyLaborDelivery - multipleBirthCode
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.motherPregnancyLaborDeliveryID
	, 'Mother Pregnancy Labor - Multiple Birth' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, pv.codeDescription as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, pv.sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.MotherPregnancyLaborDelivery exer
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = exer.participantID
	inner join ITMIDIFZ.genesis.PermissibleValues pv
		on pv.PermissibleValuesID = exer.multipleBirthCode
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1




--MotherPregnancyLaborDelivery - priorsicknessNotApplicable
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.motherPregnancyLaborDeliveryID
	, 'Mother Pregnancy Labor - PriorSickness NA' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, exer.priorSickNotApplicable
	, 0 as hadQuery
	, 0 as [openQuery]
	, NULL AS sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.MotherPregnancyLaborDelivery exer
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = exer.participantID
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1
		AND exer.priorSickNotApplicable IS NOT NULL

--MotherPregnancyLaborDelivery - dietNutritionNAIndicator
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.motherPregnancyLaborDeliveryID
	, 'Mother Pregnancy Labor - Multiple Birth' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, exer.dietNutritionNAIndicator
	, 0 as hadQuery
	, 0 as [openQuery]
	, NULL AS sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.MotherPregnancyLaborDelivery exer
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = exer.participantID
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1
		AND exer.dietNutritionNAIndicator IS NOT NULL

--MotherPregnancyLaborDelivery - lifeEventNAIndicator
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.motherPregnancyLaborDeliveryID
	, 'Mother Pregnancy Labor - Multiple Birth' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, exer.lifeEventNAIndicator
	, 0 as hadQuery
	, 0 as [openQuery]
	, NULL AS sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.MotherPregnancyLaborDelivery exer
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = exer.participantID
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1
		AND exer.lifeEventNAIndicator IS NOT NULL

--MotherPregnancyLaborDelivery - LifeEventUnknownIndicator
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.motherPregnancyLaborDeliveryID
	, 'Mother Pregnancy Labor - Multiple Birth' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, exer.LifeEventUnknownIndicator
	, 0 as hadQuery
	, 0 as [openQuery]
	, NULL AS sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.MotherPregnancyLaborDelivery exer
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = exer.participantID
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1
		AND exer.LifeEventUnknownIndicator IS NOT NULL





--ParticipantSurvey --NOT THERE

--ParticipantSurgicalProcedures
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.participantSurgicalProceduresID
	, 'Surgical Procedures' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, CASE WHEN pv.codeDescription = 'Other' THEN exer.procedureOtherComment ELSE pv.codeDescription END as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, pv.sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.ParticipantSurgicalProcedures exer
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = exer.participantID
	inner join ITMIDIFZ.genesis.PermissibleValues pv
		on pv.PermissibleValuesID = exer.procedureCode
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1

--ParticipantRace
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.participantRaceID
	, 'Participant Race' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, pv.codeDescription as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, pv.sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.ParticipantRace exer
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = exer.participantID
	inner join ITMIDIFZ.genesis.PermissibleValues pv
		on pv.PermissibleValuesID = exer.raceCode
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1

--ParticipantMedicalHistory
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.participantMedicalHistoryID
	, 'Participant Medical History' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, pv.codeDescription as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, pv.sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.ParticipantMedicalHistory exer
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = exer.participantID
	inner join ITMIDIFZ.genesis.PermissibleValues pv
		on pv.PermissibleValuesID = exer.conditionCode
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1

--ParticipantMedicalHistory - FamHXCode
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.participantMedicalHistoryID
	, 'Participant Medical Hist. - FamHXCode' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, exer.famHXCode as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, NULL as sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.ParticipantMedicalHistory exer
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = exer.participantID
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1
		AND exer.famHXCode IS NOT NULL

--ParticipantMedicalHistory - medRecCode
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.participantMedicalHistoryID
	, 'Participant Medical Hist. - medRecCode' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, exer.medRecCode   as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, NULL as sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.ParticipantMedicalHistory exer
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = exer.participantID
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1
		AND exer.medRecCode IS NOT NULL

--ParticipantMedicalHistory - selfReportCode
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.participantMedicalHistoryID
	, 'Participant Medical Hist. - selfReportCode' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, exer.selfReportCode   as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, NULL as sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.ParticipantMedicalHistory exer
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = exer.participantID
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1
		AND exer.selfReportCode IS NOT NULL

--InfantBirthEvent - birth location

INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.InfantBirthEventID
	, 'Infant Birth Location' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, CASE WHEN pv.codeDescription = 'Other' THEN exer.birthLocationOtherSpecified ELSE pv.codeDescription END as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, pv.sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
FROM ITMIDIFZ.Genesis.InfantBirthEvent exer
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = exer.participantID
	inner join ITMIDIFZ.genesis.PermissibleValues pv
		on pv.PermissibleValuesID = exer.birthLocationCode
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1

--***Infant
--InfantDischargeCondition
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.infantDischargeConditionID
	, 'Growth Country' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, pv.codeDescription as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, pv.sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.InfantDischargeCondition exer
	INNER JOIN ITMIDIFZ.[Genesis].[InfantBirthEvent] be
		ON be.InfantBirthEventID = exer.infantBirthEventID
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = be.participantID
	inner join ITMIDIFZ.genesis.PermissibleValues pv
		on pv.PermissibleValuesID = exer.dischargeConditionCode
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1

--InfantOtherDetail
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.infantOtherDetailID
	, pvQuest.codeDescription
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, pvAnswer.codeDescription as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, NULL as sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.InfantOtherDetail exer
	INNER JOIN ITMIDIFZ.[Genesis].[InfantBirthEvent] be
		ON be.InfantBirthEventID = exer.infantBirthEventID
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = be.participantID
	inner join ITMIDIFZ.genesis.PermissibleValues pvAnswer
		on pvAnswer.PermissibleValuesID = exer.answerCode
	inner join ITMIDIFZ.genesis.PermissibleValues pvQuest
		on pvQuest.PermissibleValuesID = exer.questionCode
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1

--InfantInitialResuscitation
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.infantInitialResuscitationID
	, 'Infant Initial Resuscitation' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, pv.codeDescription as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, pv.sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.InfantInitialResuscitation exer
	INNER JOIN ITMIDIFZ.[Genesis].[InfantBirthEvent] be
		ON be.InfantBirthEventID = exer.infantBirthEventID
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = be.participantID
	inner join ITMIDIFZ.genesis.PermissibleValues pv
		on pv.PermissibleValuesID = exer.initialResuscitationCode
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1

--InfantPrematureBirthEvent
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.infantPrematureBirthEventID
	, 'Premature Birth Event' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, CASE WHEN pv.codeDescription = 'Other' THEN exer.eventOtherSpecified ELSE pv.codeDescription END as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, pv.sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.InfantPrematureBirthEvent exer
	INNER JOIN ITMIDIFZ.[Genesis].[InfantBirthEvent] be
		ON be.InfantBirthEventID = exer.infantBirthEventID
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = be.participantID
	inner join ITMIDIFZ.genesis.PermissibleValues pv
		on pv.PermissibleValuesID = exer.eventCode
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1

--InfantRespiratorySupport
INSERT INTO #sourceCrfData (
[sourceSystemFieldDataID], [sourceSystemFieldDataLabel], [eventCrfID], [crfVersionID], subjectID, [fieldValue], 
[hadQuery], [openQuery], [fieldValueOrdinal], [orgSourceSystemID], [createDate], [createdBy])
SELECT 
	exer.infantRespiratorySupportID
	, 'Infant Respiratory Support' as codeSetName
	, -1 as EventCRFID --** NOT SURE THIS IS NEEDED, so defaulting to -1
	, -1 as crfVersionID
	, sub.subjectID
	, pv.codeDescription as value
	, 0 as hadQuery
	, 0 as [openQuery]
	, pv.sortOrder
	, (SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study102CrfEventAnswers' as [createdBy]
	--select *
FROM ITMIDIFZ.Genesis.InfantRespiratorySupport exer
	INNER JOIN ITMIDIFZ.[Genesis].[InfantBirthEvent] be
		ON be.InfantBirthEventID = exer.infantBirthEventID
    inner join ITMIDIFZ.genesis.Participant part
		on part.participantID = be.participantID
	inner join ITMIDIFZ.genesis.PermissibleValues pv
		on pv.PermissibleValuesID = exer.respiratorySupportCode
	INNER JOIN itmidw.dbo.tblSubject sub on 
		CONVERT(varchar(100), sub.sourceSystemSubjectID) = CONVERT(varchar(100), part.participantID)
	WHERE exer.isactive = 1


--Slowly changing dimension
MERGE  ITMIDW.[dbo].[tblCrfEventAnswers] AS targetCrfData
USING #sourceCrfData ss
	ON targetCrfData.[sourceSystemFieldDataID] = ss.[sourceSystemFieldDataID]
		AND targetCrfData.[sourceSystemFieldDataLabel] = ss.[sourceSystemFieldDataLabel]
      	
WHEN MATCHED
	AND (
           ss.[sourceSystemFieldDataID] <> targetCrfData.[sourceSystemFieldDataID] OR  
           ss.[sourceSystemFieldDataLabel] <> targetCrfData.[sourceSystemFieldDataLabel] OR  
           ss.[eventCrfID] <> targetCrfData.[eventCrfID] OR  
           ss.[crfVersionID] <> targetCrfData.[crfVersionID] OR  
           ss.[fieldValue] <> targetCrfData.[fieldValue] OR  
           ss.[hadQuery] <> targetCrfData.[hadQuery] OR  
           ss.[openQuery] <> targetCrfData.[openQuery] OR  
           ss.[fieldValueOrdinal] <> targetCrfData.[fieldValueOrdinal] OR  
		   ss.[orgSourceSystemID] <> targetCrfData.[orgSourceSystemID] OR  
		   ss.[createDate] <> targetCrfData.[createDate] OR
		   ss.[createdBy] <> targetCrfData.[createdBy] 
	)
THEN UPDATE SET
           [sourceSystemFieldDataID] = ss.[sourceSystemFieldDataID]
           , [sourceSystemFieldDataLabel] = ss.[sourceSystemFieldDataLabel]
           , [eventCrfID] = ss.[eventCrfID]
           , [crfVersionID] = ss.[crfVersionID]
           , [fieldValue] = ss.[fieldValue]
           , [hadQuery] = ss.[hadQuery]
           , [openQuery] = ss.[openQuery]
           , [fieldValueOrdinal] = ss.[fieldValueOrdinal]
		   , [orgSourceSystemID] = ss.[orgSourceSystemID]
	       , [createDate] = ss.[createDate] 
	       , [createdBy] = ss.[createdBy] 
WHEN NOT MATCHED THEN

INSERT (   [sourceSystemFieldDataID]
           ,[sourceSystemFieldDataLabel]
           ,[eventCrfID]
           ,[crfVersionID]
           ,[fieldValue]
           ,[hadQuery]
           ,[openQuery]
           ,[fieldValueOrdinal]
		   ,[orgSourceSystemID]
		   ,[createDate]
		   ,[createdBy])

VALUES (    ss.[sourceSystemFieldDataID]
           ,ss.[sourceSystemFieldDataLabel]
           ,ss.[eventCrfID]
           ,ss.[crfVersionID]
           ,ss.[fieldValue]
           ,ss.[hadQuery]
           ,ss.[openQuery]
           ,ss.[fieldValueOrdinal]
		   ,ss.[orgSourceSystemID]
		   ,ss.[createDate]
		   ,ss.[createdBy]);



END


