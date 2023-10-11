<?php
// Get the visitor's real IP address
if (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
    $ip = $_SERVER['HTTP_X_FORWARDED_FOR'];
} elseif (!empty($_SERVER['HTTP_X_REAL_IP'])) {
    $ip = $_SERVER['HTTP_X_REAL_IP'];
} else {
    $ip = $_SERVER['REMOTE_ADDR'];
}

// Log the IP address to a file
$logFile = 'access.txt';
$ipLog = $ip . "\n";

// Append the IP address to the log file
file_put_contents($logFile, $ipLog, FILE_APPEND);

// Send a response (optional)
//echo "IP address $ip has been logged.";
?>
