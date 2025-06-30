# feature_engineering.py – convert raw message ➜ ML features
import pandas as pd

# list of numeric features the model expects
COLS = ["open","high","low","close","volume",
        "is_inside_fvg","distance_to_nearest_ob","adx","rsi"]

def build_feature_vector(msg:dict)->pd.DataFrame:
    """
    Convert JSON dict from MT5 into a one‑row DataFrame of features.
    For now we fill engineered SMC fields with zeros (place‑holder).
    """
    df = pd.DataFrame([{
        "open":   msg["open"],
        "high":   msg["high"],
        "low":    msg["low"],
        "close":  msg["close"],
        "volume": msg["volume"],
        # placeholders
        "is_inside_fvg":         0,
        "distance_to_nearest_ob":0.0,
        "adx":                   20.0,
        "rsi":                   50.0,
    }])
    return df[COLS]
