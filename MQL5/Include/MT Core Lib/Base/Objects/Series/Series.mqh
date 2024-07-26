//+------------------------------------------------------------------+
//|                                                       Series.mqh |
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
#include "../../Services/Select.mqh"
#include "NewBarObj.mqh"
#include "Bar.mqh"
//+------------------------------------------------------------------+
//| Timeseries class                                                 |
//+------------------------------------------------------------------+
class CSeries : public CObject
{
  private:
    ENUM_PROGRAM_TYPE m_program;        // Program type
    ENUM_TIMEFRAMES   m_timeframe;      // Timeframe
    string            m_symbol;         // Symbol
    uint              m_amount;         // Amount of applied timeseries data
    uint              m_bars;           // Number of bars in history by symbol and timeframe
    bool              m_sync;           // Synchronized data flag
    CArrayObj         m_list_series;    // Timeseries list
    CNewBarObj        m_new_bar_obj;    // "New bar" object

  public:
    //--- Return the timeseries list
    CArrayObj      *GetList(void) { return &m_list_series; }
    //--- Return the list of bars by selected (1) double, (2) integer and (3) string property fitting a compared condition
    CArrayObj      *GetList(ENUM_BAR_PROP_DOUBLE property, double value, ENUM_COMPARER_TYPE mode = EQUAL) { return CSelect::ByBarProperty(this.GetList(), property, value, mode); }
    CArrayObj      *GetList(ENUM_BAR_PROP_INTEGER property, long value, ENUM_COMPARER_TYPE mode = EQUAL) { return CSelect::ByBarProperty(this.GetList(), property, value, mode); }
    CArrayObj      *GetList(ENUM_BAR_PROP_STRING property, string value, ENUM_COMPARER_TYPE mode = EQUAL) { return CSelect::ByBarProperty(this.GetList(), property, value, mode); }

    //--- Set (1) symbol and timeframe and (2) the number of applied timeseries data
    void            SetSymbolPeriod(const string symbol, const ENUM_TIMEFRAMES timeframe);
    bool            SetAmountUsedData(const uint amount, const uint rates_total);

    //--- Return (1) symbol, (2) timeframe, (3) number of applied timeseries data,
    //--- (4) number of bars in the timeseries, the new bar flag with the (5) auto, (6) manual time management
    string          Symbol(void) const { return this.m_symbol; }
    ENUM_TIMEFRAMES Period(void) const { return this.m_timeframe; }
    uint            AmountUsedData(void) const { return this.m_amount; }
    uint            Bars(void) const { return this.m_bars; }
    bool            IsNewBar(const datetime time) { return this.m_new_bar_obj.IsNewBar(time); }
    bool            IsNewBarManual(const datetime time) { return this.m_new_bar_obj.IsNewBarManual(time); }
    //--- Return the bar object by index (1) in the list and (2) in the timeseries
    CBar           *GetBarByListIndex(const uint index);
    CBar           *GetBarBySeriesIndex(const uint index);
    //--- Return (1) Open, (2) High, (3) Low, (4) Close, (5) time, (6) tick volume, (7) real volume, (8) bar spread by index
    double          Open(const uint index, const bool from_series = true);
    double          High(const uint index, const bool from_series = true);
    double          Low(const uint index, const bool from_series = true);
    double          Close(const uint index, const bool from_series = true);
    datetime        Time(const uint index, const bool from_series = true);
    long            TickVolume(const uint index, const bool from_series = true);
    long            RealVolume(const uint index, const bool from_series = true);
    int             Spread(const uint index, const bool from_series = true);

    //--- Save the new bar time during the manual time management
    void            SaveNewBarTime(const datetime time) { this.m_new_bar_obj.SaveNewBarTime(time); }
    //--- Synchronize symbol and timeframe data with server data
    bool            SyncData(const uint amount, const uint rates_total);
    //--- (1) Create and (2) update the timeseries list
    int             Create(const uint amount = 0);
    void            Refresh(const datetime time    = 0,
                            const double open      = 0,
                            const double high      = 0,
                            const double low       = 0,
                            const double close     = 0,
                            const long tick_volume = 0,
                            const long volume      = 0,
                            const int spread       = 0);

