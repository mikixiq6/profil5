$ErrorActionPreference = "Stop"
$git = "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\Git\cmd\git.exe"

& $git init

# Configure local git user if not set to prevent commit failures
& $git config user.name "Michal Hrdina"
& $git config user.email "michal.hrdina@example.com"

# Step 1: Create profile.json
$profileJson = @'
{
    "name": "Michal Hrdina",
    "skills": ["PHP", "JavaScript", "HTML", "CSS"],
    "projects": ["Personal IT Profile", "E-commerce Website", "Portfolio"]
}
'@
Set-Content -Path "profile.json" -Value $profileJson -Encoding UTF8
& $git add profile.json
& $git commit -m "feat(json): create profile data structure"

# Step 2: Create initial index.php with basic html
$indexPhp1 = @'
<!DOCTYPE html>
<html lang="cs">
<head>
    <meta charset="UTF-8">
    <title>IT Profile</title>
</head>
<body>
    
</body>
</html>
'@
Set-Content -Path "index.php" -Value $indexPhp1 -Encoding UTF8
& $git add index.php
& $git commit -m "feat(php): initial index.php with basic html"

# Step 3: Load and parse JSON
$indexPhp2 = @'
<?php
$jsonData = file_get_contents('profile.json');
$profile = json_decode($jsonData, true);
?>
<!DOCTYPE html>
<html lang="cs">
<head>
    <meta charset="UTF-8">
    <title>IT Profile</title>
</head>
<body>
    
</body>
</html>
'@
Set-Content -Path "index.php" -Value $indexPhp2 -Encoding UTF8
& $git add index.php
& $git commit -m "feat(php): load and parse json profile data"

# Step 4: Render name and skills
$indexPhp3 = @'
<?php
$jsonData = file_get_contents('profile.json');
$profile = json_decode($jsonData, true);
?>
<!DOCTYPE html>
<html lang="cs">
<head>
    <meta charset="UTF-8">
    <title>IT Profile</title>
</head>
<body>
    <h1><?php echo htmlspecialchars($profile['name'] ?? ''); ?></h1>
    <h2>Skills</h2>
    <ul>
        <?php foreach (($profile['skills'] ?? []) as $skill): ?>
            <li><?php echo htmlspecialchars($skill); ?></li>
        <?php endforeach; ?>
    </ul>
</body>
</html>
'@
Set-Content -Path "index.php" -Value $indexPhp3 -Encoding UTF8
& $git add index.php
& $git commit -m "feat(php): render name and skills from json"

# Step 5: Render projects
$indexPhp4 = @'
<?php
$jsonData = file_get_contents('profile.json');
$profile = json_decode($jsonData, true);
?>
<!DOCTYPE html>
<html lang="cs">
<head>
    <meta charset="UTF-8">
    <title>IT Profile</title>
</head>
<body>
    <h1><?php echo htmlspecialchars($profile['name'] ?? ''); ?></h1>
    
    <h2>Skills</h2>
    <ul>
        <?php foreach (($profile['skills'] ?? []) as $skill): ?>
            <li><?php echo htmlspecialchars($skill); ?></li>
        <?php endforeach; ?>
    </ul>

    <h2>Projects</h2>
    <ul>
        <?php foreach (($profile['projects'] ?? []) as $project): ?>
            <li><?php echo htmlspecialchars($project); ?></li>
        <?php endforeach; ?>
    </ul>
</body>
</html>
'@
Set-Content -Path "index.php" -Value $indexPhp4 -Encoding UTF8
& $git add index.php
& $git commit -m "feat(php): render projects section from json"

# Step 6: Improve layout and logic
$indexPhp5 = @'
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
    </style>
</head>
<body>
    <h1><?php echo htmlspecialchars($profile['name'] ?? 'N/A'); ?></h1>
    
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
</body>
</html>
'@
Set-Content -Path "index.php" -Value $indexPhp5 -Encoding UTF8
& $git add index.php
& $git commit -m "style(php): improve html structure and handle missing keys safely"

& $git log --oneline -n 6
