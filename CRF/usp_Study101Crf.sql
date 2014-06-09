IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'itmidw.[usp_Study101Crf]') AND type in (N'P', N'PC'))
DROP PROCEDURE itmidw.[usp_Study101Crf]
GO	
/**************************************************************************
Created On : 4/1/2014
Created By : Aaron Black
Team Name : Informatics
Object name : [usp_Study101Crf]
Functional : ITMI SSIS for Insert and Update for study 101 crf meta data
Purpose : Import of study 101 crf meta data, this is stagant data and should be  one time import, this should mostly be remarked out.
History : Created on 4/1/2014
*************************************************************************
Date Modified By QC# Purposes
**************************************************************************
#Date #Comment
**************************************************************************
USE CASE:
EXEC [usp_Study101Crf]
--testing update and delete
**************************************************************************/
CREATE PROCEDURE itmidw.[usp_Study101Crf]
AS
BEGIN
SET NOCOUNT ON;
DECLARE @UpdatedOn SMALLDATETIME
SET @UpdatedOn = CAST(GETDATE() AS SMALLDATETIME)
PRINT CONVERT(CHAR(23), @UpdatedOn, 121) + ' [usp_Study101Crf][' + @@SERVERNAME + '][' + SYSTEM_USER + ']'
PRINT 'INSERT [ITMIDW].itmidw.[usp_Study101Crf]...'


