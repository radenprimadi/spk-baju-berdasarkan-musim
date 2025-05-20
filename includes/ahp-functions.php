<?php
require_once __DIR__ . '/../config/constants.php';

function generatePairwiseMatrix($userPreferences) {
    // Matriks dasar dengan nilai yang lebih moderat untuk meningkatkan konsistensi
    $matrix = [
        [1,    2,    3,    5,    7],   // Season vs others
        [1/2,  1,    2,    3,    5],   // Weather vs others
        [1/3,  1/2,  1,    2,    3],   // Event vs others
        [1/5,  1/3,  1/2,  1,    2],   // Gender vs others
        [1/7,  1/5,  1/3,  1/2,  1]    // Comfort vs others
    ];

    // Adjust matriks dengan menjaga konsistensi reciprocal
    if ($userPreferences['priority'] === 'comfort') {
        $matrix[4][0] = 1/3; $matrix[0][4] = 3;  // Comfort vs Season
        $matrix[4][1] = 1/2; $matrix[1][4] = 2;  // Comfort vs Weather
        $matrix[4][2] = 1/1; $matrix[2][4] = 1;  // Comfort vs Event
    } elseif ($userPreferences['priority'] === 'style') {
        $matrix[3][0] = 1/3; $matrix[0][3] = 3;  // Gender vs Season
        $matrix[3][1] = 1/2; $matrix[1][3] = 2;  // Gender vs Weather
    }

    return $matrix;
}
function isMatrixValid($matrix) {
    $n = count($matrix);
    for ($i = 0; $i < $n; $i++) {
        if ($matrix[$i][$i] != 1) return false; // Diagonal harus 1
        for ($j = $i+1; $j < $n; $j++) {
            if (abs($matrix[$i][$j] * $matrix[$j][$i] - 1) > 0.01) {
                return false; // Harus memenuhi a_ij = 1/a_ji
            }
        }
    }
    return true;
}

function calculateOutfitScore($outfit, $weights) {
    return ($outfit['season_score'] * $weights['Season Compatibility'] +
            $outfit['weather_score'] * $weights['Weather Compatibility'] +
            $outfit['event_score'] * $weights['Event Compatibility'] +
            $outfit['gender_score'] * $weights['Gender Compatibility'] +
            $outfit['comfort_score'] * $weights['Comfort Level']);
}

function getAhpWeights($pdo) {
    try {
        $stmt = $pdo->query("SELECT criteria_name, weight FROM ahp_criteria");
        $weights = $stmt->fetchAll(PDO::FETCH_KEY_PAIR);
        
        if (empty($weights)) {
            return [
                'Season Compatibility' => 0.30,
                'Weather Compatibility' => 0.25,
                'Event Compatibility' => 0.25,
                'Gender Compatibility' => 0.10,
                'Comfort Level' => 0.10
            ];
        }
        return $weights;
    } catch (PDOException $e) {
        error_log("AHP weights error: " . $e->getMessage());
        return [
            'Season Compatibility' => 0.30,
            'Weather Compatibility' => 0.25,
            'Event Compatibility' => 0.25,
            'Gender Compatibility' => 0.10,
            'Comfort Level' => 0.10
        ];
    }
}

function saveAhpCalculation($pdo, $userId, $calculationData) {
    try {
        $pdo->beginTransaction();

        $stmt = $pdo->prepare("INSERT INTO ahp_calculations (
            user_id, 
            cr_value,
            is_consistent,
            calculation_date
        ) VALUES (?, ?, ?, NOW())");
        
        $stmt->execute([
            $userId,
            $calculationData['cr_value'],
            $calculationData['is_consistent'] ? 1 : 0
        ]);
        
        $calculationId = $pdo->lastInsertId();

        $stmt = $pdo->prepare("INSERT INTO ahp_weights (
            calculation_id,
            criteria_name,
            weight
        ) VALUES (?, ?, ?)");

        foreach ($calculationData['weights'] as $criteria => $weight) {
            $stmt->execute([$calculationId, $criteria, $weight]);
        }

        $pdo->commit();
        return $calculationId;

    } catch (PDOException $e) {
        $pdo->rollBack();
        error_log("Error saving AHP calculation: " . $e->getMessage());
        return false;
    }
}

