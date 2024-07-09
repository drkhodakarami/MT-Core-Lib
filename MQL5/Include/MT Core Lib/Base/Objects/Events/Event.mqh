//+------------------------------------------------------------------+
//|                                                        Event.mqh |
//|                                              Alireza Khodakarami |
//|                         https://www.youtube.com/@YourTradeMaster |
//+------------------------------------------------------------------+
#property copyright "Alireza Khodakarami"
#property link "https://www.youtube.com/@YourTradeMaster"
#property version "1.00"
#property strict    // Necessary for mql4
//+------------------------------------------------------------------+
//| Include files                                                    |
//+------------------------------------------------------------------+
#include "..\..\Collections\HistoryCollection.mqh"
#include "..\..\Collections\MarketCollection.mqh"
#include "..\..\Services\MTLib.mqh"
#include <Object.mqh>
//+------------------------------------------------------------------+
//| Abstract event class                                             |
//+------------------------------------------------------------------+
class CEvent : public CObject
{
  private:
    int m_event_code;    // Event code
//--- Return the index of the array the event's (1) double and (2) string properties are located at
    int IndexProp(ENUM_EVENT_PROP_DOUBLE property) const { return (int) property - EVENT_PROP_INTEGER_TOTAL; }
    int IndexProp(ENUM_EVENT_PROP_STRING property) const { return (int) property - EVENT_PROP_INTEGER_TOTAL - EVENT_PROP_DOUBLE_TOTAL; }

  protected:
    ENUM_TRADE_EVENT m_trade_event;                             // Trading event
    bool             m_is_hedge;                                // Hedge account flag
    long             m_chart_id;                                // Control program chart ID
    int              m_digits;                                  // Symbol's Digits()
    int              m_digits_acc;                              // Number of decimal places for the account currency
    long             m_long_prop[EVENT_PROP_INTEGER_TOTAL];     // Event integer properties
    double           m_double_prop[EVENT_PROP_DOUBLE_TOTAL];    // Event real properties
    string           m_string_prop[EVENT_PROP_STRING_TOTAL];    // Event string properties
//--- return the flag presence in the trading event
    bool             IsPresentEventFlag(const int event_code) const { return (this.m_event_code & event_code) == event_code; }

//--- Protected parametric constructor
    CEvent(const ENUM_EVENT_STATUS event_status, const int event_code, const ulong ticket);

  public:
//--- Default constructor
    CEvent(void) { ; }

//--- Set event's (1) integer, (2) real and (3) string properties
    void               SetProperty(ENUM_EVENT_PROP_INTEGER property, long value) { this.m_long_prop[property] = value; }
    void               SetProperty(ENUM_EVENT_PROP_DOUBLE property, double value) { this.m_double_prop[this.IndexProp(property)] = value; }
    void               SetProperty(ENUM_EVENT_PROP_STRING property, string value) { this.m_string_prop[this.IndexProp(property)] = value; }
//--- Return the event's (1) integer, (2) real and (3) string properties from the property array
    long               GetProperty(ENUM_EVENT_PROP_INTEGER property) const { return this.m_long_prop[property]; }
    double             GetProperty(ENUM_EVENT_PROP_DOUBLE property) const { return this.m_double_prop[this.IndexProp(property)]; }
    string             GetProperty(ENUM_EVENT_PROP_STRING property) const { return this.m_string_prop[this.IndexProp(property)]; }

//--- Return the flag of the event supporting the property
    virtual bool       SupportProperty(ENUM_EVENT_PROP_INTEGER property) { return true; }
    virtual bool       SupportProperty(ENUM_EVENT_PROP_DOUBLE property) { return true; }
    virtual bool       SupportProperty(ENUM_EVENT_PROP_STRING property) { return true; }

//--- Set the control program chart ID
    void               SetChartID(const long id) { this.m_chart_id = id; }
//--- Decode the event code and set the trading event, (2) return the trading event
    void               SetTypeEvent(void);
    ENUM_TRADE_EVENT   TradeEvent(void) const { return this.m_trade_event; }
//--- Send the event to the chart (implementation in descendant classes)
    virtual void       SendEvent(void) { ; }

//--- Compare CEvent objects by a specified property (to sort the lists by a specified event object property)
    virtual int        Compare(const CObject *node, const int mode = 0) const;
//--- Compare CEvent objects by all properties (to search for equal event objects)
    bool               IsEqual(CEvent *compared_event);
//+------------------------------------------------------------------+
//| Methods of simplified access to event object properties          |
//+------------------------------------------------------------------+
//--- Return (1) event type, (2) event time in milliseconds, (3) event status, (4) event reason, (5) deal type, (6) deal ticket,
//--- (7) order type, based on which a deal was executed, (8) position opening order type, (9) position last order ticket,
//--- (10) position first order ticket, (11) position ID, (12) opposite position ID, (13) magic number, (14) opposite position magic number, (15) position open time

