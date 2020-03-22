-- MySQL dump 10.13  Distrib 5.5.62, for Win64 (AMD64)
--
-- Host: madrid.mfuertes.net    Database: tensiondb2
-- ------------------------------------------------------
-- Server version	5.5.5-10.3.22-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `doctors`
--

DROP TABLE IF EXISTS `doctors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `doctors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `refresh` varchar(255) DEFAULT NULL,
  `name` varchar(20) DEFAULT NULL,
  `lastName` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctors`
--

LOCK TABLES `doctors` WRITE;
/*!40000 ALTER TABLE `doctors` DISABLE KEYS */;
INSERT INTO `doctors` VALUES (1,'test@upna','test_upna',NULL,'Miguel','Fuertes');
/*!40000 ALTER TABLE `doctors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patients`
--

DROP TABLE IF EXISTS `patients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `patients` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) DEFAULT NULL,
  `lastName` varchar(20) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `patient_unique_email_constraint` (`email`),
  CONSTRAINT `CONSTRAINT_1` CHECK (`deleted` in (0,1))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patients`
--

LOCK TABLES `patients` WRITE;
/*!40000 ALTER TABLE `patients` DISABLE KEYS */;
INSERT INTO `patients` VALUES (1,'Miguel','Fuertes','ed@irwin','ed_irwin',0),(2,'Tamera','Schmitt','tamera@schmitt','tamera_schmitt',0),(3,'Efa','Richards','efa@richards','efa_richards',0),(4,'Junayd','Benson','junayd@benson','junayd_benson',0),(5,'Jiya','Povey','jiya@povey','jiya_povey',0),(6,'Keri','Reeve','keri@reeve','keri_reeve',0),(7,'Hina','Moon','hina@moon','hina_moon',0),(8,'Francesca','Guthrie','francesca@guthrie','francesca_guthrie',0),(9,'Malikah','Traynor','malikah@traynor','malikah_traynor',0),(10,'Rayhaan','Knights','rayhaan@knights','rayhaan_knights',0);
/*!40000 ALTER TABLE `patients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patients_info`
--

DROP TABLE IF EXISTS `patients_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `patients_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gender` varchar(8) DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `treatment` text DEFAULT NULL,
  `limit_systolic` int(11) DEFAULT NULL,
  `limit_diastolic` int(11) DEFAULT NULL,
  `rythm_type` int(11) DEFAULT NULL,
  `doctor_id` int(11) DEFAULT NULL,
  `limit_pulse` int(11) DEFAULT NULL,
  `erc` tinyint(1) DEFAULT 0,
  `erc_fg` int(11) DEFAULT 0,
  `asma` tinyint(1) DEFAULT 0,
  `epoc` tinyint(1) DEFAULT 0,
  `dm` tinyint(1) DEFAULT 0,
  `dislipemia` tinyint(1) DEFAULT 0,
  `isquemic_cardiopatia` tinyint(1) DEFAULT 0,
  `prev_insuf_cardiaca` tinyint(1) DEFAULT 0,
  `history` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `doctor_id` (`doctor_id`),
  CONSTRAINT `patients_info_ibfk_1` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patients_info`
--

LOCK TABLES `patients_info` WRITE;
/*!40000 ALTER TABLE `patients_info` DISABLE KEYS */;
INSERT INTO `patients_info` VALUES (1,'Male','1994-06-04',175,'alguno',140,80,1,1,NULL,1,100,0,1,0,0,1,1,'alguna'),(2,'Male','1999-01-17',190,NULL,NULL,NULL,NULL,1,NULL,0,0,0,0,0,0,0,0,NULL),(3,'Female','1964-12-13',160,NULL,NULL,NULL,NULL,1,NULL,0,0,0,0,0,0,0,0,NULL),(4,'Female','1990-11-02',165,NULL,NULL,NULL,NULL,1,NULL,0,0,0,0,0,0,0,0,NULL),(5,'Female','1987-09-18',161,NULL,NULL,NULL,NULL,1,NULL,0,0,0,0,0,0,0,0,NULL),(6,'Female','1987-12-05',163,NULL,NULL,NULL,NULL,1,NULL,0,0,0,0,0,0,0,0,NULL),(7,'Male','1997-10-18',185,NULL,NULL,NULL,NULL,1,NULL,0,0,0,0,0,0,0,0,NULL),(8,'Male','1963-05-13',186,NULL,NULL,NULL,NULL,1,NULL,0,0,0,0,0,0,0,0,NULL),(9,'Male','1987-08-10',175,NULL,NULL,NULL,NULL,1,NULL,0,0,0,0,0,0,0,0,NULL),(10,'Female','1960-03-09',170,NULL,NULL,NULL,NULL,1,NULL,0,0,0,0,0,0,0,0,NULL);
/*!40000 ALTER TABLE `patients_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pressures`
--

DROP TABLE IF EXISTS `pressures`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pressures` (
  `timestamp` datetime NOT NULL,
  `patient_id` int(11) NOT NULL,
  `high` int(11) DEFAULT NULL,
  `low` int(11) DEFAULT NULL,
  `pulse` int(11) DEFAULT NULL,
  PRIMARY KEY (`timestamp`,`patient_id`),
  KEY `patient_id` (`patient_id`),
  CONSTRAINT `pressures_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients_info` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pressures`
--

LOCK TABLES `pressures` WRITE;
/*!40000 ALTER TABLE `pressures` DISABLE KEYS */;
INSERT INTO `pressures` VALUES ('2009-04-29 06:21:03',10,141,77,70),('2009-09-12 06:48:43',7,140,80,70),('2009-10-21 13:10:18',6,140,81,70),('2009-11-08 19:48:26',2,141,81,70),('2009-12-24 04:54:48',3,141,80,70),('2010-02-02 23:43:06',2,142,80,69),('2010-02-17 18:43:49',7,140,80,70),('2010-04-06 22:13:39',7,140,80,70),('2010-07-10 01:14:49',3,141,82,70),('2010-08-18 02:38:39',8,139,80,70),('2010-11-26 17:37:23',8,140,80,70),('2011-01-23 01:00:19',8,140,82,70),('2011-03-18 22:39:11',10,138,79,70),('2011-06-27 23:00:22',4,139,81,70),('2011-10-04 20:04:31',7,139,80,70),('2011-10-25 06:59:23',7,141,81,70),('2011-11-30 00:46:57',10,141,81,70),('2012-03-30 20:40:58',2,137,80,70),('2012-05-30 02:23:04',2,139,79,70),('2012-07-13 08:10:06',10,142,78,70),('2012-09-29 18:47:00',8,140,80,70),('2013-01-15 20:23:42',5,138,80,70),('2013-02-03 20:28:50',9,138,81,70),('2013-02-11 11:11:39',2,143,81,71),('2013-04-03 06:21:04',5,139,83,70),('2013-04-09 10:02:23',9,142,81,70),('2013-05-20 08:55:35',2,137,79,70),('2013-10-04 11:13:38',5,143,81,70),('2014-02-14 06:46:16',9,140,82,70),('2014-04-08 13:20:26',6,141,81,70),('2014-04-29 02:47:13',6,139,82,70),('2014-08-10 20:46:24',2,143,81,70),('2014-08-22 23:52:20',10,141,80,70),('2014-09-14 15:46:07',8,139,81,70),('2014-09-23 06:25:00',6,141,78,71),('2014-11-02 03:51:14',4,139,79,70),('2014-12-31 18:08:54',9,138,80,70),('2015-02-16 06:06:28',1,138,82,70),('2015-04-13 00:46:16',3,141,79,70),('2015-04-22 23:50:38',4,140,79,70),('2015-04-28 00:37:57',4,142,82,70),('2015-06-11 05:15:03',3,141,79,70),('2015-06-11 16:06:42',9,144,79,70),('2015-06-25 11:08:12',3,139,78,70),('2015-10-26 07:16:18',3,140,81,70),('2015-12-25 05:00:24',4,141,80,70),('2016-01-17 03:09:20',8,140,78,70),('2016-02-22 13:03:48',4,138,80,70),('2016-02-26 00:40:33',7,139,79,70),('2016-03-08 22:32:55',8,141,79,70),('2016-03-14 18:35:47',7,138,80,70),('2016-03-19 18:37:33',3,139,78,70),('2016-04-27 00:30:24',4,141,82,70),('2016-06-26 09:33:25',7,139,80,69),('2016-07-28 17:10:11',4,138,80,70),('2016-08-04 12:06:28',10,140,79,70),('2016-08-25 09:50:17',3,141,79,70),('2016-09-22 09:14:47',2,139,81,70),('2016-10-22 07:43:40',3,140,80,70),('2016-11-18 06:50:16',1,139,80,70),('2017-01-03 07:53:51',10,142,80,70),('2017-02-20 08:49:23',10,139,79,70),('2017-05-03 22:51:46',6,141,78,70),('2017-07-26 03:50:51',1,140,82,70),('2017-08-09 20:20:23',1,139,83,70),('2017-08-22 14:30:43',10,141,79,71),('2017-09-09 17:19:25',4,140,79,70),('2017-10-06 16:14:34',1,141,80,70),('2017-10-07 02:41:57',1,142,79,70),('2017-10-11 01:29:01',9,141,78,70),('2017-11-18 00:38:23',8,142,80,70),('2018-01-02 04:52:31',4,140,79,70),('2018-04-14 07:24:54',9,140,79,70),('2018-05-15 05:38:53',10,138,82,70),('2018-08-15 20:01:29',4,140,79,70),('2018-09-22 18:39:58',8,142,81,70),('2018-10-06 11:37:47',5,140,80,70),('2018-10-15 16:38:10',3,142,78,70),('2019-02-06 06:31:51',8,143,82,70),('2019-04-18 00:00:00',3,NULL,NULL,109),('2019-06-02 00:08:31',2,141,77,70),('2019-06-22 16:25:26',6,141,81,70),('2019-07-11 22:56:02',5,139,79,70),('2019-07-14 16:05:18',2,141,80,70),('2019-07-14 16:56:37',2,138,83,70),('2019-07-25 04:26:40',4,141,79,70),('2019-09-19 17:54:31',5,140,80,70),('2019-10-28 13:19:40',9,139,79,70),('2019-11-15 15:44:10',10,141,79,70),('2019-12-17 00:00:00',1,138,82,97),('2020-01-31 02:47:54',8,141,81,70),('2020-02-21 21:39:00',8,141,79,70);
/*!40000 ALTER TABLE `pressures` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `weights`
--

DROP TABLE IF EXISTS `weights`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weights` (
  `timestamp` datetime NOT NULL,
  `patient_id` int(11) NOT NULL,
  `weight` float DEFAULT NULL,
  PRIMARY KEY (`timestamp`,`patient_id`),
  KEY `patient_id` (`patient_id`),
  CONSTRAINT `weights_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients_info` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `weights`
--

LOCK TABLES `weights` WRITE;
/*!40000 ALTER TABLE `weights` DISABLE KEYS */;
INSERT INTO `weights` VALUES ('2009-03-22 20:35:17',6,77.2465),('2009-04-26 17:26:54',8,63.7082),('2009-07-03 14:41:39',4,74.4244),('2009-07-22 22:34:43',6,68.7761),('2009-12-03 23:35:06',1,65.082),('2010-01-10 09:06:29',8,71.7665),('2010-02-11 16:33:03',8,72.7642),('2010-03-27 00:51:36',9,78.2231),('2010-05-05 14:07:19',1,68.0026),('2010-05-24 04:35:54',8,71.2922),('2010-06-15 07:41:22',8,66.6497),('2010-07-18 16:16:23',9,69.1402),('2010-08-04 23:42:18',3,78.9703),('2010-11-04 11:08:19',8,67.0274),('2011-03-11 15:01:13',3,61.0033),('2011-04-11 20:16:14',6,79.2342),('2011-04-26 21:14:29',10,74.6893),('2011-04-30 07:59:35',2,71.5037),('2011-05-15 04:13:51',1,65.3379),('2011-05-27 00:52:46',6,64.6959),('2011-08-03 23:02:49',10,69.6184),('2011-10-24 21:16:40',9,67.2063),('2011-11-01 19:07:03',10,78.3837),('2011-11-27 11:14:58',9,64.3438),('2012-01-10 20:50:42',8,75.9689),('2012-01-25 09:24:54',7,70.7393),('2012-03-18 17:35:59',3,55.8394),('2012-04-20 01:45:53',1,69.1309),('2012-04-30 13:15:28',8,56.7058),('2012-05-04 08:03:10',1,68.0567),('2012-07-01 06:58:14',4,78.5169),('2012-07-15 00:58:11',1,73.3525),('2012-09-26 00:36:46',3,56.767),('2012-10-17 10:01:17',5,71.0899),('2012-10-18 20:54:02',3,62.0925),('2012-11-21 22:42:17',6,60.2166),('2012-12-04 01:37:57',5,69.3191),('2013-03-22 18:02:32',9,74.9929),('2013-08-09 08:13:22',9,80.7485),('2013-11-30 00:29:45',1,63.7895),('2014-01-07 22:34:52',1,70.1115),('2014-02-22 05:08:34',10,67.0125),('2014-02-22 22:12:56',5,74.5241),('2014-02-27 19:12:12',10,55.0073),('2014-05-08 13:44:27',2,77.0143),('2014-07-10 03:27:37',8,73.6391),('2014-08-19 20:59:10',9,64.7677),('2014-08-29 22:49:20',2,61.0542),('2015-03-10 18:25:45',3,78.8982),('2015-04-12 09:19:09',1,52.5692),('2015-06-02 16:52:50',5,62.0259),('2015-07-01 16:38:02',8,77.9315),('2015-07-21 05:12:41',5,67.8546),('2015-08-24 12:10:02',1,60.9933),('2015-10-22 17:22:17',9,61.3969),('2015-10-30 00:18:12',6,62.7551),('2016-01-03 10:59:38',6,75.413),('2016-02-26 17:05:30',4,69.8506),('2016-02-28 03:06:04',2,75.1855),('2016-05-22 01:40:19',4,75.6955),('2016-08-15 00:59:06',9,72.324),('2016-09-08 23:36:26',2,79.2076),('2016-12-12 04:34:08',2,77.0522),('2017-04-07 14:33:23',6,71.9227),('2017-05-15 23:29:44',4,69.3644),('2017-06-10 15:21:17',9,65.8732),('2017-06-16 08:07:22',3,64.0742),('2017-07-10 02:54:16',1,73.3175),('2017-08-01 04:03:07',7,61.6451),('2017-08-02 00:55:23',8,76.0728),('2017-08-03 21:13:30',4,64.0124),('2017-08-25 15:39:37',1,70.8879),('2017-11-13 03:44:52',4,75.8876),('2018-02-05 04:30:41',10,64.0113),('2018-03-29 15:57:05',8,62.0672),('2018-03-31 02:35:57',10,71.3248),('2018-07-07 13:27:59',2,91.1829),('2018-07-24 17:12:52',3,66.6058),('2018-09-29 09:10:39',7,76.3134),('2018-10-16 02:09:09',10,73.0919),('2018-10-28 18:52:49',8,66.0825),('2018-12-29 06:15:27',6,60.8244),('2019-02-07 18:29:45',6,62.6866),('2019-03-05 00:00:00',1,92),('2019-04-14 00:00:00',1,74),('2019-04-22 00:00:00',9,75),('2019-08-08 00:00:00',10,100),('2019-08-20 01:11:00',3,67.4795),('2019-09-09 04:24:34',8,68.2335),('2019-09-19 00:00:00',9,106),('2019-10-08 20:04:07',7,63.057),('2019-10-11 13:04:59',8,80.1547),('2019-11-20 00:00:00',1,86),('2019-12-13 00:02:28',9,55.9503),('2020-01-18 18:24:41',9,73.6466),('2020-02-17 08:46:25',8,72.3907);
/*!40000 ALTER TABLE `weights` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'tensiondb2'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-03-21 10:10:16
