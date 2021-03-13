//1.Zaimportuj dane uruchamiając zapytania zgodnie z instrukcjami wyświetlanymi po wpisaniu //polecenia :play movie-graph. Przeanalizuj i uruchom przykładowe zapytania. Następnie napisz //następujące zapytania: 


//2.Wszystkie filmy, w których grał Hugo Weaving

match (:Person{name: "Hugo Weaving"}) -[:ACTED_IN]-> (m: Movie) return m


//3.Reżyserzy filmów, w których grał Hugo Weaving 

MATCH (:Person {name: "Hugo Weaving"}) -[r:ACTED_IN]-> (m:Movie) <-[:DIRECTED]- (p:Person)
RETURN distinct p


//4.Wszystkie osoby, z którymi Hugo Weaving grał w tych samych filmach 

MATCH (hugo:Person {name:"Hugo Weaving"})-[:ACTED_IN]->(m)<-[:ACTED_IN]-(coActors) RETURN coActors


//5.Listę aktorów (aktor = osoba, która grała przynajmniej w jednym filmie) //wraz z ilością filmów, w których grali

MATCH (p: Person) -[:ACTED_IN]-> (m: Movie) return p, count(*) as movies_count


//6.Listę osób, które napisały scenariusz filmu, które wyreżyserowały wraz z //tytułami takich filmów (koniunkcja – ten sam autor scenariusza i reżyser)

MATCH (p:Person) -[:DIRECTED]-> (m:Movie) MATCH (p) -[:WROTE]-> (m)
return p, m.title as movie_title

//7.Listę filmów, w których grał zarówno Hugo Weaving jak i Keanu Reeves

MATCH (hugo:Person{name: "Hugo Weaving"}) -[:ACTED_IN]-> (m: Movie) 
MATCH (keanu:Person{name: "Keanu Reeves"}) -[:ACTED_IN]-> (m: Movie)
return m


//8.Zestaw zapytań powodujących uzupełnienie bazy danych o film Captain America: The First Avenger wraz z uzupełnieniem informacji o reżyserze, scenarzystach i //odtwórcach głównych ról (w oparciu o skrócone informacje z IMDB - http://www.imdb.com/title/tt0458339/) + zapytanie pokazujące dodany do bazy film wraz odtwórcami //głównych ról, scenarzystą i reżyserem. Plik SVG ma pokazywać wynik ostatniego zapytania.  

CREATE (CaptainAmerica:Movie {title:'Captain America:The First Avenger', released:2011, tagline:'When Patriots Become Heroes'})
CREATE (JoeJohnston:Person {name:'Joe Johnston', born:1950})
CREATE (ChristopherMarkus:Person {name:'Christopher Markus', born:1970})
CREATE (StephenMcFeely:Person {name:'Stephen McFeely', born:1969})
CREATE (ChrisEvans:Person {name:'Chris Evans', born:1981})
CREATE (HayleyAtwell:Person {name:'Hayley Atwell', born:1982})
CREATE (SebastianStan:Person {name:'Sebastian Stan', born:1982})
CREATE (TommyLeeJones:Person {name:'Tommy Lee Jones', born:1946})
CREATE (HugoWeaving:Person {name:'Hugo Weaving', born:1960})
CREATE (DominicCooper:Person {name:'Dominic Cooper', born:1978})
CREATE (RichardArmitage:Person {name:'Richard Armitage', born:1971})
CREATE (StanleyTucci:Person {name:'Stanley Tucci', born:1960})
CREATE
(ChrisEvans)-[:ACTED_IN {roles:['Captain America','Steve Rogers']}]->(CaptainAmerica),
(HayleyAtwell)-[:ACTED_IN {roles:['Peggy Carter']}]->(CaptainAmerica),
(SebastianStan)-[:ACTED_IN {roles:['James Buchanan Bucky Barnes']}]->(CaptainAmerica),
(TommyLeeJones)-[:ACTED_IN {roles:['Colonel Chester Phillips']}]->(CaptainAmerica),
(HugoWeaving)-[:ACTED_IN {roles:['Johann Schmidt','Red Skull']}]->(CaptainAmerica),
(DominicCooper)-[:ACTED_IN {roles:['Howard Stark']}]->(CaptainAmerica),
(RichardArmitage)-[:ACTED_IN {roles:['Heinz Kruger']}]->(CaptainAmerica),
(StanleyTucci)-[:ACTED_IN {roles:['Dr. Abraham Erskine']}]->(CaptainAmerica),
(JoeJohnston)-[:DIRECTED]->(CaptainAmerica),
(ChristopherMarkus)-[:WROTE]->(CaptainAmerica),
(StephenMcFeely)-[:WROTE]->(CaptainAmerica)

MATCH (people:Person)-[relatedTo]-(:Movie {title: "Captain America:The First Avenger"}) RETURN people, Type(relatedTo), relatedTo
