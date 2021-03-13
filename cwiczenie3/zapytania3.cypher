//Część 3 – Połączenia lotnicze 

//1.Zaimportuj dane uruchamiając skrypt task3.cypher. Napisz następujące zapytania: 

//2.Uszereguj porty lotnicze według ilości rozpoczynających się w nich lotów 

MATCH (:Flight)-[:ORIGIN]->(a:Airport) RETURN a as airport, count(*) as ilosc ORDER BY ilosc DESC


//3.Znajdź wszystkie porty lotnicze, do których da się dolecieć (bezpośrednio lub z przesiadkami) z Los Angeles (LAX) wydając mniej niż 3000

MATCH (a1)<-[:ORIGIN]-(f:FLIGHT)-[:DESTINATION]->(a2:Airport) MATCH (f) <-- (t:Ticket) WITH id(f) as idx, a1, a2, max(t.price) as ticket_price
MERGE (a1)-[:FLIGHT{price:ticket_price, f_idx: idx}]->(a2);

MATCH (a1)<-[:ORIGIN]-(f:FLIGHT)-[:DESTINATION]->(a2:Airport) MATCH (f) <-- (t:Ticket) MERGE (a1)-[fly:FLIGHT{price:t.price, f_idx: id(f)}]->(a2);

MATCH p=(lax: Airport{name:"LAX"})-[:FLIGHT*..4]->(a1: Airport) WITH reduce(amount=0, f in RELATIONSHIPS(p) | amount + f.price) as price, p 
WHERE price < 3000 RETURN last(nodes(p)) as node


//4.Uszereguj połączenia, którymi można dotrzeć z Los Angeles (LAX) do Dayton (DAY) według ceny biletów

MATCH path =(lax: Airport{name:"LAX"})-[:FLIGHT*..4]->(x: Airport{name: "DAY"}) WITH REDUCE(amount=0, f in RELATIONSHIPS(path) | amount + f.price) as price, path 
RETURN path ORDER BY price


//5.Znajdź najtańsze połączenie z Los Angeles (LAX) do Dayton (DAY) 

MATCH path=(lax: Airport{name:"LAX"})-[:FLIGHT*..4]->(x: Airport{name: "DAY"})
WITH REDUCE(amount=0, f in RELATIONSHIPS(path) | amount + f.price) as price, path 
RETURN path ORDER BY price limit 1


//6.Znajdź najtańsze połączenie z Los Angeles (LAX) do Dayton (DAY) w klasie biznes 

MATCH path=(lax: Airport{name:"LAX"})-[b:Business*..4]->(a: Airport{name: "DAY"}) WITH reduce(amount=0, f in relationships(path) | amount + f.price) as price, path
RETURN path ORDER BY price limit 1;

MATCH path=(lax: Airport{name:"LAX"})-[b:Business*..4]->(a: Airport{name: "DAY"}) WITH reduce(amount=0, f in relationships(path) | amount + f.price) as price, path
RETURN path ORDER BY price limit 1;


//7.Uszereguj linie lotnicze według ilości miast, pomiędzy którymi oferują połączenia (unikalnych miast biorących udział w relacjach :ORIGIN i :DESTINATION węzłów //typu Flight obsługiwanych przez daną linię) 

MATCH (f:Flight)-[:ORIGIN|DESTINATION]->(a:Airport)
RETURN f.airline as airline, count(distinct(a)) as count ORDER BY count(distinct(a)) DESC


//8.Znajdź najtańszą trasę łączącą 3 różne porty lotnicze

OPTIONAL MATCH path=(origin: Airport)-[:FLIGHT*..3]->(destination: Airport)
WITH reduce(con=[], n IN nodes(path) | CASE WHEN NOT n IN con THEN con+n END) as connections, path
WHERE size(connections)=3
WITH reduce(amount=0, f in relationships(path) | amount+f.price) as ticket_amount, path
RETURN path, min(ticket_amount) as min_price ORDER BY min_price LIMIT 1

