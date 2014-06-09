/*
--
select 
'SELECT  * ' + name + ' FROM genesis.' + name + ' as ' + name
FROM sysobjects 
where xtype = 'u'
order by name


SELECT  * DiseaseRegistry FROM genesis.DiseaseRegistry as DiseaseRegistry
SELECT  * DiseaseRegistryOrganization FROM genesis.DiseaseRegistryOrganization as DiseaseRegistryOrganization
SELECT  * DiseaseRegistryPatient FROM genesis.DiseaseRegistryPatient as DiseaseRegistryPatient
SELECT  * EDCKeyMap FROM [MetaDataRepository].EDCKeyMap as EDCKeyMap
SELECT  * EnrollmentDiseaseRegistryRole FROM genesis.EnrollmentDiseaseRegistryRole as EnrollmentDiseaseRegistryRole
SELECT  * ExerciseType FROM genesis.ExerciseType as ExerciseType
SELECT  * HistopathologyResult FROM genesis.HistopathologyResult as HistopathologyResult
SELECT  * HRPAdmissionType FROM genesis.HRPAdmissionType as HRPAdmissionType
SELECT  * InfantBirthEvent FROM genesis.InfantBirthEvent as InfantBirthEvent
SELECT  * InfantDischargeCondition FROM genesis.InfantDischargeCondition as InfantDischargeCondition
SELECT  * InfantInitialResuscitation FROM genesis.InfantInitialResuscitation as InfantInitialResuscitation
SELECT  * InfantOtherDetail FROM genesis.InfantOtherDetail as InfantOtherDetail
SELECT  * InfantPrematureBirthEvent FROM genesis.InfantPrematureBirthEvent as InfantPrematureBirthEvent
SELECT  * InfantRespiratorySupport FROM genesis.InfantRespiratorySupport as InfantRespiratorySupport
SELECT  * LifeEventDetail FROM genesis.LifeEventDetail as LifeEventDetail
SELECT  * MotherLaborDeliveryAdmissionReason FROM genesis.MotherLaborDeliveryAdmissionReason as MotherLaborDeliveryAdmissionReason
SELECT  * MotherPregnancyLaborDelivery FROM genesis.MotherPregnancyLaborDelivery as MotherPregnancyLaborDelivery
SELECT  * OBHistory FROM genesis.OBHistory as OBHistory
SELECT  * Organization FROM genesis.Organization as Organization
SELECT  * Participant FROM genesis.Participant as Participant
SELECT  * ParticipantConsent FROM genesis.ParticipantConsent as ParticipantConsent
SELECT  * ParticipantEventComment FROM genesis.ParticipantEventComment as ParticipantEventComment
SELECT  * ParticipantFollowUp FROM genesis.ParticipantFollowUp as ParticipantFollowUp
SELECT  * ParticipantGrowthCountry FROM genesis.ParticipantGrowthCountry as ParticipantGrowthCountry
SELECT  * ParticipantMedicalHistory FROM genesis.ParticipantMedicalHistory as ParticipantMedicalHistory
SELECT  * ParticipantRace FROM genesis.ParticipantRace as ParticipantRace
SELECT  * ParticipantSpecimenCollection FROM genesis.ParticipantSpecimenCollection as ParticipantSpecimenCollection
SELECT  * ParticipantSupplementDetail FROM genesis.ParticipantSupplementDetail as ParticipantSupplementDetail
SELECT  * ParticipantSurgicalProcedures FROM genesis.ParticipantSurgicalProcedures as ParticipantSurgicalProcedures
SELECT  * ParticipantUserAccount FROM genesis.ParticipantUserAccount as ParticipantUserAccount
SELECT  * ParticipantVitals FROM genesis.ParticipantVitals as ParticipantVitals
SELECT  * ParticipantWithdrawal FROM genesis.ParticipantWithdrawal as ParticipantWithdrawal
SELECT  * Patient FROM genesis.Patient as Patient
SELECT  * PatientCareTeam FROM genesis.PatientCareTeam as PatientCareTeam
SELECT  * PatientDataPointDetail FROM genesis.PatientDataPointDetail as PatientDataPointDetail
SELECT  * PermissibleValues FROM genesis.PermissibleValues as PermissibleValues
SELECT  * PregnancyAssistanceType FROM genesis.PregnancyAssistanceType as PregnancyAssistanceType
SELECT  * PregnancyConcomitantMedication FROM genesis.PregnancyConcomitantMedication as PregnancyConcomitantMedication
SELECT  * PregnancyEarlyLaborOnsetDetail FROM genesis.PregnancyEarlyLaborOnsetDetail as PregnancyEarlyLaborOnsetDetail
SELECT  * PregnancyInfectionType FROM genesis.PregnancyInfectionType as PregnancyInfectionType
SELECT  * PregnancyMedicalCondition FROM genesis.PregnancyMedicalCondition as PregnancyMedicalCondition
SELECT  * PregnancyNutritionIntake FROM genesis.PregnancyNutritionIntake as PregnancyNutritionIntake
SELECT  * PregnancyPastSickness FROM genesis.PregnancyPastSickness as PregnancyPastSickness
SELECT  * PregnancyVaccination FROM genesis.PregnancyVaccination as PregnancyVaccination
--SELECT  *  FROM genesis.Study as Study
--SELECT  *  FROM genesis.StudyProtocol as StudyProtocol
SELECT  *   FROM genesis.StudySite as StudySite
--SELECT  *  FROM genesis.Subject as Subject
SELECT  * UserAccount FROM [MetaDataRepository].UserAccount as UserAccount
*/