    //--- Constructors
    CSeries(void);
    CSeries(const string symbol, const ENUM_TIMEFRAMES timeframe, const uint amount = 0);
};
//+------------------------------------------------------------------+
//| Constructor 1 (current symbol and period timeseries)             |
//+------------------------------------------------------------------+
CSeries::CSeries(void) :
    m_bars(0), m_amount(0), m_sync(false)
{
    this.m_program = (ENUM_PROGRAM_TYPE)::MQLInfoInteger(MQL_PROGRAM_TYPE);
    this.m_list_series.Clear();
    this.m_list_series.Sort(SORT_BY_BAR_INDEX);
    this.SetSymbolPeriod(::Symbol(), (ENUM_TIMEFRAMES)::Period());
}
//+------------------------------------------------------------------+
//| Constructor 2 (specified symbol and period timeseries)           |
//+------------------------------------------------------------------+
CSeries::CSeries(const string symbol, const ENUM_TIMEFRAMES timeframe, const uint amount = 0) :
    m_bars(0), m_amount(0), m_sync(false)
{
    this.m_program = (ENUM_PROGRAM_TYPE)::MQLInfoInteger(MQL_PROGRAM_TYPE);
    this.m_list_series.Clear();
    this.m_list_series.Sort(SORT_BY_BAR_INDEX);
    this.SetSymbolPeriod(symbol, timeframe);
    this.m_sync = this.SetAmountUsedData(amount, 0);
}
//+------------------------------------------------------------------+
//| Set a symbol and timeframe                                       |
//+------------------------------------------------------------------+
void CSeries::SetSymbolPeriod(const string symbol, const ENUM_TIMEFRAMES timeframe)
{
    this.m_symbol    = (symbol == NULL || symbol == "" ? ::Symbol() : symbol);
    this.m_timeframe = (timeframe == PERIOD_CURRENT ? (ENUM_TIMEFRAMES)::Period() : timeframe);
    this.m_new_bar_obj.SetSymbol(this.m_symbol);
    this.m_new_bar_obj.SetPeriod(this.m_timeframe);
}
//+------------------------------------------------------------------+
//| Set the number of required data                                  |
//+------------------------------------------------------------------+
bool CSeries::SetAmountUsedData(const uint amount, const uint rates_total)
{
    //--- Set the number of available timeseries bars
    this.m_bars =
        (
            //--- If this is an indicator and the work is performed on the current symbol and timeframe,
            //--- add the rates_total value passed to the method,
            //--- otherwise, get the number from the environment
            this.m_program == PROGRAM_INDICATOR &&
                    this.m_symbol == ::Symbol() && this.m_timeframe == ::Period()
                ? rates_total
                : ::Bars(this.m_symbol, this.m_timeframe));
    //--- If managed to set the number of available history, set the amount of data in the list:
    if(this.m_bars > 0)
    {
        //--- if zero 'amount' value is passed,
        //--- use either the default value (1000 bars) or the number of available history bars - the least one of them
        //--- if non-zero 'amount' value is passed,
        //--- use either the 'amount' value or the number of available history bars - the least one of them
        this.m_amount = (amount == 0 ? ::fmin(SERIES_DEFAULT_BARS_COUNT, this.m_bars) : ::fmin(amount, this.m_bars));
        return true;
    }
    return false;
}
//+------------------------------------------------------------------+
//|Synchronize symbol and timeframe data with server data            |
//+------------------------------------------------------------------+
bool CSeries::SyncData(const uint amount, const uint rates_total)
{
    //--- If managed to obtain the available number of bars in the timeseries
    //--- and return the size of the bar object list, return 'true'
    this.m_sync = this.SetAmountUsedData(amount, rates_total);
    if(this.m_sync)
        return true;

    //--- Data is not yet synchronized with the server
    //--- Create a pause object
    CPause *pause = new CPause();
    if(pause == NULL)
    {
        ::Print(DFUN_ERR_LINE, CMessage::Text(MSG_LIB_SYS_FAILED_CREATE_PAUSE_OBJ));
        return false;
    }
    //--- Set the pause duration of 16 milliseconds (PAUSE_FOR_SYNC_ATTEMPTS) and initialize the tick counter
    pause.SetWaitingMSC(PAUSE_FOR_SYNC_ATTEMPTS);
    pause.SetTimeBegin(0);
    //--- Make five (ATTEMPTS_FOR_SYNC) attempts to obtain the available number of bars in the timeseries
    //--- and set the bar object list size
    int attempts = 0;
    while(attempts < ATTEMPTS_FOR_SYNC && !::IsStopped())
    {
        //--- If data is currently synchronized with the server
        if(::SeriesInfoInteger(this.m_symbol, this.m_timeframe, SERIES_SYNCHRONIZED))
        {
            //--- if managed to obtain the available number of bars in the timeseries
            //--- and set the size of the bar object list, break the loop
            this.m_sync = this.SetAmountUsedData(amount, rates_total);
            if(this.m_sync)
                break;
        }
        //--- Data is not yet synchronized.
        //--- If the pause of 16 ms is over
        if(pause.IsCompleted())
        {
            //--- set the new start of the next waiting for the pause object
            //--- and increase the attempt counter
            pause.SetTimeBegin(0);
            attempts++;
        }
    }
    //--- Remove the pause object and return the m_sync value
    delete pause;
    return this.m_sync;
}
//+------------------------------------------------------------------+
//| Create the timeseries list                                       |
//+------------------------------------------------------------------+
int CSeries::Create(const uint amount = 0)
{
    //--- If the required history depth is not set for the list yet,
    //--- display the appropriate message and return zero,
    if(this.m_amount == 0)
    {
        ::Print(DFUN, CMessage::Text(MSG_LIB_TEXT_BAR_TEXT_FIRS_SET_AMOUNT_DATA));
        return 0;
    }
    //--- otherwise, if the passed 'amount' value exceeds zero and is not equal to the one already set,
    //--- while being lower than the available bar number,
    //--- set the new value of the required history depth for the list
    else if(amount > 0 && this.m_amount != amount && amount < this.m_bars)
    {
        //--- If failed to set a new value, return zero
        if(!this.SetAmountUsedData(amount, 0))
            return 0;
    }
    //--- For the rates[] array we are to receive historical data to,
    //--- set the flag of direction like in the timeseries,
    //--- clear the bar object list and set the flag of sorting by bar index
    MqlRates rates[];
    ::ArraySetAsSeries(rates, true);
    this.m_list_series.Clear();
    this.m_list_series.Sort(SORT_BY_BAR_INDEX);
    ::ResetLastError();
    //--- Get historical data of the MqlRates structure to the rates[] array starting from the current bar in the amount of m_amount,
    //--- if failed to get data, display the appropriate message and return zero
    int copied = ::CopyRates(this.m_symbol, this.m_timeframe, 0, this.m_amount, rates), err = ERR_SUCCESS;
    if(copied < 1)
    {
        err = ::GetLastError();
        ::Print(DFUN, CMessage::Text(MSG_LIB_TEXT_BAR_FAILED_GET_SERIES_DATA), " ", this.m_symbol, " ", TimeframeDescription(this.m_timeframe), ". ",
                CMessage::Text(MSG_LIB_SYS_ERROR), ": ", CMessage::Text(err), CMessage::Retcode(err));
        return 0;
    }

    //--- Historical data is received in the rates[] array
    //--- In the rates[] array loop,
    for(int i = 0; i < copied; i++)
    {
        //--- create a new bar object out of the current MqlRates structure by the loop index
        ::ResetLastError();
        CBar *bar = new CBar(this.m_symbol, this.m_timeframe, i, rates[i]);
        if(bar == NULL)
        {
            ::Print(DFUN, CMessage::Text(MSG_LIB_SYS_FAILED_CREATE_BAR_OBJ), ". ", CMessage::Text(MSG_LIB_SYS_ERROR), ": ", CMessage::Text(::GetLastError()));
            continue;
        }
        //--- If failed to add bar object to the list,
        //--- display the appropriate message with the error description in the journal
        if(!this.m_list_series.Add(bar))
        {
            err = ::GetLastError();
            ::Print(DFUN, CMessage::Text(MSG_LIB_TEXT_BAR_FAILED_ADD_TO_LIST), " ", bar.Header(), ". ",
                    CMessage::Text(MSG_LIB_SYS_ERROR), ": ", CMessage::Text(err), CMessage::Retcode(err));
        }
    }
    //--- Return the size of the created bar object list
    return this.m_list_series.Total();
}
//+------------------------------------------------------------------+
//| Update timeseries list and data                                  |
//+------------------------------------------------------------------+
void CSeries::Refresh(const datetime time    = 0,
                      const double open      = 0,
                      const double high      = 0,
                      const double low       = 0,
                      const double close     = 0,
                      const long tick_volume = 0,
                      const long volume      = 0,
                      const int spread       = 0)
{
    MqlRates rates[1];
    //--- Set the flag of sorting the list of bars by index
    this.m_list_series.Sort(SORT_BY_BAR_INDEX);
    //--- If a new bar is present on a symbol and period,
    if(this.IsNewBarManual(time))
    {
        //--- create a new bar object and add it to the end of the list
        CBar *new_bar = new CBar(this.m_symbol, this.m_timeframe, 0);
        if(new_bar == NULL)
            return;
        if(!this.m_list_series.Add(new_bar))
        {
            delete new_bar;
            return;
        }
        //--- if the specified timeseries size exceeds one bar, remove the earliest bar
        if(this.m_list_series.Total() > 1)
            this.m_list_series.Delete(0);
        //--- save the new bar time as the previous one for the subsequent new bar check
        this.SaveNewBarTime(time);
    }
    //--- Get the index of the last bar in the list and the object bar by the index
    int   index  = this.m_list_series.Total() - 1;
    CBar *bar    = this.m_list_series.At(index);
    //--- if the work is performed in an indicator and the timeseries belongs to the current symbol and timeframe,
    //--- copy price parameters (passed to the method from the outside) to the bar price structure
    int   copied = 1;
    if(this.m_program == PROGRAM_INDICATOR && this.m_symbol == ::Symbol() && this.m_timeframe == ::Period())
    {
        rates[0].time        = time;
        rates[0].open        = open;
        rates[0].high        = high;
        rates[0].low         = low;
        rates[0].close       = close;
        rates[0].tick_volume = tick_volume;
        rates[0].real_volume = volume;
        rates[0].spread      = spread;
    }
    //--- otherwise, get data to the bar price structure from the environment
    else
        copied = ::CopyRates(this.m_symbol, this.m_timeframe, 0, 1, rates);
    //--- If the prices are obtained, set the new properties from the price structure for the bar object
    if(copied == 1)
        bar.SetProperties(rates[0]);
}
//+------------------------------------------------------------------+
//|  Return the bar object by index in the list                      |
//+------------------------------------------------------------------+
CBar *CSeries::GetBarByListIndex(const uint index)
{
    return this.m_list_series.At(this.m_list_series.Total() - index - 1);
}
//+------------------------------------------------------------------+
//| Return the bar object by index in the timeseries                 |
//+------------------------------------------------------------------+
CBar *CSeries::GetBarBySeriesIndex(const uint index)
{
    CArrayObj *list = this.GetList(BAR_PROP_INDEX, index);
    return (list == NULL || list.Total() == 0 ? NULL : list.At(0));
}
//+------------------------------------------------------------------+
//| Return bar's Open by the index                                   |
//+------------------------------------------------------------------+
double CSeries::Open(const uint index, const bool from_series = true)
{
    CBar *bar = (from_series ? this.GetBarBySeriesIndex(index) : this.GetBarByListIndex(index));
    return (bar != NULL ? bar.Open() : WRONG_VALUE);
}
//+------------------------------------------------------------------+
//| Return bar's High by the timeseries index or the list of bars    |
//+------------------------------------------------------------------+
double CSeries::High(const uint index, const bool from_series = true)
{
    CBar *bar = (from_series ? this.GetBarBySeriesIndex(index) : this.GetBarByListIndex(index));
    return (bar != NULL ? bar.High() : WRONG_VALUE);
}
//+------------------------------------------------------------------+
//| Return bar's Low by the timeseries index or the list of bars     |
//+------------------------------------------------------------------+
double CSeries::Low(const uint index, const bool from_series = true)
{
    CBar *bar = (from_series ? this.GetBarBySeriesIndex(index) : this.GetBarByListIndex(index));
    return (bar != NULL ? bar.Low() : WRONG_VALUE);
}
//+------------------------------------------------------------------+
//| Return bar's Close by the timeseries index or the list of bars   |
//+------------------------------------------------------------------+
double CSeries::Close(const uint index, const bool from_series = true)
{
    CBar *bar = (from_series ? this.GetBarBySeriesIndex(index) : this.GetBarByListIndex(index));
    return (bar != NULL ? bar.Close() : WRONG_VALUE);
}
//+------------------------------------------------------------------+
//| Return bar time by the timeseries index or the list of bars      |
//+------------------------------------------------------------------+
datetime CSeries::Time(const uint index, const bool from_series = true)
{
    CBar *bar = (from_series ? this.GetBarBySeriesIndex(index) : this.GetBarByListIndex(index));
    return (bar != NULL ? bar.Time() : 0);
}
//+-------------------------------------------------------------------+
//|Return bar tick volume by the timeseries index or the list of bars |
//+-------------------------------------------------------------------+
long CSeries::TickVolume(const uint index, const bool from_series = true)
{
    CBar *bar = (from_series ? this.GetBarBySeriesIndex(index) : this.GetBarByListIndex(index));
    return (bar != NULL ? bar.VolumeTick() : WRONG_VALUE);
}
//+--------------------------------------------------------------------+
//|Return bar real volume by the timeseries index or the list of bars  |
//+--------------------------------------------------------------------+
long CSeries::RealVolume(const uint index, const bool from_series = true)
{
    CBar *bar = (from_series ? this.GetBarBySeriesIndex(index) : this.GetBarByListIndex(index));
    return (bar != NULL ? bar.VolumeReal() : WRONG_VALUE);
}
//+------------------------------------------------------------------+
//| Return bar spread by the timeseries index or the list of bars    |
//+------------------------------------------------------------------+
int CSeries::Spread(const uint index, const bool from_series = true)
{
    CBar *bar = (from_series ? this.GetBarBySeriesIndex(index) : this.GetBarByListIndex(index));
    return (bar != NULL ? bar.Spread() : WRONG_VALUE);
}
//+------------------------------------------------------------------+
