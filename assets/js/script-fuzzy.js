class EnhancedFuzzyOutfitRecommender {
    constructor() {
        this.criteria = [
            { id: "season", name: "Season Compatibility", weight: 0.3 },
            { id: "weather", name: "Weather Suitability", weight: 0.25 },
            { id: "event", name: "Event Appropriateness", weight: 0.2 },
            { id: "gender", name: "Gender Preference", weight: 0.15 },
            { id: "comfort", name: "Comfort Level", weight: 0.1 }
        ];
        
        this.userPreferences = {
            priority: "balanced", // balanced, comfort, style
            climate: "tropis" // tropis, subtropis
        };
        
        this.init();
    }

    init() {
        this.setupEnhancedFuzzySets();
        this.setupDynamicRules();
        this.setupUIEventListeners();
        this.displayFuzzyDashboard();
    }

    setupEnhancedFuzzySets() {
        // Enhanced membership functions with adaptive ranges based on climate
        const climateFactor = this.userPreferences.climate === "tropis" ? 0.8 : 1.2;
        
        this.fuzzySets = {
            season: {
                poor: this.trapezoidalMF(0, 0, 2*climateFactor, 3*climateFactor),
                fair: this.triangularMF(2*climateFactor, 3*climateFactor, 5*climateFactor),
                good: this.triangularMF(3*climateFactor, 5*climateFactor, 7*climateFactor),
                excellent: this.trapezoidalMF(5*climateFactor, 7*climateFactor, 10*climateFactor, 10*climateFactor)
            },
            weather: {
                poor: this.trapezoidalMF(0, 0, 2, 3),
                fair: this.triangularMF(2, 3, 5),
                good: this.triangularMF(3, 5, 7),
                excellent: this.trapezoidalMF(5, 7, 10, 10)
            },
            event: {
                inappropriate: this.trapezoidalMF(0, 0, 2, 3),
                neutral: this.triangularMF(2, 3, 5),
                appropriate: this.triangularMF(3, 5, 7),
                perfect: this.trapezoidalMF(5, 7, 10, 10)
            },
            gender: {
                mismatch: this.trapezoidalMF(0, 0, 2, 3),
                neutral: this.triangularMF(2, 3, 5),
                match: this.triangularMF(3, 5, 7),
                excellent: this.trapezoidalMF(5, 7, 10, 10)
            },
            comfort: {
                uncomfortable: this.trapezoidalMF(0, 0, 2, 3),
                acceptable: this.triangularMF(2, 3, 5),
                comfortable: this.triangularMF(3, 5, 7),
                very_comfortable: this.trapezoidalMF(5, 7, 10, 10)
            }
        };
        
        // Output membership functions
        this.outputMF = {
            reject: this.trapezoidalMF(0, 0, 20, 30),
            consider: this.triangularMF(20, 40, 60),
            recommend: this.triangularMF(50, 70, 85),
            top_pick: this.trapezoidalMF(75, 90, 100, 100)
        };
    }

    // More sophisticated membership functions
    trapezoidalMF(a, b, c, d) {
        return (x) => Math.max(0, Math.min(
            (x - a)/(b - a), 
            1, 
            (d - x)/(d - c)
        ));
    }

    triangularMF(a, b, c) {
        return (x) => Math.max(0, Math.min(
            (x - a)/(b - a), 
            (c - x)/(c - b))
        );
    }

    // Dynamic rules based on user preferences
    setupDynamicRules() {
        const baseRules = [
            // Basic rules
            ['excellent', 'excellent', 'perfect', 'excellent', 'very_comfortable', 'top_pick'],
            ['good', 'good', 'appropriate', 'match', 'comfortable', 'recommend'],
            ['fair', 'fair', 'neutral', 'neutral', 'acceptable', 'consider'],
            ['poor', 'poor', 'inappropriate', 'mismatch', 'uncomfortable', 'reject']
        ];
        
        // Priority-specific rules
        if (this.userPreferences.priority === "comfort") {
            baseRules.push(
                ['fair', 'fair', 'neutral', 'neutral', 'comfortable', 'consider'],
                ['good', 'good', 'appropriate', 'match', 'very_comfortable', 'recommend']
            );
            // Increase weight for comfort
            this.criteria.find(c => c.id === "comfort").weight = 0.3;
        } 
        else if (this.userPreferences.priority === "style") {
            baseRules.push(
                ['excellent', 'good', 'perfect', 'excellent', 'acceptable', 'recommend'],
                ['good', 'fair', 'appropriate', 'match', 'acceptable', 'consider']
            );
            // Increase weight for event and gender
            this.criteria.find(c => c.id === "event").weight = 0.25;
            this.criteria.find(c => c.id === "gender").weight = 0.2;
        }
        
        this.rules = baseRules;
    }

    // Enhanced fuzzification with validation
    fuzzify(criterion, value) {
        if (value < 0 || value > 10) {
            console.warn(`Value ${value} out of range for ${criterion}`);
            value = Math.max(0, Math.min(10, value));
        }
        
        const result = {};
        for (const [label, mf] of Object.entries(this.fuzzySets[criterion])) {
            const membership = mf(value);
            if (membership > 0.01) { // Ignore negligible memberships
                result[label] = membership;
            }
        }
        return result;
    }

    // Rule application with weights
    applyWeightedRules(inputs) {
        const firedRules = [];
        
        for (const rule of this.rules) {
            let strength = 1;
            let totalWeight = 0;
            
            for (let i = 0; i < this.criteria.length; i++) {
                const criterion = this.criteria[i];
                const fuzzyValue = inputs[criterion.id][rule[i]] || 0;
                const weightedValue = fuzzyValue * criterion.weight;
                
                strength = Math.min(strength, weightedValue);
                totalWeight += criterion.weight;
            }
            
            if (strength > 0) {
                firedRules.push({
                    output: rule[5],
                    strength: strength * (totalWeight/this.criteria.length) // Normalize
                });
            }
        }
        
        return firedRules;
    }

    // Improved defuzzification with multiple methods
    defuzzify(firedRules, method = 'centroid') {
        if (firedRules.length === 0) return 0;
        
        if (method === 'centroid') {
            return this.centroidMethod(firedRules);
        } else if (method === 'max_av') {
            return this.maxAverageMethod(firedRules);
        }
        return 0;
    }

    centroidMethod(firedRules) {
        const step = 0.5;
        let numerator = 0;
        let denominator = 0;
        
        for (let x = 0; x <= 100; x += step) {
            let maxMembership = 0;
            
            for (const rule of firedRules) {
                const membership = this.outputMF[rule.output](x);
                maxMembership = Math.max(maxMembership, Math.min(rule.strength, membership));
            }
            
            numerator += x * maxMembership;
            denominator += maxMembership;
        }
        
        return denominator === 0 ? 0 : numerator / denominator;
    }

    maxAverageMethod(firedRules) {
        const outputPeaks = {
            reject: 15,
            consider: 40,
            recommend: 70,
            top_pick: 90
        };
        
        let sum = 0;
        let totalStrength = 0;
        
        for (const rule of firedRules) {
            sum += outputPeaks[rule.output] * rule.strength;
            totalStrength += rule.strength;
        }
        
        return totalStrength === 0 ? 0 : sum / totalStrength;
    }

    // Calculate comprehensive outfit score
    calculateEnhancedScore(outfit) {
        const fuzzyInputs = {};
        
        // Normalize and fuzzify all criteria
        for (const criterion of this.criteria) {
            const rawValue = outfit[`${criterion.id}_score`] * 10; // Scale to 0-10
            fuzzyInputs[criterion.id] = this.fuzzify(criterion.id, rawValue);
        }
        
        // Apply rules and defuzzify
        const firedRules = this.applyWeightedRules(fuzzyInputs);
        const score = this.defuzzify(firedRules, 'centroid');
        
        return {
            score: score,
            details: {
                criteria: fuzzyInputs,
                firedRules: firedRules,
                explanation: this.generateExplanation(firedRules, score)
            }
        };
    }

    // Generate natural language explanation
    generateExplanation(firedRules, score) {
        const strongestRule = firedRules.reduce((max, rule) => 
            rule.strength > max.strength ? rule : max, {strength: 0});
        
        let explanation = "";
        
        if (score >= 80) {
            explanation = "Outfit ini sangat cocok untuk Anda! ";
            explanation += "Memenuhi hampir semua kriteria penting dengan sangat baik.";
        } 
        else if (score >= 60) {
            explanation = "Outfit ini direkomendasikan. ";
            explanation += "Memiliki keseimbangan yang baik antara berbagai faktor.";
        }
        else if (score >= 40) {
            explanation = "Outfit ini bisa dipertimbangkan. ";
            explanation += "Beberapa aspek mungkin kurang ideal tetapi masih dapat digunakan.";
        }
        else {
            explanation = "Outfit ini tidak direkomendasikan. ";
            explanation += "Terlalu banyak kriteria penting yang tidak terpenuhi.";
        }
        
        explanation += ` (Kekuatan keputusan: ${(strongestRule.strength * 100).toFixed(1)}%)`;
        return explanation;
    }

    // UI Integration
    setupUIEventListeners() {
        // Connect with season/weather selection from original script.js
        document.getElementById('season_type').addEventListener('change', (e) => {
            this.userPreferences.climate = e.target.value;
            this.setupEnhancedFuzzySets();
            this.updateRecommendations();
        });
        
        // Add priority selector if not exists
        const prioritySelect = document.getElementById('priority_preference') || 
            this.createPrioritySelector();
        prioritySelect.addEventListener('change', (e) => {
            this.userPreferences.priority = e.target.value;
            this.setupDynamicRules();
            this.updateRecommendations();
        });
    }

    createPrioritySelector() {
        const container = document.createElement('div');
        container.className = 'preference-selector';
        container.innerHTML = `
            <label for="priority_preference">Prioritas Utama:</label>
            <select id="priority_preference">
                <option value="balanced">Seimbang</option>
                <option value="comfort">Kenyamanan</option>
                <option value="style">Gaya</option>
            </select>
        `;
        document.querySelector('.form-container').prepend(container);
        return document.getElementById('priority_preference');
    }

    // Display comprehensive dashboard
    displayFuzzyDashboard() {
        const container = document.getElementById('fuzzy-results');
        container.innerHTML = `
            <div class="fuzzy-dashboard">
                <div class="dashboard-header">
                    <h2><i class="fas fa-tshirt"></i> Sistem Rekomendasi Fuzzy</h2>
                    <div class="user-preferences">
                        <span>Iklim: ${this.userPreferences.climate}</span>
                        <span>Prioritas: ${this.userPreferences.priority}</span>
                    </div>
                </div>
                
                <div class="dashboard-content">
                    <div class="membership-visualization">
                        <h3>Visualisasi Fungsi Keanggotaan</h3>
                        <div class="membership-charts">
                            ${this.criteria.map(c => `
                                <div class="chart-container">
                                    <h4>${c.name}</h4>
                                    <canvas id="${c.id}-chart" width="200" height="150"></canvas>
                                </div>
                            `).join('')}
                        </div>
                    </div>
                    
                    <div class="recommendation-results">
                        <h3>Hasil Rekomendasi</h3>
                        <div id="dynamic-recommendations">
                            <!-- Will be filled by updateRecommendations() -->
                        </div>
                    </div>
                </div>
            </div>
        `;
        
        this.renderMembershipCharts();
        this.updateRecommendations();
    }

    renderMembershipCharts() {
        // Implement chart rendering using Chart.js or similar
        this.criteria.forEach(criterion => {
            const ctx = document.getElementById(`${criterion.id}-chart`).getContext('2d');
            // Render chart for each criterion's membership functions
        });
    }

    updateRecommendations() {
        // In real app, this would use actual outfit data
        const sampleOutfits = [
            { id: 1, name: "Casual Summer Outfit", 
              season_score: 0.9, weather_score: 0.8, event_score: 0.7, 
              gender_score: 0.8, comfort_score: 0.85 },
            { id: 2, name: "Formal Winter Set", 
              season_score: 0.6, weather_score: 0.7, event_score: 0.9, 
              gender_score: 0.9, comfort_score: 0.6 }
        ];
        
        const recommendationsHTML = sampleOutfits.map(outfit => {
            const evaluation = this.calculateEnhancedScore(outfit);
            return `
                <div class="outfit-recommendation ${this.getRatingClass(evaluation.score)}">
                    <h4>${outfit.name}</h4>
                    <div class="score-bar">
                        <div class="score-fill" style="width: ${evaluation.score}%">
                            ${evaluation.score.toFixed(1)}%
                        </div>
                    </div>
                    <div class="rating">${this.getRatingLabel(evaluation.score)}</div>
                    <div class="explanation">${evaluation.details.explanation}</div>
                    <button class="details-btn" data-outfit-id="${outfit.id}">
                        Lihat Detail Analisis
                    </button>
                </div>
            `;
        }).join('');
        
        document.getElementById('dynamic-recommendations').innerHTML = recommendationsHTML;
        
        // Add event listeners for detail buttons
        document.querySelectorAll('.details-btn').forEach(btn => {
            btn.addEventListener('click', () => this.showDetailedAnalysis(btn.dataset.outfitId));
        });
    }

    showDetailedAnalysis(outfitId) {
        // Implement detailed analysis modal
        console.log(`Showing details for outfit ${outfitId}`);
    }

    getRatingLabel(score) {
        if (score >= 85) return "Top Pick ★★★★★";
        if (score >= 70) return "Highly Recommended ★★★★";
        if (score >= 55) return "Recommended ★★★";
        if (score >= 40) return "Consider ★★";
        return "Not Recommended ★";
    }

    getRatingClass(score) {
        if (score >= 80) return "excellent";
        if (score >= 60) return "good";
        if (score >= 40) return "average";
        return "poor";
    }
}

// Initialize when ready
document.addEventListener('DOMContentLoaded', () => new EnhancedFuzzyOutfitRecommender());