<?php
// Database Configuration
define('DB_HOST', 'localhost');
define('DB_USER', 'root');
define('DB_PASS', '');
define('DB_NAME', 'outfit_db');
define('DB_CHARSET', 'utf8mb4');

// Path Configuration
define('BASE_URL', 'http://localhost/spk');
define('ASSETS_URL', BASE_URL . '/assets');

// AHP Configuration
define('AHP_CONSISTENCY_THRESHOLD', 0.1);

// Error Reporting
define('ENVIRONMENT', 'development');

if (ENVIRONMENT === 'development') {
    error_reporting(E_ALL);
    ini_set('display_errors', 1);
} else {
    error_reporting(0);
    ini_set('display_errors', 0);
}