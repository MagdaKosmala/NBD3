//Część 2 – Wycieczki górskie 

//1.Zaimportuj dane uruchamiając skrypt task2.cypher. Napisz następujące zapytania: 

//2.Znajdź wszystkie trasy którymi można dostać się z Darjeeling na Sandakphu 

MATCH path = ({name: "Darjeeling"}) -[*]-> ({name: "Sandakphu"}) RETURN path


//3.Znajdź trasy którymi można dostać się z Darjeeling na Sandakphu, mające najmniejszą ilość etapów 

MATCH path = ALLSHORTESTPATHS(({name: "Darjeeling"}) -[*]-> ({name: "Sandakphu"})) RETURN path


//4.Znajdź mające najmniej etapów trasy którymi można dostać się z Darjeeling na Sandakphu i które mogą być wykorzystywane zimą 

MATCH path = ALLSHORTESTPATHS(({name: "Darjeeling"}) -[*]-> ({name: "Sandakphu"})) 
WHERE ALL (rel in RELATIONSHIPS(path) WHERE rel.winter = "true")  
RETURN path

//5.Uszereguj trasy którymi można dostać się z Darjeeling na Sandakphu według dystansu 

MATCH path = ({name: "Darjeeling"}) -[*]-> ({name: "Sandakphu"}) RETURN path, length(path) ORDER BY length(path)


//6.Znajdź wszystkie trasy dostępne latem, którymi można poruszać się przy pomocy roweru (twowheeler) z Darjeeling 

MATCH path = ({name:"Darjeeling"})-[:twowheeler*{summer: 'true'}]->() RETURN path


//7. Znajdź wszystkie miejsca do których można dotrzeć przy pomocy roweru (twowheeler) z Darjeeling latem 

MATCH path = ({name: "Darjeeling"}) -[r:twowheeler*]-> (m) WHERE ALL (rel in RELATIONSHIPS(path) where rel.summer = "true") RETURN m
