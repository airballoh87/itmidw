IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ITMIdw].[usp_Study102Crf]') AND type in (N'P', N'PC'))
DROP PROCEDURE ITMIDW.[usp_Study102Crf]

GO
/**************************************************************************
Created On : 3/29/2014
Created By : Aaron Black
Team Name : Informatics
Object name : [usp_Study102Crf]
Functional : ITMI SSIS for Insert and Update for study 102 tblCrf, tblcrfType, tblCrfVersion, tblcrfmap, tblcrfFields
 Clinical report forms that were entered into DIFZ
History : Created on 3/29/2014
**************************************************************************
Date Modified By QC# Purposes
**************************************************************************
#Date #Comment
**************************************************************************
USE CASE:
EXEC [usp_Study102Crf]

**************************************************************************/
CREATE PROCEDURE ITMIDW.[usp_Study102Crf]
AS
BEGIN
SET NOCOUNT ON;
DECLARE @UpdatedOn SMALLDATETIME
SET @UpdatedOn = CAST(GETDATE() AS SMALLDATETIME)
PRINT CONVERT(CHAR(23), @UpdatedOn, 121) + ' [usp_Study102Crf][' + @@SERVERNAME + '][' + SYSTEM_USER + ']'
PRINT 'INSERT [ITMIDW].ITMIDW.[dbo].[usp_Study102Crf]...'