--META
SELECT *  FROM genesis.DiseaseRegistry as DiseaseRegistry --(2) --AE90E7E3-E2A4-443D-97AE-5CACF0DCB8E9
SELECT  *  FROM genesis.Study as Study--(2)
SELECT  *  FROM genesis.StudyProtocol as StudyProtocol --(2)

SELECT  * FROM genesis.DiseaseRegistryOrganization as DiseaseRegistryOrganization --(17) FLUFF
SELECT  *  FROM genesis.StudySite as StudySite --(17)
SELECT  *  FROM genesis.Organization as Organization --(23)

SELECT  * FROM genesis.EnrollmentDiseaseRegistryRole as EnrollmentDiseaseRegistryRole --(197)

SELECT  *  FROM [MetaDataRepository].UserAccount as UserAccount--(324)
---Use for MetaDataPopulation
SELECT  *  FROM genesis.PermissibleValues as PermissibleValues where codesetname = 'statusCode' order by codesetName --(1547)

--LOG (events)
SELECT  * FROM genesis.ExerciseType as ExerciseType  -- (3035)Linked to motherPregnancyLaborDeliveryID
SELECT  * FROM genesis.InfantBirthEvent as InfantBirthEvent --(646)
SELECT  *  FROM genesis.ParticipantFollowUp as ParticipantFollowUp --(592)
SELECT  *  FROM genesis.MotherPregnancyLaborDelivery as MotherPregnancyLaborDelivery --(1294)
SELECT  *  FROM genesis.ParticipantEventComment as ParticipantEventComment--(2852)
SELECT  *  FROM genesis.ParticipantSpecimenCollection as ParticipantSpecimenCollection --(5877)
--select o.name, c.name,* from sysobjects o inner join syscolumns c on c.id = o.id where c.name like '%vaccinationCode%'
--patient
SELECT  *  FROM genesis.Patient as Patient --(1339)  --**DIFFERENCE BETWEEN ISVISIBLE AND ISACTIVE

--SELECT  changereason,count(*)  FROM genesis.Patient as Patient GROUP BY changereason order by changeReason
--NULL	971
--Clarify: Subcase 06453624-1 was created for DanielStaufferInova	1
--DTC2_DeleteSubject()	278
--Manual update per paper subject transfer form	1
--ParticipantWithdraw_AINSUPD_TRG	88

