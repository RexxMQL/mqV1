# main_core.py – glue everything
import time, logging, json
from zeromq_bridge import ZMQBridge
from lstm_predictor import LSTMPredictor
from hrl_agent import HRLAgent
from feature_engineering import build_feature_vector

logging.basicConfig(level=logging.INFO,
                    format="%(asctime)s %(levelname)s %(message)s")

bridge = ZMQBridge()
lstm   = LSTMPredictor()
hrl    = HRLAgent()

def main_loop():
    while True:
        msg = bridge.recv_market()
        if msg is None:
            time.sleep(0.01)
            continue

        feat_df   = build_feature_vector(msg)
        bias_up   = lstm.predict_proba(feat_df)
        strat     = hrl.select_strategy(msg,bias_up)

        logging.info("Price=%.2f  Bias=%.2f  Strat=%s",msg['close'],bias_up,strat)

        # Build example trade command
        if strat=="BULLISH_CONTINUATION" and bias_up>0.8:
            cmd = {"type":"BUY",
                   "lot":0.0,                 # EA akan hitung lot
                   "sl":msg['close']-10,      # dummy 10 pips
                   "tp":msg['close']+20}
            bridge.send_command(cmd)

if __name__=="__main__":
    try:
        main_loop()
    except KeyboardInterrupt:
        print("Stopped.")