--*************************************
--******************102 tblCrfType*****
--*************************************
/* --not running unless additional forms are added, then add manual insert

INSERT INTO ITMIDW.[dbo].[tblCrfType](crfTypeCode, [crfTypeID],[crfTypeName])
SELECT 'ENROLL',	1,	'Enrollment' UNION
SELECT 'NB',	2,	'Infant Birth' UNION
SELECT 'NB2',	3,	'Infant Conditions' UNION
SELECT 'FU',	4,	'Follow Up' UNION
SELECT 'IC',	5,	'Informed Consent' UNION
SELECT 'LD',	6,	'Mother Labor and Delivery' UNION
SELECT 'OS',	7,	'Off Study' UNION
SELECT 'PFMC',	8,	'Pertinent Family Member Contact' UNION
SELECT 'TRIOC',9,	'Trio Contact' UNION
SELECT 'WD',	10,	'Withdrawal' UNION
SELECT 'SC',	11,	'Mother and Infant Specimen Collection' UNION
SELECT 'SC2',	12,	'Specimen Collection' UNION
SELECT 'EC',	13,	'Events Comments' UNION
SELECT 'PG',	14,	'Pregnancy' UNION
SELECT 'MHDM',	15,	'Mother Demographics' UNION
SELECT 'MHMH1',	16,	'Medical History' UNION
SELECT 'MHMH2',	17,	'Mother Medical History' UNION
SELECT 'CM',	18,	'Concomitant Medications' UNION
SELECT 'SP',	19,	'Surgical Procedures' UNION
SELECT 'MHMH3',20,	'Medical History (Continued)' UNION
SELECT 'MHSH',	21,	'Mother Social History' UNION
SELECT 'MHFH',	22,	'Mother Family History' UNION
SELECT 'MHLE',	23,	'Mother Life Events Evaluation' UNION
SELECT 'MHSS',	24,	'Mother Socio-Economic Status' UNION
SELECT 'FP',	25,	'Father Questionnaire' UNION
SELECT 'PF',	26,	'Pertinent Family Member Questionnaire' UNION
SELECT 'MED',	27,	'Father and Pertinent Family Member Medical History'

INSERT INTO ITMIDW.[dbo].[tblCrfType](crfTypeCode, [crfTypeID],[crfTypeName])
SELECT '6MonthBaby',	31,	'6 Month Survery for Baby'  UNION
SELECT '6MonthMom',	32,	'6 Month Survery for Mom'  UNION
SELECT '12MonthBaby',	33,	'12 Month Survery for Baby'  UNION
SELECT '12MonthMom',	34,	'12 Month Survery for Mom'  UNION
SELECT '18MonthBaby',	35,	'18 Month Survery for Baby'  UNION
SELECT '18MonthMom',	36,	'18 Month Survery for Mom'  UNION
SELECT '24MonthBaby',	37,	'24 Month Survery for Baby'  UNION
SELECT '24MonthMom',	38,	'24 Month Survery for Mom'  
--*************************************
--*****102 tblCrfSourcSytemMap*********
--*************************************

INSERT INTO ITMIDW.[dbo].[tblCrfSourceSystemMap]([sourceSystemMapID],SourceSystemCrfLabel, [crfID], [sourceSystemID])
SELECT 1,'ENROLL',	1,	3 UNION
SELECT 2,'NB',	2,	3 UNION
SELECT 3,'NB2',	3,	3 UNION
SELECT 4,'FU',	4,	3 UNION
SELECT 5,'IC',	5,	3 UNION
SELECT 6,'LD',	6,	3 UNION
SELECT 7,'OS',	7,	3 UNION
SELECT 8,'PFMC',	8,	3 UNION
SELECT 9,'TRIOC',9,	3 UNION
SELECT 10,'WD',	10,	3 UNION
SELECT 11,'SC',	11,	3 UNION
SELECT 12,'SC2',	12,	3 UNION
SELECT 13,'EC',	13,	3 UNION
SELECT 14,'PG',	14,	3 UNION
SELECT 15,'MHDM',	15,	3 UNION
SELECT 16,'MHMH1',	16,	3 UNION
SELECT 17,'MHMH2',	17,	3 UNION
SELECT 18,'CM',	18,	3 UNION
SELECT 19,'SP',	19,	3 UNION
SELECT 20,'MHMH3',20,	3 UNION
SELECT 21,'MHSH',	21,	3 UNION
SELECT 22,'MHFH',	22,	3 UNION
SELECT 23,'MHLE',	23,	3 UNION
SELECT 24,'MHSS',	24,	3 UNION
SELECT 25,'FP',	25,	3 UNION
SELECT 26,'PF',	26,	3 UNION
SELECT 27,'MED',	27,	3
--select * FROM ITMIDW.[dbo].[tblCrfSourceSystemMap]
INSERT INTO ITMIDW.[dbo].[tblCrfSourceSystemMap]([sourceSystemMapID],SourceSystemCrfLabel, [crfID], [sourceSystemID])
SELECT 31,'6MonthBaby',	31,	3 UNION
SELECT 32,'6MonthMom',	32,	3 UNION
SELECT 33,'12MonthBaby',33,	3 UNION
SELECT 34,'12MonthMom',	34,	3 UNION
SELECT 35,'18MonthBaby',35,	3 UNION
SELECT 36,'18MonthMom',	36,	3 UNION
SELECT 37,'24MonthBaby',37,	3 UNION
SELECT 38,'24MonthMom',	38,	3 
--*************************************
--******************102 tblCrf*********
--*************************************
--need surveys
INSERT INTO ITMIDW.[dbo].[tblCrf]([sourceSystemCrfID],[crfShortName],[crfTypeID],[crfName],[sourceSystemID],[orgSourceSystemID],[createDate],[createdBy])
SELECT 1, 'ENROLL',1, 'Rave: Enrollment: 101', 3, 3,GETDATE(), 'TSQL Import: adb' UNION
SELECT 2, 'NB',2, 'Rave: Infant Birth: 101', 3, 3,GETDATE(), 'TSQL Import: adb' UNION
SELECT 3, 'NB2',3, 'Rave: Infant Conditions: 101', 3,3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 4, 'FU',4, 'Rave: Follow Up: 101', 3,3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 5, 'IC',5, 'Rave: Informed Consent: 101', 3,3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 6, 'LD',6, 'Rave: Mother Labor and Delivery: 101', 3,3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 7, 'OS',7, 'Rave: Off Study: 101', 3,3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 8, 'PFMC',8, 'Rave: Pertinent Family Member Contact: 101', 3,3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 9, 'TRIOC',9, 'Rave: Trio Contact: 101', 3,3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 10, 'WD',10, 'Rave: Withdrawl: 101', 3,3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 11, 'SC',11, 'Rave: Mother and Infant Specimen Collection: 101', 3,3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 12, 'SC2',12, 'Rave: Specimen Collection: 101', 3,3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 13, 'EC',13, 'Rave: Events Comment: 101', 3,3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 14, 'PG',14, 'Rave: Pregnancy: 101', 3,3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 15, 'MHDM',15, 'Rave: Mother Demographics: 101', 3,3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 16, 'MHMH1',16, 'Rave: Medical History: 101', 3,3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 17, 'MHMH1',17, 'Rave: Mother Medical History: 101', 3,3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 18, 'CM',18, 'Rave: Concomitant Medications: 101', 3,3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 19, 'SP',19, 'Rave: Surgical Procedures: 101', 3,3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 20, 'MHMH3',20, 'Rave: Medical History (Continued): 101', 3,3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 21, 'MHSH',21, 'Rave: Mother Social History: 101', 3,3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 22, 'MHFH',22, 'Rave: Mother Family History: 101', 3,3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 23, 'MHLE',23, 'Rave: Mother Life Events Evaluation: 101', 3,3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 24, 'MHSS',24, 'Rave: Mother Socio-Economic Status: 101', 3,3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 25, 'FP',25, 'Rave: Father Questionnaire: 101', 3,3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 26, 'PF',26, 'Rave: Pertinent Family Member Questionnaire: 101', 3,3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 27, 'MED',27, 'Rave: Father and Pertinent Family Member Medical History: 101', 3,3, GETDATE(), 'TSQL Import: adb'
 
 INSERT INTO ITMIDW.[dbo].[tblCrf]([sourceSystemCrfID],[crfShortName],[crfTypeID],[crfName],[sourceSystemID],[orgSourceSystemID],[createDate],[createdBy])
 SELECT  
 crftype.crftypeID, crftype.CrfTypeName, crftype.CrfTypeID, 'Rave: '+crftype.CrfTypeName + ' :102', 3,3,getdate(),  'TSQL Import: adb'
 FROM ITMIDW.[dbo].[tblCrfType] crftype	
	LEFT JOIN ITMIDW.dbo.tblCrf crf
		on crf.sourceSystemCrfID = crftype.crfTypeID
WHERE crf.crfID is NULL

 

--*************************************
--******************102 tblCrfVersion**
--*************************************
INSERT INTO ITMIDW.[dbo].[tblCrfVersion]([sourceSystemCrfVersionID],[sourceSystemVersionID],[crfID],[crfVersionName],[orgSourceSystemID],[createDate],[createdBy])
SELECT 1,1,1, 'ENROLL: v1' , 3,GETDATE(), 'TSQL Import: adb' UNION
SELECT 2,2,2, 'NB: v1', 3,GETDATE(), 'TSQL Import: adb' UNION
SELECT 3,3,3, 'NB2: v1',3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 4,4,4, 'FU: v1',3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 5,5,5, 'IC: v1',3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 6,6,6, 'LD: v1',3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 7,7,7, 'OS: v1',3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 8,8,8, 'PFMC: v1',3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 9,9,9, 'TRIOC: v1',3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 10,10,10, 'WD: v1',3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 11,11,11, 'SC: v1',3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 12,12,12, 'SC2: v1',3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 13,13,13, 'EC: v1',3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 14,14,14, 'PG: v1',3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 15,15,15, 'MHDM: v1',3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 16,16,16, 'MHMH1: v1',3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 17,17,17, 'MHMH1: v1',3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 18,18,18, 'CM: v1',3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 19,19,19, 'SP: v1',3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 20,20,20, 'MHMH3: v1',3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 21,21,21, 'MHSH: v1',3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 22,22,22, 'MHFH: v1',3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 23,23,23, 'MHLE: v1',3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 24,24,24, 'MHSS: v1',3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 25,25,25, 'FP: v1',3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 26,26,26, 'PF: v1',3, GETDATE(), 'TSQL Import: adb' UNION
SELECT 27,27,27, 'MED: v1',3, GETDATE(), 'TSQL Import: adb' 

INSERT INTO ITMIDW.[dbo].[tblCrfVersion]([sourceSystemCrfVersionID],[sourceSystemVersionID],[crfID],[crfVersionName],[orgSourceSystemID],[createDate],[createdBy])
SELECT crf.crfID, crf.crfID,crf.crfID, ct.crftypeCode + ': v1', 3,GETDATE(), 'TSQL Import: adb'
FROM ITMIDW.dbo.tblCrf crf
	INNER JOIN ITMIDW.dbo.tblCrfType ct
		on CT.crftypeID = crf.crftypeID
	LEFT JOIN ITMIDW.[dbo].[tblCrfVersion] ver
		on ver.sourceSystemCrfVersionID = crf.sourceSystemCrfID
WHERE ver.sourceSystemCrfVersionID IS NULL

--*************************************
--******************102 tblcrfFields***
--*************************************
INSERT INTO ITMIDW.[dbo].[tblCrfFields]([crfVersionID],[sourceSystemFieldID],[fieldName],[fieldDescription],[cdeID],[questionText],[dataType],[orgSourceSystemID],[createDate],[createdBy], crfSourceSystemFieldOrder)
SELECT NULL,'ENROLHD','ENROLHD','To enroll a new family please fill in the following informatiON and press Save.','ENROLL','To enroll a new family please fill in the following informatiON and press Save.','Text','3','11/29/2013','TSQL Import: adb','1' UNION
SELECT NULL,'ENBRTHDATM','ENBRTHDATM','Mother Date of Birth (mm/dd/yyyy):','ENROLL','Mother Date of Birth (mm/dd/yyyy):','DateTime','3','11/29/2013','TSQL Import: adb','2' UNION
SELECT NULL,'DER_AGEM','DER_AGEM','Mother''s Age','ENROLL','Mother''s Age','Text','3','11/29/2013','TSQL Import: adb','3' UNION
SELECT NULL,'ENLNAMEMO','ENLNAMEMO','Mother Last Name:','ENROLL','Mother Last Name:','Text','3','11/29/2013','TSQL Import: adb','4' UNION
SELECT NULL,'ENFNAMEMO','ENFNAMEMO','Mother First Name:','ENROLL','Mother First Name:','Text','3','11/29/2013','TSQL Import: adb','5' UNION
SELECT NULL,'ENMET','ENMET','Eligibility Met:','ENROLL','Eligibility Met:','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','6' UNION
SELECT NULL,'ENICDATMO','ENICDATMO','Mother Date of Informed Consent (mm/dd/yyyy):','ENROLL','Mother Date of Informed Consent (mm/dd/yyyy):','DateTime','3','11/29/2013','TSQL Import: adb','7' UNION
SELECT NULL,'ENEDDDAT','ENEDDDAT','Estimated Delivery Date:','ENROLL','Estimated Delivery Date:','DateTime','3','11/29/2013','TSQL Import: adb','8' UNION
SELECT NULL,'ENBRTHDATF','ENBRTHDATF','Father Date of Birth:','ENROLL','Father Date of Birth:','DateTime','3','11/29/2013','TSQL Import: adb','9' UNION
SELECT NULL,'DER_AGEF','DER_AGEF','Father''s Age','ENROLL','Father''s Age','Text','3','11/29/2013','TSQL Import: adb','10' UNION
SELECT NULL,'ENLNAMEF','ENLNAMEF','Father Last Name:','ENROLL','Father Last Name:','Text','3','11/29/2013','TSQL Import: adb','11' UNION
SELECT NULL,'ENFNAMEF','ENFNAMEF','Father First Name:','ENROLL','Father First Name:','Text','3','11/29/2013','TSQL Import: adb','12' UNION
SELECT NULL,'SUBJID','SUBJID','Family Number:','ENROLL','Family Number:','Text','3','11/29/2013','TSQL Import: adb','13' UNION
SELECT NULL,'SUBJSTAT','SUBJSTAT','Family Status:','ENROLL','Family Status:','DropDownList','3','11/29/2013','TSQL Import: adb','14' UNION
SELECT NULL,'DER_SUBJID','DER_SUBJID','Derived Family Number:','ENROLL','Derived Family Number:','Text','3','11/29/2013','TSQL Import: adb','15' UNION
SELECT NULL,'NBBRTHDAT','NBBRTHDAT','Infants Date Of Birth (mm/dd/yyyy):','NB','Infants Date Of Birth (mm/dd/yyyy):','DateTime','3','11/29/2013','TSQL Import: adb','1' UNION
SELECT NULL,'NBBRTHTIM','NBBRTHTIM','Infants Time Of Birth:','NB','Infants Time Of Birth:','DateTime','3','11/29/2013','TSQL Import: adb','2' UNION
SELECT NULL,'DER_NBBRTH','DER_NBBRTH','Infants Birth Date/Time','NB','Infants Birth Date/Time','DateTime','3','11/29/2013','TSQL Import: adb','3' UNION
SELECT NULL,'NBDDAT','NBDDAT','Infants Date Of Discharge:','NB','Infants Date Of Discharge:','DateTime','3','11/29/2013','TSQL Import: adb','4' UNION
SELECT NULL,'NBDTIM','NBDTIM','Infants Time Of Discharge:','NB','Infants Time Of Discharge:','DateTime','3','11/29/2013','TSQL Import: adb','5' UNION
SELECT NULL,'DER_NBD','DER_NBD','Infants Discharge Date/Time','NB','Infants Discharge Date/Time','DateTime','3','11/29/2013','TSQL Import: adb','6' UNION
SELECT NULL,'NBHOSPTIME','NBHOSPTIME','Infants Length Of Stay In Hospital:','NB','Infants Length Of Stay In Hospital:','Text','3','11/29/2013','TSQL Import: adb','7' UNION
SELECT NULL,'NBBRTHWT_HD','NBBRTHWT_HD','Infant’s Birth Weight (Please enter weight in pounds AND ounces OR grams)','NB','Infant’s Birth Weight (Please enter weight in pounds AND ounces OR grams)','Text','3','11/29/2013','TSQL Import: adb','8' UNION
SELECT NULL,'NBBRTHWTLB','NBBRTHWTLB','Pounds (lb)','NB','Pounds (lb)','Text','3','11/29/2013','TSQL Import: adb','9' UNION
SELECT NULL,'NBBRTHWTOZ','NBBRTHWTOZ','Ounces (oz)','NB','Ounces (oz)','Text','3','11/29/2013','TSQL Import: adb','10' UNION
SELECT NULL,'NBBRTHWTGR','NBBRTHWTGR','<b>Grams (g)</b>','NB','<b>Grams (g)</b>','Text','3','11/29/2013','TSQL Import: adb','11' UNION
SELECT NULL,'NBBRTHWT','NBBRTHWT','Derived Weight (lb):','NB','Derived Weight (lb):','Text','3','11/29/2013','TSQL Import: adb','12' UNION
SELECT NULL,'NBBRTHDWT_HD','NBBRTHDWT_HD','Infant’s Weight At Time Of Discharge (Please enter weight in pounds AND ounces OR grams)','NB','Infant’s Weight At Time Of Discharge (Please enter weight in pounds AND ounces OR grams)','Text','3','11/29/2013','TSQL Import: adb','13' UNION
SELECT NULL,'NBBRTHWTDLB','NBBRTHWTDLB','Pounds (lb)','NB','Pounds (lb)','Text','3','11/29/2013','TSQL Import: adb','14' UNION
SELECT NULL,'NBBRTHWTDOZ','NBBRTHWTDOZ','Ounces (oz)','NB','Ounces (oz)','Text','3','11/29/2013','TSQL Import: adb','15' UNION
SELECT NULL,'NBBRTHWTDGR','NBBRTHWTDGR','<b>Grams (g)</b>','NB','<b>Grams (g)</b>','Text','3','11/29/2013','TSQL Import: adb','16' UNION
SELECT NULL,'NBBRTHWTD','NBBRTHWTD','Derived Weight (lb):','NB','Derived Weight (lb):','Text','3','11/29/2013','TSQL Import: adb','17' UNION
SELECT NULL,'NBGESTAGEWK','NBGESTAGEWK','Gestational Age (Weeks):','NB','Gestational Age (Weeks):','Text','3','11/29/2013','TSQL Import: adb','18' UNION
SELECT NULL,'NBGESTAGED','NBGESTAGED','Gestational Age (Days):','NB','Gestational Age (Days):','Text','3','11/29/2013','TSQL Import: adb','19' UNION
SELECT NULL,'NBCIRCIN','NBCIRCIN','Infants Head Circumference During Hospital Stay Or At Time Of Discharge:','NB','Infants Head Circumference During Hospital Stay Or At Time Of Discharge:','Text','3','11/29/2013','TSQL Import: adb','20' UNION
SELECT NULL,'NBCIRCUNK','NBCIRCUNK','Unknown:','NB','Unknown:','CheckBox','3','11/29/2013','TSQL Import: adb','21' UNION
SELECT NULL,'NBSEX','NBSEX','Infants Gender:','NB','Infants Gender:','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','22' UNION
SELECT NULL,'NBAPGARMIN1','NBAPGARMIN1','Infants Apgar Score (1 Minute):','NB','Infants Apgar Score (1 Minute):','Text','3','11/29/2013','TSQL Import: adb','23' UNION
SELECT NULL,'NBAPGARMIN5','NBAPGARMIN5','Infants Apgar Score (5 Minutes):','NB','Infants Apgar Score (5 Minutes):','Text','3','11/29/2013','TSQL Import: adb','24' UNION
SELECT NULL,'NBBIRTHLOC','NBBIRTHLOC','LocatiON Of Infants Birth:','NB','LocatiON Of Infants Birth:','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','25' UNION
SELECT NULL,'NBBIRTHLOCOTH','NBBIRTHLOCOTH','If Other, Please Specify:','NB','If Other, Please Specify:','Text','3','11/29/2013','TSQL Import: adb','26' UNION
SELECT NULL,'NBGCOUNSEL','NBGCOUNSEL','Genetic Counseling:','NB','Genetic Counseling:','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','27' UNION
SELECT NULL,'NBMETASCR','NBMETASCR','Metabolic Screening Results:','NB','Metabolic Screening Results:','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','28' UNION
SELECT NULL,'NBDISCSTATUS','NBDISCSTATUS','Infant Status At The Time Of Discharge:','NB','Infant Status At The Time Of Discharge:','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','29' UNION
SELECT NULL,'NBFULLTERM','NBFULLTERM','Was The Infant Born Full Term (> =  37 Wks)?','NB','Was The Infant Born Full Term (> =  37 Wks)?','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','30' UNION
SELECT NULL,'NBPRETERM','NBPRETERM','Was The Infant Born Prematurely (Less Than 37 Wks)?','NB','Was The Infant Born Prematurely (Less Than 37 Wks)?','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','31' UNION
SELECT NULL,'NBPRETERMRESULT_HD','NBPRETERMRESULT_HD','If Yes, Was The Initiating Event A Result Of? (check all that apply)','NB','If Yes, Was The Initiating Event A Result Of? (check all that apply)','Text','3','11/29/2013','TSQL Import: adb','32' UNION
SELECT NULL,'NBIEVPROM','NBIEVPROM','PROM:','NB','PROM:','CheckBox','3','11/29/2013','TSQL Import: adb','33' UNION
SELECT NULL,'NBIEVPTL','NBIEVPTL','PTL:','NB','PTL:','CheckBox','3','11/29/2013','TSQL Import: adb','34' UNION
SELECT NULL,'NBIEVINF','NBIEVINF','Infection:','NB','Infection:','CheckBox','3','11/29/2013','TSQL Import: adb','35' UNION
SELECT NULL,'NBIEVPREE','NBIEVPREE','Preclampsia, PIH, HELLP:','NB','Preclampsia, PIH, HELLP:','CheckBox','3','11/29/2013','TSQL Import: adb','36' UNION
SELECT NULL,'NBIEVDIAB','NBIEVDIAB','Diabetes:','NB','Diabetes:','CheckBox','3','11/29/2013','TSQL Import: adb','37' UNION
SELECT NULL,'NBIEVPLAC','NBIEVPLAC','Placenta (Abruption, Previa, Accreta):','NB','Placenta (Abruption, Previa, Accreta):','CheckBox','3','11/29/2013','TSQL Import: adb','38' UNION
SELECT NULL,'NBIEVSTRUC','NBIEVSTRUC','Structure (Uterus, Cervix):','NB','Structure (Uterus, Cervix):','CheckBox','3','11/29/2013','TSQL Import: adb','39' UNION
SELECT NULL,'NBIEVNB','NBIEVNB','Newborn (Iugr, Decels):','NB','Newborn (Iugr, Decels):','CheckBox','3','11/29/2013','TSQL Import: adb','40' UNION
SELECT NULL,'NBIEVOTH','NBIEVOTH','Other:','NB','Other:','CheckBox','3','11/29/2013','TSQL Import: adb','41' UNION
SELECT NULL,'NBIEVOTHSPEC','NBIEVOTHSPEC','Specify:','NB','Specify:','Text','3','11/29/2013','TSQL Import: adb','42' UNION
SELECT NULL,'NBIEVUNK','NBIEVUNK','Unknown:','NB','Unknown:','CheckBox','3','11/29/2013','TSQL Import: adb','43' UNION
SELECT NULL,'NBNICU','NBNICU','Was Infant Admitted To NICU?','NB','Was Infant Admitted To NICU?','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','44' UNION
SELECT NULL,'NBNICUADMDAT','NBNICUADMDAT','If Yes, Date Of Admission:','NB','If Yes, Date Of Admission:','DateTime','3','11/29/2013','TSQL Import: adb','45' UNION
SELECT NULL,'FMCODE','FMCODE','Family Member Suffix:','NB','Family Member Suffix:','Text','3','11/29/2013','TSQL Import: adb','46' UNION
SELECT NULL,'NBMEDCON','NBMEDCON','Did The Infant Have Any Of The Following Medical Conditions?','NB2','Did The Infant Have Any Of The Following Medical Conditions?','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','1' UNION
SELECT NULL,'NBINITRESUS','NBINITRESUS','Did The Infant Receive Initial Resuscitation?','NB2','Did The Infant Receive Initial Resuscitation?','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','2' UNION
SELECT NULL,'NBIRESUCITATE_HD','NBIRESUCITATE_HD','If Yes, Check All That Apply:','NB2','If Yes, Check All That Apply:','Text','3','11/29/2013','TSQL Import: adb','3' UNION
SELECT NULL,'NBIRESOX','NBIRESOX','Oxygen:','NB2','Oxygen:','CheckBox','3','11/29/2013','TSQL Import: adb','4' UNION
SELECT NULL,'NBIREPPM','NBIREPPM','Positive Pressure Mask:','NB2','Positive Pressure Mask:','CheckBox','3','11/29/2013','TSQL Import: adb','5' UNION
SELECT NULL,'NBIREINT','NBIREINT','Intubation/PPV:','NB2','Intubation/PPV:','CheckBox','3','11/29/2013','TSQL Import: adb','6' UNION
SELECT NULL,'NBIRETRAC','NBIRETRAC','Tracheal Suction:','NB2','Tracheal Suction:','CheckBox','3','11/29/2013','TSQL Import: adb','7' UNION
SELECT NULL,'NBIREDU','NBIREDU','Drug Use:','NB2','Drug Use:','CheckBox','3','11/29/2013','TSQL Import: adb','8' UNION
SELECT NULL,'NBIRECC','NBIRECC','Cardiac Compression:','NB2','Cardiac Compression:','CheckBox','3','11/29/2013','TSQL Import: adb','9' UNION
SELECT NULL,'NBPERIHEM','NBPERIHEM','Did The Infant Have Periventricular-Intraventricular Hemorrhage?','NB2','Did The Infant Have Periventricular-Intraventricular Hemorrhage?','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','10' UNION
SELECT NULL,'NBCIIMGDAT','NBCIIMGDAT','If Yes, Date Of Imaging (mm/dd/yyyy):','NB2','If Yes, Date Of Imaging (mm/dd/yyyy):','DateTime','3','11/29/2013','TSQL Import: adb','11' UNION
SELECT NULL,'NBCIGRADE','NBCIGRADE','If Yes, Indicate The Worst Grade:','NB2','If Yes, Indicate The Worst Grade:','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','12' UNION
SELECT NULL,'NBHIE','NBHIE','Did The Infant Have Hypoxic-Ischemic Encephalopathy?','NB2','Did The Infant Have Hypoxic-Ischemic Encephalopathy?','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','13' UNION
SELECT NULL,'NBSEIZ','NBSEIZ','Did The Infant Have Seizures?','NB2','Did The Infant Have Seizures?','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','14' UNION
SELECT NULL,'NBRP','NBRP','Was The Infant Diagnosised With Retinopathy Of Prematurity?','NB2','Was The Infant Diagnosised With Retinopathy Of Prematurity?','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','15' UNION
SELECT NULL,'NBRPTYPE','NBRPTYPE','If Yes, Type:','NB2','If Yes, Type:','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','16' UNION
SELECT NULL,'NBREPSUPP','NBREPSUPP','Did The Infant Receive Any Respiratory Support?','NB2','Did The Infant Receive Any Respiratory Support?','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','17' UNION
SELECT NULL,'NBRESPSUPPORTTYPE_HD','NBRESPSUPPORTTYPE_HD','If Yes, Type Of Respiratory Support:','NB2','If Yes, Type Of Respiratory Support:','Text','3','11/29/2013','TSQL Import: adb','18' UNION
SELECT NULL,'NBRSNO','NBRSNO','No:','NB2','No:','CheckBox','3','11/29/2013','TSQL Import: adb','19' UNION
SELECT NULL,'NBRSCV','NBRSCV','Con. Vent:','NB2','Con. Vent:','CheckBox','3','11/29/2013','TSQL Import: adb','20' UNION
SELECT NULL,'NBRSHV','NBRSHV','HiFi Vent:','NB2','HiFi Vent:','CheckBox','3','11/29/2013','TSQL Import: adb','21' UNION
SELECT NULL,'NBRSHFNC','NBRSHFNC','High Flow Nasal Cannula:','NB2','High Flow Nasal Cannula:','CheckBox','3','11/29/2013','TSQL Import: adb','22' UNION
SELECT NULL,'NBRSNC','NBRSNC','Nasal CPAP:','NB2','Nasal CPAP:','CheckBox','3','11/29/2013','TSQL Import: adb','23' UNION
SELECT NULL,'NBRSNOX','NBRSNOX','Nitric Oxide:','NB2','Nitric Oxide:','CheckBox','3','11/29/2013','TSQL Import: adb','24' UNION
SELECT NULL,'NBRSUNK','NBRSUNK','Unknown:','NB2','Unknown:','CheckBox','3','11/29/2013','TSQL Import: adb','25' UNION
SELECT NULL,'NBRESPSUPPORTDISCHRG_HD','NBRESPSUPPORTDISCHRG_HD','Was The Infant Discharged Home ON Any Of The Following:','NB2','Was The Infant Discharged Home ON Any Of The Following:','Text','3','11/29/2013','TSQL Import: adb','26' UNION
SELECT NULL,'NBRSDISCNO','NBRSDISCNO','No:','NB2','No:','CheckBox','3','11/29/2013','TSQL Import: adb','27' UNION
SELECT NULL,'NBRSDISCOT','NBRSDISCOT','Oxygen Therapy:','NB2','Oxygen Therapy:','CheckBox','3','11/29/2013','TSQL Import: adb','28' UNION
SELECT NULL,'NBRSDISCCRM','NBRSDISCCRM','Cardio-Respiratory Monitor:','NB2','Cardio-Respiratory Monitor:','CheckBox','3','11/29/2013','TSQL Import: adb','29' UNION
SELECT NULL,'NBRSDISCUNK','NBRSDISCUNK','Unknown:','NB2','Unknown:','CheckBox','3','11/29/2013','TSQL Import: adb','30' UNION
SELECT NULL,'NBRDSYN','NBRDSYN','Was The Infant Diagnosised With Respiratory Distress Syndrome?','NB2','Was The Infant Diagnosised With Respiratory Distress Syndrome?','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','31' UNION
SELECT NULL,'NBRDSYNSTRT','NBRDSYNSTRT','If Yes, Did The Infant Receive Surfactant Treatment?','NB2','If Yes, Did The Infant Receive Surfactant Treatment?','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','32' UNION
SELECT NULL,'RDFDDAT','RDFDDAT','Date Of First Dose:','NB2','Date Of First Dose:','DateTime','3','11/29/2013','TSQL Import: adb','33' UNION
SELECT NULL,'NBPNEUMO','NBPNEUMO','Did The Infant Have A Pneumothorax?','NB2','Did The Infant Have A Pneumothorax?','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','34' UNION
SELECT NULL,'NBCONGHRT','NBCONGHRT','Was The Infant Diagnosised With A Congenital Heart Defect/Disease?','NB2','Was The Infant Diagnosised With A Congenital Heart Defect/Disease?','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','35' UNION
SELECT NULL,'NBCONGHRTY','NBCONGHRTY','If Yes, Type:','NB2','If Yes, Type:','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','36' UNION
SELECT NULL,'NBCONGHRTTRT','NBCONGHRTTRT','If Simple, Did Infant Receive Drug Treatment:','NB2','If Simple, Did Infant Receive Drug Treatment:','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','37' UNION
SELECT NULL,'NBCONGGAS','NBCONGGAS','Was The Infant Diagnosised With Any Type Of Congenital Gastrointestinal Issue?','NB2','Was The Infant Diagnosised With Any Type Of Congenital Gastrointestinal Issue?','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','38' UNION
SELECT NULL,'NBCONGANOM','NBCONGANOM','Was The Infant Diagnosised With A Congenital Anomaly?','NB2','Was The Infant Diagnosised With A Congenital Anomaly?','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','39' UNION
SELECT NULL,'NBFMCODE','NBFMCODE','Family Member Suffix:','NB2','Family Member Suffix:','Text','3','11/29/2013','TSQL Import: adb','40' UNION
SELECT NULL,'FU_HD','FU_HD','Using log lines below, enter follow up dates.','FU','Using log lines below, enter follow up dates.','Text','3','11/29/2013','TSQL Import: adb','1' UNION
SELECT NULL,'FUTYPE','FUTYPE','Follow Up Type:','FU','Follow Up Type:','DropDownList','3','11/29/2013','TSQL Import: adb','2' UNION
SELECT NULL,'FUDAT','FUDAT','Date (mm/dd/yyyy):','FU','Date (mm/dd/yyyy):','DateTime','3','11/29/2013','TSQL Import: adb','3' UNION
SELECT NULL,'FUSENREC','FUSENREC','Sent/Received:','FU','Sent/Received:','DropDownList','3','11/29/2013','TSQL Import: adb','4' UNION
SELECT NULL,'FULOST','FULOST','Lost to follow up?','FU','Lost to follow up?','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','5' UNION
SELECT NULL,'FULOSTDAT','FULOSTDAT','Date lost to follow up:','FU','Date lost to follow up:','DateTime','3','11/29/2013','TSQL Import: adb','6' UNION
SELECT NULL,'FULOSTREAS','FULOSTREAS','Reasons lost to follow up:','FU','Reasons lost to follow up:','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','7' UNION
SELECT NULL,'NBFMCODE','NBFMCODE','Family Member Suffix:','FU','Family Member Suffix:','Text','3','11/29/2013','TSQL Import: adb','8' UNION
SELECT NULL,'ICDAT','ICDAT','Date of Informed Consent Signature (mm/dd/yyyy):','IC','Date of Informed Consent Signature (mm/dd/yyyy):','DateTime','3','11/29/2013','TSQL Import: adb','1' UNION
SELECT NULL,'ICMET','ICMET','Eligibility Met:','IC','Eligibility Met:','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','2' UNION
SELECT NULL,'NBFMCODE','NBFMCODE','Family Member Suffix:','IC','Family Member Suffix:','Text','3','11/29/2013','TSQL Import: adb','3' UNION
SELECT NULL,'HIDDEN_NOW','HIDDEN_NOW','Hidden','IC','Hidden','DateTime','3','11/29/2013','TSQL Import: adb','4' UNION
SELECT NULL,'LDADMINDAT','LDADMINDAT','Date Of AdmissiON (mm/dd/yyyy):','LD','Date Of AdmissiON (mm/dd/yyyy):','DateTime','3','11/29/2013','TSQL Import: adb','1' UNION
SELECT NULL,'LDADMINTIM','LDADMINTIM','Time Of Admission: (24 hour)','LD','Time Of Admission: (24 hour)','DateTime','3','11/29/2013','TSQL Import: adb','2' UNION
SELECT NULL,'LDDELDAT','LDDELDAT','Date Of Delivery:','LD','Date Of Delivery:','DateTime','3','11/29/2013','TSQL Import: adb','3' UNION
SELECT NULL,'LDDELTIM','LDDELTIM','Time Of Delivery:','LD','Time Of Delivery:','DateTime','3','11/29/2013','TSQL Import: adb','4' UNION
SELECT NULL,'LDDISCDAT','LDDISCDAT','Date Of Discharge:','LD','Date Of Discharge:','DateTime','3','11/29/2013','TSQL Import: adb','5' UNION
SELECT NULL,'LDDISCTIM','LDDISCTIM','Time Of Discharge:','LD','Time Of Discharge:','DateTime','3','11/29/2013','TSQL Import: adb','6' UNION
SELECT NULL,'LDADMISSIONREASON_HD','LDADMISSIONREASON_HD','ReasON For Admission/Chief Complaints (Please SELECT All That Apply):','LD','ReasON For Admission/Chief Complaints (Please SELECT All That Apply):','Text','3','11/29/2013','TSQL Import: adb','7' UNION
SELECT NULL,'LDARNONE','LDARNONE','None:','LD','None:','CheckBox','3','11/29/2013','TSQL Import: adb','8' UNION
SELECT NULL,'LDARRRM','LDARRRM','R/O Ruptured Membranes:','LD','R/O Ruptured Membranes:','CheckBox','3','11/29/2013','TSQL Import: adb','9' UNION
SELECT NULL,'LDARPRETERM','LDARPRETERM','Pre-Term Labor:','LD','Pre-Term Labor:','CheckBox','3','11/29/2013','TSQL Import: adb','10' UNION
SELECT NULL,'LDARBLEED','LDARBLEED','Bleeding FROM Vagina:','LD','Bleeding FROM Vagina:','CheckBox','3','11/29/2013','TSQL Import: adb','11' UNION
SELECT NULL,'LDARDFETAL','LDARDFETAL','Decreased Fetal Movement:','LD','Decreased Fetal Movement:','CheckBox','3','11/29/2013','TSQL Import: adb','12' UNION
SELECT NULL,'LDARPRCSEC','LDARPRCSEC','Previous C-SectiON - For Trial Of Labor:','LD','Previous C-SectiON - For Trial Of Labor:','CheckBox','3','11/29/2013','TSQL Import: adb','13' UNION
SELECT NULL,'LDARINDUC','LDARINDUC','Induction:','LD','Induction:','CheckBox','3','11/29/2013','TSQL Import: adb','14' UNION
SELECT NULL,'LDARPCSEC','LDARPCSEC','Primary C-Section:','LD','Primary C-Section:','CheckBox','3','11/29/2013','TSQL Import: adb','15' UNION
SELECT NULL,'LDARRCSEC','LDARRCSEC','Repeat C-Section:','LD','Repeat C-Section:','CheckBox','3','11/29/2013','TSQL Import: adb','16' UNION
SELECT NULL,'LDAROBS','LDAROBS','Observation:','LD','Observation:','CheckBox','3','11/29/2013','TSQL Import: adb','17' UNION
SELECT NULL,'LDARCST','LDARCST','CST (ContractiON Stress Test):','LD','CST (ContractiON Stress Test):','CheckBox','3','11/29/2013','TSQL Import: adb','18' UNION
SELECT NULL,'LDAROTH','LDAROTH','Other:','LD','Other:','CheckBox','3','11/29/2013','TSQL Import: adb','19' UNION
SELECT NULL,'LDAROTHSP','LDAROTHSP','If Other, please specify:','LD','If Other, please specify:','Text','3','11/29/2013','TSQL Import: adb','20' UNION
SELECT NULL,'LDARUNK','LDARUNK','Unknown:','LD','Unknown:','CheckBox','3','11/29/2013','TSQL Import: adb','21' UNION
SELECT NULL,'LDDELIVTYPE','LDDELIVTYPE','SELECT The Mothers Type Of Delivery:','LD','SELECT The Mothers Type Of Delivery:','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','22' UNION
SELECT NULL,'LDCSECTYPE','LDCSECTYPE','If C-Section, Type:','LD','If C-Section, Type:','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','23' UNION
SELECT NULL,'LDCSECSCHED','LDCSECSCHED','If C-Section, Schedule:','LD','If C-Section, Schedule:','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','24' UNION
SELECT NULL,'LDHISTDON','LDHISTDON','Was Histopathology Done ON The Placenta/Cord?','LD','Was Histopathology Done ON The Placenta/Cord?','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','25' UNION
SELECT NULL,'LDHISTRES_HD','LDHISTRES_HD','If Yes, Results:','LD','If Yes, Results:','Text','3','11/29/2013','TSQL Import: adb','26' UNION
SELECT NULL,'LDHISTRESNEG','LDHISTRESNEG','Negative:','LD','Negative:','CheckBox','3','11/29/2013','TSQL Import: adb','27' UNION
SELECT NULL,'LDHISTRESPD','LDHISTRESPD','Placental Disorders:','LD','Placental Disorders:','CheckBox','3','11/29/2013','TSQL Import: adb','28' UNION
SELECT NULL,'LDHISTRESDAFM','LDHISTRESDAFM','Disorders Of Amniotic Fluid And Membranes:','LD','Disorders Of Amniotic Fluid And Membranes:','CheckBox','3','11/29/2013','TSQL Import: adb','29' UNION
SELECT NULL,'LDHISTRESNPREG','LDHISTRESNPREG','Non-Pregnancy Organ Infection/Inflammation:','LD','Non-Pregnancy Organ Infection/Inflammation:','CheckBox','3','11/29/2013','TSQL Import: adb','30' UNION
SELECT NULL,'NBFMCODE','NBFMCODE','Family Member Suffix:','LD','Family Member Suffix:','Text','3','11/29/2013','TSQL Import: adb','31' UNION
SELECT NULL,'OSDAT','OSDAT','Date off study (mm/dd/yyyy):','OS','Date off study (mm/dd/yyyy):','DateTime','3','11/29/2013','TSQL Import: adb','1' UNION
SELECT NULL,'PLNAME','PLNAME','Last Name:','PFMC','Last Name:','Text','3','11/29/2013','TSQL Import: adb','1' UNION
SELECT NULL,'PFNAME','PFNAME','First Name:','PFMC','First Name:','Text','3','11/29/2013','TSQL Import: adb','2' UNION
SELECT NULL,'PBRTHDAT','PBRTHDAT','Date of Birth (mm/dd/yyyy):','PFMC','Date of Birth (mm/dd/yyyy):','DateTime','3','11/29/2013','TSQL Import: adb','3' UNION
SELECT NULL,'PSTREET','PSTREET','Street Address Line 1:','PFMC','Street Address Line 1:','Text','3','11/29/2013','TSQL Import: adb','4' UNION
SELECT NULL,'PSTREET2','PSTREET2','Street Address Line 2:','PFMC','Street Address Line 2:','Text','3','11/29/2013','TSQL Import: adb','5' UNION
SELECT NULL,'PCITY','PCITY','City:','PFMC','City:','Text','3','11/29/2013','TSQL Import: adb','6' UNION
SELECT NULL,'PST','PST','State:','PFMC','State:','SearchList','3','11/29/2013','TSQL Import: adb','7' UNION
SELECT NULL,'PZIP','PZIP','Zip Code:','PFMC','Zip Code:','Text','3','11/29/2013','TSQL Import: adb','8' UNION
SELECT NULL,'PPHONE','PPHONE','Phone Number:','PFMC','Phone Number:','Text','3','11/29/2013','TSQL Import: adb','9' UNION
SELECT NULL,'PEMAIL','PEMAIL','Email:','PFMC','Email:','Text','3','11/29/2013','TSQL Import: adb','10' UNION
SELECT NULL,'PFMREL','PFMREL','Family Member Relationship:','PFMC','Family Member Relationship:','DropDownList','3','11/29/2013','TSQL Import: adb','11' UNION
SELECT NULL,'NBFMCODE','NBFMCODE','Family Member Suffix:','PFMC','Family Member Suffix:','Text','3','11/29/2013','TSQL Import: adb','12' UNION
SELECT NULL,'CONTCTM_HD','CONTCTM_HD','<B>Mother Demographic</B>','TRIOC','<B>Mother Demographic</B>','Text','3','11/29/2013','TSQL Import: adb','1' UNION
SELECT NULL,'TCNAMEMO_HD','TCNAMEMO_HD','Mother Last Name:','TRIOC','Mother Last Name:','Text','3','11/29/2013','TSQL Import: adb','2' UNION
SELECT NULL,'TCFNAMEMO','TCFNAMEMO','Mother First Name:','TRIOC','Mother First Name:','Text','3','11/29/2013','TSQL Import: adb','3' UNION
SELECT NULL,'TCBRTHDATMO','TCBRTHDATMO','Mother Date of Birth (mm/dd/yyyy):','TRIOC','Mother Date of Birth (mm/dd/yyyy):','DateTime','3','11/29/2013','TSQL Import: adb','4' UNION
SELECT NULL,'TCEDDDAT','TCEDDDAT','Mother Estimated Delivery Date:','TRIOC','Mother Estimated Delivery Date:','DateTime','3','11/29/2013','TSQL Import: adb','5' UNION
SELECT NULL,'STREETMO','STREETMO','Mother Street Address Line 1:','TRIOC','Mother Street Address Line 1:','Text','3','11/29/2013','TSQL Import: adb','6' UNION
SELECT NULL,'STREETMO2','STREETMO2','Mother Street Address Line 2:','TRIOC','Mother Street Address Line 2:','Text','3','11/29/2013','TSQL Import: adb','7' UNION
SELECT NULL,'TCCITYMO','TCCITYMO','City:','TRIOC','City:','Text','3','11/29/2013','TSQL Import: adb','8' UNION
SELECT NULL,'TCSTMO','TCSTMO','State:','TRIOC','State:','DropDownList','3','11/29/2013','TSQL Import: adb','9' UNION
SELECT NULL,'TCZIPMO','TCZIPMO','Zip Code:','TRIOC','Zip Code:','Text','3','11/29/2013','TSQL Import: adb','10' UNION
SELECT NULL,'TCPHONEMO','TCPHONEMO','Phone Number:','TRIOC','Phone Number:','Text','3','11/29/2013','TSQL Import: adb','11' UNION
SELECT NULL,'TCEMAILMO','TCEMAILMO','Email:','TRIOC','Email:','Text','3','11/29/2013','TSQL Import: adb','12' UNION
SELECT NULL,'TCCONTCTF_HD','TCCONTCTF_HD','<B>Father Demographic</B>','TRIOC','<B>Father Demographic</B>','Text','3','11/29/2013','TSQL Import: adb','13' UNION
SELECT NULL,'TCLNAMEF','TCLNAMEF','Father Last Name:','TRIOC','Father Last Name:','Text','3','11/29/2013','TSQL Import: adb','14' UNION
SELECT NULL,'TCFNAMEF','TCFNAMEF','Father First Name:','TRIOC','Father First Name:','Text','3','11/29/2013','TSQL Import: adb','15' UNION
SELECT NULL,'TCBRTHDATF','TCBRTHDATF','Father Date of Birth:','TRIOC','Father Date of Birth:','DateTime','3','11/29/2013','TSQL Import: adb','16' UNION
SELECT NULL,'TCADDMFSAME','TCADDMFSAME','Father''s address same AS mother''s?','TRIOC','Father''s address same AS mother''s?','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','17' UNION
SELECT NULL,'TCADDRESSFNO_HD','TCADDRESSFNO_HD','If No, please enter father''s address.','TRIOC','If No, please enter father''s address.','Text','3','11/29/2013','TSQL Import: adb','18' UNION
SELECT NULL,'TCSTREETF','TCSTREETF','Father Street Address Line 1:','TRIOC','Father Street Address Line 1:','Text','3','11/29/2013','TSQL Import: adb','19' UNION
SELECT NULL,'TCSTREETF2','TCSTREETF2','Father Street Address Line 2:','TRIOC','Father Street Address Line 2:','Text','3','11/29/2013','TSQL Import: adb','20' UNION
SELECT NULL,'TCCITYF','TCCITYF','City:','TRIOC','City:','Text','3','11/29/2013','TSQL Import: adb','21' UNION
SELECT NULL,'TCSTF','TCSTF','State:','TRIOC','State:','SearchList','3','11/29/2013','TSQL Import: adb','22' UNION
SELECT NULL,'TCZIPF','TCZIPF','Zip Code:','TRIOC','Zip Code:','Text','3','11/29/2013','TSQL Import: adb','23' UNION
SELECT NULL,'TCPHONEF','TCPHONEF','Phone Number:','TRIOC','Phone Number:','Text','3','11/29/2013','TSQL Import: adb','24' UNION
SELECT NULL,'TCEMAILF','TCEMAILF','Email:','TRIOC','Email:','Text','3','11/29/2013','TSQL Import: adb','25' UNION
SELECT NULL,'CONTCTNB_HD','CONTCTNB_HD','<B>Newborn Demographic</B>','TRIOC','<B>Newborn Demographic</B>','Text','3','11/29/2013','TSQL Import: adb','26' UNION
SELECT NULL,'TCLNAMENB','TCLNAMENB','Newborn Last Name:','TRIOC','Newborn Last Name:','Text','3','11/29/2013','TSQL Import: adb','27' UNION
SELECT NULL,'TCFNAMENB','TCFNAMENB','Newborn First Name:','TRIOC','Newborn First Name:','Text','3','11/29/2013','TSQL Import: adb','28' UNION
SELECT NULL,'TCBRTHDATNB','TCBRTHDATNB','Newborn Date of Birth:','TRIOC','Newborn Date of Birth:','DateTime','3','11/29/2013','TSQL Import: adb','29' UNION
SELECT NULL,'WD_HEAD','WD_HEAD','Please enter date of withdrawal below.','WD','Please enter date of withdrawal below.','Text','3','11/29/2013','TSQL Import: adb','1' UNION
SELECT NULL,'WDDAT','WDDAT','Date of Withdrawal (mm/dd/yyyy):','WD','Date of Withdrawal (mm/dd/yyyy):','DateTime','3','11/29/2013','TSQL Import: adb','2' UNION
SELECT NULL,'WDREAS','WDREAS','ReasON for Withdrawal:','WD','ReasON for Withdrawal:','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','3' UNION
SELECT NULL,'WDOTH','WDOTH','Please Specify Reason:','WD','Please Specify Reason:','Text','3','11/29/2013','TSQL Import: adb','4' UNION
SELECT NULL,'NBFMCODE','NBFMCODE','Family Member Suffix:','WD','Family Member Suffix:','Text','3','11/29/2013','TSQL Import: adb','5' UNION
SELECT NULL,'NBFMCODE','NBFMCODE','Family Member Suffix:','SC','Family Member Suffix:','Text','3','11/29/2013','TSQL Import: adb','1' UNION
SELECT NULL,'SCCOMPLETEFORM_HD','SCCOMPLETEFORM_HD','Complete the following specimen collectiON information.','SC','Complete the following specimen collectiON information.','Text','3','11/29/2013','TSQL Import: adb','2' UNION
SELECT NULL,'SCEVTYPE','SCEVTYPE','Event Type:','SC','Event Type:','DropDownList','3','11/29/2013','TSQL Import: adb','3' UNION
SELECT NULL,'SCTYPB','SCTYPB','Blood:','SC','Blood:','CheckBox','3','11/29/2013','TSQL Import: adb','4' UNION
SELECT NULL,'SCTYPS','SCTYPS','Saliva:','SC','Saliva:','CheckBox','3','11/29/2013','TSQL Import: adb','5' UNION
SELECT NULL,'SCTYPU','SCTYPU','Urine:','SC','Urine:','CheckBox','3','11/29/2013','TSQL Import: adb','6' UNION
SELECT NULL,'SCTYPCB','SCTYPCB','Cord Blood:','SC','Cord Blood:','CheckBox','3','11/29/2013','TSQL Import: adb','7' UNION
SELECT NULL,'SCTYPP','SCTYPP','Placenta:','SC','Placenta:','CheckBox','3','11/29/2013','TSQL Import: adb','8' UNION
SELECT NULL,'SCDAT','SCDAT','Date (mm/dd/yyyy):','SC','Date (mm/dd/yyyy):','DateTime','3','11/29/2013','TSQL Import: adb','9' UNION
SELECT NULL,'SCMRN','SCMRN','Medical Record Number (MRN):','SC','Medical Record Number (MRN):','Text','3','11/29/2013','TSQL Import: adb','10' UNION
SELECT NULL,'SCBRTH','SCBRTH','Is this a multiple birth?','SC','Is this a multiple birth?','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','11' UNION
SELECT NULL,'SCMULTIBRTH','SCMULTIBRTH','If yes, how many?','SC','If yes, how many?','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','12' UNION
SELECT NULL,'MHHIDD','MHHIDD','Number of matrix added and removed:','SC','Number of matrix added and removed:','Text','3','11/29/2013','TSQL Import: adb','13' UNION
SELECT NULL,'NBFMCODE','NBFMCODE','Family Member Suffix:','SC2','Family Member Suffix:','Text','3','11/29/2013','TSQL Import: adb','1' UNION
SELECT NULL,'SC2COMPLETEFORM_HD','SC2COMPLETEFORM_HD','Complete the following specimen collectiON information.','SC2','Complete the following specimen collectiON information.','Text','3','11/29/2013','TSQL Import: adb','2' UNION
SELECT NULL,'SC2EVTYPE','SC2EVTYPE','Event Type:','SC2','Event Type:','DropDownList','3','11/29/2013','TSQL Import: adb','3' UNION
SELECT NULL,'SC2TYPB','SC2TYPB','Blood:','SC2','Blood:','CheckBox','3','11/29/2013','TSQL Import: adb','4' UNION
SELECT NULL,'SC2TYPS','SC2TYPS','Saliva:','SC2','Saliva:','CheckBox','3','11/29/2013','TSQL Import: adb','5' UNION
SELECT NULL,'SC2DAT','SC2DAT','Date (mm/dd/yyyy):','SC2','Date (mm/dd/yyyy):','DateTime','3','11/29/2013','TSQL Import: adb','6' UNION
SELECT NULL,'SC2MRN','SC2MRN','Medical Record Number (MRN):','SC2','Medical Record Number (MRN):','Text','3','11/29/2013','TSQL Import: adb','7' UNION
SELECT NULL,'ECOMMENTFORM_HD','ECOMMENTFORM_HD','Complete the following event comments.','EC','Complete the following event comments.','Text','3','11/29/2013','TSQL Import: adb','1' UNION
SELECT NULL,'ECTYPE','ECTYPE','Type:','EC','Type:','DropDownList','3','11/29/2013','TSQL Import: adb','2' UNION
SELECT NULL,'ECDAT','ECDAT','Event Date (mm/dd/yyyy):','EC','Event Date (mm/dd/yyyy):','DateTime','3','11/29/2013','TSQL Import: adb','3' UNION
SELECT NULL,'ECSITE','ECSITE','Location:','EC','Location:','DropDownList','3','11/29/2013','TSQL Import: adb','4' UNION
SELECT NULL,'ECSOTH','ECSOTH','Other, Location:','EC','Other, Location:','LongText','3','11/29/2013','TSQL Import: adb','5' UNION
SELECT NULL,'ECCOMM','ECCOMM','Comments:','EC','Comments:','LongText','3','11/29/2013','TSQL Import: adb','6' UNION
SELECT NULL,'NBFMCODE','NBFMCODE','Family Member Suffix:','EC','Family Member Suffix:','Text','3','11/29/2013','TSQL Import: adb','7' UNION
SELECT NULL,'PGCURRBIRTH_HD','PGCURRBIRTH_HD','<B>Current Birth</B>','PG','<B>Current Birth</B>','Text','3','11/29/2013','TSQL Import: adb','1' UNION
SELECT NULL,'PGEDIAG','PGEDIAG','Has Mother Been Diagnosed With Endometriosis?','PG','Has Mother Been Diagnosed With Endometriosis?','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','2' UNION
SELECT NULL,'PGEDIAGDAT','PGEDIAGDAT','If Yes, Date Of Diagnosis (mm/dd/yyyy):','PG','If Yes, Date Of Diagnosis (mm/dd/yyyy):','DateTime','3','11/29/2013','TSQL Import: adb','3' UNION
SELECT NULL,'PGEDIAGUNK','PGEDIAGUNK','Unknown:','PG','Unknown:','CheckBox','3','11/29/2013','TSQL Import: adb','4' UNION
SELECT NULL,'PGCERVC','PGCERVC','Has Mother Had A Cervical Cerclage?','PG','Has Mother Had A Cervical Cerclage?','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','5' UNION
SELECT NULL,'PGCERVCDAT','PGCERVCDAT','If Yes, Date Of Procedure:','PG','If Yes, Date Of Procedure:','DateTime','3','11/29/2013','TSQL Import: adb','6' UNION
SELECT NULL,'PGCERVCUNK','PGCERVCUNK','Unknown:','PG','Unknown:','CheckBox','3','11/29/2013','TSQL Import: adb','7' UNION
SELECT NULL,'PGPREGNANCY_HD','PGPREGNANCY_HD','<B>Pregnancy</B>','PG','<B>Pregnancy</B>','Text','3','11/29/2013','TSQL Import: adb','8' UNION
SELECT NULL,'PGOBHISTORY_HD','PGOBHISTORY_HD','OB History:','PG','OB History:','Text','3','11/29/2013','TSQL Import: adb','9' UNION
SELECT NULL,'PGOBHISTG','PGOBHISTG','Gravida:','PG','Gravida:','Text','3','11/29/2013','TSQL Import: adb','10' UNION
SELECT NULL,'PGOBHISTP','PGOBHISTP','Para:','PG','Para:','Text','3','11/29/2013','TSQL Import: adb','11' UNION
SELECT NULL,'PGOBHISTTERM','PGOBHISTTERM','Term:','PG','Term:','Text','3','11/29/2013','TSQL Import: adb','12' UNION
SELECT NULL,'PGOBHISTPTERM','PGOBHISTPTERM','Pre-Term:','PG','Pre-Term:','Text','3','11/29/2013','TSQL Import: adb','13' UNION
SELECT NULL,'PGOBHISTLIV','PGOBHISTLIV','Living:','PG','Living:','Text','3','11/29/2013','TSQL Import: adb','14' UNION
SELECT NULL,'PGNUMGEST','PGNUMGEST','Number Of Gestations During This Pregnancy:','PG','Number Of Gestations During This Pregnancy:','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','15' UNION
SELECT NULL,'PGMODE','PGMODE','What Was The Mode Of This Pregnancy?','PG','What Was The Mode Of This Pregnancy?','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','16' UNION
SELECT NULL,'PGASSISTED_HD','PGASSISTED_HD','If Assisted, Check All That Apply:','PG','If Assisted, Check All That Apply:','Text','3','11/29/2013','TSQL Import: adb','17' UNION
SELECT NULL,'PGASSIOI','PGASSIOI','OvulatiON Induction:','PG','OvulatiON Induction:','CheckBox','3','11/29/2013','TSQL Import: adb','18' UNION
SELECT NULL,'PGASSIIVF','PGASSIIVF','In Vitro Fertilization:','PG','In Vitro Fertilization:','CheckBox','3','11/29/2013','TSQL Import: adb','19' UNION
SELECT NULL,'PGASSIISI','PGASSIISI','Intracytoplasmic Sperm Injection:','PG','Intracytoplasmic Sperm Injection:','CheckBox','3','11/29/2013','TSQL Import: adb','20' UNION
SELECT NULL,'PGHRISKPAD','PGHRISKPAD','High Risk Perinatal (HRP) Admission:','PG','High Risk Perinatal (HRP) Admission:','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','21' UNION
SELECT NULL,'PGHRISKPAD_HD','PGHRISKPAD_HD','If Yes, Check All That Apply:','PG','If Yes, Check All That Apply:','Text','3','11/29/2013','TSQL Import: adb','22' UNION
SELECT NULL,'PGHRISKPADS','PGHRISKPADS','Same Admission:','PG','Same Admission:','CheckBox','3','11/29/2013','TSQL Import: adb','23' UNION
SELECT NULL,'PGHRISKPADD','PGHRISKPADD','Different Admission:','PG','Different Admission:','CheckBox','3','11/29/2013','TSQL Import: adb','24' UNION
SELECT NULL,'PGADMLBS','PGADMLBS','Mother''s AdmissiON Weight:','PG','Mother''s AdmissiON Weight:','Text','3','11/29/2013','TSQL Import: adb','25' UNION
SELECT NULL,'DER_PGWTGAIN','DER_PGWTGAIN','Weight Gain Derivation','PG','Weight Gain Derivation','Text','3','11/29/2013','TSQL Import: adb','26' UNION
SELECT NULL,'PGWTGAIN','PGWTGAIN','What Was Mothers Weight Gain During Pregnancy?','PG','What Was Mothers Weight Gain During Pregnancy?','DropDownList','3','11/29/2013','TSQL Import: adb','27' UNION
SELECT NULL,'PGCOND','PGCOND','SELECT Any Medical Conditions That Mother Was Diagnosed With During This Pregnancy:','PG','SELECT Any Medical Conditions That Mother Was Diagnosed With During This Pregnancy:','Text','3','11/29/2013','TSQL Import: adb','28' UNION
SELECT NULL,'PGCONDP','PGCONDP','None:','PG','None:','CheckBox','3','11/29/2013','TSQL Import: adb','29' UNION
SELECT NULL,'PGCONDGD','PGCONDGD','Gestational Diabetes:','PG','Gestational Diabetes:','CheckBox','3','11/29/2013','TSQL Import: adb','30' UNION
SELECT NULL,'PGCONDPE','PGCONDPE','Pre-Eclampsia/PIH/HELLP:','PG','Pre-Eclampsia/PIH/HELLP:','CheckBox','3','11/29/2013','TSQL Import: adb','31' UNION
SELECT NULL,'PGCONDPLAC','PGCONDPLAC','Placenta (Abruption, Previa, Accreta):','PG','Placenta (Abruption, Previa, Accreta):','CheckBox','3','11/29/2013','TSQL Import: adb','32' UNION
SELECT NULL,'PGCONDSTRUC','PGCONDSTRUC','Structure (Uterus, Cervix):','PG','Structure (Uterus, Cervix):','CheckBox','3','11/29/2013','TSQL Import: adb','33' UNION
SELECT NULL,'PGCONDNBID','PGCONDNBID','Newborn (Iugr, Decels):','PG','Newborn (Iugr, Decels):','CheckBox','3','11/29/2013','TSQL Import: adb','34' UNION
SELECT NULL,'PGCONDPROM','PGCONDPROM','PROM:','PG','PROM:','CheckBox','3','11/29/2013','TSQL Import: adb','35' UNION
SELECT NULL,'PGCONDINF','PGCONDINF','Infection:','PG','Infection:','CheckBox','3','11/29/2013','TSQL Import: adb','36' UNION
SELECT NULL,'PGCONDINFU','PGCONDINFU','UTI:','PG','UTI:','CheckBox','3','11/29/2013','TSQL Import: adb','37' UNION
SELECT NULL,'PGCONDINFP','PGCONDINFP','Polynephritis:','PG','Polynephritis:','CheckBox','3','11/29/2013','TSQL Import: adb','38' UNION
SELECT NULL,'PGCONDINFOTH','PGCONDINFOTH','Other:','PG','Other:','CheckBox','3','11/29/2013','TSQL Import: adb','39' UNION
SELECT NULL,'PGCONDGP','PGCONDGP','GBS Positive:','PG','GBS Positive:','CheckBox','3','11/29/2013','TSQL Import: adb','40' UNION
SELECT NULL,'PGCONDHPV','PGCONDHPV','HPV:','PG','HPV:','CheckBox','3','11/29/2013','TSQL Import: adb','41' UNION
SELECT NULL,'PGCONDC','PGCONDC','Chlamydia:','PG','Chlamydia:','CheckBox','3','11/29/2013','TSQL Import: adb','42' UNION
SELECT NULL,'PGCONDU','PGCONDU','Ureaplasma:','PG','Ureaplasma:','CheckBox','3','11/29/2013','TSQL Import: adb','43' UNION
SELECT NULL,'PGCONDVB','PGCONDVB','Vaginal Bleeding:','PG','Vaginal Bleeding:','CheckBox','3','11/29/2013','TSQL Import: adb','44' UNION
SELECT NULL,'PGCONDOTH','PGCONDOTH','Other:','PG','Other:','CheckBox','3','11/29/2013','TSQL Import: adb','45' UNION
SELECT NULL,'PGCONDUNK','PGCONDUNK','Unknown:','PG','Unknown:','CheckBox','3','11/29/2013','TSQL Import: adb','46' UNION
SELECT NULL,'PGVACC_HD','PGVACC_HD','Vaccinations During This Pregnancy:','PG','Vaccinations During This Pregnancy:','Text','3','11/29/2013','TSQL Import: adb','47' UNION
SELECT NULL,'PGVACNO','PGVACNO','None:','PG','None:','CheckBox','3','11/29/2013','TSQL Import: adb','48' UNION
SELECT NULL,'PGVACTET','PGVACTET','Tetanus:','PG','Tetanus:','CheckBox','3','11/29/2013','TSQL Import: adb','49' UNION
SELECT NULL,'PGVACTD','PGVACTD','TD:','PG','TD:','CheckBox','3','11/29/2013','TSQL Import: adb','50' UNION
SELECT NULL,'PGVACTDAP','PGVACTDAP','TDAP:','PG','TDAP:','CheckBox','3','11/29/2013','TSQL Import: adb','51' UNION
SELECT NULL,'PGVACHPV','PGVACHPV','HPV:','PG','HPV:','CheckBox','3','11/29/2013','TSQL Import: adb','52' UNION
SELECT NULL,'PGVACHBV','PGVACHBV','HBV:','PG','HBV:','CheckBox','3','11/29/2013','TSQL Import: adb','53' UNION
SELECT NULL,'PGVACINF','PGVACINF','Influenza:','PG','Influenza:','CheckBox','3','11/29/2013','TSQL Import: adb','54' UNION
SELECT NULL,'PGVACRHO','PGVACRHO','Rhogam:','PG','Rhogam:','CheckBox','3','11/29/2013','TSQL Import: adb','55' UNION
SELECT NULL,'PGVACRUB','PGVACRUB','Rubella:','PG','Rubella:','CheckBox','3','11/29/2013','TSQL Import: adb','56' UNION
SELECT NULL,'PGVACPNE','PGVACPNE','Pneumoccoal:','PG','Pneumoccoal:','CheckBox','3','11/29/2013','TSQL Import: adb','57' UNION
SELECT NULL,'PGVACUNK','PGVACUNK','Unknown:','PG','Unknown:','CheckBox','3','11/29/2013','TSQL Import: adb','58' UNION
SELECT NULL,'NBFMCODE','NBFMCODE','Family Member Suffix:','PG','Family Member Suffix:','Text','3','11/29/2013','TSQL Import: adb','59' UNION
SELECT NULL,'MHBRTHDATSR','MHBRTHDATSR','Date Of Birth (SR) (mm/dd/yyyy):','MHDM','Date Of Birth (SR) (mm/dd/yyyy):','DateTime','3','11/29/2013','TSQL Import: adb','1' UNION
SELECT NULL,'MHBRTHWT_HD','MHBRTHWT_HD','Birth Weight (SR)','MHDM','Birth Weight (SR)','Text','3','11/29/2013','TSQL Import: adb','2' UNION
SELECT NULL,'MHBRTHWTLB','MHBRTHWTLB','Pounds (lb)','MHDM','Pounds (lb)','Text','3','11/29/2013','TSQL Import: adb','3' UNION
SELECT NULL,'MHBRTHWTOZ','MHBRTHWTOZ','Ounces (oz)','MHDM','Ounces (oz)','Text','3','11/29/2013','TSQL Import: adb','4' UNION
SELECT NULL,'MHBRTHWTGR','MHBRTHWTGR','<b>Grams (g)</b>','MHDM','<b>Grams (g)</b>','Text','3','11/29/2013','TSQL Import: adb','5' UNION
SELECT NULL,'MHBRTHWTUNK','MHBRTHWTUNK','Unknown:','MHDM','Unknown:','CheckBox','3','11/29/2013','TSQL Import: adb','6' UNION
SELECT NULL,'MHBRTHWT','MHBRTHWT','Derived Weight (lb):','MHDM','Derived Weight (lb):','Text','3','11/29/2013','TSQL Import: adb','7' UNION
SELECT NULL,'MHCOUNTRYBRTH','MHCOUNTRYBRTH','Country Of Birth (SR):','MHDM','Country Of Birth (SR):','SearchList','3','11/29/2013','TSQL Import: adb','8' UNION
SELECT NULL,'NBFMCODE','NBFMCODE','Family Member Suffix:','MHDM','Family Member Suffix:','Text','3','11/29/2013','TSQL Import: adb','9' UNION
SELECT NULL,'MHGAGE','MHGAGE','Mothers Gestational Age At Time Of Birth (SR):','MHMH1','Mothers Gestational Age At Time Of Birth (SR):','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','1' UNION
SELECT NULL,'MHGAGEWK','MHGAGEWK','Weeks:','MHMH1','Weeks:','Text','3','11/29/2013','TSQL Import: adb','2' UNION
SELECT NULL,'MHGAGEUNK','MHGAGEUNK','Unknown:','MHMH1','Unknown:','CheckBox','3','11/29/2013','TSQL Import: adb','3' UNION
SELECT NULL,'MHWTPPGLB','MHWTPPGLB','Pre-Pregnancy Weight (SR):','MHMH1','Pre-Pregnancy Weight (SR):','Text','3','11/29/2013','TSQL Import: adb','4' UNION
SELECT NULL,'MHWTPPGUNK','MHWTPPGUNK','Unknown:','MHMH1','Unknown:','CheckBox','3','11/29/2013','TSQL Import: adb','5' UNION
SELECT NULL,'MHWT1YRLB','MHWT1YRLB','Weight 1 Year Ago (SR):','MHMH1','Weight 1 Year Ago (SR):','Text','3','11/29/2013','TSQL Import: adb','6' UNION
SELECT NULL,'MHWT1YRUNK','MHWT1YRUNK','Unknown:','MHMH1','Unknown:','CheckBox','3','11/29/2013','TSQL Import: adb','7' UNION
SELECT NULL,'MHWT5YRLB','MHWT5YRLB','Weight 5 Years Ago (SR):','MHMH1','Weight 5 Years Ago (SR):','Text','3','11/29/2013','TSQL Import: adb','8' UNION
SELECT NULL,'MHWT5YRUNK','MHWT5YRUNK','Unknown:','MHMH1','Unknown:','CheckBox','3','11/29/2013','TSQL Import: adb','9' UNION
SELECT NULL,'MHCURRHT','MHCURRHT','Current Height (SR) Inches Only:','MHMH1','Current Height (SR) Inches Only:','Text','3','11/29/2013','TSQL Import: adb','10' UNION
SELECT NULL,'MHCURRHTUNK','MHCURRHTUNK','Unknown:','MHMH1','Unknown:','CheckBox','3','11/29/2013','TSQL Import: adb','11' UNION
SELECT NULL,'MHBMI','MHBMI','BMI:','MHMH1','BMI:','Text','3','11/29/2013','TSQL Import: adb','12' UNION
SELECT NULL,'MHSICK','MHSICK','Have You Been Sick Over The Past Few Months With Any Of The Following? (SR - Check All That Apply)','MHMH1','Have You Been Sick Over The Past Few Months With Any Of The Following? (SR - Check All That Apply)','Text','3','11/29/2013','TSQL Import: adb','13' UNION
SELECT NULL,'MH6MNO','MH6MNO','No:','MHMH1','No:','CheckBox','3','11/29/2013','TSQL Import: adb','14' UNION
SELECT NULL,'MH6MVIR','MH6MVIR','Virus:','MHMH1','Virus:','CheckBox','3','11/29/2013','TSQL Import: adb','15' UNION
SELECT NULL,'MH6MCONG','MH6MCONG','Congestion:','MHMH1','Congestion:','CheckBox','3','11/29/2013','TSQL Import: adb','16' UNION
SELECT NULL,'MH6MFLU','MH6MFLU','Flu-Like Symptoms:','MHMH1','Flu-Like Symptoms:','CheckBox','3','11/29/2013','TSQL Import: adb','17' UNION
SELECT NULL,'MH6MGAS','MH6MGAS','Gastric Symptoms:','MHMH1','Gastric Symptoms:','CheckBox','3','11/29/2013','TSQL Import: adb','18' UNION
SELECT NULL,'MH6MOTH','MH6MOTH','Other:','MHMH1','Other:','CheckBox','3','11/29/2013','TSQL Import: adb','19' UNION
SELECT NULL,'MHMOTHTYP','MHMOTHTYP','Type:','MHMH1','Type:','Text','3','11/29/2013','TSQL Import: adb','20' UNION
SELECT NULL,'MH6MUNK','MH6MUNK','Unknown:','MHMH1','Unknown:','CheckBox','3','11/29/2013','TSQL Import: adb','21' UNION
SELECT NULL,'NBFMCODE','NBFMCODE','Family Member Suffix:','MHMH1','Family Member Suffix:','Text','3','11/29/2013','TSQL Import: adb','22' UNION
SELECT NULL,'NBFMCODE','NBFMCODE','Family Member Suffix:','MHMH2','Family Member Suffix:','Text','3','11/29/2013','TSQL Import: adb','1' UNION
SELECT NULL,'MHCONDRPT','MHCONDRPT','Are there any conditions to report?','MHMH2','Are there any conditions to report?','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','2' UNION
SELECT NULL,'MHCOND','MHCOND','Condition','MHMH2','Condition','DropDownList','3','11/29/2013','TSQL Import: adb','3' UNION
SELECT NULL,'MHCONDSR','MHCONDSR','Self-Report:','MHMH2','Self-Report:','CheckBox','3','11/29/2013','TSQL Import: adb','4' UNION
SELECT NULL,'MHCNODMR','MHCNODMR','Med Rec:','MHMH2','Med Rec:','CheckBox','3','11/29/2013','TSQL Import: adb','5' UNION
SELECT NULL,'MHCONDFHX','MHCONDFHX','Fam HX:','MHMH2','Fam HX:','CheckBox','3','11/29/2013','TSQL Import: adb','6' UNION
SELECT NULL,'MHCONDTYP','MHCONDTYP','Type:','MHMH2','Type:','LongText','3','11/29/2013','TSQL Import: adb','7' UNION
SELECT NULL,'CMNOTE','CMNOTE','Please Record Any Medications Patient Has Taken (FROM Time Of Signed Informed Consent To Discharge)','CM','Please Record Any Medications Patient Has Taken (FROM Time Of Signed Informed Consent To Discharge)','Text','3','11/29/2013','TSQL Import: adb','1' UNION
SELECT NULL,'CMNONE','CMNONE','None:','CM','None:','CheckBox','3','11/29/2013','TSQL Import: adb','2' UNION
SELECT NULL,'CMUNK','CMUNK','Unknown:','CM','Unknown:','CheckBox','3','11/29/2013','TSQL Import: adb','3' UNION
SELECT NULL,'CMNAME','CMNAME','Drug Name:','CM','Drug Name:','LongText','3','11/29/2013','TSQL Import: adb','4' UNION
SELECT NULL,'CMSTDAT','CMSTDAT','Start Date:','CM','Start Date:','DateTime','3','11/29/2013','TSQL Import: adb','5' UNION
SELECT NULL,'CMENDAT','CMENDAT','Stop Date:','CM','Stop Date:','DateTime','3','11/29/2013','TSQL Import: adb','6' UNION
SELECT NULL,'CMSTDATONG','CMSTDATONG','Ongoing:','CM','Ongoing:','CheckBox','3','11/29/2013','TSQL Import: adb','7' UNION
SELECT NULL,'CMDOS','CMDOS','Dose:','CM','Dose:','LongText','3','11/29/2013','TSQL Import: adb','8' UNION
SELECT NULL,'CMDOSU','CMDOSU','Units:','CM','Units:','DropDownList','3','11/29/2013','TSQL Import: adb','9' UNION
SELECT NULL,'CMDOSUOTH','CMDOSUOTH','Other, Specify:','CM','Other, Specify:','LongText','3','11/29/2013','TSQL Import: adb','10' UNION
SELECT NULL,'CMDOSFRQ','CMDOSFRQ','Frequency:','CM','Frequency:','DropDownList','3','11/29/2013','TSQL Import: adb','11' UNION
SELECT NULL,'CMDOSFRQOTH','CMDOSFRQOTH','Other, Specify:','CM','Other, Specify:','LongText','3','11/29/2013','TSQL Import: adb','12' UNION
SELECT NULL,'CMROUTE','CMROUTE','Route:','CM','Route:','SearchList','3','11/29/2013','TSQL Import: adb','13' UNION
SELECT NULL,'CMROUTEOTH','CMROUTEOTH','Other, Specify:','CM','Other, Specify:','LongText','3','11/29/2013','TSQL Import: adb','14' UNION
SELECT NULL,'CMIND','CMIND','Indication:','CM','Indication:','LongText','3','11/29/2013','TSQL Import: adb','15' UNION
SELECT NULL,'NBFMCODE','NBFMCODE','Family Member Suffix:','CM','Family Member Suffix:','Text','3','11/29/2013','TSQL Import: adb','16' UNION
SELECT NULL,'SPMEDHIST3_HD','SPMEDHIST3_HD','Please List Any Previous Procedures Or Surgeries Including The Data (SR - Include Art, Ovluation/IVF)','SP','Please List Any Previous Procedures Or Surgeries Including The Data (SR - Include Art, Ovluation/IVF)','Text','3','11/29/2013','TSQL Import: adb','1' UNION
SELECT NULL,'SPSPNONE','SPSPNONE','None:','SP','None:','CheckBox','3','11/29/2013','TSQL Import: adb','2' UNION
SELECT NULL,'SPSPUNK','SPSPUNK','Unknown:','SP','Unknown:','CheckBox','3','11/29/2013','TSQL Import: adb','3' UNION
SELECT NULL,'SPSURG','SPSURG','Surgical Procedure:','SP','Surgical Procedure:','DropDownList','3','11/29/2013','TSQL Import: adb','4' UNION
SELECT NULL,'SPOTH','SPOTH','Other/Comment:','SP','Other/Comment:','LongText','3','11/29/2013','TSQL Import: adb','5' UNION
SELECT NULL,'NBFMCODE','NBFMCODE','Family Member Suffix:','SP','Family Member Suffix:','Text','3','11/29/2013','TSQL Import: adb','6' UNION
SELECT NULL,'MHDIETTYPE','MHDIETTYPE','Diet Type (SR):','MHMH3','Diet Type (SR):','DropDownList','3','11/29/2013','TSQL Import: adb','1' UNION
SELECT NULL,'MHDNREC','MHDNREC','<B>Diet And Nutrition-24 Hr Recall (SR)</B>','MHMH3','<B>Diet And Nutrition-24 Hr Recall (SR)</B>','Text','3','11/29/2013','TSQL Import: adb','2' UNION
SELECT NULL,'MHDTNONE','MHDTNONE','None:','MHMH3','None:','CheckBox','3','11/29/2013','TSQL Import: adb','3' UNION
SELECT NULL,'MHDTPV','MHDTPV','Prenatal Vitamins:','MHMH3','Prenatal Vitamins:','CheckBox','3','11/29/2013','TSQL Import: adb','4' UNION
SELECT NULL,'MHPVSTDAT','MHPVSTDAT','Start Date For Prenatal Vitamins:','MHMH3','Start Date For Prenatal Vitamins:','DateTime','3','11/29/2013','TSQL Import: adb','5' UNION
SELECT NULL,'MHSUPP_HD','MHSUPP_HD','Do You Take Any Of The Following?','MHMH3','Do You Take Any Of The Following?','Text','3','11/29/2013','TSQL Import: adb','6' UNION
SELECT NULL,'MHSUPNON','MHSUPNON','None:','MHMH3','None:','CheckBox','3','11/29/2013','TSQL Import: adb','7' UNION
SELECT NULL,'MHSUPUNK','MHSUPUNK','Unknown:','MHMH3','Unknown:','CheckBox','3','11/29/2013','TSQL Import: adb','8' UNION
SELECT NULL,'MHSUPOTH','MHSUPOTH','Other Vitamins:','MHMH3','Other Vitamins:','CheckBox','3','11/29/2013','TSQL Import: adb','9' UNION
SELECT NULL,'MHSUPOTHTYP','MHSUPOTHTYP','Type:','MHMH3','Type:','Text','3','11/29/2013','TSQL Import: adb','10' UNION
SELECT NULL,'MHSUPHRB','MHSUPHRB','Herbs:','MHMH3','Herbs:','CheckBox','3','11/29/2013','TSQL Import: adb','11' UNION
SELECT NULL,'MHSUPHRBTYP','MHSUPHRBTYP','Type:','MHMH3','Type:','Text','3','11/29/2013','TSQL Import: adb','12' UNION
SELECT NULL,'MHSUPNUT','MHSUPNUT','Nutritional Supplements:','MHMH3','Nutritional Supplements:','CheckBox','3','11/29/2013','TSQL Import: adb','13' UNION
SELECT NULL,'MHSUPNUTTYP','MHSUPNUTTYP','Type:','MHMH3','Type:','LongText','3','11/29/2013','TSQL Import: adb','14' UNION
SELECT NULL,'MHDTOV','MHDTOV','Category:','MHMH3','Category:','DropDownList','3','11/29/2013','TSQL Import: adb','15' UNION
SELECT NULL,'MHDTOVTYP','MHDTOVTYP','Type:','MHMH3','Type:','LongText','3','11/29/2013','TSQL Import: adb','16' UNION
SELECT NULL,'MHDTOTH','MHDTOTH','Other Dietary Factors:','MHMH3','Other Dietary Factors:','CheckBox','3','11/29/2013','TSQL Import: adb','17' UNION
SELECT NULL,'MHDTOTHTYP','MHDTOTHTYP','Type:','MHMH3','Type:','Text','3','11/29/2013','TSQL Import: adb','18' UNION
SELECT NULL,'MHDIETREC','MHDIETREC','24 Hour Diet Recall','MHMH3','24 Hour Diet Recall','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','19' UNION
SELECT NULL,'MH24DRY_HD','MH24DRY_HD','<B>Dairy</B>','MHMH3','<B>Dairy</B>','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','20' UNION
SELECT NULL,'MH24DRYMYSV','MH24DRYMYSV','If yes, how many servings:','MHMH3','If yes, how many servings:','Text','3','11/29/2013','TSQL Import: adb','21' UNION
SELECT NULL,'MH24GR_HD','MH24GR_HD','<B>Grains</B>','MHMH3','<B>Grains</B>','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','22' UNION
SELECT NULL,'MH24GRBSSV','MH24GRBSSV','If yes, how many servings:','MHMH3','If yes, how many servings:','Text','3','11/29/2013','TSQL Import: adb','23' UNION
SELECT NULL,'MH24MP_HD','MH24MP_HD','<B>Meats/Proteins</B>','MHMH3','<B>Meats/Proteins</B>','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','24' UNION
SELECT NULL,'MH24MPLNSV','MH24MPLNSV','If yes, how many servings:','MHMH3','If yes, how many servings:','Text','3','11/29/2013','TSQL Import: adb','25' UNION
SELECT NULL,'MH24F_HD','MH24F_HD','<B>Fruit</B>','MHMH3','<B>Fruit</B>','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','26' UNION
SELECT NULL,'MH24FRCSV','MH24FRCSV','If yes, how many servings:','MHMH3','If yes, how many servings:','Text','3','11/29/2013','TSQL Import: adb','27' UNION
SELECT NULL,'MH24V_HD','MH24V_HD','<B>Vegetable</B>','MHMH3','<B>Vegetable</B>','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','28' UNION
SELECT NULL,'MH24VRCSV','MH24VRCSV','If yes, how many servings:','MHMH3','If yes, how many servings:','Text','3','11/29/2013','TSQL Import: adb','29' UNION
SELECT NULL,'MH24FS_HD','MH24FS_HD','<B>Fats</B>','MHMH3','<B>Fats</B>','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','30' UNION
SELECT NULL,'MH24FSOSV','MH24FSOSV','If yes, how many servings:','MHMH3','If yes, how many servings:','Text','3','11/29/2013','TSQL Import: adb','31' UNION
SELECT NULL,'MH24FSS','MH24FSS','<B>Sodium:</B>','MHMH3','<B>Sodium:</B>','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','32' UNION
SELECT NULL,'MH24FSSSV','MH24FSSSV','If yes, how many servings:','MHMH3','If yes, how many servings:','Text','3','11/29/2013','TSQL Import: adb','33' UNION
SELECT NULL,'MHEXERCISE','MHEXERCISE','Do You Exercise Regularly? (SR)','MHMH3','Do You Exercise Regularly? (SR)','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','34' UNION
SELECT NULL,'MHEXERCISETYPE_HD','MHEXERCISETYPE_HD','If Yes, Type:','MHMH3','If Yes, Type:','Text','3','11/29/2013','TSQL Import: adb','35' UNION
SELECT NULL,'MHEXERSTR','MHEXERSTR','Stretching Or Strengthening, Such AS Using Weights Or Range Of Motion:','MHMH3','Stretching Or Strengthening, Such AS Using Weights Or Range Of Motion:','CheckBox','3','11/29/2013','TSQL Import: adb','36' UNION
SELECT NULL,'MHEXERWSB','MHEXERWSB','Walking, Swimming Or Biking:','MHMH3','Walking, Swimming Or Biking:','CheckBox','3','11/29/2013','TSQL Import: adb','37' UNION
SELECT NULL,'MHEXERAER','MHEXERAER','Aerobic Exercise Such AS Runnings, Stair Climbing, Rowing:','MHMH3','Aerobic Exercise Such AS Runnings, Stair Climbing, Rowing:','CheckBox','3','11/29/2013','TSQL Import: adb','38' UNION
SELECT NULL,'MHEXERSKI','MHEXERSKI','Skiing Including Machines:','MHMH3','Skiing Including Machines:','CheckBox','3','11/29/2013','TSQL Import: adb','39' UNION
SELECT NULL,'MHEXEROTH','MHEXEROTH','Other:','MHMH3','Other:','CheckBox','3','11/29/2013','TSQL Import: adb','40' UNION
SELECT NULL,'MHEXEROTHTYP','MHEXEROTHTYP','If Other, Type:','MHMH3','If Other, Type:','Text','3','11/29/2013','TSQL Import: adb','41' UNION
SELECT NULL,'MHEXERDUR','MHEXERDUR','If Yes, DuratiON Of Exercise (Total)','MHMH3','If Yes, DuratiON Of Exercise (Total)','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','42' UNION
SELECT NULL,'MHEXERFREQ','MHEXERFREQ','If Yes, Frequency Of Exercise:','MHMH3','If Yes, Frequency Of Exercise:','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','43' UNION
SELECT NULL,'MHEOLPP','MHEOLPP','History Of Early Onset Of Labor In Previous Pregnancies:','MHMH3','History Of Early Onset Of Labor In Previous Pregnancies:','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','44' UNION
SELECT NULL,'MHEOLPPROM_HD','MHEOLPPROM_HD','If Yes, Check All That Apply:','MHMH3','If Yes, Check All That Apply:','Text','3','11/29/2013','TSQL Import: adb','45' UNION
SELECT NULL,'MHEOLPPROM','MHEOLPPROM','PPROM:','MHMH3','PPROM:','CheckBox','3','11/29/2013','TSQL Import: adb','46' UNION
SELECT NULL,'MHEOLPNUM','MHEOLPNUM','Number Of Pregnancies:','MHMH3','Number Of Pregnancies:','Text','3','11/29/2013','TSQL Import: adb','47' UNION
SELECT NULL,'MHEOLPPTL','MHEOLPPTL','PTL:','MHMH3','PTL:','CheckBox','3','11/29/2013','TSQL Import: adb','48' UNION
SELECT NULL,'MHEOLPPNUM','MHEOLPPNUM','Number Of Pregnancies:','MHMH3','Number Of Pregnancies:','Text','3','11/29/2013','TSQL Import: adb','49' UNION
SELECT NULL,'MHEOLPPLAC','MHEOLPPLAC','Placenta (Abruption, Previa, Accreta):','MHMH3','Placenta (Abruption, Previa, Accreta):','CheckBox','3','11/29/2013','TSQL Import: adb','50' UNION
SELECT NULL,'MHEOLPPSTRUC','MHEOLPPSTRUC','Structure (Uterus, Cervix):','MHMH3','Structure (Uterus, Cervix):','CheckBox','3','11/29/2013','TSQL Import: adb','51' UNION
SELECT NULL,'MHEOLPPNB','MHEOLPPNB','Newborn (IUGR, Decels):','MHMH3','Newborn (IUGR, Decels):','CheckBox','3','11/29/2013','TSQL Import: adb','52' UNION
SELECT NULL,'MHEOLPOTH','MHEOLPOTH','Other:','MHMH3','Other:','CheckBox','3','11/29/2013','TSQL Import: adb','53' UNION
SELECT NULL,'MHEOLPUNK','MHEOLPUNK','Unknown:','MHMH3','Unknown:','CheckBox','3','11/29/2013','TSQL Import: adb','54' UNION
SELECT NULL,'NBFMCODE','NBFMCODE','Family Member Suffix:','MHMH3','Family Member Suffix:','Text','3','11/29/2013','TSQL Import: adb','55' UNION
SELECT NULL,'MHMARSTAT','MHMARSTAT','Current Marital Status (SR):','MHSH','Current Marital Status (SR):','DropDownList','3','11/29/2013','TSQL Import: adb','1' UNION
SELECT NULL,'MHLIVNBF','MHLIVNBF','Do You Currently Live With Baby''s Father? (SR)','MHSH','Do You Currently Live With Baby''s Father? (SR)','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','2' UNION
SELECT NULL,'MHCURRZIP','MHCURRZIP','Current Zip Code (SR):','MHSH','Current Zip Code (SR):','Text','3','11/29/2013','TSQL Import: adb','3' UNION
SELECT NULL,'MHSMOKSTATMO','MHSMOKSTATMO','Smoking Status (SR):','MHSH','Smoking Status (SR):','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','4' UNION
SELECT NULL,'MHSMOKSTATCMO','MHSMOKSTATCMO','If Current Smoker, Cigarettes Per Day:','MHSH','If Current Smoker, Cigarettes Per Day:','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','5' UNION
SELECT NULL,'MHALCCONSMMO','MHALCCONSMMO','Alcohol ConsumptiON (SR):','MHSH','Alcohol ConsumptiON (SR):','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','6' UNION
SELECT NULL,'MHALCDRINKCMO','MHALCDRINKCMO','If Current Drinker, Drinks Per Day:','MHSH','If Current Drinker, Drinks Per Day:','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','7' UNION
SELECT NULL,'MHHAZ','MHHAZ','Exposure To Hazardous Chemicals (SR):','MHSH','Exposure To Hazardous Chemicals (SR):','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','8' UNION
SELECT NULL,'MHHAZDAT','MHHAZDAT','If Yes, Date Of Exposure: (mm/dd/yyyy)','MHSH','If Yes, Date Of Exposure: (mm/dd/yyyy)','DateTime','3','11/29/2013','TSQL Import: adb','9' UNION
SELECT NULL,'MHHAZUNK','MHHAZUNK','Unknown:','MHSH','Unknown:','CheckBox','3','11/29/2013','TSQL Import: adb','10' UNION
SELECT NULL,'MHHAZTYP','MHHAZTYP','If Yes, Type Of Exposure:','MHSH','If Yes, Type Of Exposure:','Text','3','11/29/2013','TSQL Import: adb','11' UNION
SELECT NULL,'MHEXPUNK','MHEXPUNK','Unknown:','MHSH','Unknown:','CheckBox','3','11/29/2013','TSQL Import: adb','12' UNION
SELECT NULL,'MHDRUGU','MHDRUGU','History Of Drug Use (Including Marijuana/Illegal Drugs):','MHSH','History Of Drug Use (Including Marijuana/Illegal Drugs):','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','13' UNION
SELECT NULL,'MHSEX','MHSEX','Gender (SR):','MHSH','Gender (SR):','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','14' UNION
SELECT NULL,'NBFMCODE','NBFMCODE','Family Member Suffix:','MHSH','Family Member Suffix:','Text','3','11/29/2013','TSQL Import: adb','15' UNION
SELECT NULL,'MHMBRTHCO','MHMBRTHCO','Your Mothers Country Of Birth (SR):','MHFH','Your Mothers Country Of Birth (SR):','SearchList','3','11/29/2013','TSQL Import: adb','1' UNION
SELECT NULL,'MHFBRTHCO','MHFBRTHCO','Your Fathers Country Of Birth (SR):','MHFH','Your Fathers Country Of Birth (SR):','SearchList','3','11/29/2013','TSQL Import: adb','2' UNION
SELECT NULL,'MHMOGUCOUNTRY_HD','MHMOGUCOUNTRY_HD','What Country(ies) Did You Grow Up In? (SR) (Ages Birth To Twelve):','MHFH','What Country(ies) Did You Grow Up In? (SR) (Ages Birth To Twelve):','Text','3','11/29/2013','TSQL Import: adb','3' UNION
SELECT NULL,'MHGUPUS','MHGUPUS','USA:','MHFH','USA:','CheckBox','3','11/29/2013','TSQL Import: adb','4' UNION
SELECT NULL,'MHGUPOTH','MHGUPOTH','Other:','MHFH','Other:','CheckBox','3','11/29/2013','TSQL Import: adb','5' UNION
SELECT NULL,'MHGUPOTHCO','MHGUPOTHCO','Country:','MHFH','Country:','SearchList','3','11/29/2013','TSQL Import: adb','6' UNION
SELECT NULL,'MHGUPUNK','MHGUPUNK','Unknown:','MHFH','Unknown:','CheckBox','3','11/29/2013','TSQL Import: adb','7' UNION
SELECT NULL,'NBFMCODE','NBFMCODE','Family Member Suffix:','MHFH','Family Member Suffix:','Text','3','11/29/2013','TSQL Import: adb','8' UNION
SELECT NULL,'MHLIFEEVENTSEVAL_HD','MHLIFEEVENTSEVAL_HD','Please SELECT Any Events That Have Occurred In Your Life Over The Past 12 Months (SR - Check All That Apply):','MHLE','Please SELECT Any Events That Have Occurred In Your Life Over The Past 12 Months (SR - Check All That Apply):','Text','3','11/29/2013','TSQL Import: adb','1' UNION
SELECT NULL,'MHLIFEUNK','MHLIFEUNK','Unknown:','MHLE','Unknown:','CheckBox','3','11/29/2013','TSQL Import: adb','2' UNION
SELECT NULL,'MHLIFENO','MHLIFENO','None:','MHLE','None:','CheckBox','3','11/29/2013','TSQL Import: adb','3' UNION
SELECT NULL,'MHLIFECCP','MHLIFECCP','Complications With Your Current Pregnancy:','MHLE','Complications With Your Current Pregnancy:','CheckBox','3','11/29/2013','TSQL Import: adb','4' UNION
SELECT NULL,'MHLIFEPHP','MHLIFEPHP','Personal Health Problems:','MHLE','Personal Health Problems:','CheckBox','3','11/29/2013','TSQL Import: adb','5' UNION
SELECT NULL,'MHLIFEPSP','MHLIFEPSP','Personal Social Problems:','MHLE','Personal Social Problems:','CheckBox','3','11/29/2013','TSQL Import: adb','6' UNION
SELECT NULL,'MHLIFEPCP','MHLIFEPCP','Problems With Current Partner:','MHLE','Problems With Current Partner:','CheckBox','3','11/29/2013','TSQL Import: adb','7' UNION
SELECT NULL,'MHLIFEFD','MHLIFEFD','Family Disruption:','MHLE','Family Disruption:','CheckBox','3','11/29/2013','TSQL Import: adb','8' UNION
SELECT NULL,'MHLIFEPYF','MHLIFEPYF','Problems With Your Finances:','MHLE','Problems With Your Finances:','CheckBox','3','11/29/2013','TSQL Import: adb','9' UNION
SELECT NULL,'MHLIFEPYOC','MHLIFEPYOC','Problems With Your Own Children:','MHLE','Problems With Your Own Children:','CheckBox','3','11/29/2013','TSQL Import: adb','10' UNION
SELECT NULL,'MHLIFEPIL','MHLIFEPIL','Problems With Your In-Laws:','MHLE','Problems With Your In-Laws:','CheckBox','3','11/29/2013','TSQL Import: adb','11' UNION
SELECT NULL,'MHLIFEPCF','MHLIFEPCF','Problems Within Your Close Family:','MHLE','Problems Within Your Close Family:','CheckBox','3','11/29/2013','TSQL Import: adb','12' UNION
SELECT NULL,'MHLIFESICF','MHLIFESICF','Serious Illness In Your Close Family:','MHLE','Serious Illness In Your Close Family:','CheckBox','3','11/29/2013','TSQL Import: adb','13' UNION
SELECT NULL,'MHLIFEDCF','MHLIFEDCF','Death Within Your Close Family:','MHLE','Death Within Your Close Family:','CheckBox','3','11/29/2013','TSQL Import: adb','14' UNION
SELECT NULL,'MHLIFELJ','MHLIFELJ','Loss Of Job (You Or Your Partner):','MHLE','Loss Of Job (You Or Your Partner):','CheckBox','3','11/29/2013','TSQL Import: adb','15' UNION
SELECT NULL,'MHLIFEPWE','MHLIFEPWE','Problems Within Your Work Environment:','MHLE','Problems Within Your Work Environment:','CheckBox','3','11/29/2013','TSQL Import: adb','16' UNION
SELECT NULL,'MHLIFEWRKT','MHLIFEWRKT','Work Transfer (You Or Your Partner):','MHLE','Work Transfer (You Or Your Partner):','CheckBox','3','11/29/2013','TSQL Import: adb','17' UNION
SELECT NULL,'MHLIFECR','MHLIFECR','Change In Residence:','MHLE','Change In Residence:','CheckBox','3','11/29/2013','TSQL Import: adb','18' UNION
SELECT NULL,'MHLIFECPA','MHLIFECPA','Current Partner Is Away Often:','MHLE','Current Partner Is Away Often:','CheckBox','3','11/29/2013','TSQL Import: adb','19' UNION
SELECT NULL,'MHLIFEAR','MHLIFEAR','Accidents, Robberies, Or Similar Events:','MHLE','Accidents, Robberies, Or Similar Events:','CheckBox','3','11/29/2013','TSQL Import: adb','20' UNION
SELECT NULL,'NBFMCODE','NBFMCODE','Family Member Suffix:','MHLE','Family Member Suffix:','Text','3','11/29/2013','TSQL Import: adb','21' UNION
SELECT NULL,'MHMODECLINED_HD','MHMODECLINED_HD','Declined (SR):','MHSS','Declined (SR):','CheckBox','3','11/29/2013','TSQL Import: adb','1' UNION
SELECT NULL,'MHMOEDLVL','MHMOEDLVL','EducatiON Level (SR):','MHSS','EducatiON Level (SR):','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','2' UNION
SELECT NULL,'MHMOOCCLVL','MHMOOCCLVL','OccupatiON (SR):','MHSS','OccupatiON (SR):','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','3' UNION
SELECT NULL,'MHMOINC','MHMOINC','Income (SR):','MHSS','Income (SR):','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','4' UNION
SELECT NULL,'MHRACE','MHRACE','Race (SR):','MHSS','Race (SR):','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','5' UNION
SELECT NULL,'MHSEX','MHSEX','Gender (SR):','MHSS','Gender (SR):','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','6' UNION
SELECT NULL,'MHETHNIC','MHETHNIC','Ethnicity:','MHSS','Ethnicity:','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','7' UNION
SELECT NULL,'NBFMCODE','NBFMCODE','Family Member Suffix:','MHSS','Family Member Suffix:','Text','3','11/29/2013','TSQL Import: adb','8' UNION
SELECT NULL,'FPBRTHDATSR','FPBRTHDATSR','Date Of Birth (SR) (mm/dd/yyyy):','FP','Date Of Birth (SR) (mm/dd/yyyy):','DateTime','3','11/29/2013','TSQL Import: adb','1' UNION
SELECT NULL,'FPBRTHWT_HD','FPBRTHWT_HD','Birth Weight (SR)','FP','Birth Weight (SR)','Text','3','11/29/2013','TSQL Import: adb','2' UNION
SELECT NULL,'FPBRTHWTLB','FPBRTHWTLB','Pounds (lb)','FP','Pounds (lb)','Text','3','11/29/2013','TSQL Import: adb','3' UNION
SELECT NULL,'FPBRTHWTOZ','FPBRTHWTOZ','Ounces (oz)','FP','Ounces (oz)','Text','3','11/29/2013','TSQL Import: adb','4' UNION
SELECT NULL,'FPBRTHWTGR','FPBRTHWTGR','<b>Grams (g)</b>','FP','<b>Grams (g)</b>','Text','3','11/29/2013','TSQL Import: adb','5' UNION
SELECT NULL,'FPBRTHWTUNK','FPBRTHWTUNK','Unknown:','FP','Unknown:','CheckBox','3','11/29/2013','TSQL Import: adb','6' UNION
SELECT NULL,'FPBRTHWT','FPBRTHWT','Derived Weight (lb):','FP','Derived Weight (lb):','Text','3','11/29/2013','TSQL Import: adb','7' UNION
SELECT NULL,'FPCOUNTRYBRTH','FPCOUNTRYBRTH','Country Of Birth (SR):','FP','Country Of Birth (SR):','SearchList','3','11/29/2013','TSQL Import: adb','8' UNION
SELECT NULL,'FPGESTAGE','FPGESTAGE','Gestational Age At Time Of Birth (SR):','FP','Gestational Age At Time Of Birth (SR):','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','9' UNION
SELECT NULL,'FPGESTAGEWK','FPGESTAGEWK','Weeks:','FP','Weeks:','Text','3','11/29/2013','TSQL Import: adb','10' UNION
SELECT NULL,'FPGESTAGEUNK','FPGESTAGEUNK','Unknown:','FP','Unknown:','CheckBox','3','11/29/2013','TSQL Import: adb','11' UNION
SELECT NULL,'FPCURRWTLB','FPCURRWTLB','Current Weight (SR):','FP','Current Weight (SR):','Text','3','11/29/2013','TSQL Import: adb','12' UNION
SELECT NULL,'FPCURRWTUNK','FPCURRWTUNK','Unknown:','FP','Unknown:','CheckBox','3','11/29/2013','TSQL Import: adb','13' UNION
SELECT NULL,'FPCURRHT','FPCURRHT','Current Height (SR) Inches Only:','FP','Current Height (SR) Inches Only:','Text','3','11/29/2013','TSQL Import: adb','14' UNION
SELECT NULL,'FPCURRHTUNK','FPCURRHTUNK','Unknown:','FP','Unknown:','CheckBox','3','11/29/2013','TSQL Import: adb','15' UNION
SELECT NULL,'FPDIETTYPE','FPDIETTYPE','Diet Type (SR):','FP','Diet Type (SR):','DropDownList','3','11/29/2013','TSQL Import: adb','16' UNION
SELECT NULL,'FPSUPP_HD','FPSUPP_HD','Do You Take Any Of The Following?','FP','Do You Take Any Of The Following?','Text','3','11/29/2013','TSQL Import: adb','17' UNION
SELECT NULL,'FPSUPNON','FPSUPNON','None:','FP','None:','CheckBox','3','11/29/2013','TSQL Import: adb','18' UNION
SELECT NULL,'FPSUPUNK','FPSUPUNK','Unknown:','FP','Unknown:','CheckBox','3','11/29/2013','TSQL Import: adb','19' UNION
SELECT NULL,'FPSUPOTH','FPSUPOTH','Other Vitamins:','FP','Other Vitamins:','CheckBox','3','11/29/2013','TSQL Import: adb','20' UNION
SELECT NULL,'FPSUPOTHTYP','FPSUPOTHTYP','Type:','FP','Type:','Text','3','11/29/2013','TSQL Import: adb','21' UNION
SELECT NULL,'FPSUPHRB','FPSUPHRB','Herbs:','FP','Herbs:','CheckBox','3','11/29/2013','TSQL Import: adb','22' UNION
SELECT NULL,'FPSUPHRBTYP','FPSUPHRBTYP','Type:','FP','Type:','Text','3','11/29/2013','TSQL Import: adb','23' UNION
SELECT NULL,'FPSUPNUT','FPSUPNUT','Nutritional Supplements:','FP','Nutritional Supplements:','CheckBox','3','11/29/2013','TSQL Import: adb','24' UNION
SELECT NULL,'FPSUPNUTTYP','FPSUPNUTTYP','Type:','FP','Type:','LongText','3','11/29/2013','TSQL Import: adb','25' UNION
SELECT NULL,'FPSUPOTHD','FPSUPOTHD','Other Dietary Factors:','FP','Other Dietary Factors:','CheckBox','3','11/29/2013','TSQL Import: adb','26' UNION
SELECT NULL,'FPSUPOTHDTYP','FPSUPOTHDTYP','Type:','FP','Type:','Text','3','11/29/2013','TSQL Import: adb','27' UNION
SELECT NULL,'FPSH_HD','FPSH_HD','<B>Social History</B>','FP','<B>Social History</B>','Text','3','11/29/2013','TSQL Import: adb','28' UNION
SELECT NULL,'FPMARSTAT','FPMARSTAT','Marital Status (SR):','FP','Marital Status (SR):','DropDownList','3','11/29/2013','TSQL Import: adb','29' UNION
SELECT NULL,'FPLVNBM','FPLVNBM','Do You Currently Live With The Baby''s Mother?','FP','Do You Currently Live With The Baby''s Mother?','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','30' UNION
SELECT NULL,'FPZIP','FPZIP','Current Zip Code (SR):','FP','Current Zip Code (SR):','Text','3','11/29/2013','TSQL Import: adb','31' UNION
SELECT NULL,'FPZIPUNK','FPZIPUNK','Unknown:','FP','Unknown:','CheckBox','3','11/29/2013','TSQL Import: adb','32' UNION
SELECT NULL,'FPSMOKSTAT','FPSMOKSTAT','Smoking Status (SR):','FP','Smoking Status (SR):','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','33' UNION
SELECT NULL,'FPSMOKSTATC','FPSMOKSTATC','If Current Smoker, Cigarettes  Per Day:','FP','If Current Smoker, Cigarettes  Per Day:','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','34' UNION
SELECT NULL,'FPALCCONS','FPALCCONS','Alcohol ConsumptiON (SR):','FP','Alcohol ConsumptiON (SR):','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','35' UNION
SELECT NULL,'FPALCDRINKC','FPALCDRINKC','If Current Drinker, Drinks Per Day:','FP','If Current Drinker, Drinks Per Day:','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','36' UNION
SELECT NULL,'FPEXPHAZ','FPEXPHAZ','Exposure To Hazardous Chemicals (SR):','FP','Exposure To Hazardous Chemicals (SR):','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','37' UNION
SELECT NULL,'FPEXPHAZDAT','FPEXPHAZDAT','If Yes, Date Of Exposure:','FP','If Yes, Date Of Exposure:','DateTime','3','11/29/2013','TSQL Import: adb','38' UNION
SELECT NULL,'FPEXPHAZUNK','FPEXPHAZUNK','Unknown:','FP','Unknown:','CheckBox','3','11/29/2013','TSQL Import: adb','39' UNION
SELECT NULL,'FPEXPHAZTYP','FPEXPHAZTYP','If Yes, Type Of Exposure:','FP','If Yes, Type Of Exposure:','Text','3','11/29/2013','TSQL Import: adb','40' UNION
SELECT NULL,'FPEXPTYPUNK','FPEXPTYPUNK','Unknown:','FP','Unknown:','CheckBox','3','11/29/2013','TSQL Import: adb','41' UNION
SELECT NULL,'FPQUESFAMHIST_HD','FPQUESFAMHIST_HD','<B>Family History</B>','FP','<B>Family History</B>','Text','3','11/29/2013','TSQL Import: adb','42' UNION
SELECT NULL,'FPFHMBRTHCO','FPFHMBRTHCO','Your Mothers Country Of Birth (SR):','FP','Your Mothers Country Of Birth (SR):','SearchList','3','11/29/2013','TSQL Import: adb','43' UNION
SELECT NULL,'FPFHFBRTHCO','FPFHFBRTHCO','Your Fathers Country Of Birth (SR):','FP','Your Fathers Country Of Birth (SR):','SearchList','3','11/29/2013','TSQL Import: adb','44' UNION
SELECT NULL,'FPGUCOUNTRY_HD','FPGUCOUNTRY_HD','What Country(ies) Did You Grow Up In? (SR) (Ages Birth To Twelve):','FP','What Country(ies) Did You Grow Up In? (SR) (Ages Birth To Twelve):','Text','3','11/29/2013','TSQL Import: adb','45' UNION
SELECT NULL,'FPFHGUPUS','FPFHGUPUS','USA:','FP','USA:','CheckBox','3','11/29/2013','TSQL Import: adb','46' UNION
SELECT NULL,'FPFHGUPOTH','FPFHGUPOTH','Other:','FP','Other:','CheckBox','3','11/29/2013','TSQL Import: adb','47' UNION
SELECT NULL,'FPFHGUPOTHCO','FPFHGUPOTHCO','Country:','FP','Country:','SearchList','3','11/29/2013','TSQL Import: adb','48' UNION
SELECT NULL,'FPFHGUPUNK','FPFHGUPUNK','Unknown:','FP','Unknown:','CheckBox','3','11/29/2013','TSQL Import: adb','49' UNION
SELECT NULL,'FPSEX','FPSEX','Gender (SR):','FP','Gender (SR):','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','50' UNION
SELECT NULL,'FPSOECONSTAT_HD','FPSOECONSTAT_HD','<B>Socio-Economic Status</B>','FP','<B>Socio-Economic Status</B>','Text','3','11/29/2013','TSQL Import: adb','51' UNION
SELECT NULL,'FPDCLN','FPDCLN','Declined (SR):','FP','Declined (SR):','CheckBox','3','11/29/2013','TSQL Import: adb','52' UNION
SELECT NULL,'FPEDLVL','FPEDLVL','EducatiON Level (SR):','FP','EducatiON Level (SR):','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','53' UNION
SELECT NULL,'FPOCCLVL','FPOCCLVL','OccupatiON (SR):','FP','OccupatiON (SR):','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','54' UNION
SELECT NULL,'FPINC','FPINC','Income (SR):','FP','Income (SR):','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','55' UNION
SELECT NULL,'FPRACE','FPRACE','Race (SR):','FP','Race (SR):','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','56' UNION
SELECT NULL,'FPETHNIC','FPETHNIC','Ethnicity:','FP','Ethnicity:','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','57' UNION
SELECT NULL,'NBFMCODE','NBFMCODE','Family Member Suffix:','FP','Family Member Suffix:','Text','3','11/29/2013','TSQL Import: adb','58' UNION
SELECT NULL,'PFBRTHDATSR','PFBRTHDATSR','Date Of Birth (SR) (mm/dd/yyyy):','PF','Date Of Birth (SR) (mm/dd/yyyy):','DateTime','3','11/29/2013','TSQL Import: adb','1' UNION
SELECT NULL,'PFBRTHWT_HD','PFBRTHWT_HD','Birth Weight (Please enter weight in pounds AND ounces OR grams)','PF','Birth Weight (Please enter weight in pounds AND ounces OR grams)','Text','3','11/29/2013','TSQL Import: adb','2' UNION
SELECT NULL,'PFBRTHWTLB','PFBRTHWTLB','Pounds (lb)','PF','Pounds (lb)','Text','3','11/29/2013','TSQL Import: adb','3' UNION
SELECT NULL,'PFBRTHWTOZ','PFBRTHWTOZ','Ounces (oz)','PF','Ounces (oz)','Text','3','11/29/2013','TSQL Import: adb','4' UNION
SELECT NULL,'PFBRTHWTGR','PFBRTHWTGR','<b>Grams (g)</b>','PF','<b>Grams (g)</b>','Text','3','11/29/2013','TSQL Import: adb','5' UNION
SELECT NULL,'PFBRTHWTUNK','PFBRTHWTUNK','Unknown:','PF','Unknown:','CheckBox','3','11/29/2013','TSQL Import: adb','6' UNION
SELECT NULL,'PFCOUNTRYBRTH','PFCOUNTRYBRTH','Country Of Birth (SR):','PF','Country Of Birth (SR):','SearchList','3','11/29/2013','TSQL Import: adb','7' UNION
SELECT NULL,'PFGESTAGE','PFGESTAGE','Gestational Age At Time Of Birth (SR):','PF','Gestational Age At Time Of Birth (SR):','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','8' UNION
SELECT NULL,'PFGESTAGEWK','PFGESTAGEWK','Weeks:','PF','Weeks:','Text','3','11/29/2013','TSQL Import: adb','9' UNION
SELECT NULL,'PFGESTAGEUNK','PFGESTAGEUNK','Unknown:','PF','Unknown:','CheckBox','3','11/29/2013','TSQL Import: adb','10' UNION
SELECT NULL,'PFCURRWTLB','PFCURRWTLB','Current Weight (SR):','PF','Current Weight (SR):','Text','3','11/29/2013','TSQL Import: adb','11' UNION
SELECT NULL,'PFCURRWTUNK','PFCURRWTUNK','Unknown:','PF','Unknown:','CheckBox','3','11/29/2013','TSQL Import: adb','12' UNION
SELECT NULL,'PFCURRHT','PFCURRHT','Current Height (SR) Inches Only:','PF','Current Height (SR) Inches Only:','Text','3','11/29/2013','TSQL Import: adb','13' UNION
SELECT NULL,'PFCURRHTUNK','PFCURRHTUNK','Unknown:','PF','Unknown:','CheckBox','3','11/29/2013','TSQL Import: adb','14' UNION
SELECT NULL,'PFDIETTYPE','PFDIETTYPE','Diet Type (SR):','PF','Diet Type (SR):','DropDownList','3','11/29/2013','TSQL Import: adb','15' UNION
SELECT NULL,'PFSUPP_HD','PFSUPP_HD','Do You Take Any Of The Following?','PF','Do You Take Any Of The Following?','Text','3','11/29/2013','TSQL Import: adb','16' UNION
SELECT NULL,'PFSUPNON','PFSUPNON','None:','PF','None:','CheckBox','3','11/29/2013','TSQL Import: adb','17' UNION
SELECT NULL,'PFSUPUNK','PFSUPUNK','Unknown:','PF','Unknown:','CheckBox','3','11/29/2013','TSQL Import: adb','18' UNION
SELECT NULL,'PFSUPOTH','PFSUPOTH','Other Vitamins:','PF','Other Vitamins:','CheckBox','3','11/29/2013','TSQL Import: adb','19' UNION
SELECT NULL,'PFSUPOTHTYP','PFSUPOTHTYP','Type:','PF','Type:','Text','3','11/29/2013','TSQL Import: adb','20' UNION
SELECT NULL,'PFSUPHRB','PFSUPHRB','Herbs:','PF','Herbs:','CheckBox','3','11/29/2013','TSQL Import: adb','21' UNION
SELECT NULL,'PFSUPHRBTYP','PFSUPHRBTYP','Type:','PF','Type:','Text','3','11/29/2013','TSQL Import: adb','22' UNION
SELECT NULL,'PFSUPNUT','PFSUPNUT','Nutritional Supplements:','PF','Nutritional Supplements:','CheckBox','3','11/29/2013','TSQL Import: adb','23' UNION
SELECT NULL,'PFSUPNUTTYP','PFSUPNUTTYP','Type:','PF','Type:','LongText','3','11/29/2013','TSQL Import: adb','24' UNION
SELECT NULL,'PFSUPOTHD','PFSUPOTHD','Other Dietary Factors:','PF','Other Dietary Factors:','CheckBox','3','11/29/2013','TSQL Import: adb','25' UNION
SELECT NULL,'PFSUPOTHDTYP','PFSUPOTHDTYP','Type:','PF','Type:','Text','3','11/29/2013','TSQL Import: adb','26' UNION
SELECT NULL,'PFSH_HD','PFSH_HD','<B>Social History</B>','PF','<B>Social History</B>','Text','3','11/29/2013','TSQL Import: adb','27' UNION
SELECT NULL,'PFMARSTAT','PFMARSTAT','Marital Status (SR):','PF','Marital Status (SR):','DropDownList','3','11/29/2013','TSQL Import: adb','28' UNION
SELECT NULL,'PFZIP','PFZIP','Current Zip Code (SR):','PF','Current Zip Code (SR):','Text','3','11/29/2013','TSQL Import: adb','29' UNION
SELECT NULL,'PFZIPUNK','PFZIPUNK','Unknown:','PF','Unknown:','CheckBox','3','11/29/2013','TSQL Import: adb','30' UNION
SELECT NULL,'PFSMOKSTAT','PFSMOKSTAT','Smoking Status (SR):','PF','Smoking Status (SR):','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','31' UNION
SELECT NULL,'PFSMOKSTATC','PFSMOKSTATC','If Current Smoker, Cigarettes  Per Day:','PF','If Current Smoker, Cigarettes  Per Day:','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','32' UNION
SELECT NULL,'PFALCCONS','PFALCCONS','Alcohol ConsumptiON (SR):','PF','Alcohol ConsumptiON (SR):','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','33' UNION
SELECT NULL,'PFALCDRINKC','PFALCDRINKC','If Current Drinker, Drinks Per Day:','PF','If Current Drinker, Drinks Per Day:','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','34' UNION
SELECT NULL,'PFEXPHAZ','PFEXPHAZ','Exposure To Hazardous Chemicals (SR):','PF','Exposure To Hazardous Chemicals (SR):','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','35' UNION
SELECT NULL,'PFEXPHAZDAT','PFEXPHAZDAT','If Yes, Date Of Exposure:','PF','If Yes, Date Of Exposure:','DateTime','3','11/29/2013','TSQL Import: adb','36' UNION
SELECT NULL,'PFEXPHAZUNK','PFEXPHAZUNK','Unknown:','PF','Unknown:','CheckBox','3','11/29/2013','TSQL Import: adb','37' UNION
SELECT NULL,'PFEXPHAZTYP','PFEXPHAZTYP','If Yes, Type Of Exposure:','PF','If Yes, Type Of Exposure:','Text','3','11/29/2013','TSQL Import: adb','38' UNION
SELECT NULL,'PFEXTYPUNK','PFEXTYPUNK','Unknown:','PF','Unknown:','CheckBox','3','11/29/2013','TSQL Import: adb','39' UNION
SELECT NULL,'PFQUESFAMHIST_HD','PFQUESFAMHIST_HD','<B>Family History</B>','PF','<B>Family History</B>','Text','3','11/29/2013','TSQL Import: adb','40' UNION
SELECT NULL,'PFFHMBRTHCO','PFFHMBRTHCO','Your Mothers Country Of Birth (SR):','PF','Your Mothers Country Of Birth (SR):','SearchList','3','11/29/2013','TSQL Import: adb','41' UNION
SELECT NULL,'PFFHFBRTHCO','PFFHFBRTHCO','Your Fathers Country Of Birth (SR):','PF','Your Fathers Country Of Birth (SR):','SearchList','3','11/29/2013','TSQL Import: adb','42' UNION
SELECT NULL,'PFGUCOUNTRY_HD','PFGUCOUNTRY_HD','What Country(ies) Did You Grow Up In? (SR) (Ages Birth To Twelve):','PF','What Country(ies) Did You Grow Up In? (SR) (Ages Birth To Twelve):','Text','3','11/29/2013','TSQL Import: adb','43' UNION
SELECT NULL,'PFFHGUPUS','PFFHGUPUS','USA:','PF','USA:','CheckBox','3','11/29/2013','TSQL Import: adb','44' UNION
SELECT NULL,'PFFHGUPOTH','PFFHGUPOTH','Other:','PF','Other:','CheckBox','3','11/29/2013','TSQL Import: adb','45' UNION
SELECT NULL,'PFFHGUPOTHCO','PFFHGUPOTHCO','Country:','PF','Country:','SearchList','3','11/29/2013','TSQL Import: adb','46' UNION
SELECT NULL,'PFFHGUPUNK','PFFHGUPUNK','Unknown:','PF','Unknown:','CheckBox','3','11/29/2013','TSQL Import: adb','47' UNION
SELECT NULL,'PFSEX','PFSEX','Gender (SR):','PF','Gender (SR):','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','48' UNION
SELECT NULL,'PFSOECONSTAT_HD','PFSOECONSTAT_HD','<B>Socio-Economic Status</B>','PF','<B>Socio-Economic Status</B>','Text','3','11/29/2013','TSQL Import: adb','49' UNION
SELECT NULL,'PFDCLN','PFDCLN','Declined (SR):','PF','Declined (SR):','CheckBox','3','11/29/2013','TSQL Import: adb','50' UNION
SELECT NULL,'PFEDLVL','PFEDLVL','EducatiON Level (SR):','PF','EducatiON Level (SR):','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','51' UNION
SELECT NULL,'PFOCCLVL','PFOCCLVL','OccupatiON (SR):','PF','OccupatiON (SR):','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','52' UNION
SELECT NULL,'PFOCCRET','PFOCCRET','If Retired:','PF','If Retired:','Text','3','11/29/2013','TSQL Import: adb','53' UNION
SELECT NULL,'PFINC','PFINC','Income (SR):','PF','Income (SR):','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','54' UNION
SELECT NULL,'PFRACE','PFRACE','Race (SR):','PF','Race (SR):','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','55' UNION
SELECT NULL,'PFETHNIC','PFETHNIC','Ethnicity:','PF','Ethnicity:','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','56' UNION
SELECT NULL,'NBFMCODE','NBFMCODE','Family Member Suffix:','PF','Family Member Suffix:','Text','3','11/29/2013','TSQL Import: adb','57' UNION
SELECT NULL,'NBFMCODE','NBFMCODE','Family Member Suffix:','MED','Family Member Suffix:','Text','3','11/29/2013','TSQL Import: adb','1' UNION
SELECT NULL,'MHRPT','MHRPT','Are there any conditions to report?','MED','Are there any conditions to report?','RadioButtON (Vertical)','3','11/29/2013','TSQL Import: adb','2' UNION
SELECT NULL,'MHNAMHD','MHNAMHD','Condition:','MED','Condition:','DropDownList','3','11/29/2013','TSQL Import: adb','3' UNION
SELECT NULL,'MHSRHD','MHSRHD','Self-Report:','MED','Self-Report:','CheckBox','3','11/29/2013','TSQL Import: adb','4' UNION
SELECT NULL,'MHFAMHXHD','MHFAMHXHD','Fam HX:','MED','Fam HX:','CheckBox','3','11/29/2013','TSQL Import: adb','5' UNION
SELECT NULL,'MHTYPOTH','MHTYPOTH','Type:','MED','Type:','LongText','3','11/29/2013','TSQL Import: adb','6' ;

--surveys 
--6 month baby

INSERT INTO ITMIDW.[itmi].[tblCrfFields]([crfVersionID],[sourceSystemFieldID],[fieldName],[fieldDescription],[cdeID],[questionText],[dataType],[orgSourceSystemID],[createDate],[createdBy], crfSourceSystemFieldOrder)
SELECT 
--[crfVersionID]
(SELECT v.crfVersionID from itmidw.tblCrfVersion v where v.crfVersionName = '6MonthBaby: v1')
--,[sourceSystemFieldID]
,[baby6].ColumnInTbl 
--,[fieldName]
, REPLACE([baby6].realText ,'"','') 
--,[fieldDescription]
, REPLACE([baby6].realText ,'"','') 
--,[cdeID]
, NULL
--,[questionText]
, REPLACE([baby6].realText ,'"','') 
--,[dataType]
, NULL
--,[orgSourceSystemID]
, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS [orgSourceSystemID]
, GETDATE() [createDate]
, 'usp_Study102Crf' AS [createdBy]
, NULL
--select * 
FROM [ITMIStaging].[dbo].[NoviBaby6Survey_Definition] [baby6]
where [baby6].ColumnInTbl  <> ''



--NoviMom6Survey_Definition 
INSERT INTO ITMIDW.[tblCrfFields]([crfVersionID],[sourceSystemFieldID],[fieldName],[fieldDescription],[cdeID],[questionText],[dataType],[orgSourceSystemID],[createDate],[createdBy], crfSourceSystemFieldOrder)
SELECT 
--[crfVersionID]
(SELECT v.crfVersionID from itmidw.tblCrfVersion v where v.crfVersionName = '6MonthMom: v1')
--,[sourceSystemFieldID]
,[baby6].ColumnInTbl 
--,[fieldName]
, REPLACE([baby6].realText ,'"','') 
--,[fieldDescription]
, REPLACE([baby6].realText ,'"','') 
--,[cdeID]
, NULL
--,[questionText]
, REPLACE([baby6].realText ,'"','') 
--,[dataType]
, NULL
--,[orgSourceSystemID]
, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS [orgSourceSystemID]
, GETDATE() [createDate]
, 'usp_Study102Crf' AS [createdBy]
, NULL
--select * 
FROM [ITMIStaging].[dbo].[NoviMom6Survey_Definition] [baby6]
where [baby6].ColumnInTbl  <> ''

--NoviBaby12Survey_Definition
INSERT INTO ITMIDW.[tblCrfFields]([crfVersionID],[sourceSystemFieldID],[fieldName],[fieldDescription],[cdeID],[questionText],[dataType],[orgSourceSystemID],[createDate],[createdBy], crfSourceSystemFieldOrder)
SELECT 
--[crfVersionID]
(SELECT v.crfVersionID from itmidw.tblCrfVersion v where v.crfVersionName = '12MonthBaby: v1')
--,[sourceSystemFieldID]
,[baby6].ColumnInTbl 
--,[fieldName]
, REPLACE([baby6].realText ,'"','') 
--,[fieldDescription]
, REPLACE([baby6].realText ,'"','') 
--,[cdeID]
, NULL
--,[questionText]
, REPLACE([baby6].realText ,'"','') 
--,[dataType]
, NULL
--,[orgSourceSystemID]
, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS [orgSourceSystemID]
, GETDATE() [createDate]
, 'usp_Study102Crf' AS [createdBy]
, NULL
--select * 
FROM [ITMIStaging].[dbo].[NoviBaby12Survey_Definition] [baby6]
where [baby6].ColumnInTbl  <> ''

--NoviMom12Survey_Definition
INSERT INTO ITMIDW.[tblCrfFields]([crfVersionID],[sourceSystemFieldID],[fieldName],[fieldDescription],[cdeID],[questionText],[dataType],[orgSourceSystemID],[createDate],[createdBy], crfSourceSystemFieldOrder)
SELECT 
--[crfVersionID]
(SELECT v.crfVersionID from itmidw.tblCrfVersion v where v.crfVersionName = '12MonthMom: v1')
--,[sourceSystemFieldID]
,[baby6].ColumnInTbl 
--,[fieldName]
, REPLACE([baby6].realText ,'"','') 
--,[fieldDescription]
, REPLACE([baby6].realText ,'"','') 
--,[cdeID]
, NULL
--,[questionText]
, REPLACE([baby6].realText ,'"','') 
--,[dataType]
, NULL
--,[orgSourceSystemID]
, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS [orgSourceSystemID]
, GETDATE() [createDate]
, 'usp_Study102Crf' AS [createdBy]
, NULL
--select * 
FROM [ITMIStaging].[dbo].[NoviMom12Survey_Definition] [baby6]
where [baby6].ColumnInTbl  <> ''

--NoviBaby18Survey_Definition
INSERT INTO itmidw.[tblCrfFields]([crfVersionID],[sourceSystemFieldID],[fieldName],[fieldDescription],[cdeID],[questionText],[dataType],[orgSourceSystemID],[createDate],[createdBy], crfSourceSystemFieldOrder)
SELECT 
--[crfVersionID]
(SELECT v.crfVersionID from itmidw.tblCrfVersion v where v.crfVersionName = '18MonthBaby: v1')
--,[sourceSystemFieldID]
,[baby6].ColumnInTbl 
--,[fieldName]
, REPLACE([baby6].realText ,'"','') 
--,[fieldDescription]
, REPLACE([baby6].realText ,'"','') 
--,[cdeID]
, NULL
--,[questionText]
, REPLACE([baby6].realText ,'"','') 
--,[dataType]
, NULL
--,[orgSourceSystemID]
, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS [orgSourceSystemID]
, GETDATE() [createDate]
, 'usp_Study102Crf' AS [createdBy]
, NULL
--select * 
FROM [ITMIStaging].[dbo].[NoviBaby18Survey_Definition] [baby6]
where [baby6].ColumnInTbl  <> ''

--NoviMom18Survey_Definition
INSERT INTO ITMIDW.[tblCrfFields]([crfVersionID],[sourceSystemFieldID],[fieldName],[fieldDescription],[cdeID],[questionText],[dataType],[orgSourceSystemID],[createDate],[createdBy], crfSourceSystemFieldOrder)
SELECT 
--[crfVersionID]
(SELECT v.crfVersionID from itmidw.tblCrfVersion v where v.crfVersionName = '18MonthMom: v1')
--,[sourceSystemFieldID]
,[baby6].ColumnInTbl 
--,[fieldName]
, REPLACE([baby6].realText ,'"','') 
--,[fieldDescription]
, REPLACE([baby6].realText ,'"','') 
--,[cdeID]
, NULL
--,[questionText]
, REPLACE([baby6].realText ,'"','') 
--,[dataType]
, NULL
--,[orgSourceSystemID]
, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS [orgSourceSystemID]
, GETDATE() [createDate]
, 'usp_Study102Crf' AS [createdBy]
, NULL
--select * 
FROM [ITMIStaging].[dbo].[NoviMom18Survey_Definition] [baby6]
where [baby6].ColumnInTbl  <> ''



--***Need - survey FieldID's
INSERT INTO ITMIDW.[dbo].[tblCrfFields]([crfVersionID],[sourceSystemFieldID],[fieldName],[fieldDescription],[cdeID],[questionText],[dataType],[orgSourceSystemID],[createDate],[createdBy], crfSourceSystemFieldOrder)

--tblCrfFieldOptions

INSERT INTO [dbo].[tblCrfFieldOptions]
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
		vers.crfVersionID
           --,<sourceSystemCrfVersionID, int,>
		,vers.sourceSystemCrfVersionID
           --,<fieldID, int,>
		,crfFields.fieldID
           --,<optionLabel, varchar(200),>
		, dd.userDataString 
           --,<optionValue, varchar(200),>
        , dd.codedData
        , (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS [orgSourceSystemID]
		, GETDATE() [createDate]
		, 'usp_Study102Crf' AS [createdBy]
FROM dbo.[Study102Fields] F
	INNER JOIN dbo.[DataDictionaryEntries] dd
		on dd.dataDictionaryName = f.dataDictionaryName
	INNER JOIN itmidw.tblcrfFields crfFields
		on crfFields.sourceSystemFieldId = f.fieldOID
	INNER JOIN itmidw.tblcrfversion vers
		on vers.crfVersionID = crfFields.crfVersionID





*/
END


