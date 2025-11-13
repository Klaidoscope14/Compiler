-- Create and populate a table 
 CREATE TABLE "Users" ( 
   id INT, 
   name TEXT, 
   bio TEXT 
 );  
 /* Insert sample rows */ 
 INSERT INTO "Users"(id, name, bio) VALUES 
   (1, 'Ada Lovelace', $$Computing pioneer$$), 
   (2, 'Alan Turing', $note$Father of AI$note$);  
 -- Parameterized selection with LIKE and hex literal 
 SELECT u."name", u.bio 
 FROM "Users" AS u 
 WHERE u.id IN (:id1, :id2) 
   AND u.name LIKE 'A%' 
   AND X'DEADBEEF' = X'DEADBEEF' 
 ORDER BY u."name" ASC 
 LIMIT ? OFFSET 10; 