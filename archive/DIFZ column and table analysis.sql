;WITH cte as
(
SELECT *, 
       ROW_NUMBER() OVER 
       (PARTITION BY [COLUMN_NAME]
       ORDER BY [COLUMN_NAME], [TABLE_NAME] ) AS RN
         FROM INFORMATION_SCHEMA.COLUMNS
              
)

select RN, CTE.[COLUMN_NAME], [TABLE_NAME] from cte
join
(
       SELECT COLUMN_NAME
       FROM INFORMATION_SCHEMA.COLUMNS
       group by COLUMN_NAME
       having count(COLUMN_NAME) > 1
) B ON CTE.COLUMN_NAME = B.COLUMN_NAME
WHERE CTE.COLUMN_NAME not in (
'acronym',
'statusDate',
'birthDateCompletenessCode',
'birthDateDay',
'birthDateMonth',
'changeCount',
'changeReason',
'createdDatetime',
'createdUserID',
'isActive',
'isVisible',
'lastChangedUserID',
'lastChangedDatetime',
'systemDatetime'
)

