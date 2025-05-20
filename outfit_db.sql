-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 02, 2025 at 01:09 PM
-- Server version: 10.4.32-MariaDB-log
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `outfit_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `ahp_criteria`
--

CREATE TABLE `ahp_criteria` (
  `criteria_id` int(11) NOT NULL,
  `criteria_name` varchar(50) NOT NULL,
  `weight` decimal(3,2) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ahp_criteria`
--

INSERT INTO `ahp_criteria` (`criteria_id`, `criteria_name`, `weight`, `description`, `created_at`) VALUES
(1, 'Season Compatibility', 0.30, 'Tingkat kesesuaian dengan musim (tropis/subtropis dan sub-musim)', '2025-05-02 05:38:39'),
(2, 'Weather Compatibility', 0.25, 'Tingkat kesesuaian dengan kondisi cuaca', '2025-05-02 05:38:39'),
(3, 'Event Compatibility', 0.25, 'Tingkat kesesuaian dengan jenis acara', '2025-05-02 05:38:39'),
(4, 'Gender Compatibility', 0.10, 'Tingkat kesesuaian dengan jenis kelamin', '2025-05-02 05:38:39'),
(5, 'Comfort Level', 0.10, 'Tingkat kenyamanan outfit', '2025-05-02 05:38:39');

-- --------------------------------------------------------

--
-- Table structure for table `outfits`
--

