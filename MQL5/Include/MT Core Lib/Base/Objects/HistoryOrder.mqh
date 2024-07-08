//+------------------------------------------------------------------+
//|                                                 HistoryOrder.mqh |
//|                                              Alireza Khodakarami |
//|                         https://www.youtube.com/@YourTradeMaster |
//+------------------------------------------------------------------+
#property copyright "Alireza Khodakarami"
#property link      "https://www.youtube.com/@YourTradeMaster"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Include files                                                    |
//+------------------------------------------------------------------+
#include "Order.mqh"
//+------------------------------------------------------------------+
//| Historical market order                                          |
//+------------------------------------------------------------------+
class CHistoryOrder : public COrder
{
public:
    //--- Constructor
                     CHistoryOrder(const ulong ticket) : COrder(ORDER_STATUS_HISTORY_ORDER, ticket) {}
    //--- Supported integer properties of an order
    virtual bool      SupportProperty(ENUM_ORDER_PROP_INTEGER property);
    //--- Supported real properties of an order
    virtual bool      SupportProperty(ENUM_ORDER_PROP_DOUBLE property);
};
//+------------------------------------------------------------------+
//| Return 'true' if an order supports a passed property,            |
//| otherwise return 'false'                                         |
//+------------------------------------------------------------------+
bool CHistoryOrder::SupportProperty(ENUM_ORDER_PROP_INTEGER property)
{
    if(property == ORDER_PROP_TIME_EXP       ||
            property == ORDER_PROP_DEAL_ENTRY     ||
            property == ORDER_PROP_TIME_UPDATE    ||
            property == ORDER_PROP_TIME_UPDATE_MSC
#ifdef __MQL5__                     ||
            property == ORDER_PROP_PROFIT_PT
#endif
      ) return false;
    return true;
}
//+------------------------------------------------------------------+
//| Return 'true' if an order supports a passed property,            |
//| otherwise return 'false'                                         |
//+------------------------------------------------------------------+
bool CHistoryOrder::SupportProperty(ENUM_ORDER_PROP_DOUBLE property)
{
#ifdef __MQL5__
    if(property == ORDER_PROP_PROFIT      ||
            property == ORDER_PROP_PROFIT_FULL ||
            property == ORDER_PROP_SWAP        ||
            property == ORDER_PROP_COMMISSION  ||
            property == ORDER_PROP_PRICE_STOP_LIMIT
      ) return false;
#endif
    return true;
}
//+------------------------------------------------------------------+
