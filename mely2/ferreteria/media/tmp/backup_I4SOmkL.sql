-- MySQL dump 10.13  Distrib 9.0.1, for Win64 (x86_64)
--
-- Host: localhost    Database: empleadosdb
-- ------------------------------------------------------
-- Server version	9.0.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `api_asistencia`
--

DROP TABLE IF EXISTS `api_asistencia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `api_asistencia` (
  `id` int NOT NULL AUTO_INCREMENT,
  `empleado_id` int NOT NULL,
  `fecha` date DEFAULT NULL,
  `hora` time DEFAULT NULL,
  `cedula` varchar(20) DEFAULT NULL,
  `Hora_entrada` datetime DEFAULT NULL,
  `Hora_salida` datetime DEFAULT NULL,
  `foto` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Codigo_empleado` (`empleado_id`)
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_asistencia`
--

LOCK TABLES `api_asistencia` WRITE;
/*!40000 ALTER TABLE `api_asistencia` DISABLE KEYS */;
INSERT INTO `api_asistencia` VALUES (55,12345678,'2025-05-16','01:01:19',NULL,NULL,NULL,'asistencias/2025/05/16/asistencia_12345678_1747371678725.jpg'),(57,12345678,'2025-05-17','15:59:02',NULL,NULL,NULL,'asistencias/2025/05/17/asistencia_12345678_1747511941967.jpg'),(58,12345678,'2025-05-20','00:34:01',NULL,NULL,NULL,'asistencias/2025/05/20/asistencia_12345678_1747715641251.jpg');
/*!40000 ALTER TABLE `api_asistencia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `api_bono`
--

DROP TABLE IF EXISTS `api_bono`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `api_bono` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `valor` decimal(10,2) NOT NULL,
  `descripcion` longtext NOT NULL,
  `creado_en` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_bono`
--

LOCK TABLES `api_bono` WRITE;
/*!40000 ALTER TABLE `api_bono` DISABLE KEYS */;
INSERT INTO `api_bono` VALUES (1,'Vacaciones',30.00,'Por salir de vacaciones','2025-05-18 00:41:39.820677'),(2,'Tumare',10.00,'es el valor de tumadre','2025-05-18 03:15:52.618557');
/*!40000 ALTER TABLE `api_bono` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `api_cargo`
--

DROP TABLE IF EXISTS `api_cargo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `api_cargo` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `descripcion` longtext,
  `sueldo` decimal(20,2) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_cargo`
--

LOCK TABLES `api_cargo` WRITE;
/*!40000 ALTER TABLE `api_cargo` DISABLE KEYS */;
INSERT INTO `api_cargo` VALUES (1,'Jefe','Administrar las funciones principales de la empresa',10000.00),(2,'Bailarin','Bailarin contratado por el jefe de la empresa el mejor el inigualable el besto bailarin',3000.00),(3,'Encargada','Tallada por los mismos angeles la mejor guarda costas de costa negra',4000.00),(4,'Secretaria','Encargada de las funciones que tiene que ver con la empresa que ayuda a gestionar al gerente de la empresa con todas las funciones relecionadas.',5000.00);
/*!40000 ALTER TABLE `api_cargo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `api_empleado`
--

DROP TABLE IF EXISTS `api_empleado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `api_empleado` (
  `Cedula` int NOT NULL,
  `Codigo_empleado` int NOT NULL,
  `Nombre` varchar(50) DEFAULT NULL,
  `Apellido` varchar(50) DEFAULT NULL,
  `Direccion` varchar(50) DEFAULT NULL,
  `Fecha_Ingreso` date DEFAULT NULL,
  `Codigo_cargo` int DEFAULT NULL,
  `Telefono` varchar(20) DEFAULT NULL,
  `Numero_cuenta` varchar(30) DEFAULT NULL,
  `Tipo_cargo` varchar(50) DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `cargo_id` bigint DEFAULT NULL,
  `foto` varchar(100) DEFAULT NULL,
  `sexo` varchar(1) NOT NULL,
  PRIMARY KEY (`Cedula`),
  UNIQUE KEY `Codigo_empleado` (`Codigo_empleado`),
  KEY `fk_empleado_user` (`user_id`),
  KEY `api_empleado_cargo_id_c4e964dd` (`cargo_id`),
  CONSTRAINT `api_empleado_cargo_id_c4e964dd_fk_api_cargo_id` FOREIGN KEY (`cargo_id`) REFERENCES `api_cargo` (`id`),
  CONSTRAINT `fk_empleado_user` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_empleado`
