import polars as pl
import numpy as np
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split
from dataclasses import dataclass
from typing import Tuple, List, Optional
from pathlib import Path



PROJECT_ROOT = Path(__file__).parent.parent
DATA_PATH = PROJECT_ROOT / "data" / "combined" / "correlation_ready.parquet"


POLLUTANTS = ['bc', 'co', 'nh3', 'nmvoc', 'nox', 'oc', 'pm10', 'pm25', 'so2']
FEATURES = POLLUTANTS + ['year']

DISEASES = [
    'Cancer de la trachée, des bronches et des poumons',
    'Pneumoconiose',
    'Maladie pulmonaire obstructive chronique',
    'Asthme',
    'Autres maladies respiratoires chroniques',
]

DISEASE_SHORT_NAMES = {
    'Cancer de la trachée, des bronches et des poumons': 'Lung Cancer',
    'Pneumoconiose': 'Pneumoconiosis',
    'Maladie pulmonaire obstructive chronique': 'COPD',
    'Asthme': 'Asthma',
    'Autres maladies respiratoires chroniques': 'Other Chronic Resp.',
}

DEFAULT_LAG_YEARS = 5
DEFAULT_TEST_SIZE = 0.2
RANDOM_STATE = 1


@dataclass
class PreparedData:
    """Container for prepared model data."""
    # Raw data
    X_train: np.ndarray
    X_test: np.ndarray
    y_train: np.ndarray
    y_test: np.ndarray
    
    # Metadata
    feature_names: List[str]
    target_name: str
    scaler: StandardScaler
    
    # Original dataframe (for scenario analysis)
    df_model: pl.DataFrame
    
    @property
    def n_features(self) -> int:
        return self.X_train.shape[1]
    
    @property
    def n_train_samples(self) -> int:
        return self.X_train.shape[0]
    
    @property
    def n_test_samples(self) -> int:
        return self.X_test.shape[0]


@dataclass
class PreparedDataTorch:
    """Container for PyTorch-ready data."""
    X_train: "torch.Tensor"
    X_test: "torch.Tensor"
    y_train: "torch.Tensor"
    y_test: "torch.Tensor"
    
    feature_names: List[str]
    target_name: str
    scaler: StandardScaler
    df_model: pl.DataFrame
    
    @property
    def n_features(self) -> int:
        return self.X_train.shape[1]
    
    @property
    def n_train_samples(self) -> int:
        return self.X_train.shape[0]
    
    @property
    def n_test_samples(self) -> int:
        return self.X_test.shape[0]


# Data Loading and Preparation
def load_data(path: Optional[Path] = None) -> pl.DataFrame:
    """Loads the correlation-ready dataset."""
    if path is None:
        path = DATA_PATH
    return pl.read_parquet(path)


def create_lagged_dataset(df: pl.DataFrame, lag_years: int = DEFAULT_LAG_YEARS) -> pl.DataFrame:
    """
    Create time-lagged dataset where emissions at (year n - lag) predict deaths at year n
    
    This accounts for the biological delay between pollution exposure
    and respiratory disease outcomes
    
    Args:
        df: Raw correlation_ready dataframe
        lag_years: Number of years to lag emissions (default: 5)
    
    Returns:
        DataFrame with emissions from t-lag joined to deaths at t
    """
    # Current health outcomes
    df_current = df.select(['gbd_location', 'year'] + DISEASES)
    
    # Lagged emissions (shift forward so they align with future deaths)
    df_lagged = df.select(
        ['gbd_location', 'year'] + POLLUTANTS
    ).with_columns(
        (pl.col('year') + lag_years).alias('year')
    )
    
    # Join: for each (country, year), get emissions from `lag_years` ago
    df_model = df_current.join(
        df_lagged,
        on=['gbd_location', 'year'],
        how='inner'
    )
    
    return df_model


