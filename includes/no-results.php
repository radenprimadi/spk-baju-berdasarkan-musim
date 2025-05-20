<?php
$pageTitle = "Hasil Tidak Ditemukan";
require '../includes/header.php';
?>

<div class="no-results-container">
    <div class="no-results-illustration">
        <img src="../assets/image/K_on.png" alt="Tidak ada hasil" />
    </div>
    
    <h2 class="no-results-title">Tidak Ada Outfit yang Cocok Ditemukan</h2>
    
    <div class="no-results-message">
        <p>Kami tidak dapat menemukan outfit yang memenuhi kriteria Anda:</p>
        
        <div class="search-criteria">
            <?php foreach ($input as $key => $value): ?>
                <span class="badge">
                    <i class="<?= getCriteriaIcon($key) ?>"></i>
                    <?= htmlspecialchars($value) ?>
                </span>
            <?php endforeach; ?>
        </div>
        
        <p class="suggestion-text">Silakan coba dengan kriteria yang lebih fleksibel atau tambahkan outfit baru ke database.</p>
    </div>
    
    <div class="no-results-actions">
        <a href="index.php" class="btn-retry">
            <i class="fas fa-redo"></i> Coba Kriteria Lain
        </a>
    </div>
</div>

<?php
require '../includes/footer.php';

function getCriteriaIcon($criteria) {
    $icons = [
        'gender' => 'fa-venus-mars',
        'season_type' => 'fa-globe-americas',
        'sub_season' => 'fa-cloud-sun',
        'weather' => 'fa-cloud-rain',
        'event_type' => 'fa-calendar-check'
    ];
    return $icons[$criteria] ?? 'fa-question-circle';
}
?>