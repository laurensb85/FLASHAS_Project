-- phpMyAdmin SQL Dump
-- version 2.11.6
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generatie Tijd: 28 Jan 2009 om 22:19
-- Server versie: 5.0.51
-- PHP Versie: 5.2.6

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `db_scores`
--
CREATE DATABASE `db_scores` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `db_scores`;

-- --------------------------------------------------------

--
-- Tabel structuur voor tabel `t_hiscores`
--

CREATE TABLE `t_hiscores` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(128) NOT NULL,
  `score` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=16 ;

--
-- Gegevens worden uitgevoerd voor tabel `t_hiscores`
--

INSERT INTO `t_hiscores` (`id`, `name`, `score`) VALUES
(1, 'Dieter', 121),
(2, 'Ronny', 13),
(3, 'Ahmed', 90),
(4, 'Harry', 150),
(5, 'Johnny', 200),
(6, 'Mohammed', 99),
(7, 'Lisa', 88),
(8, 'Bart', 101),
(9, 'Homer', 111),
(10, 'Steven', 105),
(11, 'Hans', 115),
(12, 'Peter', 103),
(13, 'test', 26),
(14, 'final test', 13),
(15, 'final test', 13);
