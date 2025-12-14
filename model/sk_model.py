"""
Gradient Boosting Models for All Respiratory Diseases
"""

from sklearn.ensemble import GradientBoostingRegressor
from sklearn.metrics import r2_score

from data_prep import prepare_data, DISEASES, DISEASE_SHORT_NAMES, POLLUTANTS

import joblib
from pathlib import Path

# TRAIN MODEL FOR EACH DISEASE

print("GRADIENT BOOSTING - ALL DISEASES")
print("="*50)

models = {}
for disease in DISEASES:
    from data_prep import FEATURES
    data = prepare_data(target_disease=disease, lag_years=0, feature_names=FEATURES)
    
    # fine tuned for COPD with gridsearchCV
    model = GradientBoostingRegressor(n_estimators=300, max_depth=7, learning_rate=0.1, random_state=20)
    model.fit(data.X_train, data.y_train)
    
    r2 = r2_score(data.y_test, model.predict(data.X_test))
    
    models[disease] = {'model': model, 'r2': r2, 'data': data}
    
    short_name = DISEASE_SHORT_NAMES[disease]
    print(f"{short_name:25s} | R² = {r2:.4f}")

# FEATURE IMPORTANCES

print("\n" + "="*50)
print("TOP 5 POLLUTANTS PER DISEASE")
print("="*50)

for disease, m in models.items():
    importances = dict(zip(FEATURES, m['model'].feature_importances_))
    top = sorted(importances.items(), key=lambda x: -x[1])[:5]
    
    short_name = DISEASE_SHORT_NAMES[disease]
    top_str = ", ".join([f"{p} ({v:.0%})" for p, v in top])
    print(f"{short_name:25s} | {top_str}")
    
# SAVE MODELS

save_dir = Path(__file__).parent / "saved"
save_dir.mkdir(exist_ok=True)

joblib.dump(models, save_dir / "sk_models.joblib")
print(f"\nModels saved to {save_dir / 'sk_models.joblib'}")