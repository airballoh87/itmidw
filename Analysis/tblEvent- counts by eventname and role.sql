select eventtype, eventName, COUNT(*)
from itmidw.tblevent
where studyID = 2
GROUP BY eventtype, eventName
ORDER BY eventtype, eventName



select sub.cohortrole,eventtype, eventName, COUNT(*)
from itmidw.tblevent eve
       inner join itmidw.tblsubject sub
              on sub.subjectID = eve.subjectID
where eve.studyID = 2
GROUP BY sub.cohortrole,eventtype, eventName
ORDER BY sub.cohortrole,eventtype, eventName
