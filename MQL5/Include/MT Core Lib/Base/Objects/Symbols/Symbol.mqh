//+------------------------------------------------------------------+
//|                                                       Symbol.mqh |
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
//| Abstract symbol class                                            |
//+------------------------------------------------------------------+
class CSymbol : public CObject
{
  private:
    struct SMarginRate
    {
        double Initial;        // initial margin rate
        double Maintenance;    // maintenance margin rate
    };
    struct SMarginRateMode
    {
        SMarginRate Long;                                        // MarginRate of long positions
        SMarginRate Short;                                       // MarginRate of short positions
        SMarginRate BuyStop;                                     // MarginRate of BuyStop orders
        SMarginRate BuyLimit;                                    // MarginRate of BuyLimit orders
        SMarginRate BuyStopLimit;                                // MarginRate of BuyStopLimit orders
        SMarginRate SellStop;                                    // MarginRate of SellStop orders
        SMarginRate SellLimit;                                   // MarginRate of SellLimit orders
        SMarginRate SellStopLimit;                               // MarginRate of SellStopLimit orders
    };
    SMarginRateMode  m_margin_rate;                              // Margin ratio structure
    MqlTick          m_tick;                                     // Symbol tick structure
    MqlBookInfo      m_book_info_array[];                        // Array of the market depth data structures
    string           m_symbol_name;                              // Symbol name
    long             m_long_prop[SYMBOL_PROP_INTEGER_TOTAL];     // Integer properties
    double           m_double_prop[SYMBOL_PROP_DOUBLE_TOTAL];    // Real properties
    string           m_string_prop[SYMBOL_PROP_STRING_TOTAL];    // String properties
    int              m_digits_currency;                          // Number of decimal places in an account currency
    int              m_global_error;                             // Global error code
                                                                 //--- Return the index of the array the symbol's (1) double and (2) string properties are located at
    int              IndexProp(ENUM_SYMBOL_PROP_DOUBLE property) const { return (int) property - SYMBOL_PROP_INTEGER_TOTAL; }
    int              IndexProp(ENUM_SYMBOL_PROP_STRING property) const { return (int) property - SYMBOL_PROP_INTEGER_TOTAL - SYMBOL_PROP_DOUBLE_TOTAL; }
    //--- (1) Fill in all the "margin ratio" symbol properties, (2) initialize the ratios
    bool             MarginRates(void);
    void             InitMarginRates(void);
    //--- Reset all symbol object data
    void             Reset(void);
    //--- Return the current day of the week
    ENUM_DAY_OF_WEEK CurrentDayOfWeek(void) const;
    //--- Returns the number of decimal places in the 'double' value
    int              GetDigits(const double value) const;

  public:
    //--- Default constructor
    CSymbol(void) { ; }

  protected:
    //--- Protected parametric constructor
    CSymbol(ENUM_SYMBOL_STATUS symbol_status, const string name);

    //--- Get and return integer properties of a selected symbol from its parameters
    bool   SymbolExists(const string name) const;
    long   SymbolExists(void) const;
    long   SymbolCustom(void) const;
    long   SymbolChartMode(void) const;
    long   SymbolMarginHedgedUseLEG(void) const;
    long   SymbolOrderFillingMode(void) const;
    long   SymbolOrderMode(void) const;
    long   SymbolExpirationMode(void) const;
    long   SymbolOrderGTCMode(void) const;
    long   SymbolOptionMode(void) const;
    long   SymbolOptionRight(void) const;
    long   SymbolBackgroundColor(void) const;
    long   SymbolCalcMode(void) const;
    long   SymbolSwapMode(void) const;
    long   SymbolDigitsLot(void);
    //--- Get and return real properties of a selected symbol from its parameters
    double SymbolBidHigh(void) const;
    double SymbolBidLow(void) const;
    double SymbolVolumeReal(void) const;
    double SymbolVolumeHighReal(void) const;
    double SymbolVolumeLowReal(void) const;
    double SymbolOptionStrike(void) const;
    double SymbolTradeAccruedInterest(void) const;
    double SymbolTradeFaceValue(void) const;
    double SymbolTradeLiquidityRate(void) const;
    double SymbolMarginHedged(void) const;
    bool   SymbolMarginLong(void);
    bool   SymbolMarginShort(void);
    bool   SymbolMarginBuyStop(void);
    bool   SymbolMarginBuyLimit(void);
    bool   SymbolMarginBuyStopLimit(void);
    bool   SymbolMarginSellStop(void);
    bool   SymbolMarginSellLimit(void);
    bool   SymbolMarginSellStopLimit(void);
    //--- Get and return string properties of a selected symbol from its parameters
    string SymbolBasis(void) const;
    string SymbolBank(void) const;
    string SymbolISIN(void) const;
    string SymbolFormula(void) const;
    string SymbolPage(void) const;
    //--- Return the number of decimal places of the account currency
    int    DigitsCurrency(void) const { return this.m_digits_currency; }
    //--- Search for a symbol and return the flag indicating its presence on the server
    bool   Exist(void) const;
    bool   Exist(const string name) const;

  public:
    //--- Set (1) integer, (2) real and (3) string symbol properties
    void         SetProperty(ENUM_SYMBOL_PROP_INTEGER property, long value) { this.m_long_prop[property] = value; }
    void         SetProperty(ENUM_SYMBOL_PROP_DOUBLE property, double value) { this.m_double_prop[this.IndexProp(property)] = value; }
    void         SetProperty(ENUM_SYMBOL_PROP_STRING property, string value) { this.m_string_prop[this.IndexProp(property)] = value; }
    //--- Return (1) integer, (2) real and (3) string symbol properties from the properties array
    long         GetProperty(ENUM_SYMBOL_PROP_INTEGER property) const { return this.m_long_prop[property]; }
    double       GetProperty(ENUM_SYMBOL_PROP_DOUBLE property) const { return this.m_double_prop[this.IndexProp(property)]; }
    string       GetProperty(ENUM_SYMBOL_PROP_STRING property) const { return this.m_string_prop[this.IndexProp(property)]; }

    //--- Return the flag of a symbol supporting the property
    virtual bool SupportProperty(ENUM_SYMBOL_PROP_INTEGER property) { return true; }
    virtual bool SupportProperty(ENUM_SYMBOL_PROP_DOUBLE property) { return true; }
    virtual bool SupportProperty(ENUM_SYMBOL_PROP_STRING property) { return true; }

    //--- Return the flag of allowing (1) market, (2) limit, (3) stop (4) and stop limit orders,
    //--- the flag of allowing setting (5) StopLoss and (6) TakeProfit orders, (7) as well as closing by an opposite order
    bool         IsMarketOrdersAllowed(void) const { return ((this.OrderModeFlags() & SYMBOL_ORDER_MARKET) == SYMBOL_ORDER_MARKET); }
    bool         IsLimitOrdersAllowed(void) const { return ((this.OrderModeFlags() & SYMBOL_ORDER_LIMIT) == SYMBOL_ORDER_LIMIT); }
    bool         IsStopOrdersAllowed(void) const { return ((this.OrderModeFlags() & SYMBOL_ORDER_STOP) == SYMBOL_ORDER_STOP); }
    bool         IsStopLimitOrdersAllowed(void) const { return ((this.OrderModeFlags() & SYMBOL_ORDER_STOP_LIMIT) == SYMBOL_ORDER_STOP_LIMIT); }
    bool         IsStopLossOrdersAllowed(void) const { return ((this.OrderModeFlags() & SYMBOL_ORDER_SL) == SYMBOL_ORDER_SL); }
    bool         IsTakeProfitOrdersAllowed(void) const { return ((this.OrderModeFlags() & SYMBOL_ORDER_TP) == SYMBOL_ORDER_TP); }
    bool         IsCloseByOrdersAllowed(void) const;

    //--- Return the (1) FOK and (2) IOC filling flag
    bool         IsFillingModeFOK(void) const { return ((this.FillingModeFlags() & SYMBOL_FILLING_FOK) == SYMBOL_FILLING_FOK); }
    bool         IsFillingModeIOC(void) const { return ((this.FillingModeFlags() & SYMBOL_FILLING_IOC) == SYMBOL_FILLING_IOC); }

    //--- Return the flag of order expiration: (1) GTC, (2) DAY, (3) Specified and (4) Specified Day
    bool         IsExpirationModeGTC(void) const { return ((this.ExpirationModeFlags() & SYMBOL_EXPIRATION_GTC) == SYMBOL_EXPIRATION_GTC); }
    bool         IsExpirationModeDAY(void) const { return ((this.ExpirationModeFlags() & SYMBOL_EXPIRATION_DAY) == SYMBOL_EXPIRATION_DAY); }
    bool         IsExpirationModeSpecified(void) const { return ((this.ExpirationModeFlags() & SYMBOL_EXPIRATION_SPECIFIED) == SYMBOL_EXPIRATION_SPECIFIED); }
    bool         IsExpirationModeSpecifiedDay(void) const { return ((this.ExpirationModeFlags() & SYMBOL_EXPIRATION_SPECIFIED_DAY) == SYMBOL_EXPIRATION_SPECIFIED_DAY); }

    //--- Return the description of allowing (1) market, (2) limit, (3) stop and (4) stop limit orders,
    //--- the description of allowing (5) StopLoss and (6) TakeProfit orders, (7) as well as closing by an opposite order
    string       GetMarketOrdersAllowedDescription(void) const;
    string       GetLimitOrdersAllowedDescription(void) const;
    string       GetStopOrdersAllowedDescription(void) const;
    string       GetStopLimitOrdersAllowedDescription(void) const;
    string       GetStopLossOrdersAllowedDescription(void) const;
    string       GetTakeProfitOrdersAllowedDescription(void) const;
    string       GetCloseByOrdersAllowedDescription(void) const;

    //--- Return the description of allowing the filling type (1) FOK and (2) IOC, (3) as well as allowed order expiration modes
    string       GetFillingModeFOKAllowedDescrioption(void) const;
    string       GetFillingModeIOCAllowedDescrioption(void) const;

    //--- Return the description of order expiration: (1) GTC, (2) DAY, (3) Specified and (4) Specified Day
    string       GetExpirationModeGTCDescription(void) const;
    string       GetExpirationModeDAYDescription(void) const;
    string       GetExpirationModeSpecifiedDescription(void) const;
    string       GetExpirationModeSpecDayDescription(void) const;

    //--- Return the description of the (1) status, (2) price type for constructing bars,
    //--- (3) method of calculating margin, (4) instrument trading mode,
    //--- (5) deal execution mode for a symbol, (6) swap calculation mode,
    //--- (7) StopLoss and TakeProfit lifetime, (8) option type, (9) option rights
    //--- flags of (10) allowed order types, (11) allowed filling types,
    //--- (12) allowed order expiration modes
    string       GetStatusDescription(void) const;
    string       GetChartModeDescription(void) const;
    string       GetCalcModeDescription(void) const;
    string       GetTradeModeDescription(void) const;
    string       GetTradeExecDescription(void) const;
    string       GetSwapModeDescription(void) const;
    string       GetOrderGTCModeDescription(void) const;
    string       GetOptionTypeDescription(void) const;
    string       GetOptionRightDescription(void) const;
    string       GetOrderModeFlagsDescription(void) const;
    string       GetFillingModeFlagsDescription(void) const;
    string       GetExpirationModeFlagsDescription(void) const;

    //+------------------------------------------------------------------+
    //| Description of symbol object properties                          |
    //+------------------------------------------------------------------+
    //--- Get description of a symbol (1) integer, (2) real and (3) string properties
    string       GetPropertyDescription(ENUM_SYMBOL_PROP_INTEGER property);
    string       GetPropertyDescription(ENUM_SYMBOL_PROP_DOUBLE property);
    string       GetPropertyDescription(ENUM_SYMBOL_PROP_STRING property);

    //--- Send description of symbol properties to the journal (full_prop=true - all properties, false - only supported ones)
    void         Print(const bool full_prop = false);
    //--- Display a short symbol description in the journal (implementation in the descendants)
    virtual void PrintShort(void) { ; }

    //--- Compare CSymbol objects by all possible properties (for sorting lists by a specified symbol object property)
    virtual int  Compare(const CObject *node, const int mode = 0) const;
    //--- Compare CSymbol objects by all properties (for searching for equal event objects)
    bool         IsEqual(CSymbol *compared_symbol) const;

    //--- Return the global error code
    int          GetError(void) const { return this.m_global_error; }
    //--- Update all symbol data that can change
    void         Refresh(void);
    //--- Update quote data by a symbol
    void         RefreshRates(void);

    //--- (1) Add, (2) remove a symbol from the Market Watch window, (3) return the data synchronization flag by a symbol
    bool         SetToMarketWatch(void) const { return ::SymbolSelect(this.m_symbol_name, true); }
    bool         RemoveFromMarketWatch(void) const { return ::SymbolSelect(this.m_symbol_name, false); }
    bool         IsSynchronized(void) const { return ::SymbolIsSynchronized(this.m_symbol_name); }
    //--- Return the (1) start and (2) end time of the week day's quote session, (3) the start and end time of the required quote session
    long         SessionQuoteTimeFrom(const uint session_index, ENUM_DAY_OF_WEEK day_of_week = WRONG_VALUE) const;
    long         SessionQuoteTimeTo(const uint session_index, ENUM_DAY_OF_WEEK day_of_week = WRONG_VALUE) const;
    bool         GetSessionQuote(const uint session_index, ENUM_DAY_OF_WEEK day_of_week, datetime &from, datetime &to);
    //--- Return the (1) start and (2) end time of the week day's trading session, (3) the start and end time of the required trading session
    long         SessionTradeTimeFrom(const uint session_index, ENUM_DAY_OF_WEEK day_of_week = WRONG_VALUE) const;
    long         SessionTradeTimeTo(const uint session_index, ENUM_DAY_OF_WEEK day_of_week = WRONG_VALUE) const;
    bool         GetSessionTrade(const uint session_index, ENUM_DAY_OF_WEEK day_of_week, datetime &from, datetime &to);
    //--- (1) Arrange a (1) subscription to the market depth, (2) close the market depth, (3) fill in the market depth data to the structure array
    bool         BookAdd(void) const;
    bool         BookClose(void) const;
    //--- Return (1) a session duration description in the hh:mm:ss format, number of (1) hours, (2) minutes and (3) seconds in the session duration time
    string       SessionDurationDescription(const ulong duration_sec) const;

  private:
    int SessionHours(const ulong duration_sec) const;
    int SessionMinutes(const ulong duration_sec) const;
    int SessionSeconds(const ulong duration_sec) const;

