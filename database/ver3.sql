SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+07:00";
SET FOREIGN_KEY_CHECKS = 0;

-- ==========================================
-- 1. BERSIH-BERSIH TOTAL (HAPUS TABEL LAMA)
-- ==========================================
DROP TABLE IF EXISTS `purchase_return_items`;
DROP TABLE IF EXISTS `purchase_returns`;
DROP TABLE IF EXISTS `point_transactions`;
DROP TABLE IF EXISTS `stock_adjustments`;
DROP TABLE IF EXISTS `sales_return_items`;
DROP TABLE IF EXISTS `sales_returns`;
DROP TABLE IF EXISTS `supplier_debts`;
DROP TABLE IF EXISTS `debt_payments`;
DROP TABLE IF EXISTS `member_debts`;
DROP TABLE IF EXISTS `purchase_items`;
DROP TABLE IF EXISTS `purchases`;
DROP TABLE IF EXISTS `settings`;
DROP TABLE IF EXISTS `stock_movements`;
DROP TABLE IF EXISTS `sale_items`;
DROP TABLE IF EXISTS `sales`;
DROP TABLE IF EXISTS `members`;
DROP TABLE IF EXISTS `products`;
DROP TABLE IF EXISTS `suppliers`;
DROP TABLE IF EXISTS `categories`;
DROP TABLE IF EXISTS `users`;
DROP TABLE IF EXISTS `clients`;

