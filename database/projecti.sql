SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+07:00";

-- ==========================================
-- 1. TABLE UTAMA: CLIENTS (Penyewa SaaS)
-- ==========================================
CREATE TABLE `clients` (
  `id` char(36) NOT NULL,
  `code` varchar(20) NOT NULL COMMENT 'Kode unik toko (misal: TOKO-A, TOKO-B)',
  `business_name` varchar(100) NOT NULL,
  `owner_name` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `status` enum('ACTIVE', 'SUSPENDED', 'INACTIVE') DEFAULT 'ACTIVE',
  `subscription_plan` enum('FREE', 'BASIC', 'PREMIUM') DEFAULT 'FREE',
  `subscription_end` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_client_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==========================================
-- 2. TABLE USERS (Super Admin & Staff Toko)
-- ==========================================
CREATE TABLE `users` (
  `id` char(36) NOT NULL,
  `client_id` char(36) DEFAULT NULL COMMENT 'NULL = Super Admin, Terisi = Staff Toko',
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `name` varchar(100) NOT NULL,
  `role` enum('SUPER_ADMIN', 'ADMIN', 'KASIR') NOT NULL DEFAULT 'KASIR',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `last_login` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`), -- Email tetap unik global untuk login
  UNIQUE KEY `unique_username_per_client` (`client_id`, `username`), -- Username boleh sama asal beda toko
  CONSTRAINT `fk_users_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==========================================
-- 3. MASTER DATA (Produk, Kategori, Member)
-- ==========================================

CREATE TABLE `categories` (
  `id` char(36) NOT NULL,
  `client_id` char(36) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_categories_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `suppliers` (
  `id` char(36) NOT NULL,
  `client_id` char(36) NOT NULL,
  `code` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_supplier_code_per_client` (`client_id`, `code`),
  CONSTRAINT `fk_suppliers_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `products` (
  `id` char(36) NOT NULL,
  `client_id` char(36) NOT NULL,
  `category_id` char(36) NOT NULL,
  `supplier_id` char(36) DEFAULT NULL,
  `barcode` varchar(50) DEFAULT NULL,
  `sku` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `purchase_price` decimal(15,2) NOT NULL DEFAULT 0.00,
  `selling_price` decimal(15,2) NOT NULL DEFAULT 0.00,
  `stock` int(11) NOT NULL DEFAULT 0,
  `min_stock` int(11) NOT NULL DEFAULT 0,
  `unit` varchar(20) NOT NULL DEFAULT 'PCS',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  -- LOGIKA SAAS: Barcode/SKU boleh kembar asalkan beda Client ID
  UNIQUE KEY `unique_barcode_per_client` (`client_id`, `barcode`),
  UNIQUE KEY `unique_sku_per_client` (`client_id`, `sku`),
  KEY `idx_products_client` (`client_id`), -- Index biar query cepat
  CONSTRAINT `fk_products_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_products_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_products_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `members` (
  `id` char(36) NOT NULL,
  `client_id` char(36) NOT NULL,
  `unique_id` varchar(20) NOT NULL COMMENT 'No Anggota',
  `nik` varchar(16) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `address` varchar(255) NOT NULL,
  `total_points` int(11) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  -- LOGIKA SAAS: NIK/No Anggota boleh sama kalau beda Client
  UNIQUE KEY `unique_nik_per_client` (`client_id`, `nik`),
  UNIQUE KEY `unique_member_id_per_client` (`client_id`, `unique_id`),
  CONSTRAINT `fk_members_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==========================================
-- 4. TRANSAKSI (Sales, Purchases, Stocks)
-- ==========================================

CREATE TABLE `sales` (
  `id` char(36) NOT NULL,
  `client_id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL COMMENT 'Kasir',
  `member_id` char(36) DEFAULT NULL,
  `invoice_number` varchar(50) NOT NULL,
  `sale_date` datetime NOT NULL,
  `total_amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `discount_amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `final_amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `payment_method` enum('CASH', 'TRANSFER', 'QRIS', 'DEBT') NOT NULL DEFAULT 'CASH',
  `status` enum('PENDING', 'PAID', 'CANCELLED') NOT NULL DEFAULT 'PAID',
  `notes` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_invoice_per_client` (`client_id`, `invoice_number`),
  KEY `idx_sales_client_date` (`client_id`, `sale_date`), -- Index untuk laporan
  CONSTRAINT `fk_sales_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_sales_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_sales_member` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `sale_items` (
  `id` char(36) NOT NULL,
  `sale_id` char(36) NOT NULL,
  `product_id` char(36) NOT NULL,
  `product_name_snapshot` varchar(100) NOT NULL COMMENT 'Nama produk saat transaksi (jaga-jaga kalau master berubah)',
  `quantity` int(11) NOT NULL,
  `price_snapshot` decimal(15,2) NOT NULL COMMENT 'Harga saat transaksi',
  `subtotal` decimal(15,2) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_sale_items_sale` FOREIGN KEY (`sale_id`) REFERENCES `sales` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_sale_items_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `stock_movements` (
  `id` char(36) NOT NULL,
  `client_id` char(36) NOT NULL,
  `product_id` char(36) NOT NULL,
  `type` enum('IN', 'OUT', 'ADJUSTMENT') NOT NULL,
  `quantity` int(11) NOT NULL,
  `reference_id` char(36) DEFAULT NULL COMMENT 'ID Sale atau Purchase',
  `notes` text DEFAULT NULL,
  `created_by` char(36) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_stock_client` (`client_id`),
  CONSTRAINT `fk_stock_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_stock_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==========================================
-- 5. CONFIGURATION
-- ==========================================

CREATE TABLE `settings` (
  `id` char(36) NOT NULL,
  `client_id` char(36) NOT NULL,
  `key` varchar(50) NOT NULL COMMENT 'misal: PRINTER_NAME, TAX_RATE',
  `value` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_setting_per_client` (`client_id`, `key`),
  CONSTRAINT `fk_settings_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ==========================================
-- 6. PURCHASING (Pembelian ke Supplier)
-- ==========================================

CREATE TABLE `purchases` (
  `id` char(36) NOT NULL,
  `client_id` char(36) NOT NULL,
  `supplier_id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL COMMENT 'Staff yang input',
  `invoice_number` varchar(50) NOT NULL COMMENT 'No Faktur dari Supplier',
  `purchase_date` datetime NOT NULL,
  `purchase_type` enum('TUNAI', 'KREDIT', 'KONSINYASI') NOT NULL DEFAULT 'TUNAI',
  `total_amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `paid_amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `remaining_debt` decimal(15,2) NOT NULL DEFAULT 0.00,
  `due_date` datetime DEFAULT NULL,
  `status` enum('PENDING', 'PARTIAL', 'PAID', 'CANCELLED') NOT NULL DEFAULT 'PENDING',
  `notes` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_purchases_client_date` (`client_id`, `purchase_date`),
  CONSTRAINT `fk_purchases_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_purchases_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`),
  CONSTRAINT `fk_purchases_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `purchase_items` (
  `id` char(36) NOT NULL,
  `purchase_id` char(36) NOT NULL,
  `product_id` char(36) NOT NULL,
  `quantity` int(11) NOT NULL,
  `purchase_price` decimal(15,2) NOT NULL,
  `subtotal` decimal(15,2) NOT NULL,
  `exp_date` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_purchase_items_purchase` FOREIGN KEY (`purchase_id`) REFERENCES `purchases` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_purchase_items_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==========================================
-- 7. DEBTS & RECEIVABLES (Hutang Piutang)
-- ==========================================

-- A. Kasbon Member (Piutang Koperasi)
CREATE TABLE `member_debts` (
  `id` char(36) NOT NULL,
  `client_id` char(36) NOT NULL,
  `member_id` char(36) NOT NULL,
  `sale_id` char(36) NOT NULL,
  `total_amount` decimal(15,2) NOT NULL,
  `paid_amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `remaining_amount` decimal(15,2) NOT NULL,
  `due_date` datetime NOT NULL,
  `status` enum('UNPAID', 'PARTIAL', 'PAID', 'OVERDUE') NOT NULL DEFAULT 'UNPAID',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_member_debts_client` (`client_id`, `status`),
  CONSTRAINT `fk_m_debts_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_m_debts_member` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`),
  CONSTRAINT `fk_m_debts_sale` FOREIGN KEY (`sale_id`) REFERENCES `sales` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- B. Riwayat Bayar Cicilan Member
CREATE TABLE `debt_payments` (
  `id` char(36) NOT NULL,
  `client_id` char(36) NOT NULL,
  `member_debt_id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL COMMENT 'Penerima Pembayaran',
  `amount` decimal(15,2) NOT NULL,
  `payment_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `payment_method` enum('CASH', 'TRANSFER') NOT NULL DEFAULT 'CASH',
  `notes` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_payments_client` (`client_id`),
  CONSTRAINT `fk_pay_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_pay_debt` FOREIGN KEY (`member_debt_id`) REFERENCES `member_debts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- C. Hutang ke Supplier (Opsional, tapi ada di SQL lamamu)
CREATE TABLE `supplier_debts` (
  `id` char(36) NOT NULL,
  `client_id` char(36) NOT NULL,
  `supplier_id` char(36) NOT NULL,
  `purchase_id` char(36) NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `paid_amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `status` enum('UNPAID', 'PARTIAL', 'PAID') NOT NULL DEFAULT 'UNPAID',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_s_debts_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_s_debts_purch` FOREIGN KEY (`purchase_id`) REFERENCES `purchases` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==========================================
-- 8. RETURNS & ADJUSTMENTS
-- ==========================================

CREATE TABLE `sales_returns` (
  `id` char(36) NOT NULL,
  `client_id` char(36) NOT NULL,
  `sale_id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `return_number` varchar(50) NOT NULL,
  `return_date` datetime NOT NULL,
  `total_refund` decimal(15,2) NOT NULL,
  `reason` text NOT NULL,
  `status` enum('PENDING', 'APPROVED', 'REJECTED') NOT NULL DEFAULT 'PENDING',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_return_no_client` (`client_id`, `return_number`),
  CONSTRAINT `fk_ret_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_ret_sale` FOREIGN KEY (`sale_id`) REFERENCES `sales` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `sales_return_items` (
  `id` char(36) NOT NULL,
  `sales_return_id` char(36) NOT NULL,
  `product_id` char(36) NOT NULL,
  `quantity` int(11) NOT NULL,
  `refund_amount` decimal(15,2) NOT NULL,
  `condition` enum('GOOD', 'DAMAGED') NOT NULL DEFAULT 'GOOD',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_ret_items_parent` FOREIGN KEY (`sales_return_id`) REFERENCES `sales_returns` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Stock Adjustment (Opname Manual: Barang Hilang/Rusak/Ketemu)
CREATE TABLE `stock_adjustments` (
  `id` char(36) NOT NULL,
  `client_id` char(36) NOT NULL,
  `product_id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `adjustment_type` enum('DAMAGED', 'EXPIRED', 'LOST', 'FOUND', 'CORRECTION') NOT NULL,
  `quantity` int(11) NOT NULL COMMENT 'Negatif jika hilang, Positif jika ketemu',
  `reason` text NOT NULL,
  `adjustment_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('PENDING', 'APPROVED') NOT NULL DEFAULT 'APPROVED',
  PRIMARY KEY (`id`),
  KEY `idx_adj_client` (`client_id`),
  CONSTRAINT `fk_adj_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_adj_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==========================================
-- 9. POINT HISTORY
-- ==========================================

CREATE TABLE `point_transactions` (
  `id` char(36) NOT NULL,
  `client_id` char(36) NOT NULL,
  `member_id` char(36) NOT NULL,
  `sale_id` char(36) DEFAULT NULL COMMENT 'Null jika penambahan manual/hadiah',
  `type` enum('EARN', 'REDEEM', 'EXPIRED', 'ADJUSTMENT') NOT NULL,
  `points` int(11) NOT NULL COMMENT 'Positif nambah, Negatif kurang',
  `points_balance_after` int(11) NOT NULL COMMENT 'Saldo akhir setelah transaksi',
  `description` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_points_client_member` (`client_id`, `member_id`),
  CONSTRAINT `fk_points_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_points_member` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==========================================
-- 10. PURCHASE RETURNS (Retur ke Supplier)
-- ==========================================

CREATE TABLE `purchase_returns` (
  `id` char(36) NOT NULL,
  `client_id` char(36) NOT NULL,
  `purchase_id` char(36) NOT NULL,
  `supplier_id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `return_number` varchar(50) NOT NULL COMMENT 'No Retur (Auto Generate)',
  `return_date` datetime NOT NULL,
  `total_amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `reason` text NOT NULL,
  `status` enum('PENDING', 'APPROVED', 'REJECTED') NOT NULL DEFAULT 'PENDING',
  `notes` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_purch_return_client` (`client_id`, `return_number`),
  CONSTRAINT `fk_pret_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_pret_purchase` FOREIGN KEY (`purchase_id`) REFERENCES `purchases` (`id`),
  CONSTRAINT `fk_pret_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`),
  CONSTRAINT `fk_pret_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `purchase_return_items` (
  `id` char(36) NOT NULL,
  `purchase_return_id` char(36) NOT NULL,
  `product_id` char(36) NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` decimal(15,2) NOT NULL COMMENT 'Harga beli saat itu',
  `subtotal` decimal(15,2) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_pret_items_parent` FOREIGN KEY (`purchase_return_id`) REFERENCES `purchase_returns` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_pret_items_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


ALTER TABLE `users`
ADD COLUMN `last_password_change` DATETIME DEFAULT NULL,
ADD COLUMN `failed_login_attempts` INT DEFAULT 0,
ADD COLUMN `last_failed_login` DATETIME DEFAULT NULL,
ADD COLUMN `account_locked_until` DATETIME DEFAULT NULL;

ALTER TABLE `settings`
ADD COLUMN `type` ENUM('TEXT','NUMBER','BOOLEAN','JSON') NOT NULL DEFAULT 'TEXT' AFTER `value`,
ADD COLUMN `group` VARCHAR(50) NOT NULL DEFAULT 'GENERAL' AFTER `type`,
ADD COLUMN `description` VARCHAR(255) DEFAULT NULL AFTER `group`;

ALTER TABLE `settings` DROP FOREIGN KEY `fk_settings_client`;
SET FOREIGN_KEY_CHECKS = 0;

-- Hapus Tabel Transaksi & Detail
DROP TABLE IF EXISTS `debt_payments`;
DROP TABLE IF EXISTS `member_debts`;
DROP TABLE IF EXISTS `supplier_debts`;
DROP TABLE IF EXISTS `point_transactions`;
DROP TABLE IF EXISTS `stock_movements`;
DROP TABLE IF EXISTS `stock_adjustments`;
DROP TABLE IF EXISTS `sales_return_items`;
DROP TABLE IF EXISTS `sales_returns`;
DROP TABLE IF EXISTS `purchase_return_items`;
DROP TABLE IF EXISTS `purchase_returns`;
DROP TABLE IF EXISTS `sale_items`;
DROP TABLE IF EXISTS `sales`;
DROP TABLE IF EXISTS `purchase_items`;
DROP TABLE IF EXISTS `purchases`;

-- Hapus Tabel Master Data
DROP TABLE IF EXISTS `products`;
DROP TABLE IF EXISTS `categories`;
DROP TABLE IF EXISTS `suppliers`;
DROP TABLE IF EXISTS `members`;
DROP TABLE IF EXISTS `settings`;
DROP TABLE IF EXISTS `users`;
DROP TABLE IF EXISTS `clients`;

SET FOREIGN_KEY_CHECKS = 1;

COMMIT;
