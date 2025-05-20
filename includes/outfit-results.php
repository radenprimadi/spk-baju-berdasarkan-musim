<?php
// Default values jika $consistency tidak terdefinisi
$cr_value = $consistency['CR'] ?? 0;
$is_consistent = $consistency['is_consistent'] ?? false;
$cr_display = number_format($cr_value, 3);
?>

<div class="results-container">
    <!-- Header dengan ikon -->
    <div class="results-header">
        <h2><i class="fas fa-tshirt"></i> Hasil Rekomendasi Outfit</h2>
        <div class="search-criteria">
            <span class="badge"><i class="fas fa-venus-mars"></i> <?= htmlspecialchars($input['gender']) ?></span>
            <span class="badge"><i class="fas fa-globe-americas"></i> <?= htmlspecialchars($input['season_type']) ?></span>
            <span class="badge"><i class="fas fa-cloud-sun"></i> <?= htmlspecialchars($input['sub_season']) ?></span>
            <span class="badge"><i class="fas fa-cloud-rain"></i> <?= htmlspecialchars($input['weather']) ?></span>
            <span class="badge"><i class="fas fa-calendar-check"></i> <?= htmlspecialchars($input['event_type']) ?></span>
        </div>
    </div>

    <!-- Konsistensi AHP -->
    <div class="consistency-alert <?= $is_consistent ? 'success' : 'warning' ?>">
        <i class="fas <?= $is_consistent ? 'fa-check-circle' : 'fa-exclamation-triangle' ?>"></i>
        <span>Matriks <?= $is_consistent ? 'konsisten' : 'tidak konsisten' ?> (CR = <?= $cr_display ?>)</span>
    </div>

    <!-- Daftar Outfit -->
    <div class="outfit-grid">
        <?php foreach ($outfits as $index => $outfit): ?>
            <div class="outfit-card <?= $index === 0 ? 'top-result' : '' ?>">
                <div class="outfit-rank">#<?= $index + 1 ?></div>
                <div class="outfit-image" style="background-image: url('<?= $outfit['image_url'] ?? 'https://via.placeholder.com/350x200?text=Outfit+' . ($index + 1) ?>')"></div>
                <div class="outfit-content">
                    <h3><?= htmlspecialchars($outfit['description']) ?></h3>
                    
                    <div class="outfit-score">
                        <div class="score-bar" style="width: <?= min(100, $outfit['total_score'] * 10) ?>%"></div>
                        <span><?= number_format($outfit['total_score'], 2) ?></span>
                    </div>
                    
                    <div class="outfit-details">
                        <div class="detail-item">
                            <span class="detail-label"><i class="fas fa-sun"></i> Season</span>
                            <span class="detail-value"><?= $outfit['season_score'] ?></span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label"><i class="fas fa-cloud"></i> Weather</span>
                            <span class="detail-value"><?= $outfit['weather_score'] ?></span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label"><i class="fas fa-calendar"></i> Event</span>
                            <span class="detail-value"><?= $outfit['event_score'] ?></span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label"><i class="fas fa-user"></i> Gender</span>
                            <span class="detail-value"><?= $outfit['gender_score'] ?></span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label"><i class="fas fa-couch"></i> Comfort</span>
                            <span class="detail-value"><?= $outfit['comfort_score'] ?></span>
                        </div>
                    </div>
                    
                    <div class="outfit-actions">
                        <button class="btn-like"><i class="far fa-heart"></i></button>
                        <button class="btn-save"><i class="far fa-bookmark"></i></button>
                    </div>
                </div>
            </div>
        <?php endforeach; ?>
    </div>
    <button type="submit" class="btn-submit" onclick="window.location.href='index.php'">
        <i class="fas fa-search"></i> Kembali Cari Outfit lain
    </button>
</div>