-- 1. Crea y agrega al entregable las consultas para completar el setup de acuerdo a lo pedido.
------------TABLA 1---------------------
CREATE TABLE Usuarios (
	id SERIAL UNIQUE,
	email VARCHAR,
	nombre VARCHAR,
	apellido VARCHAR,
	rol VARCHAR
);
---------------------------------
INSERT INTO Usuarios(email, 
					 nombre, 
					 apellido, 
					 rol)
VALUES ('usuario1@admin.com', 
		'Francisco', 
		'Quiroz',
		'administrador');
---------------------------------		
INSERT INTO Usuarios(email, 
					 nombre, 
					 apellido, 
					 rol)
VALUES ('usuario2@user.com', 
		'Ennio', 
		'Basoalto',
		'usuario');
---------------------------------		
INSERT INTO Usuarios(email, 
					 nombre, 
					 apellido, 
					 rol)
VALUES ('usuario3@user.com', 
		'Camila', 
		'Quiroga',
		'usuario');
---------------------------------
INSERT INTO Usuarios(email, 
					 nombre, 
					 apellido, 
					 rol)
VALUES ('usuario4@user.com', 
		'Raul', 
		'Carreno',
		'usuario');
---------------------------------
INSERT INTO Usuarios(email, 
					 nombre, 
					 apellido, 
					 rol)
VALUES ('usuario5@user.com', 
		'Javiera', 
		'Lucksinger',
        'usuario');
------------TABLA 2---------------------
CREATE TABLE Posts (
	id SERIAL UNIQUE,
	titulo VARCHAR,
	contenido TEXT,
	fecha_creacion TIMESTAMP,
	fecha_actualizacion TIMESTAMP,
	destacado BOOLEAN,
	usuario_id BIGINT
);
---------------------------------
INSERT INTO Posts(titulo, 
				  contenido, 
				  fecha_creacion, 
				  fecha_actualizacion, 
				  destacado, 
				  usuario_id)
VALUES ('Manzana', 
		'Manzana roja y jugosa.', 
		'2023-04-10',
		'2023-04-10', 
		true, 
		1);
---------------------------------		
INSERT INTO Posts(titulo, 
				  contenido, 
				  fecha_creacion, 
				  fecha_actualizacion, 
				  destacado, 
				  usuario_id)
VALUES ('Alfombra', 
		'La manzana cayó sobre la alfombra.', 
		'2023-04-11',
		'2023-04-11', 
		false, 
		1);
---------------------------------		
INSERT INTO Posts(titulo, 
				  contenido, 
				  fecha_creacion, 
				  fecha_actualizacion, 
				  destacado, 
				  usuario_id)
VALUES ('Ojos', 
		'Sus ojos brillaban como diamantes.', 
		'2023-04-12',
		'2023-04-12', 
		true, 
		2);
---------------------------------
INSERT INTO Posts(titulo, 
				  contenido, 
				  fecha_creacion, 
				  fecha_actualizacion, 
				  destacado, 
				  usuario_id)
VALUES ('Balcón', 
		'En el balcón, la brisa fresca.', 
		'2023-04-13',
		'2023-04-13', 
		false, 
		3);
---------------------------------
INSERT INTO Posts(titulo, 
				  contenido, 
				  fecha_creacion, 
				  fecha_actualizacion, 
				  destacado, 
				  usuario_id)
VALUES ('Brócoli', 
		'El brócoli es mi verdura favorita.', 
		'2023-04-14',
		'2023-04-14', 
		false, 
        NULL);
------------TABLA 3---------------------
CREATE TABLE Comentarios (
	id SERIAL UNIQUE,
	contenido TEXT,
	fecha_creacion TIMESTAMP,
	usuario_id BIGINT,
	post_id BIGINT
);
---------------------------------
INSERT INTO Comentarios(contenido,
						fecha_creacion,
						usuario_id,
						post_id)
VALUES ('Me encanta el sabor de una manzana roja y jugosa.', 
		'2023-04-20',
		1, 
		1);
---------------------------------
INSERT INTO Comentarios(contenido,
						fecha_creacion,
						usuario_id,
						post_id)
VALUES ('Las manzanas rojas y jugosas son excelentes para preparar ensaladas.', 
		'2023-04-20',
		2, 
		1);
---------------------------------		
INSERT INTO Comentarios(contenido,
						fecha_creacion,
						usuario_id,
						post_id)
