# hrl_agent.py – hierarchical RL router (stub)
import random, logging

STRATEGIES = ["BULLISH_CONTINUATION","RANGE_MEAN_REVERT",
              "BEARISH_BREAKOUT","WAIT"]

class HRLAgent:
    def __init__(self, model_path:str|None=None):
        # load weights later
        self.step = 0

    def select_strategy(self, context:dict, bias_proba:float)->str:
        """
        Very naive: choose strat based on bias.
        """
        self.step += 1
        if bias_proba>0.7:
            return "BULLISH_CONTINUATION"
        if bias_proba<0.3:
            return "BEARISH_BREAKOUT"
        return random.choice(["RANGE_MEAN_REVERT","WAIT"])
