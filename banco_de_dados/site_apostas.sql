-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: site_apostas
-- ------------------------------------------------------
-- Server version	8.0.40

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
-- Table structure for table `apostas`
--

DROP TABLE IF EXISTS `apostas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `apostas` (
  `id_apostas` int NOT NULL AUTO_INCREMENT,
  `resultado_esperado` varchar(45) NOT NULL,
  `valor_aposta` decimal(10,2) NOT NULL,
  `data_aposta` datetime NOT NULL,
  `id_usuario` int NOT NULL,
  `id_evento` int NOT NULL,
  PRIMARY KEY (`id_apostas`),
  KEY `id_usuario_idx` (`id_usuario`),
  KEY `id_evento_idx` (`id_evento`),
  CONSTRAINT `id_evento` FOREIGN KEY (`id_evento`) REFERENCES `eventos` (`id_evento`),
  CONSTRAINT `id_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`idusuario`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `apostas`
--

LOCK TABLES `apostas` WRITE;
/*!40000 ALTER TABLE `apostas` DISABLE KEYS */;
INSERT INTO `apostas` VALUES (1,'Sim',26.00,'2024-11-22 21:47:21',1,1),(2,'Sim',16.00,'2024-11-22 22:53:42',7,4),(3,'Sim',20000.00,'2024-11-23 19:15:57',1,7),(4,'Não',100.00,'2024-11-23 19:20:35',2,7),(5,'Sim',20000.00,'2024-11-23 19:46:04',1,8),(6,'Sim',200.00,'2024-11-23 19:49:17',2,8),(7,'Não',500.00,'2024-11-23 19:50:36',3,8),(8,'Sim',20000.00,'2024-11-23 22:09:13',1,9),(9,'Sim',350.00,'2024-11-23 22:11:45',2,9),(10,'Não',1150.00,'2024-11-23 22:16:01',3,9),(11,'Não',1050.00,'2024-11-23 22:31:55',2,10),(12,'Não',60000.00,'2024-11-23 22:32:18',1,10),(13,'Sim',3000.00,'2024-11-23 22:32:50',3,10),(14,'Não',10000.00,'2024-11-23 22:41:26',1,11),(15,'Não',1000.00,'2024-11-23 22:42:15',2,11),(16,'Sim',5000.00,'2024-11-23 22:42:52',3,11),(17,'Sim',10.00,'2024-11-24 21:25:45',7,13),(18,'Sim',10000.00,'2024-11-24 22:27:12',1,14),(19,'Sim',1000.00,'2024-11-24 22:28:10',2,14),(20,'Não',5000.00,'2024-11-24 22:28:59',9,14),(21,'Sim',10000.00,'2024-11-24 22:44:48',1,15),(22,'Sim',1000.00,'2024-11-24 22:46:04',2,15),(23,'Não',5000.00,'2024-11-24 22:46:39',9,15),(24,'Sim',5000.00,'2024-11-24 22:50:26',1,16),(25,'Não',2500.00,'2024-11-24 22:51:16',2,16),(26,'Não',5000.00,'2024-11-24 22:52:25',9,16);
/*!40000 ALTER TABLE `apostas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eventos`
--

DROP TABLE IF EXISTS `eventos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eventos` (
  `id_evento` int NOT NULL AUTO_INCREMENT,
  `titulo` varchar(50) NOT NULL,
  `descricao` varchar(150) NOT NULL,
  `valor_cota` decimal(10,2) NOT NULL DEFAULT '1.00',
  `categoria` varchar(75) DEFAULT NULL,
  `data_evento` date NOT NULL,
  `data_inicio_apostas` datetime NOT NULL,
  `data_fim_apostas` datetime NOT NULL,
  `id_usuario_criador` int NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'Pendente',
  `resultado` varchar(3) DEFAULT NULL,
  PRIMARY KEY (`id_evento`),
  KEY `id_usuario_criador_idx` (`id_usuario_criador`),
  CONSTRAINT `id_usuario_criador` FOREIGN KEY (`id_usuario_criador`) REFERENCES `usuario` (`idusuario`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eventos`
--

LOCK TABLES `eventos` WRITE;
/*!40000 ALTER TABLE `eventos` DISABLE KEYS */;
INSERT INTO `eventos` VALUES (1,'Evento teste 1','Primeiro teste de evento uau',25.00,NULL,'2024-11-23','2024-11-22 14:00:00','2024-11-22 23:59:00',1,'Aprovado',NULL),(3,'Evento teste 2','dfgfsdhsfhfhs',100.00,NULL,'2222-01-01','1111-11-11 11:11:00','1112-11-11 11:11:00',7,'Rejeitado',NULL),(4,'Evento da cris','sei la',15.00,NULL,'2024-11-23','2024-11-21 22:48:00','2024-11-22 22:48:00',8,'Finalizado','Não'),(5,'Evento teste 3','assfsfafd',10.00,NULL,'2024-11-24','2024-11-22 17:32:00','2024-11-23 23:59:00',1,'Aprovado',NULL),(6,'Evento teste 4','testando',145.00,NULL,'2024-11-26','2024-11-19 17:39:00','2024-11-25 17:39:00',7,'Aprovado',NULL),(7,'Evento teste finalizar','é',10.00,NULL,'2024-11-22','2024-11-21 19:11:00','2024-11-22 19:11:00',1,'Finalizado','Sim'),(8,'Evento teste geral 1','testando',10.00,NULL,'2024-11-22','2024-11-21 19:40:00','2024-11-23 23:40:00',7,'Finalizado','Sim'),(9,'Evento teste geral 2','blabla',3.00,NULL,'2024-11-22','2024-11-21 22:06:00','2024-11-24 22:06:00',1,'Finalizado','Sim'),(10,'Evento teste geral 3','ta quase',3.00,NULL,'2024-11-22','2024-11-21 22:30:00','2024-11-24 22:30:00',2,'Finalizado','Não'),(11,'Eu quero morrer','por favor',3.00,NULL,'2024-11-22','2024-11-21 22:41:00','2024-11-24 22:41:00',1,'Finalizado','Não'),(12,'Evento teste pendente','asdasda',2.00,NULL,'2024-11-23','2024-11-20 20:47:00','2024-11-21 20:47:00',7,'Pendente',NULL),(13,'2131231313','1231313',1.50,NULL,'2024-11-25','2024-11-23 21:22:00','2024-11-25 21:22:00',7,'Aprovado',NULL),(14,'Evento teste final','teste final',3.00,NULL,'2024-11-23','2024-11-22 22:22:00','2024-11-25 22:22:00',7,'Finalizado','Sim'),(15,'Evento teste final 2','por favor',3.00,NULL,'2024-11-23','2024-11-22 22:44:00','2024-11-25 22:44:00',1,'Finalizado','Sim'),(16,'Evento teste final 3','asdadad',2.00,NULL,'2024-11-23','2024-11-22 22:48:00','2024-11-25 22:48:00',7,'Finalizado','Não');
/*!40000 ALTER TABLE `eventos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transacoes`
--

DROP TABLE IF EXISTS `transacoes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transacoes` (
  `id_transacao` int NOT NULL AUTO_INCREMENT,
  `valor_transacao` decimal(10,2) NOT NULL,
  `meio_pagamento` varchar(45) NOT NULL,
  `data_transacao` datetime DEFAULT NULL,
  `idusuario` int NOT NULL,
  PRIMARY KEY (`id_transacao`),
  KEY `idusuario_idx` (`idusuario`),
  CONSTRAINT `idusuario` FOREIGN KEY (`idusuario`) REFERENCES `usuario` (`idusuario`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transacoes`
--

LOCK TABLES `transacoes` WRITE;
/*!40000 ALTER TABLE `transacoes` DISABLE KEYS */;
INSERT INTO `transacoes` VALUES (1,1.00,'Cartão de Crédito','2024-11-20 17:59:31',1),(2,200.00,'Cartão de Crédito','2024-11-20 18:00:14',1),(3,23.00,'Cartão de Crédito','2024-11-20 18:11:17',1),(4,-1000.00,'PIX','2024-11-20 18:40:19',1),(5,120.00,'Cartão de Crédito','2024-11-20 18:46:01',1),(6,-15.00,'Transferência Bancária','2024-11-20 18:46:25',1),(7,-100.00,'PIX','2024-11-20 18:47:16',1),(8,1000.00,'Cartão de Crédito','2024-11-20 18:49:23',2),(9,-873.00,'PIX','2024-11-20 19:08:34',2),(10,1276.00,'Cartão de Crédito','2024-11-20 19:10:04',2),(11,-1176.00,'Transferência Bancária','2024-11-20 19:10:23',2),(12,2.00,'Cartão de Crédito','2024-11-20 19:17:26',1),(13,20000.00,'Cartão de Crédito','2024-11-20 19:17:42',1),(14,12.00,'Cartão de Crédito','2024-11-21 19:00:13',3),(15,10.00,'Cartão de Crédito','2024-11-21 19:19:04',5),(16,15.00,'Cartão de Crédito','2024-11-22 22:47:09',8),(17,200.00,'Cartão de Crédito','2024-11-23 19:48:47',2),(18,500.00,'Cartão de Crédito','2024-11-23 19:50:12',3),(19,-321.05,'PIX','2024-11-23 22:10:01',1),(20,254.00,'Cartão de Crédito','2024-11-23 22:11:22',2),(21,-11.52,'Transferência Bancária','2024-11-23 22:12:15',3),(22,150.00,'Cartão de Crédito','2024-11-23 22:12:45',3),(23,1000.00,'Cartão de Crédito','2024-11-23 22:13:20',3),(24,3000.00,'Cartão de Crédito','2024-11-23 22:32:44',3),(25,10000.00,'Cartão de Crédito','2024-11-23 22:40:41',1),(26,1000.00,'Cartão de Crédito','2024-11-23 22:41:59',2),(27,5000.00,'Cartão de Crédito','2024-11-23 22:42:47',3),(28,123.00,'Cartão de Crédito','2024-11-24 21:19:56',7),(29,-96.00,'PIX','2024-11-24 21:22:04',7),(30,-34200.00,'PIX','2024-11-24 22:24:34',1),(31,10000.00,'Cartão de Crédito','2024-11-24 22:24:55',1),(32,-3385.46,'PIX','2024-11-24 22:27:55',2),(33,1000.00,'Cartão de Crédito','2024-11-24 22:28:04',2),(34,5000.00,'Cartão de Crédito','2024-11-24 22:28:38',9),(35,1000.00,'Cartão de Crédito','2024-11-24 22:45:35',2),(36,5000.00,'Cartão de Crédito','2024-11-24 22:46:33',9),(37,-19800.00,'PIX','2024-11-24 22:47:13',1),(38,-34200.00,'PIX','2024-11-24 22:49:54',1),(39,5000.00,'Cartão de Crédito','2024-11-24 22:50:13',1),(40,-3385.46,'PIX','2024-11-24 22:50:50',2),(41,2500.00,'Cartão de Crédito','2024-11-24 22:51:02',2),(42,5000.00,'Cartão de Crédito','2024-11-24 22:52:14',9);
/*!40000 ALTER TABLE `transacoes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario` (
  `idusuario` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(25) NOT NULL,
  `email` varchar(50) NOT NULL,
  `senha` varchar(75) NOT NULL,
  `data_nascimento` date NOT NULL,
  `saldo` decimal(10,2) unsigned zerofill DEFAULT '00000000.00',
  PRIMARY KEY (`idusuario`),
  UNIQUE KEY `email_UNIQUE` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (1,'Augusto','augustofidelis2003@gmail.com','cavalo1','2003-05-19',00000000.00),(2,'Bolsonaro','bolso@naro.com','bolsonaro','1990-01-01',00006666.67),(3,'teste1','teste1@teste','1234567','2000-01-01',00000000.00),(4,'teste2','teste2@teste','1234567','1999-01-01',00000000.00),(5,'teste3','teste3@teste','1234567','1111-01-01',00000010.00),(6,'teste4','teste4@teste','1234567','2011-01-01',00000000.00),(7,'Moderador','moderador@4bets.com','moderador','2000-01-01',00000013.00),(8,'Miriam','cristina@email','1234567','1969-08-07',00000015.00),(9,'cavalo','cavalo@cavalo','1234567','2024-11-14',00013333.33);
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-24 23:04:49
