IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'itmidw.[usp_Study101Specimen_SpecimenFamily]') AND type in (N'P', N'PC'))
DROP PROCEDURE itmidw.[usp_Study101Specimen_SpecimenFamily]
GO
/**************************************************************************
Created On : 3/29/2014
Created By : Aaron Black
Team Name : Informatics
Object name : [usp_Study101Specimen_SpecimenFamily]
Functional : ITMI SSIS for Insert and Update for study 102 tblSpecimen and TblSpecimenFamily
 Specimen and Specimen Family
History : Created on 3/29/2014
**************************************************************************
Date Modified By QC# Purposes
**************************************************************************
#Date #Comment
**************************************************************************
USE CASE:
truncate table tblspecimen
EXEC [usp_Study101Specimen_SpecimenFamily]

select *
from tblspecimen
**************************************************************************/
CREATE PROCEDURE itmidw.[usp_Study101Specimen_SpecimenFamily]
AS
BEGIN
SET NOCOUNT ON;
DECLARE @UpdatedOn SMALLDATETIME
SET @UpdatedOn = CAST(GETDATE() AS SMALLDATETIME)
PRINT CONVERT(CHAR(23), @UpdatedOn, 121) + ' [usp_Study101Specimen_SpecimenFamily][' + @@SERVERNAME + '][' + SYSTEM_USER + ']'
PRINT 'INSERT [ITMIDW].itmidw.[usp_Study101Specimen_SpecimenFamily]...'

--*************************************
--******************102****************
--*************************************
--drop table
IF OBJECT_ID('tempdb..#SourceSpecimen') IS NOT NULL
DROP TABLE #sourceSpecimen

IF OBJECT_ID('tempdb..#sourceSpecimenFamily') IS NOT NULL
DROP TABLE #sourceSpecimenFamily

--nautilus aliquots
SELECT 
			CONVERT(VARCHAR(100),ROW_NUMBER() OVER(ORDER BY sub.subjectID))  as [sourceSystemSpecimenID]
		   , CONVERT(VARCHAR(100),ROW_NUMBER() OVER(ORDER BY sub.subjectID)) as specimenBarcode
           , Sub.[subjectID] as SubjectID
           , NULL as [specimenFamilyID] --get later
           , (select t.specimenSampleTypeID from tblSpecimenSampleType t where specimenTypeName = 'Blood') as [specimenSampleTypeID]
           , NULL as [specimenPhysicalTypeID]
           , NULL as [location] --location_ID
           , NULL as [prepType]
           , NULL as [specimenOriginalWeight]
           , NULL as [weightVolume]
           , NULL as [units]
           , NULL as [pooledFlag]
           , NULL  as [disposedFlag]
           , NULL as [receivedFromOutSideOrgFlag]
           , NULL as [createdInErrorFlag]
           , NULL as [isActiveFlag]
           , NULL as [specimenUUID]
           , NULL as [initialWeightVolume]
           , NULL as [custodyDate]
		   , NULL as containerType
		   , NULL as  collectedFlag
           , (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'INFOPATH') as [orgSourceSystemID]
           , GETDATE() [createDate]
           ,'usp_Study101Specimen_SpecimenFamily: Manufactured' as [createdBy]
		INTO #SourceSpecimen
	from itmidw.tblSubject sub
		inner join itmidw.tblStudy study
			ON study.studyID = sub.studyID
	WHERE study.studyShortID = '101'
	
		
		
--SpecimenFamily


--Slowly changing dimension
MERGE  itmidw.[tblSpecimen] AS targetSpecimen
USING #sourceSpecimen ss
	ON targetSpecimen.[sourceSystemSpecimenID] = ss.[sourceSystemSpecimenID]
