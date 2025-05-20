<?php
// Tangkap nilai kembalian dari db.php
$pdo = require '../includes/db.php';

// Verifikasi koneksi database
if (!($pdo instanceof PDO)) {
    die("Database connection failed");
}

require '../includes/ahp-functions.php';

// Validasi input
$input = filter_input_array(INPUT_GET, [
    'gender' => FILTER_SANITIZE_SPECIAL_CHARS,
    'season_type' => FILTER_SANITIZE_SPECIAL_CHARS,
    'sub_season' => FILTER_SANITIZE_SPECIAL_CHARS,
    'weather' => FILTER_SANITIZE_SPECIAL_CHARS,
    'event_type' => FILTER_SANITIZE_SPECIAL_CHARS
]);

// Validasi semua parameter
if (in_array(null, $input, true)) {
    die("All parameters are required");
}
try {
    // Dapatkan bobot AHP
    $weights = getAhpWeights($pdo);
    
    // Hitung konsistensi (contoh - sesuaikan dengan kebutuhan)
    $sampleMatrix = generatePairwiseMatrix(['priority' => 'comfort']);
    $consistency = calculateConsistencyRatio($sampleMatrix);
    
    // Query outfit
    $stmt = $pdo->prepare("SELECT * FROM outfits WHERE 
        gender = :gender AND 
        season_type = :season_type AND 
        sub_season = :sub_season AND 
        weather = :weather AND 
        event_type = :event_type");
    
    $stmt->execute([
        ':gender' => $input['gender'],
        ':season_type' => $input['season_type'],
        ':sub_season' => $input['sub_season'],
        ':weather' => $input['weather'],
        ':event_type' => $input['event_type']
    ]);
    
    $outfits = $stmt->fetchAll();

    // Hitung skor untuk setiap outfit
    foreach ($outfits as &$outfit) {
        $outfit['total_score'] = calculateOutfitScore($outfit, $weights);
    }
    unset($outfit);

    // Urutkan berdasarkan skor tertinggi
    usort($outfits, function($a, $b) {
        return $b['total_score'] <=> $a['total_score'];
    });

    // Tampilkan hasil
    $pageTitle = "Hasil Rekomendasi Outfit";
    require '../includes/header.php';

    if (empty($outfits)) {
        require '../includes/no-results.php';
    } else {
        // Kirim variabel $consistency ke template
        require '../includes/outfit-results.php';
    }

} catch (PDOException $e) {
    die("Database error: " . $e->getMessage());
} catch (Exception $e) {
    die("Error: " . $e->getMessage());
}
// [Setelah menghitung $consistency...]

// Tampilkan hasil
$pageTitle = "Hasil Rekomendasi Outfit";
require '../includes/header.php';

if (empty($outfits)) {
    require '../includes/no-results.php';
} else {
    // Tampilkan proses perhitungan
    echo displayAhpCalculation($sampleMatrix, $consistency);
    
    // Tampilkan hasil rekomendasi
    require '../includes/outfit-results.php';
}
require '../includes/footer.php';