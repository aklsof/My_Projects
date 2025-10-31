-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 15, 2024 at 12:30 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `online_food_order`
--
CREATE DATABASE IF NOT EXISTS `online_food_order` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `online_food_order`;

-- --------------------------------------------------------

--
-- Stand-in structure for view `active_orders`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `active_orders`;
CREATE TABLE `active_orders` (
`order_id` int(11)
,`Order Number` int(11)
,`order_date` date
,`Customer First Name` varchar(30)
,`Customer Last Name` varchar(30)
,`Cachier First Name` varchar(50)
,`Cachier last Name` varchar(50)
,`item` varchar(30)
,`Quantity` double(10,2)
,`Price` float(10,2)
,`Total` double(19,2)
);

-- --------------------------------------------------------

--
-- Table structure for table `department`
--

DROP TABLE IF EXISTS `department`;
CREATE TABLE `department` (
  `department_id` int(11) NOT NULL,
  `department_name` varchar(50) DEFAULT NULL,
  `department_location` varchar(100) DEFAULT NULL,
  `department_head` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `food_item`
--

DROP TABLE IF EXISTS `food_item`;
CREATE TABLE `food_item` (
  `food_id` int(5) NOT NULL,
  `food_name` varchar(30) DEFAULT NULL,
  `food_quantity` int(5) DEFAULT NULL,
  `food_sell_price` float(10,2) DEFAULT NULL,
  `food_buy_price` float(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_customer`
--

DROP TABLE IF EXISTS `tbl_customer`;
CREATE TABLE `tbl_customer` (
  `customer_id` int(11) NOT NULL,
  `customer_first_name` varchar(30) DEFAULT NULL,
  `customer_last_name` varchar(30) DEFAULT NULL,
  `customer_email` varchar(55) DEFAULT NULL,
  `customer_phone` varchar(13) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_employee`
--

DROP TABLE IF EXISTS `tbl_employee`;
CREATE TABLE `tbl_employee` (
  `employee_id` int(11) NOT NULL,
  `employee_first_name` varchar(50) DEFAULT NULL,
  `employee_last_name` varchar(50) NOT NULL,
  `employee_email` varchar(100) DEFAULT NULL,
  `employee_phone` varchar(20) DEFAULT NULL,
  `employee_address` varchar(200) DEFAULT NULL,
  `employee_gender` int(1) DEFAULT NULL,
  `position_id` int(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `tbl_employee`
--
DROP TRIGGER IF EXISTS `Delete`;
DELIMITER $$
CREATE TRIGGER `Delete` BEFORE DELETE ON `tbl_employee` FOR EACH ROW BEGIN 
  INSERT INTO tbl_employee_audit (audit_data)
  VALUES (CONCAT('Employee with ID = ', OLD.employee_id, ' was deleted on ', DATE_FORMAT(CURRENT_DATE, '%b %d,%Y')));
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `For_insert`;
DELIMITER $$
CREATE TRIGGER `For_insert` AFTER INSERT ON `tbl_employee` FOR EACH ROW BEGIN
  INSERT INTO tbl_employee_audit (audit_data)
  VALUES (CONCAT('New employee with ID = ', NEW.employee_id, ' was added on ', DATE_FORMAT(CURRENT_DATE, '%b %d,%Y')));
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_employee_audit`
--

DROP TABLE IF EXISTS `tbl_employee_audit`;
CREATE TABLE `tbl_employee_audit` (
  `id` int(11) NOT NULL,
  `audit_data` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_gender`
--

DROP TABLE IF EXISTS `tbl_gender`;
CREATE TABLE `tbl_gender` (
  `gender_id` int(11) NOT NULL,
  `gender_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_order`
--

DROP TABLE IF EXISTS `tbl_order`;
CREATE TABLE `tbl_order` (
  `order_id` int(11) NOT NULL,
  `order_number` int(11) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `employee_id` int(11) DEFAULT NULL,
  `food_id` int(11) DEFAULT NULL,
  `order_quantity` double(10,2) NOT NULL DEFAULT 0.00,
  `order_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_position`
--

DROP TABLE IF EXISTS `tbl_position`;
CREATE TABLE `tbl_position` (
  `position_id` int(6) NOT NULL,
  `position_name` varchar(50) NOT NULL,
  `position_salary` decimal(10,2) NOT NULL,
  `position_annual_salary` decimal(10,2) NOT NULL,
  `position_department` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure for view `active_orders`
--
DROP TABLE IF EXISTS `active_orders`;

DROP VIEW IF EXISTS `active_orders`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `active_orders`  AS SELECT `tbl_order`.`order_id` AS `order_id`, `tbl_order`.`order_number` AS `Order Number`, `tbl_order`.`order_date` AS `order_date`, `tbl_customer`.`customer_first_name` AS `Customer First Name`, `tbl_customer`.`customer_last_name` AS `Customer Last Name`, `tbl_employee`.`employee_first_name` AS `Cachier First Name`, `tbl_employee`.`employee_last_name` AS `Cachier last Name`, `food_item`.`food_name` AS `item`, `tbl_order`.`order_quantity` AS `Quantity`, `food_item`.`food_sell_price` AS `Price`, `tbl_order`.`order_quantity`* `food_item`.`food_sell_price` AS `Total` FROM (((`tbl_order` join `tbl_employee` on(`tbl_order`.`employee_id` = `tbl_employee`.`employee_id`)) join `tbl_customer` on(`tbl_customer`.`customer_id` = `tbl_order`.`customer_id`)) join `food_item` on(`food_item`.`food_id` = `tbl_order`.`food_id`)) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `department`
--
ALTER TABLE `department`
  ADD PRIMARY KEY (`department_id`);

--
-- Indexes for table `food_item`
--
ALTER TABLE `food_item`
  ADD PRIMARY KEY (`food_id`);

--
-- Indexes for table `tbl_customer`
--
ALTER TABLE `tbl_customer`
  ADD PRIMARY KEY (`customer_id`),
  ADD UNIQUE KEY `customer_id_2` (`customer_id`),
  ADD KEY `customer_id` (`customer_id`);

--
-- Indexes for table `tbl_employee`
--
ALTER TABLE `tbl_employee`
  ADD PRIMARY KEY (`employee_id`),
  ADD KEY `fk_employee_gender` (`employee_gender`),
  ADD KEY `position_id` (`position_id`);

--
-- Indexes for table `tbl_employee_audit`
--
ALTER TABLE `tbl_employee_audit`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_gender`
--
ALTER TABLE `tbl_gender`
  ADD PRIMARY KEY (`gender_id`);

--
-- Indexes for table `tbl_order`
--
ALTER TABLE `tbl_order`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `fk_order_food` (`food_id`),
  ADD KEY `fk_order_employee` (`employee_id`),
  ADD KEY `fk_order_customer` (`customer_id`);

--
-- Indexes for table `tbl_position`
--
ALTER TABLE `tbl_position`
  ADD PRIMARY KEY (`position_id`),
  ADD KEY `fk_position_department` (`position_department`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_employee_audit`
--
ALTER TABLE `tbl_employee_audit`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tbl_employee`
--
ALTER TABLE `tbl_employee`
  ADD CONSTRAINT `fk_employee_gender` FOREIGN KEY (`employee_gender`) REFERENCES `tbl_gender` (`gender_id`),
  ADD CONSTRAINT `tbl_employee_ibfk_2` FOREIGN KEY (`position_id`) REFERENCES `tbl_position` (`position_id`);

--
-- Constraints for table `tbl_order`
--
ALTER TABLE `tbl_order`
  ADD CONSTRAINT `fk_order_customer` FOREIGN KEY (`customer_id`) REFERENCES `tbl_customer` (`customer_id`),
  ADD CONSTRAINT `fk_order_employee` FOREIGN KEY (`employee_id`) REFERENCES `tbl_employee` (`employee_id`),
  ADD CONSTRAINT `fk_order_food` FOREIGN KEY (`food_id`) REFERENCES `food_item` (`food_id`);

--
-- Constraints for table `tbl_position`
--
ALTER TABLE `tbl_position`
  ADD CONSTRAINT `fk_position_department` FOREIGN KEY (`position_department`) REFERENCES `department` (`department_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
