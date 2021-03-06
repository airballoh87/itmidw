/****** Object:  StoredProcedure [itmidw].[usp_Study101Post_script]    Script Date: 3/29/2014 6:39:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**************************************************************************
Created ON : 3/17/2014
Created By : AarON Black
Team Name : Informatics
Object name : [usp_Study101Post_script]
Functional : ITMI SSIS for Insert and Update for study 102 subjects
Purpose : Import of study 101 subjects from data difz schema for all forms, taking the distinct list of SubjectID's and making an insert.
History : Created ON 3/17/2014
**************************************************************************
Date Modified By QC# Purposes
**************************************************************************
#Date #Comment
**************************************************************************
USE CASE:
EXEC [usp_Study101Post_script]
--checking both delete and insert component of slowing changing dimension
DELETE FROM  tblsubject where sourceSystemSubjectID = '102-00250-02'
SELECT * FROM  tblsubject where sourceSystemSubjectID = '102-00250-02'
SELECT * FROM  tblsubject where subjectID = '13121'
UPDATE tblsubject set createdby = 'boo..' where subjectID = '13121'

**************************************************************************/
ALTER PROCEDURE [itmidw].[usp_Study101Post_script]
AS
BEGIN
SET NOCOUNT ON;
DECLARE @UpdatedON SMALLDATETIME
SET @UpdatedON = CAST(GETDATE() AS SMALLDATETIME)
PRINT CONVERT(CHAR(23), @UpdatedOn, 121) + ' [usp_Study101Post_script][' + @@SERVERNAME + '][' + SYSTEM_USER + ']'
PRINT 'INSERT [itmidw].[usp_Study101Post_script]...'

--*************************************
--******************101****************
--*************************************


---Obscure Date
--** doing this for family Unit for study 101, the obscure date will be the ate of deliver of the first studies proband in the trio

PRINT CAST(@@ROWCOUNT AS VARCHAR(10))+ ' row(s) updated.'

Select cfrA.fieldValue as obscureDate,sub.subjectID, sub.sourceSystemIDLabel
into #obscureRef
from itmidw.tblCrfEventAnswers cfrA
	inner join itmidw.tblsubject sub
		on sub.subjectID = cfra.subjectID
Where sub.studyID =1
	and sub.cohortRole = 'Mother'
	and cfrA.sourceSystemFieldDataLabel = 'Date and Time of Delivery'


UPDATE itmidw.itmi.tblOrganization  SET itmiZeroDateForObfuscation = ref.obscureDate
FROM itmidw.itmi.tblOrganization  org
	INNER JOIN itmidw.tblSubjectOrganizationMap map
		ON Map.organizationID  = org.organizationID
	INNER JOIN #obscureRef ref
		ON ref.SubjectID = map.subjectID

PRINT CAST(@@ROWCOUNT AS VARCHAR(10))+ 'obscure date row(s) updated.'


END




