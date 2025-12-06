<?php

$host = 'localhost';
$user = 'root';
$pass = '';
$db   = 'nn-project-management';

$dsn = "mysql:host=$host;dbname=$db;charset=utf8mb4";

try {
    $pdo = new PDO($dsn, $user, $pass, [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION, // throw exceptions
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,       // clean fetch results
        PDO::ATTR_EMULATE_PREPARES   => false,                  // use native prepared statements
    ]);
    
    // echo "Connected successfully"; // optional
} catch (PDOException $e) {
    error_log("PDO Connection Error: " . $e->getMessage());
    exit("Database connection failed.");
}
