--DELETE
--  FROM [dbo].['Sample Information$']
--  where f1 IS NULL



	





DROP TABLE #listme

Delete
  FROM [dbo].['Sample Information$']
	WHERE LEFT(ISNULL(f1,''),2) NOT IN  ('GS')

select f1 
into #listme
--delete
  FROM [dbo].['Sample Information$']
	WHERE LEFT(ISNULL(f1,''),2) IN  ('GS')
		and f5 is null


delete
  FROM [dbo].['Sample Information$']
	WHERE LEFT(ISNULL(f1,''),2) IN  ('GS')
		and f5 is null

SELECT [F1], * 
FROM [dbo].['Sample Information$']s
where LEFT(f1,7) in (select LEFT(f1,7) from #listme)
order by s.F1 