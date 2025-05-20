<?php
require '../includes/header.php';

// Pastikan $pdo adalah objek PDO yang valid
$pdo = require '../includes/db.php';
if (!($pdo instanceof PDO)) {
    die("Invalid database connection. Expected PDO object.");
}

try {
    $genders = $pdo->query("SELECT DISTINCT gender FROM outfits")->fetchAll();
    $events = $pdo->query("SELECT DISTINCT event_type FROM outfits")->fetchAll();
} catch (PDOException $e) {
    die("Query error: " . $e->getMessage());
}
?>
<form id="outfitForm" action="results.php" method="get">
    <!-- Field Jenis Kelamin -->
    <div class="form-group">
        <label for="gender"><i class="fas fa-venus-mars"></i> Jenis Kelamin</label>
        <select name="gender" id="gender" required>
            <option value="">Pilih...</option>
            <?php foreach ($genders as $g): ?>
                <option value="<?= htmlspecialchars($g['gender']) ?>">
                    <?= ucfirst(htmlspecialchars($g['gender'])) ?>
                </option>
            <?php endforeach; ?>
        </select>
    </div>

    <!-- Field Jenis Iklim -->
    <div class="form-group">
        <label for="season_type"><i class="fas fa-globe"></i> Jenis Iklim</label>
        <select name="season_type" id="season_type" required>
            <option value="">Pilih...</option>
            <option value="tropis">Tropis</option>
            <option value="subtropis">Subtropis</option>
        </select>
    </div>

    <!-- Field Sub Musim (akan diisi via JS) -->
    <div class="form-group">
        <label for="sub_season"><i class="fas fa-cloud-sun"></i> Sub Musim</label>
        <select name="sub_season" id="sub_season" required>
            <option value="">Pilih Jenis Iklim terlebih dahulu</option>
        </select>
    </div>

    <!-- Field Cuaca (akan diisi via JS) -->
    <div class="form-group">
        <label for="weather"><i class="fas fa-cloud-rain"></i> Cuaca</label>
        <select name="weather" id="weather" required>
            <option value="">Pilih Sub Musim terlebih dahulu</option>
        </select>
    </div>

    <!-- Field Jenis Acara -->
    <div class="form-group">
        <label for="event_type"><i class="fas fa-calendar-check"></i> Jenis Acara</label>
        <select name="event_type" id="event_type" required>
            <option value="">Pilih...</option>
            <?php foreach ($events as $e): ?>
                <option value="<?= htmlspecialchars($e['event_type']) ?>">
                    <?= ucfirst(htmlspecialchars($e['event_type'])) ?>
                </option>
            <?php endforeach; ?>
        </select>
    </div>

    <button type="submit" class="btn-submit">
        <i class="fas fa-search"></i> Cari Outfit Terbaik
    </button>
</form>

<script src="<?= ASSETS_URL ?>/js/script.js"></script>

<?php require '../includes/footer.php'; ?>