function calculateConsistencyRatio($matrix) {
    $n = count($matrix);
    
    // 1. Hitung jumlah kolom
    $columnSums = array_fill(0, $n, 0);
    foreach ($matrix as $row) {
        foreach ($row as $j => $val) {
            $columnSums[$j] += $val;
        }
    }
    
    // 2. Normalisasi matriks dan hitung eigenvector
    $eigenvector = [];
    foreach ($matrix as $i => $row) {
        $rowSum = 0;
        foreach ($row as $j => $val) {
            $rowSum += $val / $columnSums[$j];
        }
        $eigenvector[] = $rowSum / $n;
    }

    // 3. Hitung λ_max
    $lambdaMax = 0;
    for ($i = 0; $i < $n; $i++) {
        $rowSum = 0;
        for ($j = 0; $j < $n; $j++) {
            $rowSum += $matrix[$i][$j] * $eigenvector[$j];
        }
        $lambdaMax += $rowSum / $eigenvector[$i];
    }
    $lambdaMax /= $n;

    // 4. Hitung Consistency Index (CI) dan Ratio (CR)
    $CI = ($lambdaMax - $n) / ($n - 1);
    $RI = [0, 0, 0.58, 0.9, 1.12, 1.24, 1.32, 1.41][$n] ?? 1.12;
    $CR = $CI / $RI;

    return [
        'CR' => $CR,
        'is_consistent' => $CR < AHP_CONSISTENCY_THRESHOLD,
        'eigenvector' => $eigenvector,
        'lambda_max' => $lambdaMax
    ];
}

