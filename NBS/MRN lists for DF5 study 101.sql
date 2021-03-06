INSERT INTO itmidw.tblSubjectDataFreeze ( subjectID , studyID, freezeID, freezeQualifier)
select 
subjectID
, studyID
,5
,NULL
from itmidw.tblSubjectDataFreeze d
where d.freezeID = 4



INSERT INTO itmidw.tblSubjectDataFreeze ( subjectID , studyID, freezeID, freezeQualifier)
SELECT 
	sub.subjectID
	, sub.studyID
	,5
	, NULL
	FROM itmidw.tblSubject sub	
		LEFT JOIN itmidw.tblSubjectIdentifer sids
			on sids.subjectID = sub.subjectID
				and sids.subjectIdentifierType = 'MRN'
where sub.[sourceSystemIDLabel]
IN (
'NB-101-495',
'NB-101-517',
'NB-101-535',
'NB-101-538',
'NB-101-548',
'NB-101-569',
'NB-101-576',
'NB-101-580',
'NB-101-613',
'NB-101-621',
'NB-101-640',
'NB-101-668',
'NB-101-671',
'NB-101-675',
'NB-101-683',
'NB-101-693',
'NB-101-695',
'NB-101-706',
'NB-101-710',
'NB-101-717',
'NB-101-723',
'NB-101-724',
'NB-101-729',
'NB-101-730',
'NB-101-735',
'NB-101-736',
'NB-101-742',
'NB-101-752',
'NB-101-757',
'NB-101-758',
'NB-101-760',
'NB-101-770',
'NB-101-783',
'NB-101-784',
'NB-101-785',
'NB-101-786',
'NB-101-787',
'NB-101-800',
'NB-101-803',
'NB-101-808',
'NB-101-810',
'NB-101-811',
'NB-101-812',
'NB-101-813',
'NB-101-816',
'NB-101-818',
'NB-101-819',
'NB-101-821',	
'NB-101-823',
'NB-101-824',
'NB-101-826',
'NB-101-827',
'NB-101-830',
'NB-101-833',
'NB-101-835',
'NB-101-836',
'NB-101-842',
'NB-101-843',
'NB-101-845',
'NB-101-846',
'NB-101-850',
'NB-101-851',
'NB-101-858',
'NB-101-863',
'NB-101-866',
'NB-101-869',
'NB-101-875',
'NB-101-876',
'NB-101-882',
'NB-101-883',
'NB-101-884',
'NB-101-886',
'NB-101-888',
'NB-101-889',
'NB-101-890',
'NB-101-891',
'NB-101-892',
'NB-101-893',
'NB-101-894',
'NB-101-896',
'NB-101-897',
'NB-101-898',
'NB-101-899',
'NB-101-900',
'NB-101-901',
'NB-101-902',
'NB-101-903',
'NB-101-904',
'NB-101-905',
'NB-101-906',
'NB-101-907',
'NB-101-908',
'NB-101-909',
'NB-101-910',
'NB-101-912',
'NB-101-915',
'NB-101-917',
'NB-101-918',
'NB-101-919',
'NB-101-920',
'NB-101-921',
'NB-101-922',
'NB-101-926',
'NB-101-929',
'NB-101-930',
'NB-101-931',
'NB-101-932',
'NB-101-933',
'NB-101-934',
'NB-101-940',
'NB-a-101-941',
'NB-101-942',
'NB-101-943',
'NB-a-101-945',
'NB-101-946',
'NB-101-947',
'NB-101-948',
'NB-A-101-175',
'NB-A-101-714',
'NB-A-101-775',
'NB-A-101-794',
'NB-A-101-796',
'NB-A-101-838',
'NB-A-101-927',
'NB-A-101-928',
'NB-A-101-938',
'NB-B-101-175',
'NB-B-101-602',
'NB-B-101-714',
'NB-B-101-775',
'NB-B-101-776',
'NB-B-101-778',
'NB-B-101-794',
'NB-B-101-796',
'NB-B-101-838',
'NB-B-101-927',
'NB-B-101-928',
'PO-101-657-022',
'PO-101-804-023',
'PO-101-904-022',
'PO-101-905-022',
'PO-101-928-022',
'PO-101-928-023',
'PO-101-928-038',
'PO-101-932-022',
'PO-101-941-022',
'PO-101-943-022',
'F-101-015',
'F-101-233',
'F-101-242',
'F-101-246',
'F-101-248',
'F-101-495',
'F-101-517',
'F-101-535',
'F-101-538',
'F-101-548',
'F-101-566',
'F-101-569',
'F-101-576',
'F-101-580',
'F-101-602',
'F-101-613',
'F-101-621',
'F-101-640',
'F-101-668',
'F-101-671',
'F-101-675',
'F-101-683',
'F-101-693',
'F-101-695',
'F-101-706',
'F-101-710',
'F-101-714',
'F-101-717',
'F-101-723',
'F-101-724',
'F-101-729',
'F-101-730',
'F-101-735',
'F-101-736',
'F-101-742',
'F-101-752',
'F-101-757',
'F-101-758',
'F-101-760',
'F-101-770',
'F-101-775',
'F-101-778',
'F-101-783',
'F-101-784',
'F-101-785',
'F-101-786',
'F-101-787',
'F-101-794',
'F-101-796',
'F-101-800',
'F-101-803',
'F-101-808',	
'F-101-810',
'F-101-811',
'F-101-812',
'F-101-813',
'F-101-816',
'F-101-818',
'F-101-819',
'F-101-821',
'F-101-823',
'F-101-824',
'F-101-826',
'F-101-827',
'F-101-830',
'F-101-833',
'F-101-835',
'F-101-836',
'F-101-838',
'F-101-842',
'F-101-843',
'F-101-845',
'F-101-846',
'F-101-850',
'F-101-851',
'F-101-858',
'F-101-863',
'F-101-866',
'F-101-869',
'F-101-875',
'F-101-876',
'F-101-882',
'F-101-883',
'F-101-884',
'F-101-886',
'F-101-888',
'F-101-889',
'F-101-890',
'F-101-891',
'F-101-892',
'F-101-893',
'F-101-894',
'F-101-896',
'F-101-897',
'F-101-898',
'F-101-899',
'F-101-900',
'F-101-901',
'F-101-902',
'F-101-903',
'F-101-904',
'F-101-905',
'F-101-906',
'F-101-907',
'F-101-908',
'F-101-909',
'F-101-910',
'F-101-912',
'F-101-915',
'F-101-917',
'F-101-918',
'F-101-919',
'F-101-920',
'F-101-921',
'F-101-922',
'F-101-926',
'F-101-927',
'F-101-928',
'F-101-929',
'F-101-930',
'F-101-931',
'F-101-932',
'F-101-933',
'F-101-934',
'F-101-938',
'F-101-940',
'F-101-941',
'F-101-942',
'F-101-943',
'F-101-945',
'F-101-947',
'F-101-948',
'M-101-015',
'M-101-175',
'M-101-233',
'M-101-246',
'M-101-495',
'M-101-517',
'M-101-535',
'M-101-538',
'M-101-548',
'M-101-566',
'M-101-569',
'M-101-576',
'M-101-580',
'M-101-602',
'M-101-613',
'M-101-621',
'M-101-640',
'M-101-652',
'M-101-668',
'M-101-671',
'M-101-675',
'M-101-683',
'M-101-693',
'M-101-695',
'M-101-706',
'M-101-710',
'M-101-714',
'M-101-717',
'M-101-723',
'M-101-724',
'M-101-729',
'M-101-730',
'M-101-735',
'M-101-736',
'M-101-742',
'M-101-752',
'M-101-757',
'M-101-758',
'M-101-760',
'M-101-770',
'M-101-775',
'M-101-778',
'M-101-783',
'M-101-784',
'M-101-785',
'M-101-787',
'M-101-794',
'M-101-796',
'M-101-800',
'M-101-803',
'M-101-808',
'M-101-810',
'M-101-811',
'M-101-812',
'M-101-813',
'M-101-816',
'M-101-818',
'M-101-819',
'M-101-821',
'M-101-823',
'M-101-824',
'M-101-826',
'M-101-827',
'M-101-830',
'M-101-833',
'M-101-835',
'M-101-836',
'M-101-838',
'M-101-842',
'M-101-843',
'M-101-845',
'M-101-846',
'M-101-850',
'M-101-851',
'M-101-858',
'M-101-863',
'M-101-866',
'M-101-869',
'M-101-875',
'M-101-876',
'M-101-882',
'M-101-883',
'M-101-884',
'M-101-886',
'M-101-888',
'M-101-889',
'M-101-890',
'M-101-891',
'M-101-892',
'M-101-893',
'M-101-894',
'M-101-896',
'M-101-897',
'M-101-898',
'M-101-899',
'M-101-900',
'M-101-901',
'M-101-902',
'M-101-903',
'M-101-904',
'M-101-905',
'M-101-906',
'M-101-907',
'M-101-908',
'M-101-909',
'M-101-910',
'M-101-912',
'M-101-915',
'M-101-917',
'M-101-918',
'M-101-919',
'M-101-920',
'M-101-921',
'M-101-922',
'M-101-926',
'M-101-927',
'M-101-928',
'M-101-929',
'M-101-930',
'M-101-931',
'M-101-932',
'M-101-933',
'M-101-934',
'M-101-938',
'M-101-940',
'M-101-941',
'M-101-942',
'M-101-943',
'M-101-945',
'M-101-946',
'M-101-947',
'M-101-948'--,
--'PO-22-101-84',
--'PO-26-101-84',
--'PO-27-101-84'
)
and sub.cohortRole = 'Infant'
order by sub.sourceSystemIDLabel


--SELECT * FROM ITMIDW.TBLSUBJECT sub WHERE sub.sourceSystemIDLabel LIKE '%657%'