--**************************************************************************
--*******[tblcrfType]********DBCC CHECKIDENT('tblSubject', RESEED, 1)*******
--**************************************************************************
--drop table
/*
IF OBJECT_ID('tempdb..#sourceSubject') IS NOT NULL
DROP TABLE #sourceSubject  

INSERT INTO itmidw.[tblCrfType](crfTypeCode, [crfTypeID],[crfTypeName])
SELECT '101Mother',	28,	'Study101 Mother' UNION
SELECT '101Father',	29,	'Study101 Father' UNION
SELECT '101NewBorn',	30,	'Study101 New Born' 


--*************************************
--****tblCrfSourceSystemMap************
--*************************************
INSERT INTO itmidw.[tblCrfSourceSystemMap]([sourceSystemMapID],SourceSystemCrfLabel, [crfID], [sourceSystemID])
SELECT 28,'101Mother',	28,	6 UNION
SELECT 29,'101Father',	29,	6 UNION
SELECT 30,'101NewBorn',	30,	6 


--**************************************************************************
---************[tblCrf]*****************************************************
--**************************************************************************

--*************************************
--***************101*******************
--*************************************
--delete from itmidw.[tblCrf] where [orgSourceSystemID] = 6

INSERT INTO itmidw.[tblCrf]([sourceSystemCrfID],[crfShortName],[crfTypeID],[crfName],[sourceSystemID],[orgSourceSystemID],[createDate],[createdBy])
SELECT 28, 'EDC101Mother',28, 'Sharepoint: Mother: 101', 6, 6,GETDATE(), 'usp_Study101Crf' UNION
SELECT 29, 'EDC101Father',29, 'Sharepoint: Father: 101', 6, 6,GETDATE(), 'usp_Study101Crf' UNION
SELECT 30, 'EDC101NewBorn',30, 'Sharepoint: Newborn: 101', 6,6, GETDATE(), 'usp_Study101Crf' 




--**************************************************************************
---********tblCrfVersion****************************************************
--**************************************************************************

--*************************************
--******************101****************
--*************************************
INSERT INTO itmidw.[tblCrfVersion]([sourceSystemCrfVersionID],[sourceSystemVersionID],[crfID],[crfVersionName],[orgSourceSystemID],[createDate],[createdBy])
SELECT 28,28,28, '101Mother: v1' , 6,GETDATE(), 'usp_Study101Crf' UNION
SELECT 29,29,29, '101Father: v1', 6,GETDATE(), 'usp_Study101Crf' UNION
SELECT 30,30,30, '101Newborn: v1',6, GETDATE(), 'usp_Study101Crf' 


--DELETE FROM tblCrfFields where orgSourceSystemID = 6

	INSERT INTO itmidw.[tblCrfFields]([crfVersionID],[sourceSystemFieldID],[fieldName],[fieldDescription],[cdeID],[questionText],[dataType],[orgSourceSystemID],[createDate],[createdBy], crfSourceSystemFieldOrder)
	SELECT 28,'ViewLink','ViewLink','COMPUTER ASSIGNED',NULL,'COMPUTER ASSIGNED','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'KeyID','KeyID','COMPUTER ASSIGNED',NULL,'COMPUTER ASSIGNED','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Mothers Study ID ','Mothers Study ID ','Unique ID for the participant ',NULL,'Unique ID for the participant ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Family Study ID ','Family Study ID ','Unique ID for the family (ie 101-127)',NULL,'Unique ID for the family (ie 101-127)','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Alcohol Consumption','Alcohol Consumption','Self reported alcohol consumption.',NULL,'Self reported alcohol consumption.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Antenatal Steroids Indication','Antenatal Steroids Indication','The reason for giving antenatal steroids during pregnancy. ',NULL,'The reason for giving antenatal steroids during pregnancy. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Antenatal Steroids Type','Antenatal Steroids Type','Name of or type of the antenatal steroid given during pregnancy.',NULL,'Name of or type of the antenatal steroid given during pregnancy.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Antibiotics Indication ','Antibiotics Indication ','The reason for giving antibiotics during delivery',NULL,'The reason for giving antibiotics during delivery','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Antibiotics Type ','Antibiotics Type ','Type of antibiotics given during delivery',NULL,'Type of antibiotics given during delivery','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Assisted Reproductive Technology','Assisted Reproductive Technology','Type of method used to achieve pregnancy by artificial or partially artificial means.',NULL,'Type of method used to achieve pregnancy by artificial or partially artificial means.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Autoimmune Conditions-Mothers medical condition ','Autoimmune Conditions-Mothers medical condition ','Self-reported autoimmune disorder (condition that occurs when the immune system mistakenly attacks and destroys healthy body tissue).',NULL,'Self-reported autoimmune disorder (condition that occurs when the immune system mistakenly attacks and destroys healthy body tissue).','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Birth Weight-Mother','Birth Weight-Mother','Self-reported birth weight in pounds.',NULL,'Self-reported birth weight in pounds.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Birth Weight Grams-Mother','Birth Weight Grams-Mother','Self-reported pounds and ounces. (Can be pre-calculated).',NULL,'Self-reported pounds and ounces. (Can be pre-calculated).','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Birth Weight Ounces-Mother','Birth Weight Ounces-Mother','Self-reported birth weight in ounces. (Can be pre-calculated).',NULL,'Self-reported birth weight in ounces. (Can be pre-calculated).','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Birth Weight Unknown-Mother ','Birth Weight Unknown-Mother ','Self-reported birth weight unknown.',NULL,'Self-reported birth weight unknown.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'BMI ','BMI ','Body Mass Index-calcuated height x weight.',NULL,'Body Mass Index-calcuated height x weight.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Cardiac-Mothers medical condition','Cardiac-Mothers medical condition','Self-reported cardiac condition.',NULL,'Self-reported cardiac condition.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Cervical Cerclage ','Cervical Cerclage ','Procedure for an incompetent cervix (stitch placed). ',NULL,'Procedure for an incompetent cervix (stitch placed). ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Cervical Cerclage Procedure Date ','Cervical Cerclage Procedure Date ','Date cervical cerclage was performed ',NULL,'Date cervical cerclage was performed ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Chlamydia ','Chlamydia ','STD (caused by bacterium) diagnosed during pregnancy. ',NULL,'STD (caused by bacterium) diagnosed during pregnancy. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Chorioamnionitis during delivery ','Chorioamnionitis during delivery ','Infection of the membranes and/or amniotic fluid diagnosed during pregnancy.',NULL,'Infection of the membranes and/or amniotic fluid diagnosed during pregnancy.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Corrective Surgery on Uterine Anomaly ','Corrective Surgery on Uterine Anomaly ','Previous surgery on uterine anomaly noted.',NULL,'Previous surgery on uterine anomaly noted.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Country of Birth-Mother ','Country of Birth-Mother ','Self-reported country of birth.',NULL,'Self-reported country of birth.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'C-Section Other Reason ','C-Section Other Reason ','Text rationale for c-section if multiple reasons. ',NULL,'Text rationale for c-section if multiple reasons. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'C-Section Type ','C-Section Type ','Scheduled is defined by pre-arranged time notation and Unscheduled is defined by no pre-arranged time notation. ',NULL,'Scheduled is defined by pre-arranged time notation and Unscheduled is defined by no pre-arranged time notation. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Current Nutritional Status','Current Nutritional Status','Category of BMI stratification.',NULL,'Category of BMI stratification.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Currently Lives With Babies Father','Currently Lives With Babies Father','Self-reported if currently lives with babies father. NOTE-THIS FIELD CONTAINS DATA BUT IS CURRENTLY UNDER REVIEW.',NULL,'Self-reported if currently lives with babies father. NOTE-THIS FIELD CONTAINS DATA BUT IS CURRENTLY UNDER REVIEW.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Date and Time of Delivery ','Date and Time of Delivery ','Date and time mother delivered newborn.',NULL,'Date and time mother delivered newborn.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Date of Admission ','Date of Admission ','Mother of probands date of admission to hospital.',NULL,'Mother of probands date of admission to hospital.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Date of Birth ','Date of Birth ','Mother of probands date of birth.',NULL,'Mother of probands date of birth.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Date of Discharge ','Date of Discharge ','Mother of probands date of discharge from hospital.  ',NULL,'Mother of probands date of discharge from hospital.  ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Date of Exposure to Hazardous Chemicals ','Date of Exposure to Hazardous Chemicals ','Self-reported exposure date to hazardous chemicals.',NULL,'Self-reported exposure date to hazardous chemicals.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Date Quit Alcohol Consumption ','Date Quit Alcohol Consumption ','Self -reported cessation of alcohol consumption.',NULL,'Self -reported cessation of alcohol consumption.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Date Quit Drinking Unknown ','Date Quit Drinking Unknown ','Self-reported date of cessation of alcohol consumption unknown.',NULL,'Self-reported date of cessation of alcohol consumption unknown.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Date Quit Smoking ','Date Quit Smoking ','Self-reported cessation of smoking.',NULL,'Self-reported cessation of smoking.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Date Quit Smoking Unknown ','Date Quit Smoking Unknown ','Self-reported date of cessation of smoking unknown.',NULL,'Self-reported date of cessation of smoking unknown.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Delivery Result of Other Reason ','Delivery Result of Other Reason ','If delivery a result other than Premature Rupture of Membranes (PROM) or Premature Labor indicate reason.',NULL,'If delivery a result other than Premature Rupture of Membranes (PROM) or Premature Labor indicate reason.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Drinking Exposure 3 Months Prior to Conception ','Drinking Exposure 3 Months Prior to Conception ','Self-reported exposure to drinking prior to conception.',NULL,'Self-reported exposure to drinking prior to conception.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Drinking Frequency ','Drinking Frequency ','Self-reported frequency of alcohol consumption.',NULL,'Self-reported frequency of alcohol consumption.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Drug Use Ending Date ','Drug Use Ending Date ','Self-reported date of cessation of drug use.',NULL,'Self-reported date of cessation of drug use.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Drug Use Exposure 3 Months Prior to Conception ','Drug Use Exposure 3 Months Prior to Conception ','Self-reported exposure to drug use prior to conception.',NULL,'Self-reported exposure to drug use prior to conception.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Drug Use Starting Date ','Drug Use Starting Date ','Self-reported starting date of drug use.',NULL,'Self-reported starting date of drug use.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Early Onset of Labor in Previous Pregnancies ','Early Onset of Labor in Previous Pregnancies ','Uterine contraction or cervical dilation prior to 37 weeks in a previous pregnancy.',NULL,'Uterine contraction or cervical dilation prior to 37 weeks in a previous pregnancy.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Early Onset of Labor Number of Pregnancies ','Early Onset of Labor Number of Pregnancies ','Number of previous pregnancies with uterine contraction or cervical dilation prior to 37 weeks.',NULL,'Number of previous pregnancies with uterine contraction or cervical dilation prior to 37 weeks.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Education Level ','Education Level ','Self reported educational level.',NULL,'Self reported educational level.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Endometriosis ','Endometriosis ','Inflammatory uterine condition diagnosed prior to pregnancy.',NULL,'Inflammatory uterine condition diagnosed prior to pregnancy.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Endometriosis Corrective Surgery ','Endometriosis Corrective Surgery ','Previous surgery on endometriosis noted.',NULL,'Previous surgery on endometriosis noted.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Endometriosis Corrective Surgery Date ','Endometriosis Corrective Surgery Date ','Date of corrective surgery for endometriosis.',NULL,'Date of corrective surgery for endometriosis.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Endometriosis Diagnose Date ','Endometriosis Diagnose Date ','Date diagnosed with endometriosis. ',NULL,'Date diagnosed with endometriosis. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Evidence of Infection during the delivery ','Evidence of Infection during the delivery ','Infection during delivery defined as fever, positive placental histopathology, chorioamnionitis, or other documented events related to infection in medical record.',NULL,'Infection during delivery defined as fever, positive placental histopathology, chorioamnionitis, or other documented events related to infection in medical record.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Exposure to Hazardous Chemicals ','Exposure to Hazardous Chemicals ','Self-reported exposure to known hazardous chemicals such as jet fuel, military exposures, illicite drugs.',NULL,'Self-reported exposure to known hazardous chemicals such as jet fuel, military exposures, illicite drugs.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Family Autoimmune ','Family Autoimmune ','Mother of proband-Her family history for autoimmune disorders. ',NULL,'Mother of proband-Her family history for autoimmune disorders. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Family Autoimmune Type ','Family Autoimmune Type ','Mother of proband-Her family history for type of autoimmune disorders. ',NULL,'Mother of proband-Her family history for type of autoimmune disorders. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Family CA Type ','Family CA Type ','Mother of proband-Her family history for type of chromosomal abnormality.',NULL,'Mother of proband-Her family history for type of chromosomal abnormality.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Family Cancer ','Family Cancer ','Mother of proband-Her family history for cancer.',NULL,'Mother of proband-Her family history for cancer.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Family Cancer Type ','Family Cancer Type ','Mother of proband-Her family history for type of cancer.',NULL,'Mother of proband-Her family history for type of cancer.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Family Cardiac ','Family Cardiac ','Mother of proband-Her family history for cardiac issues.',NULL,'Mother of proband-Her family history for cardiac issues.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Family Cardiac Type ','Family Cardiac Type ','Mother of proband-Her family history for type of cardiac issues.',NULL,'Mother of proband-Her family history for type of cardiac issues.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Family Chromosomal Abnormality ','Family Chromosomal Abnormality ','Mother of proband-Her family history of chromosomal abnormalities.',NULL,'Mother of proband-Her family history of chromosomal abnormalities.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Family Diabetes ','Family Diabetes ','Mother of proband-Her family history of diabetes.',NULL,'Mother of proband-Her family history of diabetes.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Family Diabetes Type ','Family Diabetes Type ','Mother of proband-Her family history of type of diabetes.',NULL,'Mother of proband-Her family history of type of diabetes.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Family History of PTB ','Family History of PTB ','Mother of proband-Her family history of Pre-term Birth (PTB)',NULL,'Mother of proband-Her family history of Pre-term Birth (PTB)','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Family Hypertension ','Family Hypertension ','Mother of proband-Her family history of hypertension.',NULL,'Mother of proband-Her family history of hypertension.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Family Hypotension ','Family Hypotension ','Mother of proband-Her family history of hypotension.',NULL,'Mother of proband-Her family history of hypotension.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Family Medical History Other ','Family Medical History Other ','Mother of proband-Her family history of other medical issues.',NULL,'Mother of proband-Her family history of other medical issues.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Family Other Type ','Family Other Type ','Mother of proband-Her family history of other type of medical history.',NULL,'Mother of proband-Her family history of other type of medical history.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Family Thyroid ','Family Thyroid ','Mother of proband-Her family history of thyroid issues.',NULL,'Mother of proband-Her family history of thyroid issues.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Family Thyroid Type ','Family Thyroid Type ','Mother of proband-Her family history of type of thyroid issues.',NULL,'Mother of proband-Her family history of type of thyroid issues.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Fathers Country of Birth ','Fathers Country of Birth ','Self-reported father of probands country of birth.',NULL,'Self-reported father of probands country of birth.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Fetal Demise ','Fetal Demise ','Death of fetus. ',NULL,'Death of fetus. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Fever during delivery ','Fever during delivery ','Temperature >38.5 during delivery as documented in medical record.',NULL,'Temperature >38.5 during delivery as documented in medical record.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Full Term Weeks-Mother of Proband','Full Term Weeks-Mother of Proband','Self-reported mother of probands estimated gestational age in weeks at birth (mother of probands full term or pre-term status).',NULL,'Self-reported mother of probands estimated gestational age in weeks at birth (mother of probands full term or pre-term status).','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'GBS Positive ','GBS Positive ','Diagnosis of Group B Streph (a bacterial infection that can be passed from mother to baby during delivery). ',NULL,'Diagnosis of Group B Streph (a bacterial infection that can be passed from mother to baby during delivery). ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Gestational Age at Time of Delivery-Mother','Gestational Age at Time of Delivery-Mother','Self-reported mother of probands estimated gestational age at birth (mother of probands full term or pre-term status).',NULL,'Self-reported mother of probands estimated gestational age at birth (mother of probands full term or pre-term status).','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Gestational Age (proband) in weeks at the time of delivery-Mother','Gestational Age (proband) in weeks at the time of delivery-Mother','Age of the proband in weeks at time of delivery.  FIELD MUST BE COMBINED WITH LINE 113.',NULL,'Age of the proband in weeks at time of delivery.  FIELD MUST BE COMBINED WITH LINE 113.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Gestational Age (proband) in days at the time of Delivery ','Gestational Age (proband) in days at the time of Delivery ','Age of the proband in days at time of delivery. FIELD MUST BE COMBINED WITH LINE 112.',NULL,'Age of the proband in days at time of delivery. FIELD MUST BE COMBINED WITH LINE 112.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Gestational Diabetes ','Gestational Diabetes ','Diagnosis of diabetes during pregnancy. ',NULL,'Diagnosis of diabetes during pregnancy. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Gravida ','Gravida ','Number of times mother has been previously pregnant (regardless of whether these pregnancies were carried to term). ',NULL,'Number of times mother has been previously pregnant (regardless of whether these pregnancies were carried to term). ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Has the Mother Been Diagnosed with a Uterine Anomaly ','Has the Mother Been Diagnosed with a Uterine Anomaly ','Diagnosis of uterine anomaly to include congenital birth defects such as a bicornuate or unicornuate uterus. ',NULL,'Diagnosis of uterine anomaly to include congenital birth defects such as a bicornuate or unicornuate uterus. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Hazardous Exposure 3 Months Prior to Conception ','Hazardous Exposure 3 Months Prior to Conception ','Self-reported hazard exposure (includes jet fuel, military exposures, illicit drugs).  ',NULL,'Self-reported hazard exposure (includes jet fuel, military exposures, illicit drugs).  ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'HBV Vaccination During Pregnancy ','HBV Vaccination During Pregnancy ','HBV (Hepatitis B) vaccination upon discharge.',NULL,'HBV (Hepatitis B) vaccination upon discharge.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Height Inches ','Height Inches ','Self-reported mother of probands height (in inches) upon admission. ',NULL,'Self-reported mother of probands height (in inches) upon admission. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Hellp ','Hellp ','HELLP syndrome that includes a group of symptoms that occur in pregnant women who have hemolysis, elevated liver enzymes, and low platelet count diagnosed during pregnancy. ',NULL,'HELLP syndrome that includes a group of symptoms that occur in pregnant women who have hemolysis, elevated liver enzymes, and low platelet count diagnosed during pregnancy. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Hispanic Origin ','Hispanic Origin ','Self-reported ethnicity of Hispanic origin. ',NULL,'Self-reported ethnicity of Hispanic origin. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'History of Cancer ','History of Cancer ','Self-reported mother of probands history of cancer. ',NULL,'Self-reported mother of probands history of cancer. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'History of Drug Use ','History of Drug Use ','Self-reported mother of probands history of drug use.',NULL,'Self-reported mother of probands history of drug use.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'History of Extreme Weight Issues ','History of Extreme Weight Issues ','Self-reported mother of probands history of extreme weight issues.',NULL,'Self-reported mother of probands history of extreme weight issues.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'HPV-Diagnosed During Pregnancy','HPV-Diagnosed During Pregnancy','STD (virus from the papillomavirus family) diagnosed during pregnancy.',NULL,'STD (virus from the papillomavirus family) diagnosed during pregnancy.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'HPV-Vaccination During Pregnancy ','HPV-Vaccination During Pregnancy ','HPV (human papillomavirus) vaccination upon discharge. ',NULL,'HPV (human papillomavirus) vaccination upon discharge. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'HRP Admission ','HRP Admission ','High Risk Perinatal (HRP) admission. ',NULL,'High Risk Perinatal (HRP) admission. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'HRP Admission Date ','HRP Admission Date ','Date of High Risk Perinatal (HRP) admission. ',NULL,'Date of High Risk Perinatal (HRP) admission. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Hypotension-Pre-existing','Hypotension-Pre-existing','Diagnosis of hypotension prior to pregnancy. ',NULL,'Diagnosis of hypotension prior to pregnancy. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Income ','Income ','Self-reported household income.',NULL,'Self-reported household income.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Incompetent Shortened Cervix ','Incompetent Shortened Cervix ','Condition where the cervix cannot support the weight of a growing fetus diagnosed during pregnancy.',NULL,'Condition where the cervix cannot support the weight of a growing fetus diagnosed during pregnancy.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Infection ','Infection ','Condition in the body caused by bacteria or a virus diagnosed during pregnancy. ',NULL,'Condition in the body caused by bacteria or a virus diagnosed during pregnancy. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Influenza Vaccination During Pregnancy ','Influenza Vaccination During Pregnancy ','Influenza (flu) vaccination upon discharge. ',NULL,'Influenza (flu) vaccination upon discharge. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Item Child Count','Item Child Count','0',NULL,'0','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Known Chromosomal Abnormality ','Known Chromosomal Abnormality ','Self-reported chromosomal abnormality',NULL,'Self-reported chromosomal abnormality','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Marital Status','Marital Status','Self-reported marital status. NOTE-THIS FIELD CONTAINS DATA BUT IS CURRENTLY UNDER REVIEW.',NULL,'Self-reported marital status. NOTE-THIS FIELD CONTAINS DATA BUT IS CURRENTLY UNDER REVIEW.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Medical Conditions Controlled by Medications ','Medical Conditions Controlled by Medications ','Medical conditions controlled by medications. ',NULL,'Medical conditions controlled by medications. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Mode of Delivery ','Mode of Delivery ','Method of delivery.',NULL,'Method of delivery.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Mode of Pregnancy ','Mode of Pregnancy ','Method used to achieve pregnancy. ',NULL,'Method used to achieve pregnancy. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Months Drinking ','Months Drinking ','Self-reported number of months drinking.',NULL,'Self-reported number of months drinking.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Months Smoking ','Months Smoking ','Self-reported number of months smoking.',NULL,'Self-reported number of months smoking.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Mothers Country of Birth ','Mothers Country of Birth ','Self-reported mother of probands country of birth.',NULL,'Self-reported mother of probands country of birth.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'No Medical Conditions During Pregnancy ','No Medical Conditions During Pregnancy ','No medical conditions during pregnancy for mother. ',NULL,'No medical conditions during pregnancy for mother. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'No Vaccinations During Pregnancy ','No Vaccinations During Pregnancy ','No vaccinations upon discharge.',NULL,'No vaccinations upon discharge.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Number of Gestatations During Pregnancy ','Number of Gestatations During Pregnancy ','Number of gestations in current pregnancy. ',NULL,'Number of gestations in current pregnancy. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Occupation ','Occupation ','Self-reported occupation. NOTE-EACH LINE REPRESENTS A PERMISSIBLE VALUE FOR A TOTAL OF 6 OPTIONS, BUT ONLY ONE OPTION IS REPORTED.',NULL,'Self-reported occupation. NOTE-EACH LINE REPRESENTS A PERMISSIBLE VALUE FOR A TOTAL OF 6 OPTIONS, BUT ONLY ONE OPTION IS REPORTED.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Occupation Other ','Occupation Other ','Other occupation not noted above.',NULL,'Other occupation not noted above.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'On Antenatal Steroids during Pregnancy ','On Antenatal Steroids during Pregnancy ','Steroids given to mother during pregnancy as documented. ',NULL,'Steroids given to mother during pregnancy as documented. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'On Antibiotics during Pregnancy ','On Antibiotics during Pregnancy ','Antibiotics given to mother during pregnancy as documented. ',NULL,'Antibiotics given to mother during pregnancy as documented. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'On Medication during Pregnancy ','On Medication during Pregnancy ','Medications received during pregnancy as documented.',NULL,'Medications received during pregnancy as documented.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'On Other Medication Type ','On Other Medication Type ','Type of other medications received during pregnancy as documented. ',NULL,'Type of other medications received during pregnancy as documented. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'On Tocolytic Therapy during Pregnancy ','On Tocolytic Therapy during Pregnancy ','Tocolytic therapy given to mother during pregnancy as documented.',NULL,'Tocolytic therapy given to mother during pregnancy as documented.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Other Infections during delivery ','Other Infections during delivery ','Documented infection during delivery. ',NULL,'Documented infection during delivery. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Other Infections during delivery Findings ','Other Infections during delivery Findings ','Findings of documented infection during delivery',NULL,'Findings of documented infection during delivery','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Other Medical Conditions','Other Medical Conditions','Text rationale for other medical conditions',NULL,'Text rationale for other medical conditions','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Other Medication Indication-during pregnancy','Other Medication Indication-during pregnancy','Text rationale for other medication indication',NULL,'Text rationale for other medication indication','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Other Medication Type-during pregnancy ','Other Medication Type-during pregnancy ','Text rationale for other medication type',NULL,'Text rationale for other medication type','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Other Vaccinations during pregnancy ','Other Vaccinations during pregnancy ','Other vaccination mother received upon discharge. ',NULL,'Other vaccination mother received upon discharge. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Para ','Para ','Number of viable (>20 wks) births. Twins or triplets count as ONE birth.',NULL,'Number of viable (>20 wks) births. Twins or triplets count as ONE birth.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Path','Path','0',NULL,'0','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Placental Histopathology during delivery ','Placental Histopathology during delivery ','Documented infection on placental pathology report.',NULL,'Documented infection on placental pathology report.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Placental Histopathology during delivery Findings ','Placental Histopathology during delivery Findings ','Documented findings of infection from the placental histopathology report.',NULL,'Documented findings of infection from the placental histopathology report.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Placental Previa/Abruption ','Placental Previa/Abruption ','Condition in which the placenta is attached to the uterine wall close to or covering the cervix diagnosed during pregnancy. ',NULL,'Condition in which the placenta is attached to the uterine wall close to or covering the cervix diagnosed during pregnancy. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Preeclampsia/Eclampsia ','Preeclampsia/Eclampsia ','Condition in which hypertension arises associated with significant amounts of protein in the urine diagnosed during pregnancy. ',NULL,'Condition in which hypertension arises associated with significant amounts of protein in the urine diagnosed during pregnancy. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Pre-Existing Medical Conditions ','Pre-Existing Medical Conditions ','Illness, disease, or condition that exists prior to pregnancy. ',NULL,'Illness, disease, or condition that exists prior to pregnancy. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Pre-Existing Medical Conditions Other ','Pre-Existing Medical Conditions Other ','Other illness, disease, or condition that exists prior to pregnancy. ',NULL,'Other illness, disease, or condition that exists prior to pregnancy. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Pre-Existing Medical Listed Conditions ','Pre-Existing Medical Listed Conditions ','Listed other illness, disease or condition that exists prior to pregnancy.',NULL,'Listed other illness, disease or condition that exists prior to pregnancy.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Pregnancy Induced Hypertension ','Pregnancy Induced Hypertension ','Hypertension diagnosed during pregnancy.  ',NULL,'Hypertension diagnosed during pregnancy.  ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Prenatal Care ','Prenatal Care ','Health care provided for mother and unborn child during pregnancy. No=<3 MD visits, Yes=>3 MD visits',NULL,'Health care provided for mother and unborn child during pregnancy. No=<3 MD visits, Yes=>3 MD visits','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Pre-Pregnancy BMI ','Pre-Pregnancy BMI ','Pre-Pregnancy body mass index-calcuated height x weight.',NULL,'Pre-Pregnancy body mass index-calcuated height x weight.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Pre-Pregnancy Height Inches ','Pre-Pregnancy Height Inches ','Mothers height in inches prior to pregnancy. ',NULL,'Mothers height in inches prior to pregnancy. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Pre-Pregnancy Weight ','Pre-Pregnancy Weight ','Mothers weight in pounds prior to pregnancy. ',NULL,'Mothers weight in pounds prior to pregnancy. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Pre-Pregnancy Weight Grams ','Pre-Pregnancy Weight Grams ','0',NULL,'0','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Pre-Term Weeks-Mother of proband','Pre-Term Weeks-Mother of proband','Mothers gestational age in weeks at the time she was delivered. Pre-Term values must be < 37 weeks.',NULL,'Mothers gestational age in weeks at the time she was delivered. Pre-Term values must be < 37 weeks.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Previous Cervical Conization or Leep Electrosurgical Excision Procedures ','Previous Cervical Conization or Leep Electrosurgical Excision Procedures ','Previous cervical conization (cervical biopsy) or LEEP procedure (procedure used to remove abnormal tissue from the cervix). ',NULL,'Previous cervical conization (cervical biopsy) or LEEP procedure (procedure used to remove abnormal tissue from the cervix). ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Prom (Delivery A Result Of)','Prom (Delivery A Result Of)','Premature rupture of membranes (condition that occurs in pregnancy when there is rupture of the membranes >1 hour before the onset of labor) as diagnosed during pregnancy. ',NULL,'Premature rupture of membranes (condition that occurs in pregnancy when there is rupture of the membranes >1 hour before the onset of labor) as diagnosed during pregnancy. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Prom in Previous Pregnancies ','Prom in Previous Pregnancies ','PROM in previous pregnancies. ',NULL,'PROM in previous pregnancies. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Prom Number of Pregnancies ','Prom Number of Pregnancies ','Number of previous pregnancies mother had PROM.',NULL,'Number of previous pregnancies mother had PROM.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Psychological Stress During Pregnancy ','Psychological Stress During Pregnancy ','Self-reported psychological stress ',NULL,'Self-reported psychological stress ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Psychological Stress Types ','Psychological Stress Types ','Self-reported specific type of psychological stress life events.  ALLOWS FOR MULTIPLE SELECTIONS.',NULL,'Self-reported specific type of psychological stress life events.  ALLOWS FOR MULTIPLE SELECTIONS.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'PTB Type ','PTB Type ','Self-reported family member with a history of PTB. ',NULL,'Self-reported family member with a history of PTB. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Race ','Race ','Self-reported race.',NULL,'Self-reported race.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Reason for C-Section ','Reason for C-Section ','Reason for c-section. ',NULL,'Reason for c-section. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Recurrent Antepartum Hemorrhage ','Recurrent Antepartum Hemorrhage ','Recurrent antepartum hemorrhage (bleeding from the vagina during pregnancy) diagnosed during pregnancy.',NULL,'Recurrent antepartum hemorrhage (bleeding from the vagina during pregnancy) diagnosed during pregnancy.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Small for Gestational Age/Fetal IUGR','Small for Gestational Age/Fetal IUGR','Newborn who is smaller in size than normal for the babys sex and gestational age. ',NULL,'Newborn who is smaller in size than normal for the babys sex and gestational age. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Smoking Exposure 3 Months Prior to Conception ','Smoking Exposure 3 Months Prior to Conception ','Self-reported smoking exposure 3 months prior to conception.',NULL,'Self-reported smoking exposure 3 months prior to conception.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Smoking Frequency ','Smoking Frequency ','Self-reported smoking frequency. ',NULL,'Self-reported smoking frequency. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Smoking Status ','Smoking Status ','Self-reported smoking status.',NULL,'Self-reported smoking status.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Socio-Economic Status Declined ','Socio-Economic Status Declined ','Self-reported socio-economic status declined. ',NULL,'Self-reported socio-economic status declined. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Spontaneous Mode of Membrane Rupture ','Spontaneous Mode of Membrane Rupture ','Mode of membrance rupture (mode used to describe rupture of the amniotic sac) diagnosed during pregnancy.',NULL,'Mode of membrance rupture (mode used to describe rupture of the amniotic sac) diagnosed during pregnancy.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Submitted ','Submitted ','0',NULL,'0','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Submitted By ','Submitted By ','0',NULL,'0','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Td During Pregnancy ','Td During Pregnancy ','Mother received Td (Tetanus and Diphtheria) vaccination upon discharge. ',NULL,'Mother received Td (Tetanus and Diphtheria) vaccination upon discharge. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Tdap During Pregnancy ','Tdap During Pregnancy ','Mother received Tdap (Tetanus, Diphtheria, and Pertussis) upon discharge.',NULL,'Mother received Tdap (Tetanus, Diphtheria, and Pertussis) upon discharge.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'TestDate ','TestDate ','0',NULL,'0','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'TestNumber ','TestNumber ','0',NULL,'0','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Tetanus During Pregnancy ','Tetanus During Pregnancy ','Mother received Tetanus vaccination upon discharge. ',NULL,'Mother received Tetanus vaccination upon discharge. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Thyroid ','Thyroid ','Condition in the body involving the thyroid including hyperthyroidism or hypothyroidism) diagnosed during pregnancy.',NULL,'Condition in the body involving the thyroid including hyperthyroidism or hypothyroidism) diagnosed during pregnancy.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Title ','Title ','0',NULL,'0','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Tocolytic Therapy Indication ','Tocolytic Therapy Indication ','0',NULL,'0','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Tocolytic Therapy Type ','Tocolytic Therapy Type ','0',NULL,'0','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Type of Abnormality ','Type of Abnormality ','Type of chromosal abnormality mother was diagnosed with.',NULL,'Type of chromosal abnormality mother was diagnosed with.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Type of Cancer-Mother','Type of Cancer-Mother','Mothers type of cancer',NULL,'Mothers type of cancer','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Ureaplasma ','Ureaplasma ','Bacterial infection diagnosed during pregnancy. ',NULL,'Bacterial infection diagnosed during pregnancy. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Uterine Anomaly Diagnosis Date ','Uterine Anomaly Diagnosis Date ','Date mother was diagnosed with uterine anomaly. ',NULL,'Date mother was diagnosed with uterine anomaly. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Uterine Anomaly Due to Des Exposure ','Uterine Anomaly Due to Des Exposure ','Diagnosed with uterine anomaly due to DES exposure (Diethylstilbestrol which is a synthetic form of estrogen).',NULL,'Diagnosed with uterine anomaly due to DES exposure (Diethylstilbestrol which is a synthetic form of estrogen).','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Uterine Anomaly Type ','Uterine Anomaly Type ','Type of uterine anomaly mother was diagnosed with.',NULL,'Type of uterine anomaly mother was diagnosed with.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Vaginal Bleeding/Spotting ','Vaginal Bleeding/Spotting ','Vaginal bleeding or spotting diagnosed during pregnancy. ',NULL,'Vaginal bleeding or spotting diagnosed during pregnancy. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Was the Delivery a Result of ','Was the Delivery a Result of ','Delivery was a result of Premature Rupture of Membranes (PROM), Premature Labor, or Other.',NULL,'Delivery was a result of Premature Rupture of Membranes (PROM), Premature Labor, or Other.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Weight ','Weight ','Weight upon admission.',NULL,'Weight upon admission.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Weight Gain During Pregnancy ','Weight Gain During Pregnancy ','Mothers weight gain during pregancy. Calculated value based on pre-pregnancy weight minus mothers current weight at time of delivery',NULL,'Mothers weight gain during pregancy. Calculated value based on pre-pregnancy weight minus mothers current weight at time of delivery','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Weight Grams ','Weight Grams ','0',NULL,'0','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Years Drinking ','Years Drinking ','Self-reported years drinking.',NULL,'Self-reported years drinking.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Years Smoking ','Years Smoking ','Self-reported years smoking.',NULL,'Self-reported years smoking.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 28,'Zip Code of Residence ','Zip Code of Residence ','Postal code used by the US Postal Service that identifies where mother resides.',NULL,'Postal code used by the US Postal Service that identifies where mother resides.','','6',GETDATE(),'usp_Study101Crf',NULL UNION

	SELECT 29,'ViewLink','ViewLink','COMPUTER ASSIGNED',NULL,'COMPUTER ASSIGNED','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'KeyID','KeyID','COMPUTER ASSIGNED',NULL,'COMPUTER ASSIGNED','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Fathers Study ID','Fathers Study ID','Unique ID for the participant ',NULL,'Unique ID for the participant ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Family Study ID','Family Study ID','Unique ID for the family (ie 101-127)',NULL,'Unique ID for the family (ie 101-127)','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Alcohol Consumption','Alcohol Consumption','Self reported alcohol consumption.',NULL,'Self reported alcohol consumption.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Birth Complications','Birth Complications','0',NULL,'0','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Birth Weight-Father','Birth Weight-Father','Self-reported birth weight in pounds.',NULL,'Self-reported birth weight in pounds.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Birth Weight Grams-Father','Birth Weight Grams-Father','Calcuated based on self-reported pounds and ounces.',NULL,'Calcuated based on self-reported pounds and ounces.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Birth Weight Ounces-Father','Birth Weight Ounces-Father','Self-reported birth weight in ounces.',NULL,'Self-reported birth weight in ounces.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Birth Weight Unknown-Father','Birth Weight Unknown-Father','Self-reported birth weight unknown.',NULL,'Self-reported birth weight unknown.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Connective Tissue-Inflammatory Processes','Connective Tissue-Inflammatory Processes','0',NULL,'0','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Consent for Blood and Tissue use for other Health problems','Consent for Blood and Tissue use for other Health problems','0',NULL,'0','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Consent for Blood and Tissue use for Pre-Term Birth','Consent for Blood and Tissue use for Pre-Term Birth','0',NULL,'0','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Consent to be contacted on additional research','Consent to be contacted on additional research','0',NULL,'0','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Consent to contact their doctor','Consent to contact their doctor','0',NULL,'0','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Country of Birth-Father','Country of Birth-Father','Self-reported country of birth',NULL,'Self-reported country of birth','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Currently Lives With Babies Mother','Currently Lives With Babies Mother','Self-reported if currently lives with babies mother. NOTE-THIS FIELD CONTAINS DATA BUT IS CURRENTLY UNDER REVIEW.',NULL,'Self-reported if currently lives with babies mother. NOTE-THIS FIELD CONTAINS DATA BUT IS CURRENTLY UNDER REVIEW.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Date of Birth-Father','Date of Birth-Father','Self-reported date of birth.',NULL,'Self-reported date of birth.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Date of Diagnosis of Cancer','Date of Diagnosis of Cancer','Self-reported date cancer diagnosed. ',NULL,'Self-reported date cancer diagnosed. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Date of Exposure to Hazardous Chemicals','Date of Exposure to Hazardous Chemicals','Self-reported exposure date to hazardous chemicals.',NULL,'Self-reported exposure date to hazardous chemicals.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Date Quit Alcohol Consumption','Date Quit Alcohol Consumption','Self -reported cessation of alcohol consumption.',NULL,'Self -reported cessation of alcohol consumption.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Date Quit Drinking Unknown','Date Quit Drinking Unknown','Self-reported date of cessation of alcohol consumption unknown.',NULL,'Self-reported date of cessation of alcohol consumption unknown.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Date Quit Smoking','Date Quit Smoking','Self-reported cessation of smoking.',NULL,'Self-reported cessation of smoking.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Date Quit Smoking Unknown','Date Quit Smoking Unknown','Self-reported date of cessation of smoking unknown.',NULL,'Self-reported date of cessation of smoking unknown.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Diabetes-Fathers condition','Diabetes-Fathers condition','0',NULL,'0','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Drinking Exposure 3 Months Prior to Conception','Drinking Exposure 3 Months Prior to Conception','Self-reported exposure to drinking prior to conception.',NULL,'Self-reported exposure to drinking prior to conception.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Drinking Frequency','Drinking Frequency','Self-reported frequency of alcohol consumption.',NULL,'Self-reported frequency of alcohol consumption.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'ED','ED','0',NULL,'0','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Education Level','Education Level','Self reported educational level.',NULL,'Self reported educational level.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Exposure to Hazardous Chemicals','Exposure to Hazardous Chemicals','Self-reported exposure to known hazardous chemicals such as jet fuel, military exposures, illicite drugs.',NULL,'Self-reported exposure to known hazardous chemicals such as jet fuel, military exposures, illicite drugs.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Family Autoimmune','Family Autoimmune','Father of proband-His family history for autoimmune disorders. ',NULL,'Father of proband-His family history for autoimmune disorders. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Family Autoimmune Type','Family Autoimmune Type','Father of proband-His family history for type of autoimmune disorders. ',NULL,'Father of proband-His family history for type of autoimmune disorders. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Family Cancer','Family Cancer','Father of proband-His family history for cancer.',NULL,'Father of proband-His family history for cancer.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Family Cancer Type','Family Cancer Type','Father of proband-His family history for type of cancer.',NULL,'Father of proband-His family history for type of cancer.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Family Cardiac','Family Cardiac','Father of proband-His family history for cardiac issues.',NULL,'Father of proband-His family history for cardiac issues.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Family Cardiac Type','Family Cardiac Type','Father of proband-His family history for type of cardiac issues.',NULL,'Father of proband-His family history for type of cardiac issues.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Family Chromosomal Abnormality','Family Chromosomal Abnormality','Father of proband-His family history of chromosomal abnormalities.',NULL,'Father of proband-His family history of chromosomal abnormalities.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Family Chromosomal Type','Family Chromosomal Type','Father of proband-His family history for type of chromosomal abnormality.',NULL,'Father of proband-His family history for type of chromosomal abnormality.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Family Diabetes','Family Diabetes','Father of proband-His family history of diabetes.',NULL,'Father of proband-His family history of diabetes.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Family Diabetes Type','Family Diabetes Type','Father of proband-His family history of type of diabetes.',NULL,'Father of proband-His family history of type of diabetes.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Family History of PTB','Family History of PTB','Father of proband-His family history of Pre-term Birth (PTB)',NULL,'Father of proband-His family history of Pre-term Birth (PTB)','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Family Hypertension','Family Hypertension','Father of proband-His family history of hypertension.',NULL,'Father of proband-His family history of hypertension.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Family Hypotension','Family Hypotension','Father of proband-His family history of hypotension.',NULL,'Father of proband-His family history of hypotension.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Family Medical History Other','Family Medical History Other','Father of proband-His family history of other medical issues.',NULL,'Father of proband-His family history of other medical issues.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Family Other Type','Family Other Type','Father of proband-Hisfamily history of other type of medical history.',NULL,'Father of proband-Hisfamily history of other type of medical history.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Family Thyroid','Family Thyroid','Mother of proband-Her family history of thyroid issues.',NULL,'Mother of proband-Her family history of thyroid issues.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Family Thyroid Type','Family Thyroid Type','Mother of proband-Her family history of type of thyroid issues.',NULL,'Mother of proband-Her family history of type of thyroid issues.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Fathers Country of Birth','Fathers Country of Birth','Father of probands country of birth',NULL,'Father of probands country of birth','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Full Term Weeks-Father of Proband','Full Term Weeks-Father of Proband','Self-reported father of probands estimated gestational age in weeks at birth (father of probands full term or pre-term status).',NULL,'Self-reported father of probands estimated gestational age in weeks at birth (father of probands full term or pre-term status).','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Gestational Age at Time of Delivery','Gestational Age at Time of Delivery','Self-reported father of probands estimated gestational age at birth (father of probands full term or pre-term status).',NULL,'Self-reported father of probands estimated gestational age at birth (father of probands full term or pre-term status).','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Hazardous Exposure 3 Months Prior to Conception','Hazardous Exposure 3 Months Prior to Conception','Self-reported hazard exposure (includes jet fuel, military exposures, illicit drugs).  ',NULL,'Self-reported hazard exposure (includes jet fuel, military exposures, illicit drugs).  ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Heart Disease','Heart Disease','0',NULL,'0','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Hispanic Origin','Hispanic Origin','Self-reported ethnicity of Hispanic origin. ',NULL,'Self-reported ethnicity of Hispanic origin. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'History of Cancer','History of Cancer','Self-reported father of probands history of cancer. ',NULL,'Self-reported father of probands history of cancer. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Income','Income','Self-reported household income.',NULL,'Self-reported household income.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Item Child Count','Item Child Count','0',NULL,'0','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Item Type ','Item Type ','0',NULL,'0','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Known Chromosomal Abnormality-Father','Known Chromosomal Abnormality-Father','Self-reported chromosomal abnormality',NULL,'Self-reported chromosomal abnormality','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Marfans','Marfans','0',NULL,'0','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Marital Status','Marital Status','Self-reported marital status. NOTE-THIS FIELD CONTAINS DATA BUT IS CURRENTLY UNDER REVIEW.',NULL,'Self-reported marital status. NOTE-THIS FIELD CONTAINS DATA BUT IS CURRENTLY UNDER REVIEW.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Months Drinking','Months Drinking','Self-reported number of months drinking.',NULL,'Self-reported number of months drinking.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Months Smoking','Months Smoking','Self-reported number of months smoking.',NULL,'Self-reported number of months smoking.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Mothers Country of Birth','Mothers Country of Birth','Self-reported father of probands country of birth.',NULL,'Self-reported father of probands country of birth.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Occupation','Occupation','Self-reported occupation.',NULL,'Self-reported occupation.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Occupation Other','Occupation Other','Other occupation not listed above',NULL,'Other occupation not listed above','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Path','Path','0',NULL,'0','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Pre-Term Weeks-Father of proband','Pre-Term Weeks-Father of proband','Father gestational age in weeks at the time he was delivered. Pre-Term values must be < 37 weeks.',NULL,'Father gestational age in weeks at the time he was delivered. Pre-Term values must be < 37 weeks.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'PTB Type','PTB Type','Self-reported family member with a history of PTB. ',NULL,'Self-reported family member with a history of PTB. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Race','Race','Self-reported race.',NULL,'Self-reported race.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Smoking Exposure 3 Months Prior to Conception','Smoking Exposure 3 Months Prior to Conception','Self-reported smoking exposure 3 months prior to conception.',NULL,'Self-reported smoking exposure 3 months prior to conception.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Smoking Frequency','Smoking Frequency','Self-reported smoking frequency. ',NULL,'Self-reported smoking frequency. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Smoking Status','Smoking Status','Self-reported smoking status.',NULL,'Self-reported smoking status.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Socio-Economic Status Declined','Socio-Economic Status Declined','Self-reported socio-economic status declined. ',NULL,'Self-reported socio-economic status declined. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Type of Abnormality-Father','Type of Abnormality-Father','Type of chromosal abnormality father was diagnosed with.',NULL,'Type of chromosal abnormality father was diagnosed with.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Type of Cancer-Father','Type of Cancer-Father','Fathers type of cancer',NULL,'Fathers type of cancer','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Years Drinking','Years Drinking','Self-reported years drinking.',NULL,'Self-reported years drinking.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Years Smoking','Years Smoking','Self-reported years smoking.',NULL,'Self-reported years smoking.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Zip Code of Residence','Zip Code of Residence','Postal code used by the US Postal Service that identifies where father resides.',NULL,'Postal code used by the US Postal Service that identifies where father resides.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Created','Created','COMPUTER ASSIGNED',NULL,'COMPUTER ASSIGNED','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'Modified','Modified','COMPUTER ASSIGNED',NULL,'COMPUTER ASSIGNED','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'ID','ID','COMPUTER ASSIGNED',NULL,'COMPUTER ASSIGNED','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 29,'ItemID','ItemID','COMPUTER ASSIGNED',NULL,'COMPUTER ASSIGNED','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'ViewLink','ViewLink','COMPUTER ASSIGNED',NULL,'COMPUTER ASSIGNED','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'KeyID','KeyID','COMPUTER ASSIGNED',NULL,'COMPUTER ASSIGNED','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Infants Study ID','Infants Study ID','Unique ID for the participant ',NULL,'Unique ID for the participant ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Family Study ID','Family Study ID','Unique ID for the family (ie 101-127)',NULL,'Unique ID for the family (ie 101-127)','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Amount of Transfusions Other','Amount of Transfusions Other','0',NULL,'0','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Amount of Transfusions Platelets','Amount of Transfusions Platelets','0',NULL,'0','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Amount of Transfusions PRBC','Amount of Transfusions PRBC','0',NULL,'0','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Birth Weight-Newborn','Birth Weight-Newborn','Newborns birth weight in pounds. (Can be pre-calculated).',NULL,'Newborns birth weight in pounds. (Can be pre-calculated).','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Birth Weight Grams-Newborn','Birth Weight Grams-Newborn','Newborns birth weight in grams. (Can be pre-calculated).',NULL,'Newborns birth weight in grams. (Can be pre-calculated).','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Birth Weight Ounces-Newborn','Birth Weight Ounces-Newborn','Newborns birth weight in ounces. (Can be pre-calculated).',NULL,'Newborns birth weight in ounces. (Can be pre-calculated).','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Confirmed Diagnosis #1','Confirmed Diagnosis #1','Hospital assigned text description of ICD 9 code abstracted from NICU discharge summary. (Corresponds w/ICD 9 #1). NOTE: LIMITED FREE TEXT VALUES ENTERED, REFER TO EHR FOR ADDTL INFO.',NULL,'Hospital assigned text description of ICD 9 code abstracted from NICU discharge summary. (Corresponds w/ICD 9 #1). NOTE: LIMITED FREE TEXT VALUES ENTERED, REFER TO EHR FOR ADDTL INFO.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Confirmed Diagnosis #10','Confirmed Diagnosis #10','Hospital assigned text description of ICD 9 code abstracted from NICU discharge summary. (Corresponds w/ICD 9 #10).NOTE: LIMITED FREE TEXT VALUES ENTERED, REFER TO EHR FOR ADDTL INFO.',NULL,'Hospital assigned text description of ICD 9 code abstracted from NICU discharge summary. (Corresponds w/ICD 9 #10).NOTE: LIMITED FREE TEXT VALUES ENTERED, REFER TO EHR FOR ADDTL INFO.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Confirmed Diagnosis #2','Confirmed Diagnosis #2','Hospital assigned text description of ICD 9 code abstracted from NICU discharge summary. (Corresponds w/ICD 9 #2).NOTE: LIMITED FREE TEXT VALUES ENTERED, REFER TO EHR FOR ADDTL INFO.',NULL,'Hospital assigned text description of ICD 9 code abstracted from NICU discharge summary. (Corresponds w/ICD 9 #2).NOTE: LIMITED FREE TEXT VALUES ENTERED, REFER TO EHR FOR ADDTL INFO.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Confirmed Diagnosis #3','Confirmed Diagnosis #3','Hospital assigned text description of ICD 9 code abstracted from NICU discharge summary. (Corresponds w/ICD 9 #3). NOTE: LIMITED FREE TEXT VALUES ENTERED, REFER TO EHR FOR ADDTL INFO.',NULL,'Hospital assigned text description of ICD 9 code abstracted from NICU discharge summary. (Corresponds w/ICD 9 #3). NOTE: LIMITED FREE TEXT VALUES ENTERED, REFER TO EHR FOR ADDTL INFO.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Confirmed Diagnosis #4','Confirmed Diagnosis #4','Hospital assigned text description of ICD 9 code abstracted from NICU discharge summary. (Corresponds w/ICD 9 #4).NOTE: LIMITED FREE TEXT VALUES ENTERED, REFER TO EHR FOR ADDTL INFO.',NULL,'Hospital assigned text description of ICD 9 code abstracted from NICU discharge summary. (Corresponds w/ICD 9 #4).NOTE: LIMITED FREE TEXT VALUES ENTERED, REFER TO EHR FOR ADDTL INFO.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Confirmed Diagnosis #5','Confirmed Diagnosis #5','Hospital assigned text description of ICD 9 code abstracted from NICU discharge summary. (Corresponds w/ICD 9 #5).NOTE: LIMITED FREE TEXT VALUES ENTERED, REFER TO EHR FOR ADDTL INFO.',NULL,'Hospital assigned text description of ICD 9 code abstracted from NICU discharge summary. (Corresponds w/ICD 9 #5).NOTE: LIMITED FREE TEXT VALUES ENTERED, REFER TO EHR FOR ADDTL INFO.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Confirmed Diagnosis #6','Confirmed Diagnosis #6','Hospital assigned text description of ICD 9 code abstracted from NICU discharge summary. (Corresponds w/ICD 9 #6). NOTE: LIMITED FREE TEXT VALUES ENTERED, REFER TO EHR FOR ADDTL INFO.',NULL,'Hospital assigned text description of ICD 9 code abstracted from NICU discharge summary. (Corresponds w/ICD 9 #6). NOTE: LIMITED FREE TEXT VALUES ENTERED, REFER TO EHR FOR ADDTL INFO.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Confirmed Diagnosis #7','Confirmed Diagnosis #7','Hospital assigned text description of ICD 9 code abstracted from NICU discharge summary. (Corresponds w/ICD 9 #7).NOTE: LIMITED FREE TEXT VALUES ENTERED, REFER TO EHR FOR ADDTL INFO.',NULL,'Hospital assigned text description of ICD 9 code abstracted from NICU discharge summary. (Corresponds w/ICD 9 #7).NOTE: LIMITED FREE TEXT VALUES ENTERED, REFER TO EHR FOR ADDTL INFO.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Confirmed Diagnosis #8','Confirmed Diagnosis #8','Hospital assigned text description of ICD 9 code abstracted from NICU discharge summary. (Corresponds w/ICD 9 #8).NOTE: LIMITED FREE TEXT VALUES ENTERED, REFER TO EHR FOR ADDTL INFO.',NULL,'Hospital assigned text description of ICD 9 code abstracted from NICU discharge summary. (Corresponds w/ICD 9 #8).NOTE: LIMITED FREE TEXT VALUES ENTERED, REFER TO EHR FOR ADDTL INFO.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Confirmed Diagnosis #9','Confirmed Diagnosis #9','Hospital assigned text description of ICD 9 code abstracted from NICU discharge summary. (Corresponds w/ICD 9 #9).NOTE: LIMITED FREE TEXT VALUES ENTERED, REFER TO EHR FOR ADDTL INFO.',NULL,'Hospital assigned text description of ICD 9 code abstracted from NICU discharge summary. (Corresponds w/ICD 9 #9).NOTE: LIMITED FREE TEXT VALUES ENTERED, REFER TO EHR FOR ADDTL INFO.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Cranial Image Worst Grade','Cranial Image Worst Grade','Grade 1-4 (4 being worst) assigned to the results of cranial imaging ultrasound.',NULL,'Grade 1-4 (4 being worst) assigned to the results of cranial imaging ultrasound.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Cranial Imaging','Cranial Imaging','Cranial ultrasound performed. ',NULL,'Cranial ultrasound performed. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Cranial Imaging Date','Cranial Imaging Date','Date cranial imaging was performed.',NULL,'Date cranial imaging was performed.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Date of Admission to NICU','Date of Admission to NICU','Date newborn was admitted to Neonatal Intensive Care Unit (NICU).',NULL,'Date newborn was admitted to Neonatal Intensive Care Unit (NICU).','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Date of Birth','Date of Birth','Newborns date of birth.',NULL,'Newborns date of birth.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Date of First Transfusion','Date of First Transfusion','Date newborn received first blood transfusion.',NULL,'Date newborn received first blood transfusion.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Discharge Date','Discharge Date','Date newborn was discharged from the hospital. ',NULL,'Date newborn was discharged from the hospital. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Evidence of','Evidence of','Mother/infant had evidence of an infection (including GBS, Chorioamnionitis, UTI, and Other Infection/Illness).',NULL,'Mother/infant had evidence of an infection (including GBS, Chorioamnionitis, UTI, and Other Infection/Illness).','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Genetic Counseling','Genetic Counseling','Genetic counseling was done',NULL,'Genetic counseling was done','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Gestational Age in weeks at the time of Delivery.','Gestational Age in weeks at the time of Delivery.','Age of the proband in weeks and days at time of delivery. ',NULL,'Age of the proband in weeks and days at time of delivery. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Gestational Age in days at the time of Delivery.','Gestational Age in days at the time of Delivery.','Age of the proband in weeks and days at time of delivery. ',NULL,'Age of the proband in weeks and days at time of delivery. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Histopathology done on Placenta/Cord','Histopathology done on Placenta/Cord','Histopathology done on Placenta/Cord.',NULL,'Histopathology done on Placenta/Cord.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'ICD 9 #1','ICD 9 #1','Hospital assigned diagnosis code abstracted from NICU discharge summary. (Corresponds w/ICD 9 #1). NOTE: LIMITED NUMERIC VALUES ENTERED, REFER TO EHR FOR ADDTL INFO.',NULL,'Hospital assigned diagnosis code abstracted from NICU discharge summary. (Corresponds w/ICD 9 #1). NOTE: LIMITED NUMERIC VALUES ENTERED, REFER TO EHR FOR ADDTL INFO.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'ICD 9 #10','ICD 9 #10','Hospital assigned diagnosis code abstracted from NICU discharge summary. (Corresponds w/ICD 9 #10). NOTE: LIMITED NUMERIC VALUES ENTERED, REFER TO EHR FOR ADDTL INFO.',NULL,'Hospital assigned diagnosis code abstracted from NICU discharge summary. (Corresponds w/ICD 9 #10). NOTE: LIMITED NUMERIC VALUES ENTERED, REFER TO EHR FOR ADDTL INFO.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'ICD 9 #2','ICD 9 #2','Hospital assigned diagnosis code abstracted from NICU discharge summary. (Corresponds w/ICD 9 #2). NOTE: LIMITED NUMERIC VALUES ENTERED, REFER TO EHR FOR ADDTL INFO.',NULL,'Hospital assigned diagnosis code abstracted from NICU discharge summary. (Corresponds w/ICD 9 #2). NOTE: LIMITED NUMERIC VALUES ENTERED, REFER TO EHR FOR ADDTL INFO.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'ICD 9 #3','ICD 9 #3','Hospital assigned diagnosis code abstracted from NICU discharge summary. (Corresponds w/ICD 9 #3). ',NULL,'Hospital assigned diagnosis code abstracted from NICU discharge summary. (Corresponds w/ICD 9 #3). ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'ICD 9 #4','ICD 9 #4','Hospital assigned diagnosis code abstracted from NICU discharge summary. (Corresponds w/ICD 9 #4). NOTE: LIMITED NUMERIC VALUES ENTERED, REFER TO EHR FOR ADDTL INFO.',NULL,'Hospital assigned diagnosis code abstracted from NICU discharge summary. (Corresponds w/ICD 9 #4). NOTE: LIMITED NUMERIC VALUES ENTERED, REFER TO EHR FOR ADDTL INFO.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'ICD 9 #5','ICD 9 #5','Hospital assigned diagnosis code abstracted from NICU discharge summary. (Corresponds w/ICD 9 #5). NOTE: LIMITED NUMERIC VALUES ENTERED, REFER TO EHR FOR ADDTL INFO.',NULL,'Hospital assigned diagnosis code abstracted from NICU discharge summary. (Corresponds w/ICD 9 #5). NOTE: LIMITED NUMERIC VALUES ENTERED, REFER TO EHR FOR ADDTL INFO.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'ICD 9 #6','ICD 9 #6','Hospital assigned diagnosis code abstracted from NICU discharge summary. (Corresponds w/ICD 9 #6). NOTE: LIMITED NUMERIC VALUES ENTERED, REFER TO EHR FOR ADDTL INFO.',NULL,'Hospital assigned diagnosis code abstracted from NICU discharge summary. (Corresponds w/ICD 9 #6). NOTE: LIMITED NUMERIC VALUES ENTERED, REFER TO EHR FOR ADDTL INFO.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'ICD 9 #7','ICD 9 #7','Hospital assigned diagnosis code abstracted from NICU discharge summary. (Corresponds w/ICD 9 #7). NOTE: LIMITED NUMERIC VALUES ENTERED, REFER TO EHR FOR ADDTL INFO.',NULL,'Hospital assigned diagnosis code abstracted from NICU discharge summary. (Corresponds w/ICD 9 #7). NOTE: LIMITED NUMERIC VALUES ENTERED, REFER TO EHR FOR ADDTL INFO.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'ICD 9 #8','ICD 9 #8','Hospital assigned diagnosis code abstracted from NICU discharge summary. (Corresponds w/ICD 9 #8). NOTE: LIMITED NUMERIC VALUES ENTERED, REFER TO EHR FOR ADDTL INFO.',NULL,'Hospital assigned diagnosis code abstracted from NICU discharge summary. (Corresponds w/ICD 9 #8). NOTE: LIMITED NUMERIC VALUES ENTERED, REFER TO EHR FOR ADDTL INFO.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'ICD 9 #9','ICD 9 #9','Hospital assigned diagnosis code abstracted from NICU discharge summary. (Corresponds w/ICD 9 #9). NOTE: LIMITED NUMERIC VALUES ENTERED, REFER TO EHR FOR ADDTL INFO.',NULL,'Hospital assigned diagnosis code abstracted from NICU discharge summary. (Corresponds w/ICD 9 #9). NOTE: LIMITED NUMERIC VALUES ENTERED, REFER TO EHR FOR ADDTL INFO.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Infant Admitted to NICU','Infant Admitted to NICU','Newborn admitted to Neonatal Intensive Care Unit (NICU).',NULL,'Newborn admitted to Neonatal Intensive Care Unit (NICU).','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Infant Birth Location','Infant Birth Location','Name of hospital if newborn born outside of Inova Fairfax Hospital',NULL,'Name of hospital if newborn born outside of Inova Fairfax Hospital','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Infant Congenital Anomaly Type','Infant Congenital Anomaly Type','Type of congenital anomaly (as defined in Line 47). ',NULL,'Type of congenital anomaly (as defined in Line 47). ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Infant Congenital Heart Defect/Disease Type','Infant Congenital Heart Defect/Disease Type','Diagnosed with congenital heart defect (as defined in Line 48-the type of cardiac defined is further defined as simple or complex according to standard). Simple=ASD, VSD, PFO, PDA, etc. Complex=HLHS, TOF, AV canal, TGA, etc.',NULL,'Diagnosed with congenital heart defect (as defined in Line 48-the type of cardiac defined is further defined as simple or complex according to standard). Simple=ASD, VSD, PFO, PDA, etc. Complex=HLHS, TOF, AV canal, TGA, etc.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Infant Diagnosis with Congenital Anomaly','Infant Diagnosis with Congenital Anomaly','Diagnosed with congenital anomaly (condition present at the time of birth which varies from the standard presentation). ',NULL,'Diagnosed with congenital anomaly (condition present at the time of birth which varies from the standard presentation). ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Infant diagnosis with Congenital Heart Defect/Disease','Infant diagnosis with Congenital Heart Defect/Disease','Diagnosed with congenital heart defect (defect in the structure of the heart and great vessels which is present at birth). ',NULL,'Diagnosed with congenital heart defect (defect in the structure of the heart and great vessels which is present at birth). ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Infant Diagnosis with Gastrointestinal issues','Infant Diagnosis with Gastrointestinal issues','Diagnosed with gastrointestinal issue.',NULL,'Diagnosed with gastrointestinal issue.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Infant diagnosis with Respiratory Distress Syndrome','Infant diagnosis with Respiratory Distress Syndrome','Diagnosed with breathing disorder that affects newborns. ',NULL,'Diagnosed with breathing disorder that affects newborns. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Infant Diagnosis with Retinopathy of Prematurity','Infant Diagnosis with Retinopathy of Prematurity','Diagnosed with disorder of the blood vessels of the retina.',NULL,'Diagnosed with disorder of the blood vessels of the retina.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Infant Discharged with','Infant Discharged with','Newborn discharged with technology support to include oxygen therapy, cardiac monitor, other',NULL,'Newborn discharged with technology support to include oxygen therapy, cardiac monitor, other','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Infant Gastrointestinal Acquired Type','Infant Gastrointestinal Acquired Type','If iatrogenic example necrotizing intercolitis or GI peforation',NULL,'If iatrogenic example necrotizing intercolitis or GI peforation','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Infant Gastrointestinal Type','Infant Gastrointestinal Type','Diagnosed with congenital malformation of the GI tract',NULL,'Diagnosed with congenital malformation of the GI tract','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Infant have Hypoxic-Ischemic Encephalopathy','Infant have Hypoxic-Ischemic Encephalopathy','Diagnosed with HIE (condition when the brain is deprived of oxygen and blood).',NULL,'Diagnosed with HIE (condition when the brain is deprived of oxygen and blood).','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Infant have Meconium Aspiration','Infant have Meconium Aspiration','Aspiration that occurs when a baby breathes in amniotic fluid.',NULL,'Aspiration that occurs when a baby breathes in amniotic fluid.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Infant have Periventricular-Intraventricular Hemorrhage','Infant have Periventricular-Intraventricular Hemorrhage','Associated with 11 (Cranial Imaging) separate scoring periventricular-intraventricular hemorrhage.',NULL,'Associated with 11 (Cranial Imaging) separate scoring periventricular-intraventricular hemorrhage.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Infant have Pneumothorax','Infant have Pneumothorax','Diagnosed with accumulation of air or gas in the pleural cavity. ',NULL,'Diagnosed with accumulation of air or gas in the pleural cavity. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Infant Length of Stay in Hospital Days','Infant Length of Stay in Hospital Days','Calculated by subtracting day of admission from day of discharge.',NULL,'Calculated by subtracting day of admission from day of discharge.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Infant Length of Stay in Hospital Hours','Infant Length of Stay in Hospital Hours','0',NULL,'0','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Infant receive Blood Products','Infant receive Blood Products','Newborn received blood products (including PRBCs, Platelets, Other).',NULL,'Newborn received blood products (including PRBCs, Platelets, Other).','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Infant receive Respiratory Support','Infant receive Respiratory Support','Newborn received respiratory or oxygen support.',NULL,'Newborn received respiratory or oxygen support.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Infant received Surfactant Treatment','Infant received Surfactant Treatment','Newborn received surfactant therapy (intrapulmonary). ',NULL,'Newborn received surfactant therapy (intrapulmonary). ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Infant Respiratory Support Start Date','Infant Respiratory Support Start Date','Date newborn resceived respiratory support',NULL,'Date newborn resceived respiratory support','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Infant Respiratory Support Type','Infant Respiratory Support Type','Type of respiratory support newborn received.  ',NULL,'Type of respiratory support newborn received.  ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Infant Seizures','Infant Seizures','Newborn diagnosed with seizure activity.',NULL,'Newborn diagnosed with seizure activity.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Infant Status at Time of Discharge','Infant Status at Time of Discharge','Newborn status at time of discharge',NULL,'Newborn status at time of discharge','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Infant Surfactant Treatment firsts dose date','Infant Surfactant Treatment firsts dose date','Date newborn received first surfactant treatment',NULL,'Date newborn received first surfactant treatment','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Infants Apgar Score 1 Minute','Infants Apgar Score 1 Minute','Newborns apgar score (system of assessing the general physicial condition of a newborn based on a rating of 0,1,2) at one minute.',NULL,'Newborns apgar score (system of assessing the general physicial condition of a newborn based on a rating of 0,1,2) at one minute.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Infants Apgar Score 5 Minute','Infants Apgar Score 5 Minute','Newborns apgar score (system of assessing the general physicial condition of a newborn based on a rating of 0,1,2) at five minutes.',NULL,'Newborns apgar score (system of assessing the general physicial condition of a newborn based on a rating of 0,1,2) at five minutes.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Infants Birth Location','Infants Birth Location','Location of newborns birth',NULL,'Location of newborns birth','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Infants Discharge Head Circumference','Infants Discharge Head Circumference','Newborns last head circumference documented prior to discharge',NULL,'Newborns last head circumference documented prior to discharge','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Infants Discharge Weight Grams','Infants Discharge Weight Grams','Newborns weight in grams at the time of discharge (Can be pre-calculated).',NULL,'Newborns weight in grams at the time of discharge (Can be pre-calculated).','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Infants Discharge Weight Ounces','Infants Discharge Weight Ounces','Newborns weight in ounces at the time of discharge (Can be pre-calculated).',NULL,'Newborns weight in ounces at the time of discharge (Can be pre-calculated).','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Infants Discharge Weight Pounds','Infants Discharge Weight Pounds','Newborns weight in pounds at the time of discharge (Can be pre-calculated).',NULL,'Newborns weight in pounds at the time of discharge (Can be pre-calculated).','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Infants First Feeding','Infants First Feeding','Newborns first documented delivery of enteral feeding (not to include sweeteze or sham feedings/oral stimulation).',NULL,'Newborns first documented delivery of enteral feeding (not to include sweeteze or sham feedings/oral stimulation).','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Infants Gender','Infants Gender','Newborns gender.',NULL,'Newborns gender.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Infants Main Food Source at Hospital','Infants Main Food Source at Hospital','Newborns main food source during hospital admission. ',NULL,'Newborns main food source during hospital admission. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Infants Mode of Delivery','Infants Mode of Delivery','Newborns mode of delivery.',NULL,'Newborns mode of delivery.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Item Type','Item Type','0',NULL,'0','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Path','Path','0',NULL,'0','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Receive Initial Resuscitation','Receive Initial Resuscitation','Newborn received resuscitation efforts.',NULL,'Newborn received resuscitation efforts.','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Resuscitation Type','Resuscitation Type','Type of intial resuscitation newborn received. ',NULL,'Type of intial resuscitation newborn received. ','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Created','Created','COMPUTER ASSIGNED',NULL,'COMPUTER ASSIGNED','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'Modified','Modified','COMPUTER ASSIGNED',NULL,'COMPUTER ASSIGNED','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'ID','ID','COMPUTER ASSIGNED',NULL,'COMPUTER ASSIGNED','','6',GETDATE(),'usp_Study101Crf',NULL UNION
	SELECT 30,'ItemID','ItemID','COMPUTER ASSIGNED',NULL,'COMPUTER ASSIGNED','','6',GETDATE(),'usp_Study101Crf',NULL

--tblCrfFieldOptions

INSERT INTO itmidw.[tblCrfFieldOptions]
           (
           [crfVersionID]
           ,[sourceSystemCrfVersionID]
           ,[fieldID]
           ,[optionLabel]
           ,[optionValue]
           ,[orgSourceSystemID]
           ,[createDate]
           ,[createdBy])
SELECT 
           --,<crfVersionID, int,>
		dd.crfVersionID
           --,<sourceSystemCrfVersionID, int,>
		,dd.crfVersionID
           --,<fieldID, int,>
		,f.fieldID
           --,<optionLabel, varchar(200),>
		, crfa.fieldValue
           --,<optionValue, varchar(200),>
        , NULL AS codedData
        , (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'INFOPATH') AS [orgSourceSystemID]
		, GETDATE() [createDate]
		, 'usp_Study101Crf' AS [createdBy]
FROM itmidw.tblCrfEventAnswers crfA
	INNER JOIN itmidw.tblCrfDataDictionary dd
		on dd.crfDataDictionaryID = crfA.crfDataDictionaryID
	INNER JOIN itmidw.tblCrfFields f
		ON f.fieldID =dd.fieldID
where crfA.orgSourceSystemID = (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'INFOPATH')
	and ISNULL(crfa.fieldValue,'') <> ''
	and f.fieldName NOT LIKE '%date%'
	and f.fieldName NOT IN 
		('BMI','Cervical Cerclage Procedure Date ','Cranial Imaging Date','Date and Time of Delivery ','Date of Admission '
		,'Date of Birth', 'Date of Diagnosis of Cancer', 'Date of Discharge ','Date of First Transfusion','Family Study ID'
		,'Fathers Study ID','Height Inches ','ICD 9 #1','ICD 9 #10', 'ICD 9 #2'
		,'ICD 9 #3','ICD 9 #4'	,'ICD 9 #5','ICD 9 #6','ICD 9 #7','ICD 9 #8','ICD 9 #9','Infants Apgar Score 5 Minute'
		,'Infants Discharge Head Circumference'',Infants Discharge Weight Grams','Infants First Feeding','Infants Discharge Weight Pounds'
		,'Infants Discharge Weight Ounces','Infants First Feeding',	'Infants Study ID', 'Mothers Study ID '
		,'Pre-Pregnancy Height Inches ','Pre-Pregnancy Weight ','Pre-Pregnancy Weight Grams ','Submitted ','Weight '
		,'Weight Grams ','Zip Code of Residence','Years Drinking', 'Years Smoking')
GROUP BY 
	dd.crfVersionID
	,dd.crfVersionID
	,f.fieldID
	,crfa.fieldValue

*/
END
