# zeromq_bridge.py – helper send/recv JSON over ZMQ
import json, zmq, logging

class ZMQBridge:
    def __init__(self,
                 data_endpoint="tcp://*:5555",
                 cmd_endpoint ="tcp://127.0.0.1:5556"):
        ctx = zmq.Context.instance()
        self.sub = ctx.socket(zmq.SUB)              # subscribe to market data
        self.sub.bind(data_endpoint)
        self.sub.setsockopt_string(zmq.SUBSCRIBE,'')   # all topics

        self.push = ctx.socket(zmq.PUSH)            # send commands to EA
        self.push.connect(cmd_endpoint)

    # --------------------------------------------------------------
    def recv_market(self, flags=zmq.NOBLOCK):
        try:
            raw = self.sub.recv(flags=flags).decode()
            return json.loads(raw)
        except zmq.Again:
            return None

    def send_command(self, payload:dict):
        self.push.send_string(json.dumps(payload))
        logging.debug("CMD  ➜  MT5  %s",payload)
