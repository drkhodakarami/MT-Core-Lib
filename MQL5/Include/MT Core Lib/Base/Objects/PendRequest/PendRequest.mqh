//+------------------------------------------------------------------+
//|                                                  PendRequest.mqh |
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
#include "../../Services/MTLib.mqh"
#include <Object.mqh>
//+------------------------------------------------------------------+
//| Abstract pending trading request class                           |
//+------------------------------------------------------------------+
class CPendRequest : public CObject
{
  private:
    MqlTradeRequest m_request;    // Trading request structure
    CPause          m_pause;      // Pause class object
    //--- Copy trading request data
    void            CopyRequest(const MqlTradeRequest &request);
    //--- Return the index of the array the request (1) double and (2) string properties are actually located at
    int             IndexProp(ENUM_PEND_REQ_PROP_DOUBLE property) const { return (int) property - PEND_REQ_PROP_INTEGER_TOTAL; }
    int             IndexProp(ENUM_PEND_REQ_PROP_STRING property) const { return (int) property - PEND_REQ_PROP_INTEGER_TOTAL - PEND_REQ_PROP_DOUBLE_TOTAL; }

  protected:
    int    m_digits;                                     // Number of decimal places in a quote
    int    m_digits_lot;                                 // Number of decimal places in the symbol lot value
    bool   m_is_hedge;                                   // Hedging account flag
    long   m_long_prop[PEND_REQ_PROP_INTEGER_TOTAL];     // Request integer properties
    double m_double_prop[PEND_REQ_PROP_DOUBLE_TOTAL];    // Request real properties
    string m_string_prop[PEND_REQ_PROP_STRING_TOTAL];    // Request string properties
                                                         //--- Protected parametric constructor
    CPendRequest(const ENUM_PEND_REQ_STATUS status,
                 const uchar                id,
                 const double               price,
                 const ulong                time,
                 const MqlTradeRequest     &request,
                 const int                  retcode);
    //--- Return (1) the magic number specified in the settings, (2) hedging account flag, (3) flag indicating the real property is equal to the value
    ushort GetMagicID(void) const { return ushort(this.GetProperty(PEND_REQ_PROP_MQL_REQ_MAGIC) & 0xFFFF); }
    bool   IsHedge(void) const { return this.m_is_hedge; }
    bool   IsEqualByMode(const int mode, const double value) const;
    bool   IsEqualByMode(const int mode, const long value) const;
    //--- Return the flags indicating the pending request has completed changing each of the order/position parameters
    bool   IsCompletedVolume(void) const;
    bool   IsCompletedPrice(void) const;
    bool   IsCompletedStopLimit(void) const;
    bool   IsCompletedStopLoss(void) const;
    bool   IsCompletedTakeProfit(void) const;
    bool   IsCompletedTypeFilling(void) const;
    bool   IsCompletedTypeTime(void) const;
    bool   IsCompletedExpiration(void) const;

  public:
    //--- Default constructor
    CPendRequest() { ; }
    //--- Set request (1) integer, (2) real and (3) string properties
    void                       SetProperty(ENUM_PEND_REQ_PROP_INTEGER property, long value) { this.m_long_prop[property] = value; }
    void                       SetProperty(ENUM_PEND_REQ_PROP_DOUBLE property, double value) { this.m_double_prop[this.IndexProp(property)] = value; }
    void                       SetProperty(ENUM_PEND_REQ_PROP_STRING property, string value) { this.m_string_prop[this.IndexProp(property)] = value; }
    //--- Return (1) integer, (2) real and (3) string request properties from the properties array
    long                       GetProperty(ENUM_PEND_REQ_PROP_INTEGER property) const { return this.m_long_prop[property]; }
    double                     GetProperty(ENUM_PEND_REQ_PROP_DOUBLE property) const { return this.m_double_prop[this.IndexProp(property)]; }
    string                     GetProperty(ENUM_PEND_REQ_PROP_STRING property) const { return this.m_string_prop[this.IndexProp(property)]; }

    //--- Return the flag of the request supporting the property
    virtual bool               SupportProperty(ENUM_PEND_REQ_PROP_INTEGER property) { return true; }
    virtual bool               SupportProperty(ENUM_PEND_REQ_PROP_DOUBLE property) { return true; }
    virtual bool               SupportProperty(ENUM_PEND_REQ_PROP_STRING property) { return true; }

    //--- Return the flag indicating the pending request has completed its work
    virtual bool               IsCompleted(void) const { return false; }
    //--- Return itself
    CPendRequest              *GetObject(void) { return &this; }

    //--- Compare CPendRequest objects by a specified property (to sort the lists by a specified request object property)
    virtual int                Compare(const CObject *node, const int mode = 0) const;
    //--- Compare CPendRequest objects by all properties (to search for equal request objects)
    bool                       IsEqual(CPendRequest *compared_obj);
    //--- Return (1) the elapsed number of milliseconds, (2) waiting time completion from the pause object,
    //--- time of the (3) pause countdown start in milliseconds and (4) waiting time
    ulong                      PausePassed(void) const { return this.m_pause.Passed(); }
    bool                       PauseIsCompleted(void) const { return this.m_pause.IsCompleted(); }
    ulong                      PauseTimeBegin(void) const { return this.m_pause.TimeBegin(); }
    ulong                      PauseTimeWait(void) const { return this.m_pause.TimeWait(); }
    //--- Return the description (1) of an elapsed number of pause waiting seconds,
    //--- (2) pause countdown start time, as well as waiting time (3) in milliseconds and (4) in seconds
    string                     PausePassedDescription(void) const { return this.m_pause.PassedDescription(); }
    string                     PauseTimeBeginDescription(void) const { return this.m_pause.TimeBeginDescription(); }
    string                     PauseWaitingMSCDescription(void) const { return this.m_pause.WaitingMSCDescription(); }
    string                     PauseWaitingSecDescription(void) const { return this.m_pause.WaitingSECDescription(); }

