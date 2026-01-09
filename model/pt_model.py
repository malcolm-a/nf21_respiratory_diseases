import torch
from torch import nn
from torch.utils.data import DataLoader, TensorDataset
from sklearn.metrics import r2_score


from data_prep import prepare_data_torch, DISEASES, DISEASE_SHORT_NAMES
from pathlib import Path


class MLP(nn.Module):
    def __init__(self, n_features):
        super().__init__()
        self.layers = nn.Sequential(
            nn.Linear(n_features, 64),
            nn.ReLU(),
            nn.Linear(64, 32),
            nn.ReLU(),
            nn.Linear(32, 1)
        )
    
    def forward(self, x):
        return self.layers(x)
    

def train_model(data, epochs=400, lr=0.01):  # Lower lr, more epochs
    model = MLP(data.n_features)
    optimizer = torch.optim.Adam(model.parameters(), lr=lr)
    loss_fn = nn.MSELoss()
    
    loader = DataLoader(
        TensorDataset(data.X_train, data.y_train.unsqueeze(1)),
        batch_size=64, shuffle=True
    )
    
    for epoch in range(epochs):
        for X_batch, y_batch in loader:
            optimizer.zero_grad()
            loss = loss_fn(model(X_batch), y_batch)
            loss.backward()
            torch.nn.utils.clip_grad_norm_(model.parameters(), max_norm=1.0)  # Prevent exploding gradients
            optimizer.step()
    
    return model

# TRAIN MODEL FOR EACH DISEASE

print("PYTORCH MLP - ALL DISEASES")
print("="*50)

# Directory to save models
save_dir = Path(__file__).parent / "saved"
save_dir.mkdir(exist_ok=True)

models = {}
for disease in DISEASES:
    from data_prep import FEATURES
    data = prepare_data_torch(target_disease=disease, lag_years=0, feature_names=FEATURES)
    model = train_model(data)
    model.eval()
    with torch.no_grad():
        y_pred = model(data.X_test).numpy()
    r2 = r2_score(data.y_test.numpy(), y_pred)
    models[disease] = {'model': model, 'r2': r2, 'data': data}
    short_name = DISEASE_SHORT_NAMES[disease]
    print(f"{short_name:25s} | R² = {r2:.4f}")
    # Export model
    torch.save(model.state_dict(), save_dir / f"pt_{short_name.replace(' ', '_').lower()}.pt")
    # Optionally, export scaler as well (using joblib)
    import joblib
    joblib.dump(data.scaler, save_dir / f"pt_{short_name.replace(' ', '_').lower()}_scaler.joblib")
print(f"\nModels saved to {save_dir}")
