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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `apostas`
--

LOCK TABLES `apostas` WRITE;
/*!40000 ALTER TABLE `apostas` DISABLE KEYS */;
INSERT INTO `apostas` VALUES (1,'Sim',26.00,'2024-11-22 21:47:21',1,1),(2,'Sim',16.00,'2024-11-22 22:53:42',7,4);
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
  PRIMARY KEY (`id_evento`),
  KEY `id_usuario_criador_idx` (`id_usuario_criador`),
  CONSTRAINT `id_usuario_criador` FOREIGN KEY (`id_usuario_criador`) REFERENCES `usuario` (`idusuario`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eventos`
--

LOCK TABLES `eventos` WRITE;
/*!40000 ALTER TABLE `eventos` DISABLE KEYS */;
INSERT INTO `eventos` VALUES (1,'Evento teste 1','Primeiro teste de evento uau',25.00,NULL,'2024-11-23','2024-11-22 14:00:00','2024-11-22 23:59:00',1,'Aprovado'),(3,'Evento teste 2','dfgfsdhsfhfhs',100.00,NULL,'2222-01-01','1111-11-11 11:11:00','1112-11-11 11:11:00',7,'Rejeitado'),(4,'Evento da cris','sei la',15.00,NULL,'2024-11-23','2024-11-21 22:48:00','2024-11-22 22:48:00',8,'Aprovado');
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
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transacoes`
--

LOCK TABLES `transacoes` WRITE;
/*!40000 ALTER TABLE `transacoes` DISABLE KEYS */;
INSERT INTO `transacoes` VALUES (1,1.00,'Cartão de Crédito','2024-11-20 17:59:31',1),(2,200.00,'Cartão de Crédito','2024-11-20 18:00:14',1),(3,23.00,'Cartão de Crédito','2024-11-20 18:11:17',1),(4,-1000.00,'PIX','2024-11-20 18:40:19',1),(5,120.00,'Cartão de Crédito','2024-11-20 18:46:01',1),(6,-15.00,'Transferência Bancária','2024-11-20 18:46:25',1),(7,-100.00,'PIX','2024-11-20 18:47:16',1),(8,1000.00,'Cartão de Crédito','2024-11-20 18:49:23',2),(9,-873.00,'PIX','2024-11-20 19:08:34',2),(10,1276.00,'Cartão de Crédito','2024-11-20 19:10:04',2),(11,-1176.00,'Transferência Bancária','2024-11-20 19:10:23',2),(12,2.00,'Cartão de Crédito','2024-11-20 19:17:26',1),(13,20000.00,'Cartão de Crédito','2024-11-20 19:17:42',1),(14,12.00,'Cartão de Crédito','2024-11-21 19:00:13',3),(15,10.00,'Cartão de Crédito','2024-11-21 19:19:04',5),(16,15.00,'Cartão de Crédito','2024-11-22 22:47:09',8);
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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (1,'Augusto','augustofidelis2003@gmail.com','cavalo1','2003-05-19',00020230.98),(2,'Bolsonaro','bolso@naro.com','bolsonaro','1990-01-01',00000196.00),(3,'teste1','teste1@teste','1234567','2000-01-01',00000012.00),(4,'teste2','teste2@teste','1234567','1999-01-01',00000000.00),(5,'teste3','teste3@teste','1234567','1111-01-01',00000010.00),(6,'teste4','teste4@teste','1234567','2011-01-01',00000000.00),(7,'Moderador','moderador@4bets.com','moderador','2000-01-01',00000000.00),(8,'Miriam','cristina@email','1234567','1969-08-07',00000015.00);
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

-- Dump completed on 2024-11-22 23:38:39
