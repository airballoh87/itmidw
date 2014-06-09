IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'itmidw.[usp_Study102Specimen_SpecimenFamily]') AND type in (N'P', N'PC'))
DROP PROCEDURE itmidw.[usp_Study102Specimen_SpecimenFamily]
GO
/**************************************************************************
Created On : 3/29/2014
Created By : Aaron Black
Team Name : Informatics
Object name : [usp_Study102Specimen_SpecimenFamily]
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
EXEC [usp_Study102Specimen_SpecimenFamily]

select *
from tblspecimen
**************************************************************************/
CREATE PROCEDURE itmidw.[usp_Study102Specimen_SpecimenFamily]
AS
BEGIN
SET NOCOUNT ON;
DECLARE @UpdatedOn SMALLDATETIME
SET @UpdatedOn = CAST(GETDATE() AS SMALLDATETIME)
PRINT CONVERT(CHAR(23), @UpdatedOn, 121) + ' [usp_Study102Specimen_SpecimenFamily][' + @@SERVERNAME + '][' + SYSTEM_USER + ']'
PRINT 'INSERT [ITMIDW].itmidw.[usp_Study102Specimen_SpecimenFamily]...'

--*************************************
--******************102****************
--*************************************
--drop table
IF OBJECT_ID('tempdb..#SourceSpecimen') IS NOT NULL
DROP TABLE #sourceSpecimen

IF OBJECT_ID('tempdb..#sourceSpecimenFamily') IS NOT NULL
DROP TABLE #sourceSpecimenFamily