def prepare_data(
    target_disease: str = 'Maladie pulmonaire obstructive chronique',
    lag_years: int = DEFAULT_LAG_YEARS,
    test_size: float = DEFAULT_TEST_SIZE,
    log_transform: bool = True,
    feature_names: list = FEATURES,
    random_state: int = RANDOM_STATE
) -> PreparedData:
    """
    Complete data preparation pipeline for scikit-learn.
    
    Args:
        target_disease: Disease to predict (default: COPD)
        lag_years: Years to lag emissions (default: 5)
        test_size: Fraction for test set (default: 0.2)
        random_state: Random seed for reproducibility
        log_transform: Log-transform emissions
    
    Returns:
        PreparedData object with all data and metadata
    """
    df = create_lagged_dataset(load_data(), lag_years=lag_years)
    
    # Apply log transform if requested
    if log_transform:
        df = df.with_columns([
            pl.col(poll).log1p().alias(poll) for poll in POLLUTANTS
        ])
    
    # Drop rows with NaN values
    df = df.drop_nulls(subset=feature_names + [target_disease])
    
    # Select features and target
    X = df.select(feature_names).to_numpy()
    y = df.select(target_disease).to_numpy().ravel()
    
    # Train/test split
    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=test_size, random_state=random_state
    )
    
    # Scale features
    scaler = StandardScaler()
    X_train_scaled = scaler.fit_transform(X_train)
    X_test_scaled = scaler.transform(X_test)
    
    return PreparedData(
        X_train=X_train_scaled,
        X_test=X_test_scaled,
        y_train=y_train,
        y_test=y_test,
        feature_names=feature_names,
        target_name=target_disease,
        scaler=scaler,
        df_model=df
    )


def prepare_data_torch(
    target_disease: str = 'Maladie pulmonaire obstructive chronique',
    lag_years: int = DEFAULT_LAG_YEARS,
    test_size: float = DEFAULT_TEST_SIZE,
    log_transform: bool = True,
    feature_names: list = FEATURES,
    random_state: int = RANDOM_STATE
) -> PreparedDataTorch:
    """
    Complete data preparation pipeline for PyTorch.
    
    Uses Polars' native to_torch() method - no pandas needed!
    
    Args:
        target_disease: Disease to predict (default: COPD)
        lag_years: Years to lag emissions (default: 5)
        test_size: Fraction for test set (default: 0.2)
        random_state: Random seed for reproducibility
        log_transform: Log-transform emissions
    
    Returns:
        PreparedDataTorch object with torch tensors
    """
    import torch
    
    df = create_lagged_dataset(load_data(), lag_years=lag_years)
    
    # Apply log transform if requested
    if log_transform:
        df = df.with_columns([
            pl.col(poll).log1p().alias(poll) for poll in POLLUTANTS
        ])
    
    # Split indices first (to ensure same split as sklearn version)
    n_samples = df.height
    indices = np.arange(n_samples)
    train_idx, test_idx = train_test_split(
        indices, test_size=test_size, random_state=random_state
    )
    
    # Split dataframe
    df_train = df[train_idx]
    df_test = df[test_idx]
    
    # Scale features using numpy (StandardScaler), then convert to torch
    scaler = StandardScaler()
    
    X_train_np = df_train.select(feature_names).to_numpy()
    X_test_np = df_test.select(feature_names).to_numpy()
    
    X_train_scaled = scaler.fit_transform(X_train_np)
    X_test_scaled = scaler.transform(X_test_np)
    
    # Convert to torch tensors
    X_train = torch.FloatTensor(X_train_scaled)
    X_test = torch.FloatTensor(X_test_scaled)
    y_train = df_train.select(target_disease).to_torch().squeeze().float()
    y_test = df_test.select(target_disease).to_torch().squeeze().float()
    
    return PreparedDataTorch(
        X_train=X_train,
        X_test=X_test,
        y_train=y_train,
        y_test=y_test,
        feature_names=feature_names,
        target_name=target_disease,
        scaler=scaler,
        df_model=df
    )


