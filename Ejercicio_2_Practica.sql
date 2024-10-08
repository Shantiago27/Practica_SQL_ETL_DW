DROP TABLE IF EXISTS alumno CASCADE;
DROP TABLE IF EXISTS profesor CASCADE;
DROP TABLE IF EXISTS modulo CASCADE;
DROP TABLE IF EXISTS bootcamp CASCADE;
DROP TABLE IF EXISTS profesion CASCADE;
DROP TABLE IF EXISTS sexo CASCADE;
DROP TABLE IF EXISTS correo CASCADE;
DROP TABLE IF EXISTS lugar_residencia CASCADE;
DROP TABLE IF EXISTS edad CASCADE;

CREATE TABLE correo (
		correo_id serial PRIMARY KEY,
		desc_correo varchar(255) NOT NULL
		);
		
CREATE TABLE lugar_residencia (
		lugar_residencia_id serial PRIMARY KEY,
		ciudad varchar(255) NOT NULL
		);
		
CREATE TABLE profesion (
		profesion_id serial PRIMARY KEY,
		desc_profesion varchar(255) NOT NULL
		);
		
CREATE TABLE sexo (
		sexo_id serial PRIMARY KEY,
		descripcion_sexo varchar(255) NOT NULL
		);
		
CREATE TABLE edad (
		edad_id serial PRIMARY KEY,
		de_12_18_años int,
		de_18_30_años int,
		de_30_40_años int,
		de_40__50_años int,
		de_50_60_años int,
		de_60_años_en_adelante int
		);

CREATE TABLE modulo (
		modulo_id serial PRIMARY KEY,
		Git_Github int,
		SQL_ETL_DW int,
		Machine_Learning int,
		Deep_Learning int,
		IA int,
		Visualizacion_Datos int);

CREATE TABLE bootcamp(
		bootcamp_id serial PRIMARY KEY,
		Big_Data int,
		IA int,
		Ciberseguridad int,
		Desarrollo_Web int,
		Aprende_a_Programar int,
		Desarrollo_Java int,
		Blockchain int,
		Desarrollo_de_Apps int,
		DevOps_y_Cloud int,
		Marketing_Digital int,
		modulo_id int,
		FOREIGN KEY (modulo_id) REFERENCES MODULO(modulo_id)
		);
		
CREATE TABLE alumno (
		alumno_id serial PRIMARY KEY,
		nombres varchar(255) NOT NULL,
		apellidos varchar(255) NOT NULL,
		correo_id int,
		lugar_residencia_id int,
		profesion_id int,
		edad_id int,
		sexo_id int,
		bootcamp_id int,
		FOREIGN KEY (correo_id) REFERENCES CORREO(correo_id),
		FOREIGN KEY (lugar_residencia_id) REFERENCES LUGAR_RESIDENCIA(lugar_residencia_id),
		FOREIGN KEY (profesion_id) REFERENCES PROFESION(profesion_id),
		FOREIGN KEY (edad_id) REFERENCES EDAD(edad_id),
		FOREIGN KEY (sexo_id) REFERENCES SEXO(sexo_id),
		FOREIGN KEY (bootcamp_id) REFERENCES BOOTCAMP(bootcamp_id)
		);
		
CREATE TABLE profesor (
		profesor_id serial PRIMARY KEY,
		nombre varchar(255) NOT NULL,
		apellido varchar(255) NOT NULL,
		correo_id int,
		lugar_residencia_id int,
		profesion_id int,
		edad_id int,
		sexo_id int,
		bootcamp_id int,
		FOREIGN KEY (correo_id) REFERENCES CORREO(correo_id),
		FOREIGN KEY (lugar_residencia_id) REFERENCES LUGAR_RESIDENCIA(lugar_residencia_id),
		FOREIGN KEY (profesion_id) REFERENCES PROFESION(profesion_id),
		FOREIGN KEY (edad_id) REFERENCES EDAD(edad_id),
		FOREIGN KEY (sexo_id) REFERENCES SEXO(sexo_id),
		FOREIGN KEY (bootcamp_id) REFERENCES BOOTCAMP(bootcamp_id)
		);
		
