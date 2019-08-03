<?php

$configFilePath = __DIR__.'/import-hosts.conf';

if (!file_exists($configFilePath)) {
    echo '[ERROR] import-host.conf file is not exists!';
    exit;
}

$config = parse_ini_file($configFilePath);

if (empty($config['FILE_LOCATION'])) {
    echo '[ERROR] FILE_LOCATION is not setup!';
    exit;
}

$wslMode = !empty($_SERVER['SCRIPT_FILENAME']) && preg_match('/^\/mnt/', $_SERVER['SCRIPT_FILENAME']);
$output = $wslMode ? '/mnt/c/Windows/System32/drivers/etc/hosts' : 'C:\Windows\System32\drivers\etc\hosts';

if (!file_exists($output)) {
    echo '[ERROR] Output hosts file "'.$output.'" is not exists!'."\n";
    exit;
}

$input = $config['FILE_LOCATION'];
$blockName = empty($config['BLOCK_NAME']) ? 'default' : $config['BLOCK_NAME'];

if (preg_match('/^http/', $input)) {
    $ch = curl_init();

    curl_setopt($ch, CURLOPT_URL, $input);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
    curl_setopt($ch, CURLOPT_TIMEOUT, 10);

    $blockText = curl_exec($ch);

    if (false === $blockText || CURLE_OK !== curl_errno($ch)) {
        echo '[ERROR] Download hosts file "'.$input.'" failed!'."\n";
        exit;
    }

    curl_close($ch);
} else {
    if ($wslMode && preg_match('/^[a-zA-Z]:/', $input)) {
        // Convert Windows file path (e.g. C:\foo\bar.txt) to Linux (WSL) file path (e.g. /mnt/c/foo/bar.txt)
        $input = '/mnt/'.strtolower(substr($input, 0, 1)).'/'.trim(str_replace('\\', '/', substr($input, 2)), '/ ');
    }
    if (!file_exists($input)) {
        echo '[ERROR] Input hosts file "'.$input.'" is not exists!'."\n";
        exit;
    }

    $blockText = file_get_contents($input);
}

$inputLines = explode("\n", $blockText);

// Check input lines with valid format
foreach ($inputLines as $line) {
    $line = trim($line);

    if ('#' === substr($line, 0, 1) || empty($line)) {
        continue;
    }

    $parts = explode(' ', $line);
    $parts = array_map('trim', $parts);
    $parts = array_filter($parts, function ($part) { return !empty($part); });

    if (2 !== count($parts)) {
        echo '[ERROR] Invalid input content format: near "'.$line.'"'."\n";
        exit;
    }
}

$blockStartText = sprintf('## INSERTED BY sfdev ## %s ## START ##', $blockName);
$blockEndText   = sprintf('## INSERTED BY sfdev ## %s ## END   ##', $blockName);
$outputLines = [
    'before' => [],
    'after' => [],
];
$blockStarted = false;
$blockEnded = false;

foreach (explode("\n", file_get_contents($output)) as $line) {
    if (trim($line) === $blockStartText) {
        $blockStarted = true;
        $outputLines['before'][] = $line;
    } elseif (trim($line) === $blockEndText) {
        $blockEnded = true;
    }

    if (false === $blockStarted) {
        $outputLines['before'][] = $line;
    } elseif (true === $blockEnded) {
        $outputLines['after'][] = $line;
    }
}

if (true === $blockStarted && false === $blockEnded) {
    $blockEnded = true;
}
if (false === $blockStarted && false === $blockEnded) {
    $blockText = $blockStartText."\n".$blockText."\n".$blockEndText;
}

$outputText = implode("\n", $outputLines['before'])."\n".$blockText."\n".implode("\n", $outputLines['after']);

// Update hosts file
file_put_contents($output, $outputText);

echo '[SUCCESS] Update host file successfuly!'."\n";
