<?php
// PHP page to determine if the traffic comes from CURL or from HTTPS and then send back the respective content.
$ua = strtolower($_SERVER['HTTP_USER_AGENT'] ?? '');

if (
    strpos($ua, 'curl') !== false ||
    strpos($ua, 'wget') !== false ||
    strpos($ua, 'httpie') !== false
) {
    header("Content-Type: text/plain");
    readfile(__DIR__ . "/launcher.sh");
    exit;
}

// Browser? send them to the homepage!
header("Location: https://westr42.xyz", true, 302);
exit;
