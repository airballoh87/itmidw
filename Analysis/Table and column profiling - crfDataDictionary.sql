--Top part finds the tables you are looking for into table #t
/*

drop table #t
GO
select 
	 o.name as tableName, s.name as columnName
	 ,t.name as columnType
INTO #t	
from itmidw.sys.sysobjects o
	inner join itmidw.sys.syscolumns s
		on s.id = o.id
	inner join itmidw.sys.types t
		on t.system_type_id = s.xtype
where  o.name in (
'tblCrfDataDictionary'
)
AND s.name not like '%_ID';

--select distinct columnType from #t
--From #t, this creates a select statement taht will be used to insert into detail and min max tables.
--becuase of counting, the type of field it is in should be found, (it is above) and that will need to be split into 2 select statments.

--select DISTINCT 'SELECT COUNT(*) as '+ CONVERT(VARCHAR(100),tableName) + ' FROM itmidw.dbo.'+  CONVERT(Varchar(100),tableName)  FROM #t
--min max,count

select 
'select  COUNT(*) as Totalcnt, ' +
'''' +
CONVERT(varchar(100),ColumnName) +
''''+
' as colName' +
' , ' +
'''' +
CONVERT(varchar(100),tableName) +
''''+
' as tableName' +
--max
', CONVERT(varchar(100),(MAX(' +
CONVERT(VARCHAR(100),ColumnName) + 
'))) as Max' +
CONVERT(VARCHAR(100),ColumnName) + 
--min
', CONVERT(VARCHAR(100),MIN(' +
CONVERT(VARCHAR(100),ColumnName) + 
')) as Min' +
CONVERT(VARCHAR(100),ColumnName) + 
',(SELECT COUNT(*) FROM ' +
' (SELECT 1 as gr, ' +
CONVERT(VARCHAR(100),ColumnName) + 
' FROM itmidw.dbo.'+  CONVERT(Varchar(100),tableName) +
' Group by '+
CONVERT(VARCHAR(100),ColumnName) + 
') a GROUP BY gr)  as distinctValue' +
' FROM itmidw.dbo.'+  CONVERT(Varchar(100),tableName) +
' WHERE ' +
CONVERT(VARCHAR(100),ColumnName) + 
' IS NOT NULL UNION '
from #t



--pct filled in
--float
--numeric
--varbinary
--int

SELECT
' select '+
' SUM(CASE WHEN ISNULL(' +
 CONVERT(varchar(100),ColumnName) +
' ,0) = 0 THEN 0 ELSE 1 END) as hasValue' +
' , COUNT(*) as cnt' +
' , ' +
'''' +
CONVERT(varchar(100),ColumnName) +
''''+
' as colName' +
+' , ROUND((SUM(CASE WHEN ISNULL(' +
CONVERT(varchar(100),ColumnName) +
' ,0) = 0 THEN 0 ELSE 1 END)+0.00) /COUNT(*)+0.00,2)*100 as pctFilled, '+
'''' +
 CONVERT(Varchar(100),tableName) +
 '''' +
 ' as TableName' +
' FROM itmidw.dbo.'+  CONVERT(Varchar(100),tableName) +
' UNION '
FROM #t
WHERE columnType IN (
'float',
'numeric',
'varbinary',
'int'
)
UNION ALL
SELECT
' select '+
' SUM(CASE WHEN ISNULL(' +
 CONVERT(varchar(100),ColumnName) +
' ,'''') = '''' THEN 0 ELSE 1 END) as hasValue' +
' , COUNT(*) as cnt' +
' , ' +
'''' +
CONVERT(varchar(100),ColumnName) +
''''+
' as colName' +
+' , ROUND((SUM(CASE WHEN ISNULL(' +
CONVERT(varchar(100),ColumnName) +
' ,'''') = '''' THEN 0 ELSE 1 END)+0.00) /COUNT(*)+0.00,2)*100 as pctFilled, '+
'''' +
 CONVERT(Varchar(100),tableName) +
 '''' +
 ' as TableName' +
' FROM itmidw.dbo.'+  CONVERT(Varchar(100),tableName) +
' UNION '
FROM #t
WHERE columnType IN (
'char',
'date',
'varchar',
'datetime',
'nchar',
'nvarchar',
'sysname'
)


*/
  
DROP TABLE #detail
DROP TABLE #minMax