    //+------------------------------------------------------------------+
    //| Methods of a simplified access to the request object properties  |
    //+------------------------------------------------------------------+
    //--- Return (1) request structure, (2) status, (3) type, (4) price at the moment of the request generation,
    //--- (5) request generation time, (6) next attempt activation time,
    //--- (7) waiting time between requests, (8) current attempt index,
    //--- (9) number of attempts, (10) request ID
    //--- (11) result a request is based on,
    //--- (12) order ticket, (13) position ticket, (14) trading operation type
    MqlTradeRequest            MqlRequest(void) const { return this.m_request; }
    ENUM_PEND_REQ_STATUS       Status(void) const { return (ENUM_PEND_REQ_STATUS) this.GetProperty(PEND_REQ_PROP_STATUS); }
    ENUM_PEND_REQ_TYPE         TypeRequest(void) const { return (ENUM_PEND_REQ_TYPE) this.GetProperty(PEND_REQ_PROP_TYPE); }
    double                     PriceCreate(void) const { return this.GetProperty(PEND_REQ_PROP_PRICE_CREATE); }
    ulong                      TimeCreate(void) const { return this.GetProperty(PEND_REQ_PROP_TIME_CREATE); }
    ulong                      TimeActivate(void) const { return this.GetProperty(PEND_REQ_PROP_TIME_ACTIVATE); }
    ulong                      WaitingMSC(void) const { return this.GetProperty(PEND_REQ_PROP_WAITING); }
    uchar                      CurrentAttempt(void) const { return (uchar) this.GetProperty(PEND_REQ_PROP_CURRENT_ATTEMPT); }
    uchar                      TotalAttempts(void) const { return (uchar) this.GetProperty(PEND_REQ_PROP_TOTAL); }
    uchar                      ID(void) const { return (uchar) this.GetProperty(PEND_REQ_PROP_ID); }
    int                        Retcode(void) const { return (int) this.GetProperty(PEND_REQ_PROP_RETCODE); }
    ulong                      Order(void) const { return this.GetProperty(PEND_REQ_PROP_MQL_REQ_ORDER); }
    ulong                      Position(void) const { return this.GetProperty(PEND_REQ_PROP_MQL_REQ_POSITION); }
    ENUM_TRADE_REQUEST_ACTIONS Action(void) const { return (ENUM_TRADE_REQUEST_ACTIONS) this.GetProperty(PEND_REQ_PROP_MQL_REQ_ACTION); }
    
    //--- Return the actual (1) volume, (2) order, (3) limit order,
    //--- (4) stoploss order and (5) takeprofit order prices, (6) order filling type,
    //--- (7) order expiration type and (8) order lifetime
    double                     ActualVolume(void) const { return this.GetProperty(PEND_REQ_PROP_ACTUAL_VOLUME); }
    double                     ActualPrice(void) const { return this.GetProperty(PEND_REQ_PROP_ACTUAL_PRICE); }
    double                     ActualStopLimit(void) const { return this.GetProperty(PEND_REQ_PROP_ACTUAL_STOPLIMIT); }
    double                     ActualSL(void) const { return this.GetProperty(PEND_REQ_PROP_ACTUAL_SL); }
    double                     ActualTP(void) const { return this.GetProperty(PEND_REQ_PROP_ACTUAL_TP); }
    ENUM_ORDER_TYPE_FILLING    ActualTypeFilling(void) const { return (ENUM_ORDER_TYPE_FILLING) this.GetProperty(PEND_REQ_PROP_ACTUAL_TYPE_FILLING); }
    ENUM_ORDER_TYPE_TIME       ActualTypeTime(void) const { return (ENUM_ORDER_TYPE_TIME) this.GetProperty(PEND_REQ_PROP_ACTUAL_TYPE_TIME); }
    datetime                   ActualExpiration(void) const { return (datetime) this.GetProperty(PEND_REQ_PROP_ACTUAL_EXPIRATION); }

    //--- Set (1) the price when creating a request, (2) request creation time,
    //--- (3) current attempt time, (4) waiting time between requests,
    //--- (5) current attempt index, (6) number of attempts, (7) ID,
    //--- (8) order ticket, (9) position ticket
    void                       SetPriceCreate(const double price) { this.SetProperty(PEND_REQ_PROP_PRICE_CREATE, price); }
    void                       SetTimeCreate(const ulong time)
    {
        this.SetProperty(PEND_REQ_PROP_TIME_CREATE, time);
        this.m_pause.SetTimeBegin(time);
    }
    void                       SetTimeActivate(const ulong time) { this.SetProperty(PEND_REQ_PROP_TIME_ACTIVATE, time); }
    void                       SetWaitingMSC(const ulong miliseconds)
    {
        this.SetProperty(PEND_REQ_PROP_WAITING, miliseconds);
        this.m_pause.SetWaitingMSC(miliseconds);
    }
    void                       SetCurrentAttempt(const uchar number) { this.SetProperty(PEND_REQ_PROP_CURRENT_ATTEMPT, number); }
    void                       SetTotalAttempts(const uchar number) { this.SetProperty(PEND_REQ_PROP_TOTAL, number); }
    void                       SetID(const uchar id) { this.SetProperty(PEND_REQ_PROP_ID, id); }
    void                       SetOrder(const ulong ticket) { this.SetProperty(PEND_REQ_PROP_MQL_REQ_ORDER, ticket); }
    void                       SetPosition(const ulong ticket) { this.SetProperty(PEND_REQ_PROP_MQL_REQ_POSITION, ticket); }

    //--- Set the actual (1) volume, (2) order, (3) limit order,
    //--- (4) stoploss order and (5) takeprofit order prices, (6) order filling type,
    //--- (7) order expiration type and (8) order lifetime
    void                       SetActualVolume(const double volume) { this.SetProperty(PEND_REQ_PROP_ACTUAL_VOLUME, volume); }
    void                       SetActualPrice(const double price) { this.SetProperty(PEND_REQ_PROP_ACTUAL_PRICE, price); }
    void                       SetActualStopLimit(const double price) { this.SetProperty(PEND_REQ_PROP_ACTUAL_STOPLIMIT, price); }
    void                       SetActualSL(const double price) { this.SetProperty(PEND_REQ_PROP_ACTUAL_SL, price); }
    void                       SetActualTP(const double price) { this.SetProperty(PEND_REQ_PROP_ACTUAL_TP, price); }
    void                       SetActualTypeFilling(const ENUM_ORDER_TYPE_FILLING type) { this.SetProperty(PEND_REQ_PROP_ACTUAL_TYPE_FILLING, type); }
    void                       SetActualTypeTime(const ENUM_ORDER_TYPE_TIME type) { this.SetProperty(PEND_REQ_PROP_ACTUAL_TYPE_TIME, type); }
    void                       SetActualExpiration(const datetime expiration) { this.SetProperty(PEND_REQ_PROP_ACTUAL_EXPIRATION, expiration); }

    //+------------------------------------------------------------------+
    //| Descriptions of request object properties                        |
    //+------------------------------------------------------------------+
    //--- Get description of a request (1) integer, (2) real and (3) string property
    string                     GetPropertyDescription(ENUM_PEND_REQ_PROP_INTEGER property);
    string                     GetPropertyDescription(ENUM_PEND_REQ_PROP_DOUBLE property);
    string                     GetPropertyDescription(ENUM_PEND_REQ_PROP_STRING property);