-- ==========================================
-- 2. SYSTEM CORE
-- ==========================================
CREATE TABLE `clients` (
  `id` char(36) BINARY NOT NULL,
  `code` varchar(20) NOT NULL,
  `business_name` varchar(100) NOT NULL,
  `owner_name` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `status` varchar(20) DEFAULT 'ACTIVE',
  `subscription_plan` varchar(20) DEFAULT 'FREE',
  `subscription_end` datetime DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_client_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `users` (
  `id` char(36) BINARY NOT NULL,
  `client_id` char(36) BINARY NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `name` varchar(100) NOT NULL,
  `role` varchar(20) DEFAULT 'CASHIER',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `last_login` datetime DEFAULT NULL,
  `last_password_change` datetime DEFAULT NULL,
  `failed_login_attempts` int DEFAULT 0,
  `last_failed_login` datetime DEFAULT NULL,
  `account_locked_until` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_users_client` (`client_id`),
  CONSTRAINT `fk_users_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `settings` (
  `id` char(36) BINARY NOT NULL,
  `client_id` char(36) BINARY NOT NULL,
  `key` varchar(100) NOT NULL,
  `value` text DEFAULT NULL,
  `type` enum('TEXT','NUMBER','BOOLEAN','JSON') DEFAULT 'TEXT',
  `group` varchar(50) DEFAULT 'GENERAL',
  `description` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_setting_per_client` (`client_id`, `key`),
  CONSTRAINT `fk_settings_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ==========================================
-- 3. MASTER DATA
-- ==========================================
CREATE TABLE `categories` (
  `id` char(36) BINARY NOT NULL,
  `client_id` char(36) BINARY NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_categories_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `suppliers` (
  `id` char(36) BINARY NOT NULL,
  `client_id` char(36) BINARY NOT NULL,
  `code` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `contact_person` varchar(100) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `total_debt` decimal(15,2) DEFAULT 0.00,
  `total_purchases` int(11) DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_suppliers_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `products` (
  `id` char(36) BINARY NOT NULL,
  `client_id` char(36) BINARY NOT NULL,
  `category_id` char(36) BINARY NOT NULL,
  `supplier_id` char(36) BINARY DEFAULT NULL,
  `barcode` varchar(50) DEFAULT NULL,
  `sku` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `purchase_price` decimal(15,2) NOT NULL DEFAULT 0.00,
  `selling_price` decimal(15,2) NOT NULL DEFAULT 0.00,
  `selling_price_general` decimal(15,2) DEFAULT 0.00,
  `selling_price_member` decimal(15,2) DEFAULT 0.00,
  `product_type` varchar(20) DEFAULT 'Tunai',
  `purchase_type` varchar(20) DEFAULT 'TUNAI',
  `stock` int(11) NOT NULL DEFAULT 0,
  `min_stock` int(11) NOT NULL DEFAULT 0,
  `max_stock` int(11) NOT NULL DEFAULT 0,
  `unit` varchar(20) NOT NULL DEFAULT 'PCS',
  `points` decimal(10,2) DEFAULT 0.00,
  `image` varchar(255) DEFAULT NULL,
  `invoice_no` varchar(50) DEFAULT NULL,
  `expiry_date` datetime DEFAULT NULL,
  `description` text,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_sku_per_client` (`client_id`, `sku`),
  CONSTRAINT `fk_products_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_products_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`),
  CONSTRAINT `fk_products_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `members` (
  `id` char(36) BINARY NOT NULL,
  `client_id` char(36) BINARY NOT NULL,
  `unique_id` varchar(20) NOT NULL,
  `nik` varchar(16) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `whatsapp` varchar(15) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `region_code` varchar(5) DEFAULT NULL,
  `region_name` varchar(50) DEFAULT NULL,
  `gender` varchar(20) DEFAULT NULL,
  `total_points` int(11) NOT NULL DEFAULT 0,
  `total_debt` decimal(15,2) DEFAULT 0.00,
  `total_transactions` int DEFAULT 0,
  `monthly_spending` decimal(15,2) DEFAULT 0.00,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_member_id_per_client` (`client_id`, `unique_id`),
  CONSTRAINT `fk_members_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ==========================================
-- 4. TRANSAKSI UTAMA
-- ==========================================
CREATE TABLE `sales` (
  `id` char(36) BINARY NOT NULL,
  `client_id` char(36) BINARY NOT NULL,
  `user_id` char(36) BINARY NOT NULL,
  `member_id` char(36) BINARY DEFAULT NULL,
  `invoice_number` varchar(50) NOT NULL,
  `sale_date` datetime NOT NULL,
  `sale_type` varchar(20) DEFAULT 'TUNAI',
  `total_amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `discount_amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `discount_percentage` decimal(5,2) DEFAULT 0.00,
  `final_amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `payment_received` decimal(15,2) DEFAULT 0.00,
  `change_amount` decimal(15,2) DEFAULT 0.00,
  `dp_amount` decimal(15,2) DEFAULT 0.00,
  `remaining_debt` decimal(15,2) DEFAULT 0.00,
  `due_date` datetime DEFAULT NULL,
  `status` varchar(20) DEFAULT 'PAID',
  `notes` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_invoice_per_client` (`client_id`, `invoice_number`),
  CONSTRAINT `fk_sales_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_sales_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_sales_member` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `sale_items` (
  `id` char(36) BINARY NOT NULL,
  `client_id` char(36) BINARY NOT NULL,
  `sale_id` char(36) BINARY NOT NULL,
  `product_id` char(36) BINARY NOT NULL,
  `product_name` varchar(100) NOT NULL,
  `quantity` int(11) NOT NULL,
  `unit` varchar(20) DEFAULT NULL,
  `selling_price` decimal(15,2) NOT NULL,
  `subtotal` decimal(15,2) NOT NULL,
  `points_earned` int DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_sale_items_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_sale_items_sale` FOREIGN KEY (`sale_id`) REFERENCES `sales` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_sale_items_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `stock_movements` (
  `id` char(36) BINARY NOT NULL,
  `client_id` char(36) BINARY NOT NULL,
  `product_id` char(36) BINARY NOT NULL,
  `type` varchar(20) NOT NULL,
  `quantity` int(11) NOT NULL,
  `quantity_before` int(11) NOT NULL,
  `quantity_after` int(11) NOT NULL,
  `reference_type` varchar(50) DEFAULT NULL,
  `reference_id` char(36) BINARY DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_by` char(36) BINARY DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_stock_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_stock_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `purchases` (
  `id` char(36) BINARY NOT NULL,
  `client_id` char(36) BINARY NOT NULL,
  `supplier_id` char(36) BINARY NOT NULL,
  `user_id` char(36) BINARY NOT NULL,
  `invoice_number` varchar(50) NOT NULL,
  `purchase_date` datetime NOT NULL,
  `purchase_type` varchar(20) DEFAULT 'TUNAI',
  `total_amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `paid_amount` decimal(15,2) DEFAULT 0.00,
  `remaining_debt` decimal(15,2) DEFAULT 0.00,
  `due_date` datetime DEFAULT NULL,
  `status` varchar(20) DEFAULT 'PENDING',
  `notes` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_purchases_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_purchases_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`),
  CONSTRAINT `fk_purchases_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `purchase_items` (
  `id` char(36) BINARY NOT NULL,
  `purchase_id` char(36) BINARY NOT NULL,
  `product_id` char(36) BINARY NOT NULL,
  `quantity` int(11) NOT NULL,
  `purchase_price` decimal(15,2) NOT NULL,
  `subtotal` decimal(15,2) NOT NULL,
  `exp_date` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_p_items_purchase` FOREIGN KEY (`purchase_id`) REFERENCES `purchases` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_p_items_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ==========================================
-- 5. KEUANGAN & RETUR
-- ==========================================
CREATE TABLE `member_debts` (
  `id` char(36) BINARY NOT NULL,
  `client_id` char(36) BINARY NOT NULL,
  `member_id` char(36) BINARY NOT NULL,
  `sale_id` char(36) BINARY NOT NULL,
  `invoice_number` varchar(50) NOT NULL,
  `total_amount` decimal(15,2) NOT NULL,
  `paid_amount` decimal(15,2) DEFAULT 0.00,
  `remaining_amount` decimal(15,2) NOT NULL,
  `due_date` datetime DEFAULT NULL,
  `status` varchar(20) DEFAULT 'PENDING',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_m_debts_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_m_debts_member` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`),
  CONSTRAINT `fk_m_debts_sale` FOREIGN KEY (`sale_id`) REFERENCES `sales` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `debt_payments` (
  `id` char(36) BINARY NOT NULL,
  `client_id` char(36) BINARY NOT NULL,
  `member_debt_id` char(36) BINARY NOT NULL,
  `user_id` char(36) BINARY NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `payment_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `payment_method` varchar(20) DEFAULT 'CASH',
  `notes` text,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_pay_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_pay_debt` FOREIGN KEY (`member_debt_id`) REFERENCES `member_debts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `supplier_debts` (
  `id` char(36) BINARY NOT NULL,
  `client_id` char(36) BINARY NOT NULL,
  `supplier_id` char(36) BINARY NOT NULL,
  `purchase_id` char(36) BINARY NOT NULL,
  `invoice_number` varchar(50) DEFAULT NULL,
  `amount` decimal(15,2) NOT NULL,
  `paid_amount` decimal(15,2) DEFAULT 0.00,
  `due_date` datetime DEFAULT NULL,
  `status` varchar(20) DEFAULT 'UNPAID',
  `notes` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_s_debts_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_s_debts_purch` FOREIGN KEY (`purchase_id`) REFERENCES `purchases` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `sales_returns` (
  `id` char(36) BINARY NOT NULL,
  `client_id` char(36) BINARY NOT NULL,
  `sale_id` char(36) BINARY NOT NULL,
  `user_id` char(36) BINARY NOT NULL,
  `member_id` char(36) BINARY DEFAULT NULL,
  `return_number` varchar(50) NOT NULL,
  `return_date` datetime NOT NULL,
  `total_refund` decimal(15,2) NOT NULL,
  `reason` text NOT NULL,
  `status` varchar(20) DEFAULT 'PENDING',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_ret_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_ret_sale` FOREIGN KEY (`sale_id`) REFERENCES `sales` (`id`),
  CONSTRAINT `fk_ret_member` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `sales_return_items` (
  `id` char(36) BINARY NOT NULL,
  `sales_return_id` char(36) BINARY NOT NULL,
  `product_id` char(36) BINARY NOT NULL,
  `quantity` int(11) NOT NULL,
  `refund_amount` decimal(15,2) NOT NULL,
  `condition` varchar(20) DEFAULT 'GOOD',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_ret_items_parent` FOREIGN KEY (`sales_return_id`) REFERENCES `sales_returns` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_ret_items_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `stock_adjustments` (
  `id` char(36) BINARY NOT NULL,
  `client_id` char(36) BINARY NOT NULL,
  `product_id` char(36) BINARY NOT NULL,
  `user_id` char(36) BINARY NOT NULL,
  `adjustment_number` varchar(50) NOT NULL,
  `adjustment_type` varchar(20) NOT NULL,
  `quantity` int(11) NOT NULL,
  `reason` text NOT NULL,
  `adjustment_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(20) DEFAULT 'APPROVED',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_adj_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_adj_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `point_transactions` (
  `id` char(36) BINARY NOT NULL,
  `client_id` char(36) BINARY NOT NULL,
  `member_id` char(36) BINARY NOT NULL,
  `sale_id` char(36) BINARY DEFAULT NULL,
  `type` varchar(20) NOT NULL,
  `points` int(11) NOT NULL,
  `points_before` int(11) NOT NULL,
  `points_after` int(11) NOT NULL,
  `description` text DEFAULT NULL,
  `expiry_date` datetime DEFAULT NULL,
  `is_expired` tinyint(1) DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_pt_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_pt_member` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `purchase_returns` (
  `id` char(36) BINARY NOT NULL,
  `client_id` char(36) BINARY NOT NULL,
  `purchase_id` char(36) BINARY NOT NULL,
  `supplier_id` char(36) BINARY NOT NULL,
  `user_id` char(36) BINARY NOT NULL,
  `return_number` varchar(50) NOT NULL,
  `return_date` datetime NOT NULL,
  `total_amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `reason` text NOT NULL,
  `status` varchar(20) DEFAULT 'PENDING',
  `notes` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_pret_client` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_pret_purchase` FOREIGN KEY (`purchase_id`) REFERENCES `purchases` (`id`),
  CONSTRAINT `fk_pret_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`),
  CONSTRAINT `fk_pret_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `purchase_return_items` (
  `id` char(36) BINARY NOT NULL,
  `purchase_return_id` char(36) BINARY NOT NULL,
  `product_id` char(36) BINARY NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` decimal(15,2) NOT NULL,
  `subtotal` decimal(15,2) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_pret_items_parent` FOREIGN KEY (`purchase_return_id`) REFERENCES `purchase_returns` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_pret_items_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SET FOREIGN_KEY_CHECKS = 1;
COMMIT;
