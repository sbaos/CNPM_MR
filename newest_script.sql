-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: localhost    Database: database
-- ------------------------------------------------------
-- Server version	8.0.40

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
-- Current Database: `database`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `database` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `database`;

--
-- Table structure for table `academic_event`
--

DROP TABLE IF EXISTS `academic_event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `academic_event` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `year` int NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `academic_event_chk_1` CHECK ((`year` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `academic_event`
--

LOCK TABLES `academic_event` WRITE;
/*!40000 ALTER TABLE `academic_event` DISABLE KEYS */;
INSERT INTO `academic_event` VALUES (1,'CVPR',2022),(2,'CVPR',2023),(3,'CVPR',2024),(4,'ACCV',2020),(5,'ACCV',2022),(6,'ACCV',2024),(7,'ICJV',2022),(8,'ICJV',2023),(9,'ICJV',2024),(10,'ICJG',2022),(11,'ICJG',2023),(12,'ICJG',2024);
/*!40000 ALTER TABLE `academic_event` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin` (
  `id` int NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `admin_ibfk_1` FOREIGN KEY (`id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES (1),(2),(3),(4);
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `article_benchmark_dataset`
--

DROP TABLE IF EXISTS `article_benchmark_dataset`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `article_benchmark_dataset` (
  `ArticleID` int NOT NULL,
  `DatasetName` varchar(255) NOT NULL,
  `result` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ArticleID`,`DatasetName`),
  KEY `DatasetName` (`DatasetName`),
  CONSTRAINT `article_benchmark_dataset_ibfk_1` FOREIGN KEY (`ArticleID`) REFERENCES `science_article` (`id`),
  CONSTRAINT `article_benchmark_dataset_ibfk_2` FOREIGN KEY (`DatasetName`) REFERENCES `dataset` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `article_benchmark_dataset`
--

LOCK TABLES `article_benchmark_dataset` WRITE;
/*!40000 ALTER TABLE `article_benchmark_dataset` DISABLE KEYS */;
INSERT INTO `article_benchmark_dataset` VALUES (1,'ImageNet','81.02'),(2,'ImageNet','83.07'),(3,'kitti','0.0012'),(4,'kitti','0.0025'),(5,'kitti','16.55'),(6,'kitti','15'),(7,'MNIST','23'),(8,'MNIST','25'),(9,'COCO','42'),(10,'kitti','40'),(11,'kitti','17'),(12,'kitti','23.5'),(13,'MNIST','25'),(14,'MNIST','30'),(15,'kitti','0.0001'),(16,'ImageNet','84.25'),(17,'NeRF','27'),(18,'COCO','37'),(19,'NeRF','18'),(20,'ImageNet','78.75'),(21,'COCO','41.5'),(22,'ImageNet','70.25'),(23,'kitti','27'),(24,'MNIST','30'),(25,'ImageNet','17'),(26,'wiki','40'),(27,'COCO','47.8'),(28,'COCO','49.25');
/*!40000 ALTER TABLE `article_benchmark_dataset` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `article_categorize_subcategory`
--

DROP TABLE IF EXISTS `article_categorize_subcategory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `article_categorize_subcategory` (
  `ArticleID` int NOT NULL,
  `CategoryName` varchar(255) NOT NULL,
  `SubcategoryName` varchar(255) NOT NULL,
  PRIMARY KEY (`ArticleID`,`CategoryName`,`SubcategoryName`),
  KEY `CategoryName` (`CategoryName`,`SubcategoryName`),
  CONSTRAINT `article_categorize_subcategory_ibfk_1` FOREIGN KEY (`ArticleID`) REFERENCES `science_article` (`id`),
  CONSTRAINT `article_categorize_subcategory_ibfk_2` FOREIGN KEY (`CategoryName`, `SubcategoryName`) REFERENCES `subcategory` (`CategoryName`, `SubcategoryName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `article_categorize_subcategory`
--

LOCK TABLES `article_categorize_subcategory` WRITE;
/*!40000 ALTER TABLE `article_categorize_subcategory` DISABLE KEYS */;
INSERT INTO `article_categorize_subcategory` VALUES (4,'Depth Estimation','Monocular Depth Estimation'),(11,'Depth Estimation','Monocular Depth Estimation'),(7,'Generated Model','Adversarial Learning'),(8,'Generated Model','Adversarial Learning'),(13,'Generated Model','Adversarial Learning'),(14,'Generated Model','Adversarial Learning'),(17,'Generated Model','Adversarial Learning'),(20,'Generated Model','Adversarial Learning'),(23,'Generated Model','Diffusion'),(24,'Generated Model','Diffusion'),(21,'Object Detection','2D Object Detection'),(27,'Object Detection','2D Object Detection'),(28,'Object Detection','2D Object Detection'),(5,'Object Detection','3D Object Detection'),(10,'Object Detection','3D Object Detection'),(19,'Object Detection','3D Object Detection'),(6,'Reconstruction','Gaussian Splatting'),(12,'Reconstruction','Gaussian Splatting'),(17,'Reconstruction','NerF'),(19,'Reconstruction','NerF'),(3,'Self-supervised','Semi-supervised'),(4,'Self-supervised','Semi-supervised'),(8,'Self-supervised','Semi-supervised'),(9,'Self-supervised','Semi-supervised'),(10,'Self-supervised','Semi-supervised'),(15,'Self-supervised','Semi-supervised'),(20,'Self-supervised','Semi-supervised'),(26,'Sequence Model','State Space Model'),(1,'Transformer','Local Transformer'),(2,'Transformer','Local Transformer'),(1,'Transformer','Vision Transformer'),(2,'Transformer','Vision Transformer'),(16,'Transformer','Vision Transformer'),(18,'Transformer','Vision Transformer'),(22,'Visual Classification','Image Classification'),(25,'Visual Classification','Image Classification');
/*!40000 ALTER TABLE `article_categorize_subcategory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `article_cite_article`
--

DROP TABLE IF EXISTS `article_cite_article`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `article_cite_article` (
  `CitingArticleID` int NOT NULL,
  `CitedArticleID` int NOT NULL,
  PRIMARY KEY (`CitingArticleID`,`CitedArticleID`),
  KEY `CitedArticleID` (`CitedArticleID`),
  CONSTRAINT `article_cite_article_ibfk_1` FOREIGN KEY (`CitingArticleID`) REFERENCES `science_article` (`id`),
  CONSTRAINT `article_cite_article_ibfk_2` FOREIGN KEY (`CitedArticleID`) REFERENCES `science_article` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `article_cite_article`
--

LOCK TABLES `article_cite_article` WRITE;
/*!40000 ALTER TABLE `article_cite_article` DISABLE KEYS */;
INSERT INTO `article_cite_article` VALUES (3,1),(26,1),(4,2),(5,3),(6,4),(9,7),(10,8),(11,9),(12,10),(15,13),(16,14),(17,15),(18,16),(21,19),(22,20),(23,21),(24,22),(1,25),(2,25),(7,25),(8,25),(13,25),(14,25),(19,25),(20,25),(26,25),(27,25),(28,25);
/*!40000 ALTER TABLE `article_cite_article` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `article_discount_coupon`
--

DROP TABLE IF EXISTS `article_discount_coupon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `article_discount_coupon` (
  `Id` int NOT NULL,
  PRIMARY KEY (`Id`),
  CONSTRAINT `article_discount_coupon_ibfk_1` FOREIGN KEY (`Id`) REFERENCES `discount_coupon` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `article_discount_coupon`
--

LOCK TABLES `article_discount_coupon` WRITE;
/*!40000 ALTER TABLE `article_discount_coupon` DISABLE KEYS */;
INSERT INTO `article_discount_coupon` VALUES (1),(2),(3),(4);
/*!40000 ALTER TABLE `article_discount_coupon` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `article_keyword`
--

DROP TABLE IF EXISTS `article_keyword`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `article_keyword` (
  `ArticleID` int NOT NULL,
  `Keyword` varchar(255) NOT NULL,
  PRIMARY KEY (`ArticleID`,`Keyword`),
  CONSTRAINT `article_keyword_ibfk_1` FOREIGN KEY (`ArticleID`) REFERENCES `science_article` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `article_keyword`
--

LOCK TABLES `article_keyword` WRITE;
/*!40000 ALTER TABLE `article_keyword` DISABLE KEYS */;
INSERT INTO `article_keyword` VALUES (1,'Deformable Attention'),(1,'Vision Transformer'),(2,'Swin Transformer'),(3,'Depth Estimation'),(3,'Self-Supervised'),(4,'Monocular Depth Estimation'),(4,'Self-Supervised'),(4,'Transformer'),(5,'Complementary Depths'),(5,'Monocular 3D Object Detection'),(6,'Gausian Splatting'),(6,'SLAM'),(7,'Adversarial'),(7,'Human Motion Prediction'),(8,'GAN'),(8,'Semi-Supervised'),(9,'Semantic Segmentation'),(9,'Semi-Supervised'),(10,'3D Instance Segmentation'),(11,'RGB Tracking'),(12,'Scence Understanding'),(13,'GAN'),(14,'Adversarial'),(15,'Semi-Supervised'),(16,'Vision Transformer'),(17,'GAN'),(17,'NerF'),(18,'Semantic Segmentation'),(18,'Vision Transformer'),(19,'3D Shape Regconition'),(20,'GAN'),(20,'Semi-Supervised'),(21,'Object Detection'),(22,'Image Classification'),(23,'Diffusion'),(24,'Diffusion'),(25,'Relaxation'),(26,'SSM'),(27,'Object Detection'),(27,'RT-DETR'),(28,'Object Detection'),(28,'YOLO');
/*!40000 ALTER TABLE `article_keyword` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `article_subcategory_discount_coupon`
--

DROP TABLE IF EXISTS `article_subcategory_discount_coupon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `article_subcategory_discount_coupon` (
  `Id` int NOT NULL,
  PRIMARY KEY (`Id`),
  CONSTRAINT `article_subcategory_discount_coupon_ibfk_1` FOREIGN KEY (`Id`) REFERENCES `type_article_discount_coupon` (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `article_subcategory_discount_coupon`
--

LOCK TABLES `article_subcategory_discount_coupon` WRITE;
/*!40000 ALTER TABLE `article_subcategory_discount_coupon` DISABLE KEYS */;
INSERT INTO `article_subcategory_discount_coupon` VALUES (9),(10),(11),(12);
/*!40000 ALTER TABLE `article_subcategory_discount_coupon` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `author`
--

DROP TABLE IF EXISTS `author`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `author` (
  `orcid` int NOT NULL AUTO_INCREMENT,
  `BirthDate` date DEFAULT NULL,
  `PenName` varchar(255) DEFAULT NULL,
  `Lname` varchar(255) DEFAULT NULL,
  `Fname` varchar(255) DEFAULT NULL,
  `DomainConflict` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`orcid`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `author`
--

LOCK TABLES `author` WRITE;
/*!40000 ALTER TABLE `author` DISABLE KEYS */;
INSERT INTO `author` VALUES (1,'2000-12-01','Zhuofan Xia','Xia','Zhuofan','Tsinghua University'),(2,'2000-12-02','Ze Liu','Liu','Ze','microsoft.com'),(3,'2000-12-03','Haozhe Si','Si','Haozhe','illinois.edu'),(4,'2000-12-04','Ning Zhang','Zhang','Ning','utwente.nl'),(5,'2000-12-05','Longfei Yan','Yan','Longfei','hust.edu.cn'),(6,'2000-12-06','Hidenobu Matsuki','Matsuki','Hidenobu','imperial.ac.uk'),(7,'2000-12-07','Xianjin CHAO','CHAO','Xianjin','cityu.edu.hk'),(8,'2000-12-08','Jiaze Sun','Sun','Jiaze','imperial.ac.uk'),(9,'2000-12-09','Yunyang Zhang','Zhang','Yunyang','csu.ac.cn'),(10,'2000-12-10','Linghua Tang','Tang','Linghua','just.edu.vn'),(11,'2000-12-11','Yu Liu','Liu','Yu','Xinjiang University'),(12,'2000-12-12','Markus Schon','Schon','Markus','uni-ulm.de'),(13,'2000-12-13','Jiapeng Zhu','Zhu','Jiapeng','Xiaomi AI Lab'),(14,'2000-12-14','Rui Shao','Shao','Rui','comp.hkbu.edu.hk'),(15,'2000-12-15','Yue Fan','Fan','Yue','mpi-inf.mpg.de'),(16,'2000-12-16','Qiming Zhang','Zhang','Qiming','uni.sydney.edu.au'),(17,'2000-12-17','Yushi Lan','Lan','Yushi','e.ntu.edu.sg'),(18,'2000-12-18','Bowen Zhang','Zhang','Bowen','adelaide.edu.au'),(19,'2000-12-19','Huazhen Chu','Chu','Huazhen','xs.ustb.edu.cn'),(20,'2000-12-20','Lei Wang','Wang','Lei','alum.mit.edu'),(21,'2000-12-21','Shuhan Chen','Chen','Shuhan','yzu.edu.cn'),(22,'2000-12-22','Ali Nozaripour','Nozaripour','Ali','semnan.ac.ir'),(23,'2000-12-23','Junzhong Ji','Ji','Junzhong','bju.edu.cn'),(24,'2000-12-24','JiaYan Wen','Wen','JiaYan','gu.edu.cn'),(25,'2000-12-25','Geoffrey Hinton','Hinton','Geoffrey','cs.toronto.edu'),(26,'2000-12-26','Albert Gu','Gu','Albert','andrew.cmu.edu'),(27,'2000-12-27','Shuo Wang','Wang','Shuo','baidu.com'),(28,'2000-12-28','Rahima Khanam','Khanam','Rahima','had.ac.uk');
/*!40000 ALTER TABLE `author` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `author_social_account`
--

DROP TABLE IF EXISTS `author_social_account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `author_social_account` (
  `ORCID` int NOT NULL,
  `SocialAccount` varchar(255) NOT NULL,
  PRIMARY KEY (`ORCID`,`SocialAccount`),
  CONSTRAINT `author_social_account_ibfk_1` FOREIGN KEY (`ORCID`) REFERENCES `author` (`orcid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `author_social_account`
--

LOCK TABLES `author_social_account` WRITE;
/*!40000 ALTER TABLE `author_social_account` DISABLE KEYS */;
/*!40000 ALTER TABLE `author_social_account` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `author_write_article`
--

DROP TABLE IF EXISTS `author_write_article`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `author_write_article` (
  `ArticleID` int NOT NULL,
  `ORCID` int NOT NULL,
  PRIMARY KEY (`ArticleID`,`ORCID`),
  KEY `ORCID` (`ORCID`),
  CONSTRAINT `author_write_article_ibfk_1` FOREIGN KEY (`ArticleID`) REFERENCES `science_article` (`id`),
  CONSTRAINT `author_write_article_ibfk_2` FOREIGN KEY (`ORCID`) REFERENCES `author` (`orcid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `author_write_article`
--

LOCK TABLES `author_write_article` WRITE;
/*!40000 ALTER TABLE `author_write_article` DISABLE KEYS */;
INSERT INTO `author_write_article` VALUES (1,1),(2,2),(3,3),(4,4),(5,5),(6,6),(7,7),(8,8),(9,9),(10,10),(11,11),(12,12),(13,13),(14,14),(15,15),(16,16),(17,17),(18,18),(19,19),(20,20),(21,21),(22,22),(23,23),(24,24),(25,25),(26,26),(27,27),(28,28);
/*!40000 ALTER TABLE `author_write_article` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart`
--

DROP TABLE IF EXISTS `cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart` (
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart`
--

LOCK TABLES `cart` WRITE;
/*!40000 ALTER TABLE `cart` DISABLE KEYS */;
INSERT INTO `cart` VALUES (1),(2),(3),(4);
/*!40000 ALTER TABLE `cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart_has_article`
--

DROP TABLE IF EXISTS `cart_has_article`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart_has_article` (
  `CartID` int NOT NULL,
  `ArticleID` int NOT NULL,
  PRIMARY KEY (`CartID`,`ArticleID`),
  KEY `ArticleID` (`ArticleID`),
  CONSTRAINT `cart_has_article_ibfk_1` FOREIGN KEY (`CartID`) REFERENCES `cart` (`id`),
  CONSTRAINT `cart_has_article_ibfk_2` FOREIGN KEY (`ArticleID`) REFERENCES `science_article` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_has_article`
--

LOCK TABLES `cart_has_article` WRITE;
/*!40000 ALTER TABLE `cart_has_article` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart_has_article` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `CategoryName` varchar(255) NOT NULL,
  `Description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`CategoryName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES ('Depth Estimation','Depth estimation is the process of determining the distance of objects in a scene from a camera.'),('Generated Model','A generative model is a statistical model that can generate new data instances that are similar to the training data.'),('Object Detection','Object detection is a computer vision technique that identifies and locates objects within an image or video.'),('Reconstruction','reconstruction refers to the process of generating a complete and accurate representation of data from partial or corrupted input'),('Self-supervised','Self-supervised learning is a machine learning technique where models learn from unlabeled data by creating their own training tasks.'),('Sequence Model','Sequence models are machine learning models designed to process and generate sequential data, such as text, time series, or audio.'),('Transformer','Transformer models are a type of neural network that excels at processing sequential data, like text.'),('Visual Classification','Visual classification is the process of assigning labels to images based on their visual content');
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `collection`
--

DROP TABLE IF EXISTS `collection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `collection` (
  `ReaderID` int NOT NULL,
  `Name` varchar(255) NOT NULL,
  PRIMARY KEY (`ReaderID`,`Name`),
  CONSTRAINT `collection_ibfk_1` FOREIGN KEY (`ReaderID`) REFERENCES `reader` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `collection`
--

LOCK TABLES `collection` WRITE;
/*!40000 ALTER TABLE `collection` DISABLE KEYS */;
INSERT INTO `collection` VALUES (5,'Collection51'),(5,'Collection52'),(6,'Collection61'),(6,'Collection62'),(6,'Collection63'),(7,'Collection71'),(7,'Collection72'),(8,'Collection81');
/*!40000 ALTER TABLE `collection` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `collection_contain_article`
--

DROP TABLE IF EXISTS `collection_contain_article`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `collection_contain_article` (
  `ReaderID` int NOT NULL,
  `Name` varchar(255) NOT NULL,
  `ArticleID` int NOT NULL,
  PRIMARY KEY (`ReaderID`,`Name`,`ArticleID`),
  KEY `ArticleID` (`ArticleID`),
  CONSTRAINT `collection_contain_article_ibfk_1` FOREIGN KEY (`ReaderID`, `Name`) REFERENCES `collection` (`ReaderID`, `Name`),
  CONSTRAINT `collection_contain_article_ibfk_2` FOREIGN KEY (`ArticleID`) REFERENCES `science_article` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `collection_contain_article`
--

LOCK TABLES `collection_contain_article` WRITE;
/*!40000 ALTER TABLE `collection_contain_article` DISABLE KEYS */;
INSERT INTO `collection_contain_article` VALUES (5,'Collection51',1),(7,'Collection71',1),(5,'Collection51',2),(5,'Collection51',3),(7,'Collection71',3),(5,'Collection51',4),(5,'Collection51',5),(7,'Collection71',5),(5,'Collection51',6),(5,'Collection52',7),(7,'Collection72',7),(5,'Collection52',8),(5,'Collection52',9),(7,'Collection72',9),(5,'Collection52',10),(5,'Collection52',11),(7,'Collection72',11),(5,'Collection52',12),(6,'Collection61',13),(8,'Collection81',13),(6,'Collection61',14),(6,'Collection61',15),(8,'Collection81',15),(6,'Collection61',16),(6,'Collection61',17),(8,'Collection81',17),(6,'Collection61',18),(6,'Collection62',19),(8,'Collection81',19),(6,'Collection62',20),(6,'Collection62',21),(6,'Collection62',22),(6,'Collection62',23),(6,'Collection62',24),(6,'Collection63',25),(6,'Collection63',26),(6,'Collection63',27),(6,'Collection63',28);
/*!40000 ALTER TABLE `collection_contain_article` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `conference`
--

DROP TABLE IF EXISTS `conference`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `conference` (
  `id` int NOT NULL AUTO_INCREMENT,
  `area` varchar(255) NOT NULL,
  `sponsors` varchar(255) DEFAULT NULL,
  `rank` enum('A*','A','B','C','D') DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `conference_ibfk_1` FOREIGN KEY (`id`) REFERENCES `academic_event` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `conference`
--

LOCK TABLES `conference` WRITE;
/*!40000 ALTER TABLE `conference` DISABLE KEYS */;
INSERT INTO `conference` VALUES (1,'Louisiana, USA','Google','A*'),(2,'Vancouver, Canada','Facebook','A*'),(3,'Washington, USA','Amazon','A*'),(4,'Kyoto, Japan','Google','B'),(5,'Macau, China','Sapien','B'),(6,'Hanoi, VietNam','Google','B');
/*!40000 ALTER TABLE `conference` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cost_base_discount_coupon`
--

DROP TABLE IF EXISTS `cost_base_discount_coupon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cost_base_discount_coupon` (
  `Id` int NOT NULL,
  `CostCondition` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  CONSTRAINT `cost_base_discount_coupon_ibfk_1` FOREIGN KEY (`Id`) REFERENCES `payment_discount_coupon` (`Id`),
  CONSTRAINT `cost_base_discount_coupon_chk_1` CHECK ((`CostCondition` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cost_base_discount_coupon`
--

LOCK TABLES `cost_base_discount_coupon` WRITE;
/*!40000 ALTER TABLE `cost_base_discount_coupon` DISABLE KEYS */;
INSERT INTO `cost_base_discount_coupon` VALUES (5,100.00),(6,150.00),(7,75.00),(8,125.00);
/*!40000 ALTER TABLE `cost_base_discount_coupon` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dataset`
--

DROP TABLE IF EXISTS `dataset`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dataset` (
  `name` varchar(255) NOT NULL,
  `Description` varchar(255) DEFAULT NULL,
  `size` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dataset`
--

LOCK TABLES `dataset` WRITE;
/*!40000 ALTER TABLE `dataset` DISABLE KEYS */;
INSERT INTO `dataset` VALUES ('COCO','COCO (Common Objects in Context) is a large-scale object detection, segmentation, and captioning dataset.','200'),('ImageNet','ImageNet is a massive image database with over 14 million images, used for training and benchmarking computer vision models, particularly in image classification and object detection.','2000'),('kitti','KITTI is a popular dataset for autonomous driving research, containing real-world sensor data like images, LiDAR scans, and GPS/IMU data.','100'),('MNIST','The MNIST dataset is a large database of handwritten digits, commonly used for training and testing image processing systems and machine learning models.','10'),('NeRF','The NeRF dataset is a collection of images used to train Neural Radiance Fields (NeRF) models.','150'),('wiki','Wiki Datasets are collections of data extracted from Wikipedia articles. They are often used for various natural language processing (NLP) tasks, such as text classification, summarization, and machine translation.','1500');
/*!40000 ALTER TABLE `dataset` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dataset_for_subcategory`
--

DROP TABLE IF EXISTS `dataset_for_subcategory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dataset_for_subcategory` (
  `DatasetName` varchar(255) NOT NULL,
  `CategoryName` varchar(255) NOT NULL,
  `SubcategoryName` varchar(255) NOT NULL,
  PRIMARY KEY (`DatasetName`,`CategoryName`,`SubcategoryName`),
  KEY `CategoryName` (`CategoryName`,`SubcategoryName`),
  CONSTRAINT `dataset_for_subcategory_ibfk_1` FOREIGN KEY (`DatasetName`) REFERENCES `dataset` (`name`),
  CONSTRAINT `dataset_for_subcategory_ibfk_2` FOREIGN KEY (`CategoryName`, `SubcategoryName`) REFERENCES `subcategory` (`CategoryName`, `SubcategoryName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dataset_for_subcategory`
--

LOCK TABLES `dataset_for_subcategory` WRITE;
/*!40000 ALTER TABLE `dataset_for_subcategory` DISABLE KEYS */;
/*!40000 ALTER TABLE `dataset_for_subcategory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `discount_coupon`
--

DROP TABLE IF EXISTS `discount_coupon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `discount_coupon` (
  `id` int NOT NULL AUTO_INCREMENT,
  `VipTierRequired` enum('0','1','2','3','4','5') DEFAULT NULL,
  `TimeStart` timestamp NULL DEFAULT NULL,
  `TimeEnd` timestamp NULL DEFAULT NULL,
  `Discount` float DEFAULT NULL,
  `DiscountUnit` enum('%','$') DEFAULT NULL,
  `AdminID` int DEFAULT NULL,
  `CreatedTime` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `AdminID` (`AdminID`),
  CONSTRAINT `discount_coupon_ibfk_1` FOREIGN KEY (`AdminID`) REFERENCES `admin` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `discount_coupon`
--

LOCK TABLES `discount_coupon` WRITE;
/*!40000 ALTER TABLE `discount_coupon` DISABLE KEYS */;
INSERT INTO `discount_coupon` VALUES (1,'5','2024-11-19 17:00:00','2024-12-30 17:00:00',20,'%',1,'2024-11-20 03:30:30'),(2,'0','2024-05-19 17:00:00','2024-07-30 17:00:00',5,'$',1,'2024-05-20 03:30:30'),(3,'3','2024-11-19 17:00:00','2024-12-30 17:00:00',12,'%',1,'2024-11-20 03:30:30'),(4,'4','2024-11-19 17:00:00','2024-12-30 17:00:00',10,'$',1,'2024-11-21 03:30:30'),(5,'0','2024-11-19 17:00:00','2024-12-30 17:00:00',2,'%',2,'2024-11-22 03:30:30'),(6,'1','2024-11-19 17:00:00','2024-12-30 17:00:00',3,'$',2,'2024-11-23 03:30:30'),(7,'2','2024-11-19 17:00:00','2024-12-30 17:00:00',5,'%',2,'2024-11-24 03:30:30'),(8,'0','2024-11-19 17:00:00','2024-12-30 17:00:00',2,'$',2,'2024-11-25 03:30:30'),(9,'1','2024-11-20 17:00:00','2024-12-31 17:00:00',4,'%',3,'2024-11-26 03:30:30'),(10,'2','2024-11-21 17:00:00','2025-01-01 17:00:00',5,'$',3,'2024-11-27 03:30:30'),(11,'0','2024-11-22 17:00:00','2025-01-02 17:00:00',4,'%',3,'2024-11-28 03:30:30'),(12,'4','2024-11-23 17:00:00','2025-01-03 17:00:00',5,'$',3,'2024-11-29 03:30:30'),(13,'1','2024-11-24 17:00:00','2025-01-04 17:00:00',6,'%',4,'2024-11-30 03:30:30'),(14,'0','2024-11-25 17:00:00','2025-01-05 17:00:00',1,'$',4,'2024-12-01 03:30:30'),(15,'3','2024-11-26 17:00:00','2025-01-06 17:00:00',10,'%',4,'2024-12-02 03:30:30'),(16,'5','2024-11-27 17:00:00','2025-01-07 17:00:00',25,'$',4,'2024-12-03 03:30:30');
/*!40000 ALTER TABLE `discount_coupon` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `discount_on_academic_event`
--

DROP TABLE IF EXISTS `discount_on_academic_event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `discount_on_academic_event` (
  `EventCouponID` int NOT NULL,
  `EventID` int NOT NULL,
  PRIMARY KEY (`EventCouponID`,`EventID`),
  KEY `EventID` (`EventID`),
  CONSTRAINT `discount_on_academic_event_ibfk_1` FOREIGN KEY (`EventCouponID`) REFERENCES `paper_academic_discount_coupon` (`Id`),
  CONSTRAINT `discount_on_academic_event_ibfk_2` FOREIGN KEY (`EventID`) REFERENCES `academic_event` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `discount_on_academic_event`
--

LOCK TABLES `discount_on_academic_event` WRITE;
/*!40000 ALTER TABLE `discount_on_academic_event` DISABLE KEYS */;
INSERT INTO `discount_on_academic_event` VALUES (13,1),(13,2),(13,3),(14,4),(14,5),(14,6),(15,7),(15,8),(15,9),(16,10),(16,11),(16,12);
/*!40000 ALTER TABLE `discount_on_academic_event` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `discount_on_payment`
--

DROP TABLE IF EXISTS `discount_on_payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `discount_on_payment` (
  `PaymentCounponID` int NOT NULL,
  `PaymentID` int NOT NULL,
  PRIMARY KEY (`PaymentCounponID`,`PaymentID`),
  KEY `PaymentID` (`PaymentID`),
  CONSTRAINT `discount_on_payment_ibfk_1` FOREIGN KEY (`PaymentCounponID`) REFERENCES `payment_discount_coupon` (`Id`),
  CONSTRAINT `discount_on_payment_ibfk_2` FOREIGN KEY (`PaymentID`) REFERENCES `payment` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `discount_on_payment`
--

LOCK TABLES `discount_on_payment` WRITE;
/*!40000 ALTER TABLE `discount_on_payment` DISABLE KEYS */;
INSERT INTO `discount_on_payment` VALUES (9,2),(13,3),(14,4),(8,5),(15,5),(8,6),(16,6),(6,7),(12,7),(10,8);
/*!40000 ALTER TABLE `discount_on_payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `discount_on_payment_item`
--

DROP TABLE IF EXISTS `discount_on_payment_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `discount_on_payment_item` (
  `ArticleCouponID` int NOT NULL,
  `PaymentItemID` int NOT NULL,
  PRIMARY KEY (`ArticleCouponID`,`PaymentItemID`),
  KEY `PaymentItemID` (`PaymentItemID`),
  CONSTRAINT `discount_on_payment_item_ibfk_1` FOREIGN KEY (`ArticleCouponID`) REFERENCES `article_discount_coupon` (`Id`),
  CONSTRAINT `discount_on_payment_item_ibfk_2` FOREIGN KEY (`PaymentItemID`) REFERENCES `payment_item` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `discount_on_payment_item`
--

LOCK TABLES `discount_on_payment_item` WRITE;
/*!40000 ALTER TABLE `discount_on_payment_item` DISABLE KEYS */;
INSERT INTO `discount_on_payment_item` VALUES (4,1),(1,6),(2,11),(2,23);
/*!40000 ALTER TABLE `discount_on_payment_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `discount_on_subcategory`
--

DROP TABLE IF EXISTS `discount_on_subcategory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `discount_on_subcategory` (
  `SubcategoryCouponID` int NOT NULL,
  `CategoryName` varchar(255) NOT NULL,
  `SubcategoryName` varchar(255) NOT NULL,
  PRIMARY KEY (`SubcategoryCouponID`,`CategoryName`,`SubcategoryName`),
  KEY `CategoryName` (`CategoryName`,`SubcategoryName`),
  CONSTRAINT `discount_on_subcategory_ibfk_1` FOREIGN KEY (`SubcategoryCouponID`) REFERENCES `article_subcategory_discount_coupon` (`Id`),
  CONSTRAINT `discount_on_subcategory_ibfk_2` FOREIGN KEY (`CategoryName`, `SubcategoryName`) REFERENCES `subcategory` (`CategoryName`, `SubcategoryName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `discount_on_subcategory`
--

LOCK TABLES `discount_on_subcategory` WRITE;
/*!40000 ALTER TABLE `discount_on_subcategory` DISABLE KEYS */;
INSERT INTO `discount_on_subcategory` VALUES (11,'Depth Estimation','Monocular Depth Estimation'),(12,'Generated Model','Adversarial Learning'),(12,'Generated Model','Diffusion'),(11,'Object Detection','3D Object Detection'),(10,'Reconstruction','Gaussian Splatting'),(10,'Reconstruction','NerF'),(11,'Self-supervised','Semi-supervised'),(9,'Transformer','Local Transformer'),(9,'Transformer','Vision Transformer');
/*!40000 ALTER TABLE `discount_on_subcategory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `journal`
--

DROP TABLE IF EXISTS `journal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `journal` (
  `id` int NOT NULL,
  `association` varchar(255) DEFAULT NULL,
  `level` enum('Q1','Q2','Q3','Q4') DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `journal_ibfk_1` FOREIGN KEY (`id`) REFERENCES `academic_event` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `journal`
--

LOCK TABLES `journal` WRITE;
/*!40000 ALTER TABLE `journal` DISABLE KEYS */;
INSERT INTO `journal` VALUES (7,'Springer','Q1'),(8,'Springer','Q1'),(9,'Springer','Q1'),(10,'IEEE','Q2'),(11,'IEEE','Q2'),(12,'IEEE','Q2');
/*!40000 ALTER TABLE `journal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `paper`
--

DROP TABLE IF EXISTS `paper`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `paper` (
  `id` int NOT NULL AUTO_INCREMENT,
  `EventID` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `EventID` (`EventID`),
  CONSTRAINT `paper_ibfk_1` FOREIGN KEY (`id`) REFERENCES `science_article` (`id`),
  CONSTRAINT `paper_ibfk_2` FOREIGN KEY (`EventID`) REFERENCES `academic_event` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paper`
--

LOCK TABLES `paper` WRITE;
/*!40000 ALTER TABLE `paper` DISABLE KEYS */;
INSERT INTO `paper` VALUES (1,1),(2,1),(3,2),(4,2),(5,3),(6,3),(7,4),(8,4),(9,5),(10,5),(11,6),(12,6);
/*!40000 ALTER TABLE `paper` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `paper_academic_discount_coupon`
--

DROP TABLE IF EXISTS `paper_academic_discount_coupon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `paper_academic_discount_coupon` (
  `Id` int NOT NULL,
  PRIMARY KEY (`Id`),
  CONSTRAINT `paper_academic_discount_coupon_ibfk_1` FOREIGN KEY (`Id`) REFERENCES `type_article_discount_coupon` (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paper_academic_discount_coupon`
--

LOCK TABLES `paper_academic_discount_coupon` WRITE;
/*!40000 ALTER TABLE `paper_academic_discount_coupon` DISABLE KEYS */;
INSERT INTO `paper_academic_discount_coupon` VALUES (13),(14),(15),(16);
/*!40000 ALTER TABLE `paper_academic_discount_coupon` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment`
--

DROP TABLE IF EXISTS `payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `Time` timestamp NULL DEFAULT NULL,
  `ReaderID` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ReaderID` (`ReaderID`),
  CONSTRAINT `payment_ibfk_1` FOREIGN KEY (`ReaderID`) REFERENCES `reader` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment`
--

LOCK TABLES `payment` WRITE;
/*!40000 ALTER TABLE `payment` DISABLE KEYS */;
INSERT INTO `payment` VALUES (1,'2024-06-25 10:30:56',5),(2,'2024-12-06 17:00:00',5),(3,'2024-12-31 17:00:00',6),(4,'2024-12-31 16:59:59',6),(5,'2024-01-09 05:25:53',6),(6,'2024-12-13 10:59:25',7),(7,'2024-12-24 11:18:18',7),(8,'2024-12-25 10:19:20',7),(9,'2024-12-16 03:10:10',8),(10,'2024-11-29 05:12:12',8);
/*!40000 ALTER TABLE `payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment_discount_coupon`
--

DROP TABLE IF EXISTS `payment_discount_coupon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment_discount_coupon` (
  `Id` int NOT NULL,
  PRIMARY KEY (`Id`),
  CONSTRAINT `payment_discount_coupon_ibfk_1` FOREIGN KEY (`Id`) REFERENCES `discount_coupon` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_discount_coupon`
--

LOCK TABLES `payment_discount_coupon` WRITE;
/*!40000 ALTER TABLE `payment_discount_coupon` DISABLE KEYS */;
INSERT INTO `payment_discount_coupon` VALUES (5),(6),(7),(8),(9),(10),(11),(12),(13),(14),(15),(16);
/*!40000 ALTER TABLE `payment_discount_coupon` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment_item`
--

DROP TABLE IF EXISTS `payment_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment_item` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ArticleID` int DEFAULT NULL,
  `PaymentID` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ArticleID` (`ArticleID`),
  KEY `PaymentID` (`PaymentID`),
  CONSTRAINT `payment_item_ibfk_1` FOREIGN KEY (`ArticleID`) REFERENCES `science_article` (`id`),
  CONSTRAINT `payment_item_ibfk_2` FOREIGN KEY (`PaymentID`) REFERENCES `payment` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_item`
--

LOCK TABLES `payment_item` WRITE;
/*!40000 ALTER TABLE `payment_item` DISABLE KEYS */;
INSERT INTO `payment_item` VALUES (1,23,1),(2,1,2),(3,2,2),(4,3,3),(5,4,3),(6,5,3),(7,7,4),(8,8,4),(9,9,4),(10,10,4),(11,13,5),(12,14,5),(13,15,5),(14,16,5),(15,17,5),(16,19,6),(17,20,6),(18,21,6),(19,22,6),(20,23,6),(21,24,6),(22,13,7),(23,14,7),(24,17,7),(25,8,7),(26,7,7),(27,12,8),(28,6,8),(29,17,8),(30,18,8),(31,1,9),(32,7,9),(33,8,9),(34,9,9),(35,10,9),(36,12,10),(37,15,10),(38,16,10),(39,17,10);
/*!40000 ALTER TABLE `payment_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reader`
--

DROP TABLE IF EXISTS `reader`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reader` (
  `id` int NOT NULL,
  `creditcard` varchar(255) DEFAULT NULL,
  `VipTier` enum('0','1','2','3','4','5') DEFAULT NULL,
  `CartID` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `CartID` (`CartID`),
  CONSTRAINT `reader_ibfk_1` FOREIGN KEY (`CartID`) REFERENCES `cart` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reader`
--

LOCK TABLES `reader` WRITE;
/*!40000 ALTER TABLE `reader` DISABLE KEYS */;
INSERT INTO `reader` VALUES (5,'3849205761','1',1),(6,'1597263845','3',2),(7,'9283746510','5',3),(8,'6012345987','0',4);
/*!40000 ALTER TABLE `reader` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reader_has_discount_coupon`
--

DROP TABLE IF EXISTS `reader_has_discount_coupon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reader_has_discount_coupon` (
  `ReaderID` int NOT NULL,
  `CoupinID` int NOT NULL,
  `use` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`ReaderID`,`CoupinID`),
  KEY `CoupinID` (`CoupinID`),
  CONSTRAINT `reader_has_discount_coupon_ibfk_1` FOREIGN KEY (`ReaderID`) REFERENCES `reader` (`id`),
  CONSTRAINT `reader_has_discount_coupon_ibfk_2` FOREIGN KEY (`CoupinID`) REFERENCES `discount_coupon` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reader_has_discount_coupon`
--

LOCK TABLES `reader_has_discount_coupon` WRITE;
/*!40000 ALTER TABLE `reader_has_discount_coupon` DISABLE KEYS */;
INSERT INTO `reader_has_discount_coupon` VALUES (5,1,0),(5,2,0),(5,3,0),(5,4,0),(5,5,0),(5,6,0),(5,7,0),(5,8,0),(5,9,0),(5,10,0),(5,11,0),(5,12,0),(5,13,0),(5,14,0),(5,15,0),(5,16,0),(6,1,0),(6,2,0),(6,3,0),(6,4,0),(6,5,0),(6,6,0),(6,7,0),(6,8,0),(6,9,0),(6,10,0),(6,11,0),(6,12,0),(6,13,0),(6,14,0),(6,15,0),(6,16,0),(7,1,0),(7,2,0),(7,3,0),(7,4,0),(7,5,0),(7,6,0),(7,7,0),(7,8,0),(7,9,0),(7,10,0),(7,11,0),(7,12,0),(7,13,0),(7,14,0),(7,15,0),(7,16,0),(8,1,0),(8,2,0),(8,3,0),(8,4,0),(8,5,0),(8,6,0),(8,7,0),(8,8,0),(8,9,0),(8,10,0),(8,11,0),(8,12,0),(8,13,0),(8,14,0),(8,15,0),(8,16,0);
/*!40000 ALTER TABLE `reader_has_discount_coupon` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `science_article`
--

DROP TABLE IF EXISTS `science_article`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `science_article` (
  `id` int NOT NULL AUTO_INCREMENT,
  `Title` varchar(255) NOT NULL,
  `PublishDate` date DEFAULT NULL,
  `GithubCode` varchar(255) DEFAULT NULL,
  `link` varchar(255) DEFAULT NULL,
  `LastModified` timestamp NULL DEFAULT NULL,
  `Price` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `science_article`
--

LOCK TABLES `science_article` WRITE;
/*!40000 ALTER TABLE `science_article` DISABLE KEYS */;
INSERT INTO `science_article` VALUES (1,'Vision Transformer With Deformable Attention','2022-06-21','https://github.com/LeapLabTHU/DAT','https://openaccess.thecvf.com/content/CVPR2022/papers/Xia_Vision_Transformer_With_Deformable_Attention_CVPR_2022_paper.pdf','2022-12-21 08:00:00',26.00),(2,'Swin Transformer V2: Scaling Up Capacity and Resolution','2022-06-22','https://github.com/microsoft/Swin-Transformer','https://openaccess.thecvf.com/content/CVPR2022/papers/Liu_Swin_Transformer_V2_Scaling_Up_Capacity_and_Resolution_CVPR_2022_paper.pdf','2022-12-25 15:00:00',38.00),(3,'Fully Self-Supervised Depth Estimation From Defocus Clue','2023-06-20','https://github.com/Ehzoahis/DEReD','https://openaccess.thecvf.com/content/CVPR2023/papers/Si_Fully_Self-Supervised_Depth_Estimation_From_Defocus_Clue_CVPR_2023_paper.pdf','2023-11-18 12:00:00',42.00),(4,'Lite-Mono: A Lightweight CNN and Transformer Architecture for Self-Supervised Monocular Depth Estimation','2023-06-22','https://github.com/noahzn/Lite-Mono','https://openaccess.thecvf.com/content/CVPR2023/papers/Zhang_Lite-Mono_A_Lightweight_CNN_and_Transformer_Architecture_for_Self-Supervised_Monocular_CVPR_2023_paper.pdf','2023-11-17 10:30:00',27.00),(5,'MonoCD: Monocular 3D Object Detection with Complementary Depths','2024-06-23','https://github.com/dragonfly606/MonoCD','https://openaccess.thecvf.com/content/CVPR2024/papers/Yan_MonoCD_Monocular_3D_Object_Detection_with_Complementary_Depths_CVPR_2024_paper.pdf','2024-10-10 11:25:30',31.00),(6,'Gaussian Splatting SLAM','2024-06-21','https://github.com/muskie82/MonoGS','https://openaccess.thecvf.com/content/CVPR2024/papers/Matsuki_Gaussian_Splatting_SLAM_CVPR_2024_paper.pdf','2024-10-09 10:00:00',23.00),(7,'Adversarial Refinement Network for Human Motion Prediction','2020-12-10','https://github.com/Xianjin111/ARNet-for-human-motion-prediction','https://openaccess.thecvf.com/content/ACCV2020/papers/Chao_Adversarial_Refinement_Network_for_Human_Motion_Prediction_ACCV_2020_paper.pdf','2021-01-15 01:45:00',38.00),(8,'MatchGAN: A Self-Supervised Semi-Supervised Conditional Generative Adversarial Network','2020-12-12','https://github.com/justin941208/MatchGAN','https://openaccess.thecvf.com/content/ACCV2020/papers/Sun_MatchGAN_A_Self-Supervised_Semi-Supervised_Conditional_Generative_Adversarial_Network_ACCV_2020_paper.pdf','2021-01-10 02:30:30',31.00),(9,'Semi-Supervised Semantic Segmentation with Uncertainty-guided Self Cross Supervision','2022-12-09','https://github.com/meitounao110/USCS-pytorch','https://openaccess.thecvf.com/content/ACCV2022/papers/Zhang_Semi-Supervised_Semantic_Segmentation_with_Uncertainty-guided_Self_Cross_Supervision_ACCV_2022_paper.pdf','2023-02-15 02:00:00',28.00),(10,'Learning Inter-Superpoint Affinity for Weakly Supervised 3D Instance Segmentation','2022-12-08','https://github.com/fpthink/3D-WSIS','https://openaccess.thecvf.com/content/ACCV2022/papers/Tang_Learning_Inter-Superpoint_Affinity_for_Weakly_Supervised_3D_Instance_Segmentation_ACCV_2022_paper.pdf','2023-02-14 00:10:20',41.00),(11,'Depth Attention for Robust RGB Tracking','2024-10-27','https://github.com/LiuYuML/Depth-Attention','https://arxiv.org/pdf/2410.20395','2024-10-27 03:15:15',42.00),(12,'MGNiceNet: Unified Monocular Geometric Scene Understanding','2024-11-18','https://github.com/markusschoen/MGNiceNet','https://arxiv.org/pdf/2411.11466','2024-11-18 05:30:30',30.00),(13,'Disentangled Inference for GANs With Latently Invertible Autoencoder','2022-03-22','https://github.com/genforce/lia','https://link.springer.com/article/10.1007/s11263-022-01598-5','2022-03-22 05:00:00',38.00),(14,'Open-Set Adversarial Defense with Clean-Adversarial Mutual Learning','2022-03-05','https://github.com/rshaojimmy/OSDN-CAML','https://link.springer.com/article/10.1007/s11263-022-01581-0','2022-03-05 04:30:30',22.00),(15,'Revisiting Consistency Regularization for Semi-Supervised Learning','2022-12-07','https://github.com/wgcban/SemiCDD','https://link.springer.com/article/10.1007/s11263-022-01723-4','2022-12-07 01:45:00',28.00),(16,'ViTAEv2: Vision Transformer Advanced by Exploring Inductive Bias for Image Recognition and Beyond','2023-01-12','https://github.com/ViTAE-Transformer/ViTAE-Transformer','https://link.springer.com/article/10.1007/s11263-022-01739-w','2023-02-12 02:30:30',34.00),(17,'Correspondence Distillation from NeRF-Based GAN','2023-09-25','https://github.com/mshahbazi72/NeRF-GAN-Distillation','https://link.springer.com/article/10.1007/s11263-023-01903-w','2023-09-25 04:30:45',34.00),(18,'SegViT v2: Exploring Efficient and Continual Semantic Segmentation with Plain Vision Transformers','2023-10-27','https://github.com/zbwxp/SegVit','https://link.springer.com/article/10.1007/s11263-023-01894-8','2023-10-27 06:10:25',19.00),(19,'Learning representative viewpoints in 3D shape recognition','2021-07-02','https://github.com/subeeshvasu/Awsome_Deep_Geometry_Learning','https://link.springer.com/article/10.1007/s00371-021-02203-5','2021-07-02 07:30:30',35.00),(20,'CCS-GAN: a semi-supervised generative adversarial network for image classification','2021-07-29','https://github.com/opetrova/SemiSupervisedPytorchGAN','https://link.springer.com/article/10.1007/s00371-021-02262-8','2021-07-29 08:30:30',18.00),(21,'Split-guidance network for salient object detection','2022-02-21','https://github.com/Sssssbo/SDCNet','https://link.springer.com/article/10.1007/s00371-022-02421-5','2022-02-21 09:30:45',29.00),(22,'Image classification via convolutional sparse coding','2022-04-06','https://github.com/JingyiXu404/MCSCNet','https://link.springer.com/article/10.1007/s00371-022-02441-1','2022-04-06 10:00:00',28.00),(23,'Latent diffusion transformer for point cloud generation','2024-04-22','https://github.com/Negai-98/LDT','https://link.springer.com/article/10.1007/s00371-022-02441-1','2024-04-02 11:00:00',40.00),(24,'EDM: a enhanced diffusion models for image restoration in complex scenes','2024-07-24','https://github.com/yuanzhi-zhu/DiffPIR','https://link.springer.com/article/10.1007/s00371-024-03549-2','2024-07-24 11:30:00',25.00),(25,'Relaxation and its Role in Vision','1977-12-10','','https://era.ed.ac.uk/handle/1842/8121','1977-12-10 05:00:00',22.00),(26,'MODELING SEQUENCES WITH STRUCTURED STATE SPACES','2023-12-01','https://github.com/state-spaces/mamba','https://stacks.stanford.edu/file/druid:mb976vf9362/gu_dissertation-augmented.pdf','2024-05-31 06:00:30',36.00),(27,'RT-DETRv3: Real-time End-to-End Object Detection with Hierarchical Dense Positive Supervision','2024-11-13','https://github.com/lyuwenyu/RT-DETR','https://arxiv.org/abs/2409.08475','2024-11-13 09:00:00',20.00),(28,'YOLOV11: AN OVERVIEW OF THE KEY ARCHITECTURAL ENHANCEMENTS','2024-10-23','https://github.com/ultralytics/ultralytics','https://arxiv.org/pdf/2410.17725','2024-10-23 11:30:45',39.00);
/*!40000 ALTER TABLE `science_article` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subcategory`
--

DROP TABLE IF EXISTS `subcategory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subcategory` (
  `CategoryName` varchar(255) NOT NULL,
  `SubcategoryName` varchar(255) NOT NULL,
  `Description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`CategoryName`,`SubcategoryName`),
  CONSTRAINT `subcategory_ibfk_1` FOREIGN KEY (`CategoryName`) REFERENCES `category` (`CategoryName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subcategory`
--

LOCK TABLES `subcategory` WRITE;
/*!40000 ALTER TABLE `subcategory` DISABLE KEYS */;
INSERT INTO `subcategory` VALUES ('Depth Estimation','Monocular Depth Estimation','Monocular depth estimation is the process of inferring the depth information of a scene from a single image.'),('Generated Model','Adversarial Learning','Adversarial learning is a machine learning technique where two models, a generator and a discriminator, compete against each other.'),('Generated Model','Diffusion','Diffusion models are a type of generative model that works by gradually adding noise to data and then learning to reverse the process, generating new data points that are similar to the training data.'),('Object Detection','2D Object Detection','2D Object Detection is a computer vision technique that identifies and locates objects within a 2D image.'),('Object Detection','3D Object Detection','3D object detection is a computer vision technique that identifies and locates objects in a 3D scene.'),('Reconstruction','Gaussian Splatting','Gaussian splatting is a novel 3D neural rendering technique that represents 3D scenes as a collection of 3D Gaussian splat points.'),('Reconstruction','NerF','Neural Radiance Fields (NeRF) is a novel technique that represents 3D scenes as a continuous function that maps 3D points to color and density values.'),('Self-supervised','Semi-supervised','Semi-supervised learning is a machine learning technique that combines supervised and unsupervised learning by using both labeled and unlabeled data to train models.'),('Sequence Model','State Space Model','A state space model is a mathematical model that describes the dynamics of a system using state variables.'),('Transformer','Local Transformer','Local transformers are a variation of transformer models that focus on capturing local dependencies within a sequence, rather than global dependencies.'),('Transformer','Vision Transformer','Vision Transformer (ViT) is a neural network architecture that applies the transformer model, originally used for natural language processing, to computer vision tasks.'),('Visual Classification','Image Classification','Image classification is a computer vision technique that involves assigning a label or category to an entire image.');
/*!40000 ALTER TABLE `subcategory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subcategory_keyword`
--

DROP TABLE IF EXISTS `subcategory_keyword`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subcategory_keyword` (
  `CategoryName` varchar(255) NOT NULL,
  `SubcategoryName` varchar(255) NOT NULL,
  `Keyword` varchar(255) NOT NULL,
  PRIMARY KEY (`CategoryName`,`SubcategoryName`,`Keyword`),
  CONSTRAINT `subcategory_keyword_ibfk_1` FOREIGN KEY (`CategoryName`, `SubcategoryName`) REFERENCES `subcategory` (`CategoryName`, `SubcategoryName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subcategory_keyword`
--

LOCK TABLES `subcategory_keyword` WRITE;
/*!40000 ALTER TABLE `subcategory_keyword` DISABLE KEYS */;
INSERT INTO `subcategory_keyword` VALUES ('Depth Estimation','Monocular Depth Estimation','Monocular'),('Depth Estimation','Monocular Depth Estimation','Unet'),('Generated Model','Adversarial Learning','Discriminator'),('Generated Model','Adversarial Learning','GAN'),('Generated Model','Adversarial Learning','Generator'),('Generated Model','Diffusion','Forward Process'),('Generated Model','Diffusion','Noise'),('Generated Model','Diffusion','Step'),('Object Detection','2D Object Detection','Anchor'),('Object Detection','2D Object Detection','RCNN'),('Object Detection','2D Object Detection','YOLO'),('Object Detection','3D Object Detection','CenterNet'),('Object Detection','3D Object Detection','Depth'),('Reconstruction','Gaussian Splatting','Gaussian'),('Reconstruction','NerF','NerF'),('Self-supervised','Semi-supervised','EMA'),('Sequence Model','State Space Model','SSMs'),('Transformer','Vision Transformer','Transformer'),('Transformer','Vision Transformer','VIT'),('Visual Classification','Image Classification','ImageNet');
/*!40000 ALTER TABLE `subcategory_keyword` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `technical_report`
--

DROP TABLE IF EXISTS `technical_report`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `technical_report` (
  `id` int NOT NULL,
  `organization` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `technical_report_ibfk_1` FOREIGN KEY (`id`) REFERENCES `science_article` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `technical_report`
--

LOCK TABLES `technical_report` WRITE;
/*!40000 ALTER TABLE `technical_report` DISABLE KEYS */;
INSERT INTO `technical_report` VALUES (27,'Baidu'),(28,'ultralytics');
/*!40000 ALTER TABLE `technical_report` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `thesis`
--

DROP TABLE IF EXISTS `thesis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `thesis` (
  `id` int NOT NULL,
  `Education_Insitution` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `thesis_ibfk_1` FOREIGN KEY (`id`) REFERENCES `science_article` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `thesis`
--

LOCK TABLES `thesis` WRITE;
/*!40000 ALTER TABLE `thesis` DISABLE KEYS */;
INSERT INTO `thesis` VALUES (25,'Edinburgh'),(26,'Stanford');
/*!40000 ALTER TABLE `thesis` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `type_article_discount_coupon`
--

DROP TABLE IF EXISTS `type_article_discount_coupon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `type_article_discount_coupon` (
  `Id` int NOT NULL,
  PRIMARY KEY (`Id`),
  CONSTRAINT `type_article_discount_coupon_ibfk_1` FOREIGN KEY (`Id`) REFERENCES `payment_discount_coupon` (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `type_article_discount_coupon`
--

LOCK TABLES `type_article_discount_coupon` WRITE;
/*!40000 ALTER TABLE `type_article_discount_coupon` DISABLE KEYS */;
INSERT INTO `type_article_discount_coupon` VALUES (9),(10),(11),(12),(13),(14),(15),(16);
/*!40000 ALTER TABLE `type_article_discount_coupon` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `Username` varchar(255) NOT NULL,
  `Hashpassword` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'KietDang','b546f23fc745a27f6a92454cbf6f8968577c0c631edcc5f6ea50065a61d373be'),(2,'emkienngu','07357ba15ed9804d8eab648a9a357b46acc773209c31c157cc332a2cf1c0028b'),(3,'baotn','d7068985b24516c8498025db308d9f2afc24de09b4ec4257c6c3cd49b7f84789'),(4,'cbaaabc','206c414972cbfdf46db073d12c9d39625ec1e3c18d55a4ce70b3514a4357fb73'),(5,'reader1','560e94d0fdd7870fe36a8464857f6bcf106f2a08498029ddf45248c9b583b0ec'),(6,'reader2','6eddf0324fd512a08ed645f4aef24b116907eed967c6646462d7064a89ddce79'),(7,'reader3','a6fc8c4dcae6637c17eeba645ff7f31d16e6e7463dc31ed4349380ba66881dd2'),(8,'reader4','8687f42dd5d40766fee8381b1e70555de37ffe5b0644cc0bfa03e56c0a55194b');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `valid_article_coupon`
--

DROP TABLE IF EXISTS `valid_article_coupon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `valid_article_coupon` (
  `ArticleCouponID` int NOT NULL,
  `ArticleID` int NOT NULL,
  PRIMARY KEY (`ArticleCouponID`,`ArticleID`),
  KEY `ArticleID` (`ArticleID`),
  CONSTRAINT `valid_article_coupon_ibfk_1` FOREIGN KEY (`ArticleCouponID`) REFERENCES `article_discount_coupon` (`Id`),
  CONSTRAINT `valid_article_coupon_ibfk_2` FOREIGN KEY (`ArticleID`) REFERENCES `science_article` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `valid_article_coupon`
--

LOCK TABLES `valid_article_coupon` WRITE;
/*!40000 ALTER TABLE `valid_article_coupon` DISABLE KEYS */;
INSERT INTO `valid_article_coupon` VALUES (1,3),(3,5),(1,10),(1,11),(2,13),(2,14),(2,15),(1,23),(4,23),(3,28);
/*!40000 ALTER TABLE `valid_article_coupon` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-12-02 23:48:11
ALTER TABLE payment
ADD COLUMN status VARCHAR(50) NOT NULL DEFAULT 'Pending';

ALTER TABLE science_article
ADD COLUMN deleteAt BOOL NOT NULL DEFAULT False;
