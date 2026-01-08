// PHP page to determine if the traffic comes from CURL or from HTTPS and then send back the respective content.

<?php
$ua = strtolower($_SERVER['HTTP_USER_AGENT'] ?? '');

if (
    strpos($ua, 'curl') !== false ||
    strpos($ua, 'wget') !== false ||
    strpos($ua, 'httpie') !== false
) {
    header("Content-Type: text/plain");
    readfile(__DIR__ . "/index.sh");
    exit;
}

// Browser? send them to GitHub
header("Location: https://github.com/Wester4253/Suite-Of-Tools", true, 302);
exit;

