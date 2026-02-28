<?php
// PHP page to determine if the traffic comes from CURL or from HTTPS and then send back the respective content.
$ua = strtolower($_SERVER['HTTP_USER_AGENT'] ?? '');

if (
    strpos($ua, 'curl') !== false ||
    strpos($ua, 'wget') !== false ||
    strpos($ua, 'httpie') !== false
) {
    header("Content-Type: text/plain");
    $content = file_get_contents("https://raw.githubusercontent.com/Wester4253/Suite-Of-Tools/refs/heads/main/frontend/launcher.sh");
    echo $content;
    exit;
}

// Browser? send them to the homepage!
header("Location: https://wstr.codes", true, 302);
exit;