GO
CREATE TABLE #detail (hasValue INT, cnt INT, colName varchar(100), pctFilled FLOAT, tableName varchar(100))
CREATE TABLE #minMax (Totalcnt INT ,MaxValue VARCHAR(100),  MinValue  VARCHAR(100) , colName  VARCHAR(100), tableName  VARCHAR(100) ,distinctValue INT)

INSERT INTO #detail (hasValue  ,cnt , colName , pctFilled , tableName )
 select  SUM(CASE WHEN ISNULL(fieldOrder ,0) = 0 THEN 0 ELSE 1 END) as hasValue , COUNT(*) as cnt , 'fieldOrder' as colName , ROUND((SUM(CASE WHEN ISNULL(fieldOrder ,0) = 0 THEN 0 ELSE 1 END)+0.00) /COUNT(*)+0.00,2)*100 as pctFilled, 'tblCrfDataDictionary' as TableName FROM itmidw.dbo.tblCrfDataDictionary UNION 
 select  SUM(CASE WHEN ISNULL(createDate ,'') = '' THEN 0 ELSE 1 END) as hasValue , COUNT(*) as cnt , 'createDate' as colName , ROUND((SUM(CASE WHEN ISNULL(createDate ,'') = '' THEN 0 ELSE 1 END)+0.00) /COUNT(*)+0.00,2)*100 as pctFilled, 'tblCrfDataDictionary' as TableName FROM itmidw.dbo.tblCrfDataDictionary UNION 
 select  SUM(CASE WHEN ISNULL(studyName ,'') = '' THEN 0 ELSE 1 END) as hasValue , COUNT(*) as cnt , 'studyName' as colName , ROUND((SUM(CASE WHEN ISNULL(studyName ,'') = '' THEN 0 ELSE 1 END)+0.00) /COUNT(*)+0.00,2)*100 as pctFilled, 'tblCrfDataDictionary' as TableName FROM itmidw.dbo.tblCrfDataDictionary UNION 
 select  SUM(CASE WHEN ISNULL(crfType ,'') = '' THEN 0 ELSE 1 END) as hasValue , COUNT(*) as cnt , 'crfType' as colName , ROUND((SUM(CASE WHEN ISNULL(crfType ,'') = '' THEN 0 ELSE 1 END)+0.00) /COUNT(*)+0.00,2)*100 as pctFilled, 'tblCrfDataDictionary' as TableName FROM itmidw.dbo.tblCrfDataDictionary UNION 
 select  SUM(CASE WHEN ISNULL(crfVersionName ,'') = '' THEN 0 ELSE 1 END) as hasValue , COUNT(*) as cnt , 'crfVersionName' as colName , ROUND((SUM(CASE WHEN ISNULL(crfVersionName ,'') = '' THEN 0 ELSE 1 END)+0.00) /COUNT(*)+0.00,2)*100 as pctFilled, 'tblCrfDataDictionary' as TableName FROM itmidw.dbo.tblCrfDataDictionary UNION 
 select  SUM(CASE WHEN ISNULL(preferredFieldName ,'') = '' THEN 0 ELSE 1 END) as hasValue , COUNT(*) as cnt , 'preferredFieldName' as colName , ROUND((SUM(CASE WHEN ISNULL(preferredFieldName ,'') = '' THEN 0 ELSE 1 END)+0.00) /COUNT(*)+0.00,2)*100 as pctFilled, 'tblCrfDataDictionary' as TableName FROM itmidw.dbo.tblCrfDataDictionary UNION 
 select  SUM(CASE WHEN ISNULL(externalCDE ,'') = '' THEN 0 ELSE 1 END) as hasValue , COUNT(*) as cnt , 'externalCDE' as colName , ROUND((SUM(CASE WHEN ISNULL(externalCDE ,'') = '' THEN 0 ELSE 1 END)+0.00) /COUNT(*)+0.00,2)*100 as pctFilled, 'tblCrfDataDictionary' as TableName FROM itmidw.dbo.tblCrfDataDictionary UNION 
 select  SUM(CASE WHEN ISNULL(requiredDependency ,'') = '' THEN 0 ELSE 1 END) as hasValue , COUNT(*) as cnt , 'requiredDependency' as colName , ROUND((SUM(CASE WHEN ISNULL(requiredDependency ,'') = '' THEN 0 ELSE 1 END)+0.00) /COUNT(*)+0.00,2)*100 as pctFilled, 'tblCrfDataDictionary' as TableName FROM itmidw.dbo.tblCrfDataDictionary UNION 
 select  SUM(CASE WHEN ISNULL(requiredDependencyText ,'') = '' THEN 0 ELSE 1 END) as hasValue , COUNT(*) as cnt , 'requiredDependencyText' as colName , ROUND((SUM(CASE WHEN ISNULL(requiredDependencyText ,'') = '' THEN 0 ELSE 1 END)+0.00) /COUNT(*)+0.00,2)*100 as pctFilled, 'tblCrfDataDictionary' as TableName FROM itmidw.dbo.tblCrfDataDictionary UNION 
 select  SUM(CASE WHEN ISNULL(createdBy ,'') = '' THEN 0 ELSE 1 END) as hasValue , COUNT(*) as cnt , 'createdBy' as colName , ROUND((SUM(CASE WHEN ISNULL(createdBy ,'') = '' THEN 0 ELSE 1 END)+0.00) /COUNT(*)+0.00,2)*100 as pctFilled, 'tblCrfDataDictionary' as TableName FROM itmidw.dbo.tblCrfDataDictionary UNION 
 select  SUM(CASE WHEN ISNULL(questionText ,'') = '' THEN 0 ELSE 1 END) as hasValue , COUNT(*) as cnt , 'questionText' as colName , ROUND((SUM(CASE WHEN ISNULL(questionText ,'') = '' THEN 0 ELSE 1 END)+0.00) /COUNT(*)+0.00,2)*100 as pctFilled, 'tblCrfDataDictionary' as TableName FROM itmidw.dbo.tblCrfDataDictionary UNION 
 select  SUM(CASE WHEN ISNULL(mandatory ,'') = '' THEN 0 ELSE 1 END) as hasValue , COUNT(*) as cnt , 'mandatory' as colName , ROUND((SUM(CASE WHEN ISNULL(mandatory ,'') = '' THEN 0 ELSE 1 END)+0.00) /COUNT(*)+0.00,2)*100 as pctFilled, 'tblCrfDataDictionary' as TableName FROM itmidw.dbo.tblCrfDataDictionary UNION 
 select  SUM(CASE WHEN ISNULL(fieldName ,'') = '' THEN 0 ELSE 1 END) as hasValue , COUNT(*) as cnt , 'fieldName' as colName , ROUND((SUM(CASE WHEN ISNULL(fieldName ,'') = '' THEN 0 ELSE 1 END)+0.00) /COUNT(*)+0.00,2)*100 as pctFilled, 'tblCrfDataDictionary' as TableName FROM itmidw.dbo.tblCrfDataDictionary UNION 
 select  SUM(CASE WHEN ISNULL(fieldDescription ,'') = '' THEN 0 ELSE 1 END) as hasValue , COUNT(*) as cnt , 'fieldDescription' as colName , ROUND((SUM(CASE WHEN ISNULL(fieldDescription ,'') = '' THEN 0 ELSE 1 END)+0.00) /COUNT(*)+0.00,2)*100 as pctFilled, 'tblCrfDataDictionary' as TableName FROM itmidw.dbo.tblCrfDataDictionary UNION 
 select  SUM(CASE WHEN ISNULL(externalCDESource ,'') = '' THEN 0 ELSE 1 END) as hasValue , COUNT(*) as cnt , 'externalCDESource' as colName , ROUND((SUM(CASE WHEN ISNULL(externalCDESource ,'') = '' THEN 0 ELSE 1 END)+0.00) /COUNT(*)+0.00,2)*100 as pctFilled, 'tblCrfDataDictionary' as TableName FROM itmidw.dbo.tblCrfDataDictionary UNION 
 select  SUM(CASE WHEN ISNULL(questionText ,'') = '' THEN 0 ELSE 1 END) as hasValue , COUNT(*) as cnt , 'questionText' as colName , ROUND((SUM(CASE WHEN ISNULL(questionText ,'') = '' THEN 0 ELSE 1 END)+0.00) /COUNT(*)+0.00,2)*100 as pctFilled, 'tblCrfDataDictionary' as TableName FROM itmidw.dbo.tblCrfDataDictionary UNION 
 select  SUM(CASE WHEN ISNULL(mandatory ,'') = '' THEN 0 ELSE 1 END) as hasValue , COUNT(*) as cnt , 'mandatory' as colName , ROUND((SUM(CASE WHEN ISNULL(mandatory ,'') = '' THEN 0 ELSE 1 END)+0.00) /COUNT(*)+0.00,2)*100 as pctFilled, 'tblCrfDataDictionary' as TableName FROM itmidw.dbo.tblCrfDataDictionary UNION 
 select  SUM(CASE WHEN ISNULL(fieldName ,'') = '' THEN 0 ELSE 1 END) as hasValue , COUNT(*) as cnt , 'fieldName' as colName , ROUND((SUM(CASE WHEN ISNULL(fieldName ,'') = '' THEN 0 ELSE 1 END)+0.00) /COUNT(*)+0.00,2)*100 as pctFilled, 'tblCrfDataDictionary' as TableName FROM itmidw.dbo.tblCrfDataDictionary UNION 
 select  SUM(CASE WHEN ISNULL(fieldDescription ,'') = '' THEN 0 ELSE 1 END) as hasValue , COUNT(*) as cnt , 'fieldDescription' as colName , ROUND((SUM(CASE WHEN ISNULL(fieldDescription ,'') = '' THEN 0 ELSE 1 END)+0.00) /COUNT(*)+0.00,2)*100 as pctFilled, 'tblCrfDataDictionary' as TableName FROM itmidw.dbo.tblCrfDataDictionary 