  public:
    //+------------------------------------------------------------------+
    //| Methods of a simplified access to the order object properties    |
    //+------------------------------------------------------------------+
    //--- Integer properties
    long                        Status(void) const { return this.GetProperty(SYMBOL_PROP_STATUS); }
    bool                        IsCustom(void) const { return (bool) this.GetProperty(SYMBOL_PROP_CUSTOM); }
    color                       ColorBackground(void) const { return (color) this.GetProperty(SYMBOL_PROP_BACKGROUND_COLOR); }
    ENUM_SYMBOL_CHART_MODE      ChartMode(void) const { return (ENUM_SYMBOL_CHART_MODE) this.GetProperty(SYMBOL_PROP_CHART_MODE); }
    bool                        IsExist(void) const { return (bool) this.GetProperty(SYMBOL_PROP_EXIST); }
    bool                        IsExist(const string name) const { return this.SymbolExists(name); }
    bool                        IsSelect(void) const { return (bool) this.GetProperty(SYMBOL_PROP_SELECT); }
    bool                        IsVisible(void) const { return (bool) this.GetProperty(SYMBOL_PROP_VISIBLE); }
    long                        SessionDeals(void) const { return this.GetProperty(SYMBOL_PROP_SESSION_DEALS); }
    long                        SessionBuyOrders(void) const { return this.GetProperty(SYMBOL_PROP_SESSION_BUY_ORDERS); }
    long                        SessionSellOrders(void) const { return this.GetProperty(SYMBOL_PROP_SESSION_SELL_ORDERS); }
    long                        Volume(void) const { return this.GetProperty(SYMBOL_PROP_VOLUME); }
    long                        VolumeHigh(void) const { return this.GetProperty(SYMBOL_PROP_VOLUMEHIGH); }
    long                        VolumeLow(void) const { return this.GetProperty(SYMBOL_PROP_VOLUMELOW); }
    datetime                    Time(void) const { return (datetime) this.GetProperty(SYMBOL_PROP_TIME); }
    int                         Digits(void) const { return (int) this.GetProperty(SYMBOL_PROP_DIGITS); }
    int                         DigitsLot(void) const { return (int) this.GetProperty(SYMBOL_PROP_DIGITS_LOTS); }
    int                         Spread(void) const { return (int) this.GetProperty(SYMBOL_PROP_SPREAD); }
    bool                        IsSpreadFloat(void) const { return (bool) this.GetProperty(SYMBOL_PROP_SPREAD_FLOAT); }
    int                         TicksBookdepth(void) const { return (int) this.GetProperty(SYMBOL_PROP_TICKS_BOOKDEPTH); }
    ENUM_SYMBOL_CALC_MODE       TradeCalcMode(void) const { return (ENUM_SYMBOL_CALC_MODE) this.GetProperty(SYMBOL_PROP_TRADE_CALC_MODE); }
    ENUM_SYMBOL_TRADE_MODE      TradeMode(void) const { return (ENUM_SYMBOL_TRADE_MODE) this.GetProperty(SYMBOL_PROP_TRADE_MODE); }
    datetime                    StartTime(void) const { return (datetime) this.GetProperty(SYMBOL_PROP_START_TIME); }
    datetime                    ExpirationTime(void) const { return (datetime) this.GetProperty(SYMBOL_PROP_EXPIRATION_TIME); }
    int                         TradeStopLevel(void) const { return (int) this.GetProperty(SYMBOL_PROP_TRADE_STOPS_LEVEL); }
    int                         TradeFreezeLevel(void) const { return (int) this.GetProperty(SYMBOL_PROP_TRADE_FREEZE_LEVEL); }
    ENUM_SYMBOL_TRADE_EXECUTION TradeExecutionMode(void) const { return (ENUM_SYMBOL_TRADE_EXECUTION) this.GetProperty(SYMBOL_PROP_TRADE_EXEMODE); }
    ENUM_SYMBOL_SWAP_MODE       SwapMode(void) const { return (ENUM_SYMBOL_SWAP_MODE) this.GetProperty(SYMBOL_PROP_SWAP_MODE); }
    ENUM_DAY_OF_WEEK            SwapRollover3Days(void) const { return (ENUM_DAY_OF_WEEK) this.GetProperty(SYMBOL_PROP_SWAP_ROLLOVER3DAYS); }
    bool                        IsMarginHedgedUseLeg(void) const { return (bool) this.GetProperty(SYMBOL_PROP_MARGIN_HEDGED_USE_LEG); }
    int                         ExpirationModeFlags(void) const { return (int) this.GetProperty(SYMBOL_PROP_EXPIRATION_MODE); }
    int                         FillingModeFlags(void) const { return (int) this.GetProperty(SYMBOL_PROP_FILLING_MODE); }
    int                         OrderModeFlags(void) const { return (int) this.GetProperty(SYMBOL_PROP_ORDER_MODE); }
    ENUM_SYMBOL_ORDER_GTC_MODE  OrderModeGTC(void) const { return (ENUM_SYMBOL_ORDER_GTC_MODE) this.GetProperty(SYMBOL_PROP_ORDER_GTC_MODE); }
    ENUM_SYMBOL_OPTION_MODE     OptionMode(void) const { return (ENUM_SYMBOL_OPTION_MODE) this.GetProperty(SYMBOL_PROP_OPTION_MODE); }
    ENUM_SYMBOL_OPTION_RIGHT    OptionRight(void) const { return (ENUM_SYMBOL_OPTION_RIGHT) this.GetProperty(SYMBOL_PROP_OPTION_RIGHT); }
    //--- Real properties
    double                      Bid(void) const { return this.GetProperty(SYMBOL_PROP_BID); }
    double                      BidHigh(void) const { return this.GetProperty(SYMBOL_PROP_BIDHIGH); }
    double                      BidLow(void) const { return this.GetProperty(SYMBOL_PROP_BIDLOW); }
    double                      Ask(void) const { return this.GetProperty(SYMBOL_PROP_ASK); }
    double                      AskHigh(void) const { return this.GetProperty(SYMBOL_PROP_ASKHIGH); }
    double                      AskLow(void) const { return this.GetProperty(SYMBOL_PROP_ASKLOW); }
    double                      Last(void) const { return this.GetProperty(SYMBOL_PROP_LAST); }
    double                      LastHigh(void) const { return this.GetProperty(SYMBOL_PROP_LASTHIGH); }
    double                      LastLow(void) const { return this.GetProperty(SYMBOL_PROP_LASTLOW); }
    double                      VolumeReal(void) const { return this.GetProperty(SYMBOL_PROP_VOLUME_REAL); }
    double                      VolumeHighReal(void) const { return this.GetProperty(SYMBOL_PROP_VOLUMEHIGH_REAL); }
    double                      VolumeLowReal(void) const { return this.GetProperty(SYMBOL_PROP_VOLUMELOW_REAL); }
    double                      OptionStrike(void) const { return this.GetProperty(SYMBOL_PROP_OPTION_STRIKE); }
    double                      Point(void) const { return this.GetProperty(SYMBOL_PROP_POINT); }
    double                      TradeTickValue(void) const { return this.GetProperty(SYMBOL_PROP_TRADE_TICK_VALUE); }
    double                      TradeTickValueProfit(void) const { return this.GetProperty(SYMBOL_PROP_TRADE_TICK_VALUE_PROFIT); }
    double                      TradeTickValueLoss(void) const { return this.GetProperty(SYMBOL_PROP_TRADE_TICK_VALUE_LOSS); }
    double                      TradeTickSize(void) const { return this.GetProperty(SYMBOL_PROP_TRADE_TICK_SIZE); }
    double                      TradeContractSize(void) const { return this.GetProperty(SYMBOL_PROP_TRADE_CONTRACT_SIZE); }
    double                      TradeAccuredInterest(void) const { return this.GetProperty(SYMBOL_PROP_TRADE_ACCRUED_INTEREST); }
    double                      TradeFaceValue(void) const { return this.GetProperty(SYMBOL_PROP_TRADE_FACE_VALUE); }
    double                      TradeLiquidityRate(void) const { return this.GetProperty(SYMBOL_PROP_TRADE_LIQUIDITY_RATE); }
    double                      LotsMin(void) const { return this.GetProperty(SYMBOL_PROP_VOLUME_MIN); }
    double                      LotsMax(void) const { return this.GetProperty(SYMBOL_PROP_VOLUME_MAX); }
    double                      LotsStep(void) const { return this.GetProperty(SYMBOL_PROP_VOLUME_STEP); }
    double                      VolumeLimit(void) const { return this.GetProperty(SYMBOL_PROP_VOLUME_LIMIT); }
    double                      SwapLong(void) const { return this.GetProperty(SYMBOL_PROP_SWAP_LONG); }
    double                      SwapShort(void) const { return this.GetProperty(SYMBOL_PROP_SWAP_SHORT); }
    double                      MarginInitial(void) const { return this.GetProperty(SYMBOL_PROP_MARGIN_INITIAL); }
    double                      MarginMaintenance(void) const { return this.GetProperty(SYMBOL_PROP_MARGIN_MAINTENANCE); }
    double                      MarginLongInitial(void) const { return this.GetProperty(SYMBOL_PROP_MARGIN_LONG_INITIAL); }
    double                      MarginBuyStopInitial(void) const { return this.GetProperty(SYMBOL_PROP_MARGIN_BUY_STOP_INITIAL); }
    double                      MarginBuyLimitInitial(void) const { return this.GetProperty(SYMBOL_PROP_MARGIN_BUY_LIMIT_INITIAL); }
    double                      MarginBuyStopLimitInitial(void) const { return this.GetProperty(SYMBOL_PROP_MARGIN_BUY_STOPLIMIT_INITIAL); }
    double                      MarginLongMaintenance(void) const { return this.GetProperty(SYMBOL_PROP_MARGIN_LONG_MAINTENANCE); }
    double                      MarginBuyStopMaintenance(void) const { return this.GetProperty(SYMBOL_PROP_MARGIN_BUY_STOP_MAINTENANCE); }
    double                      MarginBuyLimitMaintenance(void) const { return this.GetProperty(SYMBOL_PROP_MARGIN_BUY_LIMIT_MAINTENANCE); }
    double                      MarginBuyStopLimitMaintenance(void) const { return this.GetProperty(SYMBOL_PROP_MARGIN_BUY_STOPLIMIT_MAINTENANCE); }
    double                      MarginShortInitial(void) const { return this.GetProperty(SYMBOL_PROP_MARGIN_SHORT_INITIAL); }
    double                      MarginSellStopInitial(void) const { return this.GetProperty(SYMBOL_PROP_MARGIN_SELL_STOP_INITIAL); }
    double                      MarginSellLimitInitial(void) const { return this.GetProperty(SYMBOL_PROP_MARGIN_SELL_LIMIT_INITIAL); }
    double                      MarginSellStopLimitInitial(void) const { return this.GetProperty(SYMBOL_PROP_MARGIN_SELL_STOPLIMIT_INITIAL); }
    double                      MarginShortMaintenance(void) const { return this.GetProperty(SYMBOL_PROP_MARGIN_SHORT_MAINTENANCE); }
    double                      MarginSellStopMaintenance(void) const { return this.GetProperty(SYMBOL_PROP_MARGIN_SELL_STOP_MAINTENANCE); }
    double                      MarginSellLimitMaintenance(void) const { return this.GetProperty(SYMBOL_PROP_MARGIN_SELL_LIMIT_MAINTENANCE); }
    double                      MarginSellStopLimitMaintenance(void) const { return this.GetProperty(SYMBOL_PROP_MARGIN_SELL_STOPLIMIT_MAINTENANCE); }
    double                      SessionVolume(void) const { return this.GetProperty(SYMBOL_PROP_SESSION_VOLUME); }
    double                      SessionTurnover(void) const { return this.GetProperty(SYMBOL_PROP_SESSION_TURNOVER); }
    double                      SessionInterest(void) const { return this.GetProperty(SYMBOL_PROP_SESSION_INTEREST); }
    double                      SessionBuyOrdersVolume(void) const { return this.GetProperty(SYMBOL_PROP_SESSION_BUY_ORDERS_VOLUME); }
    double                      SessionSellOrdersVolume(void) const { return this.GetProperty(SYMBOL_PROP_SESSION_SELL_ORDERS_VOLUME); }
    double                      SessionOpen(void) const { return this.GetProperty(SYMBOL_PROP_SESSION_OPEN); }
    double                      SessionClose(void) const { return this.GetProperty(SYMBOL_PROP_SESSION_CLOSE); }
    double                      SessionAW(void) const { return this.GetProperty(SYMBOL_PROP_SESSION_AW); }
    double                      SessionPriceSettlement(void) const { return this.GetProperty(SYMBOL_PROP_SESSION_PRICE_SETTLEMENT); }
    double                      SessionPriceLimitMin(void) const { return this.GetProperty(SYMBOL_PROP_SESSION_PRICE_LIMIT_MIN); }
    double                      SessionPriceLimitMax(void) const { return this.GetProperty(SYMBOL_PROP_SESSION_PRICE_LIMIT_MAX); }
    double                      MarginHedged(void) const { return this.GetProperty(SYMBOL_PROP_MARGIN_HEDGED); }
    double                      NormalizedPrice(const double price) const;
    //--- String properties
    string                      Name(void) const { return this.GetProperty(SYMBOL_PROP_NAME); }
    string                      Basis(void) const { return this.GetProperty(SYMBOL_PROP_BASIS); }
    string                      CurrencyBase(void) const { return this.GetProperty(SYMBOL_PROP_CURRENCY_BASE); }
    string                      CurrencyProfit(void) const { return this.GetProperty(SYMBOL_PROP_CURRENCY_PROFIT); }
    string                      CurrencyMargin(void) const { return this.GetProperty(SYMBOL_PROP_CURRENCY_MARGIN); }
    string                      Bank(void) const { return this.GetProperty(SYMBOL_PROP_BANK); }
    string                      Description(void) const { return this.GetProperty(SYMBOL_PROP_DESCRIPTION); }
    string                      Formula(void) const { return this.GetProperty(SYMBOL_PROP_FORMULA); }
    string                      ISIN(void) const { return this.GetProperty(SYMBOL_PROP_ISIN); }
    string                      Page(void) const { return this.GetProperty(SYMBOL_PROP_PAGE); }
    string                      Path(void) const { return this.GetProperty(SYMBOL_PROP_PATH); }
    //---
};
//+------------------------------------------------------------------+
//| Class methods                                                    |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Closed parametric constructor                                    |
//+------------------------------------------------------------------+
CSymbol::CSymbol(ENUM_SYMBOL_STATUS symbol_status, const string name) : m_global_error(ERR_SUCCESS)
{
    this.m_symbol_name = name;
    if(!this.Exist())
    {
        ::Print(DFUN_ERR_LINE, "\"", this.m_symbol_name, "\"", ": ", TextByLanguage("Error. There is no such symbol on the server"));
        this.m_global_error = ERR_MARKET_UNKNOWN_SYMBOL;
    }
    bool select = ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_SELECT);
    ::ResetLastError();
    if(!select)
    {
        if(!this.SetToMarketWatch())
        {
            this.m_global_error = ::GetLastError();
            ::Print(DFUN_ERR_LINE, "\"", this.m_symbol_name, "\": ", TextByLanguage("Failed to put in the market watch. Error: "), this.m_global_error);
        }
    }
    ::ResetLastError();
    if(!::SymbolInfoTick(this.m_symbol_name, this.m_tick))
    {
        this.m_global_error = ::GetLastError();
        ::Print(DFUN_ERR_LINE, "\"", this.m_symbol_name, "\": ", TextByLanguage("Could not get current prices. Error: "), this.m_global_error);
    }
    //--- Initialize data
    ::ZeroMemory(this.m_tick);
    this.Reset();
    this.m_digits_currency = (#ifdef __MQL5__(int) ::AccountInfoInteger(ACCOUNT_CURRENCY_DIGITS) #else 2 #endif);
    this.InitMarginRates();
#ifdef __MQL5__
    ::ResetLastError();
    if(!this.MarginRates())
    {
        this.m_global_error = ::GetLastError();
        ::Print(DFUN_ERR_LINE, this.Name(), ": ", TextByLanguage("Failed to get margin rates. Error: "), this.m_global_error);
        return;
    }
#endif
    //--- Save integer properties
    this.m_long_prop[SYMBOL_PROP_STATUS]                                              = symbol_status;
    this.m_long_prop[SYMBOL_PROP_VOLUME]                                              = (long) this.m_tick.volume;
    this.m_long_prop[SYMBOL_PROP_TIME]                                                = #ifdef __MQL5__ this.m_tick.time_msc #else this.m_tick.time * 1000 #endif;
    this.m_long_prop[SYMBOL_PROP_SELECT]                                              = ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_SELECT);
    this.m_long_prop[SYMBOL_PROP_VISIBLE]                                             = ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_VISIBLE);
    this.m_long_prop[SYMBOL_PROP_SESSION_DEALS]                                       = ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_SESSION_DEALS);
    this.m_long_prop[SYMBOL_PROP_SESSION_BUY_ORDERS]                                  = ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_SESSION_BUY_ORDERS);
    this.m_long_prop[SYMBOL_PROP_SESSION_SELL_ORDERS]                                 = ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_SESSION_SELL_ORDERS);
    this.m_long_prop[SYMBOL_PROP_VOLUMEHIGH]                                          = ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_VOLUMEHIGH);
    this.m_long_prop[SYMBOL_PROP_VOLUMELOW]                                           = ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_VOLUMELOW);
    this.m_long_prop[SYMBOL_PROP_DIGITS]                                              = ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_DIGITS);
    this.m_long_prop[SYMBOL_PROP_SPREAD]                                              = ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_SPREAD);
    this.m_long_prop[SYMBOL_PROP_SPREAD_FLOAT]                                        = ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_SPREAD_FLOAT);
    this.m_long_prop[SYMBOL_PROP_TICKS_BOOKDEPTH]                                     = ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_TICKS_BOOKDEPTH);
    this.m_long_prop[SYMBOL_PROP_TRADE_MODE]                                          = ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_TRADE_MODE);
    this.m_long_prop[SYMBOL_PROP_START_TIME]                                          = ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_START_TIME);
    this.m_long_prop[SYMBOL_PROP_EXPIRATION_TIME]                                     = ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_EXPIRATION_TIME);
    this.m_long_prop[SYMBOL_PROP_TRADE_STOPS_LEVEL]                                   = ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_TRADE_STOPS_LEVEL);
    this.m_long_prop[SYMBOL_PROP_TRADE_FREEZE_LEVEL]                                  = ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_TRADE_FREEZE_LEVEL);
    this.m_long_prop[SYMBOL_PROP_TRADE_EXEMODE]                                       = ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_TRADE_EXEMODE);
    this.m_long_prop[SYMBOL_PROP_SWAP_ROLLOVER3DAYS]                                  = ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_SWAP_ROLLOVER3DAYS);
    this.m_long_prop[SYMBOL_PROP_EXIST]                                               = this.SymbolExists();
    this.m_long_prop[SYMBOL_PROP_CUSTOM]                                              = this.SymbolCustom();
    this.m_long_prop[SYMBOL_PROP_MARGIN_HEDGED_USE_LEG]                               = this.SymbolMarginHedgedUseLEG();
    this.m_long_prop[SYMBOL_PROP_ORDER_MODE]                                          = this.SymbolOrderMode();
    this.m_long_prop[SYMBOL_PROP_FILLING_MODE]                                        = this.SymbolOrderFillingMode();
    this.m_long_prop[SYMBOL_PROP_EXPIRATION_MODE]                                     = this.SymbolExpirationMode();
    this.m_long_prop[SYMBOL_PROP_ORDER_GTC_MODE]                                      = this.SymbolOrderGTCMode();
    this.m_long_prop[SYMBOL_PROP_OPTION_MODE]                                         = this.SymbolOptionMode();
    this.m_long_prop[SYMBOL_PROP_OPTION_RIGHT]                                        = this.SymbolOptionRight();
    this.m_long_prop[SYMBOL_PROP_BACKGROUND_COLOR]                                    = this.SymbolBackgroundColor();
    this.m_long_prop[SYMBOL_PROP_CHART_MODE]                                          = this.SymbolChartMode();
    this.m_long_prop[SYMBOL_PROP_TRADE_CALC_MODE]                                     = this.SymbolCalcMode();
    this.m_long_prop[SYMBOL_PROP_SWAP_MODE]                                           = this.SymbolSwapMode();
    //--- Save real properties
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_ASKHIGH)]                           = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_ASKHIGH);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_ASKLOW)]                            = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_ASKLOW);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_LASTHIGH)]                          = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_LASTHIGH);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_LASTLOW)]                           = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_LASTLOW);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_POINT)]                             = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_POINT);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_TICK_VALUE)]                  = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_TRADE_TICK_VALUE);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_TICK_VALUE_PROFIT)]           = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_TRADE_TICK_VALUE_PROFIT);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_TICK_VALUE_LOSS)]             = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_TRADE_TICK_VALUE_LOSS);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_TICK_SIZE)]                   = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_TRADE_TICK_SIZE);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_CONTRACT_SIZE)]               = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_TRADE_CONTRACT_SIZE);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_VOLUME_MIN)]                        = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_VOLUME_MIN);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_VOLUME_MAX)]                        = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_VOLUME_MAX);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_VOLUME_STEP)]                       = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_VOLUME_STEP);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_VOLUME_LIMIT)]                      = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_VOLUME_LIMIT);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_SWAP_LONG)]                         = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_SWAP_LONG);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_SWAP_SHORT)]                        = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_SWAP_SHORT);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_INITIAL)]                    = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_MARGIN_INITIAL);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_MAINTENANCE)]                = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_MARGIN_MAINTENANCE);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_VOLUME)]                    = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_SESSION_VOLUME);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_TURNOVER)]                  = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_SESSION_TURNOVER);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_INTEREST)]                  = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_SESSION_INTEREST);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_BUY_ORDERS_VOLUME)]         = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_SESSION_BUY_ORDERS_VOLUME);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_SELL_ORDERS_VOLUME)]        = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_SESSION_SELL_ORDERS_VOLUME);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_OPEN)]                      = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_SESSION_OPEN);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_CLOSE)]                     = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_SESSION_CLOSE);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_AW)]                        = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_SESSION_AW);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_PRICE_SETTLEMENT)]          = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_SESSION_PRICE_SETTLEMENT);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_PRICE_LIMIT_MIN)]           = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_SESSION_PRICE_LIMIT_MIN);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_PRICE_LIMIT_MAX)]           = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_SESSION_PRICE_LIMIT_MAX);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_BID)]                               = this.m_tick.bid;
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_ASK)]                               = this.m_tick.ask;
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_LAST)]                              = this.m_tick.last;
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_BIDHIGH)]                           = this.SymbolBidHigh();
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_BIDLOW)]                            = this.SymbolBidLow();
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_VOLUME_REAL)]                       = this.SymbolVolumeReal();
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_VOLUMEHIGH_REAL)]                   = this.SymbolVolumeHighReal();
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_VOLUMELOW_REAL)]                    = this.SymbolVolumeLowReal();
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_OPTION_STRIKE)]                     = this.SymbolOptionStrike();
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_ACCRUED_INTEREST)]            = this.SymbolTradeAccruedInterest();
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_FACE_VALUE)]                  = this.SymbolTradeFaceValue();
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_LIQUIDITY_RATE)]              = this.SymbolTradeLiquidityRate();
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_HEDGED)]                     = this.SymbolMarginHedged();
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_LONG_INITIAL)]               = this.m_margin_rate.Long.Initial;
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_BUY_STOP_INITIAL)]           = this.m_margin_rate.BuyStop.Initial;
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_BUY_LIMIT_INITIAL)]          = this.m_margin_rate.BuyLimit.Initial;
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_BUY_STOPLIMIT_INITIAL)]      = this.m_margin_rate.BuyStopLimit.Initial;
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_LONG_MAINTENANCE)]           = this.m_margin_rate.Long.Maintenance;
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_BUY_STOP_MAINTENANCE)]       = this.m_margin_rate.BuyStop.Maintenance;
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_BUY_LIMIT_MAINTENANCE)]      = this.m_margin_rate.BuyLimit.Maintenance;
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_BUY_STOPLIMIT_MAINTENANCE)]  = this.m_margin_rate.BuyStopLimit.Maintenance;
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_SHORT_INITIAL)]              = this.m_margin_rate.Short.Initial;
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_SELL_STOP_INITIAL)]          = this.m_margin_rate.SellStop.Initial;
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_SELL_LIMIT_INITIAL)]         = this.m_margin_rate.SellLimit.Initial;
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_SELL_STOPLIMIT_INITIAL)]     = this.m_margin_rate.SellStopLimit.Initial;
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_SHORT_MAINTENANCE)]          = this.m_margin_rate.Short.Maintenance;
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_SELL_STOP_MAINTENANCE)]      = this.m_margin_rate.SellStop.Maintenance;
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_SELL_LIMIT_MAINTENANCE)]     = this.m_margin_rate.SellLimit.Maintenance;
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_SELL_STOPLIMIT_MAINTENANCE)] = this.m_margin_rate.SellStopLimit.Maintenance;
    //--- Save string properties
    this.m_string_prop[this.IndexProp(SYMBOL_PROP_NAME)]                              = this.m_symbol_name;
    this.m_string_prop[this.IndexProp(SYMBOL_PROP_CURRENCY_BASE)]                     = ::SymbolInfoString(this.m_symbol_name, SYMBOL_CURRENCY_BASE);
    this.m_string_prop[this.IndexProp(SYMBOL_PROP_CURRENCY_PROFIT)]                   = ::SymbolInfoString(this.m_symbol_name, SYMBOL_CURRENCY_PROFIT);
    this.m_string_prop[this.IndexProp(SYMBOL_PROP_CURRENCY_MARGIN)]                   = ::SymbolInfoString(this.m_symbol_name, SYMBOL_CURRENCY_MARGIN);
    this.m_string_prop[this.IndexProp(SYMBOL_PROP_DESCRIPTION)]                       = ::SymbolInfoString(this.m_symbol_name, SYMBOL_DESCRIPTION);
    this.m_string_prop[this.IndexProp(SYMBOL_PROP_PATH)]                              = ::SymbolInfoString(this.m_symbol_name, SYMBOL_PATH);
    this.m_string_prop[this.IndexProp(SYMBOL_PROP_BASIS)]                             = this.SymbolBasis();
    this.m_string_prop[this.IndexProp(SYMBOL_PROP_BANK)]                              = this.SymbolBank();
    this.m_string_prop[this.IndexProp(SYMBOL_PROP_ISIN)]                              = this.SymbolISIN();
    this.m_string_prop[this.IndexProp(SYMBOL_PROP_FORMULA)]                           = this.SymbolFormula();
    this.m_string_prop[this.IndexProp(SYMBOL_PROP_PAGE)]                              = this.SymbolPage();
    //--- Save additional integer properties
    this.m_long_prop[SYMBOL_PROP_DIGITS_LOTS]                                         = this.SymbolDigitsLot();
    //---
    if(!select) this.RemoveFromMarketWatch();
}
//+------------------------------------------------------------------------------------------------------------+
//|Compare CSymbol objects by all possible properties (for sorting lists by a specified symbol object property)|
//+------------------------------------------------------------------------------------------------------------+
int CSymbol::Compare(const CObject *node, const int mode = 0) const
{
    const CSymbol *symbol_compared = node;
    //--- compare integer properties of two symbols
    if(mode < SYMBOL_PROP_INTEGER_TOTAL)
    {
        long value_compared = symbol_compared.GetProperty((ENUM_SYMBOL_PROP_INTEGER) mode);
        long value_current  = this.GetProperty((ENUM_SYMBOL_PROP_INTEGER) mode);
        return (value_current > value_compared ? 1 : value_current < value_compared ? -1 : 0);
    }
    //--- compare real properties of two symbols
    else if(mode < SYMBOL_PROP_INTEGER_TOTAL + SYMBOL_PROP_DOUBLE_TOTAL)
    {
        double value_compared = symbol_compared.GetProperty((ENUM_SYMBOL_PROP_DOUBLE) mode);
        double value_current  = this.GetProperty((ENUM_SYMBOL_PROP_DOUBLE) mode);
        return (value_current > value_compared ? 1 : value_current < value_compared ? -1 : 0);
    }
    //--- compare string properties of two symbols
    else if(mode < SYMBOL_PROP_INTEGER_TOTAL + SYMBOL_PROP_DOUBLE_TOTAL + SYMBOL_PROP_STRING_TOTAL)
    {
        string value_compared = symbol_compared.GetProperty((ENUM_SYMBOL_PROP_STRING) mode);
        string value_current  = this.GetProperty((ENUM_SYMBOL_PROP_STRING) mode);
        return (value_current > value_compared ? 1 : value_current < value_compared ? -1 : 0);
    }
    return 0;
}
//+------------------------------------------------------------------+
//| Compare CSymbol objects by all properties                        |
//+------------------------------------------------------------------+
bool CSymbol::IsEqual(CSymbol *compared_symbol) const
{
    int beg = 0, end = SYMBOL_PROP_INTEGER_TOTAL;
    for(int i = beg; i < end; i++)
    {
        ENUM_SYMBOL_PROP_INTEGER prop = (ENUM_SYMBOL_PROP_INTEGER) i;
        if(this.GetProperty(prop) != compared_symbol.GetProperty(prop)) return false;
    }
    beg  = end;
    end += SYMBOL_PROP_DOUBLE_TOTAL;
    for(int i = beg; i < end; i++)
    {
        ENUM_SYMBOL_PROP_DOUBLE prop = (ENUM_SYMBOL_PROP_DOUBLE) i;
        if(this.GetProperty(prop) != compared_symbol.GetProperty(prop)) return false;
    }
    beg  = end;
    end += SYMBOL_PROP_STRING_TOTAL;
    for(int i = beg; i < end; i++)
    {
        ENUM_SYMBOL_PROP_STRING prop = (ENUM_SYMBOL_PROP_STRING) i;
        if(this.GetProperty(prop) != compared_symbol.GetProperty(prop)) return false;
    }
    return true;
}
//+------------------------------------------------------------------+
//| Fill in the margin ratio variables                               |
//+------------------------------------------------------------------+
bool CSymbol::MarginRates(void)
{
    bool res = true;
#ifdef __MQL5__
    res &= this.SymbolMarginLong();
    res &= this.SymbolMarginBuyStop();
    res &= this.SymbolMarginBuyLimit();
    res &= this.SymbolMarginBuyStopLimit();
    res &= this.SymbolMarginShort();
    res &= this.SymbolMarginSellStop();
    res &= this.SymbolMarginSellLimit();
    res &= this.SymbolMarginSellStopLimit();
#else
    this.InitMarginRates();
    res = false;
#endif
    return res;
}
//+------------------------------------------------------------------+
//| Initialize margin ratios                                         |
//+------------------------------------------------------------------+
void CSymbol::InitMarginRates(void)
{
    this.m_margin_rate.Long.Initial              = 0;
    this.m_margin_rate.Long.Maintenance          = 0;
    this.m_margin_rate.BuyStop.Initial           = 0;
    this.m_margin_rate.BuyStop.Maintenance       = 0;
    this.m_margin_rate.BuyLimit.Initial          = 0;
    this.m_margin_rate.BuyLimit.Maintenance      = 0;
    this.m_margin_rate.BuyStopLimit.Initial      = 0;
    this.m_margin_rate.BuyStopLimit.Maintenance  = 0;
    this.m_margin_rate.Short.Initial             = 0;
    this.m_margin_rate.Short.Maintenance         = 0;
    this.m_margin_rate.SellStop.Initial          = 0;
    this.m_margin_rate.SellStop.Maintenance      = 0;
    this.m_margin_rate.SellLimit.Initial         = 0;
    this.m_margin_rate.SellLimit.Maintenance     = 0;
    this.m_margin_rate.SellStopLimit.Initial     = 0;
    this.m_margin_rate.SellStopLimit.Maintenance = 0;
}
//+------------------------------------------------------------------+
//| Reset all symbol object data                                     |
//+------------------------------------------------------------------+
void CSymbol::Reset(void)
{
    int beg = 0, end = SYMBOL_PROP_INTEGER_TOTAL;
    for(int i = beg; i < end; i++)
    {
        ENUM_SYMBOL_PROP_INTEGER prop = (ENUM_SYMBOL_PROP_INTEGER) i;
        this.SetProperty(prop, 0);
    }
    beg  = end;
    end += SYMBOL_PROP_DOUBLE_TOTAL;
    for(int i = beg; i < end; i++)
    {
        ENUM_SYMBOL_PROP_DOUBLE prop = (ENUM_SYMBOL_PROP_DOUBLE) i;
        this.SetProperty(prop, 0);
    }
    beg  = end;
    end += SYMBOL_PROP_STRING_TOTAL;
    for(int i = beg; i < end; i++)
    {
        ENUM_SYMBOL_PROP_STRING prop = (ENUM_SYMBOL_PROP_STRING) i;
        this.SetProperty(prop, NULL);
    }
}
//+------------------------------------------------------------------+
//| Integer properties                                               |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Return the symbol existence flag                                 |
//+------------------------------------------------------------------+
long CSymbol::SymbolExists(void) const { return (#ifdef __MQL5__ ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_EXIST) #else this.Exist() #endif); }
//+------------------------------------------------------------------+
bool CSymbol::SymbolExists(const string name) const { return (#ifdef __MQL5__(bool) ::SymbolInfoInteger(name, SYMBOL_EXIST) #else this.Exist(name) #endif); }
//+------------------------------------------------------------------+
//| Return the custom symbol flag                                    |
//+------------------------------------------------------------------+
long CSymbol::SymbolCustom(void) const { return (#ifdef __MQL5__ ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_CUSTOM) #else false #endif); }
//+------------------------------------------------------------------+
//| Return the price type for building bars - Bid or Last            |
//+------------------------------------------------------------------+
long CSymbol::SymbolChartMode(void) const { return (#ifdef __MQL5__ ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_CHART_MODE) #else SYMBOL_CHART_MODE_BID #endif); }
//+--------------------------------------------------------------------+
//|Return the calculation mode of a hedging margin using the larger leg|
//+--------------------------------------------------------------------+
long CSymbol::SymbolMarginHedgedUseLEG(void) const { return (#ifdef __MQL5__ ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_MARGIN_HEDGED_USE_LEG) #else false #endif); }
//+------------------------------------------------------------------+
//| Return the order filling policies flags                          |
//+------------------------------------------------------------------+
long CSymbol::SymbolOrderFillingMode(void) const { return (#ifdef __MQL5__ ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_FILLING_MODE) #else 0 #endif); }
//+------------------------------------------------------------------+
//| Return the flag allowing the closure by an opposite position     |
//+------------------------------------------------------------------+
bool CSymbol::IsCloseByOrdersAllowed(void) const
{
    return (#ifdef __MQL5__(this.OrderModeFlags() & SYMBOL_ORDER_CLOSEBY) == SYMBOL_ORDER_CLOSEBY #else(bool)::MarketInfo(this.m_symbol_name, MODE_CLOSEBY_ALLOWED) #endif);
}
//+------------------------------------------------------------------+
//| Return the option type                                           |
//+------------------------------------------------------------------+
long CSymbol::SymbolOptionMode(void) const { return (#ifdef __MQL5__ ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_OPTION_MODE) #else SYMBOL_OPTION_MODE_NONE #endif); }
//+------------------------------------------------------------------+
//| Return the option right                                          |
//+------------------------------------------------------------------+
long CSymbol::SymbolOptionRight(void) const { return (#ifdef __MQL5__ ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_OPTION_RIGHT) #else SYMBOL_OPTION_RIGHT_NONE #endif); }
//+----------------------------------------------------------------------+
//|Return the background color used to highlight a symbol in Market Watch|
//+----------------------------------------------------------------------+
long CSymbol::SymbolBackgroundColor(void) const { return (#ifdef __MQL5__ ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_BACKGROUND_COLOR) #else clrNONE #endif); }
//+------------------------------------------------------------------+
//| Return the margin calculation method                             |
//+------------------------------------------------------------------+
long CSymbol::SymbolCalcMode(void) const
{
    return (#ifdef __MQL5__ ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_TRADE_CALC_MODE) #else(long)::MarketInfo(this.m_symbol_name, MODE_MARGINCALCMODE) #endif);
}
//+------------------------------------------------------------------+
//| Return the swaps calculation method                              |
//+------------------------------------------------------------------+
long CSymbol::SymbolSwapMode(void) const { return (#ifdef __MQL5__ ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_SWAP_MODE) #else(long)::MarketInfo(this.m_symbol_name, MODE_SWAPTYPE) #endif); }
//+------------------------------------------------------------------+
//| Return the flags of allowed order expiration modes               |
//+------------------------------------------------------------------+
long CSymbol::SymbolExpirationMode(void) const { return (#ifdef __MQL5__ ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_EXPIRATION_MODE) #else(long) SYMBOL_EXPIRATION_GTC #endif); }
//+------------------------------------------------------------------+
//| Return the lifetime of pending orders and                        |
//| placed StopLoss/TakeProfit levels                                |
//+------------------------------------------------------------------+
long CSymbol::SymbolOrderGTCMode(void) const
{
    return (
#ifdef __MQL5__
        this.IsExpirationModeGTC() ? ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_ORDER_GTC_MODE) : WRONG_VALUE
#else
        SYMBOL_ORDERS_GTC
#endif
    );
}
//+------------------------------------------------------------------+
//| Return the flags of allowed order types                          |
//+------------------------------------------------------------------+
long CSymbol::SymbolOrderMode(void) const
{
    return (
#ifdef __MQL5__
        ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_ORDER_MODE)
#else
        (SYMBOL_ORDER_MARKET + SYMBOL_ORDER_LIMIT + SYMBOL_ORDER_STOP + SYMBOL_ORDER_SL + SYMBOL_ORDER_TP + (this.IsCloseByOrdersAllowed() ? SYMBOL_ORDER_CLOSEBY : 0))
#endif
    );
}
//+------------------------------------------------------------------+
//| Calculate and return the number of decimal places                |
//| in a symbol lot                                                  |
//+------------------------------------------------------------------+
long CSymbol::SymbolDigitsLot(void)
{
    if(this.LotsMax() == 0 || this.LotsMin() == 0 || this.LotsStep() == 0)
    {
        ::Print(DFUN_ERR_LINE, TextByLanguage("Failed to get data of \""), this.Name(), "\"");
        this.m_global_error = ERR_MARKET_UNKNOWN_SYMBOL;
        return 2;
    }
    return long(fmax(this.GetDigits(this.LotsMin()), this.GetDigits(this.LotsStep())));
}
//+------------------------------------------------------------------+
//| Real properties                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Return maximum Bid for a day                                     |
//+------------------------------------------------------------------+
double CSymbol::SymbolBidHigh(void) const { return (#ifdef __MQL5__ ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_BIDHIGH) #else ::MarketInfo(this.m_symbol_name, MODE_HIGH) #endif); }
//+------------------------------------------------------------------+
//| Return minimum Bid for a day                                     |
//+------------------------------------------------------------------+
double CSymbol::SymbolBidLow(void) const { return (#ifdef __MQL5__ ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_BIDLOW) #else ::MarketInfo(this.m_symbol_name, MODE_LOW) #endif); }
//+------------------------------------------------------------------+
//| Return real Volume for a day                                     |
//+------------------------------------------------------------------+
double CSymbol::SymbolVolumeReal(void) const { return (#ifdef __MQL5__ ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_VOLUME_REAL) #else 0 #endif); }
//+------------------------------------------------------------------+
//| Return real maximum Volume for a day                             |
//+------------------------------------------------------------------+
double CSymbol::SymbolVolumeHighReal(void) const { return (#ifdef __MQL5__ ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_VOLUMEHIGH_REAL) #else 0 #endif); }
//+------------------------------------------------------------------+
//| Return real minimum Volume for a day                             |
//+------------------------------------------------------------------+
double CSymbol::SymbolVolumeLowReal(void) const { return (#ifdef __MQL5__ ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_VOLUMELOW_REAL) #else 0 #endif); }
//+------------------------------------------------------------------+
//| Return an option execution price                                 |
//+------------------------------------------------------------------+
double CSymbol::SymbolOptionStrike(void) const { return (#ifdef __MQL5__ ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_OPTION_STRIKE) #else 0 #endif); }
//+------------------------------------------------------------------+
//| Return accrued interest                                          |
//+------------------------------------------------------------------+
double CSymbol::SymbolTradeAccruedInterest(void) const { return (#ifdef __MQL5__ ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_TRADE_ACCRUED_INTEREST) #else 0 #endif); }
//+------------------------------------------------------------------+
//| Return a bond face value                                         |
//+------------------------------------------------------------------+
double CSymbol::SymbolTradeFaceValue(void) const { return (#ifdef __MQL5__ ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_TRADE_FACE_VALUE) #else 0 #endif); }
//+------------------------------------------------------------------+
//| Return a liquidity rate                                          |
//+------------------------------------------------------------------+
double CSymbol::SymbolTradeLiquidityRate(void) const { return (#ifdef __MQL5__ ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_TRADE_LIQUIDITY_RATE) #else 0 #endif); }
//+------------------------------------------------------------------+
//| Return a contract or margin size                                 |
//| for a single lot of covered positions                            |
//+------------------------------------------------------------------+
double CSymbol::SymbolMarginHedged(void) const
{
    return (#ifdef __MQL5__ ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_MARGIN_HEDGED) #else ::MarketInfo(this.m_symbol_name, MODE_MARGINHEDGED) #endif);
}
//+------------------------------------------------------------------+
//| Fill in the margin ratios for long positions                     |
//+------------------------------------------------------------------+
bool CSymbol::SymbolMarginLong(void)
{
    return (#ifdef __MQL5__ ::SymbolInfoMarginRate(this.m_symbol_name, ORDER_TYPE_BUY, this.m_margin_rate.Long.Initial, this.m_margin_rate.Long.Maintenance) #else false #endif);
}
//+------------------------------------------------------------------+
//| Fill in the margin ratios for short positions                    |
//+------------------------------------------------------------------+
bool CSymbol::SymbolMarginShort(void)
{
    return (#ifdef __MQL5__ ::SymbolInfoMarginRate(this.m_symbol_name, ORDER_TYPE_SELL, this.m_margin_rate.Short.Initial, this.m_margin_rate.Short.Maintenance) #else false #endif);
}
//+------------------------------------------------------------------+
//| Fill in the margin ratios for BuyStop orders                     |
//+------------------------------------------------------------------+
bool CSymbol::SymbolMarginBuyStop(void)
{
    return (#ifdef __MQL5__ ::SymbolInfoMarginRate(this.m_symbol_name, ORDER_TYPE_BUY_STOP, this.m_margin_rate.BuyStop.Initial, this.m_margin_rate.BuyStop.Maintenance) #else false #endif);
}
//+------------------------------------------------------------------+
//| Fill in the margin ratios for BuyLimit orders                    |
//+------------------------------------------------------------------+
bool CSymbol::SymbolMarginBuyLimit(void)
{
    return (#ifdef __MQL5__ ::SymbolInfoMarginRate(this.m_symbol_name, ORDER_TYPE_BUY_LIMIT, this.m_margin_rate.BuyLimit.Initial, this.m_margin_rate.BuyLimit.Maintenance) #else false #endif);
}
//+------------------------------------------------------------------+
//| Fill in the margin ratios for BuyStopLimit orders                |
//+------------------------------------------------------------------+
bool CSymbol::SymbolMarginBuyStopLimit(void)
{
    return (
#ifdef __MQL5__ ::SymbolInfoMarginRate(this.m_symbol_name, ORDER_TYPE_BUY_STOP_LIMIT, this.m_margin_rate.BuyStopLimit.Initial, this.m_margin_rate.BuyStopLimit.Maintenance) #else false #endif);
}
//+------------------------------------------------------------------+
//| Fill in the margin ratios for SellStop orders                    |
//+------------------------------------------------------------------+
bool CSymbol::SymbolMarginSellStop(void)
{
    return (#ifdef __MQL5__ ::SymbolInfoMarginRate(this.m_symbol_name, ORDER_TYPE_SELL_STOP, this.m_margin_rate.SellStop.Initial, this.m_margin_rate.SellStop.Maintenance) #else false #endif);
}
//+------------------------------------------------------------------+
//| Fill in the margin ratios for SellLimit orders                   |
//+------------------------------------------------------------------+
bool CSymbol::SymbolMarginSellLimit(void)
{
    return (#ifdef __MQL5__ ::SymbolInfoMarginRate(this.m_symbol_name, ORDER_TYPE_SELL_LIMIT, this.m_margin_rate.SellLimit.Initial, this.m_margin_rate.SellLimit.Maintenance) #else false #endif);
}
//+------------------------------------------------------------------+
//| Fill in the margin ratios for SellStopLimit orders               |
//+------------------------------------------------------------------+
bool CSymbol::SymbolMarginSellStopLimit(void){return (
#ifdef __MQL5__ ::SymbolInfoMarginRate(this.m_symbol_name, ORDER_TYPE_SELL_STOP_LIMIT, this.m_margin_rate.SellStopLimit.Initial, this.m_margin_rate.SellStopLimit.Maintenance) #else false #endif);
}
//+------------------------------------------------------------------+
//| String properties                                                |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|  Return a base asset name for a derivative instrument            |
//+------------------------------------------------------------------+
string CSymbol::SymbolBasis(void) const
{
    return (
#ifdef __MQL5__
        ::SymbolInfoString(this.m_symbol_name, SYMBOL_BASIS)
#else
        ": " + TextByLanguage("Property not supported in MQL4")
#endif
    );
}
//+------------------------------------------------------------------+
//| Return a quote source for a symbol                               |
//+------------------------------------------------------------------+
string CSymbol::SymbolBank(void) const
{
    return (
#ifdef __MQL5__
        ::SymbolInfoString(this.m_symbol_name, SYMBOL_BANK)
#else
        ": " + TextByLanguage("Property not supported in MQL4")
#endif
    );
}
//+------------------------------------------------------------------+
//| Return a symbol name to ISIN                                     |
//+------------------------------------------------------------------+
string CSymbol::SymbolISIN(void) const
{
    return (
#ifdef __MQL5__
        ::SymbolInfoString(this.m_symbol_name, SYMBOL_ISIN)
#else
        ": " + TextByLanguage("Property not supported in MQL4")
#endif
    );
}

//+------------------------------------------------------------------+
//| Return a formula for constructing a custom symbol price          |
//+------------------------------------------------------------------+
string CSymbol::SymbolFormula(void) const
{
    return (
#ifdef __MQL5__
        ::SymbolInfoString(this.m_symbol_name, SYMBOL_FORMULA)
#else
        ": " + TextByLanguage("Property not supported in MQL4")
#endif
    );
}
//+------------------------------------------------------------------+
//| Return an address of a web page with a symbol data               |
//+------------------------------------------------------------------+
string CSymbol::SymbolPage(void) const
{
    return (
#ifdef __MQL5__
        ::SymbolInfoString(this.m_symbol_name, SYMBOL_PAGE)
#else
        ": " + TextByLanguage("Property not supported in MQL4")
#endif
    );
}
//+------------------------------------------------------------------+
//| Send symbol properties to the journal                            |
//+------------------------------------------------------------------+
void CSymbol::Print(const bool full_prop = false)
{
    ::Print("============= ", TextByLanguage("Beginning of the parameter list: \""), this.Name(), "\"", " ",
            (this.Description() != #ifdef __MQL5__ "" #else NULL #endif ? "(" + this.Description() + ")" : ""), " ==================");
    int beg = 0, end = SYMBOL_PROP_INTEGER_TOTAL;
    for(int i = beg; i < end; i++)
    {
        ENUM_SYMBOL_PROP_INTEGER prop = (ENUM_SYMBOL_PROP_INTEGER) i;
        if(!full_prop && !this.SupportProperty(prop)) continue;
        ::Print(this.GetPropertyDescription(prop));
    }
    ::Print("------");
    beg  = end;
    end += SYMBOL_PROP_DOUBLE_TOTAL;
    for(int i = beg; i < end; i++)
    {
        ENUM_SYMBOL_PROP_DOUBLE prop = (ENUM_SYMBOL_PROP_DOUBLE) i;
        if(!full_prop && !this.SupportProperty(prop)) continue;
        ::Print(this.GetPropertyDescription(prop));
    }
    ::Print("------");
    beg  = end;
    end += SYMBOL_PROP_STRING_TOTAL;
    for(int i = beg; i < end; i++)
    {
        ENUM_SYMBOL_PROP_STRING prop = (ENUM_SYMBOL_PROP_STRING) i;
        if(!full_prop && !this.SupportProperty(prop)) continue;
        ::Print(this.GetPropertyDescription(prop));
    }
    ::Print("================== ", TextByLanguage("End of the parameter list: \""), this.Name(), "\"", " ",
            (this.Description() != #ifdef __MQL5__ "" #else NULL #endif ? "(" + this.Description() + ")" : ""), " ==================\n");
}
//+------------------------------------------------------------------+
//| Return the description of the symbol integer property            |
//+------------------------------------------------------------------+
string CSymbol::GetPropertyDescription(ENUM_SYMBOL_PROP_INTEGER property)
{
    return (
        //--- General properties
        property == SYMBOL_PROP_STATUS   ? TextByLanguage("Status") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " + (string) this.GetStatusDescription())
        : property == SYMBOL_PROP_CUSTOM ? TextByLanguage("Custom symbol") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported")
                                                                                                              : ": " + (this.GetProperty(property) ? TextByLanguage("Yes") : TextByLanguage("No")))
        : property == SYMBOL_PROP_CHART_MODE
            ? TextByLanguage("Price type used for generating symbols bars") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " + this.GetChartModeDescription())
        : property == SYMBOL_PROP_EXIST
            ? TextByLanguage("Symbol with this name exists") +
                  (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " + (this.GetProperty(property) ? TextByLanguage("Yes") : TextByLanguage("No")))
        : property == SYMBOL_PROP_SELECT
            ? TextByLanguage("Symbol is selected in Market Watch") +
                  (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " + (this.GetProperty(property) ? TextByLanguage("Yes") : TextByLanguage("No")))
        : property == SYMBOL_PROP_VISIBLE
            ? TextByLanguage("Symbol visible in Market Watch") +
                  (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " + (this.GetProperty(property) ? TextByLanguage("Yes") : TextByLanguage("No")))
        : property == SYMBOL_PROP_SESSION_DEALS ? TextByLanguage("Number of deals in the current session") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__(string) this.GetProperty(property)
#else TextByLanguage("Property not supported in MQL4")
#endif
                                                                                                              )
        : property == SYMBOL_PROP_SESSION_BUY_ORDERS ? TextByLanguage("Number of Buy orders at the moment") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__ (string)this.GetProperty(property)
#else TextByLanguage("Property not supported in MQL4")
#endif
                                                                                                               )
        : property == SYMBOL_PROP_SESSION_SELL_ORDERS ? TextByLanguage("Number of Sell orders at the moment") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__(string) this.GetProperty(property)
#else TextByLanguage("Property not supported in MQL4")
#endif
                                                                                                                 )
        : property == SYMBOL_PROP_VOLUME ? TextByLanguage("Volume of the last deal") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__(string) this.GetProperty(property)
#else TextByLanguage("Property not supported in MQL4")
#endif
                                                                                        )
        : property == SYMBOL_PROP_VOLUMEHIGH ? TextByLanguage("Maximum day volume") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__(string) this.GetProperty(property)
#else TextByLanguage("Property not supported in MQL4")
#endif
                                                                                       )
        : property == SYMBOL_PROP_VOLUMELOW ? TextByLanguage("Minimum day volume") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__(string) this.GetProperty(property)
#else TextByLanguage("Property not supported in MQL4")
#endif
                                                                                      )
        : property == SYMBOL_PROP_TIME
            ? TextByLanguage("Time of the last quote") + (!this.SupportProperty(property)
                                                              ? TextByLanguage(": Property not supported")
                                                              : ": " + (this.GetProperty(property) == 0 ? TextByLanguage("(No ticks yet)") : TimeMSCtoString(this.GetProperty(property))))
        : property == SYMBOL_PROP_DIGITS
            ? TextByLanguage("Digits after decimal point") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " + (string) this.GetProperty(property))
        : property == SYMBOL_PROP_DIGITS_LOTS ? TextByLanguage("Digits after decimal point in value of the lot") +
                                                    (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " + (string) this.GetProperty(property))
        : property == SYMBOL_PROP_SPREAD
            ? TextByLanguage("Spread value in points") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " + (string) this.GetProperty(property))
        : property == SYMBOL_PROP_SPREAD_FLOAT
            ? TextByLanguage("Spread is floating") +
                  (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " + (this.GetProperty(property) ? TextByLanguage("Yes") : TextByLanguage("No")))
        : property == SYMBOL_PROP_TICKS_BOOKDEPTH
            ? TextByLanguage("Maximal number of requests shown in Depth of Market") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__(string) this.GetProperty(property)
#else TextByLanguage("Property not supported in MQL4")
#endif
                                                                                       )
        : property == SYMBOL_PROP_TRADE_CALC_MODE
            ? TextByLanguage("Contract price calculation mode") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " + this.GetCalcModeDescription())
        : property == SYMBOL_PROP_TRADE_MODE
            ? TextByLanguage("Order execution type") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " + this.GetTradeModeDescription())
        : property == SYMBOL_PROP_START_TIME
            ? TextByLanguage("Date of symbol trade beginning") + (!this.SupportProperty(property)
                                                                      ? TextByLanguage(": Property not supported")
                                                                      : (this.GetProperty(property) == 0 ? TextByLanguage(": (Not set)") : ": " + TimeMSCtoString(this.GetProperty(property) * 1000)))
        : property == SYMBOL_PROP_EXPIRATION_TIME
            ? TextByLanguage("Date of symbol trade end") + (!this.SupportProperty(property)
                                                                ? TextByLanguage(": Property not supported")
                                                                : (this.GetProperty(property) == 0 ? TextByLanguage(": (Not set)") : ": " + TimeMSCtoString(this.GetProperty(property) * 1000)))
        : property == SYMBOL_PROP_TRADE_STOPS_LEVEL ? TextByLanguage("Minimum indention from close price to place Stop orders") +
                                                          (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " + (string) this.GetProperty(property))
        : property == SYMBOL_PROP_TRADE_FREEZE_LEVEL ? TextByLanguage("Distance to freeze trade operations in points") +
                                                           (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " + (string) this.GetProperty(property))
        : property == SYMBOL_PROP_TRADE_EXEMODE
            ? TextByLanguage("Deal execution mode") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " + this.GetTradeExecDescription())
        : property == SYMBOL_PROP_SWAP_MODE
            ? TextByLanguage("Swap calculation model") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " + this.GetSwapModeDescription())
        : property == SYMBOL_PROP_SWAP_ROLLOVER3DAYS ? TextByLanguage("Day of week to charge 3 days swap rollover") +
                                                           (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " + DayOfWeekDescription(this.SwapRollover3Days()))
        : property == SYMBOL_PROP_MARGIN_HEDGED_USE_LEG
            ? TextByLanguage("Calculating hedging margin using the larger leg") +
                  (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " + (this.GetProperty(property) ? TextByLanguage("Yes") : TextByLanguage("No")))
        : property == SYMBOL_PROP_EXPIRATION_MODE ? TextByLanguage("Flags of allowed order expiration modes") +
                                                        (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " + this.GetExpirationModeFlagsDescription())
        : property == SYMBOL_PROP_FILLING_MODE
            ? TextByLanguage("Flags of allowed order filling modes") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " + this.GetFillingModeFlagsDescription())
        : property == SYMBOL_PROP_ORDER_MODE
            ? TextByLanguage("Flags of allowed order types") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " + this.GetOrderModeFlagsDescription())
        : property == SYMBOL_PROP_ORDER_GTC_MODE ? TextByLanguage("Expiration of Stop Loss and Take Profit orders") +
                                                       (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " + this.GetOrderGTCModeDescription())
        : property == SYMBOL_PROP_OPTION_MODE ? TextByLanguage("Option type") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " + this.GetOptionTypeDescription())
        : property == SYMBOL_PROP_OPTION_RIGHT
            ? TextByLanguage("Option right") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " + this.GetOptionRightDescription())
        : property == SYMBOL_PROP_BACKGROUND_COLOR ? TextByLanguage("Background color of the symbol in Market Watch") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") :
#ifdef __MQL5__(this.GetProperty(property) == CLR_DEFAULT || this.GetProperty(property) == CLR_NONE ? TextByLanguage(": (Not set)") : ": " + ::ColorToString((color) this.GetProperty(property), true))
#else TextByLanguage("Property not supported in MQL4")
#endif
                                                                                                                         )
                                                   : "");
}
//+------------------------------------------------------------------+
//| Return the description of the symbol real property               |
//+------------------------------------------------------------------+
string CSymbol::GetPropertyDescription(ENUM_SYMBOL_PROP_DOUBLE property)
{
    int dg  = this.Digits();
    int dgl = this.DigitsLot();
    int dgc = this.DigitsCurrency();
    return (
        property == SYMBOL_PROP_BID ? TextByLanguage("Bid price") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported")
                                                                                                     : ": " + (this.GetProperty(property) == 0 ? TextByLanguage("(No ticks yet)")
                                                                                                                                               : ::DoubleToString(this.GetProperty(property), dg)))
        : property == SYMBOL_PROP_BIDHIGH
            ? TextByLanguage("Maximum Bid of the day") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " + ::DoubleToString(this.GetProperty(property), dg))
        : property == SYMBOL_PROP_BIDLOW
            ? TextByLanguage("Minimum Bid of the day") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " + ::DoubleToString(this.GetProperty(property), dg))
        : property == SYMBOL_PROP_ASK     ? TextByLanguage("Ask price") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported")
                                                                                                           : ": " + (this.GetProperty(property) == 0 ? TextByLanguage("(No ticks yet)")
                                                                                                                                                     : ::DoubleToString(this.GetProperty(property), dg)))
        : property == SYMBOL_PROP_ASKHIGH ? TextByLanguage("Maximum Ask of the day") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__::DoubleToString(this.GetProperty(property),dg)
#else TextByLanguage("Property not supported in MQL4")
#endif
                                                                                        )
        : property == SYMBOL_PROP_ASKLOW ? TextByLanguage("Minimum Ask of the day") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__ ::DoubleToString(this.GetProperty(property), dg)
#else TextByLanguage("Property not supported in MQL4")
#endif
                                                                                       )
        : property == SYMBOL_PROP_LAST ? TextByLanguage("Price of the last deal") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__ ::DoubleToString(this.GetProperty(property), dg)
#else TextByLanguage("Property not supported in MQL4")
#endif
                                                                                     )
        : property == SYMBOL_PROP_LASTHIGH ? TextByLanguage("Maximum Last of the day") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__ ::DoubleToString(this.GetProperty(property), dg)
#else TextByLanguage("Property not supported in MQL4")
#endif
                                                                                          )
        : property == SYMBOL_PROP_LASTLOW ? TextByLanguage("Minimum Last of the day") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__ ::DoubleToString(this.GetProperty(property), dg)
#else TextByLanguage("Property not supported in MQL4")
#endif
                                                                                         )
        : property == SYMBOL_PROP_VOLUME_REAL ? TextByLanguage("Real volume of the last deal") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__ ::DoubleToString(this.GetProperty(property), dgl)
#else TextByLanguage("Property not supported in MQL4")
#endif
                                                                                                  )
        : property == SYMBOL_PROP_VOLUMEHIGH_REAL ? TextByLanguage("Maximum real volume of the day") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__ ::DoubleToString(this.GetProperty(property), dgl)
#else TextByLanguage("Property not supported in MQL4")
#endif
                                                                                                        )
        : property == SYMBOL_PROP_VOLUMELOW_REAL ? TextByLanguage("Minimum real volume of the day") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__ ::DoubleToString(this.GetProperty(property), dgl)
#else TextByLanguage("Property not supported in MQL4")
#endif
                                                                                                       )
        : property == SYMBOL_PROP_OPTION_STRIKE ? TextByLanguage("Option strike price") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__ ::DoubleToString(this.GetProperty(property), dg)
#else TextByLanguage("Property not supported in MQL4")
#endif
                                                                                           )
        : property == SYMBOL_PROP_POINT
            ? TextByLanguage("Symbol point value") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " + ::DoubleToString(this.GetProperty(property), dg))
        : property == SYMBOL_PROP_TRADE_TICK_VALUE ? TextByLanguage("Calculated tick price for position") +
                                                         (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " + ::DoubleToString(this.GetProperty(property), dgc))
        : property == SYMBOL_PROP_TRADE_TICK_VALUE_PROFIT
            ? TextByLanguage("Calculated tick price for profitable position") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__ ::DoubleToString(this.GetProperty(property), dgc)
#else TextByLanguage("Property not supported in MQL4")
#endif
                                                                                 )
        : property == SYMBOL_PROP_TRADE_TICK_VALUE_LOSS
            ? TextByLanguage("Calculated tick price for losing position") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__ ::DoubleToString(this.GetProperty(property), dgc)
#else TextByLanguage("Property not supported in MQL4")
#endif
                                                                             )
        : property == SYMBOL_PROP_TRADE_TICK_SIZE
            ? TextByLanguage("Minimum price change") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " + ::DoubleToString(this.GetProperty(property), dg))
        : property == SYMBOL_PROP_TRADE_CONTRACT_SIZE
            ? TextByLanguage("Trade contract size") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " + ::DoubleToString(this.GetProperty(property), dgc))
        : property == SYMBOL_PROP_TRADE_ACCRUED_INTEREST ? TextByLanguage("Accumulated coupon interest") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__ ::DoubleToString(this.GetProperty(property), dgc)
#else TextByLanguage("Property not supported in MQL4")
#endif
                                                                                                            )
        : property == SYMBOL_PROP_TRADE_FACE_VALUE ? TextByLanguage("Initial bond value set by issuer") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__ ::DoubleToString(this.GetProperty(property), dgc)
#else TextByLanguage("Property not supported in MQL4")
#endif
                                                                                                           )
        : property == SYMBOL_PROP_TRADE_LIQUIDITY_RATE ? TextByLanguage("Liquidity Rate") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__ ::DoubleToString(this.GetProperty(property), 2)
#else TextByLanguage("Property not supported in MQL4")
#endif
                                                                                             )
        : property == SYMBOL_PROP_VOLUME_MIN
            ? TextByLanguage("Minimum volume for a deal") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " + ::DoubleToString(this.GetProperty(property), dgl))
        : property == SYMBOL_PROP_VOLUME_MAX
            ? TextByLanguage("Maximum volume for a deal") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " + ::DoubleToString(this.GetProperty(property), dgl))
        : property == SYMBOL_PROP_VOLUME_STEP ? TextByLanguage("Minimum volume change step for deal execution") +
                                                    (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " + ::DoubleToString(this.GetProperty(property), dgl))
        : property == SYMBOL_PROP_VOLUME_LIMIT ? TextByLanguage("Maximum allowed aggregate volume of open position and pending orders in one direction") +
                                                     (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__ ::DoubleToString(this.GetProperty(property), dgl)
#else TextByLanguage("Property not supported in MQL4")
#endif
                                                      )
        : property == SYMBOL_PROP_SWAP_LONG
            ? TextByLanguage("Long swap value") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " + ::DoubleToString(this.GetProperty(property), dgc))
        : property == SYMBOL_PROP_SWAP_SHORT ? TextByLanguage("Short swap value") +
                                                   (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " + ::DoubleToString(this.GetProperty(property), dgc))
        : property == SYMBOL_PROP_MARGIN_INITIAL ? TextByLanguage("Initial margin") +
                                                       (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " + ::DoubleToString(this.GetProperty(property), 8))
        : property == SYMBOL_PROP_MARGIN_MAINTENANCE
            ? TextByLanguage("Maintenance margin") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " + ::DoubleToString(this.GetProperty(property), 8))
            :
            //--- Initial margin requirement of a Long position
            property == SYMBOL_PROP_MARGIN_LONG_INITIAL
            ? TextByLanguage("Coefficient of margin initial charging for long positions") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__(this.GetProperty(property) == 0 ? TextByLanguage(": (Not set)") : (::DoubleToString(this.GetProperty(property), 8)))
#else TextByLanguage("Property not supported in MQL4") 
#endif
                                                                                             )
            :
            //--- Initial margin requirement of a Short position
            property == SYMBOL_PROP_MARGIN_SHORT_INITIAL
            ? TextByLanguage("Coefficient of margin initial charging for short positions") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__(this.GetProperty(property) == 0 ? TextByLanguage(": (Not set)") : (::DoubleToString(this.GetProperty(property), 8)))
#else TextByLanguage("Property not supported in MQL4") 
#endif
                                                                                              )
            :
            //--- Maintenance margin requirement of a Long position
            property == SYMBOL_PROP_MARGIN_LONG_MAINTENANCE
            ? TextByLanguage("Coefficient of margin maintenance charging for long positions") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__(this.GetProperty(property) == 0 ? TextByLanguage(": (Not set)") : (::DoubleToString(this.GetProperty(property), 8)))
#else TextByLanguage("Property not supported in MQL4") 
#endif
                                                                                                 )
            :
            //--- Maintenance margin requirement of a Short position
            property == SYMBOL_PROP_MARGIN_SHORT_MAINTENANCE
            ? TextByLanguage("Coefficient of margin maintenance charging for short positions") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__(this.GetProperty(property) == 0 ? TextByLanguage(": (Not set)") : (::DoubleToString(this.GetProperty(property), 8)))
#else TextByLanguage("Property not supported in MQL4") 
#endif
                                                                                                  )
            :
            //--- Initial margin requirements of Long orders
            property == SYMBOL_PROP_MARGIN_BUY_STOP_INITIAL
            ? TextByLanguage("Coefficient of margin initial charging for BuyStop orders") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__(this.GetProperty(property) == 0 ? TextByLanguage(": (Not set)") : (::DoubleToString(this.GetProperty(property), 8)))
#else TextByLanguage("Property not supported in MQL4") 
#endif
                                                                                             )
        : property == SYMBOL_PROP_MARGIN_BUY_LIMIT_INITIAL
            ? TextByLanguage("Coefficient of margin initial charging for BuyLimit orders") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__(this.GetProperty(property) == 0 ? TextByLanguage(": (Not set)") : (::DoubleToString(this.GetProperty(property), 8)))
#else TextByLanguage("Property not supported in MQL4") 
#endif
                                                                                              )
        : property == SYMBOL_PROP_MARGIN_BUY_STOPLIMIT_INITIAL
            ? TextByLanguage("Coefficient of margin initial charging for BuyStopLimit orders") +
                  (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__(this.GetProperty(property) == 0 ? TextByLanguage(": (Not set)") : (::DoubleToString(this.GetProperty(property), 8)))
#else TextByLanguage("Property not supported in MQL4") 
#endif
                   )
            :
            //--- Initial margin requirements of Short orders
            property == SYMBOL_PROP_MARGIN_SELL_STOP_INITIAL
            ? TextByLanguage("Coefficient of margin initial charging for SellStop orders") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__(this.GetProperty(property) == 0 ? TextByLanguage(": (Not set)") : (::DoubleToString(this.GetProperty(property), 8)))
#else TextByLanguage("Property not supported in MQL4") 
#endif
                                                                                              )
        : property == SYMBOL_PROP_MARGIN_SELL_LIMIT_INITIAL
            ? TextByLanguage("Coefficient of margin initial charging for SellLimit orders") +
                  (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__(this.GetProperty(property) == 0 ? TextByLanguage(": (Not set)") : (::DoubleToString(this.GetProperty(property), 8)))
#else TextByLanguage("Property not supported in MQL4") 
#endif
                   )
        : property == SYMBOL_PROP_MARGIN_SELL_STOPLIMIT_INITIAL
            ? TextByLanguage("Coefficient of margin initial charging for SellStopLimit orders") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__(this.GetProperty(property) == 0 ? TextByLanguage(": (Not set)") : (::DoubleToString(this.GetProperty(property), 8)))
#else TextByLanguage("Property not supported in MQL4") 
#endif
                                                                                                   )
            :
            //--- Maintenance margin requirements of Long orders
            property == SYMBOL_PROP_MARGIN_BUY_STOP_MAINTENANCE
            ? TextByLanguage("Coefficient of margin maintenance charging for BuyStop orders") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__(this.GetProperty(property) == 0 ? TextByLanguage(": (Not set)") : (::DoubleToString(this.GetProperty(property), 8)))
#else TextByLanguage("Property not supported in MQL4") 
#endif
                                                                                                 )
        : property == SYMBOL_PROP_MARGIN_BUY_LIMIT_MAINTENANCE
            ? TextByLanguage("Coefficient of margin maintenance charging for BuyLimit orders") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__(this.GetProperty(property) == 0 ? TextByLanguage(": (Not set)") : (::DoubleToString(this.GetProperty(property), 8)))
#else TextByLanguage("Property not supported in MQL4") 
#endif
                                                                                                  )
        : property == SYMBOL_PROP_MARGIN_BUY_STOPLIMIT_MAINTENANCE
            ? TextByLanguage("Coefficient of margin maintenance charging for BuyStopLimit orders") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__(this.GetProperty(property) == 0 ? TextByLanguage(": (Not set)") : (::DoubleToString(this.GetProperty(property), 8)))
#else TextByLanguage("Property not supported in MQL4") 
#endif
                                                                                                      )
            :
            //--- Maintenance margin requirements of Short orders
            property == SYMBOL_PROP_MARGIN_SELL_STOP_MAINTENANCE
            ? TextByLanguage("Coefficient of margin maintenance charging for SellStop orders") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__(this.GetProperty(property) == 0 ? TextByLanguage(": (Not set)") : (::DoubleToString(this.GetProperty(property), 8)))
#else TextByLanguage("Property not supported in MQL4") 
#endif
                                                                                                  )
        : property == SYMBOL_PROP_MARGIN_SELL_LIMIT_MAINTENANCE
            ? TextByLanguage("Coefficient of margin maintenance charging for SellLimit orders") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__(this.GetProperty(property) == 0 ? TextByLanguage(": (Not set)") : (::DoubleToString(this.GetProperty(property), 8)))
#else TextByLanguage("Property not supported in MQL4") 
#endif
                                                                                                   )
        : property == SYMBOL_PROP_MARGIN_SELL_STOPLIMIT_MAINTENANCE
            ? TextByLanguage("Coefficient of margin maintenance charging for SellStopLimit orders") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__(this.GetProperty(property) == 0 ? TextByLanguage(": (Not set)") : (::DoubleToString(this.GetProperty(property), 8)))
#else TextByLanguage("Property not supported in MQL4") 
#endif
                                                                                                       )
            :
            //---
            property == SYMBOL_PROP_SESSION_VOLUME
            ? TextByLanguage("Summary volume of the current session deals") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__ ::DoubleToString(this.GetProperty(property), dgl)
#else TextByLanguage("Property not supported in MQL4")
#endif
                                                                               )
        : property == SYMBOL_PROP_SESSION_TURNOVER ? TextByLanguage("Summary turnover of the current session") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__ ::DoubleToString(this.GetProperty(property), dgc)
#else TextByLanguage("Property not supported in MQL4")
#endif
                                                                                                                  )
        : property == SYMBOL_PROP_SESSION_INTEREST ? TextByLanguage("Summary open interest") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__ ::DoubleToString(this.GetProperty(property), dgl)
#else TextByLanguage("Property not supported in MQL4")
#endif
                                                                                                )
        : property == SYMBOL_PROP_SESSION_BUY_ORDERS_VOLUME ? TextByLanguage("Current volume of Buy orders") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__ ::DoubleToString(this.GetProperty(property), dgl)
#else TextByLanguage("Property not supported in MQL4")
#endif
                                                                                                                )
        : property == SYMBOL_PROP_SESSION_SELL_ORDERS_VOLUME ? TextByLanguage("Current volume of Sell orders") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__ ::DoubleToString(this.GetProperty(property), dgl)
#else TextByLanguage("Property not supported in MQL4")
#endif
                                                                                                                  )
        : property == SYMBOL_PROP_SESSION_OPEN ? TextByLanguage("Open price of the current session") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__ ::DoubleToString(this.GetProperty(property), dg)
#else TextByLanguage("Property not supported in MQL4")
#endif
                                                                                                        )
        : property == SYMBOL_PROP_SESSION_CLOSE ? TextByLanguage("Close price of the current session") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__ ::DoubleToString(this.GetProperty(property), dg)
#else TextByLanguage("Property not supported in MQL4")
#endif
                                                                                                          )
        : property == SYMBOL_PROP_SESSION_AW ? TextByLanguage("Average weighted price of the current session") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__ ::DoubleToString(this.GetProperty(property), dg)
#else TextByLanguage("Property not supported in MQL4")
#endif
                                                                                                                  )
        : property == SYMBOL_PROP_SESSION_PRICE_SETTLEMENT
            ? TextByLanguage("Settlement price of the current session") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__ ::DoubleToString(this.GetProperty(property), dg)
#else TextByLanguage("Property not supported in MQL4")
#endif
                                                                           )
        : property == SYMBOL_PROP_SESSION_PRICE_LIMIT_MIN
            ? TextByLanguage("Minimum price of the current session") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__ ::DoubleToString(this.GetProperty(property), dg)
#else TextByLanguage("Property not supported in MQL4")
#endif
                                                                        )
        : property == SYMBOL_PROP_SESSION_PRICE_LIMIT_MAX
            ? TextByLanguage("Maximum price of the current session") + (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " +
#ifdef __MQL5__ ::DoubleToString(this.GetProperty(property), dg)
#else TextByLanguage("Property not supported in MQL4")
#endif
                                                                        )
        : property == SYMBOL_PROP_MARGIN_HEDGED ? TextByLanguage("Contract size or margin value per one lot of hedged positions") +
                                                      (!this.SupportProperty(property) ? TextByLanguage(": Property not supported") : ": " + ::DoubleToString(this.GetProperty(property), dgc))
                                                : "");
}
//+------------------------------------------------------------------+
//| Return the description of the symbol string property             |
//+------------------------------------------------------------------+
string CSymbol::GetPropertyDescription(ENUM_SYMBOL_PROP_STRING property)
{
   return
     (
      property==SYMBOL_PROP_NAME             ?  TextByLanguage("Symbol name")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Property not supported") :
          ": "+this.GetProperty(property)
         )  :
      property==SYMBOL_PROP_BASIS            ?  TextByLanguage("Underlying asset of derivative")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Property not supported") :
         (this.GetProperty(property) == "" || this.GetProperty(property) == NULL  ?  TextByLanguage(": (Not set)") : ": \""+this.GetProperty(property)+"\"")
         )  :
      property==SYMBOL_PROP_CURRENCY_BASE    ?  TextByLanguage("Basic currency of symbol")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Property not supported") :
         (this.GetProperty(property) == "" || this.GetProperty(property) == NULL  ?  TextByLanguage(": (Not set)") : ": \""+this.GetProperty(property)+"\"")
         )  :
      property==SYMBOL_PROP_CURRENCY_PROFIT  ?  TextByLanguage("Profit currency")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Property not supported") :
         (this.GetProperty(property) == "" || this.GetProperty(property) == NULL  ?  TextByLanguage(": (Not set)") : ": \""+this.GetProperty(property)+"\"")
         )  :
      property==SYMBOL_PROP_CURRENCY_MARGIN  ?  TextByLanguage("Margin currency")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Property not supported") :
         (this.GetProperty(property) == "" || this.GetProperty(property) == NULL  ?  TextByLanguage(": (Not set)") : ": \""+this.GetProperty(property)+"\"")
         )  :
      property==SYMBOL_PROP_BANK             ?  TextByLanguage("Feeder of the current quote")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Property not supported") :
         (this.GetProperty(property) == "" || this.GetProperty(property) == NULL  ?  TextByLanguage(": (Not set)") : ": \""+this.GetProperty(property)+"\"")
         )  :
      property==SYMBOL_PROP_DESCRIPTION      ?  TextByLanguage("Symbol description")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Property not supported") :
         (this.GetProperty(property) == "" || this.GetProperty(property) == NULL  ?  TextByLanguage(": (Not set)") : ": \""+this.GetProperty(property)+"\"")
         )  :
      property==SYMBOL_PROP_FORMULA          ?  TextByLanguage("Formula used for custom symbol pricing")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Property not supported") :
         (this.GetProperty(property) == "" || this.GetProperty(property) == NULL  ?  TextByLanguage(": (Not set)") : ": \""+this.GetProperty(property)+"\"")
         )  :
      property==SYMBOL_PROP_ISIN             ?  TextByLanguage("Symbol name in ISIN system")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Property not supported") :
         (this.GetProperty(property) == "" || this.GetProperty(property) == NULL  ?  TextByLanguage(": (Not set)") : ": \""+this.GetProperty(property)+"\"")
         )  :
      property==SYMBOL_PROP_PAGE             ?  TextByLanguage("Address of web page containing symbol information")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Property not supported") :
         (this.GetProperty(property) == "" || this.GetProperty(property) == NULL  ?  TextByLanguage(": (Not set)") : ": \""+this.GetProperty(property)+"\"")
         )  :
      property==SYMBOL_PROP_PATH             ?  TextByLanguage("Path in symbol tree")+
         (!this.SupportProperty(property) ?  TextByLanguage(": Property not supported") :
         (this.GetProperty(property) == "" || this.GetProperty(property) == NULL  ?  TextByLanguage(": (Not set)") : ": \""+this.GetProperty(property)+"\"")
         )  :
      ""
     );
}
//+-------------------------------------------------------------------------------+
//| Search for a symbol and return the flag indicating its presence on the server |
//+-------------------------------------------------------------------------------+
bool CSymbol::Exist(void) const
{
    int total = ::SymbolsTotal(false);
    for(int i = 0; i < total; i++)
        if(::SymbolName(i, false) == this.m_symbol_name) return true;
    return false;
}
//+------------------------------------------------------------------+
bool CSymbol::Exist(const string name) const
{
   int total = ::SymbolsTotal(false);
   for(int i = 0; i < total; i++)
      if(::SymbolName(i, false) == name)  return true;
   return false;
}
//+------------------------------------------------------------------+
//| Return the number of decimal places in the 'double' value        |
//+------------------------------------------------------------------+
int CSymbol::GetDigits(const double value) const
{
    string val_str = (string) value;
    int    len     = ::StringLen(val_str);
    int    n       = len - ::StringFind(val_str, ".", 0) - 1;
    if(::StringSubstr(val_str, len - 1, 1) == "0") n--;
    return n;
}
//+------------------------------------------------------------------+
//| Subscribe to the market depth                                    |
//+------------------------------------------------------------------+
bool CSymbol::BookAdd(void) const { return #ifdef __MQL5__ ::MarketBookAdd(this.m_symbol_name) #else false #endif; }
//+------------------------------------------------------------------+
//| Close the market depth                                           |
//+------------------------------------------------------------------+
bool CSymbol::BookClose(void) const { return #ifdef __MQL5__ ::MarketBookRelease(this.m_symbol_name) #else false #endif; }
//+------------------------------------------------------------------+
//| Return the quote session start time                              |
//| in seconds from the beginning of a day                           |
//+------------------------------------------------------------------+
long CSymbol::SessionQuoteTimeFrom(const uint session_index, ENUM_DAY_OF_WEEK day_of_week = WRONG_VALUE) const
{
    MqlDateTime      time = {0};
    datetime         from = 0, to = 0;
    ENUM_DAY_OF_WEEK day = (day_of_week < 0 || day_of_week > SATURDAY ? this.CurrentDayOfWeek() : day_of_week);
    return (::SymbolInfoSessionQuote(this.m_symbol_name, day, session_index, from, to) ? from : WRONG_VALUE);
}
//+------------------------------------------------------------------+
//| Return the time in seconds since the day start                   |
//| up to the end of a quote session                                 |
//+------------------------------------------------------------------+
long CSymbol::SessionQuoteTimeTo(const uint session_index, ENUM_DAY_OF_WEEK day_of_week = WRONG_VALUE) const
{
    MqlDateTime      time = {0};
    datetime         from = 0, to = 0;
    ENUM_DAY_OF_WEEK day = (day_of_week < 0 || day_of_week > SATURDAY ? this.CurrentDayOfWeek() : day_of_week);
    return (::SymbolInfoSessionQuote(this.m_symbol_name, day, session_index, from, to) ? to : WRONG_VALUE);
}
//+------------------------------------------------------------------+
//| Return the start and end time of a required quote session        |
//+------------------------------------------------------------------+
bool CSymbol::GetSessionQuote(const uint session_index, ENUM_DAY_OF_WEEK day_of_week, datetime &from, datetime &to)
{
    ENUM_DAY_OF_WEEK day = (day_of_week < 0 || day_of_week > SATURDAY ? this.CurrentDayOfWeek() : day_of_week);
    return ::SymbolInfoSessionQuote(this.m_symbol_name, day, session_index, from, to);
}
//+------------------------------------------------------------------+
//| Return the trading session start time                            |
//| in seconds from the beginning of a day                           |
//+------------------------------------------------------------------+
long CSymbol::SessionTradeTimeFrom(const uint session_index, ENUM_DAY_OF_WEEK day_of_week = WRONG_VALUE) const
{
    MqlDateTime      time = {0};
    datetime         from = 0, to = 0;
    ENUM_DAY_OF_WEEK day = (day_of_week < 0 || day_of_week > SATURDAY ? this.CurrentDayOfWeek() : day_of_week);
    return (::SymbolInfoSessionTrade(this.m_symbol_name, day, session_index, from, to) ? from : WRONG_VALUE);
}
//+------------------------------------------------------------------+
//| Return the time in seconds since the day start                   |
//| up to the end of a trading session                               |
//+------------------------------------------------------------------+
long CSymbol::SessionTradeTimeTo(const uint session_index, ENUM_DAY_OF_WEEK day_of_week = WRONG_VALUE) const
{
    MqlDateTime      time = {0};
    datetime         from = 0, to = 0;
    ENUM_DAY_OF_WEEK day = (day_of_week < 0 || day_of_week > SATURDAY ? this.CurrentDayOfWeek() : day_of_week);
    return (::SymbolInfoSessionTrade(this.m_symbol_name, day, session_index, from, to) ? to : WRONG_VALUE);
}
//+------------------------------------------------------------------+
//| Return the start and end time of a required trading session      |
//+------------------------------------------------------------------+
bool CSymbol::GetSessionTrade(const uint session_index, ENUM_DAY_OF_WEEK day_of_week, datetime &from, datetime &to)
{
    ENUM_DAY_OF_WEEK day = (day_of_week < 0 || day_of_week > SATURDAY ? this.CurrentDayOfWeek() : day_of_week);
    return ::SymbolInfoSessionTrade(this.m_symbol_name, day, session_index, from, to);
}
//+------------------------------------------------------------------+
//| Return the current day of the week                               |
//+------------------------------------------------------------------+
ENUM_DAY_OF_WEEK CSymbol::CurrentDayOfWeek(void) const
{
    MqlDateTime time = {0};
    ::TimeCurrent(time);
    return (ENUM_DAY_OF_WEEK) time.day_of_week;
}
//+------------------------------------------------------------------+
//| Return the number of seconds in a session duration time          |
//+------------------------------------------------------------------+
int    CSymbol::SessionSeconds(const ulong duration_sec) const { return int(duration_sec % 60); }
//+------------------------------------------------------------------+
//| Return the number of minutes in a session duration time          |
//+------------------------------------------------------------------+
int    CSymbol::SessionMinutes(const ulong duration_sec) const { return int((duration_sec - this.SessionSeconds(duration_sec)) % 3600) / 60; }
//+------------------------------------------------------------------+
//| Return the number of hours in a session duration time            |
//+------------------------------------------------------------------+
int    CSymbol::SessionHours(const ulong duration_sec) const { return int(duration_sec - this.SessionSeconds(duration_sec) - this.SessionMinutes(duration_sec)) / 3600; }
//+--------------------------------------------------------------------+
//| Return the description of a session duration in the hh:mm:ss format|
//+--------------------------------------------------------------------+
string CSymbol::SessionDurationDescription(const ulong duration_sec) const
{
    int sec  = this.SessionSeconds(duration_sec);
    int min  = this.SessionMinutes(duration_sec);
    int hour = this.SessionHours(duration_sec);
    return ::IntegerToString(hour, 2, '0') + ":" + ::IntegerToString(min, 2, '0') + ":" + ::IntegerToString(sec, 2, '0');
}
//+------------------------------------------------------------------+
//| Return the status description                                    |
//+------------------------------------------------------------------+
string CSymbol::GetStatusDescription() const
{
    return (this.Status() == SYMBOL_STATUS_FX           ? TextByLanguage("Forex symbol")
            : this.Status() == SYMBOL_STATUS_FX_MAJOR   ? TextByLanguage("Forex major symbol")
            : this.Status() == SYMBOL_STATUS_FX_MINOR   ? TextByLanguage("Forex minor symbol")
            : this.Status() == SYMBOL_STATUS_FX_EXOTIC  ? TextByLanguage("Forex Exotic Symbol")
            : this.Status() == SYMBOL_STATUS_FX_RUB     ? TextByLanguage("Forex symbol RUB")
            : this.Status() == SYMBOL_STATUS_METAL      ? TextByLanguage("Metal")
            : this.Status() == SYMBOL_STATUS_INDEX      ? TextByLanguage("Index")
            : this.Status() == SYMBOL_STATUS_INDICATIVE ? TextByLanguage("Indicative")
            : this.Status() == SYMBOL_STATUS_CRYPTO     ? TextByLanguage("Crypto symbol")
            : this.Status() == SYMBOL_STATUS_COMMODITY  ? TextByLanguage("Commodity symbol")
            : this.Status() == SYMBOL_STATUS_EXCHANGE   ? TextByLanguage("Exchange symbol")
            : this.Status() == SYMBOL_STATUS_FUTURES    ? TextByLanguage("Furures")
            : this.Status() == SYMBOL_STATUS_CFD        ? TextByLanguage("Contract For Difference")
            : this.Status() == SYMBOL_STATUS_STOCKS     ? TextByLanguage("Stocks")
            : this.Status() == SYMBOL_STATUS_BONDS      ? TextByLanguage("Bonds")
            : this.Status() == SYMBOL_STATUS_OPTION     ? TextByLanguage("Option")
            : this.Status() == SYMBOL_STATUS_COLLATERAL ? TextByLanguage("Collateral")
            : this.Status() == SYMBOL_STATUS_CUSTOM     ? TextByLanguage("Custom symbol")
            : this.Status() == SYMBOL_STATUS_COMMON     ? TextByLanguage("Custom symbol")
            : ::EnumToString((ENUM_SYMBOL_STATUS)this.Status()));
}
//+------------------------------------------------------------------+
//| Return the description of the price type for constructing bars   |
//+------------------------------------------------------------------+
string CSymbol::GetChartModeDescription(void) const
{
    return (this.ChartMode() == SYMBOL_CHART_MODE_BID ? TextByLanguage("Bars are based on Bid prices")
                                                      : TextByLanguage("Bars are based on Last prices"));
}
//+------------------------------------------------------------------+
//| Return the description of the margin calculation method          |
//+------------------------------------------------------------------+
string CSymbol::GetCalcModeDescription(void) const
{
    return (this.TradeCalcMode() == SYMBOL_CALC_MODE_FOREX ? TextByLanguage("Forex mode")
            : this.TradeCalcMode() == SYMBOL_CALC_MODE_FOREX_NO_LEVERAGE ? TextByLanguage("Forex No Leverage mode")
            : this.TradeCalcMode() == SYMBOL_CALC_MODE_FUTURES  ? TextByLanguage("Futures mode")
            : this.TradeCalcMode() == SYMBOL_CALC_MODE_CFD      ? TextByLanguage("CFD mode")
            : this.TradeCalcMode() == SYMBOL_CALC_MODE_CFDINDEX ? TextByLanguage("CFD index mode")
            : this.TradeCalcMode() == SYMBOL_CALC_MODE_CFDLEVERAGE ? TextByLanguage("CFD Leverage mode")
            : this.TradeCalcMode() == SYMBOL_CALC_MODE_EXCH_STOCKS ? TextByLanguage("Exchange mode")
            : this.TradeCalcMode() == SYMBOL_CALC_MODE_EXCH_FUTURES ? TextByLanguage("Futures mode")
            : this.TradeCalcMode() == SYMBOL_CALC_MODE_EXCH_FUTURES_FORTS ? TextByLanguage("FORTS Futures mode")
            : this.TradeCalcMode() == SYMBOL_CALC_MODE_EXCH_BONDS ? TextByLanguage("Exchange Bonds mode")
            : this.TradeCalcMode() == SYMBOL_CALC_MODE_EXCH_STOCKS_MOEX ? TextByLanguage("Exchange MOEX Stocks mode")
            : this.TradeCalcMode() == SYMBOL_CALC_MODE_EXCH_BONDS_MOEX ? TextByLanguage("Exchange MOEX Bonds mode")
            : this.TradeCalcMode() == SYMBOL_CALC_MODE_SERV_COLLATERAL ? TextByLanguage("Collateral mode")
                                                                       : "");
}
//+------------------------------------------------------------------+
//| Return the description of a symbol trading mode                  |
//+------------------------------------------------------------------+
string CSymbol::GetTradeModeDescription(void) const
{
    return (this.TradeMode() == SYMBOL_TRADE_MODE_DISABLED    ? TextByLanguage("Trade disabled for symbol")
            : this.TradeMode() == SYMBOL_TRADE_MODE_LONGONLY  ? TextByLanguage("Only long positions allowed")
            : this.TradeMode() == SYMBOL_TRADE_MODE_SHORTONLY ? TextByLanguage("Only short positions allowed")
            : this.TradeMode() == SYMBOL_TRADE_MODE_CLOSEONLY ? TextByLanguage("Only position close operations allowed")
            : this.TradeMode() == SYMBOL_TRADE_MODE_FULL ? TextByLanguage("No trade restrictions")
                                                         : "");
}
//+------------------------------------------------------------------+
//| Return the description of a symbol trade execution mode          |
//+------------------------------------------------------------------+
string CSymbol::GetTradeExecDescription(void) const
{
    return (this.TradeExecutionMode() == SYMBOL_TRADE_EXECUTION_REQUEST    ? TextByLanguage("Execution by request")
            : this.TradeExecutionMode() == SYMBOL_TRADE_EXECUTION_INSTANT  ? TextByLanguage("Instant execution")
            : this.TradeExecutionMode() == SYMBOL_TRADE_EXECUTION_MARKET   ? TextByLanguage("Market execution")
            : this.TradeExecutionMode() == SYMBOL_TRADE_EXECUTION_EXCHANGE ? TextByLanguage("Exchange execution")
                                                                           : "");
}
//+------------------------------------------------------------------+
//| Return the description of a swap calculation model               |
//+------------------------------------------------------------------+
string CSymbol::GetSwapModeDescription(void) const
{
    return (this.SwapMode() == SYMBOL_SWAP_MODE_DISABLED ? TextByLanguage("Swaps disabled (no swaps)")
            : this.SwapMode() == SYMBOL_SWAP_MODE_POINTS ? TextByLanguage("Swaps charged in points")
            : this.SwapMode() == SYMBOL_SWAP_MODE_CURRENCY_SYMBOL ? TextByLanguage("Swaps charged in money in base currency of the symbol")
            : this.SwapMode() == SYMBOL_SWAP_MODE_CURRENCY_MARGIN
                ? TextByLanguage("Swaps charged in money in margin currency of the symbol")
            : this.SwapMode() == SYMBOL_SWAP_MODE_CURRENCY_DEPOSIT ? TextByLanguage("Swaps charged in money, in client deposit currency")
            : this.SwapMode() == SYMBOL_SWAP_MODE_INTEREST_CURRENT ? TextByLanguage("Swaps charged as specified annual interest from instrument price at calculation of swap")
            : this.SwapMode() == SYMBOL_SWAP_MODE_INTEREST_OPEN
                ? TextByLanguage("Swaps charged as specified annual interest from open price of position")
            : this.SwapMode() == SYMBOL_SWAP_MODE_REOPEN_CURRENT ? TextByLanguage("Swaps charged by reopening positions by close price")
            : this.SwapMode() == SYMBOL_SWAP_MODE_REOPEN_BID
                ? TextByLanguage("Swaps charged by reopening positions by the current Bid price")
                : "");
}
//+------------------------------------------------------------------+
//| Return the description of StopLoss and TakeProfit order lifetime |
//+------------------------------------------------------------------+
string CSymbol::GetOrderGTCModeDescription(void) const
{
    return (this.OrderModeGTC() == SYMBOL_ORDERS_GTC ? TextByLanguage("Pending orders and Stop Loss/Take Profit levels valid for unlimited period until their explicit cancellation")
            : this.OrderModeGTC() == SYMBOL_ORDERS_DAILY ? TextByLanguage("At the end of the day, all Stop Loss and Take Profit levels, as well as pending orders deleted")
            : this.OrderModeGTC() == SYMBOL_ORDERS_DAILY_EXCLUDING_STOPS ? TextByLanguage("At the end of the day, only pending orders deleted, while Stop Loss and Take Profit levels preserved")
                                                                         : "");
}
//+------------------------------------------------------------------+
//| Return the option type description                               |
//+------------------------------------------------------------------+
string CSymbol::GetOptionTypeDescription(void) const
{
    return (
#ifdef __MQL4__ TextByLanguage("Property not supported in MQL4") #else
        this.OptionMode() == SYMBOL_OPTION_MODE_EUROPEAN
            ? TextByLanguage("European option may only be exercised on specified date")
        : this.OptionMode() == SYMBOL_OPTION_MODE_AMERICAN
            ? TextByLanguage("American option may be exercised on any trading day or before expiry")
            : ""
#endif
    );
}
//+------------------------------------------------------------------+
//| Return the option right description                              |
//+------------------------------------------------------------------+
string CSymbol::GetOptionRightDescription(void) const
{
    return (
#ifdef __MQL4__ TextByLanguage("Property not supported in MQL4") #else
        this.OptionRight() == SYMBOL_OPTION_RIGHT_CALL ? TextByLanguage("Call option gives you right to buy asset at specified price")
        : this.OptionRight() == SYMBOL_OPTION_RIGHT_PUT ? TextByLanguage("Put option gives you right to sell asset at specified price")
                                                        : ""
#endif
    );
}
//+------------------------------------------------------------------+
//| Return the description of the flags of allowed order types       |
//+------------------------------------------------------------------+
string CSymbol::GetOrderModeFlagsDescription(void) const
{
    string first = #ifdef __MQL5__ "\n - " #else "" #endif;
    string next  = #ifdef __MQL5__ "\n - " #else "; " #endif;
    return
         (
            first + this.GetMarketOrdersAllowedDescription() +
            next + this.GetLimitOrdersAllowedDescription() +
            next + this.GetStopOrdersAllowedDescription() +
            next + this.GetStopLimitOrdersAllowedDescription() +
            next + this.GetStopLossOrdersAllowedDescription() +
            next + this.GetTakeProfitOrdersAllowedDescription() +
            next + this.GetCloseByOrdersAllowedDescription()
         );
}
//+------------------------------------------------------------------+
//| Return the description of the flags of allowed filling types     |
//+------------------------------------------------------------------+
string CSymbol::GetFillingModeFlagsDescription(void) const
{
    string first = #ifdef __MQL5__ "\n - " #else "" #endif;
    string next  = #ifdef __MQL5__ "\n - " #else "; " #endif;
    return (first + TextByLanguage("Return (Yes)") + next + this.GetFillingModeFOKAllowedDescrioption() + next + this.GetFillingModeIOCAllowedDescrioption());
}
//+------------------------------------------------------------------------+
//| Return the description of the flags of allowed order expiration modes  |
//+------------------------------------------------------------------------+
string CSymbol::GetExpirationModeFlagsDescription(void) const
{
    string first = #ifdef __MQL5__ "\n - " #else "" #endif;
    string next  = #ifdef __MQL5__ "\n - " #else "; " #endif;
    return (first + this.GetExpirationModeGTCDescription() + next + this.GetExpirationModeDAYDescription() + next + this.GetExpirationModeSpecifiedDescription() + next +
            this.GetExpirationModeSpecDayDescription());
}
//+------------------------------------------------------------------+
//| Return the description of allowing to use market orders          |
//+------------------------------------------------------------------+
string CSymbol::GetMarketOrdersAllowedDescription(void) const
{
    return (this.IsMarketOrdersAllowed() ? TextByLanguage("Market order (Yes)") : TextByLanguage("Market order (No)"));
}
//+------------------------------------------------------------------+
//| Return the description of allowing to use limit orders           |
//+------------------------------------------------------------------+
string CSymbol::GetLimitOrdersAllowedDescription(void) const
{
    return (this.IsLimitOrdersAllowed() ? TextByLanguage("Limit order (Yes)") : TextByLanguage("Limit order (No)"));
}
//+------------------------------------------------------------------+
//| Return the description of allowing to use stop orders            |
//+------------------------------------------------------------------+
string CSymbol::GetStopOrdersAllowedDescription(void) const
{
    return (this.IsStopOrdersAllowed() ? TextByLanguage("Stop order (Yes)") : TextByLanguage("Stop order (No)"));
}
//+------------------------------------------------------------------+
//| Return the description of allowing to use stop limit orders      |
//+------------------------------------------------------------------+
string CSymbol::GetStopLimitOrdersAllowedDescription(void) const
{
    return (this.IsStopLimitOrdersAllowed() ? TextByLanguage("StopLimit order (Yes)") : TextByLanguage("StopLimit order (No)"));
}
//+------------------------------------------------------------------+
//| Return the description of allowing to set StopLoss orders        |
//+------------------------------------------------------------------+
string CSymbol::GetStopLossOrdersAllowedDescription(void) const
{
    return (this.IsStopLossOrdersAllowed() ? TextByLanguage("StopLoss (Yes)") : TextByLanguage("StopLoss (No)"));
}
//+------------------------------------------------------------------+
//| Return the description of allowing to set TakeProfit orders      |
//+------------------------------------------------------------------+
string CSymbol::GetTakeProfitOrdersAllowedDescription(void) const
{
    return (this.IsTakeProfitOrdersAllowed() ? TextByLanguage("TakeProfit (Yes)") : TextByLanguage("TakeProfit (No)"));
}
//+---------------------------------------------------------------------+
//| Return the description of allowing to close by an opposite position |
//+---------------------------------------------------------------------+
string CSymbol::GetCloseByOrdersAllowedDescription(void) const
{
    return (this.IsCloseByOrdersAllowed() ? TextByLanguage("CloseBy order (Yes)") : TextByLanguage("CloseBy order (No)"));
}
//+------------------------------------------------------------------+
//| Return the description of allowing FOK filling type              |
//+------------------------------------------------------------------+
string CSymbol::GetFillingModeFOKAllowedDescrioption(void) const
{
    return (this.IsFillingModeFOK() ? TextByLanguage("Fill or Kill (Yes)") : TextByLanguage("Fill or Kill (No)"));
}
//+------------------------------------------------------------------+
//| Return the description of allowing IOC filling type              |
//+------------------------------------------------------------------+
string CSymbol::GetFillingModeIOCAllowedDescrioption(void) const
{
    return (this.IsFillingModeIOC() ? TextByLanguage("Immediate or Cancel order (Yes)") : TextByLanguage("Immediate or Cancel (No)"));
}
//+------------------------------------------------------------------+
//| Return the description of GTC order expiration                   |
//+------------------------------------------------------------------+
string CSymbol::GetExpirationModeGTCDescription(void) const { return (this.IsExpirationModeGTC() ? TextByLanguage("Unlimited (Yes)") : TextByLanguage("Unlimited (No)")); }
//+------------------------------------------------------------------+
//| Return the description of DAY order expiration                   |
//+------------------------------------------------------------------+
string CSymbol::GetExpirationModeDAYDescription(void) const
{
    return (this.IsExpirationModeDAY() ? TextByLanguage("Valid till the end of the day (Yes)") : TextByLanguage("Valid till the end of the day (No)"));
}
//+------------------------------------------------------------------+
//| Return the description of Specified order expiration             |
//+------------------------------------------------------------------+
string CSymbol::GetExpirationModeSpecifiedDescription(void) const
{
    return (this.IsExpirationModeSpecified() ? TextByLanguage("Time specified in order (Yes)")
                                              : TextByLanguage("Time specified in order (No)"));
}
//+------------------------------------------------------------------+
//| Return the description of Specified Day order expiration         |
//+------------------------------------------------------------------+
string CSymbol::GetExpirationModeSpecDayDescription(void) const
{
    return (this.IsExpirationModeSpecifiedDay() ? TextByLanguage("Date specified in order (Yes)")
                                                 : TextByLanguage("Date specified in order (No)"));
}
//+------------------------------------------------------------------+
//| Return a normalized price considering symbol properties          |
//+------------------------------------------------------------------+
double CSymbol::NormalizedPrice(const double price) const
{
    double tsize = this.TradeTickSize();
    return (tsize != 0 ? ::NormalizeDouble(::round(price / tsize) * tsize, this.Digits()) : ::NormalizeDouble(price, this.Digits()));
}
//+------------------------------------------------------------------+
//| Update all symbol data that can change                           |
//+------------------------------------------------------------------+
void CSymbol::Refresh(void)
{
      ::ResetLastError();
      if(!::SymbolInfoTick(this.m_symbol_name, this.m_tick))
      {
         this.m_global_error = ::GetLastError();
         return;
      }
#ifdef __MQL5__
      ::ResetLastError();
      if(!this.MarginRates())
      {
         this.m_global_error=::GetLastError();
         return;
      }
#endif 
    //--- Update integer properties
    this.m_long_prop[SYMBOL_PROP_VOLUME]                                       = (long) this.m_tick.volume;
    this.m_long_prop[SYMBOL_PROP_TIME]                                         = #ifdef __MQL5__ this.m_tick.time_msc #else this.m_tick.time * 1000 #endif;
    this.m_long_prop[SYMBOL_PROP_SELECT]                                       = ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_SELECT);
    this.m_long_prop[SYMBOL_PROP_VISIBLE]                                      = ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_VISIBLE);
    this.m_long_prop[SYMBOL_PROP_SESSION_DEALS]                                = ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_SESSION_DEALS);
    this.m_long_prop[SYMBOL_PROP_SESSION_BUY_ORDERS]                           = ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_SESSION_BUY_ORDERS);
    this.m_long_prop[SYMBOL_PROP_SESSION_SELL_ORDERS]                          = ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_SESSION_SELL_ORDERS);
    this.m_long_prop[SYMBOL_PROP_VOLUMEHIGH]                                   = ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_VOLUMEHIGH);
    this.m_long_prop[SYMBOL_PROP_VOLUMELOW]                                    = ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_VOLUMELOW);
    this.m_long_prop[SYMBOL_PROP_SPREAD]                                       = ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_SPREAD);
    this.m_long_prop[SYMBOL_PROP_TICKS_BOOKDEPTH]                              = ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_TICKS_BOOKDEPTH);
    this.m_long_prop[SYMBOL_PROP_START_TIME]                                   = ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_START_TIME);
    this.m_long_prop[SYMBOL_PROP_EXPIRATION_TIME]                              = ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_EXPIRATION_TIME);
    this.m_long_prop[SYMBOL_PROP_TRADE_STOPS_LEVEL]                            = ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_TRADE_STOPS_LEVEL);
    this.m_long_prop[SYMBOL_PROP_TRADE_FREEZE_LEVEL]                           = ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_TRADE_FREEZE_LEVEL);
    this.m_long_prop[SYMBOL_PROP_BACKGROUND_COLOR]                             = this.SymbolBackgroundColor();
    //--- Update real properties
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_ASKHIGH)]                    = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_ASKHIGH);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_ASKLOW)]                     = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_ASKLOW);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_LASTHIGH)]                   = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_LASTHIGH);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_LASTLOW)]                    = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_LASTLOW);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_TICK_VALUE)]           = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_TRADE_TICK_VALUE);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_TICK_VALUE_PROFIT)]    = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_TRADE_TICK_VALUE_PROFIT);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_TICK_VALUE_LOSS)]      = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_TRADE_TICK_VALUE_LOSS);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_TICK_SIZE)]            = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_TRADE_TICK_SIZE);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_CONTRACT_SIZE)]        = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_TRADE_CONTRACT_SIZE);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_VOLUME_MIN)]                 = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_VOLUME_MIN);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_VOLUME_MAX)]                 = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_VOLUME_MAX);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_VOLUME_STEP)]                = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_VOLUME_STEP);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_VOLUME_LIMIT)]               = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_VOLUME_LIMIT);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_SWAP_LONG)]                  = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_SWAP_LONG);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_SWAP_SHORT)]                 = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_SWAP_SHORT);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_INITIAL)]             = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_MARGIN_INITIAL);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_MAINTENANCE)]         = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_MARGIN_MAINTENANCE);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_VOLUME)]             = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_SESSION_VOLUME);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_TURNOVER)]           = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_SESSION_TURNOVER);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_INTEREST)]           = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_SESSION_INTEREST);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_BUY_ORDERS_VOLUME)]  = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_SESSION_BUY_ORDERS_VOLUME);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_SELL_ORDERS_VOLUME)] = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_SESSION_SELL_ORDERS_VOLUME);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_OPEN)]               = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_SESSION_OPEN);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_CLOSE)]              = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_SESSION_CLOSE);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_AW)]                 = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_SESSION_AW);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_PRICE_SETTLEMENT)]   = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_SESSION_PRICE_SETTLEMENT);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_PRICE_LIMIT_MIN)]    = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_SESSION_PRICE_LIMIT_MIN);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_SESSION_PRICE_LIMIT_MAX)]    = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_SESSION_PRICE_LIMIT_MAX);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_ASK)]                        = this.m_tick.ask;
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_BID)]                        = this.m_tick.bid;
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_LAST)]                       = this.m_tick.last;
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_BIDHIGH)]                    = this.SymbolBidHigh();
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_BIDLOW)]                     = this.SymbolBidLow();
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_VOLUME_REAL)]                = this.SymbolVolumeReal();
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_VOLUMEHIGH_REAL)]            = this.SymbolVolumeHighReal();
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_VOLUMELOW_REAL)]             = this.SymbolVolumeLowReal();
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_OPTION_STRIKE)]              = this.SymbolOptionStrike();
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_ACCRUED_INTEREST)]     = this.SymbolTradeAccruedInterest();
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_FACE_VALUE)]           = this.SymbolTradeFaceValue();
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_LIQUIDITY_RATE)]       = this.SymbolTradeLiquidityRate();
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_HEDGED)]              = this.SymbolMarginHedged();
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_LONG_INITIAL)]              = this.m_margin_rate.Long.Initial;
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_BUY_STOP_INITIAL)]          = this.m_margin_rate.BuyStop.Initial;
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_BUY_LIMIT_INITIAL)]         = this.m_margin_rate.BuyLimit.Initial;
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_BUY_STOPLIMIT_INITIAL)]     = this.m_margin_rate.BuyStopLimit.Initial;
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_LONG_MAINTENANCE)]          = this.m_margin_rate.Long.Maintenance;
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_BUY_STOP_MAINTENANCE)]      = this.m_margin_rate.BuyStop.Maintenance;
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_BUY_LIMIT_MAINTENANCE)]     = this.m_margin_rate.BuyLimit.Maintenance;
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_BUY_STOPLIMIT_MAINTENANCE)] = this.m_margin_rate.BuyStopLimit.Maintenance;
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_SHORT_INITIAL)]             = this.m_margin_rate.Short.Initial;
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_SELL_STOP_INITIAL)]         = this.m_margin_rate.SellStop.Initial;
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_SELL_LIMIT_INITIAL)]        = this.m_margin_rate.SellLimit.Initial;
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_SELL_STOPLIMIT_INITIAL)]    = this.m_margin_rate.SellStopLimit.Initial;
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_SHORT_MAINTENANCE)]         = this.m_margin_rate.Short.Maintenance;
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_SELL_STOP_MAINTENANCE)]     = this.m_margin_rate.SellStop.Maintenance;
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_SELL_LIMIT_MAINTENANCE)]    = this.m_margin_rate.SellLimit.Maintenance;
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_MARGIN_SELL_STOPLIMIT_MAINTENANCE)]= this.m_margin_rate.SellStopLimit.Maintenance;
}
//+------------------------------------------------------------------+
//| Update quote data by a symbol                                    |
//+------------------------------------------------------------------+
void CSymbol::RefreshRates(void)
{
    ::ResetLastError();
    if(!::SymbolInfoTick(this.m_symbol_name, this.m_tick))
    {
        this.m_global_error = ::GetLastError();
        return;
    }
    //--- Update integer properties
    this.m_long_prop[SYMBOL_PROP_VOLUME]                                    = (long) this.m_tick.volume;
    this.m_long_prop[SYMBOL_PROP_TIME]                                      = #ifdef __MQL5__ this.m_tick.time_msc #else this.m_tick.time * 1000 #endif;
    this.m_long_prop[SYMBOL_PROP_SPREAD]                                    = ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_SPREAD);
    this.m_long_prop[SYMBOL_PROP_TRADE_STOPS_LEVEL]                         = ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_TRADE_STOPS_LEVEL);
    this.m_long_prop[SYMBOL_PROP_TRADE_FREEZE_LEVEL]                        = ::SymbolInfoInteger(this.m_symbol_name, SYMBOL_TRADE_FREEZE_LEVEL);
    //--- Update real properties
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_ASKHIGH)]                 = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_ASKHIGH);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_ASKLOW)]                  = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_ASKLOW);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_LASTHIGH)]                = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_LASTHIGH);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_LASTLOW)]                 = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_LASTLOW);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_TICK_VALUE)]        = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_TRADE_TICK_VALUE);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_TICK_VALUE_PROFIT)] = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_TRADE_TICK_VALUE_PROFIT);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_TRADE_TICK_VALUE_LOSS)]   = ::SymbolInfoDouble(this.m_symbol_name, SYMBOL_TRADE_TICK_VALUE_LOSS);
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_ASK)]                     = this.m_tick.ask;
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_BID)]                     = this.m_tick.bid;
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_LAST)]                    = this.m_tick.last;
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_BIDHIGH)]                 = this.SymbolBidHigh();
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_BIDLOW)]                  = this.SymbolBidLow();
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_VOLUME_REAL)]             = this.SymbolVolumeReal();
    this.m_double_prop[this.IndexProp(SYMBOL_PROP_OPTION_STRIKE)]           = this.SymbolOptionStrike();
}
//+------------------------------------------------------------------+
