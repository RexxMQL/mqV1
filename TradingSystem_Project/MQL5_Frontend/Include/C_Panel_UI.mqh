//+------------------------------------------------------------------+
//| C_Panel_UI  – dark‑theme control panel                           |
//+------------------------------------------------------------------+
#pragma once
#define PANEL_NAME "SMC_ML_PANEL"
class CPanel_UI
  {
  private:
     long chart_id;
  public:
     void CreateMainPanel()
     {
        chart_id = ChartID();
        // panel utama (rectangle label drag‑able)
        ObjectCreate(chart_id,PANEL_NAME,OBJ_RECTANGLE_LABEL,0,0,0);
        ObjectSetInteger(chart_id,PANEL_NAME,OBJPROP_CORNER,CORNER_LEFT_UPPER);
        ObjectSetInteger(chart_id,PANEL_NAME,OBJPROP_XDISTANCE,20);
        ObjectSetInteger(chart_id,PANEL_NAME,OBJPROP_YDISTANCE,30);
        ObjectSetInteger(chart_id,PANEL_NAME,OBJPROP_XSIZE,240);
        ObjectSetInteger(chart_id,PANEL_NAME,OBJPROP_YSIZE,130);
        ObjectSetInteger(chart_id,PANEL_NAME,OBJPROP_COLOR,clrBlack);
        ObjectSetInteger(chart_id,PANEL_NAME,OBJPROP_BACK,false);
        ObjectSetInteger(chart_id,PANEL_NAME,OBJPROP_STYLE,STYLE_SOLID);
        ObjectSetInteger(chart_id,PANEL_NAME,OBJPROP_WIDTH,1);
        ObjectSetInteger(chart_id,PANEL_NAME,OBJPROP_RAY,false);
        ObjectSetString (chart_id,PANEL_NAME,OBJPROP_TEXT,"SMC‑ML v0.1");
        ObjectSetInteger(chart_id,PANEL_NAME,OBJPROP_FONTSIZE,10);

        // tombol master
        CreateButton("BTN_MASTER",  30,"AUTO‑TRADE",10,25);
        // tombol mode
        CreateButton("BTN_MODE",   150,"SIGNAL‑ONLY",10,25);
     }
     //--------------------------------------------------------------
     void CreateButton(string name,int x,string label,int w,int h)
     {
        string obj=name;
        ObjectCreate(chart_id,obj,OBJ_BUTTON,0,0,0);
        ObjectSetInteger(chart_id,obj,OBJPROP_CORNER,CORNER_LEFT_UPPER);
        ObjectSetInteger(chart_id,obj,OBJPROP_XDISTANCE,x);
        ObjectSetInteger(chart_id,obj,OBJPROP_YDISTANCE,50);
        ObjectSetInteger(chart_id,obj,OBJPROP_XSIZE,w);
        ObjectSetInteger(chart_id,obj,OBJPROP_YSIZE,h);
        ObjectSetString (chart_id,obj,OBJPROP_TEXT,label);
        ObjectSetInteger(chart_id,obj,OBJPROP_BGCOLOR,clrDimGray);
        ObjectSetInteger(chart_id,obj,OBJPROP_COLOR,clrWhite);
     }
     //--------------------------------------------------------------
     void HandleChartEvent(const int id,const long &l,const double &d,const string &s)
     {
        if(id==CHARTEVENT_OBJECT_CLICK)
        {
           if(s=="BTN_MASTER")
             ObjectSetString(chart_id,"BTN_MASTER",OBJPROP_TEXT,
                 (ObjectGetString(chart_id,"BTN_MASTER",OBJPROP_TEXT)=="AUTO‑TRADE"?"PAUSED":"AUTO‑TRADE"));
           // TODO: toggle variable & kirim info ke Python bila perlu
        }
     }
     //--------------------------------------------------------------
     void Destroy()
     {
        ObjectsDeleteAll(chart_id,0,OBJ_RECTANGLE_LABEL);
        ObjectsDeleteAll(chart_id,0,OBJ_BUTTON);
     }
  };
