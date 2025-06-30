//+------------------------------------------------------------------+
//|  C_SMC_Visuals – BOS/CHoCH & OB/FVG overlay via CCanvas          |
//+------------------------------------------------------------------+
#pragma once
#include <Canvas\Canvas.mqh>

class CSMC_Visuals
{
private:
   CCanvas canvas;
public:
   void Init()
   {
      canvas.CreateBitmapLabel(ChartID(),"SMC_CANVAS",0,0,ChartGetInteger(0,CHART_WIDTH_IN_PIXELS),
                               ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS),COLOR_FORMAT_ARGB_NORMALIZE);
   }
   //----------------------------------------------------------------
   void Refresh()
   {
      if(!canvas.IsInitialized()) return;
      canvas.Erase(0x00000000);

      // >> Contoh: gambar BOS terbaru
      double price_lastBOS = GlobalVariableGet("last_bos_price");
      if(price_lastBOS>0)
      {
         int    y = (int)ChartPriceToInteger(0,price_lastBOS,0);
         canvas.FillRectangle(0,y,ChartGetInteger(0,CHART_WIDTH_IN_PIXELS),y+1,0x55FF0000);
         canvas.TextOut(10,y-12,"BOS",0xFFFFFFFF,12);
      }
      canvas.Update();
   }
   //----------------------------------------------------------------
   void Destroy()
   {
      canvas.Destroy();
   }
};
