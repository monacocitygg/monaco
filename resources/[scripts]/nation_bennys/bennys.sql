CREATE TABLE IF NOT EXISTS `bennys_orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` varchar(50) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `vehicle_name` varchar(50) DEFAULT NULL,
  `plate` varchar(50) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `mods` longtext,
  `name` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
