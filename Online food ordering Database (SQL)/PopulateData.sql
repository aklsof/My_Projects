SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;



INSERT INTO `department` VALUES
(1, 'commercial', 'Washington', 'Robert Lim'),
(2, 'Production', 'Washington', 'John walker');

INSERT INTO `food_item` VALUES
(1, 'Tomato', 120, 1.29, 0.69),
(2, 'Potatoes', 300, 0.88, 0.46),
(3, 'apple', 75, 2.49, 0.89),
(4, 'grapes', 250, 3.69, 1.09);

INSERT INTO `tbl_customer` VALUES
(1, 'jack', 'white', 'jack@yahoo.com', '2064445252'),
(2, 'Stephan', 'black', 'stephanblack@gmail.com', '22541551522');

INSERT INTO `tbl_gender` VALUES
(1, 'Male'),
(2, 'Female'),
(3, 'others');

INSERT INTO `tbl_position` VALUES
(1, 'Sales Representative', 3000.00, 36000.00, NULL),
(2, 'Production_line1', 4500.00, 600000.00, 2),
(3, 'production manager', 6000.00, 90000.00, 2);
DROP TABLE IF EXISTS `active_orders`;

INSERT INTO `tbl_employee` VALUES
(1, 'John', 'Doe', 'johndoe@sample.com', '2554441212', '12333 Main Street #201 Kent, Washington', 1, 1),
(2, 'Richard', 'Milton', 'rm@myemail.com', '42520025', '2258 25 AVE S; Los angelos, Florida', 1, 2);




INSERT INTO `tbl_order` VALUES
(1, 4525, 1, 1, 3, 2.00, '2024-10-02'),
(2, 4525, 1, 1, 2, 6.00, '2024-09-22'),
(3, 4223, 2, 1, 3, 3.00, '2024-06-02'),
(4, 4223, 1, 1, 1, 3.00, '2024-04-16'),
(5, 4711, 1, 1, 1, 2.00, '2023-03-25');

DROP VIEW IF EXISTS `active_orders`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `active_orders`  AS SELECT `tbl_order`.`order_id` AS `order_id`, `tbl_order`.`order_number` AS `Order Number`, `tbl_order`.`order_date` AS `order_date`, `tbl_customer`.`customer_first_name` AS `Customer First Name`, `tbl_customer`.`customer_last_name` AS `Customer Last Name`, `tbl_employee`.`employee_first_name` AS `Cachier First Name`, `tbl_employee`.`employee_last_name` AS `Cachier last Name`, `food_item`.`food_name` AS `item`, `tbl_order`.`order_quantity` AS `Quantity`, `food_item`.`food_sell_price` AS `Price`, `tbl_order`.`order_quantity`* `food_item`.`food_sell_price` AS `Total` FROM (((`tbl_order` join `tbl_employee` on(`tbl_order`.`employee_id` = `tbl_employee`.`employee_id`)) join `tbl_customer` on(`tbl_customer`.`customer_id` = `tbl_order`.`customer_id`)) join `food_item` on(`food_item`.`food_id` = `tbl_order`.`food_id`)) ;
DROP TABLE IF EXISTS `view_order`;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