INSERT INTO correo (correo_id, desc_correo) VALUES
( 1,'primercorreoestudiante@email.com'),
( 2,'segundocorreoestudiante@email.com'),
( 3,'tercercorreoestudiante@email.com'),
( 4,'cuartocorreoestudiante@email.com'),
( 5,'primercorreoprofesor@email.com'),
( 6,'segundocorreoprofesor@email.com'),
( 7,'tercercorreoprofesor@email.com');

INSERT INTO edad (edad_id, de_12_18_años, de_18_30_años, de_30_40_años, de_50_60_años) VALUES
( 1, 1, NULL, NULL, NULL),
( 2, NULL, NULL, 1, NULL),
( 3, NULL, 1, NULL, NULL),
( 4, NULL, NULL, NULL, 1);

INSERT INTO profesion (profesion_id, desc_profesion) VALUES
( 1,'estudiante'),
( 2,'abogado'),
( 3,'ingeniero'),
( 4,'arquitecto');

INSERT INTO sexo (sexo_id, descripcion_sexo) VALUES
( 1,'masculino'),
( 2,'femenino');

INSERT INTO lugar_residencia (lugar_residencia_id, ciudad) VALUES
( 1,'Madrid'),
( 2,'Valencia'),
( 3,'Barcelona'),
( 4,'Panama');

INSERT INTO modulo (modulo_id, Git_Github, SQL_ETL_DW, Machine_Learning, Deep_Learning, IA, Visualizacion_Datos) VALUES
( 1, 1, 1, 1,NULL, NULL, NULL),
( 2, NULL, 1, 1, 1, NULL, NULL),
( 3, NULL, NULL, 1, 1, 1, NULL),
( 4, NULL, NULL, NULL, 1, 1, 1);

INSERT INTO bootcamp (bootcamp_id, Big_Data, IA, Ciberseguridad, Desarrollo_Web, Aprende_a_Programar, Desarrollo_Java, Blockchain, Desarrollo_de_Apps, DevOps_y_Cloud, Marketing_Digital, modulo_id) VALUES
( 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
( 2, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2),
( 3, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3),
( 4, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL, NULL, 4);

INSERT INTO alumno (nombres, apellidos, correo_id, lugar_residencia_id, profesion_id, edad_id, sexo_id, bootcamp_id) VALUES
('Jose','Rodriguez',1, 1, 1, 1, 1, 1),
('Erika','Alban',2, 2, 2, 2, 2, 2),
('Jorge','Gutierrez', 3, 3, 3, 3, 1, 3),
('Andrea','Lopez', 4, 4, 4, 4, 2, 4);

INSERT INTO profesor (nombre, apellido, correo_id, lugar_residencia_id, profesion_id, edad_id, sexo_id, bootcamp_id) VALUES
('Alex','Lopez', 5, 1, 3, 3, 1, 1),
('Fernando','Martinez', 6, 2, 4, 2, 1, 2),
('Sandra','Navarro', 7, 3, 2, 4, 2, 3);

SELECT alumno.nombres
	 , alumno.apellidos
	 , correo.desc_correo
	 , lugar_residencia.ciudad
	 , profesion.desc_profesion
	 , sexo.descripcion_sexo
	 , CASE 
        	WHEN edad.de_12_18_años = 1 THEN '12-18 años'
        	WHEN edad.de_18_30_años = 1 THEN '18-30 años'
        	WHEN edad.de_30_40_años = 1 THEN '30-40 años'
        	WHEN edad.de_50_60_años = 1 THEN '50-60 años'
        	ELSE 'Rango no definido'
    	END AS rango_edad
FROM alumno alumno

JOIN correo
  ON alumno.alumno_id = correo.correo_id
JOIN lugar_residencia
  ON alumno.alumno_id = lugar_residencia.lugar_residencia_id  
JOIN profesion
  ON alumno.alumno_id = profesion.profesion_id  
JOIN edad
  ON alumno.alumno_id = edad.edad_id  
JOIN sexo
  ON alumno.alumno_id = sexo.sexo_id  