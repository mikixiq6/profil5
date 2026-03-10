$ErrorActionPreference = "Stop"
$git = "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\Git\cmd\git.exe"

# Step 1: Add form for new interests
$indexPhp1 = @'
<?php
$jsonFilePath = 'profile.json';
$profile = [];

if (file_exists($jsonFilePath)) {
    $jsonData = file_get_contents($jsonFilePath);
    $profile = json_decode($jsonData, true) ?? [];
}
?>
<!DOCTYPE html>
<html lang="cs">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IT Profile - <?php echo htmlspecialchars($profile['name'] ?? 'Unknown'); ?></title>
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; margin: 20px; max-width: 600px; }
        h1 { color: #333; }
        h2 { color: #666; border-bottom: 1px solid #ccc; padding-bottom: 5px; }
        ul { padding-left: 20px; }
        .success { color: green; font-weight: bold; }
        .error { color: red; font-weight: bold; }
        form { margin-top: 20px; margin-bottom: 20px; padding: 10px; border: 1px solid #ccc; background: #f9f9f9; }
    </style>
</head>
<body>
    <h1><?php echo htmlspecialchars($profile['name'] ?? 'N/A'); ?></h1>
    
    <form method="POST">
        <input type="text" name="new_interest" required>
        <button type="submit">Přidat zájem</button>
    </form>

    <?php if (!empty($profile['skills'])): ?>
        <h2>Dovednosti (Skills)</h2>
        <ul>
            <?php foreach ($profile['skills'] as $skill): ?>
                <li><?php echo htmlspecialchars($skill); ?></li>
            <?php endforeach; ?>
        </ul>
    <?php endif; ?>

    <?php if (!empty($profile['projects'])): ?>
        <h2>Projekty (Projects)</h2>
        <ul>
            <?php foreach ($profile['projects'] as $project): ?>
                <li><?php echo htmlspecialchars($project); ?></li>
            <?php endforeach; ?>
        </ul>
    <?php endif; ?>

    <?php if (!empty($profile['interests'])): ?>
        <h2>Zájmy (Interests)</h2>
        <ul>
            <?php foreach ($profile['interests'] as $interest): ?>
                <li><?php echo htmlspecialchars($interest); ?></li>
            <?php endforeach; ?>
        </ul>
    <?php endif; ?>
</body>
</html>
'@
Set-Content -Path "index.php" -Value $indexPhp1 -Encoding UTF8
& $git add index.php
& $git commit -m "feat(php): add form for new interests"

# Step 2: Handle form submission and save to json
$indexPhp2 = @'
<?php
$jsonFilePath = 'profile.json';
$profile = [];

if (file_exists($jsonFilePath)) {
    $jsonData = file_get_contents($jsonFilePath);
    $profile = json_decode($jsonData, true) ?? [];
}

if ($_SERVER["REQUEST_METHOD"] === "POST" && isset($_POST["new_interest"])) {
    $newInterest = trim($_POST["new_interest"]);

    if (!empty($newInterest)) {
        if (!isset($profile['interests'])) {
            $profile['interests'] = [];
        }

        $lowerNewInterest = strtolower($newInterest);
        $existingInterestsLower = array_map('strtolower', $profile['interests']);

        if (!in_array($lowerNewInterest, $existingInterestsLower)) {
            $profile['interests'][] = $newInterest;
            file_put_contents($jsonFilePath, json_encode($profile, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE));
        }
    }
}
?>
<!DOCTYPE html>
<html lang="cs">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IT Profile - <?php echo htmlspecialchars($profile['name'] ?? 'Unknown'); ?></title>
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; margin: 20px; max-width: 600px; }
        h1 { color: #333; }
        h2 { color: #666; border-bottom: 1px solid #ccc; padding-bottom: 5px; }
        ul { padding-left: 20px; }
        .success { color: green; font-weight: bold; }
        .error { color: red; font-weight: bold; }
        form { margin-top: 20px; margin-bottom: 20px; padding: 10px; border: 1px solid #ccc; background: #f9f9f9; }
    </style>
</head>
<body>
    <h1><?php echo htmlspecialchars($profile['name'] ?? 'N/A'); ?></h1>
    
    <form method="POST">
        <input type="text" name="new_interest" required>
        <button type="submit">Přidat zájem</button>
    </form>

    <?php if (!empty($profile['skills'])): ?>
        <h2>Dovednosti (Skills)</h2>
        <ul>
            <?php foreach ($profile['skills'] as $skill): ?>
                <li><?php echo htmlspecialchars($skill); ?></li>
            <?php endforeach; ?>
        </ul>
    <?php endif; ?>

    <?php if (!empty($profile['projects'])): ?>
        <h2>Projekty (Projects)</h2>
        <ul>
            <?php foreach ($profile['projects'] as $project): ?>
                <li><?php echo htmlspecialchars($project); ?></li>
            <?php endforeach; ?>
        </ul>
    <?php endif; ?>

    <?php if (!empty($profile['interests'])): ?>
        <h2>Zájmy (Interests)</h2>
        <ul>
            <?php foreach ($profile['interests'] as $interest): ?>
                <li><?php echo htmlspecialchars($interest); ?></li>
            <?php endforeach; ?>
        </ul>
    <?php endif; ?>
</body>
</html>
'@
Set-Content -Path "index.php" -Value $indexPhp2 -Encoding UTF8
& $git add index.php
& $git commit -m "feat(php): handle form submission and save to json"

# Step 3: Add success and error messages
$indexPhp3 = @'
<?php
$jsonFilePath = 'profile.json';
$profile = [];

if (file_exists($jsonFilePath)) {
    $jsonData = file_get_contents($jsonFilePath);
    $profile = json_decode($jsonData, true) ?? [];
}

$message = "";
$messageType = "";

if ($_SERVER["REQUEST_METHOD"] === "POST" && isset($_POST["new_interest"])) {
    $newInterest = trim($_POST["new_interest"]);

    if (!empty($newInterest)) {
        if (!isset($profile['interests'])) {
            $profile['interests'] = [];
        }

        $lowerNewInterest = strtolower($newInterest);
        $existingInterestsLower = array_map('strtolower', $profile['interests']);

        if (!in_array($lowerNewInterest, $existingInterestsLower)) {
            $profile['interests'][] = $newInterest;
            if (file_put_contents($jsonFilePath, json_encode($profile, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE))) {
                $message = "Zájem byl úspěšně přidán.";
                $messageType = "success";
            }
        } else {
            $message = "Tento zájem už existuje.";
            $messageType = "error";
        }
    } else {
        $message = "Pole nesmí být prázdné.";
        $messageType = "error";
    }
}
?>
<!DOCTYPE html>
<html lang="cs">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IT Profile - <?php echo htmlspecialchars($profile['name'] ?? 'Unknown'); ?></title>
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; margin: 20px; max-width: 600px; }
        h1 { color: #333; }
        h2 { color: #666; border-bottom: 1px solid #ccc; padding-bottom: 5px; }
        ul { padding-left: 20px; }
        .success { color: green; font-weight: bold; }
        .error { color: red; font-weight: bold; }
        form { margin-top: 20px; margin-bottom: 20px; padding: 10px; border: 1px solid #ccc; background: #f9f9f9; }
    </style>
</head>
<body>
    <h1><?php echo htmlspecialchars($profile['name'] ?? 'N/A'); ?></h1>
    
    <?php if (!empty($message)): ?>
        <p class="<?php echo $messageType; ?>">
            <?php echo htmlspecialchars($message); ?>
        </p>
    <?php endif; ?>

    <form method="POST">
        <input type="text" name="new_interest" required>
        <button type="submit">Přidat zájem</button>
    </form>

    <?php if (!empty($profile['skills'])): ?>
        <h2>Dovednosti (Skills)</h2>
        <ul>
            <?php foreach ($profile['skills'] as $skill): ?>
                <li><?php echo htmlspecialchars($skill); ?></li>
            <?php endforeach; ?>
        </ul>
    <?php endif; ?>

    <?php if (!empty($profile['projects'])): ?>
        <h2>Projekty (Projects)</h2>
        <ul>
            <?php foreach ($profile['projects'] as $project): ?>
                <li><?php echo htmlspecialchars($project); ?></li>
            <?php endforeach; ?>
        </ul>
    <?php endif; ?>

    <?php if (!empty($profile['interests'])): ?>
        <h2>Zájmy (Interests)</h2>
        <ul>
            <?php foreach ($profile['interests'] as $interest): ?>
                <li><?php echo htmlspecialchars($interest); ?></li>
            <?php endforeach; ?>
        </ul>
    <?php endif; ?>
</body>
</html>
'@
Set-Content -Path "index.php" -Value $indexPhp3 -Encoding UTF8
& $git add index.php
& $git commit -m "feat(php): add success and error messages"

& $git log --oneline -n 3