WHEN MATCHED
	AND (
		   ss.specimenBarcode <> targetSpecimen.specimenBarcode OR
           ss.SubjectID <> targetSpecimen.SubjectID OR
           ss.[specimenFamilyID]  <> targetSpecimen.[specimenFamilyID] OR
           ss.[specimenSampleTypeID] <> targetSpecimen.specimenSampleTypeID OR
           ss.[specimenPhysicalTypeID] <> targetSpecimen.[specimenPhysicalTypeID] OR
           ss.[location]  <> targetSpecimen.[location] OR
           ss.[prepType] <> targetSpecimen.prepType OR
           ss.[specimenOriginalWeight] <> targetSpecimen.[specimenOriginalWeight] OR
           ss.[weightVolume] <> targetSpecimen.[weightVolume] OR
           ss.[units] <> targetSpecimen.units OR
           ss.[pooledFlag] <> targetSpecimen.pooledFlag OR
           ss.[disposedFlag] <> targetSpecimen.disposedFlag OR
           ss.[receivedFromOutSideOrgFlag] <> targetSpecimen.[receivedFromOutSideOrgFlag] OR
           ss.[createdInErrorFlag] <> targetSpecimen.[createdInErrorFlag] OR
           ss.[isActiveFlag] <> targetSpecimen.[isActiveFlag] OR
           ss.[specimenUUID] <> targetSpecimen.[specimenUUID] OR
           ss.[initialWeightVolume] <> targetSpecimen.[initialWeightVolume] OR
           ss.[custodyDate] <> targetSpecimen.[custodyDate] OR
		   ss.[orgSourceSystemID] <> targetSpecimen.[orgSourceSystemID] OR  
		   ss.[createDate] <> targetSpecimen.[createDate] OR
		   ss.[createdBy] <> targetSpecimen.[createdBy] 
	)
THEN UPDATE SET
	 	   specimenBarcode = targetSpecimen.specimenBarcode 
           ,SubjectID = targetSpecimen.SubjectID 
           ,[specimenFamilyID]  = targetSpecimen.[specimenFamilyID]
           ,[specimenSampleTypeID] = targetSpecimen.specimenSampleTypeID
           ,[specimenPhysicalTypeID] = targetSpecimen.[specimenPhysicalTypeID]
           ,[location]  = targetSpecimen.[location]
           ,[prepType] = targetSpecimen.prepType
           ,[specimenOriginalWeight] = targetSpecimen.[specimenOriginalWeight]
           ,[weightVolume] = targetSpecimen.[weightVolume]
           ,[units] = targetSpecimen.units
           ,[pooledFlag] = targetSpecimen.pooledFlag
           ,[disposedFlag] = targetSpecimen.disposedFlag
           ,[receivedFromOutSideOrgFlag] = targetSpecimen.[receivedFromOutSideOrgFlag]
           ,[createdInErrorFlag] = targetSpecimen.[createdInErrorFlag]
           ,[isActiveFlag] = targetSpecimen.[isActiveFlag]
           ,[specimenUUID] = targetSpecimen.[specimenUUID]
           ,[initialWeightVolume] = targetSpecimen.[initialWeightVolume]
           ,[custodyDate] = targetSpecimen.[custodyDate]
		   ,[orgSourceSystemID] = targetSpecimen.[orgSourceSystemID]  
		   ,[createDate] = targetSpecimen.[createDate]
		   ,[createdBy] = targetSpecimen.[createdBy] 

WHEN NOT MATCHED THEN

INSERT (
			[sourceSystemSpecimenID]
		   , specimenBarcode
           , SubjectID
           , [specimenFamilyID] 
           , [specimenSampleTypeID]
           , [specimenPhysicalTypeID]
           , [location]
           , [prepType]
           , [specimenOriginalWeight]
           , [weightVolume]
           , [units]
           , [pooledFlag]
           , [disposedFlag]
           , [receivedFromOutSideOrgFlag]
           , [createdInErrorFlag]
           , [isActiveFlag]
           , [specimenUUID]
           , [initialWeightVolume]
           , [custodyDate]
           , [orgSourceSystemID]
           , [createDate]
           , [createdBy]
)
VALUES (
			ss.[sourceSystemSpecimenID]
		   , ss.specimenBarcode
           , ss.SubjectID
           , ss.[specimenFamilyID] 
           , ss.[specimenSampleTypeID]
           , ss.[specimenPhysicalTypeID]
           , ss.[location]
           , ss.[prepType]
           , ss.[specimenOriginalWeight]
           , ss.[weightVolume]
           , ss.[units]
           , ss.[pooledFlag]
           , ss.[disposedFlag]
           , ss.[receivedFromOutSideOrgFlag]
           , ss.[createdInErrorFlag]
           , ss.[isActiveFlag]
           , ss.[specimenUUID]
           , ss.[initialWeightVolume]
           , ss.[custodyDate]
           , ss.[orgSourceSystemID]
           , ss.[createDate]
           , ss.[createdBy]
);

PRINT CAST(@@ROWCOUNT AS VARCHAR(10))+ ' row(s) updated.'

END


