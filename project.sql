-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Oct 27, 2017 at 08:50 PM
-- Server version: 5.7.19
-- PHP Version: 5.6.31

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `project`
--

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `GetToolsByCategory`$$
CREATE PROCEDURE `GetToolsByCategory` (IN `category` VARCHAR(80))  SELECT t.`name`, t.`caption`, t.`info`, t.`icon`, t.`url`, t.`size`, cc.`color` AS 'color' 
FROM `tool` AS t 
	LEFT JOIN `CategoryColor` AS cc
		ON cc.`category`=t.`category` AND cc.`size`=t.`size`
WHERE t.`category`=category ORDER BY t.`size` DESC$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `account`
--

DROP TABLE IF EXISTS `account`;
CREATE TABLE IF NOT EXISTS `account` (
  `username` varchar(80) NOT NULL,
  `password` varchar(64) NOT NULL,
  `registered` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `account`
--

INSERT INTO `account` (`username`, `password`, `registered`) VALUES
('admin', '$2y$10$qGndyrlC7ZZCNin/VEnLfuGYqCkui4nuHkErCFnLBQrFGiQmH9JIG', '2017-10-24 19:46:09'),
('kristopher', '$2y$10$WI685onHxnCDeYin1bc5L.TUJ2WEY.dPfoBCirMCv/Qeoz3f2o1Q.', '2017-10-24 19:46:37');

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
CREATE TABLE IF NOT EXISTS `category` (
  `name` varchar(80) NOT NULL,
  `sortorder` tinyint(3) NOT NULL DEFAULT '0',
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`name`, `sortorder`) VALUES
('Create', 2),
('Imagine', 0),
('Plan', 1),
('Program', 3),
('Share', 4);

-- --------------------------------------------------------

--
-- Table structure for table `categorycolor`
--

DROP TABLE IF EXISTS `categorycolor`;
CREATE TABLE IF NOT EXISTS `categorycolor` (
  `category` varchar(80) NOT NULL,
  `size` varchar(12) NOT NULL,
  `color` varchar(8) DEFAULT NULL,
  PRIMARY KEY (`category`,`size`),
  KEY `size` (`size`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `categorycolor`
--

INSERT INTO `categorycolor` (`category`, `size`, `color`) VALUES
('Create', 'tile-small', '00cc00'),
('Create', 'tile-square', '00FF00'),
('Create', 'tile-wide', '33ff33'),
('Imagine', 'tile-small', 'ff00ff'),
('Imagine', 'tile-square', 'ff33ff'),
('Imagine', 'tile-wide', 'ff66ff'),
('Plan', 'tile-small', 'ff9900'),
('Plan', 'tile-square', 'ffad33'),
('Plan', 'tile-wide', 'ffc266'),
('Program', 'tile-small', '3333ff'),
('Program', 'tile-square', '6666ff'),
('Program', 'tile-wide', '9999ff'),
('Share', 'tile-small', 'ff3333'),
('Share', 'tile-square', 'ff6666'),
('Share', 'tile-wide', 'ff9999');

-- --------------------------------------------------------

--
-- Stand-in structure for view `categoryview`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `categoryview`;
CREATE TABLE IF NOT EXISTS `categoryview` (
`category` varchar(80)
);

-- --------------------------------------------------------

--
-- Table structure for table `size`
--

DROP TABLE IF EXISTS `size`;
CREATE TABLE IF NOT EXISTS `size` (
  `name` varchar(12) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `size`
--

INSERT INTO `size` (`name`) VALUES
('tile-small'),
('tile-square'),
('tile-wide');

-- --------------------------------------------------------

--
-- Table structure for table `tool`
--

DROP TABLE IF EXISTS `tool`;
CREATE TABLE IF NOT EXISTS `tool` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  `caption` varchar(120) NOT NULL,
  `info` text NOT NULL,
  `icon` text NOT NULL,
  `url` text NOT NULL,
  `size` varchar(12) DEFAULT NULL,
  `category` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `name` (`name`),
  KEY `category` (`category`),
  KEY `size` (`size`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tool`
--

INSERT INTO `tool` (`ID`, `name`, `caption`, `info`, `icon`, `url`, `size`, `category`) VALUES
(2, 'Google Drive', 'Caption deluxe!', 'google-drive-help.php', 'google-drive-logo-flat.png', 'https://drive.google.com', 'tile-wide', 'Imagine'),
(3, 'Sketchboard', 'Sketch me crazy!', 'sketchboard-help.php', 'sketch-board-logo.png', 'https://sketchboard.me', 'tile-square', 'Imagine'),
(4, 'TinkerCad', 'Tinker me silly!', 'tinkercad-help.php', 'tinkercad-logo.png', 'https://www.tinkercad.com', 'tile-square', 'Create'),
(5, 'Beetle Blocks', 'BLOCK BLOCK BLOCK', 'beetle-blocks-help.php', 'beetle-blocks.png', 'http://beetleblocks.com/', 'tile-square', 'Create'),
(6, 'Snap!', 'CAPTION', 'snap-help.php', 'snap_logo.png', './snap/snap.html', 'tile-wide', 'Program'),
(7, 'Scratch4Arduino', 'lulululul', 'scratch-4-arduino-help.php', 'scratch-logo-small.png', 'http://s4a.cat/', 'tile-small', 'Program'),
(8, 'Thingiverse', 'CAPTION', 'thingiverse-help.php', 'thingiverse-logo.png', 'https://www.thingiverse.com/', 'tile-square', 'Share'),
(9, 'Trello', 'CAPTION', 'trello-help.php', 'trello-logo.png', 'https://trello.com/', 'tile-square', 'Plan'),
(10, 'Snap4Arduino', 'CAPTION', 'snap4arduino-help.php', 'ardu-logo.png', './snap4arduino/', 'tile-square', 'Program'),
(11, 'Ardublock', 'CAPTION', 'ardublock-help.php', 'ardu-logo.png', 'http://blog.ardublock.com/', 'tile-square', 'Program'),
(12, 'Coggle', 'CAPTION', 'coggle-help.php', 'coggle-logo.png', 'https://coggle.it/', 'tile-square', 'Imagine'),
(13, 'Scratch4Raspberry', 'lulululul', 'scratch-4-arduino-help.php', 'scratch-logo-small.png', 'https://scratch.mit.edu/', 'tile-small', 'Program'),
(14, 'Arduino IDE', 'ARDUIDE', 'arduino-ide-help.php', 'arduino-ide.png', 'https://create.arduino.cc/editor', 'tile-small', 'Program'),
(15, 'Netsblocks', '!', 'netsblox-help.php', 'netsblox.png', 'https://editor.netsblox.org/', 'tile-small', 'Program'),
(16, 'Pocket Code', 'CODE', 'pocket-code-help.php', 'pocket-code-allwhite.png', 'https://www.catrobat.org/intro/', 'tile-small', 'Program'),
(17, 'MIT App Inventor', 'Invent me please!', 'mit-app-inventor-help.php', 'app-inventor-allwhite.png', 'http://ai2.appinventor.mit.edu/', 'tile-small', 'Program');

-- --------------------------------------------------------

--
-- Structure for view `categoryview`
--
DROP TABLE IF EXISTS `categoryview`;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `categoryview`  AS  select `category`.`name` AS `category` from `category` order by `category`.`sortorder` ;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `categorycolor`
--
ALTER TABLE `categorycolor`
  ADD CONSTRAINT `categorycolor_ibfk_1` FOREIGN KEY (`category`) REFERENCES `category` (`name`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `categorycolor_ibfk_2` FOREIGN KEY (`size`) REFERENCES `size` (`name`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tool`
--
ALTER TABLE `tool`
  ADD CONSTRAINT `tool_ibfk_1` FOREIGN KEY (`category`) REFERENCES `category` (`name`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `tool_ibfk_2` FOREIGN KEY (`size`) REFERENCES `size` (`name`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
