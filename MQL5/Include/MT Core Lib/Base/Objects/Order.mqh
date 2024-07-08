//+------------------------------------------------------------------+
//|                                                        Order.mqh |
//|                                              Alireza Khodakarami |
//|                         https://www.youtube.com/@YourTradeMaster |
//+------------------------------------------------------------------+
#property copyright "Alireza Khodakarami"
#property link      "https://www.youtube.com/@YourTradeMaster"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Include files                                                    |
//+------------------------------------------------------------------+
#include <Object.mqh>
#include "..\MTLib.mqh"
//+------------------------------------------------------------------+
//| Abstract order class                                             |
//+------------------------------------------------------------------+
class COrder : public CObject
{
private:
    ulong             m_ticket;                                    // Selected order/deal ticket (MQL5)
    long              m_long_prop[ORDER_PROP_INTEGER_TOTAL];       // Integer properties
    double            m_double_prop[ORDER_PROP_DOUBLE_TOTAL];      // Real properties
    string            m_string_prop[ORDER_PROP_STRING_TOTAL];      // String properties

    //--- Return the array index the double property is actually located at
    int               IndexProp(ENUM_ORDER_PROP_DOUBLE property) const { return(int)property-ORDER_PROP_INTEGER_TOTAL;                        }
    //--- Return the array index the string property is actually located at
    int               IndexProp(ENUM_ORDER_PROP_STRING property) const { return(int)property-ORDER_PROP_INTEGER_TOTAL-ORDER_PROP_DOUBLE_TOTAL;}
    
public:
    //--- Default constructor
                     COrder(void) {;}
protected:
    //--- Protected parametric constructor
                     COrder(ENUM_ORDER_STATUS order_status, const ulong ticket);

    //--- Get and return integer properties of a selected order from its parameters
    long              OrderMagicNumber(void)        const;
    long              OrderTicket(void)             const;
    long              OrderTicketFrom(void)         const;
    long              OrderTicketTo(void)           const;
    long              OrderPositionID(void)         const;
    long              OrderPositionByID(void)       const;
    long              OrderOpenTimeMSC(void)        const;
    long              OrderCloseTimeMSC(void)       const;
    long              OrderType(void)               const;
    long              OrderTypeByDirection(void)    const;
    long              OrderTypeFilling(void)        const;
    long              OrderTypeTime(void)           const;
    long              OrderReason(void)             const;
    long              DealOrder(void)               const;
    long              DealEntry(void)               const;
    bool              OrderCloseByStopLoss(void)    const;
    bool              OrderCloseByTakeProfit(void)  const;
    datetime          OrderOpenTime(void)           const;
    datetime          OrderCloseTime(void)          const;
    datetime          OrderExpiration(void)         const;
    datetime          PositionTimeUpdate(void)      const;
    datetime          PositionTimeUpdateMSC(void)   const;

    //--- Get and return real properties of a selected order from its parameters: (1) open price, (2) close price, (3) profit,
    //---  (4) commission, (5) swap, (6) volume, (7) unexecuted volume (8) StopLoss price, (9) TakeProfit price (10) StopLimit order price
    double            OrderOpenPrice(void)          const;
    double            OrderClosePrice(void)         const;
    double            OrderProfit(void)             const;
    double            OrderCommission(void)         const;
    double            OrderSwap(void)               const;
    double            OrderVolume(void)             const;
    double            OrderVolumeCurrent(void)      const;
    double            OrderStopLoss(void)           const;
    double            OrderTakeProfit(void)         const;
    double            OrderPriceStopLimit(void)     const;

    //--- Get and return string properties of a selected order from its parameters: (1) symbol, (2) comment, (3) ID at an exchange
    string            OrderSymbol(void)             const;
    string            OrderComment(void)            const;
    string            OrderExternalID(void)         const;

    //--- Return (1) reason, (2) direction, (3) deal type
    string            GetReasonDescription(const long reason)            const;
    string            GetEntryDescription(const long deal_entry)         const;
    string            GetTypeDealDescription(const long type_deal)       const;

public:
    //--- Return (1) integer, (2) real and (3) string order properties from the property array
    long              GetProperty(ENUM_ORDER_PROP_INTEGER property)      const { return m_long_prop[property];                    }
    double            GetProperty(ENUM_ORDER_PROP_DOUBLE property)       const { return m_double_prop[this.IndexProp(property)];  }
    string            GetProperty(ENUM_ORDER_PROP_STRING property)       const { return m_string_prop[this.IndexProp(property)];  }

    //--- Return the flag of the order supporting the property
    virtual bool      SupportProperty(ENUM_ORDER_PROP_INTEGER property)        { return true; }
    virtual bool      SupportProperty(ENUM_ORDER_PROP_DOUBLE property)         { return true; }
    virtual bool      SupportProperty(ENUM_ORDER_PROP_STRING property)         { return true; }

    //--- Compare COrder objects by all possible properties
    virtual int       Compare(const CObject *node, const int mode = 0) const;

//+------------------------------------------------------------------+
//| Methods of a simplified access to the order object properties    |
//+------------------------------------------------------------------+
    //--- Return (1) ticket, (2) parent order ticket, (3) derived order ticket, (4) magic number, (5) order reason (6) position ID
    //--- (7) opposite position ID, (8) flag of closing by StopLoss, (9) flag of closing by TakeProfit (10) open time, (11) close time,
    //--- (12) open time in milliseconds, (13) close time in milliseconds (14) expiration date, (15) type, (16) status, (17) direction
    long              Ticket(void)                                       const { return this.GetProperty(ORDER_PROP_TICKET);                     }
    long              TicketFrom(void)                                   const { return this.GetProperty(ORDER_PROP_TICKET_FROM);                }
    long              TicketTo(void)                                     const { return this.GetProperty(ORDER_PROP_TICKET_TO);                  }
    long              Magic(void)                                        const { return this.GetProperty(ORDER_PROP_MAGIC);                      }
    long              Reason(void)                                       const { return this.GetProperty(ORDER_PROP_REASON);                     }
    long              PositionID(void)                                   const { return this.GetProperty(ORDER_PROP_POSITION_ID);                }
    long              PositionByID(void)                                 const { return this.GetProperty(ORDER_PROP_POSITION_BY_ID);             }
    bool              IsCloseByStopLoss(void)                            const { return (bool)this.GetProperty(ORDER_PROP_CLOSE_BY_SL);          }
    bool              IsCloseByTakeProfit(void)                          const { return (bool)this.GetProperty(ORDER_PROP_CLOSE_BY_TP);          }
    datetime          TimeOpen(void)                                     const { return (datetime)this.GetProperty(ORDER_PROP_TIME_OPEN);        }
    datetime          TimeClose(void)                                    const { return (datetime)this.GetProperty(ORDER_PROP_TIME_CLOSE);       }
    datetime          TimeOpenMSC(void)                                  const { return (datetime)this.GetProperty(ORDER_PROP_TIME_OPEN_MSC);    }
    datetime          TimeCloseMSC(void)                                 const { return (datetime)this.GetProperty(ORDER_PROP_TIME_CLOSE_MSC);   }
    datetime          TimeExpiration(void)                               const { return (datetime)this.GetProperty(ORDER_PROP_TIME_EXP);         }
    ENUM_ORDER_TYPE   TypeOrder(void)                                    const { return (ENUM_ORDER_TYPE)this.GetProperty(ORDER_PROP_TYPE);      }
    ENUM_ORDER_STATUS Status(void)                                       const { return (ENUM_ORDER_STATUS)this.GetProperty(ORDER_PROP_STATUS);  }
    ENUM_ORDER_TYPE   TypeByDirection(void)                              const { return (ENUM_ORDER_TYPE)this.GetProperty(ORDER_PROP_DIRECTION); }

    //--- Return (1) open price, (2) close price, (3) profit, (4) commission, (5) swap, (6) volume,
    //--- (7) unexecuted volume (8) StopLoss and (9) TakeProfit (10) StopLimit order price
    double            PriceOpen(void)                                    const { return this.GetProperty(ORDER_PROP_PRICE_OPEN);                 }
    double            PriceClose(void)                                   const { return this.GetProperty(ORDER_PROP_PRICE_CLOSE);                }
    double            Profit(void)                                       const { return this.GetProperty(ORDER_PROP_PROFIT);                     }
    double            Comission(void)                                    const { return this.GetProperty(ORDER_PROP_COMMISSION);                 }
    double            Swap(void)                                         const { return this.GetProperty(ORDER_PROP_SWAP);                       }
    double            Volume(void)                                       const { return this.GetProperty(ORDER_PROP_VOLUME);                     }
    double            VolumeCurrent(void)                                const { return this.GetProperty(ORDER_PROP_VOLUME_CURRENT);             }
    double            StopLoss(void)                                     const { return this.GetProperty(ORDER_PROP_SL);                         }
    double            TakeProfit(void)                                   const { return this.GetProperty(ORDER_PROP_TP);                         }
    double            PriceStopLimit(void)                               const { return this.GetProperty(ORDER_PROP_PRICE_STOP_LIMIT);           }

