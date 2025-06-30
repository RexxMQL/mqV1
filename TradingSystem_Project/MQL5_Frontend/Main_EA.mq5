//+------------------------------------------------------------------+
//|  Main_EA.mq5 – “SMC‑ML‑Bridge”  v0.1                             |
//|  Skeleton by OpenAI (2025)                                       |
//+------------------------------------------------------------------+
#property copyright "©2025"
#property version   "0.1"
#property strict

#include <Trade/Trade.mqh>
#include <Include/C_ZeroMQ_Connector.mqh>
#include <Include/C_Panel_UI.mqh>
#include <Include/C_SMC_Visuals.mqh>
#include <Include/C_Risk_Manager.mqh>

CTrade              trade;
CZeroMQ_Connector   zmq;
CPanel_UI           ui;
CSMC_Visuals        smc;
CRisk_Manager       risk;

int OnInit()
{
   zmq.Setup("tcp://127.0.0.1:5555","tcp://127.0.0.1:5556");
   ui.CreateMainPanel();
   smc.Init();
   return(INIT_SUCCEEDED);
}
//--------------------------------------------------------------------
void OnDeinit(const int reason)
{
   zmq.Close();
   ui.Destroy();
   smc.Destroy();
}
//--------------------------------------------------------------------
void OnTick()
{
   // 1) Kirim bar/tick ➜ Python
   zmq.PublishMarketData();

   // 2) Periksa perintah Python
   string cmd;
   while(zmq.PullCommand(cmd))
       ExecuteCommand(cmd);

   // 3) Gambar overlay SMC (opsional setiap bar selesai)
   smc.Refresh();
}
//--------------------------------------------------------------------
void ExecuteCommand(const string &cmd)
{
   // contoh pesan: {"type":"BUY","lot":0.05,"sl":1910.0,"tp":1925.0}
   MqlTradeRequest  req  = risk.BuildRequest(cmd,trade);
   MqlTradeResult   res;
   if(req.type!=WRONG_VALUE) trade.OrderSend(req,res);
   // TODO: tangani hasil & update UI
}
//--------------------------------------------------------------------
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
   ui.HandleChartEvent(id,lparam,dparam,sparam);
}
