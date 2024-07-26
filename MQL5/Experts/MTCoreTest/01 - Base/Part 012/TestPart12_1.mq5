//+------------------------------------------------------------------+
//|                                                 TestPart12_1.mq5 |
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
int OnInit()
{
    //--- Fast check of the account object
    CAccount *acc = new CAccount();
    if(acc != NULL)
    {
        acc.PrintShort();
        acc.Print();
        delete acc;
    }
    //---
    return (INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
