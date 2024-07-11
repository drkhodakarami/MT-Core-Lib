//+------------------------------------------------------------------+
//|                                                 TestPart15_1.mq5 |
//|                                              Alireza Khodakarami |
//|                         https://www.youtube.com/@YourTradeMaster |
//+------------------------------------------------------------------+
#property copyright "Alireza Khodakarami"
#property link "https://www.youtube.com/@YourTradeMaster"
#property version "1.00"
//--- includes
#include <MT Core Lib/Base/Engine.mqh>
//--- input variables
input ENUM_SYMBOLS_MODE InpModeUsedSymbols = SYMBOLS_MODE_CURRENT;                                                              // Mode of used symbols list
input string            InpUsedSymbols     = "EURUSD,AUDUSD,EURAUD,EURCAD,EURGBP,EURJPY,EURUSD,GBPUSD,NZDUSD,USDCAD,USDJPY";    // List of used symbols (comma - separator)
//--- global variables
CEngine                 engine;
string                  used_symbols;
string                  array_used_symbols[];
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int                     OnInit()
{
    //--- Fill in the array of used symbols
    used_symbols = InpUsedSymbols;
    CreateUsedSymbolsArray(InpModeUsedSymbols, used_symbols, array_used_symbols);

    //--- Set the type of the used symbol list in the symbol collection
    engine.SetUsedSymbols(array_used_symbols);

    //--- Fast check of the symbol object collection
    CArrayObj *list   = engine.GetListAllUsedSymbols();
    CSymbol   *symbol = NULL;
    if(list != NULL)
    {
        int total = list.Total();
        for(int i = 0; i < total; i++)
        {
            symbol = list.At(i);
            if(symbol == NULL) continue;
            symbol.Refresh();
            symbol.RefreshRates();
            symbol.PrintShort();
            if(InpModeUsedSymbols < SYMBOLS_MODE_MARKET_WATCH) symbol.Print();
        }
    }
    //---
    return (INIT_SUCCEEDED);
}
//---------------------------------------------------