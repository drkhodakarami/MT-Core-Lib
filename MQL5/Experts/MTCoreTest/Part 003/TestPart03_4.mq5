//+------------------------------------------------------------------+
//|                                           TestDoEasyPart02_5.mq5 |
//|                                              Alireza Khodakarami |
//|                         https://www.youtube.com/@YourTradeMaster |
//+------------------------------------------------------------------+
#property copyright "Alireza Khodakarami"
#property link      "https://www.youtube.com/@YourTradeMaster"
#property version   "1.00"
//--- includes
#include <MT Core Lib\Base\Engine.mqh>
//--- global variables
CEngine        engine;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
    return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
{
    engine.OnTimer();
}
//+------------------------------------------------------------------+