CREATE TABLE `outfits` (
  `id` int(11) NOT NULL,
  `gender` enum('pria','wanita','unisex') NOT NULL,
  `season_type` enum('tropis','subtropis') NOT NULL,
  `sub_season` varchar(20) NOT NULL,
  `weather` varchar(20) NOT NULL,
  `event_type` varchar(20) NOT NULL,
  `description` text NOT NULL,
  `season_score` int(11) DEFAULT 0,
  `weather_score` int(11) DEFAULT 0,
  `event_score` int(11) DEFAULT 0,
  `gender_score` int(11) DEFAULT 0,
  `comfort_score` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `outfits`
--

INSERT INTO `outfits` (`id`, `gender`, `season_type`, `sub_season`, `weather`, `event_type`, `description`, `season_score`, `weather_score`, `event_score`, `gender_score`, `comfort_score`, `created_at`, `updated_at`) VALUES
(1, 'pria', 'tropis', 'kemarau', 'cerah', 'santai', 'Kaos katun lengan pendek + Celana pendek + Sandal jepit + Topi baseball', 9, 8, 7, 10, 8, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(2, 'pria', 'tropis', 'kemarau', 'cerah', 'formal', 'Kemeja linen lengan pendek + Celana chino + Loafers + Kacamata hitam', 8, 7, 9, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(3, 'pria', 'tropis', 'kemarau', 'cerah', 'pesta', 'Kemeja sutra lengan pendek + Celana linen + Loafers + Jam tangan', 8, 7, 8, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(4, 'pria', 'tropis', 'kemarau', 'cerah', 'olahraga', 'Tank top + Celana training pendek + Sepatu lari + Bandana', 9, 9, 9, 10, 8, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(5, 'pria', 'tropis', 'kemarau', 'cerah', 'kerja', 'Kemeja lengan pendek + Celana chino + Loafers + Jam tangan', 8, 7, 9, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(6, 'pria', 'tropis', 'kemarau', 'panas', 'santai', 'Tank top katun + Celana pendek breathable + Sandal jepit + Topi bucket', 9, 9, 8, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(7, 'pria', 'tropis', 'kemarau', 'panas', 'formal', 'Kemeja linen lengan panjang digulung + Celana chino + Espadrilles', 8, 8, 8, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(8, 'pria', 'tropis', 'kemarau', 'panas', 'pesta', 'Kemeja sutra lengan pendek + Celana slim fit + Loafers', 8, 8, 9, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(9, 'pria', 'tropis', 'kemarau', 'panas', 'olahraga', 'Running singlet + Celana kompresi pendek + Running shoes', 9, 10, 9, 10, 8, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(10, 'pria', 'tropis', 'kemarau', 'panas', 'kerja', 'Kemeja lengan pendek + Celana chino + Loafers', 8, 8, 9, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(11, 'wanita', 'tropis', 'kemarau', 'cerah', 'santai', 'Dress flowy pendek + Sandal jepit + Topi lebar + Tas anyaman', 9, 9, 8, 10, 8, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(12, 'wanita', 'tropis', 'kemarau', 'cerah', 'formal', 'Blouse katun lengan pendek + Rok midi + Wedges + Cardigan tipis', 8, 8, 9, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(13, 'wanita', 'tropis', 'kemarau', 'cerah', 'pesta', 'Dress slit tinggi + Heels + Clutch kecil + Anting besar', 8, 8, 10, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(14, 'wanita', 'tropis', 'kemarau', 'cerah', 'olahraga', 'Sports bra + Legging pendek + Running shoes + Headband', 9, 9, 9, 10, 8, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(15, 'wanita', 'tropis', 'kemarau', 'cerah', 'kerja', 'Tunik + Celana palazo + Sandal wedges + Cardigan', 8, 8, 9, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(16, 'wanita', 'tropis', 'kemarau', 'panas', 'santai', 'Bikini top + Sarung pareo + Sandal jepit + Topi besar', 9, 10, 7, 10, 8, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(17, 'wanita', 'tropis', 'kemarau', 'panas', 'formal', 'Blouse lengan pendek + Rok linen + Sandal wedges + Kacamata hitam', 8, 9, 9, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(18, 'wanita', 'tropis', 'kemarau', 'panas', 'pesta', 'Dress maxi flowy + Sandal gladiator + Tas anyaman', 8, 9, 10, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(19, 'wanita', 'tropis', 'kemarau', 'panas', 'olahraga', 'Tank top + Running shorts + Running shoes + Headband pendingin', 9, 10, 9, 10, 8, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(20, 'wanita', 'tropis', 'kemarau', 'panas', 'kerja', 'Rompi tanpa lengan + Celana wide leg + Wedges + Scarf ringan', 8, 9, 9, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(21, 'pria', 'tropis', 'hujan', 'hujan', 'santai', 'Hoodie + Celana jeans + Sepatu waterproof + Payung kecil', 9, 9, 7, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(22, 'pria', 'tropis', 'hujan', 'hujan', 'formal', 'Blazer water resistant + Kemeja + Celana kain anti air + Loafers tahan air', 8, 9, 9, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(23, 'pria', 'tropis', 'hujan', 'hujan', 'pesta', 'Kemeja lengan panjang + Celana dress + Jas hujan stylish + Shoes tahan air', 8, 9, 8, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(24, 'pria', 'tropis', 'hujan', 'hujan', 'olahraga', 'Jaket olahraga anti air + Legging panjang + Sepatu trail', 9, 9, 9, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(25, 'pria', 'tropis', 'hujan', 'hujan', 'kerja', 'Kemeja lengan panjang + Celana bahan water repellent + Ankle boots', 8, 9, 9, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(26, 'pria', 'tropis', 'hujan', 'lembab', 'santai', 'Kaos quick-dry + Celana pendek quick-dry + Sandal waterproof', 8, 8, 7, 10, 8, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(27, 'pria', 'tropis', 'hujan', 'lembab', 'formal', 'Kemeja lengan pendek anti lembab + Celana gabardine + Loafers tahan air', 8, 8, 9, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(28, 'pria', 'tropis', 'hujan', 'lembab', 'pesta', 'Kemeja sutra + Celana dress + Jas hujan transparan + Shoes tahan air', 8, 8, 8, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(29, 'pria', 'tropis', 'hujan', 'lembab', 'olahraga', 'Dri-fit t-shirt + Legging pendek quick-dry + Trail shoes', 8, 8, 9, 10, 8, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(30, 'pria', 'tropis', 'hujan', 'lembab', 'kerja', 'Kemeja bahan tahan lembab + Celana chino + Ankle boots waterproof', 8, 8, 9, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(31, 'wanita', 'tropis', 'hujan', 'hujan', 'santai', 'Sweater + Legging + Boots karet + Jas hujan pendek', 9, 9, 7, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(32, 'wanita', 'tropis', 'hujan', 'hujan', 'formal', 'Blouse lengan panjang + Celana water repellent + Ankle boots + Trench coat', 8, 9, 9, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(33, 'wanita', 'tropis', 'hujan', 'hujan', 'pesta', 'Dress pendek bahan quick dry + Rain boots stylish + Jas hujan transparan', 8, 9, 10, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(34, 'wanita', 'tropis', 'hujan', 'hujan', 'olahraga', 'Jaket anti air + Legging + Sepatu trail + Topi waterproof', 9, 9, 9, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(35, 'wanita', 'tropis', 'hujan', 'hujan', 'kerja', 'Blouse lengan panjang + Rok midi tahan air + Boots + Trench coat', 8, 9, 9, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(36, 'wanita', 'tropis', 'hujan', 'lembab', 'santai', 'T-shirt katun tipis + Celana linen pendek + Sandal jepit', 8, 8, 7, 10, 8, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(37, 'wanita', 'tropis', 'hujan', 'lembab', 'formal', 'Blouse lengan pendek + Rok midi + Wedges + Cardigan tipis', 8, 8, 9, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(38, 'wanita', 'tropis', 'hujan', 'lembab', 'pesta', 'Dress satin pendek + Heels + Clutch kecil + Anting statement', 8, 8, 10, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(39, 'wanita', 'tropis', 'hujan', 'lembab', 'olahraga', 'Tank top + Legging pendek + Running shoes + Headband', 8, 8, 9, 10, 8, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(40, 'wanita', 'tropis', 'hujan', 'lembab', 'kerja', 'Tunik + Celana palazo + Wedges rendah + Cardigan', 8, 8, 9, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(41, 'unisex', 'tropis', 'kemarau', 'cerah', 'santai', 'Kaos oblong + Celana pendek + Sandal jepit + Topi', 9, 9, 8, 10, 8, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(42, 'unisex', 'tropis', 'kemarau', 'panas', 'olahraga', 'T-shirt dry fit + Celana training pendek + Running shoes', 9, 9, 9, 10, 8, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(43, 'unisex', 'tropis', 'hujan', 'hujan', 'kerja', 'Kemeja lengan panjang + Celana chino tahan air + Sepatu waterproof', 8, 9, 9, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(44, 'unisex', 'tropis', 'hujan', 'lembab', 'santai', 'T-shirt katun + Celana pendek + Sandal jepit', 8, 8, 7, 10, 8, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(45, 'unisex', 'tropis', 'kemarau', 'cerah', 'kerja', 'Kemeja lengan pendek + Celana chino + Loafers', 8, 8, 9, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(46, 'unisex', 'tropis', 'kemarau', 'panas', 'santai', 'Tank top + Celana pendek + Sandal + Topi', 9, 9, 8, 10, 8, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(47, 'unisex', 'tropis', 'hujan', 'hujan', 'olahraga', 'Jaket anti air + Celana training + Sepatu trail', 9, 9, 9, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(48, 'unisex', 'tropis', 'kemarau', 'cerah', 'formal', 'Kemeja lengan pendek + Celana linen + Sandal', 8, 8, 8, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(49, 'unisex', 'tropis', 'hujan', 'lembab', 'kerja', 'Kemeja lengan panjang + Celana waterproof + Sepatu tahan air', 8, 9, 9, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(50, 'unisex', 'tropis', 'kemarau', 'panas', 'pesta', 'Kemeja linen + Celana pendek + Sandal kulit', 8, 8, 8, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(51, 'pria', 'subtropis', 'semi', 'sejuk', 'santai', 'Sweater tipis + Jeans + Sneakers + Scarf', 9, 8, 7, 10, 8, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(52, 'pria', 'subtropis', 'semi', 'sejuk', 'formal', 'Blazer katun + Kemeja lengan panjang + Celana kain + Oxford shoes', 8, 8, 9, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(53, 'pria', 'subtropis', 'semi', 'sejuk', 'pesta', 'Kemeja dress + Celana slim fit + Derbies + Jam tangan', 8, 8, 9, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(54, 'pria', 'subtropis', 'semi', 'sejuk', 'olahraga', 'Jaket track + T-shirt + Legging + Running shoes', 9, 8, 9, 10, 8, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(55, 'pria', 'subtropis', 'semi', 'sejuk', 'kerja', 'Kemeja lengan panjang + Celana dress + Blazer + Leather shoes', 8, 8, 9, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(56, 'pria', 'subtropis', 'semi', 'berawan', 'santai', 'Hoodie + Jogger pants + Sneakers + Beanie', 9, 8, 7, 10, 8, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(57, 'pria', 'subtropis', 'semi', 'berawan', 'formal', 'Tweed blazer + Rollneck + Celana wool + Brogues', 8, 8, 9, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(58, 'pria', 'subtropis', 'semi', 'berawan', 'pesta', 'Kemeja sutra + Blazer + Celana dress + Leather shoes', 8, 8, 9, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(59, 'pria', 'subtropis', 'semi', 'berawan', 'olahraga', 'Windbreaker + Legging + Running shoes', 9, 8, 9, 10, 8, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(60, 'pria', 'subtropis', 'semi', 'berawan', 'kerja', 'Knit sweater + Celana chino + Loafers + Trench coat', 8, 8, 9, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(61, 'wanita', 'subtropis', 'semi', 'sejuk', 'santai', 'Cardigan + T-shirt + Jeans + Sneakers', 9, 8, 7, 10, 8, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(62, 'wanita', 'subtropis', 'semi', 'sejuk', 'formal', 'Blazer + Blouse lengan panjang + Pencil skirt + Pumps', 8, 8, 9, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(63, 'wanita', 'subtropis', 'semi', 'sejuk', 'pesta', 'Dress midi lengan pendek + Bolero + Heels + Clutch', 8, 8, 10, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(64, 'wanita', 'subtropis', 'semi', 'sejuk', 'olahraga', 'Running jacket + Legging + Running shoes', 9, 8, 9, 10, 8, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(65, 'wanita', 'subtropis', 'semi', 'sejuk', 'kerja', 'Blouse sutra + Blazer + Pencil skirt + Loafers', 8, 8, 9, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(66, 'wanita', 'subtropis', 'semi', 'berawan', 'santai', 'Sweater oversized + Jeans + Boots + Scarf', 9, 8, 7, 10, 8, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(67, 'wanita', 'subtropis', 'semi', 'berawan', 'formal', 'Blazer linen + Rollneck + Celana wide leg + Loafers', 8, 8, 9, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(68, 'wanita', 'subtropis', 'semi', 'berawan', 'pesta', 'Jumpsuit lengan panjang + Heels + Statement necklace', 8, 8, 10, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(69, 'wanita', 'subtropis', 'semi', 'berawan', 'olahraga', 'Running tights + Long sleeve top + Running shoes', 9, 8, 9, 10, 8, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(70, 'wanita', 'subtropis', 'semi', 'berawan', 'kerja', 'Turtleneck + Blazer + Pencil skirt + Knee-high boots', 8, 8, 9, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(71, 'pria', 'subtropis', 'panas', 'panas', 'santai', 'Tank top + Celana pendek + Sandal + Topi', 9, 9, 7, 10, 8, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(72, 'pria', 'subtropis', 'panas', 'panas', 'formal', 'Kemeja linen lengan pendek + Celana linen + Loafers', 8, 8, 8, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(73, 'pria', 'subtropis', 'panas', 'panas', 'pesta', 'Kemeja sutra lengan pendek + Celana slim fit + Derbies', 8, 8, 9, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(74, 'pria', 'subtropis', 'panas', 'panas', 'olahraga', 'T-shirt running + Running shorts + Running shoes', 9, 9, 9, 10, 8, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(75, 'pria', 'subtropis', 'panas', 'panas', 'kerja', 'Kemeja lengan pendek + Celana chino + Loafers', 8, 8, 9, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(76, 'pria', 'subtropis', 'panas', 'kering', 'santai', 'Kaos oblong + Celana pendek cargo + Sandal gunung', 9, 9, 7, 10, 8, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(77, 'pria', 'subtropis', 'panas', 'kering', 'formal', 'Kemeja katun lengan panjang + Celana linen + Espadrilles', 8, 8, 8, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(78, 'pria', 'subtropis', 'panas', 'kering', 'pesta', 'Kemeja dress lengan pendek + Celana slim fit + Loafers', 8, 8, 9, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(79, 'pria', 'subtropis', 'panas', 'kering', 'olahraga', 'Compression shirt + Running shorts + Trail shoes', 9, 9, 9, 10, 8, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(80, 'pria', 'subtropis', 'panas', 'kering', 'kerja', 'Polo shirt + Celana chino + Loafers', 8, 8, 9, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(81, 'wanita', 'subtropis', 'panas', 'panas', 'santai', 'Bikini top + Sarung pareo + Sandal jepit', 9, 10, 7, 10, 8, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(82, 'wanita', 'subtropis', 'panas', 'panas', 'formal', 'Dress linen lengan pendek + Sandal wedges + Topi lebar', 8, 9, 9, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(83, 'wanita', 'subtropis', 'panas', 'panas', 'pesta', 'Dress maxi flowy + Sandal gladiator + Tas anyaman', 8, 9, 10, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(84, 'wanita', 'subtropis', 'panas', 'panas', 'olahraga', 'Sports bra + Running shorts + Running shoes', 9, 10, 9, 10, 8, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(85, 'wanita', 'subtropis', 'panas', 'panas', 'kerja', 'Blouse lengan pendek + Rok midi + Sandal wedges', 8, 9, 9, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(86, 'wanita', 'subtropis', 'panas', 'kering', 'santai', 'Crop top + High-waisted shorts + Sneakers', 9, 9, 7, 10, 8, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(87, 'wanita', 'subtropis', 'panas', 'kering', 'formal', 'Rompi tanpa lengan + Celana wide leg + Heels', 8, 9, 9, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(88, 'wanita', 'subtropis', 'panas', 'kering', 'pesta', 'Slip dress + Strappy heels + Clutch kecil', 8, 9, 10, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(89, 'wanita', 'subtropis', 'panas', 'kering', 'olahraga', 'Tank top + Legging pendek + Running shoes', 9, 9, 9, 10, 8, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(90, 'wanita', 'subtropis', 'panas', 'kering', 'kerja', 'Sleeveless blouse + Midi skirt + Sandals', 8, 9, 9, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(91, 'unisex', 'subtropis', 'semi', 'sejuk', 'santai', 'Hoodie + Jeans + Sneakers + Scarf', 9, 8, 7, 10, 8, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(92, 'unisex', 'subtropis', 'panas', 'panas', 'olahraga', 'T-shirt dry fit + Running shorts + Running shoes', 9, 9, 9, 10, 8, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(93, 'unisex', 'subtropis', 'gugur', 'berangin', 'kerja', 'Turtleneck + Blazer + Chinos + Leather shoes', 8, 8, 9, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(94, 'unisex', 'subtropis', 'dingin', 'dingin', 'santai', 'Puffer jacket + Jeans + Thermal shirt + Boots', 9, 9, 7, 10, 8, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(95, 'unisex', 'subtropis', 'semi', 'berawan', 'formal', 'Blazer + Kemeja + Celana chino + Derbies', 8, 8, 8, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(96, 'unisex', 'subtropis', 'panas', 'kering', 'santai', 'T-shirt + Celana pendek + Sandal', 9, 9, 7, 10, 8, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(97, 'unisex', 'subtropis', 'gugur', 'sejuk', 'kerja', 'Sweater + Celana dress + Boots + Scarf', 8, 8, 9, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(98, 'unisex', 'subtropis', 'dingin', 'salju', 'olahraga', 'Ski jacket + Thermal pants + Snow boots', 9, 9, 9, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(99, 'unisex', 'subtropis', 'semi', 'sejuk', 'pesta', 'Kemeja linen + Celana linen + Loafers', 8, 8, 8, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09'),
(100, 'unisex', 'subtropis', 'panas', 'panas', 'kerja', 'Polo shirt + Celana linen + Espadrilles', 8, 9, 9, 10, 7, '2025-05-02 05:46:09', '2025-05-02 05:46:09');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `ahp_criteria`
--
ALTER TABLE `ahp_criteria`
  ADD PRIMARY KEY (`criteria_id`),
  ADD UNIQUE KEY `criteria_name` (`criteria_name`);

--
-- Indexes for table `outfits`
--
ALTER TABLE `outfits`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `ahp_criteria`
--
ALTER TABLE `ahp_criteria`
  MODIFY `criteria_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `outfits`
--
ALTER TABLE `outfits`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=101;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