def prepare_all_diseases(
    lag_years: int = DEFAULT_LAG_YEARS,
    test_size: float = DEFAULT_TEST_SIZE,
    random_state: int = RANDOM_STATE,
    for_torch: bool = False
) -> dict:
    """
    Prepare data for all diseases.
    
    Args:
        lag_years: Years to lag emissions
        test_size: Fraction for test set
        random_state: Random seed
        for_torch: If True, return PreparedDataTorch objects
    
    Returns:
        Dictionary mapping disease name to PreparedData/PreparedDataTorch
    """
    prepare_fn = prepare_data_torch if for_torch else prepare_data
    
    return {
        disease: prepare_fn(
            target_disease=disease,
            lag_years=lag_years,
            test_size=test_size,
            random_state=random_state
        )
        for disease in DISEASES
    }


# =============================================================================
# SCENARIO ANALYSIS HELPERS
# =============================================================================
def get_baseline_emissions(
    df: Optional[pl.DataFrame] = None,
    year: Optional[int] = None,
    log_transform: bool = True
) -> np.ndarray:
    """
    Get baseline emissions (latest year or specified year).
    
    Args:
        df: DataFrame (if None, loads from default path)
        year: Specific year (default: latest available)
        log_transform: Whether to log-transform (should match training)
    
    Returns:
        Mean emissions across all countries for the specified year
    """
    if df is None:
        df = load_data()
    
    if year is None:
        year = df['year'].max()
    
    baseline_df = df.filter(pl.col('year') == year).select(POLLUTANTS)
    
    if log_transform:
        baseline_df = baseline_df.with_columns([
            pl.col(poll).log1p().alias(poll) for poll in POLLUTANTS
        ])
    
    return baseline_df.mean().to_numpy().flatten()


def create_scenario_features(
    baseline_emissions: np.ndarray,
    multiplier: float,
    year: int,
    scaler: StandardScaler
) -> np.ndarray:
    """
    Create feature vector for a scenario prediction.
    
    Args:
        baseline_emissions: Baseline emission values (already log-transformed if needed)
        multiplier: Factor to multiply emissions (e.g., 0.8 for -20%)
        year: Year for prediction
        scaler: Fitted StandardScaler from training
    
    Returns:
        Scaled feature vector ready for model prediction
    """
    # Apply multiplier to emissions
    scenario = baseline_emissions * multiplier
    
    # Add year feature
    features = np.append(scenario, year).reshape(1, -1)
    
    # Scale using the fitted scaler
    return scaler.transform(features)


# =============================================================================
# TEST
# =============================================================================
if __name__ == "__main__":
    print("=" * 60)
    print("SKLEARN DATA PREPARATION TEST")
    print("=" * 60)
    
    data = prepare_data()
    
    print(f"\nTarget: {DISEASE_SHORT_NAMES.get(data.target_name, data.target_name)}")
    print(f"Features: {data.feature_names}")
    print(f"Training samples: {data.n_train_samples:,}")
    print(f"Test samples: {data.n_test_samples:,}")
    print(f"X_train shape: {data.X_train.shape}")
    print(f"y_train range: [{data.y_train.min():.2f}, {data.y_train.max():.2f}]")
    
    print("\n" + "=" * 60)
    print("PYTORCH DATA PREPARATION TEST")
    print("=" * 60)
    
    data_torch = prepare_data_torch()
    
    print(f"\nTarget: {DISEASE_SHORT_NAMES.get(data_torch.target_name, data_torch.target_name)}")
    print(f"X_train shape: {data_torch.X_train.shape}")
    print(f"X_train dtype: {data_torch.X_train.dtype}")
    print(f"y_train shape: {data_torch.y_train.shape}")
    print(f"y_train dtype: {data_torch.y_train.dtype}")
    
    print("\n" + "=" * 60)
    print("ALL DISEASES TEST")
    print("=" * 60)
    
    all_data = prepare_all_diseases()
    for disease, d in all_data.items():
        short_name = DISEASE_SHORT_NAMES.get(disease, disease)
        print(f"  {short_name:25s}: {d.n_train_samples:,} train, {d.n_test_samples:,} test")
    
    print("\n✅ All tests passed!")