    //--- Return (1) symbol, (2) comment, (3) ID at an exchange
    string            Symbol(void)                                       const { return this.GetProperty(ORDER_PROP_SYMBOL);                     }
    string            Comment(void)                                      const { return this.GetProperty(ORDER_PROP_COMMENT);                    }
    string            ExternalID(void)                                   const { return this.GetProperty(ORDER_PROP_EXT_ID);                     }

    //--- Get the full order profit
    double            ProfitFull(void)                                   const { return this.Profit()+this.Comission()+this.Swap();              }
    //--- Get order profit in points
    int               ProfitInPoints(void) const;

//+------------------------------------------------------------------+
//| Descriptions of the order object properties                      |
//+------------------------------------------------------------------+
    //--- Get description of an order's (1) integer, (2) real and (3) string property
    string            GetPropertyDescription(ENUM_ORDER_PROP_INTEGER property);
    string            GetPropertyDescription(ENUM_ORDER_PROP_DOUBLE property);
    string            GetPropertyDescription(ENUM_ORDER_PROP_STRING property);
    //--- Return order status name
    string            StatusDescription(void)    const;
    //--- Return order or position name
    string            TypeDescription(void)      const;
    //--- Return the deal direction name
    string            DealEntryDescription(void) const;
    //--- Return order/position direction
    string            DirectionDescription(void) const;
    //--- Send description of order properties to journal (full_prop=true - all properties, false - only supported ones)
    void              Print(const bool full_prop = false);
    //---
};
//+------------------------------------------------------------------+
//| Class methods                                                    |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Closed parametric constructor                                    |
//+------------------------------------------------------------------+
COrder::COrder(ENUM_ORDER_STATUS order_status, const ulong ticket)
{
//--- Save integer properties
    m_ticket = ticket;
    m_long_prop[ORDER_PROP_STATUS]                              = order_status;
    m_long_prop[ORDER_PROP_MAGIC]                               = this.OrderMagicNumber();
    m_long_prop[ORDER_PROP_TICKET]                              = this.OrderTicket();
    m_long_prop[ORDER_PROP_TIME_OPEN]                           = (long)(ulong)this.OrderOpenTime();
    m_long_prop[ORDER_PROP_TIME_CLOSE]                          = (long)(ulong)this.OrderCloseTime();
    m_long_prop[ORDER_PROP_TIME_EXP]                            = (long)(ulong)this.OrderExpiration();
    m_long_prop[ORDER_PROP_TYPE]                                = this.OrderType();
    m_long_prop[ORDER_PROP_DIRECTION]                           = this.OrderTypeByDirection();
    m_long_prop[ORDER_PROP_POSITION_ID]                         = this.OrderPositionID();
    m_long_prop[ORDER_PROP_REASON]                              = this.OrderReason();
    m_long_prop[ORDER_PROP_DEAL_ORDER]                          = this.DealOrder();
    m_long_prop[ORDER_PROP_DEAL_ENTRY]                          = this.DealEntry();
    m_long_prop[ORDER_PROP_POSITION_BY_ID]                      = this.OrderPositionByID();
    m_long_prop[ORDER_PROP_TIME_OPEN_MSC]                       = this.OrderOpenTimeMSC();
    m_long_prop[ORDER_PROP_TIME_CLOSE_MSC]                      = this.OrderCloseTimeMSC();
    m_long_prop[ORDER_PROP_TIME_UPDATE]                         = (long)(ulong)this.PositionTimeUpdate();
    m_long_prop[ORDER_PROP_TIME_UPDATE_MSC]                     = (long)(ulong)this.PositionTimeUpdateMSC();

//--- Save real properties
    m_double_prop[this.IndexProp(ORDER_PROP_PRICE_OPEN)]        = this.OrderOpenPrice();
    m_double_prop[this.IndexProp(ORDER_PROP_PRICE_CLOSE)]       = this.OrderClosePrice();
    m_double_prop[this.IndexProp(ORDER_PROP_PROFIT)]            = this.OrderProfit();
    m_double_prop[this.IndexProp(ORDER_PROP_COMMISSION)]        = this.OrderCommission();
    m_double_prop[this.IndexProp(ORDER_PROP_SWAP)]              = this.OrderSwap();
    m_double_prop[this.IndexProp(ORDER_PROP_VOLUME)]            = this.OrderVolume();
    m_double_prop[this.IndexProp(ORDER_PROP_SL)]                = this.OrderStopLoss();
    m_double_prop[this.IndexProp(ORDER_PROP_TP)]                = this.OrderTakeProfit();
    m_double_prop[this.IndexProp(ORDER_PROP_VOLUME_CURRENT)]    = this.OrderVolumeCurrent();
    m_double_prop[this.IndexProp(ORDER_PROP_PRICE_STOP_LIMIT)]  = this.OrderPriceStopLimit();

//--- Save string properties
    m_string_prop[this.IndexProp(ORDER_PROP_SYMBOL)]            = this.OrderSymbol();
    m_string_prop[this.IndexProp(ORDER_PROP_COMMENT)]           = this.OrderComment();
    m_string_prop[this.IndexProp(ORDER_PROP_EXT_ID)]            = this.OrderExternalID();

//--- Save additional integer properties
    m_long_prop[ORDER_PROP_PROFIT_PT]                           = this.ProfitInPoints();
    m_long_prop[ORDER_PROP_TICKET_FROM]                         = this.OrderTicketFrom();
    m_long_prop[ORDER_PROP_TICKET_TO]                           = this.OrderTicketTo();
    m_long_prop[ORDER_PROP_CLOSE_BY_SL]                         = this.OrderCloseByStopLoss();
    m_long_prop[ORDER_PROP_CLOSE_BY_TP]                         = this.OrderCloseByTakeProfit();

//--- Save additional real properties
    m_double_prop[this.IndexProp(ORDER_PROP_PROFIT_FULL)]       = this.ProfitFull();
}
//+------------------------------------------------------------------+
//| Compare COrder objects by all possible properties                |
//+------------------------------------------------------------------+
int COrder::Compare(const CObject *node, const int mode = 0) const
{
    const COrder *order_compared = node;
//--- compare integer properties of two orders
    if(mode < ORDER_PROP_INTEGER_TOTAL)
    {
        long value_compared = order_compared.GetProperty((ENUM_ORDER_PROP_INTEGER)mode);
        long value_current = this.GetProperty((ENUM_ORDER_PROP_INTEGER)mode);
        return(value_current > value_compared ? 1 : value_current < value_compared ? -1 : 0);
    }
//--- compare real properties of two orders
    else if(mode < ORDER_PROP_DOUBLE_TOTAL + ORDER_PROP_INTEGER_TOTAL)
    {
        double value_compared = order_compared.GetProperty((ENUM_ORDER_PROP_DOUBLE)mode);
        double value_current = this.GetProperty((ENUM_ORDER_PROP_DOUBLE)mode);
        return(value_current > value_compared ? 1 : value_current < value_compared ? -1 : 0);
    }
//--- compare string properties of two orders
    else if(mode < ORDER_PROP_DOUBLE_TOTAL + ORDER_PROP_INTEGER_TOTAL + ORDER_PROP_STRING_TOTAL)
    {
        string value_compared = order_compared.GetProperty((ENUM_ORDER_PROP_STRING)mode);
        string value_current = this.GetProperty((ENUM_ORDER_PROP_STRING)mode);
        return(value_current > value_compared ? 1 : value_current < value_compared ? -1 : 0);
    }
    return 0;
}