SELECT  * FROM genesis.DiseaseRegistryPatient as DiseaseRegistryPatient --(1339)  --** this maps patient to disease registry (study)
SELECT  *  FROM genesis.Subject as Subject --Family --(1339)  --estimated delivery day \ month \ year into tblClinicalDataDates


SELECT  *  FROM genesis.ParticipantWithdrawal as ParticipantWithdrawal --(303)  --withdrawl data into tblClinicalDataDates
SELECT  *  FROM genesis.Participant as Participant --(4223)  --this is the subject, tblclincialdatadates, links to subject
SELECT  *  FROM genesis.ParticipantConsent as ParticipantConsent --(3924) - tblclinicalDataDates
SELECT  *  FROM genesis.ParticipantRace as ParticipantRace --(1369) --why is race in seperate table
--crfdetail

SELECT  subjectID, ODMFormOID,* FROM [MetaDataRepository].EDCKeyMap as EDCKeyMap ORDER BY EDCKeyMap.subjectID, EDCKeyMap.ODMFormOID --(147604)

--TDB
SELECT  * FROM genesis.HistopathologyResult as HistopathologyResult --(2428)
SELECT  * FROM genesis.HRPAdmissionType as HRPAdmissionType--(1214)
SELECT  * FROM genesis.InfantDischargeCondition as InfantDischargeCondition--(2504)
SELECT  * FROM genesis.InfantInitialResuscitation as InfantInitialResuscitation--(3756)
SELECT  * FROM genesis.InfantOtherDetail as InfantOtherDetail--(14505)
SELECT  * FROM genesis.InfantPrematureBirthEvent as InfantPrematureBirthEvent--(6430)
SELECT  * FROM genesis.InfantRespiratorySupport as InfantRespiratorySupport--(4382)
SELECT  * FROM genesis.LifeEventDetail as LifeEventDetail--(10336)
SELECT  * FROM genesis.MotherLaborDeliveryAdmissionReason as MotherLaborDeliveryAdmissionReason--(7891)
SELECT  *  FROM genesis.OBHistory as OBHistory--(3035)
SELECT  *  FROM genesis.ParticipantGrowthCountry as ParticipantGrowthCountry--(2736)
SELECT  *  FROM genesis.ParticipantMedicalHistory as ParticipantMedicalHistory--(5042)
SELECT  *  FROM genesis.ParticipantSupplementDetail as ParticipantSupplementDetail--(10112)
SELECT  *  FROM genesis.ParticipantSurgicalProcedures as ParticipantSurgicalProcedures--(2101)
SELECT  *  FROM genesis.ParticipantUserAccount as ParticipantUserAccount--(207)
SELECT  *  FROM genesis.ParticipantVitals as ParticipantVitals--(14324)
SELECT  *  FROM genesis.PatientCareTeam as PatientCareTea--(20788)
SELECT  *  FROM genesis.PregnancyAssistanceType as PregnancyAssistanceType--(1821)
SELECT  *  FROM genesis.PregnancyConcomitantMedication as PregnancyConcomitantMedication--(1146)
SELECT  *  FROM genesis.PregnancyEarlyLaborOnsetDetail as PregnancyEarlyLaborOnsetDetail--(4249)
SELECT  *  FROM genesis.PregnancyInfectionType as PregnancyInfectionType--(1818)
SELECT  *  FROM genesis.PregnancyMedicalCondition as PregnancyMedicalCondition--(9090)
SELECT  *  FROM genesis.PregnancyNutritionIntake as PregnancyNutritionIntake--(4249)
SELECT  *  FROM genesis.PregnancyPastSickness as PregnancyPastSickness--(3654)
SELECT  *  FROM genesis.PregnancyVaccination as PregnancyVaccination--(6666)