--

LOCK TABLES `api_empleado` WRITE;
/*!40000 ALTER TABLE `api_empleado` DISABLE KEYS */;
INSERT INTO `api_empleado` VALUES (12345678,1,'Shorekeeper','Costas','Costa Negra',NULL,NULL,'12345678',NULL,NULL,NULL,3,'empleados/fotos/Captura_de_pantalla_2025-05-09_170339_CQdRemM.png','F'),(12398765,4,'Zani','Monteli','Rinacita',NULL,NULL,'12345678',NULL,NULL,NULL,4,'empleados/fotos/Captura_de_pantalla_2025-05-08_081048_NEIXRkH.png','F'),(87654321,2,'Ricardo','Milos','Miami Florida',NULL,NULL,'123456789',NULL,NULL,NULL,2,'empleados/fotos/wp5291411_NzbynT3.png','M');
/*!40000 ALTER TABLE `api_empleado` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `api_pago`
--

DROP TABLE IF EXISTS `api_pago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `api_pago` (
  `id` int NOT NULL AUTO_INCREMENT,
  `empleado_id` int NOT NULL,
  `fecha_inicial` date NOT NULL,
  `fecha_final` date NOT NULL,
  `fecha_pago` datetime DEFAULT CURRENT_TIMESTAMP,
  `sueldo_base` decimal(10,2) NOT NULL,
  `deducciones` decimal(10,2) DEFAULT '0.00',
  `pago_total` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `empleado_id` (`empleado_id`),
  CONSTRAINT `api_pago_ibfk_1` FOREIGN KEY (`empleado_id`) REFERENCES `api_empleado` (`Cedula`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_pago`
--

LOCK TABLES `api_pago` WRITE;
/*!40000 ALTER TABLE `api_pago` DISABLE KEYS */;
INSERT INTO `api_pago` VALUES (2,87654321,'2025-05-01','2025-05-30','2025-05-17 00:00:00',3000.00,30.00,2970.00),(4,12345678,'2025-05-01','2025-05-31','2025-05-18 00:00:00',4000.00,20.00,4010.00),(5,12398765,'2025-05-08','2025-05-22','2025-05-18 00:00:00',5000.00,10.00,5020.00),(6,12398765,'2025-05-15','2025-05-30','2025-05-18 00:00:00',5000.00,5.00,5025.00);
/*!40000 ALTER TABLE `api_pago` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `api_pago_bonos`
--

DROP TABLE IF EXISTS `api_pago_bonos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `api_pago_bonos` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `pago_id` bigint NOT NULL,
  `bono_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `api_pago_bonos_pago_id_bono_id_ec1db053_uniq` (`pago_id`,`bono_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_pago_bonos`
--

LOCK TABLES `api_pago_bonos` WRITE;
/*!40000 ALTER TABLE `api_pago_bonos` DISABLE KEYS */;
INSERT INTO `api_pago_bonos` VALUES (2,4,1),(3,5,1),(4,6,1);
/*!40000 ALTER TABLE `api_pago_bonos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `api_perfilusuario`
--

DROP TABLE IF EXISTS `api_perfilusuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `api_perfilusuario` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `color_favorito` varchar(30) NOT NULL,
  `comida_favorita` varchar(50) NOT NULL,
  `animal_favorito` varchar(30) NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `api_perfilusuario_user_id_e75f0784_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_perfilusuario`
--

LOCK TABLES `api_perfilusuario` WRITE;
/*!40000 ALTER TABLE `api_perfilusuario` DISABLE KEYS */;
INSERT INTO `api_perfilusuario` VALUES (4,'rojo','arroz','pitbull',20),(11,'rojo','tucorazon','gatos',38);
/*!40000 ALTER TABLE `api_perfilusuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `api_permiso`
--

DROP TABLE IF EXISTS `api_permiso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `api_permiso` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date NOT NULL,
  `duracion` int NOT NULL,
  `descripcion` longtext,
  `fecha_registro` datetime(6) NOT NULL,
  `empleado_id` varchar(8) DEFAULT NULL,
  `tipo_permiso_id` bigint NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_permiso`
--

LOCK TABLES `api_permiso` WRITE;
/*!40000 ALTER TABLE `api_permiso` DISABLE KEYS */;
INSERT INTO `api_permiso` VALUES (7,'2025-05-16','2025-05-19',3,'problemas de salud','2025-05-16 07:49:13.297153','12345678',1);
/*!40000 ALTER TABLE `api_permiso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `api_reposo`
--

DROP TABLE IF EXISTS `api_reposo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `api_reposo` (
  `id` int NOT NULL AUTO_INCREMENT,
  `empleado_id` int NOT NULL,
  `tipo_reposo_id` varchar(20) NOT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date NOT NULL,
  `duracion_dias` int NOT NULL,
  `descripcion` text,
  `fecha_registro` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `empleado_id` (`empleado_id`),
  CONSTRAINT `api_reposo_ibfk_1` FOREIGN KEY (`empleado_id`) REFERENCES `api_empleado` (`Cedula`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_reposo`
--

LOCK TABLES `api_reposo` WRITE;
/*!40000 ALTER TABLE `api_reposo` DISABLE KEYS */;
INSERT INTO `api_reposo` VALUES (24,12345678,'1','2025-05-19','2025-05-29',10,'','2025-05-19 00:01:54');
/*!40000 ALTER TABLE `api_reposo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `api_tipopermiso`
--

DROP TABLE IF EXISTS `api_tipopermiso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `api_tipopermiso` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `descripcion` longtext,
  `duracion_dias_fija` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_tipopermiso`
--

LOCK TABLES `api_tipopermiso` WRITE;
/*!40000 ALTER TABLE `api_tipopermiso` DISABLE KEYS */;
INSERT INTO `api_tipopermiso` VALUES (1,'Cita Medica','problemas de salud',3),(2,'Accidente','Situacion en peligro de vida',3),(3,'Fractura','accidente',1),(4,'fallecimiento de familiar','Muerte de algún familiar o alguien cercano.',1);
/*!40000 ALTER TABLE `api_tipopermiso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `api_tiporeposo`
--

DROP TABLE IF EXISTS `api_tiporeposo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `api_tiporeposo` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `descripcion` longtext,
  `duracion_dias_fija` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_tiporeposo`
--

LOCK TABLES `api_tiporeposo` WRITE;
/*!40000 ALTER TABLE `api_tiporeposo` DISABLE KEYS */;
INSERT INTO `api_tiporeposo` VALUES (1,'Discapacidad','',10),(2,'Maternidad','',182),(3,'Paternidad','',14),(4,'Vacaciones','',15);
/*!40000 ALTER TABLE `api_tiporeposo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add asistencia',1,'add_asistencia'),(2,'Can change asistencia',1,'change_asistencia'),(3,'Can delete asistencia',1,'delete_asistencia'),(4,'Can view asistencia',1,'view_asistencia'),(5,'Can add log entry',2,'add_logentry'),(6,'Can change log entry',2,'change_logentry'),(7,'Can delete log entry',2,'delete_logentry'),(8,'Can view log entry',2,'view_logentry'),(9,'Can add permission',3,'add_permission'),(10,'Can change permission',3,'change_permission'),(11,'Can delete permission',3,'delete_permission'),(12,'Can view permission',3,'view_permission'),(13,'Can add group',4,'add_group'),(14,'Can change group',4,'change_group'),(15,'Can delete group',4,'delete_group'),(16,'Can view group',4,'view_group'),(17,'Can add user',5,'add_user'),(18,'Can change user',5,'change_user'),(19,'Can delete user',5,'delete_user'),(20,'Can view user',5,'view_user'),(21,'Can add content type',6,'add_contenttype'),(22,'Can change content type',6,'change_contenttype'),(23,'Can delete content type',6,'delete_contenttype'),(24,'Can view content type',6,'view_contenttype'),(25,'Can add session',7,'add_session'),(26,'Can change session',7,'change_session'),(27,'Can delete session',7,'delete_session'),(28,'Can view session',7,'view_session'),(29,'Can add empleado',8,'add_empleado'),(30,'Can change empleado',8,'change_empleado'),(31,'Can delete empleado',8,'delete_empleado'),(32,'Can view empleado',8,'view_empleado'),(33,'Can add pago',9,'add_pago'),(34,'Can change pago',9,'change_pago'),(35,'Can delete pago',9,'delete_pago'),(36,'Can view pago',9,'view_pago'),(37,'Can add reposo',10,'add_reposo'),(38,'Can change reposo',10,'change_reposo'),(39,'Can delete reposo',10,'delete_reposo'),(40,'Can view reposo',10,'view_reposo'),(41,'Can add perfil usuario',11,'add_perfilusuario'),(42,'Can change perfil usuario',11,'change_perfilusuario'),(43,'Can delete perfil usuario',11,'delete_perfilusuario'),(44,'Can view perfil usuario',11,'view_perfilusuario'),(45,'Can add tipo reposo',12,'add_tiporeposo'),(46,'Can change tipo reposo',12,'change_tiporeposo'),(47,'Can delete tipo reposo',12,'delete_tiporeposo'),(48,'Can view tipo reposo',12,'view_tiporeposo'),(49,'Can add tipo permiso',13,'add_tipopermiso'),(50,'Can change tipo permiso',13,'change_tipopermiso'),(51,'Can delete tipo permiso',13,'delete_tipopermiso'),(52,'Can view tipo permiso',13,'view_tipopermiso'),(53,'Can add permiso',14,'add_permiso'),(54,'Can change permiso',14,'change_permiso'),(55,'Can delete permiso',14,'delete_permiso'),(56,'Can view permiso',14,'view_permiso'),(57,'Can add cargo',15,'add_cargo'),(58,'Can change cargo',15,'change_cargo'),(59,'Can delete cargo',15,'delete_cargo'),(60,'Can view cargo',15,'view_cargo'),(61,'Can add bono',16,'add_bono'),(62,'Can change bono',16,'change_bono'),(63,'Can delete bono',16,'delete_bono'),(64,'Can view bono',16,'view_bono');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
INSERT INTO `auth_user` VALUES (20,'pbkdf2_sha256$1000000$UsETaFyoyTCH0WyioAqcyf$FPbMnjoVcKugaKiaehbQPWe4+p/lqOVENEim3UFMt4A=',NULL,1,'respaldo','','','bienbow@gmail.com',0,1,'2025-05-14 08:07:12.719416'),(38,'pbkdf2_sha256$1000000$zwJG7yIbIII8QIoEXA4jEm$MthneWGjr5tyqS8Ss5LlnE0QsrH9SE9N0u7tVTrFTq4=',NULL,1,'alfin','','','yosoydios3@gmail.com',0,1,'2025-05-16 00:39:04.771365');
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bono_empleado`
--

DROP TABLE IF EXISTS `bono_empleado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bono_empleado` (
  `Codigo_bono` int NOT NULL,
  `Codigo_empleado` int DEFAULT NULL,
  `Fecha_bono` date DEFAULT NULL,
  `Codigo_asistencia` int DEFAULT NULL,
  PRIMARY KEY (`Codigo_bono`),
  KEY `Codigo_empleado` (`Codigo_empleado`),
  KEY `Codigo_asistencia` (`Codigo_asistencia`),
  CONSTRAINT `bono_empleado_ibfk_1` FOREIGN KEY (`Codigo_empleado`) REFERENCES `api_empleado` (`Codigo_empleado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bono_empleado`
--

LOCK TABLES `bono_empleado` WRITE;
/*!40000 ALTER TABLE `bono_empleado` DISABLE KEYS */;
/*!40000 ALTER TABLE `bono_empleado` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cargo`
--

DROP TABLE IF EXISTS `cargo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cargo` (
  `Codigo_cargo` int NOT NULL,
  `Nombre_cargo` varchar(50) DEFAULT NULL,
  `Id_departamento` int DEFAULT NULL,
  `Codigo_empleado` int DEFAULT NULL,
  PRIMARY KEY (`Codigo_cargo`),
  KEY `Codigo_empleado` (`Codigo_empleado`),
  CONSTRAINT `cargo_ibfk_1` FOREIGN KEY (`Codigo_empleado`) REFERENCES `api_empleado` (`Codigo_empleado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cargo`
--

LOCK TABLES `cargo` WRITE;
/*!40000 ALTER TABLE `cargo` DISABLE KEYS */;
/*!40000 ALTER TABLE `cargo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `departamento`
--

DROP TABLE IF EXISTS `departamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `departamento` (
  `ID_Departamento` int NOT NULL AUTO_INCREMENT,
  `Nombre_departamento` varchar(100) NOT NULL,
  `Direccion` varchar(255) DEFAULT NULL,
  `Cod_Cargo` int DEFAULT NULL,
  PRIMARY KEY (`ID_Departamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departamento`
--

LOCK TABLES `departamento` WRITE;
/*!40000 ALTER TABLE `departamento` DISABLE KEYS */;
/*!40000 ALTER TABLE `departamento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (2,'admin','logentry'),(1,'api','asistencia'),(16,'api','bono'),(15,'api','cargo'),(8,'api','empleado'),(9,'api','pago'),(11,'api','perfilusuario'),(14,'api','permiso'),(10,'api','reposo'),(13,'api','tipopermiso'),(12,'api','tiporeposo'),(4,'auth','group'),(3,'auth','permission'),(5,'auth','user'),(6,'contenttypes','contenttype'),(7,'sessions','session');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2025-04-14 15:49:05.483859'),(2,'auth','0001_initial','2025-04-14 15:49:08.550814'),(3,'admin','0001_initial','2025-04-14 15:49:09.394413'),(4,'admin','0002_logentry_remove_auto_add','2025-04-14 15:49:09.409412'),(5,'admin','0003_logentry_add_action_flag_choices','2025-04-14 15:49:09.430818'),(6,'api','0001_initial','2025-04-14 15:49:09.639803'),(7,'contenttypes','0002_remove_content_type_name','2025-04-14 15:49:10.341347'),(8,'auth','0002_alter_permission_name_max_length','2025-04-14 15:49:10.555718'),(9,'auth','0003_alter_user_email_max_length','2025-04-14 15:49:10.790444'),(10,'auth','0004_alter_user_username_opts','2025-04-14 15:49:10.820108'),(11,'auth','0005_alter_user_last_login_null','2025-04-14 15:49:11.322153'),(12,'auth','0006_require_contenttypes_0002','2025-04-14 15:49:11.329101'),(13,'auth','0007_alter_validators_add_error_messages','2025-04-14 15:49:11.355454'),(14,'auth','0008_alter_user_username_max_length','2025-04-14 15:49:11.814227'),(15,'auth','0009_alter_user_last_name_max_length','2025-04-14 15:49:12.237368'),(16,'auth','0010_alter_group_name_max_length','2025-04-14 15:49:12.430126'),(17,'auth','0011_update_proxy_permissions','2025-04-14 15:49:12.454781'),(18,'auth','0012_alter_user_first_name_max_length','2025-04-14 15:49:12.876499'),(19,'sessions','0001_initial','2025-04-14 15:49:13.005256'),(20,'api','0002_alter_asistencia_cedula','2025-04-14 17:45:47.984279'),(21,'api','0002_auto_20250502_1457','2025-05-02 19:05:37.296284'),(22,'api','0002_alter_reposo_empleado','2025-05-03 16:08:44.849082'),(23,'api','0002_alter_asistencia_empleado','2025-05-05 02:57:33.688224'),(24,'api','0003_perfilusuario','2025-05-08 17:23:51.315603'),(25,'api','0002_tiporeposo_duracion_dias_fija','2025-05-08 17:56:03.546543'),(26,'api','0002_empleado_cargo_alter_reposo_tipo_reposo','2025-05-12 04:56:16.101920'),(27,'api','0003_empleado_foto','2025-05-12 18:44:11.161058'),(28,'api','0004_alter_empleado_foto','2025-05-12 19:02:33.768031'),(29,'api','0005_cargo_alter_empleado_cargo','2025-05-12 20:02:15.046451'),(30,'api','0006_empleado_sexo_alter_empleado_cedula_and_more','2025-05-17 21:13:07.295494'),(31,'api','0007_bono','2025-05-17 23:57:26.233601');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('4vfkp9ja6pyxezr6saecjq8mbsxu2wmg','.eJxVjDsOwjAQBe_iGln-rR1R0nMGa73e4ABypDipIu6OI6WA9s3M20XEbS1xa7zEKYurMOLyuyWkF9cD5CfWxyxprusyJXko8qRN3ufM79vp_h0UbKXX3gE7w8zks7J6ANYWQBmrmYggKB6SCeDH0eSMrKAHGpMN2rsuBfH5Atd_NzE:1uEgrr:K9ND9gTLbNVP0nDiNqkzAqRQl5ZIQ3fNYrG7ar-YEu4','2025-05-27 04:03:47.758060'),('cd977ivvxhpp12er1i7t80gz02sspbxz','.eJxVjDsOwjAQBe_iGln-rR1R0nMGa73e4ABypDipIu6OI6WA9s3M20XEbS1xa7zEKYurMOLyuyWkF9cD5CfWxyxprusyJXko8qRN3ufM79vp_h0UbKXX3gE7w8zks7J6ANYWQBmrmYggKB6SCeDH0eSMrKAHGpMN2rsuBfH5Atd_NzE:1uF4JS:EqnT6dVEVBRv0s8Ydx7DOijMvYeHj0nVofmZrVsdvBM','2025-05-28 05:05:50.929414'),('nkmo5br5fecurmgwflchsib4hkpq6txh','.eJxVjMsOwiAQRf-FtSHlkQFcuvcbyAwDUjWQlHZl_Hdt0oVu7znnvkTEba1xG3mJM4uzUOL0uxGmR2474Du2W5ept3WZSe6KPOiQ1875eTncv4OKo35rVIlA-8BMUJwm51FxCMEZDUVBgWRhYnJOofWTsQhoIGTNRuugKIn3B-EMN3o:1u4SU8:DYixfbT8OlJ0bX1DcXsPj5GhUQJ_ZVrKtcOOmwZV8KY','2025-04-28 22:41:00.809504');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `historial_trabajador`
--

DROP TABLE IF EXISTS `historial_trabajador`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `historial_trabajador` (
  `Cedula` int NOT NULL,
  `Id_ingreso` date NOT NULL,
  `Id_egreso` date DEFAULT NULL,
  PRIMARY KEY (`Cedula`,`Id_ingreso`),
  CONSTRAINT `historial_trabajador_ibfk_1` FOREIGN KEY (`Cedula`) REFERENCES `api_empleado` (`Cedula`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historial_trabajador`
--

LOCK TABLES `historial_trabajador` WRITE;
/*!40000 ALTER TABLE `historial_trabajador` DISABLE KEYS */;
/*!40000 ALTER TABLE `historial_trabajador` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `salario`
--

DROP TABLE IF EXISTS `salario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `salario` (
  `Codigo_salario` int NOT NULL,
  `Codigo_empleado` int DEFAULT NULL,
  `Fecha_bono` date DEFAULT NULL,
  `Codigo_asistencia` int DEFAULT NULL,
  PRIMARY KEY (`Codigo_salario`),
  KEY `Codigo_empleado` (`Codigo_empleado`),
  KEY `Codigo_asistencia` (`Codigo_asistencia`),
  CONSTRAINT `salario_ibfk_1` FOREIGN KEY (`Codigo_empleado`) REFERENCES `api_empleado` (`Codigo_empleado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `salario`
--

LOCK TABLES `salario` WRITE;
/*!40000 ALTER TABLE `salario` DISABLE KEYS */;
/*!40000 ALTER TABLE `salario` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-20  3:05:19
