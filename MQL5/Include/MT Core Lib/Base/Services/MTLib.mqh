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
#include "TimerCounter.mqh"
#include "Translator.mqh"

string program_name = "MTCoreLib";
CTranslator trObject;
bool trInitialized = false;
//+------------------------------------------------------------------+
//| Service functions                                                |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Display all sorting enumeration constants in the journal         |
//+------------------------------------------------------------------+
void EnumNumbersTest()
{
    string enm = "ENUM_SORT_ORDERS_MODE";
    string t = StringSubstr(enm, 5, 5) + "BY";
    Print("Search of the values of the enumaration ", enm, ":");
    ENUM_SORT_ORDERS_MODE type = 0;
    while(StringFind(EnumToString(type), t) == 0)
    {
        Print(enm, "[", type, "]=", EnumToString(type));
        if(type > 500) break;
        type++;
    }
    Print("\nNumber of members of the ", enm, "=", type);
}
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
//| Return the minimum symbol lot                                    |
//+------------------------------------------------------------------+
double MinimumLots(const string symbol_name) 
{ 
    return SymbolInfoDouble(symbol_name,SYMBOL_VOLUME_MIN);
}
//+------------------------------------------------------------------+
//| Return the maximum symbol lot                                    |
//+------------------------------------------------------------------+
double MaximumLots(const string symbol_name) 
{ 
    return SymbolInfoDouble(symbol_name,SYMBOL_VOLUME_MAX);
}
//+------------------------------------------------------------------+
//| Return the symbol lot change step                                |
//+------------------------------------------------------------------+
double StepLots(const string symbol_name) 
{ 
    return SymbolInfoDouble(symbol_name,SYMBOL_VOLUME_STEP);
}
//+------------------------------------------------------------------+
//| Return the normalized lot                                        |
//+------------------------------------------------------------------+
double NormalizeLot(const string symbol_name, double order_lots) 
{
    double ml = SymbolInfoDouble(symbol_name, SYMBOL_VOLUME_MIN);
    double mx = SymbolInfoDouble(symbol_name, SYMBOL_VOLUME_MAX);
    double ln = NormalizeDouble(order_lots, int(ceil(fabs(log(ml) / log(10)))));
    return(ln < ml ? ml : ln > mx ? mx : ln);
}
//+------------------------------------------------------------------+
//| Return correct StopLoss relative to StopLevel                    |
//+------------------------------------------------------------------+
double CorrectStopLoss(const string symbol_name, const ENUM_ORDER_TYPE order_type, const double price_set, const double stop_loss, const int spread_multiplier=2)
{
   if(stop_loss == 0) return 0;
   int lv = StopLevel(symbol_name, spread_multiplier), dg = (int)SymbolInfoInteger(symbol_name, SYMBOL_DIGITS);
   double pt = SymbolInfoDouble(symbol_name,SYMBOL_POINT);
   double price = (order_type == ORDER_TYPE_BUY ? SymbolInfoDouble(symbol_name, SYMBOL_BID) : order_type == ORDER_TYPE_SELL ? SymbolInfoDouble(symbol_name, SYMBOL_ASK) : price_set);
   return(
            order_type == ORDER_TYPE_BUY       || 
            order_type == ORDER_TYPE_BUY_LIMIT || 
            order_type == ORDER_TYPE_BUY_STOP
#ifdef __MQL5__                                 ||
            order_type == ORDER_TYPE_BUY_STOP_LIMIT
#endif ? 
            NormalizeDouble(fmin(price-lv*pt,stop_loss),dg) :
            NormalizeDouble(fmax(price+lv*pt,stop_loss),dg)
        );
}
//+------------------------------------------------------------------+
//| Return correct StopLoss relative to StopLevel                    |
//+------------------------------------------------------------------+
double CorrectStopLoss(const string symbol_name, const ENUM_ORDER_TYPE order_type, const double price_set, const int stop_loss, const int spread_multiplier = 2)
{
    if(stop_loss == 0) return 0;
    int lv = StopLevel(symbol_name, spread_multiplier), dg = (int)SymbolInfoInteger(symbol_name, SYMBOL_DIGITS);
    double pt = SymbolInfoDouble(symbol_name, SYMBOL_POINT);
    double price = (order_type == ORDER_TYPE_BUY ? SymbolInfoDouble(symbol_name, SYMBOL_BID) : order_type == ORDER_TYPE_SELL ? SymbolInfoDouble(symbol_name, SYMBOL_ASK) : price_set);
    return(
        order_type == ORDER_TYPE_BUY        || 
        order_type == ORDER_TYPE_BUY_LIMIT  || 
        order_type == ORDER_TYPE_BUY_STOP
#ifdef __MQL5__                             ||
        order_type == ORDER_TYPE_BUY_STOP_LIMIT
#endif 
            ? NormalizeDouble(fmin(price - lv * pt, price - stop_loss * pt), dg) 
            : NormalizeDouble(fmax(price + lv * pt, price + stop_loss * pt), dg)
         );
}
//+------------------------------------------------------------------+
//| Return correct TakeProfit relative to StopLevel                  |
//+------------------------------------------------------------------+
double CorrectTakeProfit(const string symbol_name, const ENUM_ORDER_TYPE order_type, const double price_set, const double take_profit, const int spread_multiplier = 2)
{
    if(take_profit == 0) return 0;
    int lv = StopLevel(symbol_name, spread_multiplier), dg = (int)SymbolInfoInteger(symbol_name, SYMBOL_DIGITS);
    double pt = SymbolInfoDouble(symbol_name, SYMBOL_POINT);
    double price = (order_type == ORDER_TYPE_BUY ? SymbolInfoDouble(symbol_name, SYMBOL_BID) : order_type == ORDER_TYPE_SELL ? SymbolInfoDouble(symbol_name, SYMBOL_ASK) : price_set);
    return
        (order_type == ORDER_TYPE_BUY       ||
         order_type == ORDER_TYPE_BUY_LIMIT ||
         order_type == ORDER_TYPE_BUY_STOP
#ifdef __MQL5__                  ||
         order_type == ORDER_TYPE_BUY_STOP_LIMIT
#endif 
            ? NormalizeDouble(fmax(price + lv * pt, take_profit), dg) 
            : NormalizeDouble(fmin(price - lv * pt, take_profit), dg)
        );
}
//+------------------------------------------------------------------+
//| Return correct TakeProfit relative to StopLevel                  |
//+------------------------------------------------------------------+
double CorrectTakeProfit(const string symbol_name, const ENUM_ORDER_TYPE order_type, const double price_set, const int take_profit, const int spread_multiplier = 2)
{
    if(take_profit == 0) return 0;
    int lv = StopLevel(symbol_name, spread_multiplier), dg = (int)SymbolInfoInteger(symbol_name, SYMBOL_DIGITS);
    double pt = SymbolInfoDouble(symbol_name, SYMBOL_POINT);
    double price = (order_type == ORDER_TYPE_BUY ? SymbolInfoDouble(symbol_name, SYMBOL_BID) : order_type == ORDER_TYPE_SELL ? SymbolInfoDouble(symbol_name, SYMBOL_ASK) : price_set);
    return
        (order_type == ORDER_TYPE_BUY       ||
         order_type == ORDER_TYPE_BUY_LIMIT ||
         order_type == ORDER_TYPE_BUY_STOP
#ifdef __MQL5__                  ||
         order_type == ORDER_TYPE_BUY_STOP_LIMIT
#endif 
            ? ::NormalizeDouble(::fmax(price + lv * pt, price + take_profit * pt), dg) 
            : ::NormalizeDouble(::fmin(price - lv * pt, price - take_profit * pt), dg)
        );
}
//+------------------------------------------------------------------+
//| Return the correct order placement price                         |
//| relative to StopLevel                                            |
//+------------------------------------------------------------------+
double CorrectPricePending(const string symbol_name, const ENUM_ORDER_TYPE order_type, const double price_set, const double price = 0, const int spread_multiplier = 2)
{
    double pt = SymbolInfoDouble(symbol_name, SYMBOL_POINT), pp = 0;
    int lv = StopLevel(symbol_name, spread_multiplier), dg = (int)SymbolInfoInteger(symbol_name, SYMBOL_DIGITS);
    switch(order_type)
    {
    case ORDER_TYPE_BUY_LIMIT        : pp = (price == 0 ? SymbolInfoDouble(symbol_name, SYMBOL_ASK) : price); return NormalizeDouble(fmin(pp - lv * pt, price_set), dg);
    case ORDER_TYPE_BUY_STOP         :
    case ORDER_TYPE_BUY_STOP_LIMIT   : pp = (price == 0 ? SymbolInfoDouble(symbol_name, SYMBOL_ASK) : price); return NormalizeDouble(fmax(pp + lv * pt, price_set), dg);
    case ORDER_TYPE_SELL_LIMIT       : pp = (price == 0 ? SymbolInfoDouble(symbol_name, SYMBOL_BID) : price); return NormalizeDouble(fmax(pp + lv * pt, price_set), dg);
    case ORDER_TYPE_SELL_STOP        :
    case ORDER_TYPE_SELL_STOP_LIMIT  : pp = (price == 0 ? SymbolInfoDouble(symbol_name, SYMBOL_BID) : price); return NormalizeDouble(fmin(pp - lv * pt, price_set), dg);
    default                          : Print(DFUN, TextByLanguage("Invalid order type: "), EnumToString(order_type)); return 0;
    }
}
//+------------------------------------------------------------------+
//| Return the correct order placement price                         |
//| relative to StopLevel                                            |
//+------------------------------------------------------------------+
double CorrectPricePending(const string symbol_name, const ENUM_ORDER_TYPE order_type, const int distance_set, const double price = 0, const int spread_multiplier = 2)
{
    double pt = SymbolInfoDouble(symbol_name, SYMBOL_POINT), pp = 0;
    int lv = StopLevel(symbol_name, spread_multiplier), dg = (int)SymbolInfoInteger(symbol_name, SYMBOL_DIGITS);
    switch(order_type)
    {
    case ORDER_TYPE_BUY_LIMIT        : pp = (price == 0 ? SymbolInfoDouble(symbol_name, SYMBOL_ASK) : price); return NormalizeDouble(fmin(pp - lv * pt, pp - distance_set * pt), dg);
    case ORDER_TYPE_BUY_STOP         :
    case ORDER_TYPE_BUY_STOP_LIMIT   : pp = (price == 0 ? SymbolInfoDouble(symbol_name, SYMBOL_ASK) : price); return NormalizeDouble(fmax(pp + lv * pt, pp + distance_set * pt), dg);
    case ORDER_TYPE_SELL_LIMIT       : pp = (price == 0 ? SymbolInfoDouble(symbol_name, SYMBOL_BID) : price); return NormalizeDouble(fmax(pp + lv * pt, pp + distance_set * pt), dg);
    case ORDER_TYPE_SELL_STOP        :
    case ORDER_TYPE_SELL_STOP_LIMIT  : pp = (price == 0 ? SymbolInfoDouble(symbol_name, SYMBOL_BID) : price); return NormalizeDouble(fmin(pp - lv * pt, pp - distance_set * pt), dg);
    default                          : Print(DFUN, TextByLanguage("Invalid order type: "), EnumToString(order_type)); return 0;
    }
}
//+------------------------------------------------------------------+
//| Check the stop level in points relative to StopLevel             |
//+------------------------------------------------------------------+
bool CheckStopLevel(const string symbol_name, const int stop_in_points, const int spread_multiplier)
{
    return(stop_in_points >= StopLevel(symbol_name, spread_multiplier));
}
//+------------------------------------------------------------------+
//| Return StopLevel in points                                       |
//+------------------------------------------------------------------+
int StopLevel(const string symbol_name, const int spread_multiplier)
{
    int spread = (int)SymbolInfoInteger(symbol_name, SYMBOL_SPREAD);
    int stop_level = (int)SymbolInfoInteger(symbol_name, SYMBOL_TRADE_STOPS_LEVEL);
    return(stop_level == 0 ? spread*spread_multiplier : stop_level);
}
//+------------------------------------------------------------------+
//| Return the order name                                            |
//+------------------------------------------------------------------+
string OrderTypeDescription(const ENUM_ORDER_TYPE type)
{
    string pref = (#ifdef __MQL5__ "Market order" #else "Position" #endif );
    return
        (
            type == ORDER_TYPE_BUY_LIMIT       ?  TextByLanguage("Buy Limit")                                                 :
            type == ORDER_TYPE_BUY_STOP        ?  TextByLanguage("Buy Stop")                                                  :
            type == ORDER_TYPE_SELL_LIMIT      ?  TextByLanguage("Sell Limit")                                                :
            type == ORDER_TYPE_SELL_STOP       ?  TextByLanguage("Sell Stop")                                                 :
#ifdef __MQL5__
            type == ORDER_TYPE_BUY_STOP_LIMIT  ?  TextByLanguage("Buy Stop Limit")                                            :
            type == ORDER_TYPE_SELL_STOP_LIMIT ?  TextByLanguage("Sell Stop Limit")                                           :
            type == ORDER_TYPE_CLOSE_BY        ?  TextByLanguage("Order for closing by")  :
#else
            type == ORDER_TYPE_BALANCE         ?  TextByLanguage("Balance operation")   :
            type == ORDER_TYPE_CREDIT          ?  TextByLanguage("Credit operation")     :
#endif
            type == ORDER_TYPE_BUY             ?  pref + TextByLanguage(" Buy")                                                 :
            type == ORDER_TYPE_SELL            ?  pref + TextByLanguage(" Sell")                                                :
            TextByLanguage("Unknown order type")
        );
}
//+------------------------------------------------------------------+
//| Return the position name                                         |
//+------------------------------------------------------------------+
string PositionTypeDescription(const ENUM_POSITION_TYPE type)
{
    return
        (
            type == POSITION_TYPE_BUY    ? TextByLanguage("Buy")  :
            type == POSITION_TYPE_SELL   ? TextByLanguage("Sell") :
            TextByLanguage("Unknown position type")
        );
}
//+------------------------------------------------------------------+
//| Return the deal name                                             |
//+------------------------------------------------------------------+
string DealTypeDescription(const ENUM_DEAL_TYPE type)
{
    return
        (
            type == DEAL_TYPE_BUY                       ?  TextByLanguage("Buy deal") :
            type == DEAL_TYPE_SELL                      ?  TextByLanguage("Sell deal") :
            type == DEAL_TYPE_BALANCE                   ?  TextByLanguage("Balance operation") :
            type == DEAL_TYPE_CREDIT                    ?  TextByLanguage("Credit") :
            type == DEAL_TYPE_CHARGE                    ?  TextByLanguage("Additional charge") :
            type == DEAL_TYPE_CORRECTION                ?  TextByLanguage("Correction") :
            type == DEAL_TYPE_BONUS                     ?  TextByLanguage("Bonus") :
            type == DEAL_TYPE_COMMISSION                ?  TextByLanguage("Additional comissions") :
            type == DEAL_TYPE_COMMISSION_DAILY          ?  TextByLanguage("Daily commission") :
            type == DEAL_TYPE_COMMISSION_MONTHLY        ?  TextByLanguage("Monthly commission") :
            type == DEAL_TYPE_COMMISSION_AGENT_DAILY    ?  TextByLanguage("Daily agent commission") :
            type == DEAL_TYPE_COMMISSION_AGENT_MONTHLY  ?  TextByLanguage("Monthly agent commission") :
            type == DEAL_TYPE_INTEREST                  ?  TextByLanguage("Accrued interest on free funds") :
            type == DEAL_TYPE_BUY_CANCELED              ?  TextByLanguage("Canceled buy transaction") :
            type == DEAL_TYPE_SELL_CANCELED             ?  TextByLanguage("Canceled sell transaction") :
            type == DEAL_DIVIDEND                       ?  TextByLanguage("Dividend operations") :
            type == DEAL_DIVIDEND_FRANKED               ?  TextByLanguage("Franked (non-taxable) dividend operations") :
            type == DEAL_TAX                            ?  TextByLanguage("Tax charges") :
            TextByLanguage("Unknown deal type")
        );
}
//+------------------------------------------------------------------+
//| Return position type by order type                               |
//+------------------------------------------------------------------+
ENUM_POSITION_TYPE PositionTypeByOrderType(ENUM_ORDER_TYPE type_order)
{
    if(
        type_order == ORDER_TYPE_BUY             ||
        type_order == ORDER_TYPE_BUY_LIMIT       ||
        type_order == ORDER_TYPE_BUY_STOP
#ifdef __MQL5__                           ||
        type_order == ORDER_TYPE_BUY_STOP_LIMIT
#endif
    ) return POSITION_TYPE_BUY;
    else if(
        type_order == ORDER_TYPE_SELL            ||
        type_order == ORDER_TYPE_SELL_LIMIT      ||
        type_order == ORDER_TYPE_SELL_STOP
#ifdef __MQL5__                           ||
        type_order == ORDER_TYPE_SELL_STOP_LIMIT
#endif
    ) return POSITION_TYPE_SELL;
    return WRONG_VALUE;
}
//+------------------------------------------------------------------+
