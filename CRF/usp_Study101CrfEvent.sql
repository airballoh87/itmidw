IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'itmidw.[usp_Study101CrfEvent]') AND type in (N'P', N'PC'))
DROP PROCEDURE itmidw.[usp_Study101CrfEvent]
GO	
/**************************************************************************
Created On : 4/1/2014
Created By : Aaron Black
Team Name : Informatics
Object name : [usp_Study101CrfEvent]
Functional : ITMI SSIS for Insert and Update for study 101 crf event
Purpose : Import of study 101, this designates the event for any subject occurence that is data senstive
History : Created on 4/1/2014
*************************************************************************
Date Modified By QC# Purposes
**************************************************************************
#Date #Comment
**************************************************************************
USE CASE:
EXEC [usp_Study101CrfEvent]
--testing update and delete
**************************************************************************/
CREATE PROCEDURE itmidw.[usp_Study101CrfEvent]
AS
BEGIN
SET NOCOUNT ON;
DECLARE @UpdatedOn SMALLDATETIME
SET @UpdatedOn = CAST(GETDATE() AS SMALLDATETIME)
PRINT CONVERT(CHAR(23), @UpdatedOn, 121) + ' [usp_Study101CrfEvent][' + @@SERVERNAME + '][' + SYSTEM_USER + ']'
PRINT 'INSERT itmidw.[usp_Study101CrfEvent]...'


--*************************************
--******************101****************
--*************************************

/*
INSERT INTO itmidw.[tblCrfEvent]([EventID],[sourceSystemCrfEventID],[crfID],[crfVersionID],[subjectID],[crfStatus],[UPDATEdDate],[completedDate],[studyID],[eventCrfUUID],[formOrdinal],[orgSourceSystemID],[createDate],[createdBy])
SELECT 
	e.eventID
	, sourceSystemEventID
	, crf.crfID
	, ver.crfVersionID
	, e.subjectID
	, NULL AS crfStatus
	, NULL AS UPDATEdDate
	, NULL AS CompletedDate
	, e.studyID 
	, NULL AS eventCrfUUID
	, NULL AS FormOrdinal
	, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'INFOPATH') AS [orgSourceSystemID]
	, GETDATE()
	, 'usp_Study101CrfEvent' 
FROM itmidw.TBLEVENT e
	INNER JOIN  itmidw.tblcrf crf
		ON LTRIM(RTRIM(crf.crfShortName)) = LTRIM(RTRIM(LEFT(e.sourceSystemEventID,CHARINDEX(':',e.sourceSystemEventID)-1)))
			and crf.orgSourceSystemID = 6
	INNER JOIN itmidw.tblCrfVersiON ver
		ON ver.crfID = crf.crfID
WHERE e.orgSourceSystemID = 6	
	AND e.eventtype = 'Clinical Report Form'

PRINT CAST(@@ROWCOUNT AS VARCHAR(10))+ ' row(s) updated.'
*/
END