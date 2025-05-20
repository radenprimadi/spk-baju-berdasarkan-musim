<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo $pageTitle ?? 'SPK AHP Pemilihan Outfit'; ?></title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="../assets/css/style.css">
    <link rel="stylesheet" href="../assets/css/result.css">
    <style>
        :root {
            --primary-color: #6a11cb;
            --secondary-color: #2575fc;
            --accent-color: #f1c40f;
            --text-dark: #2c3e50;
            --text-light: #7f8c8d;
            --bg-light: #f8f9fa;
            --success-color: #2ecc71;
            --warning-color: #e74c3c;
            --base-spacing: 20px;
            --section-spacing: 40px;
            --card-spacing: 15px;
            --element-spacing: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="header-content">
                <h1><i class="fas fa-tshirt"></i> <?php echo $pageHeader ?? 'SPK AHP: Pemilihan Outfit Terbaik'; ?></h1>
                <?php if (isset($pageSubheader)): ?>
                    <p class="subtitle"><?php echo $pageSubheader; ?></p>
                <?php endif; ?>
            </div>
            <div class="header-bg"></div>
        </div>