//+------------------------------------------------------------------+
//|                                                 TestPart12_2.mq5 |
//|                                              Alireza Khodakarami |
//|                         https://www.youtube.com/@YourTradeMaster |
//+------------------------------------------------------------------+
#property copyright "Alireza Khodakarami"
#property link "https://www.youtube.com/@YourTradeMaster"
#property version "1.00"
//--- includes
#include <MT Core Lib/Base/Engine.mqh>
//--- input variables
input bool InpFullProperties = false;    // Show full accounts properties
//--- global variables
CEngine    engine;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int        OnInit()
{
    //--- Fast check of the account object collection
    CArrayObj *list = engine.GetListAllAccounts();
    if(list != NULL)
    {
        int total = list.Total();
        if(total > 0) Print("\n", TextByLanguage("=========== List of saved accounts ==========="));
        for(int i = 0; i < total; i++)
        {
            CAccount *account = list.At(i);
            if(account == NULL) continue;
            Sleep(100);
            if(InpFullProperties)
                account.Print();
            else
                account.PrintShort();
        }
    }
    //---
    return (INIT_SUCCEEDED);
}
//---------------------------------------------------