//+------------------------------------------------------------------+
//|                                                        MTLib.mqh |
//|                                              Alireza Khodakarami |
//|                         https://www.youtube.com/@YourTradeMaster |
//+------------------------------------------------------------------+
#property copyright "Alireza Khodakarami"
#property link      "https://www.youtube.com/@YourTradeMaster"
//+------------------------------------------------------------------+
//| Include files                                                    |
//+------------------------------------------------------------------+
#include "..\Defines.mqh"
#include "Translator.mqh"

string program_name = "MTCoreLib";
CTranslator trObject;
bool trInitialized = false;
//+------------------------------------------------------------------+
//| Service functions                                                |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Return the text in one of two languages                          |
//+------------------------------------------------------------------+
string TextByLanguage(const string text)
{
    if(!trInitialized)
    {
        trObject.init(program_name, COUNTRY_LANG);
        trInitialized = true;
    }
    return(trObject.tr(text));
}
//+------------------------------------------------------------------+
//| Return time with milliseconds                                    |
//+------------------------------------------------------------------+
string TimeMSCtoString(const long time_msc)
{
    return TimeToString(time_msc / 1000, TIME_DATE | TIME_MINUTES | TIME_SECONDS) + "." + IntegerToString(time_msc % 1000, 3, '0');
}
//+------------------------------------------------------------------+
//| Returns the number of decimal places in a symbol lot             |
//+------------------------------------------------------------------+
uint DigitsLots(const string symbol_name)
{
    return (int)ceil(fabs(log(SymbolInfoDouble(symbol_name, SYMBOL_VOLUME_STEP)) / log(10)));
}
//+------------------------------------------------------------------+
