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
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_asistencia`
--

LOCK TABLES `api_asistencia` WRITE;
/*!40000 ALTER TABLE `api_asistencia` DISABLE KEYS */;
INSERT INTO `api_asistencia` VALUES (49,30928863,'2025-05-05','14:17:22',NULL,NULL,NULL,'asistencias/2025/05/05/asistencia_30928863_1746469041413.jpg');
/*!40000 ALTER TABLE `api_asistencia` ENABLE KEYS */;
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
  PRIMARY KEY (`Cedula`),
  UNIQUE KEY `Codigo_empleado` (`Codigo_empleado`),
  KEY `fk_empleado_user` (`user_id`),
  CONSTRAINT `fk_empleado_user` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_empleado`
--

LOCK TABLES `api_empleado` WRITE;
/*!40000 ALTER TABLE `api_empleado` DISABLE KEYS */;
INSERT INTO `api_empleado` VALUES (12345678,4,'Bienvenido','Ramirez','Felix E Mejia',NULL,NULL,'12345678910',NULL,NULL,NULL),(23145678,6,'Joserman','Ramirez','asdasgagasd',NULL,NULL,'12345745732',NULL,NULL,NULL),(30928863,3,'Armando','kkjhjkhkjhj','kjkhkjhkjh',NULL,NULL,'04241586532',NULL,NULL,NULL),(87654321,5,'Bienbo','Martinez','easdrqweqw',NULL,NULL,'82756383753',NULL,NULL,NULL),(99887766,7,'jlhjkhjhkjh','jhkjhkjhkjh','kljkljlkjkljl',NULL,NULL,'09090990909',NULL,NULL,NULL);
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
  `bonos` decimal(10,2) DEFAULT '0.00',
  `deducciones` decimal(10,2) DEFAULT '0.00',
  `pago_total` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `empleado_id` (`empleado_id`),
  CONSTRAINT `api_pago_ibfk_1` FOREIGN KEY (`empleado_id`) REFERENCES `api_empleado` (`Cedula`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_pago`
--

LOCK TABLES `api_pago` WRITE;
/*!40000 ALTER TABLE `api_pago` DISABLE KEYS */;
/*!40000 ALTER TABLE `api_pago` ENABLE KEYS */;
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
  `tipo_reposo` varchar(20) NOT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date NOT NULL,
  `duracion_dias` int NOT NULL,
  `descripcion` text,
  `fecha_registro` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `empleado_id` (`empleado_id`),
  CONSTRAINT `api_reposo_ibfk_1` FOREIGN KEY (`empleado_id`) REFERENCES `api_empleado` (`Cedula`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_reposo`
--

LOCK TABLES `api_reposo` WRITE;
/*!40000 ALTER TABLE `api_reposo` DISABLE KEYS */;
INSERT INTO `api_reposo` VALUES (1,12345678,'PATERNIDAD','2025-05-07','2025-05-20',14,'enfermedad','2025-05-05 07:40:11');
/*!40000 ALTER TABLE `api_reposo` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add asistencia',1,'add_asistencia'),(2,'Can change asistencia',1,'change_asistencia'),(3,'Can delete asistencia',1,'delete_asistencia'),(4,'Can view asistencia',1,'view_asistencia'),(5,'Can add log entry',2,'add_logentry'),(6,'Can change log entry',2,'change_logentry'),(7,'Can delete log entry',2,'delete_logentry'),(8,'Can view log entry',2,'view_logentry'),(9,'Can add permission',3,'add_permission'),(10,'Can change permission',3,'change_permission'),(11,'Can delete permission',3,'delete_permission'),(12,'Can view permission',3,'view_permission'),(13,'Can add group',4,'add_group'),(14,'Can change group',4,'change_group'),(15,'Can delete group',4,'delete_group'),(16,'Can view group',4,'view_group'),(17,'Can add user',5,'add_user'),(18,'Can change user',5,'change_user'),(19,'Can delete user',5,'delete_user'),(20,'Can view user',5,'view_user'),(21,'Can add content type',6,'add_contenttype'),(22,'Can change content type',6,'change_contenttype'),(23,'Can delete content type',6,'delete_contenttype'),(24,'Can view content type',6,'view_contenttype'),(25,'Can add session',7,'add_session'),(26,'Can change session',7,'change_session'),(27,'Can delete session',7,'delete_session'),(28,'Can view session',7,'view_session'),(29,'Can add empleado',8,'add_empleado'),(30,'Can change empleado',8,'change_empleado'),(31,'Can delete empleado',8,'delete_empleado'),(32,'Can view empleado',8,'view_empleado'),(33,'Can add pago',9,'add_pago'),(34,'Can change pago',9,'change_pago'),(35,'Can delete pago',9,'delete_pago'),(36,'Can view pago',9,'view_pago'),(37,'Can add reposo',10,'add_reposo'),(38,'Can change reposo',10,'change_reposo'),(39,'Can delete reposo',10,'delete_reposo'),(40,'Can view reposo',10,'view_reposo');
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
INSERT INTO `auth_user` VALUES (1,'pbkdf2_sha256$1000000$tCjpO4EBGf5uvaDgK3UJRT$3RdmOPrlBuwsWpxsSk4uHebfGFuAZnClswxAm8/Qgps=','2025-04-14 22:41:00.000000',0,'work','','','bienbord07@gmail.com',0,1,'2025-04-14 22:40:14.000000'),(2,'pbkdf2_sha256$1000000$oOEUJkxK4l1bpsurzH8vui$02RJYOvVaZsBK11wAk7vYmMtKsY0APxW5lejA/4+3FE=','2025-05-05 11:54:07.553993',1,'fermil2025','','','ferreteria@gmail.com',1,1,'2025-05-02 21:03:59.363173');
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
INSERT INTO `django_admin_log` VALUES (1,'2025-05-05 11:56:44.102501','1','work',2,'[{\"changed\": {\"fields\": [\"password\"]}}]',5,2),(2,'2025-05-05 11:56:59.673639','1','work',2,'[{\"changed\": {\"fields\": [\"Staff status\", \"Superuser status\"]}}]',5,2);
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (2,'admin','logentry'),(1,'api','asistencia'),(8,'api','empleado'),(9,'api','pago'),(10,'api','reposo'),(4,'auth','group'),(3,'auth','permission'),(5,'auth','user'),(6,'contenttypes','contenttype'),(7,'sessions','session');
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
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2025-04-14 15:49:05.483859'),(2,'auth','0001_initial','2025-04-14 15:49:08.550814'),(3,'admin','0001_initial','2025-04-14 15:49:09.394413'),(4,'admin','0002_logentry_remove_auto_add','2025-04-14 15:49:09.409412'),(5,'admin','0003_logentry_add_action_flag_choices','2025-04-14 15:49:09.430818'),(6,'api','0001_initial','2025-04-14 15:49:09.639803'),(7,'contenttypes','0002_remove_content_type_name','2025-04-14 15:49:10.341347'),(8,'auth','0002_alter_permission_name_max_length','2025-04-14 15:49:10.555718'),(9,'auth','0003_alter_user_email_max_length','2025-04-14 15:49:10.790444'),(10,'auth','0004_alter_user_username_opts','2025-04-14 15:49:10.820108'),(11,'auth','0005_alter_user_last_login_null','2025-04-14 15:49:11.322153'),(12,'auth','0006_require_contenttypes_0002','2025-04-14 15:49:11.329101'),(13,'auth','0007_alter_validators_add_error_messages','2025-04-14 15:49:11.355454'),(14,'auth','0008_alter_user_username_max_length','2025-04-14 15:49:11.814227'),(15,'auth','0009_alter_user_last_name_max_length','2025-04-14 15:49:12.237368'),(16,'auth','0010_alter_group_name_max_length','2025-04-14 15:49:12.430126'),(17,'auth','0011_update_proxy_permissions','2025-04-14 15:49:12.454781'),(18,'auth','0012_alter_user_first_name_max_length','2025-04-14 15:49:12.876499'),(19,'sessions','0001_initial','2025-04-14 15:49:13.005256'),(20,'api','0002_alter_asistencia_cedula','2025-04-14 17:45:47.984279'),(21,'api','0002_auto_20250502_1457','2025-05-02 19:05:37.296284'),(22,'api','0002_alter_reposo_empleado','2025-05-03 16:08:44.849082'),(23,'api','0002_alter_asistencia_empleado','2025-05-05 02:57:33.688224');
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
INSERT INTO `django_session` VALUES ('4vfkp9ja6pyxezr6saecjq8mbsxu2wmg','.eJxVjDsOwjAQBe_iGln-rR1R0nMGa73e4ABypDipIu6OI6WA9s3M20XEbS1xa7zEKYurMOLyuyWkF9cD5CfWxyxprusyJXko8qRN3ufM79vp_h0UbKXX3gE7w8zks7J6ANYWQBmrmYggKB6SCeDH0eSMrKAHGpMN2rsuBfH5Atd_NzE:1uAxZB:Edfkib5BAwy23B8e9iycvzr4QiN0GynCCo-GINyShMo','2025-05-16 21:05:05.546740'),('cd977ivvxhpp12er1i7t80gz02sspbxz','.eJxVjDsOwjAQBe_iGln-rR1R0nMGa73e4ABypDipIu6OI6WA9s3M20XEbS1xa7zEKYurMOLyuyWkF9cD5CfWxyxprusyJXko8qRN3ufM79vp_h0UbKXX3gE7w8zks7J6ANYWQBmrmYggKB6SCeDH0eSMrKAHGpMN2rsuBfH5Atd_NzE:1uBuRA:C8Ie58cOM8sHd_cI5JtGt5bDYJGybQ1oRKZTiJfhcaE','2025-05-19 11:56:44.212430'),('nkmo5br5fecurmgwflchsib4hkpq6txh','.eJxVjMsOwiAQRf-FtSHlkQFcuvcbyAwDUjWQlHZl_Hdt0oVu7znnvkTEba1xG3mJM4uzUOL0uxGmR2474Du2W5ept3WZSe6KPOiQ1875eTncv4OKo35rVIlA-8BMUJwm51FxCMEZDUVBgWRhYnJOofWTsQhoIGTNRuugKIn3B-EMN3o:1u4SU8:DYixfbT8OlJ0bX1DcXsPj5GhUQJ_ZVrKtcOOmwZV8KY','2025-04-28 22:41:00.809504');
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

-- Dump completed on 2025-05-05 20:36:34
