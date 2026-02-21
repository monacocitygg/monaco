CREATE TABLE IF NOT EXISTS `hypex_farm` (
  `Org` varchar(50) DEFAULT NULL,
  `Lvl` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT IGNORE INTO `hypex_farm` (`Org`, `Lvl`) VALUES
	('Favela01', 1), 
	('Favela02', 1),
	('Vanilla', 1),
	('Favela03', 1),
	('Favela04', 1),
	('Favela05', 1), 
	('Attachs01', 1),
	('Lavagem01', 1),
	('Famillies', 1),
	('Mafia', 1),
	('Razors', 1),
	('Triads', 1),
	('Lavagem', 1);