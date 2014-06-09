--select * FROM SurveyBaby12_Stage
--select * FROM SurveyBaby18_Stage
--select * FROM SurveyBaby6_Stage
--select * FROM SurveyMom12_Stage
--select * FROM SurveyMom18_Stage
--select * FROM SurveyMom6_Stage

--insert into crfFieldxx
--insert into crfFieldOptionsxx

--insert into tbleventxx

--select * from itmidw.tblEvent where eventType like '%survey%'
--insert into tblcrfEvent
-- select * from itmidw.tblCrfEvent where crftype like '%survey%'
--insert into tblcrfEventAnswers

DROP TABLE #sourceCrfData

SELECT 
           CONVERT(Varchar(100),deets.patientDataPointDetailID) AS [sourceSystemFieldDataID]
           ,deets.fieldName AS [sourceSystemFieldDataLabel]
           ,eve.crfEventID AS  [eventCrfID]
           ,crf.crfID AS [crfVersionID]
		   ,sub.subjectID AS subjectID
           ,ISNULL(deets.itmiFieldValue,deets.fieldValue) AS [fieldValue]
           ,NULL AS [hadQuery]
           ,CASE WHEN deets.queryStatus = 'Open' Then 1 ELSE 0 END AS [openQuery]
           ,NULL AS [fieldValueOrdinal]
		   ,deets.itmifieldID as fieldID
           ,(SELECT ss.sourceSystemID FROM ITMIDW.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS [orgSourceSystemID]
           ,GETDATE() [createDate]
           ,'usp_Study102CrfEventAnswers' AS [createdBy]
INTO #sourceCrfData
--select COUNT(*)
	FROM difzDBcopy.PatientDataPointDetail AS deets
		INNER JOIN ITMIDW.tblSubject subject
			ON subject.subjectId = deets.itmidwSubjectID
		INNER JOIN ITMIDW.tblCrf crf
			ON crf.crfName = deets.itmiFormName
		INNER JOIN ITMIDW.tblCrfEvent eve
			ON eve.sourceSystemCrfEventID = CONVERT(VARCHAR(50),deets.recordID)
				and eve.studyID = (select stud.studyID from ITMIDW.tblStudy stud where stud.studyshortID like '%102%')
		INNER JOIN ITMIDW.tblSubject sub
			ON sub.subjectID = deets.itmidwSubjectID
				AND sub.studyID = (select stud.studyID from ITMIDW.tblStudy stud where stud.studyshortID like '%102%')
	WHERE deets.isactive = 1	



SELECT DISTINCT 
	'INSERT INTO #sourceCrfData([sourceSystemFieldDataID],[eventCrfID],[crfVersionID],[fieldValue],[hadQuery],[openQuery],[fieldValueOrdinal],[orgSourceSystemID],[createDate], [createdBy], [sourceSystemFieldDataLabel], subjectID) SELECT ob.fieldID, Event.crfeventID,  event.crfVersionID, [' +
	 CONVERT(VARCHAR(100),s.name ) +
	 '] , 0, 0, NULL, 6, GETDATE(), ''usp_Study102CrfEventAnswers '',''' +
	 CONVERT(VARCHAR(100),s.name) + '''' +
	' ,sub.subjectID' + 
	' FROM dbo.' + CONVERT(VARCHAR(100), o.name) + ' ss ' +
	' INNER JOIN itmidw.tblCrfFields ob ON ob.crfVersionID =  (SELECT v.crfVersionID from itmidw.tblCrfVersion v where v.crfVersionName = ''6MonthBaby: v1'') and ob.sourceSystemFieldID = ''' +
	 CONVERT(VARCHAR(100),s.name) + '''' + 
	 ' INNER JOIN itmidw.tblSubject sub ON sub.sourceSystemIDLabel = ss.[family ID] '+ 
	' LEFT JOIN itmidw.tblCrfEvent event ON event.[sourceSystemCrfEventID] = ss.[family ID]' + 
	' WHERE ISNULL ([' + CONVERT(VARCHAR(100),s.name) + '] ,'''') <> '''' and crfeventID IS NOT NULL' 
FROM itmistaging.dbo.sysobjects o
	INNER JOIN itmistaging.dbo.syscolumns s
		ON s.id = o.id
	INNER JOIN tblcrf crf
		ON   o.name = 'SurveyBaby6_Stage'
			WHERE o.xtype = 'u'
				 and s.name not in ('Survey Status','Date Completed','Date Started', 'Last Name', 'First Name','Family ID', 'Site')


--NoviMom6Survey_Definition 
SELECT DISTINCT 
	'INSERT INTO #sourceCrfData([sourceSystemFieldDataID],[eventCrfID],[crfVersionID],[fieldValue],[hadQuery],[openQuery],[fieldValueOrdinal],[orgSourceSystemID],[createDate], [createdBy], [sourceSystemFieldDataLabel], subjectID) SELECT ob.fieldID, Event.crfeventID,  event.crfVersionID, [' +
	 CONVERT(VARCHAR(100),s.name ) +
	 '] , 0, 0, NULL, 6, GETDATE(), ''usp_Study102CrfEventAnswers '',''' +
	 CONVERT(VARCHAR(100),s.name) + '''' +
	' ,sub.subjectID' + 
	' FROM dbo.' + CONVERT(VARCHAR(100), o.name) + ' ss ' +
	' INNER JOIN itmidw.tblCrfFields ob ON ob.crfVersionID =  (SELECT v.crfVersionID from itmidw.tblCrfVersion v where v.crfVersionName = ''6MonthBaby: v1'') and ob.sourceSystemFieldID = ''' +
	 CONVERT(VARCHAR(100),s.name) + '''' + 
	 ' INNER JOIN itmidw.tblSubject sub ON sub.sourceSystemIDLabel = ss.[family ID] '+ 
	' LEFT JOIN itmidw.tblCrfEvent event ON event.[sourceSystemCrfEventID] = ss.[family ID]' + 
	' WHERE ISNULL ([' + CONVERT(VARCHAR(100),s.name) + '] ,'''') <> '''' and crfeventID IS NOT NULL' 
--SELECT distinct s.name
FROM itmistaging.dbo.sysobjects o
	INNER JOIN itmistaging.dbo.syscolumns s
		ON s.id = o.id
	INNER JOIN itmidw.tblcrf crf
		ON   o.name = 'Surveymom18_Stage'
			WHERE o.xtype = 'u'
				 and s.name not in ('Survey Status','Date Completed','Date Started', 'Last Name', 'First Name','Family ID', 'Site')

--NoviBaby12Survey_Definition
--NoviMom12Survey_Definition

--NoviBaby18Survey_Definition
--NoviMom18Survey_Definition
