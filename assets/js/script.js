document.addEventListener('DOMContentLoaded', function() {
    // Ambil elemen-elemen form yang akan dimanipulasi
    const seasonTypeSelect = document.getElementById('season_type');
    const subSeasonSelect = document.getElementById('sub_season');
    const weatherSelect = document.getElementById('weather');
    
    // Opsi musim berdasarkan jenis iklim
    const seasonOptions = {
        tropis: [
            {value: 'kemarau', label: 'Kemarau'},
            {value: 'hujan', label: 'Hujan'}
        ],
        subtropis: [
            {value: 'semi', label: 'Semi'},
            {value: 'panas', label: 'Panas'},
            {value: 'gugur', label: 'Gugur'},
            {value: 'dingin', label: 'Dingin'}
        ]
    };
    
    // Opsi cuaca berdasarkan sub musim
    const weatherOptions = {
        kemarau: [
            {value: 'cerah', label: 'Cerah'},
            {value: 'panas', label: 'Panas'},
            {value: 'kering', label: 'Kering'}
        ],
        hujan: [
            {value: 'hujan', label: 'Hujan'},
            {value: 'lembab', label: 'Lembab'},
            {value: 'gerimis', label: 'Gerimis'}
        ],
        semi: [
            {value: 'sejuk', label: 'Sejuk'},
            {value: 'cerah', label: 'Cerah'},
            {value: 'berangin', label: 'Berangin'}
        ],
        panas: [
            {value: 'panas', label: 'Panas'},
            {value: 'gerah', label: 'Gerah'},
            {value: 'kering', label: 'Kering'},
            {value: 'cerah', label: 'Cerah'}
        ],
        gugur: [
            {value: 'sejuk', label: 'Sejuk'},
            {value: 'berangin', label: 'Berangin'},
            {value: 'hujan-ringan', label: 'Hujan Ringan'}
        ],
        dingin: [
            {value: 'dingin', label: 'Dingin'},
            {value: 'beku', label: 'Beku'},
            {value: 'salju', label: 'Salju'},
            {value: 'berangin', label: 'Berangin'}
        ]
    };

    // Fungsi untuk mengisi dropdown sub-seasons
    function updateSubSeasonOptions(seasonType) {
        subSeasonSelect.innerHTML = '<option value="">Pilih Sub Musim...</option>'; // Reset opsi
        weatherSelect.innerHTML = '<option value="">Pilih Cuaca...</option>'; // Reset cuaca
        
        if (seasonType && seasonOptions[seasonType]) {
            seasonOptions[seasonType].forEach(function(option) {
                const opt = document.createElement('option');
                opt.value = option.value;
                opt.textContent = option.label;
                subSeasonSelect.appendChild(opt);
            });
        }
    }

    // Fungsi untuk mengisi dropdown weather berdasarkan sub-seasons
    function updateWeatherOptions(subSeason) {
        weatherSelect.innerHTML = '<option value="">Pilih Cuaca...</option>'; // Reset cuaca
        
        if (subSeason && weatherOptions[subSeason]) {
            weatherOptions[subSeason].forEach(function(option) {
                const opt = document.createElement('option');
                opt.value = option.value;
                opt.textContent = option.label;
                weatherSelect.appendChild(opt);
            });
        }
    }

    // Event listener untuk mengubah sub-seasons saat jenis iklim dipilih
    seasonTypeSelect.addEventListener('change', function() {
        const selectedSeason = this.value;
        console.log(`Selected season type: ${selectedSeason}`);
        updateSubSeasonOptions(selectedSeason); // Update sub-seasons sesuai iklim
    });
    
    // Event listener untuk mengubah cuaca saat sub-musim dipilih
    subSeasonSelect.addEventListener('change', function() {
        const selectedSubSeason = this.value;
        console.log(`Selected sub-season: ${selectedSubSeason}`);
        updateWeatherOptions(selectedSubSeason); // Update cuaca sesuai sub-musim
    });

    // Inisialisasi dropdown saat halaman dimuat jika sudah ada nilai yang dipilih
    const initialSeason = seasonTypeSelect.value;
    if (initialSeason) {
        updateSubSeasonOptions(initialSeason);
    }

    const initialSubSeason = subSeasonSelect.value;
    if (initialSubSeason) {
        updateWeatherOptions(initialSubSeason);
    }
});