--nautilus aliquots
SELECT DISTINCT
			CONVERT(VARCHAR(100),al.ALIQUOT_ID) as [sourceSystemSpecimenID]
			,CONVERT(VARCHAR(100),al.EXTERNAL_REFERENCE) as specimenBarcode
           , Sub.[subjectID] as SubjectID
           , NULL as [specimenFamilyID] --get later
           , CONVERT(VARCHAR(100),st.specimenSampleTypeID) as [specimenSampleTypeID]
           , CONVERT(VARCHAR(100),matrix_type) as [specimenPhysicalTypeID]
           , NULL as [location] --location_ID
           , NULL as [prepType]
           , CONVERT(VARCHAR(100),au.U_INITIAL_VOLUME) as [specimenOriginalWeight]
           , CONVERT(VARCHAR(100),au.U_CURRENT_VOLUME) as [weightVolume]
           , CONVERT(VARCHAR(100),u.DESCRIPTION)as [units]
           , NULL as [pooledFlag]
           , AU.U_DISPOSED  as [disposedFlag]
           , NULL as [receivedFromOutSideOrgFlag]
           , NULL as [createdInErrorFlag]
           , NULL as [isActiveFlag]
           , NULL as [specimenUUID]
           , au.U_INITIAL_VOLUME as initialWeightVolume --*Change to initial volume
           , NULL as [custodyDate]
		   , CONVERT(VARCHAR(100),ct.name) as containerType
		   , CASE WHEN ISNULL(au.U_COLLECTED,'N') = 'T' THEN 'Y' ELSE 'N' END as collectedFlag
           , (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
           , GETDATE() [createDate]
           ,'usp_Study102Specimen_SpecimenFamily: Aliquot' as [createdBy]
		   --new
           , AL.NEEDS_REVIEW as needsReview
           , AL.PLATE_COLUMN as plateColumn
           , AL.PLATE_ORDER as plateOrder
           , AL.PLATE_ROW as plateRow
           , AL.STATUS as [status]
           , AL.PLATE_ID as plateID
           , AL.SAMPLE_ID as sourceSystemSampleId
           , AU.U_AVAILABILITY as [availability]
           , AU.U_COLLECTED as collected
           , AU.U_COLLECTED_BY as collectedBy
           , AU.U_COLLECTION_DATE as collectionDate
           , AU.U_COMMENT as comment
           , AU.U_CONSUMED as consumedFlag
           , AU.U_CURRENT_VOLUME as currentVolume
           , AU.U_EXTRACTION_TYPE as extractionType
           , AU.U_LAB_CONDITION as labCondition
           , AU.U_LAB_STATUS as labStatus
           , AU.U_SOURCE_SYSTEM_NAME as sourceSystemName
           , AU.U_SOURCE_SYSTEM_ID as sourceSystemID
           , AL.CREATED_ON as sourceSystemCreatedDate
		   , AL.CREATED_BY as sourceSystemCreatedBy
INTO #sourceSpecimen
	from [nautilus].[ALIQUOT] al
		INNER JOIN nautilus.ALIQUOT_USER AU 
			ON al.ALIQUOT_ID = AU.ALIQUOT_ID
		INNER JOIN nautilus.sample s
			on s.SAMPLE_ID = al.SAMPLE_ID
		INNER JOIN nautilus.SAMPLE_USER SU 
			ON S.SAMPLE_ID = SU.SAMPLE_ID
		LEFT JOIN [nautilus].[UNIT] u
			ON u.UNIT_ID  = al.UNIT_ID
		LEFT JOIN [nautilus].[CONTAINER_TYPE] ct
			on ct.CONTAINER_TYPE_ID = al.CONTAINER_TYPE_ID
		LEFT JOIN nautilus.[ALIQUOT_TEMPLATe] alTemplate
			on alTemplate.ALIQUOT_TEMPLATE_ID = al.ALIQUOT_TEMPLATE_ID
		LEFT JOIN itmidw.tblSpecimenSampleType st
			on st.specimenTypeName = al.matrix_type
		LEFT JOIN itmidw.tblSubject sub
			on sub.sourceSystemIDLabel =  replace(LEFT(s.EXTERNAL_REFERENCE,4) + SUBSTRING(s.EXTERNAL_REFERENCE,8,10),'[','')
	WHERE s.group_id = 22 ---Study

--nautulis sample
INSERT INTO  #sourceSpecimen (
			[sourceSystemSpecimenID]
		   ,specimenBarcode
           , SubjectID
           , [specimenFamilyID] --get later
           , [specimenSampleTypeID]
           , [specimenPhysicalTypeID]
           , [location] --location_ID
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
		   , containerType
		   , collectedFlag
           , [orgSourceSystemID]
           , [createDate]
           , [createdBy]
		   , [needsReview]
           , [plateColumn]
           , [plateOrder]
           , [plateRow]
           , [status]
           , [plateID]
           , [sourceSystemSampleId]
           , [availability]
           , [collected]
           , [collectedBy]
           , [collectionDate]
           , [comment]
           , [consumedFlag]
           , [currentVolume]
           , [extractionType]
           , [labCondition]
           , [labStatus]
           , [sourceSystemName]
           , [sourceSystemID]

)
SELECT DISTINCT
			sa.SAMPLE_ID as [sourceSystemSpecimenID]
			,sa.EXTERNAL_REFERENCE as specimenBarcode
           , Sub.[subjectID] as SubjectID
           , NULL as [specimenFamilyID] --get later
           , st.specimenSampleTypeID as [specimenSampleTypeID]
           , NULL as [specimenPhysicalTypeID]
           , NULL as [location] --location_ID
           , NULL as [prepType]
           , NULL as [specimenOriginalWeight]
           , NULL as [weightVolume]
           , NULL as [units]
           , NULL as [pooledFlag]
           , NULL as [disposedFlag]
           , NULL as [receivedFromOutSideOrgFlag]
           , NULL as [createdInErrorFlag]
           , NULL as [isActiveFlag]
           , NULL as [specimenUUID]
           , NULL as [initialWeightVolume]
           , NULL as [custodyDate]
		   , NULL as containerType
		   , '' as collectedFlag
           , (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
           , GETDATE() [createDate]
           ,'usp_Study102Specimen_SpecimenFamily: Sample' as [createdBy]
		   , NULL as [needsReview]
           , NULL as [plateColumn]
           , NULL as  [plateOrder]
           , NULL as  [plateRow]
           , NULL as  [status]
           , NULL as  [plateID]
           , NULL as  [sourceSystemSampleId]
           , NULL as  [availability]
           , NULL as  [collected]
           , NULL as  [collectedBy]
           , NULL as  [collectionDate]
           , NULL as  [comment]
           , NULL as  [consumedFlag]
           , NULL as  [currentVolume]
           , NULL as  [extractionType]
           , NULL as  [labCondition]
           , NULL as  [labStatus]
           , NULL as  [sourceSystemName]
           , NULL as  [sourceSystemID]
	FROM  nautilus.sample sa
		LEFT JOIN itmidw.tblSubject sub
			on sub.sourceSystemIDLabel =  replace(LEFT(sa.EXTERNAL_REFERENCE,4) + SUBSTRING(sa.EXTERNAL_REFERENCE,8,10),'[','')
		LEFT JOIN itmidw.tblSpecimenSampleType st
			on st.specimenTypeName = sa.SAMPLE_TYPE

		
--SpecimenFamily

/*
SELECT 
    [sourceSystemSpecimenFamilyID]
    ,[subjectID]
    ,[receivedDate]
    ,[sourceOrganizationID]
    ,[specimenPhysicalTypeID]
    ,[specimenSampleTypeID]
    ,[specimenAnatomicalSiteID]
    ,[orgSourceSystemID]
    ,[createDate]
    ,[createdBy]
  INTO #sourceSpecimenFamily
--select *
FROM itmidw.tblSpecimen specimen
	INNER JOIN nautilus.aliquot al
		on al.ALIQUOT_ID = specimen.sourceSystemSpecimenID
	LEFT JOIN nautilus.ALIQUOT_FORMULATION alForm
		on alForm.PARENT_ALIQUOT_ID = al.aliquot_ID
*/




--Slowly changing dimension
MERGE  itmidw.[tblSpecimen] AS targetSpecimen
USING #sourceSpecimen ss
	ON targetSpecimen.[sourceSystemSpecimenID] = ss.[sourceSystemSpecimenID]
		AND ss.[createdBy] = targetSpecimen.[createdBy] 
		AND ss.[orgSourceSystemID] = targetSpecimen.[orgSourceSystemID]
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
		   ss.[createDate] <> targetSpecimen.[createDate]  OR  
		   ss.[needsReview] <> targetSpecimen.[needsReview] OR  
           ss.[plateColumn] <> targetSpecimen.[plateColumn] OR  
           ss.[plateOrder] <> targetSpecimen.[plateOrder] OR  
           ss.[plateRow] <> targetSpecimen.[plateRow] OR  
           ss.[status] <> targetSpecimen.[status] OR  
           ss.[plateID] <> targetSpecimen.[plateID] OR  
           ss.[sourceSystemSampleId] <> targetSpecimen.[sourceSystemSampleId] OR  
           ss.[availability] <> targetSpecimen.[availability] OR  
           ss.[collected] <> targetSpecimen.[collected] OR  
           ss.[collectedBy] <> targetSpecimen.[collectedBy] OR  
           ss.[collectionDate] <> targetSpecimen.[collectionDate] OR  
           ss.[comment] <> targetSpecimen.[comment] OR  
           ss.[consumedFlag] <> targetSpecimen.[consumedFlag] OR  
           ss.[currentVolume] <> targetSpecimen.[currentVolume] OR  
           ss.[extractionType] <> targetSpecimen.[extractionType] OR  
           ss.[labCondition] <> targetSpecimen.[labCondition] OR  
           ss.[labStatus] <> targetSpecimen.[labStatus] OR  
           ss.[sourceSystemName] <> targetSpecimen.[sourceSystemName] OR  
           ss.[sourceSystemID] <> targetSpecimen.[sourceSystemID]
		   
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
		   ,[needsReview] = targetSpecimen.[needsReview]
           ,[plateColumn] = targetSpecimen.[plateColumn]
           ,[plateOrder] = targetSpecimen.[plateOrder]
           ,[plateRow] = targetSpecimen.[plateRow]
           ,[status] = targetSpecimen.[status]
           ,[plateID] = targetSpecimen.[plateID]
           ,[sourceSystemSampleId] = targetSpecimen.[sourceSystemSampleId]
           ,[availability] = targetSpecimen.[availability]
           ,[collected] = targetSpecimen.[collected]
           ,[collectedBy] = targetSpecimen.[collectedBy]
           ,[collectionDate] = targetSpecimen.[collectionDate]
           ,[comment] = targetSpecimen.[comment]
           ,[consumedFlag] = targetSpecimen.[consumedFlag]
           ,[currentVolume] = targetSpecimen.[currentVolume]
           ,[extractionType] = targetSpecimen.[extractionType]
           ,[labCondition] = targetSpecimen.[labCondition]
           ,[labStatus] = targetSpecimen.[labStatus]
           ,[sourceSystemName] = targetSpecimen.[sourceSystemName]
           ,[sourceSystemID] = targetSpecimen.[sourceSystemID]

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
		   , [needsReview]
           , [plateColumn]
           , [plateOrder]
           , [plateRow]
           , [status]
           , [plateID]
           , [sourceSystemSampleId]
           , [availability]
           , [collected]
           , [collectedBy]
           , [collectionDate]
           , [comment]
           , [consumedFlag]
           , [currentVolume]
           , [extractionType]
           , [labCondition]
           , [labStatus]
           , [sourceSystemName]
           , [sourceSystemID]
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
		   , ss.[needsReview]
           , ss.[plateColumn]
           , ss.[plateOrder]
           , ss.[plateRow]
           , ss.[status]
           , ss.[plateID]
           , ss.[sourceSystemSampleId]
           , ss.[availability]
           , ss.[collected]
           , ss.[collectedBy]
           , ss.[collectionDate]
           , ss.[comment]
           , ss.[consumedFlag]
           , ss.[currentVolume]
           , ss.[extractionType]
           , ss.[labCondition]
           , ss.[labStatus]
           , ss.[sourceSystemName]
           , ss.[sourceSystemID]
);

PRINT CAST(@@ROWCOUNT AS VARCHAR(10))+ ' row(s) updated.'

--specimen Family Insert

END


