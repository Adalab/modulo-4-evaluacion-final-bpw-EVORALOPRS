CREATE DATABASE books;
USE books;

CREATE TABLE book(
id_Book INT auto_increment primary key,
title VARCHAR(45) not null,
date_public INT,
gender VARCHAR(255),
sypnosis TEXT
);

CREATE TABLE author(
id_author INT auto_increment primary key,
name VARCHAR (30) not null,
lastname VARCHAR (30) not null,
biography TEXT
);

CREATE TABLE reviews(
id_review INT auto_increment primary key,
qualification INT,
comment TEXT
);

CREATE TABLE users(
id_user INT auto_increment primary key,
name VARCHAR (45)
);



-- Claves foráneas 
ALTER TABLE book 
ADD COLUMN id_author INT;

ALTER TABLE book
ADD FOREIGN KEY (id_author) REFERENCES author(id_author);
DESCRIBE book;
DESCRIBE author;



ALTER TABLE reviews
ADD COLUMN id_book INT,
ADD COLUMN id_user INT;

ALTER TABLE reviews
ADD FOREIGN KEY (id_book) REFERENCES book(id_book);

ALTER TABLE reviews 
ADD FOREIGN KEY (id_user) REFERENCES users(id_user);


-- Insertar datos en las tablas 
INSERT INTO book (title,date_public,gender,sypnosis, id_author) VALUES 
('Respondona',2022,'Ensayo','Respondona trata sobre el significado de la conciencia feminista en la vida diaria, la recuperación personal, la superación de la supremacía    blanca y masculina, las relaciones íntimas y, todo ello, explorando el punto donde lo público y lo privado se encuentran.',1),
('Todo sobre el amor','2021','Narrativa','Todo sobre el amor ofrece nuevas formas radicales de pensar sobre el amor al mostrar su interconexión en nuestra vida privada y pública.Ofrece un replanteamiento del amor propio (sin narcisismo) que aporta paz y compasión a nuestra vida personal y profesional, y defiende la importancia del amor para poner fin a las luchas entre individuos, comunidades y sociedades.',1),
('Tokio Blues',2005,'Novela literaria','Mientras aterriza en un aeropuerto europeo, Toru Watanabe, un ejecutivo de 37 años, escucha una vieja canción de los Beatles que le hace retroceder a su juventud, al turbulento Tokio de los años sesenta. Con una mezcla de melancolía y desasosiego, Toru recuerda entonces a la inestable y misteriosa Naoko, la novia de su mejor y único amigo de la adolescencia, Kizuki. El suicidio de éste distanció a Toru y a Naoko durante un año, hasta que se reencontraron e iniciaron una relación íntima. Sin embargo, la aparición de otra mujer en la vida de Toru le lleva a experimentar el deslumbramiento y el desengaño allí donde todo debería cobrar sentido: el sexo, el amor y la muerte. Y ningún de los personajes parece capaz de alcanzar el frágil equilibrio entre las esperanzas juveniles y la necesidad de encontrar un lugar en el mundo.',2),
('La ciudad de los mueros inciertos', 2024,'Novela literaria','Poco se imagina el joven protagonista de esta novela que la chica de la que se ha enamorado está a punto de desaparecer de su vida. Se han conocido durante un concurso entre estudiantes de diferentes institutos, y no pueden verse muy a menudo. En sus encuentros, sentados bajo la glicinia de un parque o paseando a orillas de un río, la joven empieza a hablarle de una extraña ciudad amurallada, situada, al parecer, en otro mundo; poco a poco, ella acaba confesándole su inquietante sensación de que su verdadero yo se halla en esa misteriosa ciudad',2);

SELECT * FROM book;
DELETE FROM book WHERE title IN ('Respondona', 'Todo sobre el amor', 'Tokio Blues', 'La ciduad de los mueros inciertos');
DELETE FROM book WHERE id_book IN(4,8);




INSERT INTO author (name, lastname, biography) VALUES 
('Bell', 'Hooks', 'Gloria Jean Watkins más conocida como Bell Hooks es una prolífica escritora y activista feminista negra, su trabajo ha estado siempre presidido por el estudio y la crítica de la interseccionalidad de género, raza y clase.'),
('Haruki', 'Murakami','Haruki Murakami (Kioto, 1949) es uno de los pocos autores japoneses que han dado el salto de escritor de prestigio a autor con grandes ventas en todo el mundo,n España, ha merecido el Premio Arcebispo Juan de San Clemente, la Orden de las Artes y las Letras, concedida por el Gobierno español, el Premi Internacional Catalunya 2011 y, recientemente, el Premio Princesa de Asturias de las Letras 2023.');

SELECT * FROM author;

INSERT INTO reviews (comment, qualification, id_book ,id_user)
VALUES 
('Comentario 1',9,9,2),
('Cometario 2',10,10,3),
('Comentario 3',9,11,3),
('Comentario 4',7,12,1);
SELECT * FROM reviews;
SELECT * FROM book WHERE id IN (9,10,11,12);


INSERT INTO users(name)
VALUES ('María'),('Hilary'),('Nelson'),('Chauny');

ALTER TABLE users
ADD COLUMN email VARCHAR(45) not null,
ADD COLUMN password VARCHAR(45);


SELECT * FROM users;
SELECT * FROM book JOIN author ON book.id_author = author.id_author WHERE author.name = 'Bell';