    //--- Return the names of pending request object parameters
    string                     StatusDescription(void) const;
    string                     TypeRequestDescription(void) const;
    string                     IDDescription(void) const;
    string                     RetcodeDescription(void) const;
    string                     TimeCreateDescription(void) const;
    string                     TimeActivateDescription(void) const;
    string                     TimeWaitingDescription(void) const;
    string                     CurrentAttemptDescription(void) const;
    string                     TotalAttemptsDescription(void) const;
    string                     PriceCreateDescription(void) const;

    string                     TypeFillingActualDescription(void) const;
    string                     TypeTimeActualDescription(void) const;
    string                     ExpirationActualDescription(void) const;
    string                     VolumeActualDescription(void) const;
    string                     PriceActualDescription(void) const;
    string                     StopLimitActualDescription(void) const;
    string                     StopLossActualDescription(void) const;
    string                     TakeProfitActualDescription(void) const;

    //--- Return the names of trading request structures parameters in the request object
    string                     MqlReqActionDescription(void) const;
    string                     MqlReqMagicDescription(void) const;
    string                     MqlReqOrderDescription(void) const;
    string                     MqlReqSymbolDescription(void) const;
    string                     MqlReqVolumeDescription(void) const;
    string                     MqlReqPriceDescription(void) const;
    string                     MqlReqStopLimitDescription(void) const;
    string                     MqlReqStopLossDescription(void) const;
    string                     MqlReqTakeProfitDescription(void) const;
    string                     MqlReqDeviationDescription(void) const;
    string                     MqlReqTypeOrderDescription(void) const;
    string                     MqlReqTypeFillingDescription(void) const;
    string                     MqlReqTypeTimeDescription(void) const;
    string                     MqlReqExpirationDescription(void) const;
    string                     MqlReqCommentDescription(void) const;
    string                     MqlReqPositionDescription(void) const;
    string                     MqlReqPositionByDescription(void) const;

