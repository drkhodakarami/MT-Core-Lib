//+------------------------------------------------------------------+
//|                                                   TestPart39.mq5 |
//|                                              Alireza Khodakarami |
//|                         https://www.youtube.com/@YourTradeMaster |
//+------------------------------------------------------------------+
#property copyright "Alireza Khodakarami"
#property link "https://www.youtube.com/@YourTradeMaster"
#property version "1.00"
//--- includes
#include <MT Core Lib/Base/Engine.mqh>
//--- enums
//--- defines
//--- structures
//--- properties
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_plots 2
//--- plot Label1
#property indicator_label1 "Label1"
#property indicator_type1 DRAW_LINE
#property indicator_color1 clrRed
#property indicator_style1 STYLE_SOLID
#property indicator_width1 1
//--- plot Label2
#property indicator_label2 "Label2"
#property indicator_type2 DRAW_LINE
#property indicator_color2 clrGreen
#property indicator_style2 STYLE_SOLID
#property indicator_width2 1
//--- indicator buffers
double                      Buffer1[];
double                      Buffer2[];
//--- input variables
sinput ENUM_SYMBOLS_MODE    InpModeUsedSymbols = SYMBOLS_MODE_CURRENT;                                                              // Mode of used symbols list
sinput string               InpUsedSymbols     = "EURUSD,AUDUSD,EURAUD,EURCAD,EURGBP,EURJPY,EURUSD,GBPUSD,NZDUSD,USDCAD,USDJPY";    // List of used symbols (comma - separator)
sinput ENUM_TIMEFRAMES_MODE InpModeUsedTFs     = TIMEFRAMES_MODE_LIST;                                                              // Mode of used timeframes list
sinput string               InpUsedTFs         = "M1,M5,M15,M30,H1,H4,D1,W1,MN1";                                                   // List of used timeframes (comma - separator)
sinput bool                 InpUseSounds       = true;                                                                              // Use sounds
//--- global variables
CEngine                     engine;                  // CEngine library main object
string                      prefix;                  // Prefix of graphical object names
bool                        testing;                 // Flag of working in the tester
int                         used_symbols_mode;       // Mode of working with symbols
string                      array_used_symbols[];    // Array of used symbols
string                      array_used_periods[];    // Array of used timeframes
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int                         OnInit()
{
    //--- indicator buffers mapping
    SetIndexBuffer(0, Buffer1, INDICATOR_DATA);
    SetIndexBuffer(1, Buffer2, INDICATOR_DATA);

    //--- Set indicator global variables
    prefix  = MQLInfoString(MQL_PROGRAM_NAME) + "_";
    testing = engine.IsTester();
    ZeroMemory(rates_data);

    //--- Initialize MT Core Lib library
    OnInitCustom();

    //--- Check and remove remaining indicator graphical objects
    if(IsPresentObectByPrefix(prefix))
        ObjectsDeleteAll(0, prefix);

    //--- Check playing a standard sound using macro substitutions
    engine.PlaySoundByDescription(SND_OK);
    //--- Wait for 600 milliseconds
    engine.Pause(600);
    engine.PlaySoundByDescription(SND_NEWS);

    //---
    return (INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    //--- Remove indicator graphical objects by an object name prefix
    ObjectsDeleteAll(0, prefix);
    Comment("");
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int       rates_total,
                const int       prev_calculated,
                const datetime &time[],
                const double   &open[],
                const double   &high[],
                const double   &low[],
                const double   &close[],
                const long     &tick_volume[],
                const long     &volume[],
                const int      &spread[])
{
    //+------------------------------------------------------------------+
    //| OnCalculate code block for working with the library:             |
    //+------------------------------------------------------------------+
    //--- Pass the current symbol data from OnCalculate() to the price structure
    CopyData(rates_data, rates_total, prev_calculated, time, open, high, low, close, tick_volume, volume, spread);

    //--- Handle the Calculate event in the library
    engine.OnCalculate(rates_data);

    //--- If working in the tester
    if(MQLInfoInteger(MQL_TESTER))
    {
        engine.OnTimer(rates_data);    // Working in the timer
        PressButtonsControl();         // Button pressing control
        EventsHandling();              // Working with events
    }

    //+------------------------------------------------------------------+
    //| OnCalculate code block for working with the indicator:           |
    //+------------------------------------------------------------------+
    //--- Arrange resource-saving indicator calculations
    //--- Set OnCalculate arrays as timeseries
    ArraySetAsSeries(open, true);
    ArraySetAsSeries(high, true);
    ArraySetAsSeries(low, true);
    ArraySetAsSeries(close, true);
    ArraySetAsSeries(tick_volume, true);
    ArraySetAsSeries(volume, true);
    ArraySetAsSeries(spread, true);

    //--- Setting buffer arrays as timeseries
    ArraySetAsSeries(Buffer1, true);
    ArraySetAsSeries(Buffer2, true);

    //--- Check for the minimum number of bars for calculation
    if(rates_total < 2 || Point() == 0)
        return 0;

    //--- Check and calculate the number of calculated bars
    int limit = rates_total - prev_calculated;
    if(limit > 1)
    {
        limit = rates_total - 1;
        ArrayInitialize(Buffer1, EMPTY_VALUE);
        ArrayInitialize(Buffer2, EMPTY_VALUE);
    }
    //--- Prepare data
    for(int i = limit; i >= 0 && !IsStopped(); i--)
    {
        // the code for preparing indicator calculation buffers
    }

    //--- Calculate the indicator
    for(int i = limit; i >= 0 && !IsStopped(); i--)
    {
        Buffer1[i] = high[i];
        Buffer2[i] = low[i];
    }

    //--- return value of prev_calculated for next call
    return (rates_total);
}
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
{
    //--- Launch the library timer (only not in the tester)
    if(!MQLInfoInteger(MQL_TESTER))
        engine.OnTimer(rates_data);
}
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int     id,
                  const long   &lparam,
                  const double &dparam,
                  const string &sparam)
{
    //--- If working in the tester, exit
    if(MQLInfoInteger(MQL_TESTER))
        return;
    //--- Handling mouse events
    if(id == CHARTEVENT_OBJECT_CLICK)
    {
        //--- Handling pressing the buttons in the panel
        if(StringFind(sparam, "BUTT_") > 0)
            PressButtonEvents(sparam);
    }
    //--- Handling MT Core Lib library events
    if(id > CHARTEVENT_CUSTOM - 1)
        OnCustomEvent(id, lparam, dparam, sparam);
}
//+------------------------------------------------------------------+
//| Initializing Custom library                                      |
//+------------------------------------------------------------------+
void OnInitCustom()
{
    //--- Check if working with the full list is selected
    used_symbols_mode = InpModeUsedSymbols;
    if((ENUM_SYMBOLS_MODE) used_symbols_mode == SYMBOLS_MODE_ALL)
    {
        int    total   = SymbolsTotal(false);
        string en_n    = "\nNumber of symbols on server " + (string) total + ".\nMaximum number: " + (string) SYMBOLS_COMMON_TOTAL + " symbols.";
        string caption = TextByLanguage("Attention!");
        string en      = "Full list mode selected.\nIn this mode, the initial preparation of lists of symbol collections and timeseries can take a long time." + en_n + "\nContinue?\n\"No\" - working with the current symbol \"" + Symbol() + "\"";
        string message = TextByLanguage(en);
        int    flags   = (MB_YESNO | MB_ICONWARNING | MB_DEFBUTTON2);
        int    mb_res  = MessageBox(message, caption, flags);
        switch(mb_res)
        {
            case IDNO :
                used_symbols_mode = SYMBOLS_MODE_CURRENT;
                break;
            default :
                break;
        }
    }
    //--- Set the counter start point to measure the approximate library initialization time
    ulong begin = GetTickCount();
    Print(TextByLanguage("--- Initializing the \"MT Core Lib\" library ---"));
    //--- Fill in the array of used symbols
    CreateUsedSymbolsArray((ENUM_SYMBOLS_MODE) used_symbols_mode, InpUsedSymbols, array_used_symbols);
    //--- Set the type of the used symbol list in the symbol collection and fill in the list of symbol timeseries
    engine.SetUsedSymbols(array_used_symbols);
    //--- Displaying the selected mode of working with the symbol object collection in the journal
    string num =
        (used_symbols_mode == SYMBOLS_MODE_CURRENT 
                  ? ": \"" + Symbol() + "\"" 
                  : TextByLanguage(". The number of symbols used: ") + (string) engine.GetSymbolsCollectionTotal());
    Print(engine.ModeSymbolsListDescription(), num);
//--- Implement displaying the list of used symbols only for MQL5 - MQL4 has no ArrayPrint() function
#ifdef __MQL5__
    if(InpModeUsedSymbols != SYMBOLS_MODE_CURRENT)
    {
        string     array_symbols[];
        CArrayObj *list_symbols = engine.GetListAllUsedSymbols();
        for(int i = 0; i < list_symbols.Total(); i++)
        {
            CSymbol *symbol = list_symbols.At(i);
            if(symbol == NULL)
                continue;
            ArrayResize(array_symbols, ArraySize(array_symbols) + 1, 1000);
            array_symbols[ArraySize(array_symbols) - 1] = symbol.Name();
        }
        ArrayPrint(array_symbols);
    }
#endif
    //--- Set used timeframes
    CreateUsedTimeframesArray(InpModeUsedTFs, InpUsedTFs, array_used_periods);
    //--- Display the selected mode of working with the timeseries object collection
    string mode =
        (InpModeUsedTFs == TIMEFRAMES_MODE_CURRENT 
                ? TextByLanguage("Work only with the current Period: ") + TimeframeDescription((ENUM_TIMEFRAMES) Period()) 
                : InpModeUsedTFs == TIMEFRAMES_MODE_LIST 
                      ? TextByLanguage("Work with a predefined list of Periods:")
                      : TextByLanguage("Work with the full list of all Periods:"));
    Print(mode);
//--- Implement displaying the list of used timeframes only for MQL5 - MQL4 has no ArrayPrint() function
#ifdef __MQL5__
    if(InpModeUsedTFs != TIMEFRAMES_MODE_CURRENT)
        ArrayPrint(array_used_periods);
#endif
    //--- Create timeseries of all used symbols
    engine.SeriesCreateAll(array_used_periods);
    //--- Check created timeseries - display descriptions of all created timeseries in the journal
    //--- (true - only created ones, false - created and declared ones)
    engine.GetTimeSeriesCollection().PrintShort(false);    // Short descriptions
    // engine.GetTimeSeriesCollection().Print(true);      // Full descriptions

    //--- Create resource text files
    engine.CreateFile(FILE_TYPE_WAV, "sound_array_coin_01", TextByLanguage("Falling coin 1"), sound_array_coin_01);
    engine.CreateFile(FILE_TYPE_WAV, "sound_array_coin_02", TextByLanguage("Falling coins"), sound_array_coin_02);
    engine.CreateFile(FILE_TYPE_WAV, "sound_array_coin_03", TextByLanguage("Coins"), sound_array_coin_03);
    engine.CreateFile(FILE_TYPE_WAV, "sound_array_coin_04", TextByLanguage("Falling coin 2"), sound_array_coin_04);
    engine.CreateFile(FILE_TYPE_WAV, "sound_array_click_01", TextByLanguage("Button click 1"), sound_array_click_01);
    engine.CreateFile(FILE_TYPE_WAV, "sound_array_click_02", TextByLanguage("Button click 2"), sound_array_click_02);
    engine.CreateFile(FILE_TYPE_WAV, "sound_array_click_03", TextByLanguage("Button click 3"), sound_array_click_03);
    engine.CreateFile(FILE_TYPE_WAV, "sound_array_cash_machine_01", TextByLanguage("Cash machine"), sound_array_cash_machine_01);
    engine.CreateFile(FILE_TYPE_BMP, "img_array_spot_green", TextByLanguage("Image \"Green Spot lamp\""), img_array_spot_green);
    engine.CreateFile(FILE_TYPE_BMP, "img_array_spot_red", TextByLanguage("Image \"Red Spot lamp\""), img_array_spot_red);

    //--- Pass all existing collections to the main library class
    engine.CollectionOnInit();
    /*
    //--- Set the default magic number for all used symbols
       engine.TradingSetMagic(engine.SetCompositeMagicNumber(magic_number));
    */
    //--- Set standard sounds for trading objects of all used symbols
    engine.SetSoundsStandard();
    //--- Set the general flag of using sounds
    engine.SetUseSounds(InpUseSounds);
    //--- Set the spread multiplier for symbol trading objects in the symbol collection
    // engine.SetSpreadMultiplier(InpSpreadMultiplier);

    //--- Set controlled values for symbols
    //--- Get the list of all collection symbols
    CArrayObj *list = engine.GetListAllUsedSymbols();
    if(list != NULL && list.Total() != 0)
    {
        //--- In a loop by the list, set the necessary values for tracked symbol properties
        //--- By default, the LONG_MAX value is set to all properties, which means "Do not track this property"
        //--- It can be enabled or disabled (by setting the value less than LONG_MAX or vice versa - set the LONG_MAX value) at any time and anywhere in the program
        /*
        for(int i=0;i<list.Total();i++)
          {
           CSymbol* symbol=list.At(i);
           if(symbol==NULL)
              continue;
           //--- Set control of the symbol price increase by 100 points
           symbol.SetControlBidInc(100000*symbol.Point());
           //--- Set control of the symbol price decrease by 100 points
           symbol.SetControlBidDec(100000*symbol.Point());
           //--- Set control of the symbol spread increase by 40 points
           symbol.SetControlSpreadInc(400);
           //--- Set control of the symbol spread decrease by 40 points
           symbol.SetControlSpreadDec(400);
           //--- Set control of the current spread by the value of 40 points
           symbol.SetControlSpreadLevel(400);
          }
        */
    }
    //--- Set controlled values for the current account
    CAccount *account = engine.GetAccountCurrent();
    if(account != NULL)
    {
        //--- Set control of the profit increase to 10
        account.SetControlledValueINC(ACCOUNT_PROP_PROFIT, 10.0);
        //--- Set control of the funds increase to 15
        account.SetControlledValueINC(ACCOUNT_PROP_EQUITY, 15.0);
        //--- Set profit control level to 20
        account.SetControlledValueLEVEL(ACCOUNT_PROP_PROFIT, 20.0);
    }
    //--- Get the end of the library initialization time counting and display it in the journal
    ulong end = GetTickCount();
    Print(TextByLanguage("Library initialization time: "), TimeMSCtoString(end - begin, TIME_MINUTES | TIME_SECONDS));
}
//+------------------------------------------------------------------+
//| Copy data from the first OnCalculate() form to the structure     |
//+------------------------------------------------------------------+
void CopyData(SDataCalculate &data_calculate,
              const int       rates_total,
              const int       prev_calculated,
              const int       begin,
              const double   &price[])
{
    //--- Get the array indexing flag as in the timeseries. If failed,
    //--- set the indexing direction for the array as in the timeseries
    bool as_series_price = ArrayGetAsSeries(price);
    if(!as_series_price)
        ArraySetAsSeries(price, true);
    //--- Copy the array zero bar to the OnCalculate() SDataCalculate data structure
    data_calculate.rates_total     = rates_total;
    data_calculate.prev_calculated = prev_calculated;
    data_calculate.begin           = begin;
    data_calculate.price           = price[0];
    //--- Return the array's initial indexing direction
    if(!as_series_price)
        ArraySetAsSeries(price, false);
}
//+------------------------------------------------------------------+
//| Copy data from the second OnCalculate() form to the structure    |
//+------------------------------------------------------------------+
void CopyData(SDataCalculate &data_calculate,
              const int       rates_total,
              const int       prev_calculated,
              const datetime &time[],
              const double   &open[],
              const double   &high[],
              const double   &low[],
              const double   &close[],
              const long     &tick_volume[],
              const long     &volume[],
              const int      &spread[])
{
    //--- Get the array indexing flags as in the timeseries. If failed,
    //--- set the indexing direction or the arrays as in the timeseries
    bool as_series_time = ArrayGetAsSeries(time);
    if(!as_series_time)
        ArraySetAsSeries(time, true);
    bool as_series_open = ArrayGetAsSeries(open);
    if(!as_series_open)
        ArraySetAsSeries(open, true);
    bool as_series_high = ArrayGetAsSeries(high);
    if(!as_series_high)
        ArraySetAsSeries(high, true);
    bool as_series_low = ArrayGetAsSeries(low);
    if(!as_series_low)
        ArraySetAsSeries(low, true);
    bool as_series_close = ArrayGetAsSeries(close);
    if(!as_series_close)
        ArraySetAsSeries(close, true);
    bool as_series_tick_volume = ArrayGetAsSeries(tick_volume);
    if(!as_series_tick_volume)
        ArraySetAsSeries(tick_volume, true);
    bool as_series_volume = ArrayGetAsSeries(volume);
    if(!as_series_volume)
        ArraySetAsSeries(volume, true);
    bool as_series_spread = ArrayGetAsSeries(spread);
    if(!as_series_spread)
        ArraySetAsSeries(spread, true);
    //--- Copy the arrays' zero bar to the OnCalculate() SDataCalculate data structure
    data_calculate.rates_total       = rates_total;
    data_calculate.prev_calculated   = prev_calculated;
    data_calculate.rates.time        = time[0];
    data_calculate.rates.open        = open[0];
    data_calculate.rates.high        = high[0];
    data_calculate.rates.low         = low[0];
    data_calculate.rates.close       = close[0];
    data_calculate.rates.tick_volume = tick_volume[0];
    data_calculate.rates.real_volume = (#ifdef __MQL5__ volume[0] #else 0 #endif);
    data_calculate.rates.spread      = (#ifdef __MQL5__ spread[0] #else 0 #endif);
    //--- Return the arrays' initial indexing direction
    if(!as_series_time)
        ArraySetAsSeries(time, false);
    if(!as_series_open)
        ArraySetAsSeries(open, false);
    if(!as_series_high)
        ArraySetAsSeries(high, false);
    if(!as_series_low)
        ArraySetAsSeries(low, false);
    if(!as_series_close)
        ArraySetAsSeries(close, false);
    if(!as_series_tick_volume)
        ArraySetAsSeries(tick_volume, false);
    if(!as_series_volume)
        ArraySetAsSeries(volume, false);
    if(!as_series_spread)
        ArraySetAsSeries(spread, false);
}
//+------------------------------------------------------------------+
//| Handling Custom library events                                   |
//+------------------------------------------------------------------+
void OnCustomEvent(const int     id,
                   const long   &lparam,
                   const double &dparam,
                   const string &sparam)
{
    int    idx    = id - CHARTEVENT_CUSTOM;
    //--- Retrieve (1) event time milliseconds, (2) reason and (3) source from lparam, as well as (4) set the exact event time
    ushort msc    = engine.EventMSC(lparam);
    ushort reason = engine.EventReason(lparam);
    ushort source = engine.EventSource(lparam);
    long   time   = TimeCurrent() * 1000 + msc;

    //--- Handling symbol events
    if(source == COLLECTION_SYMBOLS_ID)
    {
        CSymbol *symbol = engine.GetSymbolObjByName(sparam);
        if(symbol == NULL)
            return;
        //--- Number of decimal places in the event value - in case of a 'long' event, it is 0, otherwise - Digits() of a symbol
        int    digits   = (idx < SYMBOL_PROP_INTEGER_TOTAL ? 0 : symbol.Digits());
        //--- Event text description
        string id_descr = (idx < SYMBOL_PROP_INTEGER_TOTAL ? symbol.GetPropertyDescription((ENUM_SYMBOL_PROP_INTEGER) idx) : symbol.GetPropertyDescription((ENUM_SYMBOL_PROP_DOUBLE) idx));
        //--- Property change text value
        string value    = DoubleToString(dparam, digits);

        //--- Check event reasons and display its description in the journal
        if(reason == BASE_EVENT_REASON_INC)
            Print(symbol.EventDescription(idx, (ENUM_BASE_EVENT_REASON) reason, source, value, id_descr, digits));
        if(reason == BASE_EVENT_REASON_DEC)
            Print(symbol.EventDescription(idx, (ENUM_BASE_EVENT_REASON) reason, source, value, id_descr, digits));
        if(reason == BASE_EVENT_REASON_MORE_THEN)
            Print(symbol.EventDescription(idx, (ENUM_BASE_EVENT_REASON) reason, source, value, id_descr, digits));
        if(reason == BASE_EVENT_REASON_LESS_THEN)
            Print(symbol.EventDescription(idx, (ENUM_BASE_EVENT_REASON) reason, source, value, id_descr, digits));
        if(reason == BASE_EVENT_REASON_EQUALS)
            Print(symbol.EventDescription(idx, (ENUM_BASE_EVENT_REASON) reason, source, value, id_descr, digits));
    }

    //--- Handling account events
    else if(source == COLLECTION_ACCOUNT_ID)
    {
        CAccount *account = engine.GetAccountCurrent();
        if(account == NULL)
            return;
        //--- Number of decimal places in the event value - in case of a 'long' event, it is 0, otherwise - Digits() of a symbol
        int    digits   = int(idx < ACCOUNT_PROP_INTEGER_TOTAL ? 0 : account.CurrencyDigits());
        //--- Event text description
        string id_descr = (idx < ACCOUNT_PROP_INTEGER_TOTAL ? account.GetPropertyDescription((ENUM_ACCOUNT_PROP_INTEGER) idx) : account.GetPropertyDescription((ENUM_ACCOUNT_PROP_DOUBLE) idx));
        //--- Property change text value
        string value    = DoubleToString(dparam, digits);

        //--- Checking event reasons and handling the increase of funds by a specified value,

        //--- In case of a property value increase
        if(reason == BASE_EVENT_REASON_INC)
        {
            //--- Display an event in the journal
            Print(account.EventDescription(idx, (ENUM_BASE_EVENT_REASON) reason, source, value, id_descr, digits));
            //--- if this is an equity increase
            if(idx == ACCOUNT_PROP_EQUITY)
            {
                //--- Get the list of all open positions for the current symbol
                CArrayObj *list_positions = engine.GetListMarketPosition();
                list_positions            = CSelect::ByOrderProperty(list_positions, ORDER_PROP_SYMBOL, Symbol(), EQUAL);
                //--- Select positions with the profit exceeding zero
                list_positions            = CSelect::ByOrderProperty(list_positions, ORDER_PROP_PROFIT_FULL, 0, MORE);
                if(list_positions != NULL)
                {
                    //--- Sort the list by profit considering commission and swap
                    list_positions.Sort(SORT_BY_ORDER_PROFIT_FULL);
                    //--- Get the position index with the highest profit
                    int index = CSelect::FindOrderMax(list_positions, ORDER_PROP_PROFIT_FULL);
                    if(index > WRONG_VALUE)
                    {
                        COrder *position = list_positions.At(index);
                        if(position != NULL)
                        {
                            //--- Get a ticket of a position with the highest profit and close the position by a ticket
                            engine.ClosePosition(position.Ticket());
                        }
                    }
                }
            }
        }
        //--- Other events are simply displayed in the journal
        if(reason == BASE_EVENT_REASON_DEC)
            Print(account.EventDescription(idx, (ENUM_BASE_EVENT_REASON) reason, source, value, id_descr, digits));
        if(reason == BASE_EVENT_REASON_MORE_THEN)
            Print(account.EventDescription(idx, (ENUM_BASE_EVENT_REASON) reason, source, value, id_descr, digits));
        if(reason == BASE_EVENT_REASON_LESS_THEN)
            Print(account.EventDescription(idx, (ENUM_BASE_EVENT_REASON) reason, source, value, id_descr, digits));
        if(reason == BASE_EVENT_REASON_EQUALS)
            Print(account.EventDescription(idx, (ENUM_BASE_EVENT_REASON) reason, source, value, id_descr, digits));
    }

    //--- Handling market watch window events
    else if(idx > MARKET_WATCH_EVENT_NO_EVENT && idx < SYMBOL_EVENTS_NEXT_CODE)
    {
        //--- Market Watch window event
        string descr = engine.GetMWEventDescription((ENUM_MW_EVENT) idx);
        string name  = (idx == MARKET_WATCH_EVENT_SYMBOL_SORT ? "" : ": " + sparam);
        Print(TimeMSCtoString(lparam), " ", descr, name);
    }

    //--- Handling timeseries events
    else if(idx > SERIES_EVENTS_NO_EVENT && idx < SERIES_EVENTS_NEXT_CODE)
    {
        //--- "New bar" event
        if(idx == SERIES_EVENTS_NEW_BAR)
            Print(TextByLanguage("New Bar on "), sparam, " ", TimeframeDescription((ENUM_TIMEFRAMES) dparam), ": ", TimeToString(lparam));
    }

    //--- Handling trading events
    else if(idx > TRADE_EVENT_NO_EVENT && idx < TRADE_EVENTS_NEXT_CODE)
    {
        //--- Get the list of trading events
        CArrayObj *list = engine.GetListAllOrdersEvents();
        if(list == NULL)
            return;
        //--- get the event index shift relative to the end of the list
        //--- in the tester, the shift is passed by the lparam parameter to the event handler
        //--- outside the tester, events are sent one by one and handled in OnChartEvent()
        int     shift = (testing ? (int) lparam : 0);
        CEvent *event = list.At(list.Total() - 1 - shift);
        if(event == NULL)
            return;
        //--- Accrue the credit
        if(event.TypeEvent() == TRADE_EVENT_ACCOUNT_CREDIT)
            Print(DFUN, event.TypeEventDescription());
        //--- Additional charges
        if(event.TypeEvent() == TRADE_EVENT_ACCOUNT_CHARGE)
            Print(DFUN, event.TypeEventDescription());
        //--- Correction
        if(event.TypeEvent() == TRADE_EVENT_ACCOUNT_CORRECTION)
            Print(DFUN, event.TypeEventDescription());
        //--- Enumerate bonuses
        if(event.TypeEvent() == TRADE_EVENT_ACCOUNT_BONUS)
            Print(DFUN, event.TypeEventDescription());
        //--- Additional commissions
        if(event.TypeEvent() == TRADE_EVENT_ACCOUNT_COMISSION)
            Print(DFUN, event.TypeEventDescription());
        //--- Daily commission
        if(event.TypeEvent() == TRADE_EVENT_ACCOUNT_COMISSION_DAILY)
            Print(DFUN, event.TypeEventDescription());
        //--- Monthly commission
        if(event.TypeEvent() == TRADE_EVENT_ACCOUNT_COMISSION_MONTHLY)
            Print(DFUN, event.TypeEventDescription());
        //--- Daily agent commission
        if(event.TypeEvent() == TRADE_EVENT_ACCOUNT_COMISSION_AGENT_DAILY)
            Print(DFUN, event.TypeEventDescription());
        //--- Monthly agent commission
        if(event.TypeEvent() == TRADE_EVENT_ACCOUNT_COMISSION_AGENT_MONTHLY)
            Print(DFUN, event.TypeEventDescription());
        //--- Interest rate
        if(event.TypeEvent() == TRADE_EVENT_ACCOUNT_INTEREST)
            Print(DFUN, event.TypeEventDescription());
        //--- Canceled buy deal
        if(event.TypeEvent() == TRADE_EVENT_BUY_CANCELLED)
            Print(DFUN, event.TypeEventDescription());
        //--- Canceled sell deal
        if(event.TypeEvent() == TRADE_EVENT_SELL_CANCELLED)
            Print(DFUN, event.TypeEventDescription());
        //--- Dividend operations
        if(event.TypeEvent() == TRADE_EVENT_DIVIDENT)
            Print(DFUN, event.TypeEventDescription());
        //--- Accrual of franked dividend
        if(event.TypeEvent() == TRADE_EVENT_DIVIDENT_FRANKED)
            Print(DFUN, event.TypeEventDescription());
        //--- Tax charges
        if(event.TypeEvent() == TRADE_EVENT_TAX)
            Print(DFUN, event.TypeEventDescription());
        //--- Replenishing account balance
        if(event.TypeEvent() == TRADE_EVENT_ACCOUNT_BALANCE_REFILL)
            Print(DFUN, event.TypeEventDescription());
        //--- Withdrawing funds from balance
        if(event.TypeEvent() == TRADE_EVENT_ACCOUNT_BALANCE_WITHDRAWAL)
            Print(DFUN, event.TypeEventDescription());

        //--- Pending order placed
        if(event.TypeEvent() == TRADE_EVENT_PENDING_ORDER_PLASED)
            Print(DFUN, event.TypeEventDescription());
        //--- Pending order removed
        if(event.TypeEvent() == TRADE_EVENT_PENDING_ORDER_REMOVED)
            Print(DFUN, event.TypeEventDescription());
        //--- Pending order activated by price
        if(event.TypeEvent() == TRADE_EVENT_PENDING_ORDER_ACTIVATED)
            Print(DFUN, event.TypeEventDescription());
        //--- Pending order partially activated by price
        if(event.TypeEvent() == TRADE_EVENT_PENDING_ORDER_ACTIVATED_PARTIAL)
            Print(DFUN, event.TypeEventDescription());
        //--- Position opened
        if(event.TypeEvent() == TRADE_EVENT_POSITION_OPENED)
            Print(DFUN, event.TypeEventDescription());
        //--- Position opened partially
        if(event.TypeEvent() == TRADE_EVENT_POSITION_OPENED_PARTIAL)
            Print(DFUN, event.TypeEventDescription());
        //--- Position closed
        if(event.TypeEvent() == TRADE_EVENT_POSITION_CLOSED)
            Print(DFUN, event.TypeEventDescription());
        //--- Position closed by an opposite one
        if(event.TypeEvent() == TRADE_EVENT_POSITION_CLOSED_BY_POS)
            Print(DFUN, event.TypeEventDescription());
        //--- Position closed by StopLoss
        if(event.TypeEvent() == TRADE_EVENT_POSITION_CLOSED_BY_SL)
            Print(DFUN, event.TypeEventDescription());
        //--- Position closed by TakeProfit
        if(event.TypeEvent() == TRADE_EVENT_POSITION_CLOSED_BY_TP)
            Print(DFUN, event.TypeEventDescription());
        //--- Position reversal by a new deal (netting)
        if(event.TypeEvent() == TRADE_EVENT_POSITION_REVERSED_BY_MARKET)
            Print(DFUN, event.TypeEventDescription());
        //--- Position reversal by activating a pending order (netting)
        if(event.TypeEvent() == TRADE_EVENT_POSITION_REVERSED_BY_PENDING)
            Print(DFUN, event.TypeEventDescription());
        //--- Position reversal by partial market order execution (netting)
        if(event.TypeEvent() == TRADE_EVENT_POSITION_REVERSED_BY_MARKET_PARTIAL)
            Print(DFUN, event.TypeEventDescription());
        //--- Position reversal by activating a pending order (netting)
        if(event.TypeEvent() == TRADE_EVENT_POSITION_REVERSED_BY_PENDING_PARTIAL)
            Print(DFUN, event.TypeEventDescription());
        //--- Added volume to a position by a new deal (netting)
        if(event.TypeEvent() == TRADE_EVENT_POSITION_VOLUME_ADD_BY_MARKET)
            Print(DFUN, event.TypeEventDescription());
        //--- Added volume to a position by partial execution of a market order (netting)
        if(event.TypeEvent() == TRADE_EVENT_POSITION_VOLUME_ADD_BY_MARKET_PARTIAL)
            Print(DFUN, event.TypeEventDescription());
        //--- Added volume to a position by activating a pending order (netting)
        if(event.TypeEvent() == TRADE_EVENT_POSITION_VOLUME_ADD_BY_PENDING)
            Print(DFUN, event.TypeEventDescription());
        //--- Added volume to a position by partial activation of a pending order (netting)
        if(event.TypeEvent() == TRADE_EVENT_POSITION_VOLUME_ADD_BY_PENDING_PARTIAL)
            Print(DFUN, event.TypeEventDescription());
        //--- Position closed partially
        if(event.TypeEvent() == TRADE_EVENT_POSITION_CLOSED_PARTIAL)
            Print(DFUN, event.TypeEventDescription());
        //--- Position partially closed by an opposite one
        if(event.TypeEvent() == TRADE_EVENT_POSITION_CLOSED_PARTIAL_BY_POS)
            Print(DFUN, event.TypeEventDescription());
        //--- Position closed partially by StopLoss
        if(event.TypeEvent() == TRADE_EVENT_POSITION_CLOSED_PARTIAL_BY_SL)
            Print(DFUN, event.TypeEventDescription());
        //--- Position closed partially by TakeProfit
        if(event.TypeEvent() == TRADE_EVENT_POSITION_CLOSED_PARTIAL_BY_TP)
            Print(DFUN, event.TypeEventDescription());
        //--- StopLimit order activation
        if(event.TypeEvent() == TRADE_EVENT_TRIGGERED_STOP_LIMIT_ORDER)
            Print(DFUN, event.TypeEventDescription());
        //--- Changing order price
        if(event.TypeEvent() == TRADE_EVENT_MODIFY_ORDER_PRICE)
            Print(DFUN, event.TypeEventDescription());
        //--- Changing order and StopLoss price
        if(event.TypeEvent() == TRADE_EVENT_MODIFY_ORDER_PRICE_SL)
            Print(DFUN, event.TypeEventDescription());
        //--- Changing order and TakeProfit price
        if(event.TypeEvent() == TRADE_EVENT_MODIFY_ORDER_PRICE_TP)
            Print(DFUN, event.TypeEventDescription());
        //--- Changing order, StopLoss and TakeProfit price
        if(event.TypeEvent() == TRADE_EVENT_MODIFY_ORDER_PRICE_SL_TP)
            Print(DFUN, event.TypeEventDescription());
        //--- Changing order's StopLoss and TakeProfit price
        if(event.TypeEvent() == TRADE_EVENT_MODIFY_ORDER_SL_TP)
            Print(DFUN, event.TypeEventDescription());
        //--- Changing order's StopLoss
        if(event.TypeEvent() == TRADE_EVENT_MODIFY_ORDER_SL)
            Print(DFUN, event.TypeEventDescription());
        //--- Changing order's TakeProfit
        if(event.TypeEvent() == TRADE_EVENT_MODIFY_ORDER_TP)
            Print(DFUN, event.TypeEventDescription());
        //--- Changing position's StopLoss and TakeProfit
        if(event.TypeEvent() == TRADE_EVENT_MODIFY_POSITION_SL_TP)
            Print(DFUN, event.TypeEventDescription());
        //--- Changing position StopLoss
        if(event.TypeEvent() == TRADE_EVENT_MODIFY_POSITION_SL)
            Print(DFUN, event.TypeEventDescription());
        //--- Changing position TakeProfit
        if(event.TypeEvent() == TRADE_EVENT_MODIFY_POSITION_TP)
            Print(DFUN, event.TypeEventDescription());
    }
}
//+------------------------------------------------------------------+
//| Working with events in the tester                                |
//+------------------------------------------------------------------+
void EventsHandling(void)
{
    //--- If a trading event is present
    if(engine.IsTradeEvent())
    {
        //--- Number of trading events occurred simultaneously
        int total = engine.GetTradeEventsTotal();
        for(int i = 0; i < total; i++)
        {
            //--- Get the next event from the list of simultaneously occurred events by index
            CEventBaseObj *event = engine.GetTradeEventByIndex(i);
            if(event == NULL)
                continue;
            long   lparam = i;
            double dparam = event.DParam();
            string sparam = event.SParam();
            OnCustomEvent(CHARTEVENT_CUSTOM + event.ID(), lparam, dparam, sparam);
        }
    }
    //--- If there is an account event
    if(engine.IsAccountsEvent())
    {
        //--- Get the list of all account events occurred simultaneously
        CArrayObj *list = engine.GetListAccountEvents();
        if(list != NULL)
        {
            //--- Get the next event in a loop
            int total = list.Total();
            for(int i = 0; i < total; i++)
            {
                //--- take an event from the list
                CEventBaseObj *event = list.At(i);
                if(event == NULL)
                    continue;
                //--- Send an event to the event handler
                long   lparam = event.LParam();
                double dparam = event.DParam();
                string sparam = event.SParam();
                OnCustomEvent(CHARTEVENT_CUSTOM + event.ID(), lparam, dparam, sparam);
            }
        }
    }
    //--- If there is a symbol collection event
    if(engine.IsSymbolsEvent())
    {
        //--- Get the list of all symbol events occurred simultaneously
        CArrayObj *list = engine.GetListSymbolsEvents();
        if(list != NULL)
        {
            //--- Get the next event in a loop
            int total = list.Total();
            for(int i = 0; i < total; i++)
            {
                //--- take an event from the list
                CEventBaseObj *event = list.At(i);
                if(event == NULL)
                    continue;
                //--- Send an event to the event handler
                long   lparam = event.LParam();
                double dparam = event.DParam();
                string sparam = event.SParam();
                OnCustomEvent(CHARTEVENT_CUSTOM + event.ID(), lparam, dparam, sparam);
            }
        }
    }
    //--- If there is a timeseries collection event
    if(engine.IsSeriesEvent())
    {
        //--- Get the list of all timeseries events occurred simultaneously
        CArrayObj *list = engine.GetListSeriesEvents();
        if(list != NULL)
        {
            //--- Get the next event in a loop
            int total = list.Total();
            for(int i = 0; i < total; i++)
            {
                //--- take an event from the list
                CEventBaseObj *event = list.At(i);
                if(event == NULL)
                    continue;
                //--- Send an event to the event handler
                long   lparam = event.LParam();
                double dparam = event.DParam();
                string sparam = event.SParam();
                OnCustomEvent(CHARTEVENT_CUSTOM + event.ID(), lparam, dparam, sparam);
            }
        }
    }
}
//+------------------------------------------------------------------+
//| Return the button status                                         |
//+------------------------------------------------------------------+
bool ButtonState(const string name)
{
    return (bool) ObjectGetInteger(0, name, OBJPROP_STATE);
}
//+------------------------------------------------------------------+
//| Set the button status                                            |
//+------------------------------------------------------------------+
void ButtonState(const string name, const bool state)
{
    ObjectSetInteger(0, name, OBJPROP_STATE, state);
    //--- Button 1
    if(name == "BUTT_1")
    {
        if(state)
            ObjectSetInteger(0, name, OBJPROP_BGCOLOR, C'220,255,240');
        else
            ObjectSetInteger(0, name, OBJPROP_BGCOLOR, C'240,240,240');
    }
    //--- Button 2
    if(name == "BUTT_2")
    {
        if(state)
            ObjectSetInteger(0, name, OBJPROP_BGCOLOR, C'255,220,90');
        else
            ObjectSetInteger(0, name, OBJPROP_BGCOLOR, C'240,240,240');
    }
}
//+------------------------------------------------------------------+
//| Tracking the buttons' status                                     |
//+------------------------------------------------------------------+
void PressButtonsControl(void)
{
    int total = ObjectsTotal(0, 0);
    for(int i = 0; i < total; i++)
    {
        string obj_name = ObjectName(0, i);
        if(StringFind(obj_name, prefix + "BUTT_") < 0)
            continue;
        PressButtonEvents(obj_name);
    }
}
//+------------------------------------------------------------------+
//| Handle pressing the buttons                                      |
//+------------------------------------------------------------------+
void PressButtonEvents(const string button_name)
{
    //--- Convert button name into its string ID
    string button = StringSubstr(button_name, StringLen(prefix));
    //--- If the button is pressed
    if(ButtonState(button_name))
    {
        //--- If button 1 is pressed
        if(button == "BUTT_1")
        {
        }
        //--- If button 2 is pressed
        else if(button == "BUTT_2")
        {
        }
        //--- Wait for 1/10 of a second
        engine.Pause(100);
        //--- "Unpress" the button (if this is neither a trailing button, nor the buttons enabling pending requests)
        ButtonState(button_name, false);
        //--- re-draw the chart
        ChartRedraw();
    }
    //--- Not pressed
    else
    {
        //--- button 1
        if(button == "BUTT_1")
            ButtonState(button_name, false);
        //--- button 2
        if(button == "BUTT_2")
            ButtonState(button_name, false);
        //--- re-draw the chart
        ChartRedraw();
    }
}
//+------------------------------------------------------------------+
