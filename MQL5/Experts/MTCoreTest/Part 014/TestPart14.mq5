//+------------------------------------------------------------------+
//|                                                   TestPart14.mq5 |
//|                                              Alireza Khodakarami |
//|                         https://www.youtube.com/@YourTradeMaster |
//+------------------------------------------------------------------+
#property copyright "Alireza Khodakarami"
#property link "https://www.youtube.com/@YourTradeMaster"
#property version "1.00"
//--- includes
#include <MT Core Lib/Base/Engine.mqh>
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int       OnInit()
{
    //--- Fast check of a symbol object
    string   smb = Symbol();
    CSymbol *sy  = new CSymbol(SYMBOL_STATUS_FX, smb);
    if(sy != NULL)
    {
        sy.Refresh();
        sy.RefreshRates();
        sy.Print();
        delete sy;
    }
    //---
    return (INIT_SUCCEEDED);
}
//---------------------------------------------------