    ENUM_TRADE_EVENT   TypeEvent(void) const { return (ENUM_TRADE_EVENT) this.GetProperty(EVENT_PROP_TYPE_EVENT); }
    long               TimeEvent(void) const { return this.GetProperty(EVENT_PROP_TIME_EVENT); }
    ENUM_EVENT_STATUS  Status(void) const { return (ENUM_EVENT_STATUS) this.GetProperty(EVENT_PROP_STATUS_EVENT); }
    ENUM_EVENT_REASON  Reason(void) const { return (ENUM_EVENT_REASON) this.GetProperty(EVENT_PROP_REASON_EVENT); }
    ENUM_DEAL_TYPE     TypeDeal(void) const { return (ENUM_DEAL_TYPE) this.GetProperty(EVENT_PROP_TYPE_DEAL_EVENT); }
    long               TicketDeal(void) const { return this.GetProperty(EVENT_PROP_TICKET_DEAL_EVENT); }
    ENUM_ORDER_TYPE    TypeOrderEvent(void) const { return (ENUM_ORDER_TYPE) this.GetProperty(EVENT_PROP_TYPE_ORDER_EVENT); }
    ENUM_ORDER_TYPE    TypeFirstOrderPosition(void) const { return (ENUM_ORDER_TYPE) this.GetProperty(EVENT_PROP_TYPE_ORDER_POSITION); }
    long               TicketOrderEvent(void) const { return this.GetProperty(EVENT_PROP_TICKET_ORDER_EVENT); }
    long               TicketFirstOrderPosition(void) const { return this.GetProperty(EVENT_PROP_TICKET_ORDER_POSITION); }
    long               PositionID(void) const { return this.GetProperty(EVENT_PROP_POSITION_ID); }
    long               PositionByID(void) const { return this.GetProperty(EVENT_PROP_POSITION_BY_ID); }
    long               Magic(void) const { return this.GetProperty(EVENT_PROP_MAGIC_ORDER); }
    long               MagicCloseBy(void) const { return this.GetProperty(EVENT_PROP_MAGIC_BY_ID); }
    long               TimePosition(void) const { return this.GetProperty(EVENT_PROP_TIME_ORDER_POSITION); }
//--- When changing position direction, return (1) previous position order type, (2) previous position order ticket,
//--- (3) current position order type, (4) current position order ticket,
//--- (5) position type and (6) ticket before changing direction, (7) position type and (8) ticket after changing direction
    ENUM_ORDER_TYPE    TypeOrderPosPrevious(void) const { return (ENUM_ORDER_TYPE) this.GetProperty(EVENT_PROP_TYPE_ORD_POS_BEFORE); }
    long               TicketOrderPosPrevious(void) const { return (ENUM_ORDER_TYPE) this.GetProperty(EVENT_PROP_TICKET_ORD_POS_BEFORE); }
    ENUM_ORDER_TYPE    TypeOrderPosCurrent(void) const { return (ENUM_ORDER_TYPE) this.GetProperty(EVENT_PROP_TYPE_ORD_POS_CURRENT); }
    long               TicketOrderPosCurrent(void) const { return (ENUM_ORDER_TYPE) this.GetProperty(EVENT_PROP_TICKET_ORD_POS_CURRENT); }
    ENUM_POSITION_TYPE TypePositionPrevious(void) const { return PositionTypeByOrderType(this.TypeOrderPosPrevious()); }
    ulong              TicketPositionPrevious(void) const { return this.TicketOrderPosPrevious(); }
    ENUM_POSITION_TYPE TypePositionCurrent(void) const { return PositionTypeByOrderType(this.TypeOrderPosCurrent()); }
    ulong              TicketPositionCurrent(void) const { return this.TicketOrderPosCurrent(); }

//--- Return (1) the price the event occurred at, (2) open price, (3) close price,
//--- (4) StopLoss price, (5) TakeProfit price, (6) profit, (7) requested order volume,
//--- (8) executed order volume, (9) remaining order volume, (10) executed position volume
    double             PriceEvent(void) const { return this.GetProperty(EVENT_PROP_PRICE_EVENT); }
    double             PriceOpen(void) const { return this.GetProperty(EVENT_PROP_PRICE_OPEN); }
    double             PriceClose(void) const { return this.GetProperty(EVENT_PROP_PRICE_CLOSE); }
    double             PriceStopLoss(void) const { return this.GetProperty(EVENT_PROP_PRICE_SL); }
    double             PriceTakeProfit(void) const { return this.GetProperty(EVENT_PROP_PRICE_TP); }
    double             Profit(void) const { return this.GetProperty(EVENT_PROP_PROFIT); }
    double             VolumeOrderInitial(void) const { return this.GetProperty(EVENT_PROP_VOLUME_ORDER_INITIAL); }
    double             VolumeOrderExecuted(void) const { return this.GetProperty(EVENT_PROP_VOLUME_ORDER_EXECUTED); }
    double             VolumeOrderCurrent(void) const { return this.GetProperty(EVENT_PROP_VOLUME_ORDER_CURRENT); }
    double             VolumePositionExecuted(void) const { return this.GetProperty(EVENT_PROP_VOLUME_POSITION_EXECUTED); }
//--- When modifying prices, (1) the order price, (2) StopLoss and (3) TakeProfit before modification are returned
    double             PriceOpenBefore(void) const { return this.GetProperty(EVENT_PROP_PRICE_OPEN_BEFORE); }
    double             PriceStopLossBefore(void) const { return this.GetProperty(EVENT_PROP_PRICE_SL_BEFORE); }
    double             PriceTakeProfitBefore(void) const { return this.GetProperty(EVENT_PROP_PRICE_TP_BEFORE); }
    double             PriceEventAsk(void) const { return this.GetProperty(EVENT_PROP_PRICE_EVENT_ASK); }
    double             PriceEventBid(void) const { return this.GetProperty(EVENT_PROP_PRICE_EVENT_BID); }

//--- Return the (1) symbol and (2) opposite position symbol
    string             Symbol(void) const { return this.GetProperty(EVENT_PROP_SYMBOL); }
    string             SymbolCloseBy(void) const { return this.GetProperty(EVENT_PROP_SYMBOL_BY_ID); }

//+------------------------------------------------------------------+
//| Descriptions of the order object properties                      |
//+------------------------------------------------------------------+
//--- Get description of an order's (1) integer, (2) real and (3) string property
    string             GetPropertyDescription(ENUM_EVENT_PROP_INTEGER property);
    string             GetPropertyDescription(ENUM_EVENT_PROP_DOUBLE property);
    string             GetPropertyDescription(ENUM_EVENT_PROP_STRING property);
//--- Return the event's (1) status and (2) type
    string             StatusDescription(void) const;
    string             TypeEventDescription(void) const;
//--- Return the name of an (1) event deal order, (2) position's parent order, (3) current position order and the (4) current position
//--- Return the name of an (5) order and (6) position before the direction was changed
    string             TypeOrderDealDescription(void) const;
    string             TypeOrderFirstDescription(void) const;
    string             TypeOrderEventDescription(void) const;
    string             TypePositionCurrentDescription(void) const;
    string             TypeOrderPreviousDescription(void) const;
    string             TypePositionPreviousDescription(void) const;
//--- Return the name of the deal/order/position reason
    string             ReasonDescription(void) const;

//--- Display (1) description of order properties (full_prop=true - all properties, false - only supported ones),
//--- (2) short event message (implementation in the class descendants) in the journal
    void               Print(const bool full_prop = false);
    virtual void       PrintShort(void) { ; }
};
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CEvent::CEvent(const ENUM_EVENT_STATUS event_status, const int event_code, const ulong ticket) : m_event_code(event_code), m_digits(0)
{
    this.m_long_prop[EVENT_PROP_STATUS_EVENT]       = event_status;
    this.m_long_prop[EVENT_PROP_TICKET_ORDER_EVENT] = (long) ticket;
    this.m_is_hedge                                 = #ifdef __MQL4__ true #else bool(::AccountInfoInteger(ACCOUNT_MARGIN_MODE) == ACCOUNT_MARGIN_MODE_RETAIL_HEDGING) #endif;
    this.m_digits_acc                               = #ifdef __MQL4__ 2 #else(int)::AccountInfoInteger(ACCOUNT_CURRENCY_DIGITS) #endif;
    this.m_chart_id                                 = ::ChartID();
}
//+------------------------------------------------------------------+
//| Compare CEvent objects by a specified property                   |
//+------------------------------------------------------------------+
int CEvent::Compare(const CObject *node, const int mode = 0) const
{
    const CEvent *event_compared = node;
//--- compare integer properties of two events
    if(mode < EVENT_PROP_INTEGER_TOTAL)
    {
        long value_compared = event_compared.GetProperty((ENUM_EVENT_PROP_INTEGER) mode);
        long value_current  = this.GetProperty((ENUM_EVENT_PROP_INTEGER) mode);
        return (value_current > value_compared ? 1 : value_current < value_compared ? -1 : 0);
    }
//--- compare integer properties of two objects
    if(mode < EVENT_PROP_DOUBLE_TOTAL + EVENT_PROP_INTEGER_TOTAL)
    {
        double value_compared = event_compared.GetProperty((ENUM_EVENT_PROP_DOUBLE) mode);
        double value_current  = this.GetProperty((ENUM_EVENT_PROP_DOUBLE) mode);
        return (value_current > value_compared ? 1 : value_current < value_compared ? -1 : 0);
    }
//--- compare string properties of two objects
    else if(mode < EVENT_PROP_DOUBLE_TOTAL + EVENT_PROP_INTEGER_TOTAL + EVENT_PROP_STRING_TOTAL)
    {
        string value_compared = event_compared.GetProperty((ENUM_EVENT_PROP_STRING) mode);
        string value_current  = this.GetProperty((ENUM_EVENT_PROP_STRING) mode);
        return (value_current > value_compared ? 1 : value_current < value_compared ? -1 : 0);
    }
    return 0;
}
//+------------------------------------------------------------------+
//| Compare CEvent events by all properties                          |
//+------------------------------------------------------------------+
bool CEvent::IsEqual(CEvent *compared_event)
{
    int beg = 0, end = EVENT_PROP_INTEGER_TOTAL;
    for(int i = beg; i < end; i++)
    {
        ENUM_EVENT_PROP_INTEGER prop = (ENUM_EVENT_PROP_INTEGER) i;
        if(this.GetProperty(prop) != compared_event.GetProperty(prop)) return false;
    }
    beg  = end;
    end += EVENT_PROP_DOUBLE_TOTAL;
    for(int i = beg; i < end; i++)
    {
        ENUM_EVENT_PROP_DOUBLE prop = (ENUM_EVENT_PROP_DOUBLE) i;
        if(this.GetProperty(prop) != compared_event.GetProperty(prop)) return false;
    }
    beg  = end;
    end += EVENT_PROP_STRING_TOTAL;
    for(int i = beg; i < end; i++)
    {
        ENUM_EVENT_PROP_STRING prop = (ENUM_EVENT_PROP_STRING) i;
        if(this.GetProperty(prop) != compared_event.GetProperty(prop)) return false;
    }
//---
    return true;
}
//+------------------------------------------------------------------+
//| Decode the event code and set a trading event                    |
//+------------------------------------------------------------------+
void CEvent::SetTypeEvent(void)
{
//--- Set event symbol's Digits()
    this.m_digits = (int) ::SymbolInfoInteger(this.Symbol(), SYMBOL_DIGITS);
//--- Pending order is set (check if the event code is matched since there can be only one flag here)
    if(this.m_event_code == TRADE_EVENT_FLAG_ORDER_PLASED)
    {
        this.m_trade_event = TRADE_EVENT_PENDING_ORDER_PLASED;
        this.SetProperty(EVENT_PROP_TYPE_EVENT, this.m_trade_event);
        return;
    }
//--- Pending order is removed (check if the event code is matched since there can be only one flag here)
    if(this.m_event_code == TRADE_EVENT_FLAG_ORDER_REMOVED)
    {
        this.m_trade_event = TRADE_EVENT_PENDING_ORDER_REMOVED;
        this.SetProperty(EVENT_PROP_TYPE_EVENT, this.m_trade_event);
        return;
    }
//--- Pending order is modified
    if(this.IsPresentEventFlag(TRADE_EVENT_FLAG_ORDER_MODIFY))
    {
//--- If the placement price is modified
        if(this.IsPresentEventFlag(TRADE_EVENT_FLAG_PRICE))
        {
            this.m_trade_event = TRADE_EVENT_MODIFY_ORDER_PRICE;
            //--- If StopLoss and TakeProfit are modified
            if(this.IsPresentEventFlag(TRADE_EVENT_FLAG_SL) && this.IsPresentEventFlag(TRADE_EVENT_FLAG_TP)) this.m_trade_event = TRADE_EVENT_MODIFY_ORDER_PRICE_STOP_LOSS_TAKE_PROFIT;
            //--- If StopLoss is modified
            else if(this.IsPresentEventFlag(TRADE_EVENT_FLAG_SL))
                this.m_trade_event = TRADE_EVENT_MODIFY_ORDER_PRICE_STOP_LOSS;
            //--- If TakeProfit is modified
            else if(this.IsPresentEventFlag(TRADE_EVENT_FLAG_TP))
                this.m_trade_event = TRADE_EVENT_MODIFY_ORDER_PRICE_TAKE_PROFIT;
        }
//--- If the placement price is not modified
        else
        {
//--- If StopLoss and TakeProfit are modified
            if(this.IsPresentEventFlag(TRADE_EVENT_FLAG_SL) && this.IsPresentEventFlag(TRADE_EVENT_FLAG_TP)) this.m_trade_event = TRADE_EVENT_MODIFY_ORDER_STOP_LOSS_TAKE_PROFIT;
//--- If StopLoss is modified
            else if(this.IsPresentEventFlag(TRADE_EVENT_FLAG_SL))
                this.m_trade_event = TRADE_EVENT_MODIFY_ORDER_STOP_LOSS;
//--- If TakeProfit is modified
            else if(this.IsPresentEventFlag(TRADE_EVENT_FLAG_TP))
                this.m_trade_event = TRADE_EVENT_MODIFY_ORDER_TAKE_PROFIT;
        }
        this.SetProperty(EVENT_PROP_TYPE_EVENT, this.m_trade_event);
        return;
    }
//--- Position is modified
    if(this.IsPresentEventFlag(TRADE_EVENT_FLAG_POSITION_MODIFY))
    {
//--- If StopLoss and TakeProfit are modified
        if(this.IsPresentEventFlag(TRADE_EVENT_FLAG_SL) && this.IsPresentEventFlag(TRADE_EVENT_FLAG_TP)) this.m_trade_event = TRADE_EVENT_MODIFY_POSITION_STOP_LOSS_TAKE_PROFIT;
//--- If StopLoss is modified
        else if(this.IsPresentEventFlag(TRADE_EVENT_FLAG_SL))
            this.m_trade_event = TRADE_EVENT_MODIFY_POSITION_STOP_LOSS;
//--- If TakeProfit is modified
        else if(this.IsPresentEventFlag(TRADE_EVENT_FLAG_TP))
            this.m_trade_event = TRADE_EVENT_MODIFY_POSITION_TAKE_PROFIT;
        this.SetProperty(EVENT_PROP_TYPE_EVENT, this.m_trade_event);
        return;
    }
//--- Position is opened (Check for multiple flags in the event code)
    if(this.IsPresentEventFlag(TRADE_EVENT_FLAG_POSITION_OPENED))
    {
        //--- If an existing position is changed
        if(this.IsPresentEventFlag(TRADE_EVENT_FLAG_POSITION_CHANGED))
        {
            //--- If this pending order is activated by the price
            if(this.IsPresentEventFlag(TRADE_EVENT_FLAG_ORDER_ACTIVATED))
            {
                //--- If this is a position reversal
                if(this.IsPresentEventFlag(TRADE_EVENT_FLAG_POSITION_REVERSE))
                {
                    //--- check the partial closure flag and set the
                    //--- "position reversal by activation of a pending order" or "position reversal by partial activation of a pending order" trading event
                    this.m_trade_event = (!this.IsPresentEventFlag(TRADE_EVENT_FLAG_PARTIAL) ? TRADE_EVENT_POSITION_REVERSED_BY_PENDING : TRADE_EVENT_POSITION_REVERSED_BY_PENDING_PARTIAL);
                    this.SetProperty(EVENT_PROP_TYPE_EVENT, this.m_trade_event);
                    return;
                }
                //--- If this is adding a volume to a position
                else
                {
                    //--- check the partial closure flag and set the
                    //--- "added volume to a position by activating a pending order" or "added volume to a position by partially activating a pending order" trading event
                    this.m_trade_event = (!this.IsPresentEventFlag(TRADE_EVENT_FLAG_PARTIAL) ? TRADE_EVENT_POSITION_VOLUME_ADD_BY_PENDING : TRADE_EVENT_POSITION_VOLUME_ADD_BY_PENDING_PARTIAL);
                    this.SetProperty(EVENT_PROP_TYPE_EVENT, this.m_trade_event);
                    return;
                }
            }
            //--- If a position was changed by a market deal
            else
            {
                //--- If this is a position reversal
                if(this.IsPresentEventFlag(TRADE_EVENT_FLAG_POSITION_REVERSE))
                {
                    //--- check the partial opening flag and set the "position reversal" or "position reversal by partial execution" trading event
                    this.m_trade_event = (!this.IsPresentEventFlag(TRADE_EVENT_FLAG_PARTIAL) ? TRADE_EVENT_POSITION_REVERSED_BY_MARKET : TRADE_EVENT_POSITION_REVERSED_BY_MARKET_PARTIAL);
                    this.SetProperty(EVENT_PROP_TYPE_EVENT, this.m_trade_event);
                    return;
                }
                //--- If this is adding a volume to a position
                else
                {
                    //--- check the partial opening flag and set "added volume to a position" or "added volume to a position by partial execution" trading event
                    this.m_trade_event = (!this.IsPresentEventFlag(TRADE_EVENT_FLAG_PARTIAL) ? TRADE_EVENT_POSITION_VOLUME_ADD_BY_MARKET : TRADE_EVENT_POSITION_VOLUME_ADD_BY_MARKET_PARTIAL);
                    this.SetProperty(EVENT_PROP_TYPE_EVENT, this.m_trade_event);
                    return;
                }
            }
        }
        //--- If a new position is opened
        else
        {
            //--- If this pending order is activated by the price
            if(this.IsPresentEventFlag(TRADE_EVENT_FLAG_ORDER_ACTIVATED))
            {
                //--- check the partial closing flag and set the "pending order activated" or "pending order partially activated" trading event
                this.m_trade_event = (!this.IsPresentEventFlag(TRADE_EVENT_FLAG_PARTIAL) ? TRADE_EVENT_PENDING_ORDER_ACTIVATED : TRADE_EVENT_PENDING_ORDER_ACTIVATED_PARTIAL);
                this.SetProperty(EVENT_PROP_TYPE_EVENT, this.m_trade_event);
                return;
            }
            //--- check the partial opening flag and set the "Position opened" or "Position partially opened" trading event
            this.m_trade_event = (!this.IsPresentEventFlag(TRADE_EVENT_FLAG_PARTIAL) ? TRADE_EVENT_POSITION_OPENED : TRADE_EVENT_POSITION_OPENED_PARTIAL);
            this.SetProperty(EVENT_PROP_TYPE_EVENT, this.m_trade_event);
            return;
        }
    }
//--- Position is closed (Check for multiple flags in the event code)
    if(this.IsPresentEventFlag(TRADE_EVENT_FLAG_POSITION_CLOSED))
    {
        //--- if the position is closed by StopLoss
        if(this.IsPresentEventFlag(TRADE_EVENT_FLAG_SL))
        {
            //--- check the partial closing flag and set the "Position closed by StopLoss" or "Position closed by StopLoss partially" trading event
            this.m_trade_event = (!this.IsPresentEventFlag(TRADE_EVENT_FLAG_PARTIAL) ? TRADE_EVENT_POSITION_CLOSED_BY_SL : TRADE_EVENT_POSITION_CLOSED_PARTIAL_BY_SL);
            this.SetProperty(EVENT_PROP_TYPE_EVENT, this.m_trade_event);
            return;
        }
        //--- if the position is closed by TakeProfit
        else if(this.IsPresentEventFlag(TRADE_EVENT_FLAG_TP))
        {
            //--- check the partial closing flag and set the "Position closed by TakeProfit" or "Position closed by TakeProfit partially" trading event
            this.m_trade_event = (!this.IsPresentEventFlag(TRADE_EVENT_FLAG_PARTIAL) ? TRADE_EVENT_POSITION_CLOSED_BY_TP : TRADE_EVENT_POSITION_CLOSED_PARTIAL_BY_TP);
            this.SetProperty(EVENT_PROP_TYPE_EVENT, this.m_trade_event);
            return;
        }
        //--- if the position is closed by an opposite one
        else if(this.IsPresentEventFlag(TRADE_EVENT_FLAG_BY_POS))
        {
            //--- check the partial closing flag and set the "Position closed by opposite one" or "Position closed by opposite one partially" event
            this.m_trade_event = (!this.IsPresentEventFlag(TRADE_EVENT_FLAG_PARTIAL) ? TRADE_EVENT_POSITION_CLOSED_BY_POS : TRADE_EVENT_POSITION_CLOSED_PARTIAL_BY_POS);
            this.SetProperty(EVENT_PROP_TYPE_EVENT, this.m_trade_event);
            return;
        }
        //--- If the position is closed
        else
        {
            //--- check the partial closing flag and set the "Position closed" or "Position closed partially" event
            this.m_trade_event = (!this.IsPresentEventFlag(TRADE_EVENT_FLAG_PARTIAL) ? TRADE_EVENT_POSITION_CLOSED : TRADE_EVENT_POSITION_CLOSED_PARTIAL);
            this.SetProperty(EVENT_PROP_TYPE_EVENT, this.m_trade_event);
            return;
        }
    }
//--- Balance operation on the account (clarify the event by the deal type)
    if(this.m_event_code == TRADE_EVENT_FLAG_ACCOUNT_BALANCE)
    {
        //--- Initialize the trading event
        this.m_trade_event       = TRADE_EVENT_NO_EVENT;
        //--- Take a deal type
        ENUM_DEAL_TYPE deal_type = (ENUM_DEAL_TYPE) this.GetProperty(EVENT_PROP_TYPE_DEAL_EVENT);
        //--- if the deal is a balance operation
        if(deal_type == DEAL_TYPE_BALANCE)
        {
            //--- check the deal profit and set the event (funds deposit or withdrawal)
            this.m_trade_event = (this.GetProperty(EVENT_PROP_PROFIT) > 0 ? TRADE_EVENT_ACCOUNT_BALANCE_REFILL : TRADE_EVENT_ACCOUNT_BALANCE_WITHDRAWAL);
        }
        //--- Remaining balance operation types match the ENUM_DEAL_TYPE enumeration starting with DEAL_TYPE_CREDIT
        else if(deal_type > DEAL_TYPE_BALANCE)
        {
            //--- set the event
            this.m_trade_event = (ENUM_TRADE_EVENT) deal_type;
        }
        this.SetProperty(EVENT_PROP_TYPE_EVENT, this.m_trade_event);
        return;
    }
}
//+------------------------------------------------------------------+
//| Return the description of the event's integer property           |
//+------------------------------------------------------------------+
string CEvent::GetPropertyDescription(ENUM_EVENT_PROP_INTEGER property)
{
    return (property == EVENT_PROP_TYPE_EVENT               ? TextByLanguage("Event's type") + ": " + this.TypeEventDescription()
            : property == EVENT_PROP_TIME_EVENT             ? TextByLanguage("Time of event") + ": " + TimeMSCtoString(this.GetProperty(property))
            : property == EVENT_PROP_STATUS_EVENT           ? TextByLanguage("Status of event") + ": \"" + this.StatusDescription() + "\""
            : property == EVENT_PROP_REASON_EVENT           ? TextByLanguage("Reason of event") + ": " + this.ReasonDescription()
            : property == EVENT_PROP_TYPE_DEAL_EVENT        ? TextByLanguage("Deal's type") + ": " + DealTypeDescription((ENUM_DEAL_TYPE) this.GetProperty(property))
            : property == EVENT_PROP_TICKET_DEAL_EVENT      ? TextByLanguage("Deal's ticket") + " #" + (string) this.GetProperty(property)
            : property == EVENT_PROP_TYPE_ORDER_EVENT       ? TextByLanguage("Event's order type") + ": " + OrderTypeDescription((ENUM_ORDER_TYPE) this.GetProperty(property))
            : property == EVENT_PROP_TYPE_ORDER_POSITION    ? TextByLanguage("Position's order type") + ": " + OrderTypeDescription((ENUM_ORDER_TYPE) this.GetProperty(property))
            : property == EVENT_PROP_TICKET_ORDER_POSITION  ? TextByLanguage("Position's first order ticket") + " #" + (string) this.GetProperty(property)
            : property == EVENT_PROP_TICKET_ORDER_EVENT     ? TextByLanguage("Event's order ticket") + " #" + (string) this.GetProperty(property)
            : property == EVENT_PROP_POSITION_ID            ? TextByLanguage("Position ID") + " #" + (string) this.GetProperty(property)
            : property == EVENT_PROP_POSITION_BY_ID         ? TextByLanguage("Opposite position's ID") + " #" + (string) this.GetProperty(property)
            : property == EVENT_PROP_MAGIC_ORDER            ? TextByLanguage("Magic number") + ": " + (string) this.GetProperty(property)
            : property == EVENT_PROP_MAGIC_BY_ID            ? TextByLanguage("Magic number of opposite position") + ": " + (string) this.GetProperty(property)
            : property == EVENT_PROP_TIME_ORDER_POSITION    ? TextByLanguage("Position's opened time") + ": " + TimeMSCtoString(this.GetProperty(property))
            : property == EVENT_PROP_TYPE_ORD_POS_BEFORE    ? TextByLanguage("Position order type before changing direction")
            : property == EVENT_PROP_TICKET_ORD_POS_BEFORE  ? TextByLanguage("Position order ticket before changing direction")
            : property == EVENT_PROP_TYPE_ORD_POS_CURRENT   ? TextByLanguage("Current position order type")
            : property == EVENT_PROP_TICKET_ORD_POS_CURRENT ? TextByLanguage("Current position order ticket")
                                                            : EnumToString(property));
}
//+------------------------------------------------------------------+
//| Return the description of the event's real property              |
//+------------------------------------------------------------------+
string CEvent::GetPropertyDescription(ENUM_EVENT_PROP_DOUBLE property)
{
    int dg  = (int) ::SymbolInfoInteger(this.GetProperty(EVENT_PROP_SYMBOL), SYMBOL_DIGITS);
    int dgl = (int) DigitsLots(this.GetProperty(EVENT_PROP_SYMBOL));
    return (property == EVENT_PROP_PRICE_EVENT                ? TextByLanguage("Price at the time of event") + ": " + ::DoubleToString(this.GetProperty(property), dg)
            : property == EVENT_PROP_PRICE_OPEN               ? TextByLanguage("Open price") + ": " + ::DoubleToString(this.GetProperty(property), dg)
            : property == EVENT_PROP_PRICE_CLOSE              ? TextByLanguage("Close price") + ": " + ::DoubleToString(this.GetProperty(property), dg)
            : property == EVENT_PROP_PRICE_SL                 ? TextByLanguage("StopLoss price") + ": " + ::DoubleToString(this.GetProperty(property), dg)
            : property == EVENT_PROP_PRICE_TP                 ? TextByLanguage("TakeProfit price") + ": " + ::DoubleToString(this.GetProperty(property), dg)
            : property == EVENT_PROP_VOLUME_ORDER_INITIAL     ? TextByLanguage("Initial volume") + ": " + ::DoubleToString(this.GetProperty(property), dgl)
            : property == EVENT_PROP_VOLUME_ORDER_EXECUTED    ? TextByLanguage("Executed volume") + ": " + ::DoubleToString(this.GetProperty(property), dgl)
            : property == EVENT_PROP_VOLUME_ORDER_CURRENT     ? TextByLanguage("Remaining volume") + ": " + ::DoubleToString(this.GetProperty(property), dgl)
            : property == EVENT_PROP_VOLUME_POSITION_EXECUTED ? TextByLanguage("Position current volume") + ": " + ::DoubleToString(this.GetProperty(property), dgl)
            : property == EVENT_PROP_PROFIT                   ? TextByLanguage("Profit") + ": " + ::DoubleToString(this.GetProperty(property), this.m_digits_acc)
            : property == EVENT_PROP_PRICE_OPEN_BEFORE        ? TextByLanguage("Open price before modification") + ": " + ::DoubleToString(this.GetProperty(property), dg)
            : property == EVENT_PROP_PRICE_SL_BEFORE          ? TextByLanguage("StopLoss price before modification") + ": " + ::DoubleToString(this.GetProperty(property), dg)
            : property == EVENT_PROP_PRICE_TP_BEFORE          ? TextByLanguage("TakeProfit price before modification") + ": " + ::DoubleToString(this.GetProperty(property), dg)
            : property == EVENT_PROP_PRICE_EVENT_ASK          ? TextByLanguage("Ask price at the time of event") + ": " + ::DoubleToString(this.GetProperty(property), dg)
            : property == EVENT_PROP_PRICE_EVENT_BID          ? TextByLanguage("Bid price at the time of event") + ": " + ::DoubleToString(this.GetProperty(property), dg)
                                                              : EnumToString(property));
}
//+------------------------------------------------------------------+
//| Return the description of the event's string property            |
//+------------------------------------------------------------------+
string CEvent::GetPropertyDescription(ENUM_EVENT_PROP_STRING property)
{
    return (property == EVENT_PROP_SYMBOL ? TextByLanguage("Symbol") + ": \"" + this.GetProperty(property) + "\""
                                          : TextByLanguage("Symbol of opposite position") + ": \"" + this.GetProperty(property) + "\"");
}
//+------------------------------------------------------------------+
//| Return the event status name                                     |
//+------------------------------------------------------------------+
string CEvent::StatusDescription(void) const
{
    ENUM_EVENT_STATUS status = (ENUM_EVENT_STATUS) this.GetProperty(EVENT_PROP_STATUS_EVENT);
    return (status == EVENT_STATUS_MARKET_PENDING     ? TextByLanguage("Pending order placed")
            : status == EVENT_STATUS_MARKET_POSITION  ? TextByLanguage("Position opened")
            : status == EVENT_STATUS_HISTORY_PENDING  ? TextByLanguage("Pending order removed")
            : status == EVENT_STATUS_HISTORY_POSITION ? TextByLanguage("Position closed")
            : status == EVENT_STATUS_BALANCE          ? TextByLanguage("Balance operation")
                                                      : TextByLanguage("Unknown status"));
}
//+------------------------------------------------------------------+
//| Return the trading event name                                    |
//+------------------------------------------------------------------+
string CEvent::TypeEventDescription(void) const
{
    ENUM_TRADE_EVENT event = this.TypeEvent();
    return (event == TRADE_EVENT_NO_EVENT                          ? TextByLanguage("No trade event")
            : event == TRADE_EVENT_PENDING_ORDER_PLASED            ? TextByLanguage("Pending order placed")
            : event == TRADE_EVENT_PENDING_ORDER_REMOVED           ? TextByLanguage("Pending order removed")
            : event == TRADE_EVENT_ACCOUNT_CREDIT                  ? TextByLanguage("Credit")
            : event == TRADE_EVENT_ACCOUNT_CHARGE                  ? TextByLanguage("Additional charge")
            : event == TRADE_EVENT_ACCOUNT_CORRECTION              ? TextByLanguage("Correction")
            : event == TRADE_EVENT_ACCOUNT_BONUS                   ? TextByLanguage("Bonus")
            : event == TRADE_EVENT_ACCOUNT_COMISSION               ? TextByLanguage("Additional commission")
            : event == TRADE_EVENT_ACCOUNT_COMISSION_DAILY         ? TextByLanguage("Daily commission")
            : event == TRADE_EVENT_ACCOUNT_COMISSION_MONTHLY       ? TextByLanguage("Monthly commission")
            : event == TRADE_EVENT_ACCOUNT_COMISSION_AGENT_DAILY   ? TextByLanguage("Daily agent commission")
            : event == TRADE_EVENT_ACCOUNT_COMISSION_AGENT_MONTHLY ? TextByLanguage("Monthly agent commission")
            : event == TRADE_EVENT_ACCOUNT_INTEREST                ? TextByLanguage("Interest rate")
            : event == TRADE_EVENT_BUY_CANCELLED                   ? TextByLanguage("Canceled buy deal")
            : event == TRADE_EVENT_SELL_CANCELLED                  ? TextByLanguage("Canceled sell deal")
            : event == TRADE_EVENT_DIVIDENT                        ? TextByLanguage("Dividend operations")
            : event == TRADE_EVENT_DIVIDENT_FRANKED                ? TextByLanguage("Franked (non-taxable) dividend operations")
            : event == TRADE_EVENT_TAX                             ? TextByLanguage("Tax charges")
            : event == TRADE_EVENT_ACCOUNT_BALANCE_REFILL          ? TextByLanguage("Balance refill")
            : event == TRADE_EVENT_ACCOUNT_BALANCE_WITHDRAWAL      ? TextByLanguage("Withdrawals")
            : event == TRADE_EVENT_PENDING_ORDER_ACTIVATED         ? TextByLanguage("Pending order activated")
            : event == TRADE_EVENT_PENDING_ORDER_ACTIVATED_PARTIAL ? TextByLanguage("Pending order activated partially")
            : event == TRADE_EVENT_POSITION_OPENED                 ? TextByLanguage("Position opened")
            : event == TRADE_EVENT_POSITION_OPENED_PARTIAL         ? TextByLanguage("Position opened partially")
            : event == TRADE_EVENT_POSITION_CLOSED                 ? TextByLanguage("Position closed")
            : event == TRADE_EVENT_POSITION_CLOSED_PARTIAL         ? TextByLanguage("Position closed partially")
            : event == TRADE_EVENT_POSITION_CLOSED_BY_POS          ? TextByLanguage("Position closed by opposite position")
            : event == TRADE_EVENT_POSITION_CLOSED_PARTIAL_BY_POS  ? TextByLanguage("Position closed partially by opposite position")
            : event == TRADE_EVENT_POSITION_CLOSED_BY_SL           ? TextByLanguage("Position closed by StopLoss")
            : event == TRADE_EVENT_POSITION_CLOSED_BY_TP           ? TextByLanguage("Position closed by TakeProfit")
            : event == TRADE_EVENT_POSITION_CLOSED_PARTIAL_BY_SL   ? TextByLanguage("Position closed partially by StopLoss")
            : event == TRADE_EVENT_POSITION_CLOSED_PARTIAL_BY_TP   ? TextByLanguage("Position closed partially by TakeProfit")
            : event == TRADE_EVENT_POSITION_REVERSED_BY_MARKET     ? TextByLanguage("Position reversal by market request")
            : event == TRADE_EVENT_POSITION_REVERSED_BY_PENDING    ? TextByLanguage("Position reversal by a triggered pending order")
            : event == TRADE_EVENT_POSITION_VOLUME_ADD_BY_MARKET   ? TextByLanguage("Added volume to position by market request")
            : event == TRADE_EVENT_POSITION_VOLUME_ADD_BY_PENDING  ? TextByLanguage("Added volume to the position by activation of a pending order")
            :

            event == TRADE_EVENT_POSITION_REVERSED_BY_MARKET_PARTIAL      ? TextByLanguage("Position reversal by partial completion of market request")
            : event == TRADE_EVENT_POSITION_REVERSED_BY_PENDING_PARTIAL   ? TextByLanguage("Position reversal by a partially triggered pending order")
            : event == TRADE_EVENT_POSITION_VOLUME_ADD_BY_MARKET_PARTIAL  ? TextByLanguage("Added volume to position by partial completion of a market request")
            : event == TRADE_EVENT_POSITION_VOLUME_ADD_BY_PENDING_PARTIAL ? TextByLanguage("Added volume to position by a triggered pending order")
            :

            event == TRADE_EVENT_TRIGGERED_STOP_LIMIT_ORDER                 ? TextByLanguage("StopLimit order triggered.")
            : event == TRADE_EVENT_MODIFY_ORDER_PRICE                       ? TextByLanguage("Modified order price")
            : event == TRADE_EVENT_MODIFY_ORDER_PRICE_STOP_LOSS             ? TextByLanguage("Modified order price and StopLoss")
            : event == TRADE_EVENT_MODIFY_ORDER_PRICE_TAKE_PROFIT           ? TextByLanguage("Modified order price and TakeProfit")
            : event == TRADE_EVENT_MODIFY_ORDER_PRICE_STOP_LOSS_TAKE_PROFIT ? TextByLanguage("Modified order price, StopLoss and TakeProfit")
            : event == TRADE_EVENT_MODIFY_ORDER_STOP_LOSS_TAKE_PROFIT       ? TextByLanguage("Modified order's StopLoss and TakeProfit")
            : event == TRADE_EVENT_MODIFY_ORDER_STOP_LOSS                   ? TextByLanguage("Modified order's StopLoss")
            : event == TRADE_EVENT_MODIFY_ORDER_TAKE_PROFIT                 ? TextByLanguage("Modified order's TakeProfit")
            : event == TRADE_EVENT_MODIFY_POSITION_STOP_LOSS_TAKE_PROFIT    ? TextByLanguage("Modified position's StopLoss and TakeProfit")
            : event == TRADE_EVENT_MODIFY_POSITION_STOP_LOSS                ? TextByLanguage("Modified position's StopLoss")
            : event == TRADE_EVENT_MODIFY_POSITION_TAKE_PROFIT              ? TextByLanguage("Modified position's TakeProfit")
                                                                            : EnumToString(event));
}
//+------------------------------------------------------------------+
//| Return the name of the order/position/deal                       |
//+------------------------------------------------------------------+
string CEvent::TypeOrderDealDescription(void) const
{
    ENUM_EVENT_STATUS status = this.Status();
    return (status == EVENT_STATUS_MARKET_PENDING || status == EVENT_STATUS_HISTORY_PENDING     ? OrderTypeDescription((ENUM_ORDER_TYPE) this.GetProperty(EVENT_PROP_TYPE_ORDER_EVENT))
            : status == EVENT_STATUS_MARKET_POSITION || status == EVENT_STATUS_HISTORY_POSITION ? PositionTypeDescription((ENUM_POSITION_TYPE) this.GetProperty(EVENT_PROP_TYPE_DEAL_EVENT))
            : status == EVENT_STATUS_BALANCE                                                    ? DealTypeDescription((ENUM_DEAL_TYPE) this.GetProperty(EVENT_PROP_TYPE_DEAL_EVENT))
                                                                                                : TextByLanguage("Unknown order type"));
}
//+------------------------------------------------------------------+
//| Return the name of the position's first order                    |
//+------------------------------------------------------------------+
string CEvent::TypeOrderFirstDescription(void) const { return OrderTypeDescription((ENUM_ORDER_TYPE) this.GetProperty(EVENT_PROP_TYPE_ORDER_POSITION)); }
//+------------------------------------------------------------------+
//| Return the name of the order that changed the position           |
//+------------------------------------------------------------------+
string CEvent::TypeOrderEventDescription(void) const { return OrderTypeDescription(this.TypeOrderEvent()); }
//+------------------------------------------------------------------+
//| Return the name of the current position                          |
//+------------------------------------------------------------------+
string CEvent::TypePositionCurrentDescription(void) const { return PositionTypeDescription(this.TypePositionCurrent()); }
//+------------------------------------------------------------------+
//| Return the name of the order before changing the direction       |
//+------------------------------------------------------------------+
string CEvent::TypeOrderPreviousDescription(void) const { return OrderTypeDescription(this.TypeOrderPosPrevious()); }
//+------------------------------------------------------------------+
//| Return the name of the position before changing the direction    |
//+------------------------------------------------------------------+
string CEvent::TypePositionPreviousDescription(void) const { return PositionTypeDescription(this.TypePositionPrevious()); }
//+------------------------------------------------------------------+
//| Return the name of the deal/order/position reason                |
//+------------------------------------------------------------------+
string CEvent::ReasonDescription(void) const
{
    ENUM_EVENT_REASON reason = this.Reason();
    return (reason == EVENT_REASON_ACTIVATED_PENDING                 ? TextByLanguage("Pending order activated")
            : reason == EVENT_REASON_ACTIVATED_PENDING_PARTIALLY     ? TextByLanguage("Pending order partially triggered")
            : reason == EVENT_REASON_STOPLIMIT_TRIGGERED             ? TextByLanguage("StopLimit order triggered")
            : reason == EVENT_REASON_MODIFY                          ? TextByLanguage("Modified")
            : reason == EVENT_REASON_CANCEL                          ? TextByLanguage("Canceled")
            : reason == EVENT_REASON_EXPIRED                         ? TextByLanguage("Expired")
            : reason == EVENT_REASON_DONE                            ? TextByLanguage("Fully completed market request")
            : reason == EVENT_REASON_DONE_PARTIALLY                  ? TextByLanguage("Partially completed market request")
            : reason == EVENT_REASON_VOLUME_ADD                      ? TextByLanguage("Added volume to position")
            : reason == EVENT_REASON_VOLUME_ADD_PARTIALLY            ? TextByLanguage("Volume added to position by request partial completion")
            : reason == EVENT_REASON_VOLUME_ADD_BY_PENDING           ? TextByLanguage("Added volume to position by triggering pending order")
            : reason == EVENT_REASON_VOLUME_ADD_BY_PENDING_PARTIALLY ? TextByLanguage("Added volume to position by partially triggered pending order")
            : reason == EVENT_REASON_REVERSE                         ? TextByLanguage("Position reversal")
            : reason == EVENT_REASON_REVERSE_PARTIALLY               ? TextByLanguage("Position reversal by partial request execution")
            : reason == EVENT_REASON_REVERSE_BY_PENDING              ? TextByLanguage("Position reversal on triggered pending order")
            : reason == EVENT_REASON_REVERSE_BY_PENDING_PARTIALLY    ? TextByLanguage("Position reversal on partially triggered pending order")
            : reason == EVENT_REASON_DONE_SL                         ? TextByLanguage("Close by StopLoss triggered")
            : reason == EVENT_REASON_DONE_SL_PARTIALLY               ? TextByLanguage("Partial close by StopLoss triggered")
            : reason == EVENT_REASON_DONE_TP                         ? TextByLanguage("Close by TakeProfit triggered")
            : reason == EVENT_REASON_DONE_TP_PARTIALLY               ? TextByLanguage("Partial close by TakeProfit triggered")
            : reason == EVENT_REASON_DONE_BY_POS                     ? TextByLanguage("Closed by opposite position")
            : reason == EVENT_REASON_DONE_PARTIALLY_BY_POS           ? TextByLanguage("Closed partially by opposite position")
            : reason == EVENT_REASON_DONE_BY_POS_PARTIALLY           ? TextByLanguage("Closed by incomplete volume of opposite position")
            : reason == EVENT_REASON_DONE_PARTIALLY_BY_POS_PARTIALLY ? TextByLanguage("Closed partially by incomplete volume of opposite position")
            : reason == EVENT_REASON_BALANCE_REFILL                  ? TextByLanguage("Balance refill")
            : reason == EVENT_REASON_BALANCE_WITHDRAWAL              ? TextByLanguage("Withdrawals from the balance")
            : reason == EVENT_REASON_ACCOUNT_CREDIT                  ? TextByLanguage("Credit")
            : reason == EVENT_REASON_ACCOUNT_CHARGE                  ? TextByLanguage("Additional charge")
            : reason == EVENT_REASON_ACCOUNT_CORRECTION              ? TextByLanguage("Correction")
            : reason == EVENT_REASON_ACCOUNT_BONUS                   ? TextByLanguage("Bonus")
            : reason == EVENT_REASON_ACCOUNT_COMISSION               ? TextByLanguage("Additional commission")
            : reason == EVENT_REASON_ACCOUNT_COMISSION_DAILY         ? TextByLanguage("Daily commission")
            : reason == EVENT_REASON_ACCOUNT_COMISSION_MONTHLY       ? TextByLanguage("Monthly commission")
            : reason == EVENT_REASON_ACCOUNT_COMISSION_AGENT_DAILY   ? TextByLanguage("Daily agent commission")
            : reason == EVENT_REASON_ACCOUNT_COMISSION_AGENT_MONTHLY ? TextByLanguage("Monthly agent commission")
            : reason == EVENT_REASON_ACCOUNT_INTEREST                ? TextByLanguage("Interest rate")
            : reason == EVENT_REASON_BUY_CANCELLED                   ? TextByLanguage("Canceled buy deal")
            : reason == EVENT_REASON_SELL_CANCELLED                  ? TextByLanguage("Canceled sell deal")
            : reason == EVENT_REASON_DIVIDENT                        ? TextByLanguage("Dividend operations")
            : reason == EVENT_REASON_DIVIDENT_FRANKED                ? TextByLanguage("Franked (non-taxable) dividend operations")
            : reason == EVENT_REASON_TAX                             ? TextByLanguage("Tax charges")
                                                                     : EnumToString(reason));
}
//+------------------------------------------------------------------+
//| Display the event properties in the journal                      |
//+------------------------------------------------------------------+
void CEvent::Print(const bool full_prop = false)
{
    ::Print("============= ", TextByLanguage("Beginning of event parameter list: \""), this.StatusDescription(), "\" =============");
    int beg = 0, end = EVENT_PROP_INTEGER_TOTAL;
    for(int i = beg; i < end; i++)
    {
        ENUM_EVENT_PROP_INTEGER prop = (ENUM_EVENT_PROP_INTEGER) i;
        if(!full_prop && !this.SupportProperty(prop)) continue;
        ::Print(this.GetPropertyDescription(prop));
    }
    ::Print("------");
    beg  = end;
    end += EVENT_PROP_DOUBLE_TOTAL;
    for(int i = beg; i < end; i++)
    {
        ENUM_EVENT_PROP_DOUBLE prop = (ENUM_EVENT_PROP_DOUBLE) i;
        if(!full_prop && !this.SupportProperty(prop)) continue;
        ::Print(this.GetPropertyDescription(prop));
    }
    ::Print("------");
    beg  = end;
    end += EVENT_PROP_STRING_TOTAL;
    for(int i = beg; i < end; i++)
    {
        ENUM_EVENT_PROP_STRING prop = (ENUM_EVENT_PROP_STRING) i;
        if(!full_prop && !this.SupportProperty(prop)) continue;
        ::Print(this.GetPropertyDescription(prop));
    }
    ::Print("================== ", TextByLanguage("End of parameter list: \""), this.StatusDescription(), "\" ==================\n");
}
//+------------------------------------------------------------------+
