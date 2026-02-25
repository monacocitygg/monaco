CREATE DATABASE IF NOT EXISTS `hiddenAnticheat`;
USE `hiddenAnticheat`;

CREATE TABLE IF NOT EXISTS `bans` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT DEFAULT 0,
    `steam` VARCHAR(50) DEFAULT NULL,
    `discord` VARCHAR(50) DEFAULT NULL,
    `license` VARCHAR(50) DEFAULT NULL,
    `license2` VARCHAR(50) DEFAULT NULL,
    `xbl` VARCHAR(50) DEFAULT NULL,
    `live` VARCHAR(50) DEFAULT NULL,
    `fivem` VARCHAR(50) DEFAULT NULL,
    `ip` VARCHAR(50) DEFAULT NULL,
    `reason` VARCHAR(255) NOT NULL,
    `banned_by` VARCHAR(50) DEFAULT 'Anticheat',
    `ban_date` BIGINT NOT NULL,
    INDEX `idx_identifiers` (`steam`, `discord`, `license`, `ip`)
);
