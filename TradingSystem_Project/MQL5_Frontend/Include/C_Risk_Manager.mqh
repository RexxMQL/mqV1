//+------------------------------------------------------------------+
//|  C_Risk_Manager – hitung lot & bangun order request              |
//+------------------------------------------------------------------+
#pragma once
#define MAX_RISK_PCT 5.0             // default 5 % equity / trade
class CRisk_Manager
{
public:
   // Parse JSON → bangun MqlTradeRequest (sangat sederhana)
   MqlTradeRequest BuildRequest(const string &json,CTrade &trade)
   {
      MqlTradeRequest req;  ZeroMemory(req);
      // --------- dummy parsing (gunakan fungsi JSON nyata nanti)
      if(StringFind(json,"\"type\":\"BUY\"")>=0)  req.type=ORDER_TYPE_BUY;
      else if(StringFind(json,"\"type\":\"SELL\"")>=0) req.type=ORDER_TYPE_SELL;
      else { req.type=WRONG_VALUE; return(req); }

      // lot dinamis
      double sl_price = 0, tp_price = 0;
      // extract sl/tp sederhana
      int slPos = StringFind(json,"\"sl\":");  int tpPos = StringFind(json,"\"tp\":");
      if(slPos>0)  sl_price = StringToDouble(StringSubstr(json,slPos+5,12));
      if(tpPos>0)  tp_price = StringToDouble(StringSubstr(json,tpPos+5,12));

      req.symbol   = _Symbol;
      req.volume   = CalcLot(sl_price);
      req.price    = (req.type==ORDER_TYPE_BUY)?SymbolInfoDouble(_Symbol,SYMBOL_ASK)
                                               :SymbolInfoDouble(_Symbol,SYMBOL_BID);
      req.sl       = sl_price;
      req.tp       = tp_price;
      req.deviation= 3;
      req.magic    = 123456;
      req.action   = TRADE_ACTION_DEAL;
      req.type_filling = ORDER_FILLING_FOK;
      return(req);
   }
   //----------------------------------------------------------------
   double CalcLot(double sl_price)
   {
      double equity  = AccountInfoDouble(ACCOUNT_EQUITY);
      double risk$   = equity * (MAX_RISK_PCT/100.0);

      double price   = SymbolInfoDouble(_Symbol,SYMBOL_BID);
      double tickVal = SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE);
      double pipVal  = (tickVal/SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE));

      double sl_pips = MathAbs(price - sl_price)/_Point;
      double lot     = (risk$ / (sl_pips * pipVal));
      // normalisasi lot step
      double step    = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP);
      lot = MathFloor(lot/step)*step;
      return(lot);
   }
};
