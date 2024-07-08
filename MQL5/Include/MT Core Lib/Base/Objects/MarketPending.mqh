//+------------------------------------------------------------------+
//|                                                MarketPending.mqh |
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
//| Market pending order                                             |
//+------------------------------------------------------------------+
class CMarketPending : public COrder
{
public:
    //--- Constructor
                     CMarketPending(const ulong ticket = 0) : COrder(ORDER_STATUS_MARKET_PENDING, ticket) {}
    //--- Supported order properties (1) real, (2) integer
    virtual bool      SupportProperty(ENUM_ORDER_PROP_DOUBLE property);
    virtual bool      SupportProperty(ENUM_ORDER_PROP_INTEGER property);
};
//+------------------------------------------------------------------+
//| Return 'true' if an order supports a passed                      |
//| integer property, otherwise return 'false'                       |
//+------------------------------------------------------------------+
bool CMarketPending::SupportProperty(ENUM_ORDER_PROP_INTEGER property)
{
    if(property == ORDER_PROP_PROFIT_PT         ||
            property == ORDER_PROP_DEAL_ORDER        ||
            property == ORDER_PROP_DEAL_ENTRY        ||
            property == ORDER_PROP_TIME_UPDATE       ||
            property == ORDER_PROP_TIME_CLOSE        ||
            property == ORDER_PROP_TIME_CLOSE_MSC    ||
            property == ORDER_PROP_TIME_UPDATE_MSC   ||
            property == ORDER_PROP_TICKET_FROM       ||
            property == ORDER_PROP_TICKET_TO         ||
            property == ORDER_PROP_CLOSE_BY_SL       ||
            property == ORDER_PROP_CLOSE_BY_TP
      ) return false;
    return true;
}
//+------------------------------------------------------------------+
//| Return 'true' if an order supports a passed                      |
//| real property, otherwise return 'false'                          |
//+------------------------------------------------------------------+
bool CMarketPending::SupportProperty(ENUM_ORDER_PROP_DOUBLE property)
{
    if(property == ORDER_PROP_COMMISSION  ||
            property == ORDER_PROP_SWAP        ||
            property == ORDER_PROP_PROFIT      ||
            property == ORDER_PROP_PROFIT_FULL ||
            property == ORDER_PROP_PRICE_CLOSE
      ) return false;
    return true;
}
//+------------------------------------------------------------------+
