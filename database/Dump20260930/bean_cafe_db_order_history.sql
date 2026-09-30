-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: localhost    Database: bean_cafe_db
-- ------------------------------------------------------
-- Server version	5.5.5-10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `order_history`
--

DROP TABLE IF EXISTS `order_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_history` (
  `history_id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL,
  `status` varchar(20) NOT NULL,
  `updated_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`history_id`),
  KEY `fk_history_order` (`order_id`),
  CONSTRAINT `fk_history_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_history`
--

LOCK TABLES `order_history` WRITE;
/*!40000 ALTER TABLE `order_history` DISABLE KEYS */;
INSERT INTO `order_history` VALUES (40,16,'Pending','2026-09-29 23:49:41'),(41,17,'Pending','2026-09-29 23:50:05'),(42,18,'Pending','2026-09-29 23:50:17'),(43,19,'Pending','2026-09-29 23:50:22'),(44,20,'Pending','2026-09-29 23:50:30'),(45,21,'Pending','2026-09-30 00:19:56'),(46,16,'Preparing','2026-09-30 00:20:03'),(47,16,'Ready','2026-09-30 00:20:06'),(48,16,'Completed','2026-09-30 00:20:08'),(49,17,'Preparing','2026-09-30 00:20:16'),(50,17,'Ready','2026-09-30 00:20:19'),(51,17,'Completed','2026-09-30 00:20:22'),(52,18,'Preparing','2026-09-30 00:20:27'),(53,18,'Ready','2026-09-30 00:20:30'),(54,18,'Completed','2026-09-30 00:20:35'),(55,19,'Preparing','2026-09-30 00:20:43'),(56,19,'Ready','2026-09-30 00:20:48'),(57,19,'Completed','2026-09-30 00:20:53'),(58,20,'Preparing','2026-09-30 00:20:59'),(59,20,'Ready','2026-09-30 00:21:02'),(60,20,'Completed','2026-09-30 00:21:09'),(61,21,'Preparing','2026-09-30 00:21:16'),(62,21,'Ready','2026-09-30 00:21:19'),(63,21,'Completed','2026-09-30 00:21:24'),(64,22,'Pending','2026-09-30 00:22:07'),(65,23,'Pending','2026-09-30 00:22:16'),(66,24,'Pending','2026-09-30 00:22:22'),(67,25,'Pending','2026-09-30 00:22:27'),(68,22,'Preparing','2026-09-30 00:22:33'),(69,23,'Preparing','2026-09-30 00:22:42'),(70,24,'Cancelled','2026-09-30 00:22:52'),(71,25,'Preparing','2026-09-30 00:23:02'),(72,26,'Pending','2026-09-30 00:24:08'),(73,27,'Pending','2026-09-30 00:24:14'),(74,28,'Pending','2026-09-30 00:24:21'),(75,22,'Ready','2026-09-30 00:24:56'),(76,23,'Ready','2026-09-30 00:25:03'),(77,29,'Pending','2026-09-30 10:27:41'),(78,26,'Preparing','2026-09-30 11:06:23'),(79,22,'Completed','2026-09-30 11:06:38');
/*!40000 ALTER TABLE `order_history` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-30 18:08:56
