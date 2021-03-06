/*

--SELECT * FROM [ITMIStaging].[etl].[Locks] (NOLOCK) WHERE IsLocked = 1
SELECT * FROM [ITMIStaging].[etl].[ErrorLogs] (NOLOCK)
SELECT * FROM [ITMIStaging].[etl].[Processes] (NOLOCK) ORDER BY ProcessID
SELECT * FROM [ITMIStaging].[etl].[Jobs] (NOLOCK)

SELECT
    p.ProcessName,
    el.*
FROM [ITMIStaging].[etl].[ErrorLogs] (nolock) el
INNER JOIN [ITMIStaging].[etl].[Jobs] (nolock) j ON j.JobID = el.JobID
INNER JOIN [ITMIStaging].[etl].[Processes] (nolock) p ON p.ProcessID = j.ProcessID

*/

SELECT 
    --COALESCE(jpp.StartDT, jp.StartDT, j.StartDT) AS PPStartDT,
    COALESCE(jpp.JobID, jp.JobID, j.JobID) AS PPJobID,
    --COALESCE(ppp.ProcessName, pp.ProcessName, p.ProcessName) AS PPProcessName,
	--COALESCE(pp.ProcessName, p.ProcessName) AS PP3rocessName,
    --COALESCE(CASE WHEN jpp.JobID IS NULL AND jp.JobID IS NOT NULL THEN j.JobID END, jp.JobID, j.JobID) AS PJobID,
    COALESCE(CASE WHEN jpp.StartDT IS NULL AND jp.StartDT IS NOT NULL THEN j.StartDT END, jp.StartDT, j.StartDT) AS PStartDT,
    COALESCE(pp.ProcessName, p.ProcessName) AS PProcessName,
    j.JobID,
    p.ProcessName,
    j.StartDT,
    j.FinishDT,
    CAST(FLOOR(DATEDIFF(SS, j.StartDT, j.FinishDT) / 3600) AS VARCHAR(4)) + ':' +
    CAST(FLOOR((DATEDIFF(SS, j.StartDT, j.FinishDT) % 3600) / 60) AS VARCHAR(2)) + ':' +
    CAST(FLOOR((DATEDIFF(SS, j.StartDT, j.FinishDT) % 3600) % 60) AS VARCHAR(2)) AS Duration,
    --c.Records,
    --j.JobDataID,
    el.ErrCount,
    j.JobData
    
FROM [ITMIStaging].[etl].[Jobs] (nolock) j
INNER JOIN [ITMIStaging].[etl].[Processes] (nolock) p ON p.ProcessID = j.ProcessID
LEFT JOIN [ITMIStaging].[etl].[Jobs] (nolock) jp ON jp.JobID = j.LinkedJobID
LEFT JOIN [ITMIStaging].[etl].[Processes] (nolock) pp ON pp.ProcessID = jp.ProcessID
LEFT JOIN [ITMIStaging].[etl].[Jobs] (nolock) jpp ON jpp.JobID = jp.LinkedJobID
--LEFT JOIN [ITMIStaging].[etl].[Processes] (nolock) ppp ON ppp.ProcessID = jpp.ProcessID
LEFT JOIN (SELECT JobID, COUNT(*) AS ErrCount FROM [ITMIStaging].[etl].[ErrorLogs] (nolock) GROUP BY JobID) el ON el.JobID = j.JobID
--LEFT JOIN [ITMIStaging].[etl].[Chunks] c ON c.ChunkID = j.JobDataID AND CHARINDEX('Import.', p.ProcessName) = 1

WHERE 
	j.StartDT >= '2014-06-01' and

    CAST(FLOOR(CAST(j.StartDT AS FLOAT)) AS DATETIME) BETWEEN '2014-06-01' and  '2014-06-03'
    --AND p.ProcessName NOT LIKE '%ManifestIlluminaImport%' 
   --AND p.ProcessName NOT LIKE '%Import.Roster%'
    --AND j.JobData LIKE '%205188%'
    --AND pp.ProcessName LIKE '%ManifestIlluminaImport%'
    --AND COALESCE(CASE WHEN jpp.JobID IS NULL AND jp.JobID IS NOT NULL THEN j.JobID END, jp.JobID, j.JobID) = 917659 
    --AND ErrCount IS NOT null
    --j.FinishDT IS NULL
    --COALESCE(jpp.JobID, jp.JobID, j.JobID) = 4054
    --COALESCE(CASE WHEN jpp.JobID IS NULL AND jp.JobID IS NOT NULL THEN j.JobID END, jp.JobID, j.JobID) = 414

ORDER BY
    COALESCE(jpp.StartDT, jp.StartDT, j.StartDT) desc,--PPStartDT,
    PStartDT,
    j.StartDT