VALUES ('Cuando era niño, solía comer manzanas rojas y jugosas todos los días después del colegio.', 
		'2023-04-21',
		3, 
		1);
---------------------------------		
INSERT INTO Comentarios(contenido,
						fecha_creacion,
						usuario_id,
						post_id)
VALUES ('Ahora tendré que limpiar la manzana que cayó sobre la alfombra.', 
		'2023-04-22',
		1, 
		2);
---------------------------------		
INSERT INTO Comentarios(contenido,
						fecha_creacion,
						usuario_id,
						post_id)
VALUES ('La manzana cayó sobre la alfombra y la dejó manchada.', 
		'2023-04-22',
		2, 
        2);
------------------------------------------------------------------------------------------------------------------------------------
-- 2. Cruza los datos de la tabla usuarios y posts mostrando las siguientes columnas. nombre e email del usuario junto al título y contenido del post.
SELECT nombre, email, titulo, contenido
FROM usuarios
FULL JOIN posts on usuarios.id = posts.usuario_id;

-- 3. Muestra el id, título y contenido de los posts de los administradores. El administrador puede ser cualquier id y debe ser seleccionado dinámicamente.
SELECT posts.id, titulo, contenido
FROM posts
FULL JOIN usuarios on posts.usuario_id = usuarios.id
WHERE usuarios.rol = 'administrador';

-- 4. Cuenta la cantidad de posts de cada usuario. La tabla resultante debe mostrar el id e email del usuario junto con la cantidad de posts de cada usuario.
SELECT usuarios.id, email, count(titulo) AS cantidad_de_posts
FROM usuarios
LEFT JOIN posts on usuarios.id = posts.usuario_id
GROUP BY usuarios.id, email
ORDER BY usuarios.id ASC;

-- 5. Muestra el email del usuario que ha creado más posts. Aquí la tabla resultante tiene un único registro y muestra solo el email.
SELECT email
FROM (SELECT usuarios.id, email, count(titulo) AS cantidad_de_posts
	  FROM usuarios
	  LEFT JOIN posts on usuarios.id = posts.usuario_id
	  GROUP BY usuarios.id, email
	  ORDER BY usuarios.id ASC 
	  LIMIT 1) AS top_posts;

-- 6. Muestra la fecha del último post de cada usuario.
-- Hint: Utiliza la función de agregado MAX sobre la fecha de creación.
SELECT usuarios.id, email, nombre, apellido, MAX(fecha_creacion) AS ultimo_post
FROM usuarios
LEFT JOIN posts on usuarios.id = posts.usuario_id
GROUP BY usuarios.id, email, nombre, apellido;

-- 7. Muestra el título y contenido del post (artículo) con más comentarios.
SELECT titulo, posts.contenido, COUNT(comentarios.contenido) AS veces_comentado
FROM posts
LEFT JOIN comentarios ON posts.id = comentarios.post_id
GROUP BY titulo, posts.contenido
ORDER BY veces_comentado DESC
LIMIT 1;

-- 8. Muestra en una tabla el título de cada post, el contenido de cada post y el contenido de cada comentario asociado a los posts mostrados, junto con el email del usuario que lo escribió.
SELECT titulo, posts.contenido AS contenido, comentarioEmail.contenido AS comentarios, email
FROM posts
LEFT JOIN (SELECT comentarios.contenido, email, usuario_id, post_id
		   FROM comentarios
		   LEFT JOIN usuarios ON comentarios.usuario_id = usuarios.id) AS comentarioEmail
ON posts.id = comentarioEmail.post_id;

-- 9. Muestra el contenido del último comentario de cada usuario.
SELECT email, nombre, apellido, comentarios.contenido AS ultimo_comentario
FROM usuarios
LEFT JOIN (SELECT usuario_id, contenido
		   FROM comentarios
		   WHERE (usuario_id, fecha_creacion) IN (SELECT usuario_id, MAX(fecha_creacion)
												  FROM comentarios
												  GROUP BY usuario_id)) AS comentarios 
		   ON comentarios.usuario_id = usuarios.id
ORDER BY usuarios.id;

-- 10. Muestra los emails de los usuarios que no han escrito ningún comentario.
SELECT email
FROM usuarios
LEFT JOIN comentarios ON usuarios.id = comentarios.usuario_id
GROUP BY email, comentarios.contenido
HAVING contenido IS NULL;