    //--- Display (1) description of request properties (full_prop=true - all properties, false - only supported ones),
    //--- (2) short message about the request, (3) short request name (2 and 3 - implementation in the class descendants)
    void                       Print(const bool full_prop = false);
    virtual void               PrintShort(void) { ; }
    virtual string             Header(void) { return NULL; }
};
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CPendRequest::CPendRequest(const ENUM_PEND_REQ_STATUS status,
                           const uchar                id,
                           const double               price,
                           const ulong                time,
                           const MqlTradeRequest     &request,
                           const int                  retcode)
{
    this.CopyRequest(request);
    this.m_is_hedge   = #ifdef __MQL4__ true #else bool(::AccountInfoInteger(ACCOUNT_MARGIN_MODE) == ACCOUNT_MARGIN_MODE_RETAIL_HEDGING) #endif;
    this.m_digits     = (int) ::SymbolInfoInteger(this.GetProperty(PEND_REQ_PROP_MQL_REQ_SYMBOL), SYMBOL_DIGITS);
    int dg            = (int) DigitsLots(this.GetProperty(PEND_REQ_PROP_MQL_REQ_SYMBOL));
    this.m_digits_lot = (dg == 0 ? 1 : dg);
    this.SetProperty(PEND_REQ_PROP_STATUS, status);
    this.SetProperty(PEND_REQ_PROP_ID, id);
    this.SetProperty(PEND_REQ_PROP_RETCODE, retcode);
    this.SetProperty(PEND_REQ_PROP_TYPE, this.GetProperty(PEND_REQ_PROP_RETCODE) > 0 ? PEND_REQ_TYPE_ERROR : PEND_REQ_TYPE_REQUEST);
    this.SetProperty(PEND_REQ_PROP_TIME_CREATE, time);
    this.SetProperty(PEND_REQ_PROP_PRICE_CREATE, price);
    this.m_pause.SetTimeBegin(this.GetProperty(PEND_REQ_PROP_TIME_CREATE));
    this.m_pause.SetWaitingMSC(this.GetProperty(PEND_REQ_PROP_WAITING));
}
//+------------------------------------------------------------------+
//| Compare CPendRequest objects by a specified property             |
//+------------------------------------------------------------------+
int CPendRequest::Compare(const CObject *node, const int mode = 0) const
{
    const CPendRequest *compared_obj = node;
    //--- compare integer properties of two events
    if(mode < PEND_REQ_PROP_INTEGER_TOTAL)
    {
        long value_compared = compared_obj.GetProperty((ENUM_PEND_REQ_PROP_INTEGER) mode);
        long value_current  = this.GetProperty((ENUM_PEND_REQ_PROP_INTEGER) mode);
        return (value_current > value_compared ? 1 : value_current < value_compared ? -1
                                                                                    : 0);
    }
    //--- compare integer properties of two objects
    if(mode < PEND_REQ_PROP_DOUBLE_TOTAL + PEND_REQ_PROP_INTEGER_TOTAL)
    {
        double value_compared = compared_obj.GetProperty((ENUM_PEND_REQ_PROP_DOUBLE) mode);
        double value_current  = this.GetProperty((ENUM_PEND_REQ_PROP_DOUBLE) mode);
        return (value_current > value_compared ? 1 : value_current < value_compared ? -1
                                                                                    : 0);
    }
    //--- compare string properties of two objects
    else if(mode < PEND_REQ_PROP_DOUBLE_TOTAL + PEND_REQ_PROP_INTEGER_TOTAL + PEND_REQ_PROP_STRING_TOTAL)
    {
        string value_compared = compared_obj.GetProperty((ENUM_PEND_REQ_PROP_STRING) mode);
        string value_current  = this.GetProperty((ENUM_PEND_REQ_PROP_STRING) mode);
        return (value_current > value_compared ? 1 : value_current < value_compared ? -1
                                                                                    : 0);
    }
    return 0;
}
//+------------------------------------------------------------------+
//| Compare CPendRequest objects by all properties                   |
//+------------------------------------------------------------------+
bool CPendRequest::IsEqual(CPendRequest *compared_obj)
{
    int beg = 0, end = PEND_REQ_PROP_INTEGER_TOTAL;
    for(int i = beg; i < end; i++)
    {
        ENUM_PEND_REQ_PROP_INTEGER prop = (ENUM_PEND_REQ_PROP_INTEGER) i;
        if(this.GetProperty(prop) != compared_obj.GetProperty(prop))
            return false;
    }
    beg  = end;
    end += PEND_REQ_PROP_DOUBLE_TOTAL;
    for(int i = beg; i < end; i++)
    {
        ENUM_PEND_REQ_PROP_DOUBLE prop = (ENUM_PEND_REQ_PROP_DOUBLE) i;
        if(this.GetProperty(prop) != compared_obj.GetProperty(prop))
            return false;
    }
    beg  = end;
    end += PEND_REQ_PROP_STRING_TOTAL;
    for(int i = beg; i < end; i++)
    {
        ENUM_PEND_REQ_PROP_STRING prop = (ENUM_PEND_REQ_PROP_STRING) i;
        if(this.GetProperty(prop) != compared_obj.GetProperty(prop))
            return false;
    }
    //--- All properties are equal
    return true;
}
//+---------------------------------------------------------------------+
//| Return the flag indicating the real value is equal to the passed one|
//+---------------------------------------------------------------------+
bool CPendRequest::IsEqualByMode(const int mode, const double value) const
{
    CPendRequest *req = new CPendRequest();
    if(req == NULL)
        return false;
    req.SetProperty((ENUM_PEND_REQ_PROP_DOUBLE) mode, value);
    bool res = !this.Compare(req, mode);
    delete req;
    return res;
}
//+------------------------------------------------------------------------+
//| Return the flag indicating the integer value is equal to the passed one|
//+------------------------------------------------------------------------+
bool CPendRequest::IsEqualByMode(const int mode, const long value) const
{
    CPendRequest *req = new CPendRequest();
    if(req == NULL)
        return false;
    req.SetProperty((ENUM_PEND_REQ_PROP_INTEGER) mode, value);
    bool res = !this.Compare(req, mode);
    delete req;
    return res;
}
//+------------------------------------------------------------------+
//| Return the flag of a successful volume change                    |
//+------------------------------------------------------------------+
bool CPendRequest::IsCompletedVolume(void) const
{
    return this.IsEqualByMode(PEND_REQ_PROP_ACTUAL_VOLUME, this.GetProperty(PEND_REQ_PROP_MQL_REQ_VOLUME));
}
//+------------------------------------------------------------------+
//| Return the flag of a successful price modification               |
//+------------------------------------------------------------------+
bool CPendRequest::IsCompletedPrice(void) const
{
    return this.IsEqualByMode(PEND_REQ_PROP_ACTUAL_PRICE, this.GetProperty(PEND_REQ_PROP_MQL_REQ_PRICE));
}
//+-------------------------------------------------------------------+
//| Return the flag of a successful StopLimit order price modification|
//+-------------------------------------------------------------------+
bool CPendRequest::IsCompletedStopLimit(void) const
{
    return this.IsEqualByMode(PEND_REQ_PROP_ACTUAL_STOPLIMIT, this.GetProperty(PEND_REQ_PROP_MQL_REQ_STOPLIMIT));
}
//+------------------------------------------------------------------+
//| Return the flag of a successful StopLoss order modification      |
//+------------------------------------------------------------------+
bool CPendRequest::IsCompletedStopLoss(void) const
{
    return this.IsEqualByMode(PEND_REQ_PROP_ACTUAL_SL, this.GetProperty(PEND_REQ_PROP_MQL_REQ_SL));
}
//+------------------------------------------------------------------+
//| Return the flag of a successful TakeProfit order modification    |
//+------------------------------------------------------------------+
bool CPendRequest::IsCompletedTakeProfit(void) const
{
    return this.IsEqualByMode(PEND_REQ_PROP_ACTUAL_TP, this.GetProperty(PEND_REQ_PROP_MQL_REQ_TP));
}
//+------------------------------------------------------------------+
//| Return the flag of a successful order filling type modification  |
//+------------------------------------------------------------------+
bool CPendRequest::IsCompletedTypeFilling(void) const
{
    return this.IsEqualByMode(PEND_REQ_PROP_ACTUAL_TYPE_FILLING, this.GetProperty(PEND_REQ_PROP_MQL_REQ_TYPE_FILLING));
}
//+-------------------------------------------------------------------+
//| Return the flag of a successful order expiration type modification|
//+-------------------------------------------------------------------+
bool CPendRequest::IsCompletedTypeTime(void) const
{
    return this.IsEqualByMode(PEND_REQ_PROP_ACTUAL_TYPE_TIME, this.GetProperty(PEND_REQ_PROP_MQL_REQ_TYPE_TIME));
}
//+------------------------------------------------------------------+
//| Return the flag of a successful order lifetime modification      |
//+------------------------------------------------------------------+
bool CPendRequest::IsCompletedExpiration(void) const
{
    return this.IsEqualByMode(PEND_REQ_PROP_ACTUAL_EXPIRATION, this.GetProperty(PEND_REQ_PROP_MQL_REQ_EXPIRATION));
}
//+------------------------------------------------------------------+
//| Copy trading request data                                        |
//+------------------------------------------------------------------+
void CPendRequest::CopyRequest(const MqlTradeRequest &request)
{
    //--- Copy a passed structure to an object structure
    this.m_request = request;
    //--- Integer properties of a trading request structure
    this.SetProperty(PEND_REQ_PROP_MQL_REQ_ACTION, request.action);                // Type of a performed action in the request structure
    this.SetProperty(PEND_REQ_PROP_MQL_REQ_TYPE, request.type);                    // Order type in the request structure
    this.SetProperty(PEND_REQ_PROP_MQL_REQ_MAGIC, request.magic);                  // EA stamp (magic number ID) in the request structure
    this.SetProperty(PEND_REQ_PROP_MQL_REQ_ORDER, request.order);                  // Order ticket in the request structure
    this.SetProperty(PEND_REQ_PROP_MQL_REQ_POSITION, request.position);            // Position ticket in the request structure
    this.SetProperty(PEND_REQ_PROP_MQL_REQ_POSITION_BY, request.position_by);      // Opposite position ticket in the request structure
    this.SetProperty(PEND_REQ_PROP_MQL_REQ_DEVIATION, request.deviation);          // Maximum acceptable deviation from a requested price in the request structure
    this.SetProperty(PEND_REQ_PROP_MQL_REQ_EXPIRATION, request.expiration);        // Order expiration time (for ORDER_TIME_SPECIFIED type orders) in the request structure
    this.SetProperty(PEND_REQ_PROP_MQL_REQ_TYPE_FILLING, request.type_filling);    // Order filling type in the request structure
    this.SetProperty(PEND_REQ_PROP_MQL_REQ_TYPE_TIME, request.type_time);          // Order lifetime type in the request structure
                                                                                   //--- Real properties of a trading request structure
    this.SetProperty(PEND_REQ_PROP_MQL_REQ_VOLUME, request.volume);                // Requested volume of a deal in lots in the request structure
    this.SetProperty(PEND_REQ_PROP_MQL_REQ_PRICE, request.price);                  // Price in the request structure
    this.SetProperty(PEND_REQ_PROP_MQL_REQ_STOPLIMIT, request.stoplimit);          // StopLimit level in the request structure
    this.SetProperty(PEND_REQ_PROP_MQL_REQ_SL, request.sl);                        // Stop Loss level in the request structure
    this.SetProperty(PEND_REQ_PROP_MQL_REQ_TP, request.tp);                        // Take Profit level in the request structure
                                                                                   //--- String properties of a trading request structure
    this.SetProperty(PEND_REQ_PROP_MQL_REQ_SYMBOL, request.symbol);                // Trading instrument name in the request structure
    this.SetProperty(PEND_REQ_PROP_MQL_REQ_COMMENT, request.comment);              // Order comment in the request structure
}
//+------------------------------------------------------------------+
//| Return the description of the request integer property           |
//+------------------------------------------------------------------+
string CPendRequest::GetPropertyDescription(ENUM_PEND_REQ_PROP_INTEGER property)
{
    return (
        property == PEND_REQ_PROP_STATUS                ? this.StatusDescription()
        : property == PEND_REQ_PROP_TYPE                ? this.TypeRequestDescription()
        : property == PEND_REQ_PROP_ID                  ? this.IDDescription()
        : property == PEND_REQ_PROP_RETCODE             ? this.RetcodeDescription()
        : property == PEND_REQ_PROP_TIME_CREATE         ? this.TimeCreateDescription()
        : property == PEND_REQ_PROP_TIME_ACTIVATE       ? this.TimeActivateDescription()
        : property == PEND_REQ_PROP_WAITING             ? this.TimeWaitingDescription()
        : property == PEND_REQ_PROP_CURRENT_ATTEMPT     ? this.CurrentAttemptDescription()
        : property == PEND_REQ_PROP_TOTAL               ? this.TotalAttemptsDescription()
        : property == PEND_REQ_PROP_ACTUAL_TYPE_FILLING ? this.TypeFillingActualDescription()
        : property == PEND_REQ_PROP_ACTUAL_TYPE_TIME    ? this.TypeTimeActualDescription()
        : property == PEND_REQ_PROP_ACTUAL_EXPIRATION   ? this.ExpirationActualDescription()
        //--- MqlTradeRequest
        : property == PEND_REQ_PROP_MQL_REQ_ACTION       ? this.MqlReqActionDescription()
        : property == PEND_REQ_PROP_MQL_REQ_TYPE         ? this.MqlReqTypeOrderDescription()
        : property == PEND_REQ_PROP_MQL_REQ_MAGIC        ? this.MqlReqMagicDescription()
        : property == PEND_REQ_PROP_MQL_REQ_ORDER        ? this.MqlReqOrderDescription()
        : property == PEND_REQ_PROP_MQL_REQ_POSITION     ? this.MqlReqPositionDescription()
        : property == PEND_REQ_PROP_MQL_REQ_POSITION_BY  ? this.MqlReqPositionByDescription()
        : property == PEND_REQ_PROP_MQL_REQ_DEVIATION    ? this.MqlReqDeviationDescription()
        : property == PEND_REQ_PROP_MQL_REQ_EXPIRATION   ? this.MqlReqExpirationDescription()
        : property == PEND_REQ_PROP_MQL_REQ_TYPE_FILLING ? this.MqlReqTypeFillingDescription()
        : property == PEND_REQ_PROP_MQL_REQ_TYPE_TIME    ? this.MqlReqTypeTimeDescription()
                                                         : ::EnumToString(property));
}
//+------------------------------------------------------------------+
//| Return the description of the request real property              |
//+------------------------------------------------------------------+
string CPendRequest::GetPropertyDescription(ENUM_PEND_REQ_PROP_DOUBLE property)
{
    return (
        property == PEND_REQ_PROP_PRICE_CREATE       ? this.PriceCreateDescription()
        : property == PEND_REQ_PROP_ACTUAL_VOLUME    ? this.VolumeActualDescription()
        : property == PEND_REQ_PROP_ACTUAL_PRICE     ? this.PriceActualDescription()
        : property == PEND_REQ_PROP_ACTUAL_STOPLIMIT ? this.StopLimitActualDescription()
        : property == PEND_REQ_PROP_ACTUAL_SL        ? this.StopLossActualDescription()
        : property == PEND_REQ_PROP_ACTUAL_TP        ? this.TakeProfitActualDescription()
        //--- MqlTradeRequest
        : property == PEND_REQ_PROP_MQL_REQ_VOLUME    ? this.MqlReqVolumeDescription()
        : property == PEND_REQ_PROP_MQL_REQ_PRICE     ? this.MqlReqPriceDescription()
        : property == PEND_REQ_PROP_MQL_REQ_STOPLIMIT ? this.MqlReqStopLimitDescription()
        : property == PEND_REQ_PROP_MQL_REQ_SL        ? this.MqlReqStopLossDescription()
        : property == PEND_REQ_PROP_MQL_REQ_TP        ? this.MqlReqTakeProfitDescription()
                                                      : ::EnumToString(property));
}
//+------------------------------------------------------------------+
//| Return the description of the request string property            |
//+------------------------------------------------------------------+
string CPendRequest::GetPropertyDescription(ENUM_PEND_REQ_PROP_STRING property)
{
    return (
        property == PEND_REQ_PROP_MQL_REQ_SYMBOL 
            ? this.MqlReqSymbolDescription() 
            : property == PEND_REQ_PROP_MQL_REQ_COMMENT 
                ? this.MqlReqCommentDescription()
                : ::EnumToString(property));
}
//+------------------------------------------------------------------+
//| Return the pending request status name                           |
//+------------------------------------------------------------------+
string CPendRequest::StatusDescription(void) const
{
    int code_descr =
        (this.GetProperty(PEND_REQ_PROP_STATUS) == PEND_REQ_STATUS_OPEN     ? MSG_LIB_TEXT_PEND_REQUEST_STATUS_OPEN
         : this.GetProperty(PEND_REQ_PROP_STATUS) == PEND_REQ_STATUS_CLOSE  ? MSG_LIB_TEXT_PEND_REQUEST_STATUS_CLOSE
         : this.GetProperty(PEND_REQ_PROP_STATUS) == PEND_REQ_STATUS_SLTP   ? MSG_LIB_TEXT_PEND_REQUEST_STATUS_SLTP
         : this.GetProperty(PEND_REQ_PROP_STATUS) == PEND_REQ_STATUS_PLACE  ? MSG_LIB_TEXT_PEND_REQUEST_STATUS_PLACE
         : this.GetProperty(PEND_REQ_PROP_STATUS) == PEND_REQ_STATUS_REMOVE ? MSG_LIB_TEXT_PEND_REQUEST_STATUS_REMOVE
         : this.GetProperty(PEND_REQ_PROP_STATUS) == PEND_REQ_STATUS_MODIFY ? MSG_LIB_TEXT_PEND_REQUEST_STATUS_MODIFY
                                                                            : MSG_EVN_STATUS_UNKNOWN);
    return CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_STATUS) + ": " + CMessage::Text(code_descr);
}
//+------------------------------------------------------------------+
//| Return the pending request type name                             |
//+------------------------------------------------------------------+
string CPendRequest::TypeRequestDescription(void) const
{
    int code_descr =
        (this.GetProperty(PEND_REQ_PROP_TYPE) == PEND_REQ_TYPE_ERROR
             ? MSG_LIB_TEXT_PEND_REQUEST_BY_ERROR
         : this.GetProperty(PEND_REQ_PROP_TYPE) == PEND_REQ_TYPE_REQUEST
             ? MSG_LIB_TEXT_PEND_REQUEST_BY_REQUEST
             : MSG_SYM_MODE_UNKNOWN);
    return CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_TYPE) + ": " + CMessage::Text(code_descr);
}
//+------------------------------------------------------------------+
//| Return the pending request ID description                        |
//+------------------------------------------------------------------+
string CPendRequest::IDDescription(void) const
{
    return CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_ID) + (": #") + (string) this.GetProperty(PEND_REQ_PROP_ID);
}
//+------------------------------------------------------------------+
//| Return the description of an error code a request is based on    |
//+------------------------------------------------------------------+
string CPendRequest::RetcodeDescription(void) const
{
    return CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_RETCODE) + ": " +
           CMessage::Text((int) this.GetProperty(PEND_REQ_PROP_RETCODE)) +
           " (" + (string) this.GetProperty(PEND_REQ_PROP_RETCODE) + ")";
}
//+------------------------------------------------------------------+
//| Return the description of a pending request creation time        |
//+------------------------------------------------------------------+
string CPendRequest::TimeCreateDescription(void) const
{
    return CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_TIME_CREATE) + ": " + ::TimeMSCtoString(this.GetProperty(PEND_REQ_PROP_TIME_CREATE));
}
//+------------------------------------------------------------------+
//| Return the description of a pending request activation time      |
//+------------------------------------------------------------------+
string CPendRequest::TimeActivateDescription(void) const
{
    return CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_TIME_ACTIVATE) + ": " + ::TimeMSCtoString(this.GetProperty(PEND_REQ_PROP_TIME_ACTIVATE));
}
//+---------------------------------------------------------------------+
//| Return the description of a time spent waiting for a pending request|
//+---------------------------------------------------------------------+
string CPendRequest::TimeWaitingDescription(void) const
{
    return CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_WAITING) + ": " +
           (string) this.GetProperty(PEND_REQ_PROP_WAITING) +
           " (" + ::TimeToString(this.GetProperty(PEND_REQ_PROP_WAITING) / 1000, TIME_MINUTES | TIME_SECONDS) + ")";
}
//+------------------------------------------------------------------+
//| Return the description of the current pending request attempt    |
//+------------------------------------------------------------------+
string CPendRequest::CurrentAttemptDescription(void) const
{
    return CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_CURRENT_ATTEMPT) + ": " + (string) this.GetProperty(PEND_REQ_PROP_CURRENT_ATTEMPT);
}
//+------------------------------------------------------------------+
//| Return the description of a number of pending request attempts   |
//+------------------------------------------------------------------+
string CPendRequest::TotalAttemptsDescription(void) const
{
    return CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_TOTAL_ATTEMPTS) + ": " + (string) this.GetProperty(PEND_REQ_PROP_TOTAL);
}
//+------------------------------------------------------------------+
//| Return the description of the actual order filling mode          |
//+------------------------------------------------------------------+
string CPendRequest::TypeFillingActualDescription(void) const
{
    return CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_ACTUAL_TYPE_FILLING) + ": " + OrderTypeFillingDescription((ENUM_ORDER_TYPE_FILLING) this.GetProperty(PEND_REQ_PROP_ACTUAL_TYPE_FILLING));
}
//+------------------------------------------------------------------+
//| Return the actual order lifetime type                            |
//+------------------------------------------------------------------+
string CPendRequest::TypeTimeActualDescription(void) const
{
    return CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_ACTUAL_TYPE_TIME) + ": " + OrderTypeTimeDescription((ENUM_ORDER_TYPE_TIME) this.GetProperty(PEND_REQ_PROP_ACTUAL_TYPE_TIME));
}
//+------------------------------------------------------------------+
//| Return the description of the actual order lifetime              |
//+------------------------------------------------------------------+
string CPendRequest::ExpirationActualDescription(void) const
{
    return CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_ACTUAL_EXPIRATION) + ": " +
           (this.GetProperty(PEND_REQ_PROP_ACTUAL_EXPIRATION) > 0 
                ? ::TimeToString(this.GetProperty(PEND_REQ_PROP_ACTUAL_EXPIRATION)) 
                : CMessage::Text(MSG_LIB_PROP_NOT_SET));
}
//+------------------------------------------------------------------+
//| Return the description of a price when creating a request        |
//+------------------------------------------------------------------+
string CPendRequest::PriceCreateDescription(void) const
{
    return CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_PRICE_CREATE) + ": " + ::DoubleToString(this.GetProperty(PEND_REQ_PROP_PRICE_CREATE), this.m_digits);
}
//+------------------------------------------------------------------+
//| Return the description of the actual order volume                |
//+------------------------------------------------------------------+
string CPendRequest::VolumeActualDescription(void) const
{
    return CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_ACTUAL_VOLUME) + ": " + ::DoubleToString(this.GetProperty(PEND_REQ_PROP_ACTUAL_VOLUME), this.m_digits_lot);
}
//+------------------------------------------------------------------+
//| Return the description of the actual order price                 |
//+------------------------------------------------------------------+
string CPendRequest::PriceActualDescription(void) const
{
    return CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_ACTUAL_PRICE) + ": " + ::DoubleToString(this.GetProperty(PEND_REQ_PROP_ACTUAL_PRICE), this.m_digits);
}
//+------------------------------------------------------------------+
//| Return the description of the actual StopLimit order price       |
//+------------------------------------------------------------------+
string CPendRequest::StopLimitActualDescription(void) const
{
    return CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_ACTUAL_STOPLIMIT) + ": " + ::DoubleToString(this.GetProperty(PEND_REQ_PROP_ACTUAL_STOPLIMIT), this.m_digits);
}
//+------------------------------------------------------------------+
//| Return the description of the actual StopLoss order price        |
//+------------------------------------------------------------------+
string CPendRequest::StopLossActualDescription(void) const
{
    return CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_ACTUAL_SL) + ": " + ::DoubleToString(this.GetProperty(PEND_REQ_PROP_ACTUAL_SL), this.m_digits);
}
//+------------------------------------------------------------------+
//| Return the description of the actual TakeProfit order price      |
//+------------------------------------------------------------------+
string CPendRequest::TakeProfitActualDescription(void) const
{
    return CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_ACTUAL_TP) + ": " + ::DoubleToString(this.GetProperty(PEND_REQ_PROP_ACTUAL_TP), this.m_digits);
}
//+------------------------------------------------------------------+
//| Return the executed action type description                      |
//+------------------------------------------------------------------+
string CPendRequest::MqlReqActionDescription(void) const
{
    int code_descr =
        (this.GetProperty(PEND_REQ_PROP_MQL_REQ_ACTION) == TRADE_ACTION_DEAL       ? MSG_LIB_TEXT_REQUEST_ACTION_DEAL
         : this.GetProperty(PEND_REQ_PROP_MQL_REQ_ACTION) == TRADE_ACTION_PENDING  ? MSG_LIB_TEXT_REQUEST_ACTION_PENDING
         : this.GetProperty(PEND_REQ_PROP_MQL_REQ_ACTION) == TRADE_ACTION_SLTP     ? MSG_LIB_TEXT_REQUEST_ACTION_SLTP
         : this.GetProperty(PEND_REQ_PROP_MQL_REQ_ACTION) == TRADE_ACTION_MODIFY   ? MSG_LIB_TEXT_REQUEST_ACTION_MODIFY
         : this.GetProperty(PEND_REQ_PROP_MQL_REQ_ACTION) == TRADE_ACTION_REMOVE   ? MSG_LIB_TEXT_REQUEST_ACTION_REMOVE
         : this.GetProperty(PEND_REQ_PROP_MQL_REQ_ACTION) == TRADE_ACTION_CLOSE_BY ? MSG_LIB_TEXT_REQUEST_ACTION_CLOSE_BY
                                                                                   : MSG_LIB_TEXT_REQUEST_ACTION_UNCNOWN);
    return CMessage::Text(MSG_LIB_TEXT_REQUEST_ACTION) + ": " + CMessage::Text(code_descr);
}
//+------------------------------------------------------------------+
//| Return the magic number value description                        |
//+------------------------------------------------------------------+
string CPendRequest::MqlReqMagicDescription(void) const
{
    return CMessage::Text(MSG_ORD_MAGIC) + ": " + (string) this.GetProperty(PEND_REQ_PROP_MQL_REQ_MAGIC) +
           (this.GetMagicID() != this.GetProperty(PEND_REQ_PROP_MQL_REQ_MAGIC) ? " (" + (string) this.GetMagicID() + ")" : "");
}
//+------------------------------------------------------------------+
//| Return the order ticket value description                        |
//+------------------------------------------------------------------+
string CPendRequest::MqlReqOrderDescription(void) const
{
    return CMessage::Text(MSG_LIB_TEXT_REQUEST_ORDER) + ": " +
           (this.GetProperty(PEND_REQ_PROP_MQL_REQ_ORDER) > 0
                ? (" #") + (string) this.GetProperty(PEND_REQ_PROP_MQL_REQ_ORDER)
                : CMessage::Text(MSG_LIB_PROP_NOT_SET));
}
//+------------------------------------------------------------------+
//| Return the request position ticket description                   |
//+------------------------------------------------------------------+
string CPendRequest::MqlReqPositionDescription(void) const
{
    return CMessage::Text(MSG_LIB_TEXT_REQUEST_POSITION) + ": " +
           (this.GetProperty(PEND_REQ_PROP_MQL_REQ_POSITION) > 0 
                ? (string) this.GetProperty(PEND_REQ_PROP_MQL_REQ_POSITION) 
                : CMessage::Text(MSG_LIB_PROP_NOT_SET));
}
//+------------------------------------------------------------------+
//| Return the request opposite position ticket description          |
//+------------------------------------------------------------------+
string CPendRequest::MqlReqPositionByDescription(void) const
{
    return CMessage::Text(MSG_LIB_TEXT_REQUEST_POSITION_BY) + ": " +
           (this.GetProperty(PEND_REQ_PROP_MQL_REQ_POSITION_BY) > 0 
                ? (string) this.GetProperty(PEND_REQ_PROP_MQL_REQ_POSITION_BY) 
                : CMessage::Text(MSG_LIB_PROP_NOT_SET));
}
//+------------------------------------------------------------------+
//| Return the request deviation size description                    |
//+------------------------------------------------------------------+
string CPendRequest::MqlReqDeviationDescription(void) const
{
    return CMessage::Text(MSG_LIB_TEXT_REQUEST_DEVIATION) + ": " + (string) this.GetProperty(PEND_REQ_PROP_MQL_REQ_DEVIATION);
}
//+------------------------------------------------------------------+
//| Return the request order type description                        |
//+------------------------------------------------------------------+
string CPendRequest::MqlReqTypeOrderDescription(void) const
{
    return CMessage::Text(MSG_LIB_TEXT_REQUEST_TYPE) + ": " + OrderTypeDescription((ENUM_ORDER_TYPE) this.GetProperty(PEND_REQ_PROP_MQL_REQ_TYPE));
}
//+------------------------------------------------------------------+
//| Return the request order filling mode description                |
//+------------------------------------------------------------------+
string CPendRequest::MqlReqTypeFillingDescription(void) const
{
    return CMessage::Text(MSG_LIB_TEXT_REQUEST_TYPE_FILLING) + ": " + OrderTypeFillingDescription((ENUM_ORDER_TYPE_FILLING) this.GetProperty(PEND_REQ_PROP_MQL_REQ_TYPE_FILLING));
}
//+------------------------------------------------------------------+
//| Return the request order lifetime type description               |
//+------------------------------------------------------------------+
string CPendRequest::MqlReqTypeTimeDescription(void) const
{
    return CMessage::Text(MSG_LIB_TEXT_REQUEST_TYPE_TIME) + ": " + OrderTypeTimeDescription((ENUM_ORDER_TYPE_TIME) this.GetProperty(PEND_REQ_PROP_MQL_REQ_TYPE_TIME));
}
//+------------------------------------------------------------------+
//| Return the request order expiration time description             |
//+------------------------------------------------------------------+
string CPendRequest::MqlReqExpirationDescription(void) const
{
    return CMessage::Text(MSG_LIB_TEXT_REQUEST_EXPIRATION) + ": " +
           (this.GetProperty(PEND_REQ_PROP_MQL_REQ_EXPIRATION) > 0 
                ? ::TimeToString(this.GetProperty(PEND_REQ_PROP_MQL_REQ_EXPIRATION)) 
                : CMessage::Text(MSG_LIB_PROP_NOT_SET));
}
//+------------------------------------------------------------------+
//| Return the request volume description                            |
//+------------------------------------------------------------------+
string CPendRequest::MqlReqVolumeDescription(void) const
{
    return CMessage::Text(MSG_LIB_TEXT_REQUEST_VOLUME) + ": " +
           (this.GetProperty(PEND_REQ_PROP_MQL_REQ_VOLUME) > 0 
                ? ::DoubleToString(this.GetProperty(PEND_REQ_PROP_MQL_REQ_VOLUME), this.m_digits_lot) 
                : CMessage::Text(MSG_LIB_PROP_NOT_SET));
}
//+------------------------------------------------------------------+
//| Return the request price value description                       |
//+------------------------------------------------------------------+
string CPendRequest::MqlReqPriceDescription(void) const
{
    return CMessage::Text(MSG_LIB_TEXT_REQUEST_PRICE) + ": " +
           (this.GetProperty(PEND_REQ_PROP_MQL_REQ_PRICE) > 0 
                ? ::DoubleToString(this.GetProperty(PEND_REQ_PROP_MQL_REQ_PRICE), this.m_digits) 
                : CMessage::Text(MSG_LIB_PROP_NOT_SET));
}
//+------------------------------------------------------------------+
//| Return the request StopLimit order price description             |
//+------------------------------------------------------------------+
string CPendRequest::MqlReqStopLimitDescription(void) const
{
    return CMessage::Text(MSG_LIB_TEXT_REQUEST_STOPLIMIT) + ": " +
           (this.GetProperty(PEND_REQ_PROP_MQL_REQ_STOPLIMIT) > 0 
                ? ::DoubleToString(this.GetProperty(PEND_REQ_PROP_MQL_REQ_STOPLIMIT), this.m_digits) 
                : CMessage::Text(MSG_LIB_PROP_NOT_SET));
}
//+------------------------------------------------------------------+
//| Return the request StopLoss order price description              |
//+------------------------------------------------------------------+
string CPendRequest::MqlReqStopLossDescription(void) const
{
    return CMessage::Text(MSG_LIB_TEXT_REQUEST_SL) + ": " +
           (this.GetProperty(PEND_REQ_PROP_MQL_REQ_SL) > 0 
                ? ::DoubleToString(this.GetProperty(PEND_REQ_PROP_MQL_REQ_SL), this.m_digits) 
                : CMessage::Text(MSG_LIB_PROP_NOT_SET));
}
//+------------------------------------------------------------------+
//| Return the request TakeProfit order price description            |
//+------------------------------------------------------------------+
string CPendRequest::MqlReqTakeProfitDescription(void) const
{
    return CMessage::Text(MSG_LIB_TEXT_REQUEST_TP) + ": " +
           (this.GetProperty(PEND_REQ_PROP_MQL_REQ_TP) > 0 
                ? ::DoubleToString(this.GetProperty(PEND_REQ_PROP_MQL_REQ_TP), this.m_digits) 
                : CMessage::Text(MSG_LIB_PROP_NOT_SET));
}
//+------------------------------------------------------------------+
//| Return the description of a trading instrument name in a request |
//+------------------------------------------------------------------+
string CPendRequest::MqlReqSymbolDescription(void) const
{
    return CMessage::Text(MSG_LIB_TEXT_REQUEST_SYMBOL) + ": " + this.GetProperty(PEND_REQ_PROP_MQL_REQ_SYMBOL);
}
//+------------------------------------------------------------------+
//| Return the request order comment description                     |
//+------------------------------------------------------------------+
string CPendRequest::MqlReqCommentDescription(void) const
{
    return CMessage::Text(MSG_LIB_TEXT_REQUEST_COMMENT) + ": " +
           (this.GetProperty(PEND_REQ_PROP_MQL_REQ_COMMENT) != "" && this.GetProperty(PEND_REQ_PROP_MQL_REQ_COMMENT) != NULL
                ? "\"" + this.GetProperty(PEND_REQ_PROP_MQL_REQ_COMMENT) + "\""
                : CMessage::Text(MSG_LIB_PROP_NOT_SET));
}
//+------------------------------------------------------------------+
//| Display the pending request properties in the journal            |
//+------------------------------------------------------------------+
void CPendRequest::Print(const bool full_prop = false)
{
    int header_code =
        (this.GetProperty(PEND_REQ_PROP_STATUS) == PEND_REQ_STATUS_OPEN     ? MSG_LIB_TEXT_PEND_REQUEST_STATUS_OPEN
         : this.GetProperty(PEND_REQ_PROP_STATUS) == PEND_REQ_STATUS_CLOSE  ? MSG_LIB_TEXT_PEND_REQUEST_STATUS_CLOSE
         : this.GetProperty(PEND_REQ_PROP_STATUS) == PEND_REQ_STATUS_SLTP   ? MSG_LIB_TEXT_PEND_REQUEST_STATUS_SLTP
         : this.GetProperty(PEND_REQ_PROP_STATUS) == PEND_REQ_STATUS_PLACE  ? MSG_LIB_TEXT_PEND_REQUEST_STATUS_PLACE
         : this.GetProperty(PEND_REQ_PROP_STATUS) == PEND_REQ_STATUS_REMOVE ? MSG_LIB_TEXT_PEND_REQUEST_STATUS_REMOVE
         : this.GetProperty(PEND_REQ_PROP_STATUS) == PEND_REQ_STATUS_MODIFY ? MSG_LIB_TEXT_PEND_REQUEST_STATUS_MODIFY
                                                                            : WRONG_VALUE);
    ::Print("============= \"", CMessage::Text(header_code), "\" =============");
    int beg = 0, end = PEND_REQ_PROP_INTEGER_TOTAL;
    for(int i = beg; i < end; i++)
    {
        ENUM_PEND_REQ_PROP_INTEGER prop = (ENUM_PEND_REQ_PROP_INTEGER) i;
        if(!full_prop && !this.SupportProperty(prop))
            continue;
        ::Print(this.GetPropertyDescription(prop));
    }
    ::Print("------");
    beg  = end;
    end += PEND_REQ_PROP_DOUBLE_TOTAL;
    for(int i = beg; i < end; i++)
    {
        ENUM_PEND_REQ_PROP_DOUBLE prop = (ENUM_PEND_REQ_PROP_DOUBLE) i;
        if(!full_prop && !this.SupportProperty(prop))
            continue;
        ::Print(this.GetPropertyDescription(prop));
    }
    ::Print("------");
    beg  = end;
    end += PEND_REQ_PROP_STRING_TOTAL;
    for(int i = beg; i < end; i++)
    {
        ENUM_PEND_REQ_PROP_STRING prop = (ENUM_PEND_REQ_PROP_STRING) i;
        if(!full_prop && !this.SupportProperty(prop))
            continue;
        ::Print(this.GetPropertyDescription(prop));
    }
    ::Print("================== ", CMessage::Text(MSG_LIB_PARAMS_LIST_END), ": \"", CMessage::Text(header_code), "\" ==================\n");
}
//+------------------------------------------------------------------+
