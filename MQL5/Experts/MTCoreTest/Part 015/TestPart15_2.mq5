//+------------------------------------------------------------------+
//|                                                 TestPart15_2.mq5 |
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
        }
    }
    //--- Get the minimum and maximum values
    //--- get the current account properties (we need the number of decimal places for the account currency)
    CAccount *account = engine.GetAccountCurrent();
    if(account != NULL)
    {
        int index_min = 0, index_max = 0, dgc = (int) account.CurrencyDigits();
        //--- If working with the Market Watch window, leave only visible symbols in the list
        if(InpModeUsedSymbols == SYMBOLS_MODE_MARKET_WATCH) list = CSelect::BySymbolProperty(list, SYMBOL_PROP_VISIBLE, true, EQUAL);

        //--- min/max swap long
        index_min = CSelect::FindSymbolMin(list, SYMBOL_PROP_SWAP_LONG);    // symbol index in the collection list with the minimum swap long
        index_max = CSelect::FindSymbolMax(list, SYMBOL_PROP_SWAP_LONG);    // symbol index in the collection list with the maximum swap long
        if(index_max != WRONG_VALUE && index_min != WRONG_VALUE)
        {
            symbol = list.At(index_min);
            if(symbol != NULL) Print(TextByLanguage("Minimum swap long for a symbol "), symbol.Name(), " = ", NormalizeDouble(symbol.SwapLong(), dgc));
            symbol = list.At(index_max);
            if(symbol != NULL) Print(TextByLanguage("Maximum swap long for a symbol "), symbol.Name(), " = ", NormalizeDouble(symbol.SwapLong(), dgc));
        }

        //--- min/max swap short
        index_min = CSelect::FindSymbolMin(list, SYMBOL_PROP_SWAP_SHORT);    // symbol index in the collection list with the minimum swap short
        index_max = CSelect::FindSymbolMax(list, SYMBOL_PROP_SWAP_SHORT);    // symbol index in the collection list with the maximum swap short
        if(index_max != WRONG_VALUE && index_min != WRONG_VALUE)
        {
            symbol = list.At(index_min);
            if(symbol != NULL) Print(TextByLanguage("Minimum swap short for a symbol "), symbol.Name(), " = ", NormalizeDouble(symbol.SwapShort(), dgc));
            symbol = list.At(index_max);
            if(symbol != NULL) Print(TextByLanguage("Maximum swap short for a symbol "), symbol.Name(), " = ", NormalizeDouble(symbol.SwapShort(), dgc));
        }

        //--- min/max spread
        index_min = CSelect::FindSymbolMin(list, SYMBOL_PROP_SPREAD);    // symbol index in the collection list with the minimum spread
        index_max = CSelect::FindSymbolMax(list, SYMBOL_PROP_SPREAD);    // symbol index in the collection list with the maximum spread
        if(index_max != WRONG_VALUE && index_min != WRONG_VALUE)
        {
            symbol = list.At(index_min);
            if(symbol != NULL) Print(TextByLanguage("Minimum symbol spread "), symbol.Name(), " = ", symbol.Spread());
            symbol = list.At(index_max);
            if(symbol != NULL) Print(TextByLanguage("Maximum symbol spread "), symbol.Name(), " = ", symbol.Spread());
        }
    }
    //---
    return (INIT_SUCCEEDED);
}
//---------------------------------------------------