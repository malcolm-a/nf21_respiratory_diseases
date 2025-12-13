"""
Gradient Boosting Model for COPD Prediction with Lag Analysis
"""

from sklearn.ensemble import GradientBoostingRegressor
from sklearn.metrics import r2_score

from data_prep import prepare_data, DISEASES, DISEASE_SHORT_NAMES

# =============================================================================
# LAG ANALYSIS: Find optimal lag for each disease
# =============================================================================
print("LAG ANALYSIS BY DISEASE")
print("="*60)

for disease in DISEASES:
    short_name = DISEASE_SHORT_NAMES[disease]
    print(f"\n{short_name}:")
    
    for lag in [0, 3, 6, 9]:
        data = prepare_data(target_disease=disease, lag_years=lag)
        
        model = GradientBoostingRegressor(n_estimators=100, max_depth=5, random_state=42)
        model.fit(data.X_train, data.y_train)
        
        r2 = r2_score(data.y_test, model.predict(data.X_test))
        print(f"  Lag {lag} years | R² = {r2:.4f}")
