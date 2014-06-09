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
SELECT  * Study FROM genesis.Study as Study
SELECT  * StudyProtocol FROM genesis.StudyProtocol as StudyProtocol
SELECT  * StudySite FROM genesis.StudySite as StudySite
SELECT  * Subject FROM genesis.Subject as Subject
SELECT  * UserAccount FROM [MetaDataRepository].UserAccount as UserAccount
*/

--META
SELECT *  FROM genesis.DiseaseRegistry as DiseaseRegistry
SELECT  * FROM genesis.DiseaseRegistryOrganization as DiseaseRegistryOrganization
SELECT  * FROM genesis.DiseaseRegistryPatient as DiseaseRegistryPatient
SELECT  * FROM genesis.EnrollmentDiseaseRegistryRole as EnrollmentDiseaseRegistryRole
SELECT  *  FROM genesis.Study as Study
SELECT  *  FROM genesis.StudyProtocol as StudyProtocol
SELECT  *  FROM genesis.StudySite as StudySite
SELECT  *  FROM genesis.Organization as Organization
---Use for MetaDataPopulation
SELECT  * FROM [MetaDataRepository].EDCKeyMap as EDCKeyMap  
SELECT  *  FROM genesis.PermissibleValues as PermissibleValues order by  codesetName



--LOG (events)
SELECT  * FROM genesis.ExerciseType as ExerciseType  --Linked to motherPregnancyLaborDeliveryID
SELECT  * FROM genesis.InfantBirthEvent as InfantBirthEvent
SELECT  *  FROM genesis.ParticipantFollowUp as ParticipantFollowUp
SELECT  *  FROM genesis.MotherPregnancyLaborDelivery as MotherPregnancyLaborDelivery
SELECT  *  FROM genesis.ParticipantEventComment as ParticipantEventComment
SELECT  *  FROM genesis.ParticipantSpecimenCollection as ParticipantSpecimenCollection

--patient
SELECT  *  FROM genesis.Patient as Patient
SELECT  *  FROM genesis.Subject as Subject
SELECT  *  FROM genesis.ParticipantWithdrawal as ParticipantWithdrawal
SELECT  *  FROM genesis.Participant as Participant
SELECT  *  FROM genesis.ParticipantConsent as ParticipantConsent
SELECT  *  FROM genesis.ParticipantRace as ParticipantRace
--crfdetail
SELECT patientIdentifier, COUNT(*) FROM genesis.PatientDataPointDetail as PatientDataPointDetail  where  dataPageName  = 'Mother Labor and Delivery - 01' group by patientIdentifier ORDER BY patientIdentifier





--TDB
SELECT  * FROM genesis.HistopathologyResult as HistopathologyResult --(2428)
SELECT  * FROM genesis.HRPAdmissionType as HRPAdmissionType
SELECT  * FROM genesis.InfantDischargeCondition as InfantDischargeCondition


SELECT  * FROM genesis.InfantInitialResuscitation as InfantInitialResuscitation
SELECT  * FROM genesis.InfantOtherDetail as InfantOtherDetail
SELECT  * FROM genesis.InfantPrematureBirthEvent as InfantPrematureBirthEvent
SELECT  * FROM genesis.InfantRespiratorySupport as InfantRespiratorySupport
SELECT  * FROM genesis.LifeEventDetail as LifeEventDetail
SELECT  * FROM genesis.MotherLaborDeliveryAdmissionReason as MotherLaborDeliveryAdmissionReason
SELECT  *  FROM genesis.OBHistory as OBHistory
SELECT  *  FROM genesis.ParticipantGrowthCountry as ParticipantGrowthCountry
SELECT  *  FROM genesis.ParticipantMedicalHistory as ParticipantMedicalHistory
SELECT  *  FROM genesis.ParticipantSupplementDetail as ParticipantSupplementDetail
SELECT  *  FROM genesis.ParticipantSurgicalProcedures as ParticipantSurgicalProcedures
SELECT  *  FROM genesis.ParticipantUserAccount as ParticipantUserAccount
SELECT  *  FROM genesis.ParticipantVitals as ParticipantVitals
SELECT  *  FROM genesis.PatientCareTeam as PatientCareTea
SELECT  *  FROM genesis.PregnancyAssistanceType as PregnancyAssistanceType
SELECT  *  FROM genesis.PregnancyConcomitantMedication as PregnancyConcomitantMedication
SELECT  *  FROM genesis.PregnancyEarlyLaborOnsetDetail as PregnancyEarlyLaborOnsetDetail
SELECT  *  FROM genesis.PregnancyInfectionType as PregnancyInfectionType
SELECT  *  FROM genesis.PregnancyMedicalCondition as PregnancyMedicalCondition
SELECT  *  FROM genesis.PregnancyNutritionIntake as PregnancyNutritionIntake
SELECT  *  FROM genesis.PregnancyPastSickness as PregnancyPastSickness
SELECT  *  FROM genesis.PregnancyVaccination as PregnancyVaccination
SELECT  *  FROM [MetaDataRepository].UserAccount as UserAccount
