# lstm_predictor.py – stub wrapper.  Replace with real model later.
import numpy as np

class LSTMPredictor:
    def __init__(self, model_path:str|None=None):
        # TODO: load keras model
        self.model = None

    def predict_proba(self, df):
        """
        Return probability price will rise in horizon +15m.
        Dummy: random uniform.
        """
        return float(np.random.uniform(0,1))