//+------------------------------------------------------------------+
//| Integer properties                                               |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Return magic number                                              |
//+------------------------------------------------------------------+
long COrder::OrderMagicNumber() const
{
#ifdef __MQL4__
    return ::OrderMagicNumber();
#else
    long res = 0;
    switch((ENUM_ORDER_STATUS)this.GetProperty(ORDER_PROP_STATUS))
    {
    case ORDER_STATUS_MARKET_ACTIVE     :
        res = ::PositionGetInteger(POSITION_MAGIC);
        break;
    case ORDER_STATUS_MARKET_PENDING    :
        res = ::OrderGetInteger(ORDER_MAGIC);
        break;
    case ORDER_STATUS_DEAL              :
        res = ::HistoryDealGetInteger(m_ticket, DEAL_MAGIC);
        break;
    case ORDER_STATUS_HISTORY_PENDING   :
    case ORDER_STATUS_HISTORY_ORDER     :
        res = ::HistoryOrderGetInteger(m_ticket, ORDER_MAGIC);
        break;
    default                             :
        res = 0;
        break;
    }
    return res;
#endif
}
//+------------------------------------------------------------------+
//| Return the ticket                                                |
//+------------------------------------------------------------------+
long COrder::OrderTicket(void) const
{
#ifdef __MQL4__
    return ::OrderTicket();
#else
    long res = 0;
    switch((ENUM_ORDER_STATUS)this.GetProperty(ORDER_PROP_STATUS))
    {
    case ORDER_STATUS_MARKET_ACTIVE     :
    case ORDER_STATUS_MARKET_PENDING    :
    case ORDER_STATUS_HISTORY_PENDING   :
    case ORDER_STATUS_HISTORY_ORDER     :
    case ORDER_STATUS_DEAL              :
        res = (long)m_ticket;
        break;
    default                             :
        res = 0;
        break;
    }
    return res;
#endif
}
//+------------------------------------------------------------------+
//| Return the parent order ticket                                   |
//+------------------------------------------------------------------+
long COrder::OrderTicketFrom(void) const
{
    long ticket = 0;
#ifdef __MQL4__
    string order_comment =::OrderComment();
    if(::StringFind(order_comment, "from #") > WRONG_VALUE) ticket = ::StringToInteger(::StringSubstr(order_comment, 6));
#endif
    return ticket;
}
//+------------------------------------------------------------------+
//| Return the child order ticket                                    |
//+------------------------------------------------------------------+
long COrder::OrderTicketTo(void) const
{
    long ticket = 0;
#ifdef __MQL4__
    string order_comment =::OrderComment();
    if(::StringFind(order_comment, "to #") > WRONG_VALUE) ticket = ::StringToInteger(::StringSubstr(order_comment, 4));
#endif
    return ticket;
}
//+------------------------------------------------------------------+
//| Return position ID                                               |
//+------------------------------------------------------------------+
long COrder::OrderPositionID(void) const
{
#ifdef __MQL4__
    return ::OrderMagicNumber();
#else
    long res = 0;
    switch((ENUM_ORDER_STATUS)this.GetProperty(ORDER_PROP_STATUS))
    {
    case ORDER_STATUS_MARKET_ACTIVE     :
        res = ::PositionGetInteger(POSITION_IDENTIFIER);
        break;
    case ORDER_STATUS_MARKET_PENDING    :
        res = ::OrderGetInteger(ORDER_POSITION_ID);
        break;
    case ORDER_STATUS_HISTORY_PENDING   :
    case ORDER_STATUS_HISTORY_ORDER     :
        res = ::HistoryOrderGetInteger(m_ticket, ORDER_POSITION_ID);
        break;
    case ORDER_STATUS_DEAL              :
        res = ::HistoryDealGetInteger(m_ticket, DEAL_POSITION_ID);
        break;
    default                             :
        res = 0;
        break;
    }
    return res;
#endif
}
//+------------------------------------------------------------------+
//| Return the opposite position ID                                  |
//+------------------------------------------------------------------+
long COrder::OrderPositionByID(void) const
{
#ifdef __MQL4__
    return 0;
#else
    long res = 0;
    switch((ENUM_ORDER_STATUS)this.GetProperty(ORDER_PROP_STATUS))
    {
    case ORDER_STATUS_MARKET_PENDING    :
        res = ::OrderGetInteger(ORDER_POSITION_BY_ID);
        break;
    case ORDER_STATUS_HISTORY_PENDING   :
    case ORDER_STATUS_HISTORY_ORDER     :
        res = ::HistoryOrderGetInteger(m_ticket, ORDER_POSITION_BY_ID);
        break;
    default                             :
        res = 0;
        break;
    }
    return res;
#endif
}
//+------------------------------------------------------------------+
//| Return open time in milliseconds                                 |
//+------------------------------------------------------------------+
long COrder::OrderOpenTimeMSC(void) const
{
#ifdef __MQL4__
    return (long)::OrderOpenTime();
#else
    long res = 0;
    switch((ENUM_ORDER_STATUS)this.GetProperty(ORDER_PROP_STATUS))
    {
    case ORDER_STATUS_MARKET_ACTIVE     :
        res = ::PositionGetInteger(POSITION_TIME_MSC);
        break;
    case ORDER_STATUS_MARKET_PENDING    :
        res = ::OrderGetInteger(ORDER_TIME_SETUP_MSC);
        break;
    case ORDER_STATUS_HISTORY_PENDING   :
    case ORDER_STATUS_HISTORY_ORDER     :
        res = ::HistoryOrderGetInteger(m_ticket, ORDER_TIME_SETUP_MSC);
        break;
    case ORDER_STATUS_DEAL              :
        res = ::HistoryDealGetInteger(m_ticket, DEAL_TIME_MSC);
        break;
    default                             :
        res = 0;
        break;
    }
    return res;
#endif
}
//+------------------------------------------------------------------+
//| Return close time in milliseconds                                |
//+------------------------------------------------------------------+
long COrder::OrderCloseTimeMSC(void) const
{
#ifdef __MQL4__
    return (long)::OrderCloseTime();
#else
    long res = 0;
    switch((ENUM_ORDER_STATUS)this.GetProperty(ORDER_PROP_STATUS))
    {
    case ORDER_STATUS_HISTORY_PENDING   :
    case ORDER_STATUS_HISTORY_ORDER     :
        res = ::HistoryOrderGetInteger(m_ticket, ORDER_TIME_DONE_MSC);
        break;
    case ORDER_STATUS_DEAL              :
        res = (datetime)::HistoryDealGetInteger(m_ticket, DEAL_TIME_MSC);
        break;
    default                             :
        res = 0;
        break;
    }
    return res;
#endif
}
//+------------------------------------------------------------------+
//| Return the type                                                  |
//+------------------------------------------------------------------+
long COrder::OrderType(void) const
{
#ifdef __MQL4__
    return (long)::OrderType();
#else
    long res = 0;
    switch((ENUM_ORDER_STATUS)this.GetProperty(ORDER_PROP_STATUS))
    {
    case ORDER_STATUS_MARKET_ACTIVE     :
        res = ::PositionGetInteger(POSITION_TYPE);
        break;
    case ORDER_STATUS_MARKET_PENDING    :
        res = ::OrderGetInteger(ORDER_TYPE);
        break;
    case ORDER_STATUS_HISTORY_PENDING   :
    case ORDER_STATUS_HISTORY_ORDER     :
        res = ::HistoryOrderGetInteger(m_ticket, ORDER_TYPE);
        break;
    case ORDER_STATUS_DEAL              :
        res = ::HistoryDealGetInteger(m_ticket, DEAL_TYPE);
        break;
    default                             :
        res = 0;
        break;
    }
    return res;
#endif
}
//+------------------------------------------------------------------+
//| Return the type by direction                                     |
//+------------------------------------------------------------------+
long COrder::OrderTypeByDirection(void) const
{
    ENUM_ORDER_STATUS status = (ENUM_ORDER_STATUS)this.GetProperty(ORDER_PROP_STATUS);
    if(status == ORDER_STATUS_MARKET_ACTIVE)
    {
        return(this.OrderType() == POSITION_TYPE_BUY ? ORDER_TYPE_BUY : ORDER_TYPE_SELL);
    }
    if(status == ORDER_STATUS_MARKET_PENDING || status == ORDER_STATUS_HISTORY_PENDING)
    {
        return
            (
                this.OrderType() == ORDER_TYPE_BUY_LIMIT ||
                this.OrderType() == ORDER_TYPE_BUY_STOP
#ifdef __MQL5__                        ||
                this.OrderType() == ORDER_TYPE_BUY_STOP_LIMIT
#endif ?
                ORDER_TYPE_BUY :
                ORDER_TYPE_SELL
            );
    }
    if(status == ORDER_STATUS_HISTORY_ORDER)
    {
        return this.OrderType();
    }
    return WRONG_VALUE;
}
//+------------------------------------------------------------------+
//| Return execution type by residue                                 |
//+------------------------------------------------------------------+
long COrder::OrderTypeFilling(void) const
{
#ifdef __MQL4__
    return (long)ORDER_FILLING_RETURN;
#else
    long res = 0;
    switch((ENUM_ORDER_STATUS)this.GetProperty(ORDER_PROP_STATUS))
    {
    case ORDER_STATUS_MARKET_PENDING    :
        res = ::OrderGetInteger(ORDER_TYPE_FILLING);
        break;
    case ORDER_STATUS_HISTORY_PENDING   :
    case ORDER_STATUS_HISTORY_ORDER     :
        res = ::HistoryOrderGetInteger(m_ticket, ORDER_TYPE_FILLING);
        break;
    default                             :
        res = 0;
        break;
    }
    return res;
#endif
}
//+------------------------------------------------------------------+
//| Return order lifetime                                            |
//+------------------------------------------------------------------+
long COrder::OrderTypeTime(void) const
{
#ifdef __MQL4__
    return (long)ORDER_TIME_GTC;
#else
    long res = 0;
    switch((ENUM_ORDER_STATUS)this.GetProperty(ORDER_PROP_STATUS))
    {
    case ORDER_STATUS_MARKET_PENDING    :
        res =::OrderGetInteger(ORDER_TYPE_TIME);
        break;
    case ORDER_STATUS_HISTORY_PENDING   :
    case ORDER_STATUS_HISTORY_ORDER     :
        res =::HistoryOrderGetInteger(m_ticket, ORDER_TYPE_TIME);
        break;
    default                             :
        res = 0;
        break;
    }
    return res;
#endif
}
//+------------------------------------------------------------------+
//| Order reason or source                                           |
//+------------------------------------------------------------------+
long COrder::OrderReason(void) const
{
#ifdef __MQL4__
    return
        (
            this.OrderCloseByStopLoss()   ?  ORDER_REASON_SL      :
            this.OrderCloseByTakeProfit() ?  ORDER_REASON_TP      :
            this.OrderMagicNumber() != 0    ?  ORDER_REASON_EXPERT  : WRONG_VALUE
        );
#else
    long res = WRONG_VALUE;
    switch((ENUM_ORDER_STATUS)this.GetProperty(ORDER_PROP_STATUS))
    {
    case ORDER_STATUS_MARKET_ACTIVE     :
        res =::PositionGetInteger(POSITION_REASON);
        break;
    case ORDER_STATUS_MARKET_PENDING    :
        res =::OrderGetInteger(ORDER_REASON);
        break;
    case ORDER_STATUS_HISTORY_PENDING   :
    case ORDER_STATUS_HISTORY_ORDER     :
        res =::HistoryOrderGetInteger(m_ticket, ORDER_REASON);
        break;
    case ORDER_STATUS_DEAL              :
        res =::HistoryDealGetInteger(m_ticket, DEAL_REASON);
        break;
    default                             :
        res = WRONG_VALUE;
        break;
    }
    return res;
#endif
}
//+------------------------------------------------------------------+
//| Order, based on which a deal is performed                        |
//+------------------------------------------------------------------+
long COrder::DealOrder(void) const
{
#ifdef __MQL4__
    return ::OrderTicket();
#else
    long res = 0;
    switch((ENUM_ORDER_STATUS)this.GetProperty(ORDER_PROP_STATUS))
    {
    case ORDER_STATUS_MARKET_ACTIVE     :
        res =::PositionGetInteger(POSITION_IDENTIFIER);
        break;
    case ORDER_STATUS_MARKET_PENDING    :
        res =::OrderGetInteger(ORDER_POSITION_ID);
        break;
    case ORDER_STATUS_HISTORY_PENDING   :
    case ORDER_STATUS_HISTORY_ORDER     :
        res =::HistoryOrderGetInteger(m_ticket, ORDER_POSITION_ID);
        break;
    case ORDER_STATUS_DEAL              :
        res =::HistoryDealGetInteger(m_ticket, DEAL_ORDER);
        break;
    default                             :
        res = 0;
        break;
    }
    return res;
#endif
}
//+------------------------------------------------------------------+
//| Deal direction IN, OUT, IN/OUT                                   |
//+------------------------------------------------------------------+
long COrder::DealEntry(void) const
{
#ifdef __MQL4__
    return ::OrderType();
#else
    long res = WRONG_VALUE;
    switch((ENUM_ORDER_STATUS)this.GetProperty(ORDER_PROP_STATUS))
    {
    case ORDER_STATUS_DEAL  :
        res =::HistoryDealGetInteger(m_ticket, DEAL_ENTRY);
        break;
    default                 :
        res = WRONG_VALUE;
        break;
    }
    return res;
#endif
}
//+------------------------------------------------------------------+
//| Return the flag of closing a position by StopLoss                |
//+------------------------------------------------------------------+
bool COrder::OrderCloseByStopLoss(void) const
{
#ifdef __MQL4__
    return(::StringFind(::OrderComment(), "[sl") > WRONG_VALUE);
#else
    return (bool)this.OrderReason() == ORDER_REASON_SL;
#endif
}
//+------------------------------------------------------------------+
//| Return the flag of closing a position by TakeProfit              |
//+------------------------------------------------------------------+
bool COrder::OrderCloseByTakeProfit(void) const
{
#ifdef __MQL4__
    return(::StringFind(::OrderComment(), "[tp") > WRONG_VALUE);
#else
    return (bool)this.OrderReason() == ORDER_REASON_TP;
#endif
}
//+------------------------------------------------------------------+
//| Return open time                                                 |
//+------------------------------------------------------------------+
datetime COrder::OrderOpenTime(void) const
{
#ifdef __MQL4__
    return ::OrderOpenTime();
#else
    datetime res = 0;
    switch((ENUM_ORDER_STATUS)this.GetProperty(ORDER_PROP_STATUS))
    {
    case ORDER_STATUS_MARKET_ACTIVE     :
        res = (datetime)::PositionGetInteger(POSITION_TIME);
        break;
    case ORDER_STATUS_MARKET_PENDING    :
        res = (datetime)::OrderGetInteger(ORDER_TIME_SETUP);
        break;
    case ORDER_STATUS_HISTORY_PENDING   :
    case ORDER_STATUS_HISTORY_ORDER     :
        res = (datetime)::HistoryOrderGetInteger(m_ticket, ORDER_TIME_SETUP);
        break;
    case ORDER_STATUS_DEAL              :
        res = (datetime)::HistoryDealGetInteger(m_ticket, DEAL_TIME);
        break;
    default                             :
        res = 0;
        break;
    }
    return res;
#endif
}
//+------------------------------------------------------------------+
//| Return close time                                                |
//+------------------------------------------------------------------+
datetime COrder::OrderCloseTime(void) const
{
#ifdef __MQL4__
    return ::OrderCloseTime();
#else
    datetime res = 0;
    switch((ENUM_ORDER_STATUS)this.GetProperty(ORDER_PROP_STATUS))
    {
    case ORDER_STATUS_HISTORY_PENDING   :
    case ORDER_STATUS_HISTORY_ORDER     :
        res = (datetime)::HistoryOrderGetInteger(m_ticket, ORDER_TIME_DONE);
        break;
    case ORDER_STATUS_DEAL              :
        res = (datetime)::HistoryDealGetInteger(m_ticket, DEAL_TIME);
        break;
    default                             :
        res = 0;
        break;
    }
    return res;
#endif
}
//+------------------------------------------------------------------+
//| Return expiration time                                           |
//+------------------------------------------------------------------+
datetime COrder::OrderExpiration(void) const
{
#ifdef __MQL4__
    return ::OrderExpiration();
#else
    datetime res = 0;
    switch((ENUM_ORDER_STATUS)this.GetProperty(ORDER_PROP_STATUS))
    {
    case ORDER_STATUS_MARKET_PENDING    :
        res = (datetime)::OrderGetInteger(ORDER_TIME_EXPIRATION);
        break;
    case ORDER_STATUS_HISTORY_PENDING   :
        res = (datetime)::HistoryOrderGetInteger(m_ticket, ORDER_TIME_EXPIRATION);
        break;
    default                             :
        res = 0;
        break;
    }
    return res;
#endif
}
//+------------------------------------------------------------------+
//| Position change time in seconds                                  |
//+------------------------------------------------------------------+
datetime COrder::PositionTimeUpdate(void) const
{
#ifdef __MQL4__
    return 0;
#else
    datetime res = 0;
    switch((ENUM_ORDER_STATUS)this.GetProperty(ORDER_PROP_STATUS))
    {
    case ORDER_STATUS_MARKET_ACTIVE  :
        res = (datetime)::PositionGetInteger(POSITION_TIME_UPDATE);
        break;
    default                          :
        res = 0;
        break;
    }
    return res;
#endif
}
//+------------------------------------------------------------------+
//| Position change time in milliseconds                             |
//+------------------------------------------------------------------+
datetime COrder::PositionTimeUpdateMSC(void) const
{
#ifdef __MQL4__
    return 0;
#else
    datetime res = 0;
    switch((ENUM_ORDER_STATUS)this.GetProperty(ORDER_PROP_STATUS))
    {
    case ORDER_STATUS_MARKET_ACTIVE  :
        res = (datetime)::PositionGetInteger(POSITION_TIME_UPDATE_MSC);
        break;
    default                          :
        res = 0;
        break;
    }
    return res;
#endif
}
//+------------------------------------------------------------------+
//| Real properties                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Return open price                                                |
//+------------------------------------------------------------------+
double COrder::OrderOpenPrice(void) const
{
#ifdef __MQL4__
    return ::OrderOpenPrice();
#else
    double res = 0;
    switch((ENUM_ORDER_STATUS)this.GetProperty(ORDER_PROP_STATUS))
    {
    case ORDER_STATUS_MARKET_ACTIVE     :
        res = ::PositionGetDouble(POSITION_PRICE_OPEN);
        break;
    case ORDER_STATUS_MARKET_PENDING    :
        res = ::OrderGetDouble(ORDER_PRICE_OPEN);
        break;
    case ORDER_STATUS_HISTORY_PENDING   :
    case ORDER_STATUS_HISTORY_ORDER     :
        res = ::HistoryOrderGetDouble(m_ticket, ORDER_PRICE_OPEN);
        break;
    case ORDER_STATUS_DEAL              :
        res = ::HistoryDealGetDouble(m_ticket, DEAL_PRICE);
        break;
    default                             :
        res = 0;
        break;
    }
    return res;
#endif
}
//+------------------------------------------------------------------+
//| Return close price                                               |
//+------------------------------------------------------------------+
double COrder::OrderClosePrice(void) const
{
#ifdef __MQL4__
    return ::OrderClosePrice();
#else
    double res = 0;
    switch((ENUM_ORDER_STATUS)this.GetProperty(ORDER_PROP_STATUS))
    {
    case ORDER_STATUS_HISTORY_PENDING   :
    case ORDER_STATUS_HISTORY_ORDER     :
        res = ::HistoryOrderGetDouble(m_ticket, ORDER_PRICE_OPEN);
        break;
    case ORDER_STATUS_DEAL              :
        res = ::HistoryDealGetDouble(m_ticket, DEAL_PRICE);
        break;
    default                             :
        res = 0;
        break;
    }
    return res;
#endif
}
//+------------------------------------------------------------------+
//| Return profit                                                    |
//+------------------------------------------------------------------+
double COrder::OrderProfit(void) const
{
#ifdef __MQL4__
    return ::OrderProfit();
#else
    double res = 0;
    switch((ENUM_ORDER_STATUS)this.GetProperty(ORDER_PROP_STATUS))
    {
    case ORDER_STATUS_MARKET_ACTIVE  :
        res = ::PositionGetDouble(POSITION_PROFIT);
        break;
    case ORDER_STATUS_DEAL           :
        res = ::HistoryDealGetDouble(m_ticket, DEAL_PROFIT);
        break;
    default                          :
        res = 0;
        break;
    }
    return res;
#endif
}
//+------------------------------------------------------------------+
//| Return commission                                                |
//+------------------------------------------------------------------+
double COrder::OrderCommission(void) const
{
#ifdef __MQL4__
    return ::OrderCommission();
#else
    double res = 0;
    switch((ENUM_ORDER_STATUS)this.GetProperty(ORDER_PROP_STATUS))
    {
    case ORDER_STATUS_DEAL  :
        res = ::HistoryDealGetDouble(m_ticket, DEAL_COMMISSION);
        break;
    default                 :
        res = 0;
        break;
    }
    return res;
#endif
}
//+------------------------------------------------------------------+
//| Return swap                                                      |
//+------------------------------------------------------------------+
double COrder::OrderSwap(void) const
{
#ifdef __MQL4__
    return ::OrderSwap();
#else
    double res = 0;
    switch((ENUM_ORDER_STATUS)this.GetProperty(ORDER_PROP_STATUS))
    {
    case ORDER_STATUS_MARKET_ACTIVE  :
        res = ::PositionGetDouble(POSITION_SWAP);
        break;
    case ORDER_STATUS_DEAL           :
        res = ::HistoryDealGetDouble(m_ticket, DEAL_SWAP);
        break;
    default                          :
        res = 0;
        break;
    }
    return res;
#endif
}
//+------------------------------------------------------------------+
//| Return volume                                                    |
//+------------------------------------------------------------------+
double COrder::OrderVolume(void) const
{
#ifdef __MQL4__
    return ::OrderLots();
#else
    double res = 0;
    switch((ENUM_ORDER_STATUS)this.GetProperty(ORDER_PROP_STATUS))
    {
    case ORDER_STATUS_MARKET_ACTIVE     :
        res = ::PositionGetDouble(POSITION_VOLUME);
        break;
    case ORDER_STATUS_MARKET_PENDING    :
        res = ::OrderGetDouble(ORDER_VOLUME_INITIAL);
        break;
    case ORDER_STATUS_HISTORY_PENDING   :
    case ORDER_STATUS_HISTORY_ORDER     :
        res = ::HistoryOrderGetDouble(m_ticket, ORDER_VOLUME_INITIAL);
        break;
    case ORDER_STATUS_DEAL              :
        res = ::HistoryDealGetDouble(m_ticket, DEAL_VOLUME);
        break;
    default                             :
        res = 0;
        break;
    }
    return res;
#endif
}
//+------------------------------------------------------------------+
//| Return unexecuted volume                                         |
//+------------------------------------------------------------------+
double COrder::OrderVolumeCurrent(void) const
{
#ifdef __MQL4__
    return ::OrderLots();
#else
    double res = 0;
    switch((ENUM_ORDER_STATUS)this.GetProperty(ORDER_PROP_STATUS))
    {
    case ORDER_STATUS_MARKET_PENDING    :
        res = ::OrderGetDouble(ORDER_VOLUME_CURRENT);
        break;
    case ORDER_STATUS_HISTORY_PENDING   :
    case ORDER_STATUS_HISTORY_ORDER     :
        res = ::HistoryOrderGetDouble(m_ticket, ORDER_VOLUME_CURRENT);
        break;
    default                             :
        res = 0;
        break;
    }
    return res;
#endif
}
//+------------------------------------------------------------------+
//| Return StopLoss price                                            |
//+------------------------------------------------------------------+
double COrder::OrderStopLoss(void) const
{
#ifdef __MQL4__
    return ::OrderStopLoss();
#else
    double res = 0;
    switch((ENUM_ORDER_STATUS)this.GetProperty(ORDER_PROP_STATUS))
    {
    case ORDER_STATUS_MARKET_ACTIVE     :
        res = ::PositionGetDouble(POSITION_SL);
        break;
    case ORDER_STATUS_MARKET_PENDING    :
        res = ::OrderGetDouble(ORDER_SL);
        break;
    case ORDER_STATUS_HISTORY_PENDING   :
    case ORDER_STATUS_HISTORY_ORDER     :
        res = ::HistoryOrderGetDouble(m_ticket, ORDER_SL);
        break;
    default                             :
        res = 0;
        break;
    }
    return res;
#endif
}
//+------------------------------------------------------------------+
//| Return TakeProfit price                                          |
//+------------------------------------------------------------------+
double COrder::OrderTakeProfit(void) const
{
#ifdef __MQL4__
    return ::OrderTakeProfit();
#else
    double res = 0;
    switch((ENUM_ORDER_STATUS)this.GetProperty(ORDER_PROP_STATUS))
    {
    case ORDER_STATUS_MARKET_ACTIVE     :
        res = ::PositionGetDouble(POSITION_TP);
        break;
    case ORDER_STATUS_MARKET_PENDING    :
        res = ::OrderGetDouble(ORDER_TP);
        break;
    case ORDER_STATUS_HISTORY_PENDING   :
    case ORDER_STATUS_HISTORY_ORDER     :
        res = ::HistoryOrderGetDouble(m_ticket, ORDER_TP);
        break;
    default                             :
        res = 0;
        break;
    }
    return res;
#endif
}
//+------------------------------------------------------------------+
//| Return Limit order price                                         |
//| when StopLimit order is activated                                |
//+------------------------------------------------------------------+
double COrder::OrderPriceStopLimit(void) const
{
#ifdef __MQL4__
    return 0;
#else
    double res = 0;
    switch((ENUM_ORDER_STATUS)this.GetProperty(ORDER_PROP_STATUS))
    {
    case ORDER_STATUS_MARKET_PENDING    :
        res = ::OrderGetDouble(ORDER_PRICE_STOPLIMIT);
        break;
    case ORDER_STATUS_HISTORY_PENDING   :
    case ORDER_STATUS_HISTORY_ORDER     :
        res = ::HistoryOrderGetDouble(m_ticket, ORDER_PRICE_STOPLIMIT);
        break;
    default                             :
        res = 0;
        break;
    }
    return res;
#endif
}
//+------------------------------------------------------------------+
//| String properties                                                |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Return symbol                                                    |
//+------------------------------------------------------------------+
string COrder::OrderSymbol(void) const
{
#ifdef __MQL4__
    return ::OrderSymbol();
#else
    string res = "";
    switch((ENUM_ORDER_STATUS)this.GetProperty(ORDER_PROP_STATUS))
    {
    case ORDER_STATUS_MARKET_ACTIVE     :
        res = ::PositionGetString(POSITION_SYMBOL);
        break;
    case ORDER_STATUS_MARKET_PENDING    :
        res = ::OrderGetString(ORDER_SYMBOL);
        break;
    case ORDER_STATUS_HISTORY_PENDING   :
    case ORDER_STATUS_HISTORY_ORDER     :
        res = ::HistoryOrderGetString(m_ticket, ORDER_SYMBOL);
        break;
    case ORDER_STATUS_DEAL              :
        res = ::HistoryDealGetString(m_ticket, DEAL_SYMBOL);
        break;
    default                             :
        res = "";
        break;
    }
    return res;
#endif
}
//+------------------------------------------------------------------+
//| Return comment                                                   |
//+------------------------------------------------------------------+
string COrder::OrderComment(void) const
{
#ifdef __MQL4__
    return ::OrderComment();
#else
    string res = "";
    switch((ENUM_ORDER_STATUS)this.GetProperty(ORDER_PROP_STATUS))
    {
    case ORDER_STATUS_MARKET_ACTIVE     :
        res = ::PositionGetString(POSITION_COMMENT);
        break;
    case ORDER_STATUS_MARKET_PENDING    :
        res = ::OrderGetString(ORDER_COMMENT);
        break;
    case ORDER_STATUS_HISTORY_PENDING   :
    case ORDER_STATUS_HISTORY_ORDER     :
        res = ::HistoryOrderGetString(m_ticket, ORDER_COMMENT);
        break;
    case ORDER_STATUS_DEAL              :
        res = ::HistoryDealGetString(m_ticket, DEAL_COMMENT);
        break;
    default                             :
        res = "";
        break;
    }
    return res;
#endif
}
//+------------------------------------------------------------------+
//| Return ID used by an exchange                                    |
//+------------------------------------------------------------------+
string COrder::OrderExternalID(void) const
{
#ifdef __MQL4__
    return "";
#else
    string res = "";
    switch((ENUM_ORDER_STATUS)this.GetProperty(ORDER_PROP_STATUS))
    {
    case ORDER_STATUS_MARKET_PENDING    :
        res = ::OrderGetString(ORDER_EXTERNAL_ID);
        break;
    case ORDER_STATUS_HISTORY_PENDING   :
    case ORDER_STATUS_HISTORY_ORDER     :
        res = ::HistoryOrderGetString(m_ticket, ORDER_EXTERNAL_ID);
        break;
    case ORDER_STATUS_DEAL              :
        res = ::HistoryDealGetString(m_ticket, DEAL_EXTERNAL_ID);
        break;
    default                             :
        res = "";
        break;
    }
    return res;
#endif
}
//+------------------------------------------------------------------+
//| Get order profit in points                                       |
//+------------------------------------------------------------------+
int COrder::ProfitInPoints(void) const
{
    ENUM_ORDER_TYPE type = this.TypeOrder();
    string symbol = this.Symbol();
    double point = ::SymbolInfoDouble(symbol, SYMBOL_POINT);
    if(type > ORDER_TYPE_SELL || point == 0) return 0;
    if(this.Status() == ORDER_STATUS_HISTORY_ORDER)
        return int(type == ORDER_TYPE_BUY ? (this.PriceClose() - this.PriceOpen()) / point : type == ORDER_TYPE_SELL ? (this.PriceOpen() - this.PriceClose()) / point : 0);
    else if(this.Status() == ORDER_STATUS_MARKET_ACTIVE)
    {
        if(type == ORDER_TYPE_BUY)
            return int((::SymbolInfoDouble(symbol, SYMBOL_BID) - this.PriceOpen()) / point);
        else if(type == ORDER_TYPE_SELL)
            return int((this.PriceOpen() -::SymbolInfoDouble(symbol, SYMBOL_ASK)) / point);
    }
    return 0;
}
//+------------------------------------------------------------------+
//| Reason                                                           |
//+------------------------------------------------------------------+
string COrder::GetReasonDescription(const long reason) const
{
#ifdef __MQL4__
    return
        (
            this.IsCloseByStopLoss()            ?  TextByLanguage("Due to StopLoss")                  :
            this.IsCloseByTakeProfit()          ?  TextByLanguage("Due to TakeProfit")              :
            this.Reason() == ORDER_REASON_EXPERT  ?  TextByLanguage("Placed from mql4 program")   :
            TextByLanguage("Property not supported in MQL4")
        );
#else
    string res = "";
    switch(this.Status())
    {
    case ORDER_STATUS_MARKET_ACTIVE        :
        res =
            (
                reason == POSITION_REASON_CLIENT   ?  TextByLanguage("Position opened from desktop terminal") :
                reason == POSITION_REASON_MOBILE   ?  TextByLanguage("Position opened from mobile app") :
                reason == POSITION_REASON_WEB      ?  TextByLanguage("Position opened from web platform") :
                reason == POSITION_REASON_EXPERT   ?  TextByLanguage("Position opened from EA or script") : ""
            );
        break;
    case ORDER_STATUS_MARKET_PENDING       :
    case ORDER_STATUS_HISTORY_PENDING      :
    case ORDER_STATUS_HISTORY_ORDER        :
        res =
            (
                reason == ORDER_REASON_CLIENT      ?  TextByLanguage("Order set from desktop terminal") :
                reason == ORDER_REASON_MOBILE      ?  TextByLanguage("Order set from mobile app") :
                reason == ORDER_REASON_WEB         ?  TextByLanguage("Oder set from web platform") :
                reason == ORDER_REASON_EXPERT      ?  TextByLanguage("Order set from EA or script") :
                reason == ORDER_REASON_SL          ?  TextByLanguage("Due to StopLoss") :
                reason == ORDER_REASON_TP          ?  TextByLanguage("Due to TakeProfit") :
                reason == ORDER_REASON_SO          ?  TextByLanguage("Due to Stop Out") : ""
            );
        break;
    case ORDER_STATUS_DEAL                 :
        res =
            (
                reason == DEAL_REASON_CLIENT       ?  TextByLanguage("Deal carried out from desktop terminal") :
                reason == DEAL_REASON_MOBILE       ?  TextByLanguage("Deal carried out from mobile app") :
                reason == DEAL_REASON_WEB          ?  TextByLanguage("Deal carried out from web platform") :
                reason == DEAL_REASON_EXPERT       ?  TextByLanguage("Deal carried out from EA or script") :
                reason == DEAL_REASON_SL           ?  TextByLanguage("Due to StopLoss") :
                reason == DEAL_REASON_TP           ?  TextByLanguage("Due to TakeProfit") :
                reason == DEAL_REASON_SO           ?  TextByLanguage("Due to Stop Out") :
                reason == DEAL_REASON_ROLLOVER     ?  TextByLanguage("Due to position rollover") :
                reason == DEAL_REASON_VMARGIN      ?  TextByLanguage("Due to variation margin") :
                reason == DEAL_REASON_SPLIT        ?  TextByLanguage("Due to split") : ""
            );
        break;
    default                                :
        res = "";
        break;
    }
    return res;
#endif
}
//+------------------------------------------------------------------+
//| Deal direction description                                       |
//+------------------------------------------------------------------+
string COrder::GetEntryDescription(const long deal_entry) const
{
#ifdef __MQL4__
    return TextByLanguage("Property not supported in MQL4");
#else
    string res = "";
    switch(this.Status())
    {
    case ORDER_STATUS_MARKET_ACTIVE     :
        res = TextByLanguage("Property not supported for position");
        break;
    case ORDER_STATUS_MARKET_PENDING    :
    case ORDER_STATUS_HISTORY_PENDING   :
        res = TextByLanguage("Property not supported for pending order");
        break;
    case ORDER_STATUS_HISTORY_ORDER     :
        res = TextByLanguage("Property not supported for history order");
        break;
    case ORDER_STATUS_DEAL              :
        res =
            (
                deal_entry == DEAL_ENTRY_IN     ?  TextByLanguage("Entry to market") :
                deal_entry == DEAL_ENTRY_OUT    ?  TextByLanguage("Out from market") :
                deal_entry == DEAL_ENTRY_INOUT  ?  TextByLanguage("Reversal") :
                deal_entry == DEAL_ENTRY_OUT_BY ?  TextByLanguage("Closing by opposite position") : ""
            );
        break;
    default                             :
        res = "";
        break;
    }
    return res;
#endif
}
//+------------------------------------------------------------------+
//| Return deal type name                                            |
//+------------------------------------------------------------------+
string COrder::GetTypeDealDescription(const long deal_type) const
{
#ifdef __MQL4__
    return TextByLanguage("Property not supported in MQL4");
#else
    string res = "";
    switch(this.Status())
    {
    case ORDER_STATUS_MARKET_ACTIVE     :
        res = TextByLanguage("Property not supported for position");
        break;
    case ORDER_STATUS_MARKET_PENDING    :
    case ORDER_STATUS_HISTORY_PENDING   :
        res = TextByLanguage("Property not supported for pending order");
        break;
    case ORDER_STATUS_HISTORY_ORDER     :
        res = TextByLanguage("Property not supported for history order");
        break;
    case ORDER_STATUS_DEAL              :
        res =
            (
                deal_type == DEAL_TYPE_BUY                      ?  TextByLanguage("Buy deal") :
                deal_type == DEAL_TYPE_SELL                     ?  TextByLanguage("Sell deal") :
                deal_type == DEAL_TYPE_BALANCE                  ?  TextByLanguage("Balance accrual") :
                deal_type == DEAL_TYPE_CREDIT                   ?  TextByLanguage("Credit accrual") :
                deal_type == DEAL_TYPE_CHARGE                   ?  TextByLanguage("Extra charges") :
                deal_type == DEAL_TYPE_CORRECTION               ?  TextByLanguage("Corrective entry") :
                deal_type == DEAL_TYPE_BONUS                    ?  TextByLanguage("Bonuses") :
                deal_type == DEAL_TYPE_COMMISSION               ?  TextByLanguage("Additional comissions") :
                deal_type == DEAL_TYPE_COMMISSION_DAILY         ?  TextByLanguage("Commission accrued at the end of a trading day") :
                deal_type == DEAL_TYPE_COMMISSION_MONTHLY       ?  TextByLanguage("Commission accrued at the end of a month") :
                deal_type == DEAL_TYPE_COMMISSION_AGENT_DAILY   ?  TextByLanguage("Agency commission charged at the end of a trading day") :
                deal_type == DEAL_TYPE_COMMISSION_AGENT_MONTHLY ?  TextByLanguage("Agency commission charged at the end of a month") :
                deal_type == DEAL_TYPE_INTEREST                 ?  TextByLanguage("Accrued interest on free funds") :
                deal_type == DEAL_TYPE_BUY_CANCELED             ?  TextByLanguage("Canceled buy transaction") :
                deal_type == DEAL_TYPE_SELL_CANCELED            ?  TextByLanguage("Canceled sell transaction") :
                deal_type == DEAL_DIVIDEND                      ?  TextByLanguage("Accrued dividends") :
                deal_type == DEAL_DIVIDEND_FRANKED              ?  TextByLanguage("Accrual of franked dividend") :
                deal_type == DEAL_TAX                           ?  TextByLanguage("Tax accrual") : ""
            );
        break;
    default                             :
        res = "";
        break;
    }
    return res;
#endif
}
//+------------------------------------------------------------------+
//| Return the order status name                                     |
//+------------------------------------------------------------------+
string COrder::StatusDescription(void) const
{
    ENUM_ORDER_STATUS status = this.Status();
    ENUM_ORDER_TYPE   type = (ENUM_ORDER_TYPE)this.TypeOrder();
    return
        (
            status == ORDER_STATUS_BALANCE        ?  TextByLanguage("Balance operation") :
            status == ORDER_STATUS_CREDIT         ?  TextByLanguage("Credits operation") :
            status == ORDER_STATUS_HISTORY_ORDER  || status == ORDER_STATUS_HISTORY_PENDING                     ?
            (
                type > ORDER_TYPE_SELL ? TextByLanguage("Pending order")                      :
                TextByLanguage("The order to ") + (type == ORDER_TYPE_BUY ? TextByLanguage("buy") : TextByLanguage("sell"))
            )                                                                                               :
            status == ORDER_STATUS_DEAL           ?  TextByLanguage("Deal")                          :
            status == ORDER_STATUS_MARKET_ACTIVE  ?  TextByLanguage("Active position")              :
            status == ORDER_STATUS_MARKET_PENDING ?  TextByLanguage("Active pending order") :
            ""
        );
}
//+------------------------------------------------------------------+
//| Return order or position name                                    |
//+------------------------------------------------------------------+
string COrder::TypeDescription(void) const
{
    if(this.Status() == ORDER_STATUS_DEAL)
        return this.GetTypeDealDescription(this.TypeOrder());
    else switch(this.TypeOrder())
        {
        case ORDER_TYPE_BUY              :
            return "Buy";
        case ORDER_TYPE_BUY_LIMIT        :
            return "Buy Limit";
        case ORDER_TYPE_BUY_STOP         :
            return "Buy Stop";
        case ORDER_TYPE_SELL             :
            return "Sell";
        case ORDER_TYPE_SELL_LIMIT       :
            return "Sell Limit";
        case ORDER_TYPE_SELL_STOP        :
            return "Sell Stop";
#ifdef __MQL4__
        case ORDER_TYPE_BALANCE          :
            return TextByLanguage("Balance operation");
        case ORDER_TYPE_CREDIT           :
            return TextByLanguage("Credit operation");
#else
        case ORDER_TYPE_BUY_STOP_LIMIT   :
            return "Buy Stop Limit";
        case ORDER_TYPE_SELL_STOP_LIMIT  :
            return "Sell Stop Limit";
#endif
        default                          :
            return TextByLanguage("Unknown type");
        }
}
//+------------------------------------------------------------------+
//| Return deal direction name                                       |
//+------------------------------------------------------------------+
string COrder::DealEntryDescription(void) const
{
    return(this.Status() == ORDER_STATUS_DEAL ? this.GetEntryDescription(this.GetProperty(ORDER_PROP_DEAL_ENTRY)) : "");
}
//+------------------------------------------------------------------+
//| Return order/position direction type                             |
//+------------------------------------------------------------------+
string COrder::DirectionDescription(void) const
{
    if(this.Status() == ORDER_STATUS_DEAL)
        return this.TypeDescription();
    switch(this.TypeByDirection())
    {
    case ORDER_TYPE_BUY  :
        return "Buy";
    case ORDER_TYPE_SELL :
        return "Sell";
    default              :
        return TextByLanguage("Unknown type");
    }
}
//+------------------------------------------------------------------+
//| Send order properties to the journal                             |
//+------------------------------------------------------------------+
void COrder::Print(const bool full_prop = false)
{
    ::Print("============= ", TextByLanguage("Beginning of the parameter list: \""), this.StatusDescription(), "\" =============");
    int beg = 0, end = ORDER_PROP_INTEGER_TOTAL;
    for(int i = beg; i < end; i++)
    {
        ENUM_ORDER_PROP_INTEGER prop = (ENUM_ORDER_PROP_INTEGER)i;
        if(!full_prop && !this.SupportProperty(prop)) continue;
        ::Print(this.GetPropertyDescription(prop));
    }
    ::Print("------");
    beg = end;
    end += ORDER_PROP_DOUBLE_TOTAL;
    for(int i = beg; i < end; i++)
    {
        ENUM_ORDER_PROP_DOUBLE prop = (ENUM_ORDER_PROP_DOUBLE)i;
        if(!full_prop && !this.SupportProperty(prop)) continue;
        ::Print(this.GetPropertyDescription(prop));
    }
    ::Print("------");
    beg = end;
    end += ORDER_PROP_STRING_TOTAL;
    for(int i = beg; i < end; i++)
    {
        ENUM_ORDER_PROP_STRING prop = (ENUM_ORDER_PROP_STRING)i;
        if(!full_prop && !this.SupportProperty(prop)) continue;
        ::Print(this.GetPropertyDescription(prop));
    }
    ::Print("================== ", TextByLanguage("End of the parameter list: \""), this.StatusDescription(), "\" ==================\n");
}
//+------------------------------------------------------------------+
//| Return description of an order's integer property                |
//+------------------------------------------------------------------+
string COrder::GetPropertyDescription(ENUM_ORDER_PROP_INTEGER property)
{
    return
        (
//--- General properties
            property == ORDER_PROP_MAGIC             ?  TextByLanguage("Magic") +
                (!this.SupportProperty(property)    ?  TextByLanguage(": Property not supported") :
                 ": " + (string)this.GetProperty(property)
                )  :
            property == ORDER_PROP_TICKET            ?  TextByLanguage("Ticket") +
                (!this.SupportProperty(property)    ?  TextByLanguage(": Property not supported") :
                 " #" + (string)this.GetProperty(property)
                )  :
            property == ORDER_PROP_TICKET_FROM       ?  TextByLanguage("Ticket of parent order") +
                (!this.SupportProperty(property)    ?  TextByLanguage(": Property not supported") :
                 " #" + (string)this.GetProperty(property)
                )  :
            property == ORDER_PROP_TICKET_TO         ?  TextByLanguage("Inherited order ticket") +
                (!this.SupportProperty(property)    ?  TextByLanguage(": Property not supported") :
                 " #" + (string)this.GetProperty(property)
                )  :
            property == ORDER_PROP_TIME_OPEN         ?  TextByLanguage("Open time") +
                (!this.SupportProperty(property)    ?  TextByLanguage(": Property not supported") :
                 ": " +::TimeToString(this.GetProperty(property), TIME_DATE | TIME_MINUTES | TIME_SECONDS)
                )  :
            property == ORDER_PROP_TIME_CLOSE        ?  TextByLanguage("Close time") +
                (!this.SupportProperty(property)    ?  TextByLanguage(": Property not supported") :
                 ": " +::TimeToString(this.GetProperty(property), TIME_DATE | TIME_MINUTES | TIME_SECONDS)
                )  :
            property == ORDER_PROP_TIME_EXP          ?  TextByLanguage("Expiration date") +
                (!this.SupportProperty(property)    ?  TextByLanguage(": Property not supported") :
                 (this.GetProperty(property) == 0     ?  TextByLanguage(": Not set") :
                  ": " +::TimeToString(this.GetProperty(property), TIME_DATE | TIME_MINUTES | TIME_SECONDS))
                )  :
            property == ORDER_PROP_TYPE              ?  TextByLanguage("Type") + ": " + this.TypeDescription()                   :
            property == ORDER_PROP_DIRECTION         ?  TextByLanguage("Type by direction") + ": " + this.DirectionDescription() :

            property == ORDER_PROP_REASON            ?  TextByLanguage("Reason") +
                (!this.SupportProperty(property)    ?  TextByLanguage(": Property not supported") :
                 ": " + this.GetReasonDescription(this.GetProperty(property))
                )  :
            property == ORDER_PROP_POSITION_ID       ?  TextByLanguage("Position ID") +
                (!this.SupportProperty(property)    ?  TextByLanguage(": Property not supported") :
                 ": #" + (string)this.GetProperty(property)
                )  :
            property == ORDER_PROP_DEAL_ORDER        ?  TextByLanguage("Deal by order") +
                (!this.SupportProperty(property)    ?  TextByLanguage(": Property not supported") :
                 ": #" + (string)this.GetProperty(property)
                )  :
            property == ORDER_PROP_DEAL_ENTRY        ?  TextByLanguage("Deal entry") +
                (!this.SupportProperty(property)    ?  TextByLanguage(": Property not supported") :
                 ": " + this.GetEntryDescription(this.GetProperty(property))
                )  :
            property == ORDER_PROP_POSITION_BY_ID    ?  TextByLanguage("Opposite position ID") +
                (!this.SupportProperty(property)    ?  TextByLanguage(": Property not supported") :
                 ": " + (string)this.GetProperty(property)
                )  :
            property == ORDER_PROP_TIME_OPEN_MSC     ?  TextByLanguage("Open time in milliseconds") +
                (!this.SupportProperty(property)    ?  TextByLanguage(": Property not supported") :
                 ": " + (string)this.GetProperty(property) + " > " + TimeMSCtoString(this.GetProperty(property))
                )  :
            property == ORDER_PROP_TIME_CLOSE_MSC    ?  TextByLanguage("Close time in milliseconds") +
                (!this.SupportProperty(property)    ?  TextByLanguage(": Property not supported") :
                 ": " + (string)this.GetProperty(property) + " > " + TimeMSCtoString(this.GetProperty(property))
                )  :
            property == ORDER_PROP_TIME_UPDATE       ?  TextByLanguage("Position change time") +
                (!this.SupportProperty(property)    ?  TextByLanguage(": Property not supported") :
                 ": " + (this.GetProperty(property) != 0 ? ::TimeToString(this.GetProperty(property), TIME_DATE | TIME_MINUTES | TIME_SECONDS) : "0")
                )  :
            property == ORDER_PROP_TIME_UPDATE_MSC   ?  TextByLanguage("Time to change a position in milliseconds") +
                (!this.SupportProperty(property)    ?  TextByLanguage(": Property not supported") :
                 ": " + (this.GetProperty(property) != 0 ? (string)this.GetProperty(property) + " > " + TimeMSCtoString(this.GetProperty(property)) : "0")
                )  :
//--- Additional property
            property == ORDER_PROP_STATUS            ?  TextByLanguage("Status") +
                (!this.SupportProperty(property)    ?  TextByLanguage(": Property not supported") :
                 ": \"" + this.StatusDescription() + "\""
                )  :
            property == ORDER_PROP_PROFIT_PT         ?  TextByLanguage("Profit in points") +
                (!this.SupportProperty(property)    ?  TextByLanguage(": Property not supported") :
                 ": " + (string)this.GetProperty(property)
                )  :
            property == ORDER_PROP_CLOSE_BY_SL       ?  TextByLanguage("Close by StopLoss") +
                (!this.SupportProperty(property)    ?  TextByLanguage(": Property not supported") :
                 ": " + (this.GetProperty(property) ? TextByLanguage("Yes") : TextByLanguage("No"))
                )  :
            property == ORDER_PROP_CLOSE_BY_TP       ?  TextByLanguage("Close by TakeProfit") +
                (!this.SupportProperty(property)    ?  TextByLanguage(": Property not supported") :
                 ": " + (this.GetProperty(property) ? TextByLanguage("Yes") : TextByLanguage("No"))
                )  :
            ""
        );
}
//+------------------------------------------------------------------+
//| Return description of order's real property                      |
//+------------------------------------------------------------------+
string COrder::GetPropertyDescription(ENUM_ORDER_PROP_DOUBLE property)
{
    int dg = (int)::SymbolInfoInteger(this.GetProperty(ORDER_PROP_SYMBOL), SYMBOL_DIGITS);
    int dgl = (int)DigitsLots(this.GetProperty(ORDER_PROP_SYMBOL));
    return
        (
//--- General properties
            property == ORDER_PROP_PRICE_CLOSE       ?  TextByLanguage("Close price") +
                (!this.SupportProperty(property)    ?  TextByLanguage(": Property not supported") :
                 ": " +::DoubleToString(this.GetProperty(property), dg)
                )  :
            property == ORDER_PROP_PRICE_OPEN        ?  TextByLanguage("Open price") +
                (!this.SupportProperty(property)    ?  TextByLanguage(": Property not supported") :
                 ": " +::DoubleToString(this.GetProperty(property), dg)
                )  :
            property == ORDER_PROP_SL                ?  TextByLanguage("StopLoss price") +
                (!this.SupportProperty(property)    ?  TextByLanguage(": Property not supported") :
                 (this.GetProperty(property) == 0     ?  TextByLanguage(": Not set") : ": " +::DoubleToString(this.GetProperty(property), dg))
                )  :
            property == ORDER_PROP_TP                ?  TextByLanguage("TakeProfit price") +
                (!this.SupportProperty(property)    ?  TextByLanguage(": Property not supported") :
                 (this.GetProperty(property) == 0     ?  TextByLanguage(": Not set") : ": " +::DoubleToString(this.GetProperty(property), dg))
                )  :
            property == ORDER_PROP_PROFIT            ?  TextByLanguage("Profit") +
                (!this.SupportProperty(property)    ?  TextByLanguage(": Property not supported") :
                 ": " +::DoubleToString(this.GetProperty(property), 2)
                )  :
            property == ORDER_PROP_COMMISSION        ?  TextByLanguage("Comission") +
                (!this.SupportProperty(property)    ?  TextByLanguage(": Property not supported") :
                 ": " +::DoubleToString(this.GetProperty(property), 2)
                )  :
            property == ORDER_PROP_SWAP              ?  TextByLanguage("Swap") +
                (!this.SupportProperty(property)    ?  TextByLanguage(": Property not supported") :
                 ": " +::DoubleToString(this.GetProperty(property), 2)
                )  :
            property == ORDER_PROP_VOLUME            ?  TextByLanguage("Volume") +
                (!this.SupportProperty(property)    ?  TextByLanguage(": Property not supported") :
                 ": " +::DoubleToString(this.GetProperty(property), dgl)
                ) :
            property == ORDER_PROP_VOLUME_CURRENT    ?  TextByLanguage("Unfulfilled volume") +
                (!this.SupportProperty(property)    ?  TextByLanguage(": Property not supported") :
                 ": " +::DoubleToString(this.GetProperty(property), dgl)
                ) :
            property == ORDER_PROP_PRICE_STOP_LIMIT  ?
            TextByLanguage("Price of placing Limit order when StopLimit order activated") +
                (!this.SupportProperty(property)    ?  TextByLanguage(": Property not supported") :
                 ": " +::DoubleToString(this.GetProperty(property), dg)
                ) :
//--- Additional property
            property == ORDER_PROP_PROFIT_FULL       ?  TextByLanguage("Profit+Comission+Swap") +
                (!this.SupportProperty(property)    ?  TextByLanguage(": Property not supported") :
                 ": " +::DoubleToString(this.GetProperty(property), 2)
                ) :
            ""
        );
}
//+------------------------------------------------------------------+
//| Return description of the order's string property                |
//+------------------------------------------------------------------+
string COrder::GetPropertyDescription(ENUM_ORDER_PROP_STRING property)
{
    return
        (
            property == ORDER_PROP_SYMBOL         ?  TextByLanguage("Symbol") + ": \"" + this.GetProperty(property) + "\""            :
            property == ORDER_PROP_COMMENT        ?  TextByLanguage("Comment") +
                (this.GetProperty(property) == ""  ?  TextByLanguage(": Not set") : ": \"" + this.GetProperty(property) + "\"") :
            property == ORDER_PROP_EXT_ID         ?  TextByLanguage("ID on exchange") +
                (!this.SupportProperty(property) ?  TextByLanguage(": Property not supported") :
                (this.GetProperty(property) == ""  ?  TextByLanguage(": Not set") : ": \"" + this.GetProperty(property) + "\"")) :
            ""
        );
}
//+------------------------------------------------------------------+
