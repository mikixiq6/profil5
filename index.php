<?php
// Inicializace session pro ukládání hlášek napříč přesměrováním (PRG pattern)
session_start();

$jsonFile = 'profile.json';

// Zajištění, že profile.json existuje, jinak jej vytvoříme jako prázdné pole
if (!file_exists($jsonFile)) {
    file_put_contents($jsonFile, json_encode([]));
}

// Načtení a dekódování dat ze souboru JSON
$interestsData = file_get_contents($jsonFile);
$interests = json_decode($interestsData, true);
if (!is_array($interests)) {
    $interests = []; // Pojistka pro případ narušeného JSON
}

// Zpracování POST požadavků (Create, Update, Delete)
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action = isset($_POST['action']) ? $_POST['action'] : '';

    // Create - Přidání nového zájmu
    if ($action === 'add') {
        $newInterest = isset($_POST['interest']) ? trim($_POST['interest']) : '';

        if ($newInterest === '') {
            $_SESSION['message'] = 'Pole nesmí být prázdné.';
            $_SESSION['msg_type'] = 'error';
        } else {
            // Kontrola duplicity (ignoruje velikost písmen)
            $lowerInterests = array_map(function ($item) {
                return mb_strtolower($item, 'UTF-8');
            }, $interests);

            if (in_array(mb_strtolower($newInterest, 'UTF-8'), $lowerInterests)) {
                $_SESSION['message'] = 'Tento zájem už existuje.';
                $_SESSION['msg_type'] = 'error';
            } else {
                $interests[] = $newInterest;
                file_put_contents($jsonFile, json_encode(array_values($interests), JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT));
                $_SESSION['message'] = 'Zájem byl úspěšně přidán.';
                $_SESSION['msg_type'] = 'success';
            }
        }
        // Redirect
        header("Location: index.php");
        exit;
    }

    // Update - Úprava existujícího zájmu
    if ($action === 'edit') {
        $index = isset($_POST['index']) ? (int) $_POST['index'] : -1;
        $updatedInterest = isset($_POST['interest']) ? trim($_POST['interest']) : '';

        if ($updatedInterest === '') {
            $_SESSION['message'] = 'Pole nesmí být prázdné.';
            $_SESSION['msg_type'] = 'error';
        } else {
            if (isset($interests[$index])) {
                // Odstraníme aktuální položku, abychom při kontrole duplicity neporovnávali sami se sebou
                $tempInterests = $interests;
                unset($tempInterests[$index]);

                $lowerTempInterests = array_map(function ($item) {
                    return mb_strtolower($item, 'UTF-8');
                }, $tempInterests);

                if (in_array(mb_strtolower($updatedInterest, 'UTF-8'), $lowerTempInterests)) {
                    $_SESSION['message'] = 'Tento zájem už existuje.';
                    $_SESSION['msg_type'] = 'error';
                } else {
                    $interests[$index] = $updatedInterest;
                    // Přepis s přečíslováním indexů pro jistotu
                    file_put_contents($jsonFile, json_encode(array_values($interests), JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT));
                    $_SESSION['message'] = 'Zájem byl upraven.';
                    $_SESSION['msg_type'] = 'success';
                }
            } else {
                $_SESSION['message'] = 'Zájem nebyl nalezen.';
                $_SESSION['msg_type'] = 'error';
            }
        }
        // Redirect
        header("Location: index.php");
        exit;
    }

    // Delete - Odstranění zájmu
    if ($action === 'delete') {
        $index = isset($_POST['index']) ? (int) $_POST['index'] : -1;
        if (isset($interests[$index])) {
            unset($interests[$index]); // Odstranění položky
            // Přečíslování indexů pomocí array_values a uložení
            file_put_contents($jsonFile, json_encode(array_values($interests), JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT));
            $_SESSION['message'] = 'Zájem byl odstraněn.';
            $_SESSION['msg_type'] = 'success';
        }
        // Redirect
        header("Location: index.php");
        exit;
    }
}

// Získání zprávy ze session (Get fázový render)
$message = '';
$msgType = '';
if (isset($_SESSION['message'])) {
    $message = $_SESSION['message'];
    $msgType = $_SESSION['msg_type'] ?? 'info';
    unset($_SESSION['message'], $_SESSION['msg_type']); // Výmaz zprávy po zobrazení
}

// Režim editace - zjištění, zda upravujeme pomocí GET parametru edit_index
$editIndex = isset($_GET['edit_index']) ? (int) $_GET['edit_index'] : null;
$editValue = '';
if ($editIndex !== null && isset($interests[$editIndex])) {
    $editValue = $interests[$editIndex];
}
?>
<!DOCTYPE html>
<html lang="cs">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IT Profil 5.0 – Správa zájmů</title>
    <link rel="stylesheet" href="style.css">
    <!-- Přidání moderního fontu -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
</head>

<body>

    <div class="container">
        <header>
            <h1>IT Profil 5.0</h1>
            <p>Správa osobních zájmů</p>
        </header>

        <!-- Zobrazení zpráv po přesměrování -->
        <?php if ($message !== ''): ?>
            <div class="alert alert-<?= htmlspecialchars($msgType) ?>">
                <?= htmlspecialchars($message) ?>
            </div>
        <?php endif; ?>

        <!-- Formulář pro přidání/úpravu zájmů -->
        <div class="card form-card">
            <h2><?= $editIndex !== null ? 'Upravit zájem' : 'Přidat nový zájem' ?></h2>
            <form action="index.php" method="POST" class="add-form">
                <?php if ($editIndex !== null): ?>
                    <!-- Režim editece existující položky -->
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" name="index" value="<?= htmlspecialchars((string) $editIndex) ?>">
                    <input type="text" name="interest" value="<?= htmlspecialchars($editValue) ?>"
                        placeholder="Název zájmu..." required autofocus>
                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">Uložit změny</button>
                        <a href="index.php" class="btn btn-secondary">Zrušit</a>
                    </div>
                <?php else: ?>
                    <!-- Režim přidání nové položky -->
                    <input type="hidden" name="action" value="add">
                    <input type="text" name="interest" placeholder="Zadejte nový zájem..." required>
                    <button type="submit" class="btn btn-primary">Přidat zájem</button>
                <?php endif; ?>
            </form>
        </div>

        <!-- Seznam zájmů -->
        <div class="card list-card">
            <h2>Vaše zájmy</h2>
            <?php if (empty($interests)): ?>
                <div class="empty-state">
                    <p>Zatím nebyly přidány žádné zájmy.</p>
                </div>
            <?php else: ?>
                <ul class="interest-list">
                    <?php foreach ($interests as $index => $interest): ?>
                        <li class="interest-item <?= ($editIndex === $index) ? 'editing' : '' ?>">
                            <span class="interest-name"><?= htmlspecialchars($interest) ?></span>
                            <div class="item-actions">
                                <!-- Úprava (přesměruje na GET formulář nahoře) -->
                                <a href="index.php?edit_index=<?= htmlspecialchars((string) $index) ?>"
                                    class="btn btn-sm btn-edit">Upravit</a>

                                <!-- Mazání - skrze formulář s POST metodou pro bezpečnost a PRG -->
                                <form action="index.php" method="POST" style="display:inline-block;"
                                    onsubmit="return confirm('Opravdu chcete tento zájem smazat?');">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="index" value="<?= htmlspecialchars((string) $index) ?>">
                                    <button type="submit" class="btn btn-sm btn-delete">Smazat</button>
                                </form>
                            </div>
                        </li>
                    <?php endforeach; ?>
                </ul>
            <?php endif; ?>
        </div>
    </div>

</body>

</html>