---minmax
INSERT INTO #minMax (Totalcnt , colName , tableName ,MaxValue ,  MinValue, distinctValue )
select  COUNT(*) as Totalcnt, 'fieldOrder' as colName , 'tblCrfDataDictionary' as tableName, CONVERT(varchar(100),(MAX(fieldOrder))) as MaxfieldOrder, CONVERT(VARCHAR(100),MIN(fieldOrder)) as MinfieldOrder,(SELECT COUNT(*) FROM  (SELECT 1 as gr, fieldOrder FROM itmidw.dbo.tblCrfDataDictionary Group by fieldOrder) a GROUP BY gr)  as distinctValue FROM itmidw.dbo.tblCrfDataDictionary WHERE fieldOrder IS NOT NULL UNION 
select  COUNT(*) as Totalcnt, 'createDate' as colName , 'tblCrfDataDictionary' as tableName, CONVERT(varchar(100),(MAX(createDate))) as MaxcreateDate, CONVERT(VARCHAR(100),MIN(createDate)) as MincreateDate,(SELECT COUNT(*) FROM  (SELECT 1 as gr, createDate FROM itmidw.dbo.tblCrfDataDictionary Group by createDate) a GROUP BY gr)  as distinctValue FROM itmidw.dbo.tblCrfDataDictionary WHERE createDate IS NOT NULL UNION 
select  COUNT(*) as Totalcnt, 'studyName' as colName , 'tblCrfDataDictionary' as tableName, CONVERT(varchar(100),(MAX(studyName))) as MaxstudyName, CONVERT(VARCHAR(100),MIN(studyName)) as MinstudyName,(SELECT COUNT(*) FROM  (SELECT 1 as gr, studyName FROM itmidw.dbo.tblCrfDataDictionary Group by studyName) a GROUP BY gr)  as distinctValue FROM itmidw.dbo.tblCrfDataDictionary WHERE studyName IS NOT NULL UNION 
select  COUNT(*) as Totalcnt, 'crfType' as colName , 'tblCrfDataDictionary' as tableName, CONVERT(varchar(100),(MAX(crfType))) as MaxcrfType, CONVERT(VARCHAR(100),MIN(crfType)) as MincrfType,(SELECT COUNT(*) FROM  (SELECT 1 as gr, crfType FROM itmidw.dbo.tblCrfDataDictionary Group by crfType) a GROUP BY gr)  as distinctValue FROM itmidw.dbo.tblCrfDataDictionary WHERE crfType IS NOT NULL UNION 
select  COUNT(*) as Totalcnt, 'crfVersionName' as colName , 'tblCrfDataDictionary' as tableName, CONVERT(varchar(100),(MAX(crfVersionName))) as MaxcrfVersionName, CONVERT(VARCHAR(100),MIN(crfVersionName)) as MincrfVersionName,(SELECT COUNT(*) FROM  (SELECT 1 as gr, crfVersionName FROM itmidw.dbo.tblCrfDataDictionary Group by crfVersionName) a GROUP BY gr)  as distinctValue FROM itmidw.dbo.tblCrfDataDictionary WHERE crfVersionName IS NOT NULL UNION 
select  COUNT(*) as Totalcnt, 'preferredFieldName' as colName , 'tblCrfDataDictionary' as tableName, CONVERT(varchar(100),(MAX(preferredFieldName))) as MaxpreferredFieldName, CONVERT(VARCHAR(100),MIN(preferredFieldName)) as MinpreferredFieldName,(SELECT COUNT(*) FROM  (SELECT 1 as gr, preferredFieldName FROM itmidw.dbo.tblCrfDataDictionary Group by preferredFieldName) a GROUP BY gr)  as distinctValue FROM itmidw.dbo.tblCrfDataDictionary WHERE preferredFieldName IS NOT NULL UNION 
select  COUNT(*) as Totalcnt, 'externalCDE' as colName , 'tblCrfDataDictionary' as tableName, CONVERT(varchar(100),(MAX(externalCDE))) as MaxexternalCDE, CONVERT(VARCHAR(100),MIN(externalCDE)) as MinexternalCDE,(SELECT COUNT(*) FROM  (SELECT 1 as gr, externalCDE FROM itmidw.dbo.tblCrfDataDictionary Group by externalCDE) a GROUP BY gr)  as distinctValue FROM itmidw.dbo.tblCrfDataDictionary WHERE externalCDE IS NOT NULL UNION 
select  COUNT(*) as Totalcnt, 'requiredDependency' as colName , 'tblCrfDataDictionary' as tableName, CONVERT(varchar(100),(MAX(requiredDependency))) as MaxrequiredDependency, CONVERT(VARCHAR(100),MIN(requiredDependency)) as MinrequiredDependency,(SELECT COUNT(*) FROM  (SELECT 1 as gr, requiredDependency FROM itmidw.dbo.tblCrfDataDictionary Group by requiredDependency) a GROUP BY gr)  as distinctValue FROM itmidw.dbo.tblCrfDataDictionary WHERE requiredDependency IS NOT NULL UNION 
select  COUNT(*) as Totalcnt, 'requiredDependencyText' as colName , 'tblCrfDataDictionary' as tableName, CONVERT(varchar(100),(MAX(requiredDependencyText))) as MaxrequiredDependencyText, CONVERT(VARCHAR(100),MIN(requiredDependencyText)) as MinrequiredDependencyText,(SELECT COUNT(*) FROM  (SELECT 1 as gr, requiredDependencyText FROM itmidw.dbo.tblCrfDataDictionary Group by requiredDependencyText) a GROUP BY gr)  as distinctValue FROM itmidw.dbo.tblCrfDataDictionary WHERE requiredDependencyText IS NOT NULL UNION 
select  COUNT(*) as Totalcnt, 'createdBy' as colName , 'tblCrfDataDictionary' as tableName, CONVERT(varchar(100),(MAX(createdBy))) as MaxcreatedBy, CONVERT(VARCHAR(100),MIN(createdBy)) as MincreatedBy,(SELECT COUNT(*) FROM  (SELECT 1 as gr, createdBy FROM itmidw.dbo.tblCrfDataDictionary Group by createdBy) a GROUP BY gr)  as distinctValue FROM itmidw.dbo.tblCrfDataDictionary WHERE createdBy IS NOT NULL UNION 
select  COUNT(*) as Totalcnt, 'questionText' as colName , 'tblCrfDataDictionary' as tableName, CONVERT(varchar(100),(MAX(questionText))) as MaxquestionText, CONVERT(VARCHAR(100),MIN(questionText)) as MinquestionText,(SELECT COUNT(*) FROM  (SELECT 1 as gr, questionText FROM itmidw.dbo.tblCrfDataDictionary Group by questionText) a GROUP BY gr)  as distinctValue FROM itmidw.dbo.tblCrfDataDictionary WHERE questionText IS NOT NULL UNION 
select  COUNT(*) as Totalcnt, 'mandatory' as colName , 'tblCrfDataDictionary' as tableName, CONVERT(varchar(100),(MAX(mandatory))) as Maxmandatory, CONVERT(VARCHAR(100),MIN(mandatory)) as Minmandatory,(SELECT COUNT(*) FROM  (SELECT 1 as gr, mandatory FROM itmidw.dbo.tblCrfDataDictionary Group by mandatory) a GROUP BY gr)  as distinctValue FROM itmidw.dbo.tblCrfDataDictionary WHERE mandatory IS NOT NULL UNION 
select  COUNT(*) as Totalcnt, 'fieldName' as colName , 'tblCrfDataDictionary' as tableName, CONVERT(varchar(100),(MAX(fieldName))) as MaxfieldName, CONVERT(VARCHAR(100),MIN(fieldName)) as MinfieldName,(SELECT COUNT(*) FROM  (SELECT 1 as gr, fieldName FROM itmidw.dbo.tblCrfDataDictionary Group by fieldName) a GROUP BY gr)  as distinctValue FROM itmidw.dbo.tblCrfDataDictionary WHERE fieldName IS NOT NULL UNION 
select  COUNT(*) as Totalcnt, 'fieldDescription' as colName , 'tblCrfDataDictionary' as tableName, CONVERT(varchar(100),(MAX(fieldDescription))) as MaxfieldDescription, CONVERT(VARCHAR(100),MIN(fieldDescription)) as MinfieldDescription,(SELECT COUNT(*) FROM  (SELECT 1 as gr, fieldDescription FROM itmidw.dbo.tblCrfDataDictionary Group by fieldDescription) a GROUP BY gr)  as distinctValue FROM itmidw.dbo.tblCrfDataDictionary WHERE fieldDescription IS NOT NULL UNION 
select  COUNT(*) as Totalcnt, 'externalCDESource' as colName , 'tblCrfDataDictionary' as tableName, CONVERT(varchar(100),(MAX(externalCDESource))) as MaxexternalCDESource, CONVERT(VARCHAR(100),MIN(externalCDESource)) as MinexternalCDESource,(SELECT COUNT(*) FROM  (SELECT 1 as gr, externalCDESource FROM itmidw.dbo.tblCrfDataDictionary Group by externalCDESource) a GROUP BY gr)  as distinctValue FROM itmidw.dbo.tblCrfDataDictionary WHERE externalCDESource IS NOT NULL UNION 
select  COUNT(*) as Totalcnt, 'questionText' as colName , 'tblCrfDataDictionary' as tableName, CONVERT(varchar(100),(MAX(questionText))) as MaxquestionText, CONVERT(VARCHAR(100),MIN(questionText)) as MinquestionText,(SELECT COUNT(*) FROM  (SELECT 1 as gr, questionText FROM itmidw.dbo.tblCrfDataDictionary Group by questionText) a GROUP BY gr)  as distinctValue FROM itmidw.dbo.tblCrfDataDictionary WHERE questionText IS NOT NULL UNION 
select  COUNT(*) as Totalcnt, 'mandatory' as colName , 'tblCrfDataDictionary' as tableName, CONVERT(varchar(100),(MAX(mandatory))) as Maxmandatory, CONVERT(VARCHAR(100),MIN(mandatory)) as Minmandatory,(SELECT COUNT(*) FROM  (SELECT 1 as gr, mandatory FROM itmidw.dbo.tblCrfDataDictionary Group by mandatory) a GROUP BY gr)  as distinctValue FROM itmidw.dbo.tblCrfDataDictionary WHERE mandatory IS NOT NULL UNION 
select  COUNT(*) as Totalcnt, 'fieldName' as colName , 'tblCrfDataDictionary' as tableName, CONVERT(varchar(100),(MAX(fieldName))) as MaxfieldName, CONVERT(VARCHAR(100),MIN(fieldName)) as MinfieldName,(SELECT COUNT(*) FROM  (SELECT 1 as gr, fieldName FROM itmidw.dbo.tblCrfDataDictionary Group by fieldName) a GROUP BY gr)  as distinctValue FROM itmidw.dbo.tblCrfDataDictionary WHERE fieldName IS NOT NULL UNION 
select  COUNT(*) as Totalcnt, 'fieldDescription' as colName , 'tblCrfDataDictionary' as tableName, CONVERT(varchar(100),(MAX(fieldDescription))) as MaxfieldDescription, CONVERT(VARCHAR(100),MIN(fieldDescription)) as MinfieldDescription,(SELECT COUNT(*) FROM  (SELECT 1 as gr, fieldDescription FROM itmidw.dbo.tblCrfDataDictionary Group by fieldDescription) a GROUP BY gr)  as distinctValue FROM itmidw.dbo.tblCrfDataDictionary WHERE fieldDescription IS NOT NULL 



select 
	d.tableName
	, d.colName
	, d.cnt as RowCnt
	, d.hasValue as RowsWithValues
	, distinctValue
	, d.pctFilled as pctRowsWithValues
	, mm.MaxValue
	, mm.MinValue
FROM #detail d
	INNER JOIN #minMax mm
		on d.colName = mm.colName
			and d.tableName = mm.tableName
ORDER BY d.tableName, d.colName