function displayAhpCalculation($matrix, $consistency) {
    $n = count($matrix);
    $eigenvector = $consistency['eigenvector'] ?? array_fill(0, $n, 0);
    $cr = $consistency['CR'] ?? 0;
    $is_consistent = $consistency['is_consistent'] ?? false;
    
    $criteria = ['Season', 'Weather', 'Event', 'Gender', 'Comfort'];
    
    $html = '<div class="ahp-process">';
    $html .= '<div class="process-header">';
    $html .= '<h3><i class="fas fa-project-diagram"></i> Proses Analisis Hierarki (AHP)</h3>';
    $html .= '<div class="process-progress">';
    $html .= '<div class="step active"><span>1</span>Matriks</div>';
    $html .= '<div class="step active"><span>2</span>Normalisasi</div>';
    $html .= '<div class="step active"><span>3</span>Konsistensi</div>';
    $html .= '<div class="step active"><span>4</span>Hasil</div>';
    $html .= '</div></div>';
    
    // 1. Matriks Perbandingan Berpasangan
    $html .= '<div class="calculation-step">';
    $html .= '<h4><i class="fas fa-table"></i> 1. Matriks Perbandingan Berpasangan</h4>';
    $html .= '<div class="matrix-container">';
    $html .= '<table class="pairwise-matrix">';
    $html .= '<tr><th>Kriteria</th>';
    foreach ($criteria as $c) {
        $html .= '<th>' . $c . '</th>';
    }
    $html .= '</tr>';
    
    foreach ($matrix as $i => $row) {
        $html .= '<tr>';
        $html .= '<th>' . $criteria[$i] . '</th>';
        foreach ($row as $j => $value) {
            $class = '';
            if ($i == $j) $class = 'diagonal';
            elseif ($i < $j) $class = 'upper';
            else $class = 'lower';
            
            $html .= '<td class="' . $class . '">' . number_format($value, 3) . '</td>';
        }
        $html .= '</tr>';
    }
    $html .= '</table>';
    $html .= '</div>';
    $html .= '</div>';
    
// 2. Normalisasi Matriks
$columnSums = array_fill(0, $n, 0);
foreach ($matrix as $row) {
    foreach ($row as $j => $val) {
        $columnSums[$j] += $val;
    }
}

    $html .= '<div class="calculation-step">';
    $html .= '<h4><i class="fas fa-calculator"></i> 2. Normalisasi Matriks</h4>';
    $html .= '<div class="normalization-explain">';
    $html .= '<p>Normalisasi dilakukan dengan membagi setiap nilai dalam kolom dengan jumlah kolom tersebut:</p>';
    $html .= '<div class="formula-container">';
    $html .= '<span class="formula">a<sub>ij</sub> = <div class="fraction">';
    $html .= '<span class="numerator">x<sub>ij</sub></span>';
    $html .= '<span class="denominator">Σx<sub>ij</sub></span>';
    $html .= '</div></span>';
    $html .= '</div>';
    $html .= '</div>';

    $html .= '<div class="matrix-container">';
    $html .= '<table class="normalized-matrix">';
    $html .= '<thead><tr><th class="corner-header">Kriteria</th>';

    foreach ($criteria as $c) {
        $html .= '<th>' . $c . '</th>';
    }
    $html .= '<th class="eigenvector-header">Eigenvector</th></tr></thead>';

    $html .= '<tbody>';
    foreach ($matrix as $i => $row) {
        $html .= '<tr>';
        $html .= '<th>' . $criteria[$i] . '</th>';
        
        foreach ($row as $j => $val) {
            $normalized = $val / $columnSums[$j];
            $highlight = ($i == $j) ? 'diagonal-cell' : '';
            $html .= '<td class="' . $highlight . '">' . number_format($normalized, 3) . '</td>';
        }
        
        $html .= '<td class="eigenvalue-cell"><span class="eigenvalue-pill">' . number_format($eigenvector[$i], 3) . '</span></td>';
        $html .= '</tr>';
    }
    $html .= '</tbody>';

    // Baris jumlah kolom
    $html .= '<tfoot><tr><th>Jumlah</th>';
    foreach ($columnSums as $sum) {
        $html .= '<td class="sum-cell">' . number_format($sum, 3) . '</td>';
    }
    $html .= '<td class="sum-eigenvalue">' . number_format(array_sum($eigenvector), 3) . '</td>';
    $html .= '</tr></tfoot>';

    $html .= '</table>';
    $html .= '</div>'; // matrix-container
    $html .= '</div>'; // calculation-step
    // 3. Uji Konsistensi
    $html .= '<div class="calculation-step">';
    $html .= '<h4><i class="fas fa-check-circle"></i> 3. Uji Konsistensi</h4>';
    $html .= '<div class="consistency-card ' . ($is_consistent ? 'consistent' : 'inconsistent') . '">';
    $html .= '<div class="consistency-header">';
    $html .= '<i class="fas ' . ($is_consistent ? 'fa-check' : 'fa-exclamation-triangle') . '"></i>';
    $html .= '<h4>Hasil Uji Konsistensi</h4>';
    $html .= '</div>';
    $html .= '<div class="consistency-metrics">';
    $html .= '<div class="metric highlight">';
    $html .= '<div class="metric-label">Consistency Ratio (CR)</div>';
    $html .= '<div class="metric-value">' . number_format($cr, 3) . '</div>';
    $html .= '</div>';
    $html .= '<div class="metric">';
    $html .= '<div class="metric-label">Threshold</div>';
    $html .= '<div class="metric-value">' . AHP_CONSISTENCY_THRESHOLD . '</div>';
    $html .= '</div>';
    $html .= '<div class="metric">';
    $html .= '<div class="metric-label">Status</div>';
    $html .= '<div class="metric-value">' . ($is_consistent ? 'Konsisten' : 'Tidak Konsisten') . '</div>';
    $html .= '</div>';
    $html .= '</div>';
    $html .= '<div class="consistency-result">';
    $html .= '<p>CR < ' . AHP_CONSISTENCY_THRESHOLD . ' menunjukkan matriks perbandingan ' . ($is_consistent ? 'konsisten' : 'tidak konsisten') . ' dan ' . ($is_consistent ? 'dapat' : 'tidak dapat') . ' digunakan untuk pengambilan keputusan.</p>';
    $html .= '</div>';
    $html .= '</div>';
    $html .= '</div>';
    
    // 4. Bobot Prioritas
    $html .= '<div class="calculation-step">';
    $html .= '<h4><i class="fas fa-weight-hanging"></i> 4. Bobot Prioritas Kriteria</h4>';
    $html .= '<div class="weights-container">';
    $html .= '<div class="weights-chart">';
    
    foreach ($eigenvector as $i => $weight) {
        $html .= '<div class="weight-item">';
        $html .= '<div class="weight-info">';
        $html .= '<div class="weight-icon" style="background: ' . getColorForIndex($i) . '">';
        $html .= '<i class="' . getIconForCriteria($criteria[$i]) . '"></i>';
        $html .= '</div>';
        $html .= '<div class="weight-label">' . $criteria[$i] . '</div>';
        $html .= '<div class="weight-value">' . number_format($weight * 100, 1) . '%</div>';
        $html .= '</div>';
        $html .= '<div class="weight-bar-container">';
        $html .= '<div class="weight-bar" style="width: ' . ($weight * 100) . '%; background: ' . getColorForIndex($i) . '"></div>';
        $html .= '</div>';
        $html .= '</div>';
    }
    
    $html .= '</div>';
    $html .= '<div class="weights-summary">';
    $html .= '<h4><i class="fas fa-info-circle"></i> Informasi Bobot</h4>';
    $html .= '<p>Bobot prioritas menunjukkan tingkat kepentingan relatif setiap kriteria:</p>';
    $html .= '<ul>';
    
    arsort($eigenvector);
    foreach ($eigenvector as $i => $weight) {
        $html .= '<li>';
        $html .= '<span style="background: ' . getColorForIndex($i) . '; width: 12px; height: 12px; border-radius: 2px; display: inline-block;"></span>';
        $html .= $criteria[$i] . ': ' . number_format($weight * 100, 1) . '%';
        $html .= '</li>';
    }
    
    $html .= '</ul>';
    $html .= '</div>';
    $html .= '</div>';
    $html .= '</div>';
    
    $html .= '</div>';
    
    return $html;
}

function getColorForIndex($index) {
    $colors = ['#6a11cb', '#2575fc', '#1abc9c', '#f1c40f', '#e74c3c'];
    return $colors[$index % count($colors)];
}

function getIconForCriteria($criteria) {
    $icons = [
        'Season' => 'fa-sun',
        'Weather' => 'fa-cloud',
        'Event' => 'fa-calendar',
        'Gender' => 'fa-venus-mars',
        'Comfort' => 'fa-couch'
    ];
    return $icons[$criteria] ?? 'fa-circle';
}