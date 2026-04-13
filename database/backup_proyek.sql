Enter password: 
/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-12.1.2-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: project_i
-- ------------------------------------------------------
-- Server version	12.1.2-MariaDB-ubu2404

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `client_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `categories_client_id_name` (`client_id`,`name`),
  CONSTRAINT `1` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `categories` VALUES
('13630365-7c76-416e-8070-7f914c0aaee3','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','Gas','',1,'2026-04-02 03:24:01','2026-04-02 03:24:01'),
('47c6cfa5-b0d3-43d7-8cbb-498ac2de2c7c','e983c109-aae5-4fd0-b010-c56025b09412','Susu','Susu cair, susu bubuk, susu kental manis, dll',1,'2026-01-12 23:25:11','2026-01-12 23:25:11'),
('506157ec-f151-4932-9dc9-d8e15da04d95','e983c109-aae5-4fd0-b010-c56025b09412','Bumbu Dapur','Bumbu masak, kecap, saus, MSG, garam, merica, dll',1,'2026-01-12 23:25:11','2026-01-12 23:25:11'),
('522f5b89-0e92-4eb0-9531-2aa1e4daa851','e983c109-aae5-4fd0-b010-c56025b09412','Mie Instan','Mie instan berbagai merek dan rasa',1,'2026-01-12 23:25:11','2026-01-12 23:25:11'),
('60fc3e42-dbf6-48e7-9be6-edc51b4da669','2dcc3a4c-a0b2-45dc-8541-57bcfcff89d6','Make-Up','',1,'2026-02-04 01:58:47','2026-02-04 01:58:47'),
('77a79006-428c-4304-b988-80c854e48a73','e983c109-aae5-4fd0-b010-c56025b09412','Elektronik','Baterai, lampu, kabel, dan elektronik kecil lainnya',1,'2026-01-12 23:25:11','2026-01-12 23:25:11'),
('7f2eb2d7-35de-4fcc-bd9f-0282023731b0','e983c109-aae5-4fd0-b010-c56025b09412','Minuman','Air mineral, teh, kopi, soft drink, jus, dll',1,'2026-01-12 23:25:11','2026-01-12 23:25:11'),
('8bfc6feb-6cac-447c-b034-ea0008d9253b','e983c109-aae5-4fd0-b010-c56025b09412','Snack','Makanan ringan, keripik, biskuit, coklat, permen, dll',1,'2026-01-12 23:25:11','2026-01-12 23:25:11'),
('8ce389c1-e093-4181-a7ed-c17af3e6a888','e983c109-aae5-4fd0-b010-c56025b09412','Frozen Food','Makanan beku (nugget, sosis, bakso, dll)',1,'2026-01-12 23:25:11','2026-01-12 23:25:11'),
('9f0d2d1e-528a-495e-a2ff-77d03d5b5a26','e983c109-aae5-4fd0-b010-c56025b09412','Kebutuhan Bayi','Popok, susu bayi, bedak bayi, dll',1,'2026-01-12 23:25:11','2026-01-12 23:25:11'),
('a9d57f07-dc28-4b0a-bb02-73669731e86b','e983c109-aae5-4fd0-b010-c56025b09412','Kecantikan','Make-up, bedak, dll',1,'2026-01-26 15:51:45','2026-01-26 15:51:45'),
('bc12152c-969a-4e4d-b616-98b58ff4827f','3b415014-cfd3-4ca8-8f19-137d3d074bda','Alat Tulis','',1,'2026-02-03 23:11:40','2026-02-03 23:11:40'),
('c5e25e0e-ef0d-4ce9-985e-7451dd61ceab','e983c109-aae5-4fd0-b010-c56025b09412','Sembako','Bahan makanan pokok (beras, minyak, gula, tepung, dll)',1,'2026-01-12 23:25:11','2026-01-12 23:25:11'),
('ca44c0b3-09a3-4560-8cac-aecd24194a94','e983c109-aae5-4fd0-b010-c56025b09412','Lain-lain','Produk lain yang tidak termasuk kategori di atas',1,'2026-01-12 23:25:11','2026-01-12 23:25:11'),
('e3572048-e0f7-4660-b015-26c10970c9f3','e983c109-aae5-4fd0-b010-c56025b09412','Alat Tulis','Pulpen, pensil, buku tulis, kertas, dll',1,'2026-01-12 23:25:11','2026-01-12 23:25:11'),
('ec3892c7-6bdc-47ff-8af6-a9caa5e94d5b','e983c109-aae5-4fd0-b010-c56025b09412','Roti & Kue','Roti tawar, roti manis, kue kering, dll',1,'2026-01-12 23:25:11','2026-01-12 23:25:11'),
('f6eeb624-cbab-4757-9703-678e1d773687','e983c109-aae5-4fd0-b010-c56025b09412','Rokok','Berbagai merek rokok',1,'2026-01-12 23:25:11','2026-01-12 23:25:11'),
('ffbf7fec-82cb-4f96-a5ac-6d0cfb9b01ea','e983c109-aae5-4fd0-b010-c56025b09412','Toiletries','Sabun, shampoo, pasta gigi, detergen, dan kebutuhan mandi',1,'2026-01-12 23:25:11','2026-01-12 23:25:11');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `clients`
--

DROP TABLE IF EXISTS `clients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `clients` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `code` varchar(20) NOT NULL,
  `business_name` varchar(100) NOT NULL,
  `owner_name` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `status` enum('ACTIVE','SUSPENDED','INACTIVE') DEFAULT 'ACTIVE',
  `subscription_plan` enum('FREE','BASIC','PREMIUM') DEFAULT 'FREE',
  `subscription_end` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `clients_code_unique` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clients`
--

LOCK TABLES `clients` WRITE;
/*!40000 ALTER TABLE `clients` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `clients` VALUES
('2dcc3a4c-a0b2-45dc-8541-57bcfcff89d6','CLI-2026-JIW4','Koperasi Makmur','','081234567890','','ACTIVE','BASIC','2026-02-05 07:00:00','2026-02-04 01:57:54','2026-02-04 01:57:54'),
('3b415014-cfd3-4ca8-8f19-137d3d074bda','DEMO-02','Toko Agak Laen','','081234567890','','INACTIVE','PREMIUM','2026-02-07 07:00:00','2026-02-03 23:00:20','2026-02-04 01:46:27'),
('e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','CLI-2026-HHBL','Koperasi Merah Putih','','081234567890','','ACTIVE','FREE','2026-04-30 07:00:00','2026-04-02 03:22:57','2026-04-02 03:22:57'),
('e983c109-aae5-4fd0-b010-c56025b09412','DEMO-01','Koperasi Demo Sejahtera','Budi Santoso','08123456789','Jl. Teknologi No. 1, Bandung','ACTIVE','PREMIUM','2026-04-03 07:00:00','2026-01-12 23:25:03','2026-04-02 02:10:36');
/*!40000 ALTER TABLE `clients` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `debt_payments`
--

DROP TABLE IF EXISTS `debt_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `debt_payments` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `client_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `member_debt_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `member_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `user_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'User yang menerima pembayaran',
  `amount` decimal(15,2) NOT NULL,
  `payment_method` enum('CASH','TRANSFER','DEBIT','CREDIT') NOT NULL DEFAULT 'CASH',
  `payment_date` datetime NOT NULL,
  `receipt_number` varchar(50) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `debt_payments_client_id_member_debt_id` (`client_id`,`member_debt_id`),
  KEY `debt_payments_client_id_payment_date` (`client_id`,`payment_date`),
  KEY `member_debt_id` (`member_debt_id`),
  KEY `member_id` (`member_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `157` FOREIGN KEY (`member_debt_id`) REFERENCES `member_debts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `158` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `159` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `debt_payments`
--

LOCK TABLES `debt_payments` WRITE;
/*!40000 ALTER TABLE `debt_payments` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `debt_payments` VALUES
('00c4f664-30da-42f6-b553-f6e8f14de0ce','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','d799eda1-d896-422a-ba1d-0e109857ba5a','846a2b2a-b4e5-41a3-ad6f-f0449f2f4a59','cbf1b57b-be22-4f0b-bce7-65e66d459064',49000.00,'CASH','2026-04-02 03:33:33','PAY-20260402-002',NULL,'2026-04-02 03:33:33','2026-04-02 03:33:33'),
('9f2fe85a-5398-4e40-be09-e7f7a5e8a91c','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','d799eda1-d896-422a-ba1d-0e109857ba5a','846a2b2a-b4e5-41a3-ad6f-f0449f2f4a59','ca514c50-219f-448c-bf71-70a742f29382',50000.00,'CASH','2026-04-02 03:30:12','PAY-20260402-001',NULL,'2026-04-02 03:30:12','2026-04-02 03:30:12');
/*!40000 ALTER TABLE `debt_payments` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `member_debts`
--

DROP TABLE IF EXISTS `member_debts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `member_debts` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `client_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `member_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `sale_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `invoice_number` varchar(50) NOT NULL,
  `total_amount` decimal(15,2) NOT NULL,
  `paid_amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `remaining_amount` decimal(15,2) NOT NULL,
  `due_date` datetime NOT NULL,
  `status` enum('PENDING','PARTIAL','PAID','OVERDUE') NOT NULL DEFAULT 'PENDING',
  `notes` text DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `member_debts_client_id_member_id` (`client_id`,`member_id`),
  KEY `member_debts_client_id_status` (`client_id`,`status`),
  KEY `member_id` (`member_id`),
  KEY `sale_id` (`sale_id`),
  CONSTRAINT `105` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `106` FOREIGN KEY (`sale_id`) REFERENCES `sales` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_debts`
--

LOCK TABLES `member_debts` WRITE;
/*!40000 ALTER TABLE `member_debts` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `member_debts` VALUES
('d799eda1-d896-422a-ba1d-0e109857ba5a','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','846a2b2a-b4e5-41a3-ad6f-f0449f2f4a59','251a3d2a-1ab6-4c93-814a-1ddbbf017608','0426-001 K',100000.00,100000.00,0.00,'2030-11-14 07:00:00','PAID',NULL,'2026-04-02 03:29:49','2026-04-02 03:33:33');
/*!40000 ALTER TABLE `member_debts` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `members`
--

DROP TABLE IF EXISTS `members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `members` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `client_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `unique_id` varchar(20) NOT NULL,
  `nik` varchar(16) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `whatsapp` varchar(15) DEFAULT NULL,
  `total_points` int(11) DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `region_code` varchar(50) NOT NULL,
  `region_name` varchar(50) DEFAULT NULL,
  `gender` enum('Laki-laki','Perempuan') DEFAULT NULL,
  `total_debt` decimal(15,2) DEFAULT 0.00,
  `total_transactions` int(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `members_client_id_unique_id` (`client_id`,`unique_id`),
  UNIQUE KEY `members_client_id_nik` (`client_id`,`nik`),
  KEY `members_client_id_full_name` (`client_id`,`full_name`),
  CONSTRAINT `1` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members`
--

LOCK TABLES `members` WRITE;
/*!40000 ALTER TABLE `members` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `members` VALUES
('4263dfc1-ccda-4b41-a833-d7239c4a58f1','e983c109-aae5-4fd0-b010-c56025b09412','BDG-2026-0002','3273010201900002','Siti Nurhaliza','Jl. Sudirman No. 456, Bandung','082345678901',97,1,'2026-01-12 23:55:09','2026-01-26 14:44:13','BDG','Bandung','Perempuan',0.00,2),
('4fda66ab-3124-40db-8a02-cf9315eeea8a','e983c109-aae5-4fd0-b010-c56025b09412','CJR-2026-0001','3276899990011223','Heksu Howaito','Jalanin Aja Dulu yah','081234567891',0,1,'2026-02-04 00:20:49','2026-02-04 00:20:49','CJR','Cianjur','Laki-laki',0.00,0),
('669577cf-832d-47eb-841d-a7a8bbefb544','e983c109-aae5-4fd0-b010-c56025b09412','BDG-2026-0003','3273010301900003','Budi Santoso','Jl. Asia Afrika No. 789, Bandung','083456789012',0,1,'2026-01-12 23:55:09','2026-01-12 23:55:09','BDG','Bandung','Laki-laki',0.00,0),
('76934931-62a6-4de1-b78e-333578e42af5','3b415014-cfd3-4ca8-8f19-137d3d074bda','Bandung-2026-0001','3232328823774228','NaiNai','Jalanin Aja dulu sama Fakhri hehe','080121312774',19,1,'2026-02-04 00:39:36','2026-02-04 01:24:18','Bandung','Bandung','Perempuan',0.00,3),
('846a2b2a-b4e5-41a3-ad6f-f0449f2f4a59','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','Bandung-2026-0001','3276899990011223','Pravowo','Jalanin sama mayor nya','081234567891',100,1,'2026-04-02 03:26:40','2026-04-02 03:33:33','Bandung','Bandung','Laki-laki',0.00,2),
('c39c762e-921a-493d-ad9b-a519c984f79f','e983c109-aae5-4fd0-b010-c56025b09412','KBG-2026-0001','3204010101900004','Dewi Lestari','Jl. Raya Soreang No. 100, Kabupaten Bandung','084567890123',0,1,'2026-01-12 23:55:09','2026-01-12 23:55:09','KBG','Kabupaten Bandung','Perempuan',0.00,0),
('ee3b2155-a132-44a7-a4c5-ad1e5099feef','e983c109-aae5-4fd0-b010-c56025b09412','BDG-2026-0001','3273010101900001','Ahmad Hidayat','Jl. Merdeka No. 123, Bandung','081234567890',0,1,'2026-01-12 23:55:09','2026-01-12 23:55:09','BDG','Bandung','Laki-laki',0.00,0),
('ef1641c9-86f1-4584-a1d9-c9997e2efbcc','2dcc3a4c-a0b2-45dc-8541-57bcfcff89d6','Bandung-2026-0001','3232323232323222','Heksu Howaito','GGGGGGGGGGGGGGGGGGGGGGGGGgaaa','081234567891',0,1,'2026-02-04 01:59:56','2026-02-04 02:00:27','Bandung','Bandung','Laki-laki',0.00,1),
('f7a5044e-37be-4e88-a8ab-c80351023b07','e983c109-aae5-4fd0-b010-c56025b09412','KBG-2026-0002','3204010201900005','Eko Prasetyo','Jl. Raya Majalaya No. 200, Kabupaten Bandung','085678901234',0,1,'2026-01-12 23:55:09','2026-01-12 23:55:09','KBG','Kabupaten Bandung','Laki-laki',0.00,0);
/*!40000 ALTER TABLE `members` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `point_transactions`
--

DROP TABLE IF EXISTS `point_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `point_transactions` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `client_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `member_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `sale_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `type` enum('EARN','REDEEM','ADJUSTMENT','EXPIRED') NOT NULL,
  `points` int(11) NOT NULL,
  `points_before` int(11) DEFAULT NULL,
  `points_after` int(11) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `expiry_date` datetime DEFAULT NULL,
  `is_expired` tinyint(1) DEFAULT 0,
  `created_by` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `point_transactions_client_id_member_id` (`client_id`,`member_id`),
  KEY `point_transactions_client_id_type` (`client_id`,`type`),
  KEY `member_id` (`member_id`),
  KEY `sale_id` (`sale_id`),
  KEY `created_by` (`created_by`),
  CONSTRAINT `154` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `155` FOREIGN KEY (`sale_id`) REFERENCES `sales` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `156` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `point_transactions`
--

LOCK TABLES `point_transactions` WRITE;
/*!40000 ALTER TABLE `point_transactions` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `point_transactions` VALUES
('29b8d4b8-54db-4cca-b109-39a5289690f8','e983c109-aae5-4fd0-b010-c56025b09412','4263dfc1-ccda-4b41-a833-d7239c4a58f1','f83820e2-c6b3-4e43-a4fe-401377125546','EARN',18,0,18,'Pembelian 0126-001 T - 18 point','2027-01-13 00:10:26',0,NULL,NULL,'2026-01-13 00:10:26','2026-01-13 00:10:26'),
('62a05b53-aab5-4253-ba86-270e11653991','3b415014-cfd3-4ca8-8f19-137d3d074bda','76934931-62a6-4de1-b78e-333578e42af5','3128a0c7-ef61-4315-a9c0-b5f918566d96','EARN',5,10,15,'Pembelian 0226-003 T - 5 point','2027-02-04 01:18:49',0,NULL,NULL,'2026-02-04 01:18:49','2026-02-04 01:18:49'),
('7807b66a-2fcf-4ba3-9a1f-296a5d6751b7','3b415014-cfd3-4ca8-8f19-137d3d074bda','76934931-62a6-4de1-b78e-333578e42af5','8a92cbee-98a8-43f3-902f-808bcec0269b','EARN',10,0,10,'Pembelian 0226-002 T - 10 point','2027-02-04 01:16:04',0,NULL,NULL,'2026-02-04 01:16:04','2026-02-04 01:16:04'),
('df856c41-392a-454e-b5a7-c4ced3802387','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','846a2b2a-b4e5-41a3-ad6f-f0449f2f4a59','251a3d2a-1ab6-4c93-814a-1ddbbf017608','EARN',100,0,100,'Pembelian 0426-001 K - 100 point','2027-04-02 03:29:49',0,NULL,NULL,'2026-04-02 03:29:49','2026-04-02 03:29:49'),
('e5812815-3021-4a6f-a1f7-8ef473dc3c55','e983c109-aae5-4fd0-b010-c56025b09412','4263dfc1-ccda-4b41-a833-d7239c4a58f1','eefe9878-3baf-4c08-a9f8-e4d4a685526f','EARN',79,18,97,'Pembelian 0126-002 T - 79 point','2027-01-26 14:44:13',0,NULL,NULL,'2026-01-26 14:44:13','2026-01-26 14:44:13'),
('f2685f0b-c9cb-4ec7-aa14-b8965067e140','3b415014-cfd3-4ca8-8f19-137d3d074bda','76934931-62a6-4de1-b78e-333578e42af5','0298402d-6269-4f2e-ae15-c77e1e7df19d','EARN',4,15,19,'Pembelian 0226-004 T - 4 point','2027-02-04 01:24:18',0,NULL,NULL,'2026-02-04 01:24:18','2026-02-04 01:24:18');
/*!40000 ALTER TABLE `point_transactions` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `client_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `category_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `supplier_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `barcode` varchar(50) DEFAULT NULL,
  `sku` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `unit` varchar(20) DEFAULT 'PCS',
  `purchase_price` decimal(15,2) DEFAULT 0.00,
  `selling_price` decimal(15,2) DEFAULT 0.00,
  `stock` int(11) DEFAULT 0,
  `min_stock` int(11) DEFAULT 0,
  `max_stock` int(11) DEFAULT 0,
  `points` decimal(10,2) DEFAULT 0.00,
  `description` text DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `product_type` varchar(20) DEFAULT 'Tunai',
  `purchase_type` varchar(20) DEFAULT 'TUNAI',
  `invoice_no` varchar(50) DEFAULT NULL,
  `expiry_date` datetime DEFAULT NULL,
  `selling_price_general` decimal(15,2) DEFAULT 0.00,
  `selling_price_member` decimal(15,2) DEFAULT 0.00,
  PRIMARY KEY (`id`),
  UNIQUE KEY `products_client_id_sku` (`client_id`,`sku`),
  UNIQUE KEY `products_client_id_barcode` (`client_id`,`barcode`),
  KEY `products_client_id_name` (`client_id`,`name`),
  KEY `category_id` (`category_id`),
  KEY `supplier_id` (`supplier_id`),
  CONSTRAINT `170` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `171` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `172` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `173` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `products` VALUES
('01e2bc19-0464-4599-9076-a2adf7ea3db2','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','13630365-7c76-416e-8070-7f914c0aaee3','c3b3f4d7-f63c-4b90-b68c-78f16271342b','8986756644476','PRD-20260401-001','Gas 3 KG','PCS',16000.00,22000.00,16,5,0,100.00,NULL,NULL,1,'2026-04-02 03:24:35','2026-04-02 03:34:07','Tunai','TUNAI',NULL,NULL,22000.00,20000.00),
('0440627b-ef83-43cf-b918-c1a9534c1d3e','e983c109-aae5-4fd0-b010-c56025b09412','8bfc6feb-6cac-447c-b034-ea0008d9253b','8cf104e1-ab43-466c-938e-e15717968105','8992741100011','PRD-20260112-009','OREO VANILLA 137G','PAK',7500.00,9000.00,37,10,0,0.00,'Biskuit Oreo vanilla',NULL,1,'2026-01-12 23:50:58','2026-01-26 14:44:13','Tunai','TUNAI',NULL,NULL,9000.00,9000.00),
('046212b1-966f-447c-b263-45ad46c3b07a','3b415014-cfd3-4ca8-8f19-137d3d074bda','bc12152c-969a-4e4d-b616-98b58ff4827f','4f15890d-b296-4901-b98b-d34d226e9311','8986756644476','PRD-20260203-001','Google Calendar','PCS',3000.00,5000.00,18,5,0,5.00,NULL,NULL,1,'2026-02-03 23:12:18','2026-02-04 01:24:18','Tunai','TUNAI',NULL,NULL,5000.00,4000.00),
('1234bbdb-dca0-493c-9239-55943dea97ee','e983c109-aae5-4fd0-b010-c56025b09412','ffbf7fec-82cb-4f96-a5ac-6d0cfb9b01ea','8cf104e1-ab43-466c-938e-e15717968105','8992388100064','PRD-20260112-016','PASTA GIGI PEPSODENT 190G','PCS',10000.00,12000.00,40,10,0,0.00,'Pasta gigi keluarga',NULL,1,'2026-01-12 23:50:58','2026-01-12 23:50:58','Tunai','TUNAI',NULL,NULL,12000.00,12000.00),
('39dc97d0-db09-4995-a643-0ffe3f16065c','e983c109-aae5-4fd0-b010-c56025b09412','7f2eb2d7-35de-4fcc-bd9f-0282023731b0','9119581c-6e2d-4207-a604-b593db590278','8993675100014','PRD-20260112-005','AQUA BOTOL 600ML','KARTON',36000.00,42000.00,20,5,0,0.00,'Air mineral Aqua isi 24 botol',NULL,1,'2026-01-12 23:50:58','2026-01-12 23:50:58','Tunai','TUNAI',NULL,NULL,42000.00,42000.00),
('496cb79a-d888-4b5a-8626-82cade16b3ea','e983c109-aae5-4fd0-b010-c56025b09412','c5e25e0e-ef0d-4ce9-985e-7451dd61ceab','354845ab-e35c-4609-961c-7009e426803b','8996001600108','PRD-20260112-003','GULA PASIR GULAKU 1KG','PAK',14000.00,16000.00,40,10,0,0.00,'Gula pasir putih 1kg',NULL,1,'2026-01-12 23:50:58','2026-01-12 23:50:58','Tunai','TUNAI',NULL,NULL,16000.00,16000.00),
('4ec7dd7b-88ed-4189-b445-82f01d8f340e','e983c109-aae5-4fd0-b010-c56025b09412','c5e25e0e-ef0d-4ce9-985e-7451dd61ceab','354845ab-e35c-4609-961c-7009e426803b','8992388211011','PRD-20260112-004','TEPUNG TERIGU SEGITIGA BIRU 1KG','PAK',11000.00,13000.00,25,5,0,0.00,'Tepung terigu serbaguna',NULL,1,'2026-01-12 23:50:58','2026-01-12 23:50:58','Tunai','TUNAI',NULL,NULL,13000.00,13000.00),
('6a56017f-14cd-492d-a0ee-d8b0f22b828c','e983c109-aae5-4fd0-b010-c56025b09412','ffbf7fec-82cb-4f96-a5ac-6d0cfb9b01ea','8cf104e1-ab43-466c-938e-e15717968105','8992388100057','PRD-20260112-015','SABUN LIFEBUOY 85G','PAK',3500.00,4500.00,60,15,0,0.00,'Sabun mandi batangan',NULL,1,'2026-01-12 23:50:58','2026-01-12 23:50:58','Tunai','TUNAI',NULL,NULL,4500.00,4500.00),
('6c2095d8-cdd7-41c0-8a85-0d4c2ec25f0e','e983c109-aae5-4fd0-b010-c56025b09412','522f5b89-0e92-4eb0-9531-2aa1e4daa851','354845ab-e35c-4609-961c-7009e426803b','8992388100019','PRD-20260112-011','INDOMIE GORENG','KARTON',60000.00,70000.00,28,5,0,0.00,'Indomie goreng isi 40 pcs',NULL,1,'2026-01-12 23:50:58','2026-01-26 15:37:40','Tunai','TUNAI',NULL,NULL,70000.00,70000.00),
('71a359a0-e86b-49e4-920c-2c76854a8555','e983c109-aae5-4fd0-b010-c56025b09412','47c6cfa5-b0d3-43d7-8cbb-498ac2de2c7c','9119581c-6e2d-4207-a604-b593db590278','8992388100033','PRD-20260112-013','SUSU ULTRA MILK COKLAT 1L','KARTON',96000.00,108000.00,15,3,0,0.00,'Susu UHT coklat isi 12',NULL,1,'2026-01-12 23:50:58','2026-01-12 23:50:58','Tunai','TUNAI',NULL,NULL,108000.00,108000.00),
('73c17329-c216-4e06-802e-30d9bcbcdb3f','e983c109-aae5-4fd0-b010-c56025b09412','e3572048-e0f7-4660-b015-26c10970c9f3','a847e7f6-e062-4558-931c-8c5db0de722d','8986756644476','PRD-20260126-001','PULPEN KENKO','PCS',2500.00,3000.00,11,5,0,0.00,NULL,NULL,1,'2026-01-26 16:00:07','2026-01-26 16:03:02','Tunai','TUNAI',NULL,NULL,3000.00,2800.00),
('82cf0f80-b7c9-45a6-977d-3d4420d5809e','e983c109-aae5-4fd0-b010-c56025b09412','ffbf7fec-82cb-4f96-a5ac-6d0cfb9b01ea','8cf104e1-ab43-466c-938e-e15717968105','8992388100071','PRD-20260112-017','SHAMPOO PANTENE 170ML','BTL',18000.00,21000.00,25,5,0,0.00,'Shampoo rambut',NULL,1,'2026-01-12 23:50:58','2026-01-12 23:50:58','Tunai','TUNAI',NULL,NULL,21000.00,21000.00),
('a47b4c17-536c-4601-a9eb-b3ae9b1bb211','e983c109-aae5-4fd0-b010-c56025b09412','c5e25e0e-ef0d-4ce9-985e-7451dd61ceab','354845ab-e35c-4609-961c-7009e426803b','8992761111014','PRD-20260112-002','MINYAK GORENG TROPICAL 2L','BTL',30000.00,32000.00,30,5,0,0.00,'Minyak goreng kemasan 2 liter',NULL,1,'2026-01-12 23:50:58','2026-02-04 00:19:50','Tunai','TUNAI',NULL,NULL,32000.00,32000.00),
('a90750fc-1b84-437f-97b6-e5fc11396389','e983c109-aae5-4fd0-b010-c56025b09412','c5e25e0e-ef0d-4ce9-985e-7451dd61ceab','354845ab-e35c-4609-961c-7009e426803b','8991002501010','PRD-20260112-001','BERAS PREMIUM 5KG','SACK',60000.00,70000.00,50,10,0,0.00,'Beras premium kualitas A',NULL,1,'2026-01-12 23:50:58','2026-01-12 23:50:58','Tunai','TUNAI',NULL,NULL,70000.00,70000.00),
('b6667d58-92c6-4ba6-b354-a8b009478925','e983c109-aae5-4fd0-b010-c56025b09412','ffbf7fec-82cb-4f96-a5ac-6d0cfb9b01ea','8cf104e1-ab43-466c-938e-e15717968105','8992388100088','PRD-20260112-018','DETERGEN RINSO 800G','PAK',16000.00,19000.00,3,5,0,0.00,'Detergen bubuk',NULL,1,'2026-01-12 23:50:58','2026-01-12 23:50:58','Tunai','TUNAI',NULL,NULL,19000.00,19000.00),
('bd78cb1e-2a95-46ca-b505-ca0a8e7b3e5f','e983c109-aae5-4fd0-b010-c56025b09412','c5e25e0e-ef0d-4ce9-985e-7451dd61ceab','354845ab-e35c-4609-961c-7009e426803b','8992388100095','PRD-20260112-019','KECAP BANGO 220ML','BTL',11000.00,13000.00,0,5,0,0.00,'Kecap manis',NULL,1,'2026-01-12 23:50:58','2026-01-12 23:50:58','Tunai','TUNAI',NULL,NULL,13000.00,13000.00),
('c4012059-f174-40f0-bae4-8891f7b4b582','e983c109-aae5-4fd0-b010-c56025b09412','7f2eb2d7-35de-4fcc-bd9f-0282023731b0','9119581c-6e2d-4207-a604-b593db590278','8992761100018','PRD-20260112-007','COCA COLA 390ML','KARTON',42000.00,48000.00,12,3,0,0.00,'Coca Cola kemasan botol isi 24',NULL,1,'2026-01-12 23:50:58','2026-01-12 23:50:58','Tunai','TUNAI',NULL,NULL,48000.00,48000.00),
('c8b0bb23-e443-4eca-a855-0400fff15308','e983c109-aae5-4fd0-b010-c56025b09412','47c6cfa5-b0d3-43d7-8cbb-498ac2de2c7c','9119581c-6e2d-4207-a604-b593db590278','8992388100040','PRD-20260112-014','SUSU DANCOW PUTIH 800G','BOX',85000.00,95000.00,20,5,0,0.00,'Susu bubuk Dancow 800 gram',NULL,1,'2026-01-12 23:50:58','2026-01-12 23:50:58','Tunai','TUNAI',NULL,NULL,95000.00,95000.00),
('c991e6a0-c523-4239-9ceb-5cfd77aa8075','e983c109-aae5-4fd0-b010-c56025b09412','522f5b89-0e92-4eb0-9531-2aa1e4daa851','354845ab-e35c-4609-961c-7009e426803b','8992388100026','PRD-20260112-012','INDOMIE SOTO','KARTON',60000.00,70000.00,24,5,0,0.00,'Indomie rasa soto isi 40 pcs',NULL,1,'2026-01-12 23:50:58','2026-01-26 15:10:49','Tunai','TUNAI',NULL,NULL,70000.00,70000.00),
('c992c8b6-7bf8-415d-a277-bdbfa10a5c0c','e983c109-aae5-4fd0-b010-c56025b09412','8bfc6feb-6cac-447c-b034-ea0008d9253b','8cf104e1-ab43-466c-938e-e15717968105','8996001411018','PRD-20260112-010','CHEETOS KEJU 80G','PAK',9000.00,11000.00,35,8,0,0.00,'Snack keju renyah',NULL,1,'2026-01-12 23:50:58','2026-01-12 23:50:58','Tunai','TUNAI',NULL,NULL,11000.00,11000.00),
('cad61999-cb50-4297-aff8-bc26120c5433','2dcc3a4c-a0b2-45dc-8541-57bcfcff89d6','60fc3e42-dbf6-48e7-9be6-edc51b4da669','c803d466-bf6b-483f-823a-3a3bd697b661','8986756644476','PRD-20260203-001','Make-Up','PCS',10000.00,12000.00,9,2,0,10.00,NULL,NULL,1,'2026-02-04 01:59:18','2026-02-04 02:00:27','Tunai','TUNAI',NULL,NULL,12000.00,11000.00),
('d6e23904-87ce-438b-95b8-6d4aef2fc7f5','e983c109-aae5-4fd0-b010-c56025b09412','7f2eb2d7-35de-4fcc-bd9f-0282023731b0','9119581c-6e2d-4207-a604-b593db590278','8992753100016','PRD-20260112-006','TEH PUCUK HARUM 350ML','KARTON',48000.00,54000.00,15,3,0,0.00,'Teh kemasan botol isi 24',NULL,1,'2026-01-12 23:50:58','2026-01-12 23:50:58','Tunai','TUNAI',NULL,NULL,54000.00,54000.00),
('ef07ae08-de34-43f2-843b-34e6af83e4c3','e983c109-aae5-4fd0-b010-c56025b09412','8bfc6feb-6cac-447c-b034-ea0008d9253b','8cf104e1-ab43-466c-938e-e15717968105','8996001320013','PRD-20260112-008','CHITATO RASA SAPI PANGGANG 68G','PAK',8000.00,10000.00,50,10,0,0.00,'Keripik kentang rasa sapi panggang',NULL,1,'2026-01-12 23:50:58','2026-01-12 23:50:58','Tunai','TUNAI',NULL,NULL,10000.00,10000.00);
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `purchase_items`
--

DROP TABLE IF EXISTS `purchase_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase_items` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `client_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `purchase_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `product_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `quantity` int(11) NOT NULL,
  `unit` varchar(20) NOT NULL COMMENT 'Satuan kemasan',
  `purchase_price` decimal(15,2) NOT NULL,
  `selling_price` decimal(15,2) NOT NULL,
  `exp_date` datetime DEFAULT NULL COMMENT 'Tanggal expired untuk batch ini',
  `subtotal` decimal(15,2) NOT NULL COMMENT 'quantity * purchasePrice',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `purchase_items_purchase_id` (`purchase_id`),
  KEY `purchase_items_product_id` (`product_id`),
  CONSTRAINT `103` FOREIGN KEY (`purchase_id`) REFERENCES `purchases` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `104` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchase_items`
--

LOCK TABLES `purchase_items` WRITE;
/*!40000 ALTER TABLE `purchase_items` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `purchase_items` VALUES
('26e7f1ba-24e0-464f-8c14-5c0d3dc1ebec','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','a9515ce8-9f4c-43a1-a4c5-3a04a49900c5','01e2bc19-0464-4599-9076-a2adf7ea3db2',10,'PCS',16000.00,22000.00,'2026-05-01 07:00:00',160000.00,'2026-04-02 03:31:41','2026-04-02 03:31:41'),
('4755e16b-bcb9-4e8e-9168-2c00a6100464','e983c109-aae5-4fd0-b010-c56025b09412','8713d1b2-2243-4451-a904-6a635a366b12','a47b4c17-536c-4601-a9eb-b3ae9b1bb211',1,'BTL',30000.00,32000.00,'2026-02-28 07:00:00',30000.00,'2026-02-04 00:19:50','2026-02-04 00:19:50');
/*!40000 ALTER TABLE `purchase_items` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `purchase_return_items`
--

DROP TABLE IF EXISTS `purchase_return_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase_return_items` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `purchase_return_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `product_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `quantity` int(11) NOT NULL,
  `unit` varchar(20) NOT NULL,
  `price` decimal(15,2) NOT NULL,
  `subtotal` decimal(15,2) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `purchase_return_id` (`purchase_return_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `103` FOREIGN KEY (`purchase_return_id`) REFERENCES `purchase_returns` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `104` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchase_return_items`
--

LOCK TABLES `purchase_return_items` WRITE;
/*!40000 ALTER TABLE `purchase_return_items` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `purchase_return_items` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `purchase_returns`
--

DROP TABLE IF EXISTS `purchase_returns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase_returns` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `client_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `purchase_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `supplier_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `user_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `return_number` varchar(50) NOT NULL COMMENT 'Nomor retur (auto-generate)',
  `return_date` datetime NOT NULL,
  `total_amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `reason` text NOT NULL COMMENT 'Alasan retur',
  `status` enum('PENDING','APPROVED','REJECTED') NOT NULL DEFAULT 'PENDING',
  `notes` text DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `return_number` (`return_number`),
  UNIQUE KEY `return_number_2` (`return_number`),
  UNIQUE KEY `return_number_3` (`return_number`),
  UNIQUE KEY `return_number_4` (`return_number`),
  UNIQUE KEY `return_number_5` (`return_number`),
  UNIQUE KEY `return_number_6` (`return_number`),
  UNIQUE KEY `return_number_7` (`return_number`),
  UNIQUE KEY `return_number_8` (`return_number`),
  UNIQUE KEY `return_number_9` (`return_number`),
  UNIQUE KEY `return_number_10` (`return_number`),
  UNIQUE KEY `return_number_11` (`return_number`),
  UNIQUE KEY `return_number_12` (`return_number`),
  UNIQUE KEY `return_number_13` (`return_number`),
  UNIQUE KEY `return_number_14` (`return_number`),
  UNIQUE KEY `return_number_15` (`return_number`),
  UNIQUE KEY `return_number_16` (`return_number`),
  UNIQUE KEY `return_number_17` (`return_number`),
  UNIQUE KEY `return_number_18` (`return_number`),
  UNIQUE KEY `return_number_19` (`return_number`),
  UNIQUE KEY `return_number_20` (`return_number`),
  UNIQUE KEY `return_number_21` (`return_number`),
  UNIQUE KEY `return_number_22` (`return_number`),
  UNIQUE KEY `return_number_23` (`return_number`),
  UNIQUE KEY `return_number_24` (`return_number`),
  UNIQUE KEY `return_number_25` (`return_number`),
  UNIQUE KEY `return_number_26` (`return_number`),
  UNIQUE KEY `return_number_27` (`return_number`),
  UNIQUE KEY `return_number_28` (`return_number`),
  UNIQUE KEY `return_number_29` (`return_number`),
  UNIQUE KEY `return_number_30` (`return_number`),
  UNIQUE KEY `return_number_31` (`return_number`),
  UNIQUE KEY `return_number_32` (`return_number`),
  UNIQUE KEY `return_number_33` (`return_number`),
  UNIQUE KEY `return_number_34` (`return_number`),
  UNIQUE KEY `return_number_35` (`return_number`),
  UNIQUE KEY `return_number_36` (`return_number`),
  UNIQUE KEY `return_number_37` (`return_number`),
  UNIQUE KEY `return_number_38` (`return_number`),
  UNIQUE KEY `return_number_39` (`return_number`),
  UNIQUE KEY `return_number_40` (`return_number`),
  UNIQUE KEY `return_number_41` (`return_number`),
  UNIQUE KEY `return_number_42` (`return_number`),
  UNIQUE KEY `return_number_43` (`return_number`),
  UNIQUE KEY `return_number_44` (`return_number`),
  UNIQUE KEY `return_number_45` (`return_number`),
  UNIQUE KEY `return_number_46` (`return_number`),
  UNIQUE KEY `return_number_47` (`return_number`),
  UNIQUE KEY `return_number_48` (`return_number`),
  UNIQUE KEY `return_number_49` (`return_number`),
  UNIQUE KEY `return_number_50` (`return_number`),
  UNIQUE KEY `return_number_51` (`return_number`),
  UNIQUE KEY `return_number_52` (`return_number`),
  KEY `purchase_returns_supplier_id` (`supplier_id`),
  KEY `purchase_returns_return_date` (`return_date`),
  KEY `purchase_returns_status` (`status`),
  KEY `purchase_id` (`purchase_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `154` FOREIGN KEY (`purchase_id`) REFERENCES `purchases` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `155` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `156` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchase_returns`
--

LOCK TABLES `purchase_returns` WRITE;
/*!40000 ALTER TABLE `purchase_returns` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `purchase_returns` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `purchases`
--

DROP TABLE IF EXISTS `purchases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchases` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `client_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `supplier_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `user_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'User yang input pembelian',
  `invoice_number` varchar(50) NOT NULL COMMENT 'Nomor faktur dari supplier',
  `purchase_date` datetime NOT NULL,
  `purchase_type` enum('TUNAI','KREDIT','KONSINYASI') NOT NULL DEFAULT 'TUNAI' COMMENT 'TUNAI = Bayar langsung, KREDIT = Hutang, KONSINYASI = Bayar yg laku',
  `total_amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `paid_amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `remaining_debt` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT 'Total amount - paid amount',
  `due_date` datetime DEFAULT NULL COMMENT 'Jatuh tempo untuk kredit',
  `status` enum('PENDING','PARTIAL','PAID','CANCELLED') NOT NULL DEFAULT 'PENDING',
  `notes` text DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `purchases_client_id_invoice_number` (`client_id`,`invoice_number`),
  KEY `purchases_supplier_id` (`supplier_id`),
  KEY `purchases_user_id` (`user_id`),
  KEY `purchases_purchase_date` (`purchase_date`),
  KEY `purchases_status` (`status`),
  KEY `purchases_purchase_type` (`purchase_type`),
  CONSTRAINT `157` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `158` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `159` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchases`
--

LOCK TABLES `purchases` WRITE;
/*!40000 ALTER TABLE `purchases` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `purchases` VALUES
('8713d1b2-2243-4451-a904-6a635a366b12','e983c109-aae5-4fd0-b010-c56025b09412','a847e7f6-e062-4558-931c-8c5db0de722d','e6202c95-ba5d-44ae-b474-cca92657976c','PO-20260204-001','2026-02-04 00:19:50','TUNAI',30000.00,30000.00,0.00,NULL,'PAID','','2026-02-04 00:19:50','2026-02-04 00:19:50'),
('a9515ce8-9f4c-43a1-a4c5-3a04a49900c5','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','c3b3f4d7-f63c-4b90-b68c-78f16271342b','ca514c50-219f-448c-bf71-70a742f29382','PO-20260402-001','2026-04-02 03:31:41','TUNAI',160000.00,160000.00,0.00,NULL,'PAID','','2026-04-02 03:31:41','2026-04-02 03:31:41');
/*!40000 ALTER TABLE `purchases` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `sale_items`
--

DROP TABLE IF EXISTS `sale_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `sale_items` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `client_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `sale_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `product_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `product_name` varchar(100) NOT NULL COMMENT 'Snapshot nama produk saat transaksi',
  `quantity` int(11) NOT NULL,
  `unit` varchar(20) NOT NULL,
  `selling_price` decimal(15,2) NOT NULL,
  `subtotal` decimal(15,2) NOT NULL,
  `points_earned` int(11) DEFAULT 0,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sale_id` (`sale_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `103` FOREIGN KEY (`sale_id`) REFERENCES `sales` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `104` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sale_items`
--

LOCK TABLES `sale_items` WRITE;
/*!40000 ALTER TABLE `sale_items` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `sale_items` VALUES
('058fb54c-1310-497f-bec5-11b12e472894','3b415014-cfd3-4ca8-8f19-137d3d074bda','3128a0c7-ef61-4315-a9c0-b5f918566d96','046212b1-966f-447c-b263-45ad46c3b07a','Google Calendar',1,'PCS',5000.00,5000.00,5,'2026-02-04 01:18:49','2026-02-04 01:18:49'),
('0dcd1aa6-3309-4029-a0a2-485ad3d14d49','e983c109-aae5-4fd0-b010-c56025b09412','42c573d3-7fd5-4785-a11a-bf30228e17dc','6c2095d8-cdd7-41c0-8a85-0d4c2ec25f0e','INDOMIE GORENG',1,'KARTON',70000.00,70000.00,0,'2026-01-26 15:37:40','2026-01-26 15:37:40'),
('1e2b5edb-22ee-4899-ab22-aea4026c65d1','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','ac5d76fb-6449-443f-9f3b-4b07a2c4a04e','01e2bc19-0464-4599-9076-a2adf7ea3db2','Gas 3 KG',1,'PCS',22000.00,22000.00,0,'2026-04-02 03:34:07','2026-04-02 03:34:07'),
('5a4e70f7-942a-46fc-8da6-a1ed16ea6ddf','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','2bc3b6f8-04f4-442a-955b-953f37363eee','01e2bc19-0464-4599-9076-a2adf7ea3db2','Gas 3 KG',1,'PCS',22000.00,22000.00,0,'2026-04-02 03:25:02','2026-04-02 03:25:02'),
('75ba8fbf-3273-453d-bf90-4adc2e5322e2','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','02238c54-78c7-4149-ae93-a313a2793a36','01e2bc19-0464-4599-9076-a2adf7ea3db2','Gas 3 KG',1,'PCS',20000.00,20000.00,0,'2026-04-02 03:27:03','2026-04-02 03:27:03'),
('7c942417-7754-4119-9499-1d9b37893fe6','e983c109-aae5-4fd0-b010-c56025b09412','f83820e2-c6b3-4e43-a4fe-401377125546','0440627b-ef83-43cf-b918-c1a9534c1d3e','OREO VANILLA 137G',2,'PAK',9000.00,18000.00,18,'2026-01-13 00:10:26','2026-01-13 00:10:26'),
('9183ecc6-6ee6-4017-a7d4-a9671b4bf631','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','251a3d2a-1ab6-4c93-814a-1ddbbf017608','01e2bc19-0464-4599-9076-a2adf7ea3db2','Gas 3 KG',5,'PCS',20000.00,100000.00,100,'2026-04-02 03:29:49','2026-04-02 03:29:49'),
('b15bd8be-8fb8-411a-8589-8c71413b8110','3b415014-cfd3-4ca8-8f19-137d3d074bda','537cc545-b270-461b-af21-54ad7de34872','046212b1-966f-447c-b263-45ad46c3b07a','Google Calendar',2,'PCS',5000.00,10000.00,0,'2026-02-03 23:13:09','2026-02-03 23:13:09'),
('b6ac54a7-0e53-4888-b85d-4c79b6cb2967','3b415014-cfd3-4ca8-8f19-137d3d074bda','8a92cbee-98a8-43f3-902f-808bcec0269b','046212b1-966f-447c-b263-45ad46c3b07a','Google Calendar',2,'PCS',5000.00,10000.00,10,'2026-02-04 01:16:04','2026-02-04 01:16:04'),
('c0a3c0af-4afc-4bb3-bbe6-da8401e42ccc','e983c109-aae5-4fd0-b010-c56025b09412','eefe9878-3baf-4c08-a9f8-e4d4a685526f','6c2095d8-cdd7-41c0-8a85-0d4c2ec25f0e','INDOMIE GORENG',1,'KARTON',70000.00,70000.00,70,'2026-01-26 14:44:13','2026-01-26 14:44:13'),
('cb97539f-79d6-47ff-864f-c846321fb164','e983c109-aae5-4fd0-b010-c56025b09412','50a1b1ce-81da-4ba7-b845-b61a4be29a44','a47b4c17-536c-4601-a9eb-b3ae9b1bb211','MINYAK GORENG TROPICAL 2L',1,'BTL',32000.00,32000.00,0,'2026-01-26 15:10:49','2026-01-26 15:10:49'),
('e30b342c-6322-40e6-a3b8-69bd6e814192','2dcc3a4c-a0b2-45dc-8541-57bcfcff89d6','a2d11478-c623-4d10-98ea-4ad07d36d94f','cad61999-cb50-4297-aff8-bc26120c5433','Make-Up',1,'PCS',11000.00,11000.00,0,'2026-02-04 02:00:27','2026-02-04 02:00:27'),
('ee3ef331-af6f-4268-a752-617ba76ffc5f','e983c109-aae5-4fd0-b010-c56025b09412','eefe9878-3baf-4c08-a9f8-e4d4a685526f','0440627b-ef83-43cf-b918-c1a9534c1d3e','OREO VANILLA 137G',1,'PAK',9000.00,9000.00,9,'2026-01-26 14:44:13','2026-01-26 14:44:13'),
('f3a11d10-c72b-4b0f-99bd-d5cb7e39f602','3b415014-cfd3-4ca8-8f19-137d3d074bda','0298402d-6269-4f2e-ae15-c77e1e7df19d','046212b1-966f-447c-b263-45ad46c3b07a','Google Calendar',1,'PCS',4000.00,4000.00,4,'2026-02-04 01:24:18','2026-02-04 01:24:18'),
('fd7300f1-aad5-4b18-9ffb-24222b7950fc','e983c109-aae5-4fd0-b010-c56025b09412','50a1b1ce-81da-4ba7-b845-b61a4be29a44','c991e6a0-c523-4239-9ceb-5cfd77aa8075','INDOMIE SOTO',1,'KARTON',70000.00,70000.00,0,'2026-01-26 15:10:49','2026-01-26 15:10:49');
/*!40000 ALTER TABLE `sale_items` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `sales`
--

DROP TABLE IF EXISTS `sales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `sales` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `client_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `member_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `user_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `invoice_number` varchar(50) NOT NULL,
  `sale_date` datetime NOT NULL,
  `sale_type` enum('TUNAI','KREDIT') NOT NULL DEFAULT 'TUNAI',
  `total_amount` decimal(15,2) DEFAULT 0.00,
  `discount_amount` decimal(15,2) DEFAULT 0.00,
  `discount_percentage` decimal(5,2) DEFAULT 0.00,
  `final_amount` decimal(15,2) DEFAULT 0.00,
  `dp_amount` decimal(15,2) DEFAULT 0.00,
  `remaining_debt` decimal(15,2) DEFAULT 0.00,
  `payment_received` decimal(15,2) DEFAULT 0.00,
  `change_amount` decimal(15,2) DEFAULT 0.00,
  `due_date` datetime DEFAULT NULL,
  `status` enum('PENDING','PARTIAL','PAID','CANCELLED') DEFAULT 'PAID',
  `notes` text DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sales_client_id_invoice_number` (`client_id`,`invoice_number`),
  KEY `sales_client_id_sale_date` (`client_id`,`sale_date`),
  KEY `sales_member_id` (`member_id`),
  KEY `sales_user_id` (`user_id`),
  CONSTRAINT `158` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `159` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `160` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `161` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales`
--

LOCK TABLES `sales` WRITE;
/*!40000 ALTER TABLE `sales` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `sales` VALUES
('02238c54-78c7-4149-ae93-a313a2793a36','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','846a2b2a-b4e5-41a3-ad6f-f0449f2f4a59','ca514c50-219f-448c-bf71-70a742f29382','0426-002 T','2026-04-02 03:27:03','TUNAI',20000.00,0.00,0.00,20000.00,0.00,0.00,50000.00,30000.00,NULL,'PAID','','2026-04-02 03:27:03','2026-04-02 03:27:03'),
('0298402d-6269-4f2e-ae15-c77e1e7df19d','3b415014-cfd3-4ca8-8f19-137d3d074bda','76934931-62a6-4de1-b78e-333578e42af5','2becb525-e406-4588-b481-4cae80f41d92','0226-004 T','2026-02-04 01:24:18','TUNAI',4000.00,0.00,0.00,4000.00,0.00,0.00,4000.00,0.00,NULL,'PAID','','2026-02-04 01:24:18','2026-02-04 01:24:18'),
('251a3d2a-1ab6-4c93-814a-1ddbbf017608','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','846a2b2a-b4e5-41a3-ad6f-f0449f2f4a59','ca514c50-219f-448c-bf71-70a742f29382','0426-001 K','2026-04-02 03:29:49','KREDIT',100000.00,0.00,0.00,100000.00,1000.00,99000.00,0.00,0.00,'2030-11-14 07:00:00','PARTIAL','','2026-04-02 03:29:49','2026-04-02 03:29:49'),
('2bc3b6f8-04f4-442a-955b-953f37363eee','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57',NULL,'ca514c50-219f-448c-bf71-70a742f29382','0426-001 T','2026-04-02 03:25:02','TUNAI',22000.00,0.00,0.00,22000.00,0.00,0.00,50000.00,28000.00,NULL,'PAID','','2026-04-02 03:25:02','2026-04-02 03:25:02'),
('3128a0c7-ef61-4315-a9c0-b5f918566d96','3b415014-cfd3-4ca8-8f19-137d3d074bda','76934931-62a6-4de1-b78e-333578e42af5','2becb525-e406-4588-b481-4cae80f41d92','0226-003 T','2026-02-04 01:18:49','TUNAI',5000.00,0.00,0.00,5000.00,0.00,0.00,5000.00,0.00,NULL,'PAID','','2026-02-04 01:18:49','2026-02-04 01:18:49'),
('42c573d3-7fd5-4785-a11a-bf30228e17dc','e983c109-aae5-4fd0-b010-c56025b09412',NULL,'e6202c95-ba5d-44ae-b474-cca92657976c','0126-004 T','2026-01-26 15:37:40','TUNAI',70000.00,0.00,0.00,70000.00,0.00,0.00,100000.00,30000.00,NULL,'PAID','','2026-01-26 15:37:40','2026-01-26 15:37:40'),
('50a1b1ce-81da-4ba7-b845-b61a4be29a44','e983c109-aae5-4fd0-b010-c56025b09412',NULL,'e6202c95-ba5d-44ae-b474-cca92657976c','0126-003 T','2026-01-26 15:10:49','TUNAI',102000.00,0.00,0.00,102000.00,0.00,0.00,110000.00,8000.00,NULL,'PAID','','2026-01-26 15:10:49','2026-01-26 15:10:49'),
('537cc545-b270-461b-af21-54ad7de34872','3b415014-cfd3-4ca8-8f19-137d3d074bda',NULL,'2becb525-e406-4588-b481-4cae80f41d92','0226-001 T','2026-02-03 23:13:09','TUNAI',10000.00,0.00,0.00,10000.00,0.00,0.00,50000.00,40000.00,NULL,'PAID','','2026-02-03 23:13:09','2026-02-03 23:13:09'),
('8a92cbee-98a8-43f3-902f-808bcec0269b','3b415014-cfd3-4ca8-8f19-137d3d074bda','76934931-62a6-4de1-b78e-333578e42af5','2becb525-e406-4588-b481-4cae80f41d92','0226-002 T','2026-02-04 01:16:04','TUNAI',10000.00,0.00,0.00,10000.00,0.00,0.00,10000.00,0.00,NULL,'PAID','','2026-02-04 01:16:04','2026-02-04 01:16:04'),
('a2d11478-c623-4d10-98ea-4ad07d36d94f','2dcc3a4c-a0b2-45dc-8541-57bcfcff89d6','ef1641c9-86f1-4584-a1d9-c9997e2efbcc','3d0b20d9-8053-4727-b5de-7f837b31217b','0226-005 T','2026-02-04 02:00:27','TUNAI',11000.00,0.00,0.00,11000.00,0.00,0.00,11000.00,0.00,NULL,'PAID','','2026-02-04 02:00:27','2026-02-04 02:00:27'),
('ac5d76fb-6449-443f-9f3b-4b07a2c4a04e','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57',NULL,'cbf1b57b-be22-4f0b-bce7-65e66d459064','0426-003 T','2026-04-02 03:34:07','TUNAI',22000.00,0.00,0.00,22000.00,0.00,0.00,50000.00,28000.00,NULL,'PAID','','2026-04-02 03:34:07','2026-04-02 03:34:07'),
('eefe9878-3baf-4c08-a9f8-e4d4a685526f','e983c109-aae5-4fd0-b010-c56025b09412','4263dfc1-ccda-4b41-a833-d7239c4a58f1','40df4d1a-128e-4516-84d6-f17528016378','0126-002 T','2026-01-26 14:44:13','TUNAI',79000.00,0.00,0.00,79000.00,0.00,0.00,100000.00,21000.00,NULL,'PAID','','2026-01-26 14:44:13','2026-01-26 14:44:13'),
('f83820e2-c6b3-4e43-a4fe-401377125546','e983c109-aae5-4fd0-b010-c56025b09412','4263dfc1-ccda-4b41-a833-d7239c4a58f1','e6202c95-ba5d-44ae-b474-cca92657976c','0126-001 T','2026-01-13 00:10:26','TUNAI',18000.00,0.00,0.00,18000.00,0.00,0.00,50000.00,32000.00,NULL,'PAID','Test transaksi perdana SaaS','2026-01-13 00:10:26','2026-01-13 00:10:26');
/*!40000 ALTER TABLE `sales` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `sales_return_items`
--

DROP TABLE IF EXISTS `sales_return_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `sales_return_items` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `sales_return_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `product_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `quantity` int(11) NOT NULL,
  `unit` varchar(20) NOT NULL,
  `price` decimal(15,2) NOT NULL,
  `subtotal` decimal(15,2) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sales_return_items_sales_return_id` (`sales_return_id`),
  KEY `sales_return_items_product_id` (`product_id`),
  CONSTRAINT `103` FOREIGN KEY (`sales_return_id`) REFERENCES `sales_returns` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `104` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_return_items`
--

LOCK TABLES `sales_return_items` WRITE;
/*!40000 ALTER TABLE `sales_return_items` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `sales_return_items` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `sales_returns`
--

DROP TABLE IF EXISTS `sales_returns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `sales_returns` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `client_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `sale_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `member_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `user_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `return_number` varchar(50) NOT NULL COMMENT 'Nomor retur (auto-generate)',
  `return_date` datetime NOT NULL,
  `total_amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `reason` text NOT NULL COMMENT 'Alasan retur',
  `status` enum('PENDING','APPROVED','REJECTED') NOT NULL DEFAULT 'PENDING',
  `refund_method` enum('CASH','DEBT_DEDUCTION','STORE_CREDIT') NOT NULL DEFAULT 'CASH' COMMENT 'Metode pengembalian dana',
  `notes` text DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `return_number` (`return_number`),
  UNIQUE KEY `sales_returns_return_number` (`return_number`),
  UNIQUE KEY `return_number_2` (`return_number`),
  UNIQUE KEY `return_number_3` (`return_number`),
  UNIQUE KEY `return_number_4` (`return_number`),
  UNIQUE KEY `return_number_5` (`return_number`),
  UNIQUE KEY `return_number_6` (`return_number`),
  UNIQUE KEY `return_number_7` (`return_number`),
  UNIQUE KEY `return_number_8` (`return_number`),
  UNIQUE KEY `return_number_9` (`return_number`),
  UNIQUE KEY `return_number_10` (`return_number`),
  UNIQUE KEY `return_number_11` (`return_number`),
  UNIQUE KEY `return_number_12` (`return_number`),
  UNIQUE KEY `return_number_13` (`return_number`),
  UNIQUE KEY `return_number_14` (`return_number`),
  UNIQUE KEY `return_number_15` (`return_number`),
  UNIQUE KEY `return_number_16` (`return_number`),
  UNIQUE KEY `return_number_17` (`return_number`),
  UNIQUE KEY `return_number_18` (`return_number`),
  UNIQUE KEY `return_number_19` (`return_number`),
  UNIQUE KEY `return_number_20` (`return_number`),
  UNIQUE KEY `return_number_21` (`return_number`),
  UNIQUE KEY `return_number_22` (`return_number`),
  UNIQUE KEY `return_number_23` (`return_number`),
  UNIQUE KEY `return_number_24` (`return_number`),
  UNIQUE KEY `return_number_25` (`return_number`),
  UNIQUE KEY `return_number_26` (`return_number`),
  UNIQUE KEY `return_number_27` (`return_number`),
  UNIQUE KEY `return_number_28` (`return_number`),
  UNIQUE KEY `return_number_29` (`return_number`),
  UNIQUE KEY `return_number_30` (`return_number`),
  UNIQUE KEY `return_number_31` (`return_number`),
  UNIQUE KEY `return_number_32` (`return_number`),
  UNIQUE KEY `return_number_33` (`return_number`),
  UNIQUE KEY `return_number_34` (`return_number`),
  UNIQUE KEY `return_number_35` (`return_number`),
  UNIQUE KEY `return_number_36` (`return_number`),
  UNIQUE KEY `return_number_37` (`return_number`),
  UNIQUE KEY `return_number_38` (`return_number`),
  UNIQUE KEY `return_number_39` (`return_number`),
  UNIQUE KEY `return_number_40` (`return_number`),
  UNIQUE KEY `return_number_41` (`return_number`),
  UNIQUE KEY `return_number_42` (`return_number`),
  UNIQUE KEY `return_number_43` (`return_number`),
  UNIQUE KEY `return_number_44` (`return_number`),
  UNIQUE KEY `return_number_45` (`return_number`),
  UNIQUE KEY `return_number_46` (`return_number`),
  UNIQUE KEY `return_number_47` (`return_number`),
  UNIQUE KEY `return_number_48` (`return_number`),
  UNIQUE KEY `return_number_49` (`return_number`),
  UNIQUE KEY `return_number_50` (`return_number`),
  UNIQUE KEY `return_number_51` (`return_number`),
  UNIQUE KEY `return_number_52` (`return_number`),
  KEY `sales_returns_sale_id` (`sale_id`),
  KEY `sales_returns_member_id` (`member_id`),
  KEY `sales_returns_return_date` (`return_date`),
  KEY `sales_returns_status` (`status`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `154` FOREIGN KEY (`sale_id`) REFERENCES `sales` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `155` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `156` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_returns`
--

LOCK TABLES `sales_returns` WRITE;
/*!40000 ALTER TABLE `sales_returns` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `sales_returns` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `settings` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `client_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `key` varchar(100) NOT NULL,
  `value` text DEFAULT NULL,
  `type` enum('TEXT','NUMBER','BOOLEAN','JSON') DEFAULT 'TEXT',
  `group` varchar(50) DEFAULT 'GENERAL',
  `description` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `settings_client_id_key` (`client_id`,`key`),
  CONSTRAINT `1` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settings`
--

LOCK TABLES `settings` WRITE;
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `settings` VALUES
('02333d69-7840-4205-a195-a32aec007998','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','auto_reorder_enabled','false','BOOLEAN','INVENTORY','Auto reorder saat stok menipis','2026-04-02 03:22:58','2026-04-02 03:22:58'),
('039d667d-4e68-4d3f-9987-053b24212c35','2dcc3a4c-a0b2-45dc-8541-57bcfcff89d6','bank_account_name','Koperasi Makmur','TEXT','BANK','Nama pemilik rekening','2026-02-04 01:57:54','2026-02-04 01:57:54'),
('08dee33a-bcd9-4897-8094-ad9f9b70b1dc','e983c109-aae5-4fd0-b010-c56025b09412','company_phone','08123456789','TEXT','COMPANY','','2026-01-12 23:25:07','2026-01-12 23:25:07'),
('0f30e8d2-b61e-4153-8dac-48f800cd2e4f','e983c109-aae5-4fd0-b010-c56025b09412','low_stock_alert_threshold','10','NUMBER','INVENTORY','','2026-01-12 23:25:07','2026-01-12 23:25:07'),
('0f429982-4991-433a-849d-836713748982','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','auto_print_after_sale','true','BOOLEAN','PRINT','Auto print setelah transaksi','2026-04-02 03:22:58','2026-04-02 03:22:58'),
('14b5a3ce-4844-42e1-91ca-4a5ef68a4bec','2dcc3a4c-a0b2-45dc-8541-57bcfcff89d6','auto_reorder_enabled','false','BOOLEAN','INVENTORY','Auto reorder saat stok menipis','2026-02-04 01:57:54','2026-02-04 01:57:54'),
('1d80e430-0f19-4a45-9408-972e5c22b6d6','2dcc3a4c-a0b2-45dc-8541-57bcfcff89d6','bank_account_number','','TEXT','BANK','Nomor rekening bank','2026-02-04 01:57:54','2026-02-04 01:57:54'),
('25970589-bc10-4f23-977d-25089bea0661','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','min_transaction_for_points','50000','NUMBER','TRANSACTION','Minimum transaksi untuk dapat point','2026-04-02 03:22:58','2026-04-02 03:22:58'),
('2d1df7ae-c45a-49af-bebe-44d0fe9a1884','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','company_phone','081234567890','TEXT','COMPANY','Nomor telepon perusahaan','2026-04-02 03:22:57','2026-04-02 03:22:57'),
('2e1cb185-d0ff-4f30-b8ba-f616d6c72dd2','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','company_website','','TEXT','COMPANY','Website perusahaan','2026-04-02 03:22:57','2026-04-02 03:22:57'),
('33bb6550-58c9-4436-a155-99c932673f39','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','point_value','1000','NUMBER','TRANSACTION','Nilai point dalam rupiah (1 point = X rupiah)','2026-04-02 03:22:58','2026-04-02 03:22:58'),
('356bc2d4-4458-4fb8-b04d-c36bb542bd88','2dcc3a4c-a0b2-45dc-8541-57bcfcff89d6','min_points_to_redeem','100','NUMBER','TRANSACTION','Minimum point untuk ditukar','2026-02-04 01:57:54','2026-02-04 01:57:54'),
('3574b216-60ac-415c-a500-5b56da4c26f4','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','print_dot_matrix_width','80','NUMBER','PRINT','Lebar karakter dot matrix','2026-04-02 03:22:58','2026-04-02 03:22:58'),
('3affa6a8-a486-4beb-a0e2-cd69796d17c7','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','print_show_barcode','true','BOOLEAN','PRINT','Tampilkan barcode di struk','2026-04-02 03:22:58','2026-04-02 03:22:58'),
('3fd44216-11e4-4f63-b374-4da1299730be','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','default_credit_days','30','NUMBER','TRANSACTION','Jangka waktu kredit default (hari)','2026-04-02 03:22:57','2026-04-02 03:22:57'),
('43685952-2f52-4fc7-8a64-57cda24f4e7c','2dcc3a4c-a0b2-45dc-8541-57bcfcff89d6','point_enabled','true','BOOLEAN','TRANSACTION','Enable/disable sistem point','2026-02-04 01:57:54','2026-02-04 01:57:54'),
('43a23579-1a49-4bd3-9232-e7edf79b0964','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','company_address','Alamat Toko Anda','TEXT','COMPANY','Alamat perusahaan','2026-04-02 03:22:57','2026-04-02 03:22:57'),
('4873fd61-2546-4a07-b5ce-087d57286d56','e983c109-aae5-4fd0-b010-c56025b09412','company_address','Jl. Teknologi No. 1, Bandung','TEXT','COMPANY','','2026-01-12 23:25:07','2026-01-12 23:25:07'),
('4d361f9d-7b6e-4ba8-9a1a-dd6f68558341','2dcc3a4c-a0b2-45dc-8541-57bcfcff89d6','low_stock_alert_threshold','10','NUMBER','INVENTORY','Batas minimal stok untuk alert','2026-02-04 01:57:54','2026-02-04 01:57:54'),
('4d3f4854-0f2d-47a9-8f08-106233ed46f5','e983c109-aae5-4fd0-b010-c56025b09412','company_name','Koperasi Demo Sejahtera','TEXT','COMPANY','','2026-01-12 23:25:07','2026-01-12 23:25:07'),
('59ae8e71-61e3-4381-9c5a-b5e5e8877bde','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','min_points_to_redeem','100','NUMBER','TRANSACTION','Minimum point untuk ditukar','2026-04-02 03:22:58','2026-04-02 03:22:58'),
('5a6c1490-dd40-42d2-a622-622b87c7a90d','2dcc3a4c-a0b2-45dc-8541-57bcfcff89d6','print_show_barcode','true','BOOLEAN','PRINT','Tampilkan barcode di struk','2026-02-04 01:57:54','2026-02-04 01:57:54'),
('5d7e774e-a182-4be7-b809-f11698aa7910','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','bank_account_number','','TEXT','BANK','Nomor rekening bank','2026-04-02 03:22:57','2026-04-02 03:22:57'),
('6422ecf4-6b30-45df-b79c-2fd183f58d16','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','company_name','Koperasi Merah Putih','TEXT','COMPANY','Nama perusahaan','2026-04-02 03:22:57','2026-04-02 03:22:57'),
('688c7ec0-b31b-4dc2-80c5-ba6ace26487d','2dcc3a4c-a0b2-45dc-8541-57bcfcff89d6','company_city','','TEXT','COMPANY','Kota perusahaan','2026-02-04 01:57:54','2026-02-04 01:57:54'),
('6c614e6c-4472-4dca-bc8f-9085677a7726','2dcc3a4c-a0b2-45dc-8541-57bcfcff89d6','company_phone','081234567890','TEXT','COMPANY','Nomor telepon perusahaan','2026-02-04 01:57:54','2026-02-04 01:57:54'),
('70120209-1648-4eee-ab09-93bc8d8534ae','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','point_expiry_months','12','NUMBER','TRANSACTION','Masa berlaku point (bulan)','2026-04-02 03:22:58','2026-04-02 03:22:58'),
('7c10e608-4109-4724-8809-41abd9dc4439','2dcc3a4c-a0b2-45dc-8541-57bcfcff89d6','auto_print_after_sale','true','BOOLEAN','PRINT','Auto print setelah transaksi','2026-02-04 01:57:54','2026-02-04 01:57:54'),
('825d5565-a0df-488a-b388-3010969dc77b','2dcc3a4c-a0b2-45dc-8541-57bcfcff89d6','point_per_rupiah','1000','NUMBER','TRANSACTION','Poin per rupiah (1 poin per 1000 rupiah)','2026-02-04 01:57:54','2026-02-04 01:57:54'),
('91999b25-0b11-481a-947a-8ab569643155','2dcc3a4c-a0b2-45dc-8541-57bcfcff89d6','bank_name','','TEXT','BANK','Nama bank','2026-02-04 01:57:54','2026-02-04 01:57:54'),
('95666749-e520-40d8-ad7a-0b2a378ec28a','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','point_per_rupiah','1000','NUMBER','TRANSACTION','Poin per rupiah (1 poin per 1000 rupiah)','2026-04-02 03:22:57','2026-04-02 03:22:57'),
('96c384c3-5e50-4702-90fb-dc1675c9dfb1','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','point_enabled','true','BOOLEAN','TRANSACTION','Enable/disable sistem point','2026-04-02 03:22:58','2026-04-02 03:22:58'),
('9d9e0659-6131-4452-95e9-6b979a1354c3','2dcc3a4c-a0b2-45dc-8541-57bcfcff89d6','point_expiry_months','12','NUMBER','TRANSACTION','Masa berlaku point (bulan)','2026-02-04 01:57:54','2026-02-04 01:57:54'),
('a05b74ad-e850-4f50-8fda-088e01d43a5a','e983c109-aae5-4fd0-b010-c56025b09412','point_enabled','true','BOOLEAN','POINTS','','2026-01-12 23:25:07','2026-01-12 23:25:07'),
('a08736c7-2138-4d91-a502-d8b30193b650','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','low_stock_alert_threshold','10','NUMBER','INVENTORY','Batas minimal stok untuk alert','2026-04-02 03:22:58','2026-04-02 03:22:58'),
('a0f38066-d898-4430-8a33-c1879e1d5521','2dcc3a4c-a0b2-45dc-8541-57bcfcff89d6','company_name','Koperasi Makmur','TEXT','COMPANY','Nama perusahaan','2026-02-04 01:57:54','2026-02-04 01:57:54'),
('abe35be5-25b6-4b84-9bb5-a053414750dd','e983c109-aae5-4fd0-b010-c56025b09412','print_show_barcode','true','BOOLEAN','PRINT','','2026-01-12 23:25:07','2026-01-12 23:25:07'),
('b59e6ed0-3414-4a1d-8520-029c28adb95a','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','min_credit_dp_percentage','20','NUMBER','TRANSACTION','Minimal DP untuk kredit (%)','2026-04-02 03:22:57','2026-04-02 03:22:57'),
('c36527bd-9c6d-4935-8b90-aec842d23f7a','2dcc3a4c-a0b2-45dc-8541-57bcfcff89d6','company_website','','TEXT','COMPANY','Website perusahaan','2026-02-04 01:57:54','2026-02-04 01:57:54'),
('c99b8b8d-a32c-4537-a770-2d3e73e5a727','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','bank_account_name','Koperasi Merah Putih','TEXT','BANK','Nama pemilik rekening','2026-04-02 03:22:57','2026-04-02 03:22:57'),
('ccb04de2-087b-4bc5-bf91-c5f97911919c','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','company_city','','TEXT','COMPANY','Kota perusahaan','2026-04-02 03:22:57','2026-04-02 03:22:57'),
('d14bd9fe-25f7-4267-9a00-a3e5373b551c','2dcc3a4c-a0b2-45dc-8541-57bcfcff89d6','company_address','Jlain aja dulu nomor 5','TEXT','COMPANY',NULL,'2026-02-04 01:57:54','2026-02-04 02:09:58'),
('d3fd1fae-ce3d-493e-a175-55773b6bdff8','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','print_thermal_width','58','NUMBER','PRINT','Lebar kertas thermal (mm)','2026-04-02 03:22:58','2026-04-02 03:22:58'),
('d6e03a27-0eb7-44dd-bdf7-fcb8efb23449','2dcc3a4c-a0b2-45dc-8541-57bcfcff89d6','print_thermal_width','58','NUMBER','PRINT','Lebar kertas thermal (mm)','2026-02-04 01:57:54','2026-02-04 01:57:54'),
('daae52f7-abb7-49b8-8e1a-829ce19bd303','2dcc3a4c-a0b2-45dc-8541-57bcfcff89d6','point_value','1000','NUMBER','TRANSACTION','Nilai point dalam rupiah (1 point = X rupiah)','2026-02-04 01:57:54','2026-02-04 01:57:54'),
('ea6e9ea2-6f23-4c02-9f9a-ecd427e41fc3','2dcc3a4c-a0b2-45dc-8541-57bcfcff89d6','min_credit_dp_percentage','20','NUMBER','TRANSACTION','Minimal DP untuk kredit (%)','2026-02-04 01:57:54','2026-02-04 01:57:54'),
('ebf13b97-379d-475f-b9a7-a4a988067e38','2dcc3a4c-a0b2-45dc-8541-57bcfcff89d6','min_transaction_for_points','50000','NUMBER','TRANSACTION','Minimum transaksi untuk dapat point','2026-02-04 01:57:54','2026-02-04 01:57:54'),
('ed2e15d9-d781-497d-af5f-084a38062623','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','bank_name','','TEXT','BANK','Nama bank','2026-04-02 03:22:57','2026-04-02 03:22:57'),
('ef05aad8-2a99-44c8-82e2-2d079b335408','2dcc3a4c-a0b2-45dc-8541-57bcfcff89d6','print_dot_matrix_width','80','NUMBER','PRINT','Lebar karakter dot matrix','2026-02-04 01:57:54','2026-02-04 01:57:54'),
('f06db186-ae4a-4b9f-9113-5c4aa7307c36','2dcc3a4c-a0b2-45dc-8541-57bcfcff89d6','default_credit_days','30','NUMBER','TRANSACTION','Jangka waktu kredit default (hari)','2026-02-04 01:57:54','2026-02-04 01:57:54');
/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `stock_adjustments`
--

DROP TABLE IF EXISTS `stock_adjustments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock_adjustments` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `client_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `product_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `user_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `adjustment_number` varchar(50) NOT NULL,
  `adjustment_type` enum('DAMAGED','EXPIRED','LOST','LEAKED','REPACK','FOUND','OTHER') NOT NULL,
  `quantity` int(11) DEFAULT NULL,
  `reason` text DEFAULT NULL,
  `adjustment_date` datetime DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `approved_by` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `status` enum('PENDING','APPROVED','REJECTED') DEFAULT 'APPROVED',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `stock_adjustments_client_id_adjustment_number` (`client_id`,`adjustment_number`),
  KEY `product_id` (`product_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `105` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `106` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_adjustments`
--

LOCK TABLES `stock_adjustments` WRITE;
/*!40000 ALTER TABLE `stock_adjustments` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `stock_adjustments` VALUES
('46ca37d2-936e-4e98-9720-6ffec30692af','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','01e2bc19-0464-4599-9076-a2adf7ea3db2','ca514c50-219f-448c-bf71-70a742f29382','ADJ-20260401-001','LEAKED',-1,'Ya bocor lah, bauuu','2026-04-02 03:26:00','',NULL,'APPROVED','2026-04-02 03:26:00','2026-04-02 03:26:00'),
('990016ff-9f37-4c0d-8fc3-a9552e99e6b6','e983c109-aae5-4fd0-b010-c56025b09412','73c17329-c216-4e06-802e-30d9bcbcdb3f','e6202c95-ba5d-44ae-b474-cca92657976c','ADJ-20260126-001','LEAKED',-1,'Tinta nya bocor nih','2026-01-26 16:03:02','',NULL,'APPROVED','2026-01-26 16:03:02','2026-01-26 16:03:02');
/*!40000 ALTER TABLE `stock_adjustments` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `stock_movements`
--

DROP TABLE IF EXISTS `stock_movements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock_movements` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `client_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `product_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `type` enum('IN','OUT','ADJUSTMENT','RETURN_IN','RETURN_OUT') NOT NULL,
  `quantity` int(11) NOT NULL,
  `quantity_before` int(11) DEFAULT NULL,
  `quantity_after` int(11) DEFAULT NULL,
  `reference_type` enum('PURCHASE','SALE','ADJUSTMENT','RETURN') DEFAULT NULL,
  `reference_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_by` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  KEY `created_by` (`created_by`),
  CONSTRAINT `105` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `106` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_movements`
--

LOCK TABLES `stock_movements` WRITE;
/*!40000 ALTER TABLE `stock_movements` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `stock_movements` VALUES
('167a0558-5834-4e66-9a96-b437e6d40614','e983c109-aae5-4fd0-b010-c56025b09412','0440627b-ef83-43cf-b918-c1a9534c1d3e','OUT',-2,40,38,'SALE','f83820e2-c6b3-4e43-a4fe-401377125546','Penjualan 0126-001 T','e6202c95-ba5d-44ae-b474-cca92657976c','2026-01-13 00:10:26','2026-01-13 00:10:26'),
('22d0c124-501e-4753-8416-eb300795a636','e983c109-aae5-4fd0-b010-c56025b09412','73c17329-c216-4e06-802e-30d9bcbcdb3f','ADJUSTMENT',-1,12,11,'ADJUSTMENT','990016ff-9f37-4c0d-8fc3-a9552e99e6b6','LEAKED: Tinta nya bocor nih','e6202c95-ba5d-44ae-b474-cca92657976c','2026-01-26 16:03:02','2026-01-26 16:03:02'),
('2cc14837-785c-4c16-9348-58d62d5e39cc','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','01e2bc19-0464-4599-9076-a2adf7ea3db2','IN',10,7,17,'PURCHASE','a9515ce8-9f4c-43a1-a4c5-3a04a49900c5','Pembelian dari PT OKE GAS','ca514c50-219f-448c-bf71-70a742f29382','2026-04-02 03:31:41','2026-04-02 03:31:41'),
('33a360ba-8b81-432b-a5be-cb56b8a4d88d','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','01e2bc19-0464-4599-9076-a2adf7ea3db2','OUT',-1,13,12,'SALE','02238c54-78c7-4149-ae93-a313a2793a36','Penjualan 0426-002 T','ca514c50-219f-448c-bf71-70a742f29382','2026-04-02 03:27:03','2026-04-02 03:27:03'),
('3a724873-8304-4311-9a4d-e08f1a151722','3b415014-cfd3-4ca8-8f19-137d3d074bda','046212b1-966f-447c-b263-45ad46c3b07a','OUT',-2,24,22,'SALE','537cc545-b270-461b-af21-54ad7de34872','Penjualan 0226-001 T','2becb525-e406-4588-b481-4cae80f41d92','2026-02-03 23:13:09','2026-02-03 23:13:09'),
('462774f6-b59c-49e0-84ea-b7f71584b65e','e983c109-aae5-4fd0-b010-c56025b09412','0440627b-ef83-43cf-b918-c1a9534c1d3e','OUT',-1,38,37,'SALE','eefe9878-3baf-4c08-a9f8-e4d4a685526f','Penjualan 0126-002 T','40df4d1a-128e-4516-84d6-f17528016378','2026-01-26 14:44:13','2026-01-26 14:44:13'),
('54164278-67b9-44d3-994a-9dd3f0ec5e7b','3b415014-cfd3-4ca8-8f19-137d3d074bda','046212b1-966f-447c-b263-45ad46c3b07a','OUT',-2,22,20,'SALE','8a92cbee-98a8-43f3-902f-808bcec0269b','Penjualan 0226-002 T','2becb525-e406-4588-b481-4cae80f41d92','2026-02-04 01:16:04','2026-02-04 01:16:04'),
('65603244-71d4-44fa-bed4-925ed1b378e8','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','01e2bc19-0464-4599-9076-a2adf7ea3db2','ADJUSTMENT',-1,14,13,'ADJUSTMENT','46ca37d2-936e-4e98-9720-6ffec30692af','LEAKED: Ya bocor lah, bauuu','ca514c50-219f-448c-bf71-70a742f29382','2026-04-02 03:26:00','2026-04-02 03:26:00'),
('66243cd2-ad84-4ede-bae0-12dd7291fc12','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','01e2bc19-0464-4599-9076-a2adf7ea3db2','OUT',-1,17,16,'SALE','ac5d76fb-6449-443f-9f3b-4b07a2c4a04e','Penjualan 0426-003 T','cbf1b57b-be22-4f0b-bce7-65e66d459064','2026-04-02 03:34:07','2026-04-02 03:34:07'),
('7f14ff2d-6a64-4e02-8109-1e1103186501','e983c109-aae5-4fd0-b010-c56025b09412','6c2095d8-cdd7-41c0-8a85-0d4c2ec25f0e','OUT',-1,30,29,'SALE','eefe9878-3baf-4c08-a9f8-e4d4a685526f','Penjualan 0126-002 T','40df4d1a-128e-4516-84d6-f17528016378','2026-01-26 14:44:13','2026-01-26 14:44:13'),
('8d72f360-dfdd-44e4-a3c7-d7418e75346b','e983c109-aae5-4fd0-b010-c56025b09412','c991e6a0-c523-4239-9ceb-5cfd77aa8075','OUT',-1,25,24,'SALE','50a1b1ce-81da-4ba7-b845-b61a4be29a44','Penjualan 0126-003 T','e6202c95-ba5d-44ae-b474-cca92657976c','2026-01-26 15:10:49','2026-01-26 15:10:49'),
('9d94acef-bd21-4bc5-b10e-8d611b0fcdfb','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','01e2bc19-0464-4599-9076-a2adf7ea3db2','OUT',-5,12,7,'SALE','251a3d2a-1ab6-4c93-814a-1ddbbf017608','Penjualan 0426-001 K','ca514c50-219f-448c-bf71-70a742f29382','2026-04-02 03:29:49','2026-04-02 03:29:49'),
('aca003e0-6bbd-4b4b-8a37-a7519459bf5d','e983c109-aae5-4fd0-b010-c56025b09412','a47b4c17-536c-4601-a9eb-b3ae9b1bb211','IN',1,29,30,'PURCHASE','8713d1b2-2243-4451-a904-6a635a366b12','Pembelian dari PT Agak Laen Abadi','e6202c95-ba5d-44ae-b474-cca92657976c','2026-02-04 00:19:50','2026-02-04 00:19:50'),
('b103086d-9b29-4e33-8247-721029f88555','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','01e2bc19-0464-4599-9076-a2adf7ea3db2','OUT',-1,15,14,'SALE','2bc3b6f8-04f4-442a-955b-953f37363eee','Penjualan 0426-001 T','ca514c50-219f-448c-bf71-70a742f29382','2026-04-02 03:25:02','2026-04-02 03:25:02'),
('c4a688c3-b237-4a0b-89ff-e5dd01f18bb2','e983c109-aae5-4fd0-b010-c56025b09412','6c2095d8-cdd7-41c0-8a85-0d4c2ec25f0e','OUT',-1,29,28,'SALE','42c573d3-7fd5-4785-a11a-bf30228e17dc','Penjualan 0126-004 T','e6202c95-ba5d-44ae-b474-cca92657976c','2026-01-26 15:37:40','2026-01-26 15:37:40'),
('ca7241b9-6385-4f94-b1a1-af88c2702839','e983c109-aae5-4fd0-b010-c56025b09412','a47b4c17-536c-4601-a9eb-b3ae9b1bb211','OUT',-1,30,29,'SALE','50a1b1ce-81da-4ba7-b845-b61a4be29a44','Penjualan 0126-003 T','e6202c95-ba5d-44ae-b474-cca92657976c','2026-01-26 15:10:49','2026-01-26 15:10:49'),
('dfc36e15-cfa3-4612-a294-328b5f003291','3b415014-cfd3-4ca8-8f19-137d3d074bda','046212b1-966f-447c-b263-45ad46c3b07a','OUT',-1,19,18,'SALE','0298402d-6269-4f2e-ae15-c77e1e7df19d','Penjualan 0226-004 T','2becb525-e406-4588-b481-4cae80f41d92','2026-02-04 01:24:18','2026-02-04 01:24:18'),
('e7dd53b4-dea8-44ff-9892-8df5416e2e9b','3b415014-cfd3-4ca8-8f19-137d3d074bda','046212b1-966f-447c-b263-45ad46c3b07a','OUT',-1,20,19,'SALE','3128a0c7-ef61-4315-a9c0-b5f918566d96','Penjualan 0226-003 T','2becb525-e406-4588-b481-4cae80f41d92','2026-02-04 01:18:49','2026-02-04 01:18:49'),
('ef8557e5-6686-4dda-8e59-b191a7682c06','2dcc3a4c-a0b2-45dc-8541-57bcfcff89d6','cad61999-cb50-4297-aff8-bc26120c5433','OUT',-1,10,9,'SALE','a2d11478-c623-4d10-98ea-4ad07d36d94f','Penjualan 0226-005 T','3d0b20d9-8053-4727-b5de-7f837b31217b','2026-02-04 02:00:27','2026-02-04 02:00:27');
/*!40000 ALTER TABLE `stock_movements` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `supplier_debts`
--

DROP TABLE IF EXISTS `supplier_debts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `supplier_debts` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `client_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `supplier_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `purchase_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'Referensi ke transaksi pembelian kredit',
  `invoice_number` varchar(50) NOT NULL COMMENT 'Nomor faktur pembelian (copy dari purchase)',
  `total_amount` decimal(15,2) NOT NULL COMMENT 'Total hutang awal',
  `paid_amount` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT 'Total yang sudah dibayar',
  `remaining_amount` decimal(15,2) NOT NULL COMMENT 'Sisa hutang (totalAmount - paidAmount)',
  `due_date` datetime DEFAULT NULL COMMENT 'Tanggal jatuh tempo (jika ada)',
  `status` enum('PENDING','PARTIAL','PAID','OVERDUE') NOT NULL DEFAULT 'PENDING',
  `notes` text DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `supplier_debts_supplier_id` (`supplier_id`),
  KEY `supplier_debts_purchase_id` (`purchase_id`),
  KEY `supplier_debts_invoice_number` (`invoice_number`),
  KEY `supplier_debts_status` (`status`),
  KEY `supplier_debts_due_date` (`due_date`),
  CONSTRAINT `105` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `106` FOREIGN KEY (`purchase_id`) REFERENCES `purchases` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `supplier_debts`
--

LOCK TABLES `supplier_debts` WRITE;
/*!40000 ALTER TABLE `supplier_debts` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `supplier_debts` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `suppliers`
--

DROP TABLE IF EXISTS `suppliers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `suppliers` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `client_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `code` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `contact_person` varchar(100) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `suppliers_client_id_code` (`client_id`,`code`),
  CONSTRAINT `1` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `suppliers`
--

LOCK TABLES `suppliers` WRITE;
/*!40000 ALTER TABLE `suppliers` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `suppliers` VALUES
('01d55113-fb39-4d6c-a777-bc2fef1b759d','e983c109-aae5-4fd0-b010-c56025b09412','SUP-007','CV Tani Makmur','081122334455','tani.makmur@gmail.com','Lembang Asri No. 88, Bandung Barat',1,NULL,NULL,'2026-01-12 23:50:42','2026-01-12 23:50:42'),
('16523d4d-a513-465e-840f-49c8e66f8290','e983c109-aae5-4fd0-b010-c56025b09412','SUP-005','Kerupuk Pasar (Bu Ema)','087712345678',NULL,'Pasar Kosambi Lantai Dasar, Bandung',1,NULL,NULL,'2026-01-12 23:50:42','2026-01-12 23:50:42'),
('354845ab-e35c-4609-961c-7009e426803b','e983c109-aae5-4fd0-b010-c56025b09412','SUP-001','PT Sumber Rezeki Jaya','081234567890','admin@sumberrezeki.com','Jl. Soekarno Hatta No. 123, Bandung',1,NULL,NULL,'2026-01-12 23:50:42','2026-01-12 23:50:42'),
('4f15890d-b296-4901-b98b-d34d226e9311','3b415014-cfd3-4ca8-8f19-137d3d074bda','SUP-001','PT X','0808080808088','yudi@mail.id','Jalan Ahhhhhhhhh',1,NULL,NULL,'2026-02-03 23:11:25','2026-02-03 23:11:25'),
('6caf860c-5dfb-4aa2-815a-473be70e54b8','e983c109-aae5-4fd0-b010-c56025b09412','SUP-006','PT Indo Food Distribusi','021-5556667','distribusi@indofood.co.id','Kawasan Industri Pulo Gadung, Jakarta',1,NULL,NULL,'2026-01-12 23:50:42','2026-01-12 23:50:42'),
('8cf104e1-ab43-466c-938e-e15717968105','e983c109-aae5-4fd0-b010-c56025b09412','SUP-003','UD Barokah Selalu','085678901234','sales@barokahselalu.com','Pasar Induk Caringin Blok A1, Bandung',1,NULL,NULL,'2026-01-12 23:50:42','2026-01-12 23:50:42'),
('9119581c-6e2d-4207-a604-b593db590278','e983c109-aae5-4fd0-b010-c56025b09412','SUP-002','CV Maju Bersama','081987654321','info@majubersama.id','Jl. Jendral Sudirman No. 45, Jakarta',1,NULL,NULL,'2026-01-12 23:50:42','2026-01-12 23:50:42'),
('a13348e6-51f9-42ec-b260-4ae22d4109eb','e983c109-aae5-4fd0-b010-c56025b09412','SUP-004','Toko Roti Keliling (Pak Ujang)','081345678901',NULL,'Jl. Kampung Rambutan, Bandung',1,NULL,NULL,'2026-01-12 23:50:42','2026-01-12 23:50:42'),
('a847e7f6-e062-4558-931c-8c5db0de722d','e983c109-aae5-4fd0-b010-c56025b09412','SUP-008','PT Agak Laen Abadi','0812345678900',NULL,'Jalan Agak Laen No.10',1,NULL,NULL,'2026-01-26 15:45:30','2026-01-26 16:02:33'),
('c3b3f4d7-f63c-4b90-b68c-78f16271342b','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','SUP-001','PT OKE GAS','081234567890',NULL,'Jalan dar der dor no 1',1,NULL,NULL,'2026-04-02 03:23:52','2026-04-02 03:23:52'),
('c803d466-bf6b-483f-823a-3a3bd697b661','2dcc3a4c-a0b2-45dc-8541-57bcfcff89d6','SUP-001','PTX','081234567890','hello@fakhrif.my.id','TTTTTTTTTTTTTTTTTTT',1,NULL,NULL,'2026-02-04 01:58:41','2026-02-04 01:58:41');
/*!40000 ALTER TABLE `suppliers` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `client_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('SUPER_ADMIN','ADMIN','KASIR') NOT NULL DEFAULT 'KASIR',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `last_password_change` datetime DEFAULT NULL,
  `failed_login_attempts` int(11) NOT NULL DEFAULT 0,
  `last_failed_login` datetime DEFAULT NULL,
  `account_locked_until` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_username_unique` (`username`),
  UNIQUE KEY `users_email_unique` (`email`),
  UNIQUE KEY `users_username` (`username`),
  UNIQUE KEY `users_email` (`email`),
  KEY `users_role` (`role`),
  KEY `users_is_active` (`is_active`),
  KEY `client_id` (`client_id`),
  CONSTRAINT `1` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `users` VALUES
('2becb525-e406-4588-b481-4cae80f41d92','3b415014-cfd3-4ca8-8f19-137d3d074bda','AgakLaen','agaklaen@mail.id','Admin Agak Laen','$2a$12$x./kvJ1yMVijdpL5PDxkJOmqOZ02LicrQ.obORlWpEJbdlqY4AgCe','ADMIN',1,'2026-02-03 23:00:20',0,NULL,NULL,'2026-02-03 23:00:20','2026-02-03 23:00:20'),
('3d0b20d9-8053-4727-b5de-7f837b31217b','2dcc3a4c-a0b2-45dc-8541-57bcfcff89d6','makmuAdmin','makmur@mail.id','Makmur Admin','$2a$12$dYEgs4gTeth8Yjl3v0Gh4eE8lmJHdhsu57yb.TRA.bmjpGVUO1N7O','ADMIN',1,'2026-02-04 01:57:54',0,NULL,NULL,'2026-02-04 01:57:54','2026-02-04 01:57:54'),
('40df4d1a-128e-4516-84d6-f17528016378','e983c109-aae5-4fd0-b010-c56025b09412','kasir','kasir@koperasi.com','Kasir Koperasi','$2a$12$JE3in6Ato4lGueusTTAGwOHAkMM4lOvVeR6uhLlwgZuK1lx4uJOUG','KASIR',1,'2026-01-12 23:25:04',0,NULL,NULL,'2026-01-12 23:25:04','2026-01-12 23:25:04'),
('6adbe87d-f1be-43de-903c-e9398263ab2a',NULL,'superadmin','super@saas.com','Super Administrator','$2a$12$JBBbwiZxZsksGwej.YxtB.v5orCmjx0RDU6CZUEKTS3px1atKkiQa','SUPER_ADMIN',1,'2026-01-12 23:25:03',0,NULL,NULL,'2026-01-12 23:25:03','2026-01-12 23:25:03'),
('ca514c50-219f-448c-bf71-70a742f29382','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','SawitAdmin','sawit@gov.id','Admin Koperasi Merah Putih','$2a$12$ifJlJARHAGUHKx54Kyhy/.XIDuCrRx68Kw6gJptB83pW5jDyOfvR.','ADMIN',1,'2026-04-02 03:22:57',0,NULL,NULL,'2026-04-02 03:22:57','2026-04-02 03:22:57'),
('cbf1b57b-be22-4f0b-bce7-65e66d459064','e4bc6e89-17d8-4b5d-ae7f-31263c57fa57','fufufafa',NULL,'Fufufafa','$2a$12$iuBg0JWv3DaAscGDptqSGePRk.aIS8AySwooZ3EedOCvkfd/chgyy','KASIR',1,'2026-04-02 03:32:39',0,NULL,NULL,'2026-04-02 03:32:38','2026-04-02 03:32:38'),
('e6202c95-ba5d-44ae-b474-cca92657976c','e983c109-aae5-4fd0-b010-c56025b09412','admin','admin@koperasi.com','Admin Koperasi','$2a$12$0dfNQRQBY6bOz92O8ifzL.xUnN7N1xtqsOSHf1BELMQpwfB8h9o6S','ADMIN',1,'2026-02-04 01:41:59',0,NULL,NULL,'2026-01-12 23:25:03','2026-02-04 01:41:59'),
('f13c1118-7654-43db-97b7-9a5777ff25e3','3b415014-cfd3-4ca8-8f19-137d3d074bda','kasirLaen','kasir@kasir.my.id','HexWhite','$2a$12$.DeHuXMNI.YCWjoV3bOq1OUVG9HUc/s31FeWhTUiF0A4bQ61brhu2','KASIR',1,'2026-02-04 01:56:28',0,NULL,NULL,'2026-02-04 01:56:28','2026-02-04 01:56:28');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
commit;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2026-04-13 16:33:42
