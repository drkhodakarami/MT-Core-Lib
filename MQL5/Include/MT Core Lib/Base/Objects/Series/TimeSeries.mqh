//+------------------------------------------------------------------+
//|                                                   TimeSeries.mqh |
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
#include "Series.mqh"
#include "../Ticks/NewTickObj.mqh"
//+------------------------------------------------------------------+
//| Symbol timeseries class                                          |
//+------------------------------------------------------------------+
class CTimeSeries : public CBaseObj
{
  private:
    string          m_symbol;                // Timeseries symbol
    CNewTickObj     m_new_tick;              // "New tick" object
    CArrayObj       m_list_series;           // List of timeseries by timeframes
    datetime        m_server_firstdate;      // The very first date in history by a server symbol
    datetime        m_terminal_firstdate;    // The very first date in history by a symbol in the client terminal
    //--- Return (1) the timeframe index in the list and (2) the timeframe by the list index
    char            IndexTimeframe(const ENUM_TIMEFRAMES timeframe) const { return IndexEnumTimeframe(timeframe) - 1; }
    ENUM_TIMEFRAMES TimeframeByIndex(const uchar index) const { return TimeframeByEnumIndex(uchar(index + 1)); }
    //--- Set the very first date in history by symbol on the server and in the client terminal
    void            SetTerminalServerDate(void)
    {
        this.m_server_firstdate   = (datetime)::SeriesInfoInteger(this.m_symbol, ::Period(), SERIES_SERVER_FIRSTDATE);
        this.m_terminal_firstdate = (datetime)::SeriesInfoInteger(this.m_symbol, ::Period(), SERIES_TERMINAL_FIRSTDATE);
    }

  public:
    //--- Return (1) oneself, (2) the full list of timeseries, (3) specified timeseries object and (4) timeseries object by index
    CTimeSeries *GetObject(void) { return &this; }
    CArrayObj   *GetListSeries(void) { return &this.m_list_series; }
    CSeries     *GetSeries(const ENUM_TIMEFRAMES timeframe) { return this.m_list_series.At(this.IndexTimeframe(timeframe)); }
    CSeries     *GetSeriesByIndex(const uchar index) { return this.m_list_series.At(index); }
    //--- Set/return timeseries symbol
    void         SetSymbol(const string symbol) { this.m_symbol = (symbol == NULL || symbol == "" ? ::Symbol() : symbol); }
    string       Symbol(void) const { return this.m_symbol; }
    //--- Set the history depth (1) of a specified timeseries and (2) of all applied symbol timeseries
    bool         SetRequiredUsedData(const ENUM_TIMEFRAMES timeframe, const uint required = 0, const int rates_total = 0);
    bool         SetRequiredAllUsedData(const uint required = 0, const int rates_total = 0);
    //--- Return the flag of data synchronization with the server data of the (1) specified timeseries, (2) all timeseries
    bool         SyncData(const ENUM_TIMEFRAMES timeframe, const uint required = 0, const int rates_total = 0);
    bool         SyncAllData(const uint required = 0, const int rates_total = 0);
    //--- Return the very first date in history by symbol (1) on the server, (2) in the client terminal and (3) the new tick flag
    datetime     ServerFirstDate(void) const { return this.m_server_firstdate; }
    datetime     TerminalFirstDate(void) const { return this.m_terminal_firstdate; }
    bool         IsNewTick(void) { return this.m_new_tick.IsNewTick(); }
    //--- Create (1) the specified timeseries list and (2) all timeseries lists
    bool         Create(const ENUM_TIMEFRAMES timeframe, const uint required = 0);
    bool         CreateAll(const uint required = 0);
    //--- Update (1) the specified timeseries list and (2) all timeseries lists
    void         Refresh(const ENUM_TIMEFRAMES timeframe,
                         const datetime        time = 0,
                         const double open          = 0,
                         const double high          = 0,
                         const double low           = 0,
                         const double close         = 0,
                         const long tick_volume     = 0,
                         const long volume          = 0,
                         const int spread           = 0);
    void         RefreshAll(const datetime time    = 0,
                            const double open      = 0,
                            const double high      = 0,
                            const double low       = 0,
                            const double close     = 0,
                            const long tick_volume = 0,
                            const long volume      = 0,
                            const int spread       = 0);
    //--- Compare CTimeSeries objects (by symbol)
    virtual int  Compare(const CObject *node, const int mode = 0) const;
    //--- Display (1) description and (2) short symbol timeseries description in the journal
    void         Print(const bool created = true);
    void         PrintShort(const bool created = true);

    //--- Constructors
    CTimeSeries(void) { ; }
    CTimeSeries(const string symbol);
};
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CTimeSeries::CTimeSeries(const string symbol) :
    m_symbol(NULL)
{
    this.m_list_series.Clear();
    this.m_list_series.Sort();
    for(int i = 0; i < 21; i++)
    {
        ENUM_TIMEFRAMES timeframe  = this.TimeframeByIndex((uchar) i);
        CSeries        *series_obj = new CSeries(this.m_symbol, timeframe);
        this.m_list_series.Add(series_obj);
    }
    this.SetTerminalServerDate();
    this.m_new_tick.SetSymbol(this.m_symbol);
    this.m_new_tick.Refresh();
}
//+------------------------------------------------------------------+
//| Compare CTimeSeries objects                                      |
//+------------------------------------------------------------------+
int CTimeSeries::Compare(const CObject *node, const int mode = 0) const
{
    const CTimeSeries *compared_obj = node;
    return (this.Symbol() > compared_obj.Symbol() ? 1 : this.Symbol() < compared_obj.Symbol() ? -1
                                                                                              : 0);
}
//+------------------------------------------------------------------+
//| Set a history depth of a specified timeseries                    |
//+------------------------------------------------------------------+
bool CTimeSeries::SetRequiredUsedData(const ENUM_TIMEFRAMES timeframe, const uint required = 0, const int rates_total = 0)
{
    if(this.m_symbol == NULL)
    {
        ::Print(DFUN, CMessage::Text(MSG_LIB_TEXT_TS_TEXT_FIRST_SET_SYMBOL));
        return false;
    }
    CSeries *series_obj = this.m_list_series.At(this.IndexTimeframe(timeframe));
    return series_obj.SetRequiredUsedData(required, rates_total);
}
//+------------------------------------------------------------------+
//| Set the history depth of all applied symbol timeseries           |
//+------------------------------------------------------------------+
bool CTimeSeries::SetRequiredAllUsedData(const uint required = 0, const int rates_total = 0)
{
    if(this.m_symbol == NULL)
    {
        ::Print(DFUN, CMessage::Text(MSG_LIB_TEXT_TS_TEXT_FIRST_SET_SYMBOL));
        return false;
    }
    bool res = true;
    for(int i = 0; i < 21; i++)
    {
        CSeries *series_obj = this.m_list_series.At(i);
        if(series_obj == NULL)
            continue;
        res &= series_obj.SetRequiredUsedData(required, rates_total);
    }
    return res;
}
//+------------------------------------------------------------------+
//| Return the flag of data synchronization                          |
//| with the server data                                             |
//+------------------------------------------------------------------+
bool CTimeSeries::SyncData(const ENUM_TIMEFRAMES timeframe, const uint required = 0, const int rates_total = 0)
{
    if(this.m_symbol == NULL)
    {
        ::Print(DFUN, CMessage::Text(MSG_LIB_TEXT_TS_TEXT_FIRST_SET_SYMBOL));
        return false;
    }
    CSeries *series_obj = this.m_list_series.At(this.IndexTimeframe(timeframe));
    if(series_obj == NULL)
    {
        ::Print(DFUN, CMessage::Text(MSG_LIB_TEXT_TS_FAILED_GET_SERIES_OBJ), this.m_symbol, " ", TimeframeDescription(timeframe));
        return false;
    }
    if(!series_obj.IsAvailable())
        return false;
    return series_obj.SyncData(required, rates_total);
}
//+------------------------------------------------------------------+
//| Return the flag of data synchronization                          |
//| of all timeseries with the server data                           |
//+------------------------------------------------------------------+
bool CTimeSeries::SyncAllData(const uint required = 0, const int rates_total = 0)
{
    if(this.m_symbol == NULL)
    {
        ::Print(DFUN, CMessage::Text(MSG_LIB_TEXT_TS_TEXT_FIRST_SET_SYMBOL));
        return false;
    }
    bool res = true;
    for(int i = 0; i < 21; i++)
    {
        CSeries *series_obj = this.m_list_series.At(i);
        if(series_obj == NULL || !series_obj.IsAvailable())
            continue;
        res &= series_obj.SyncData(required, rates_total);
    }
    return res;
}
//+------------------------------------------------------------------+
//| Create a specified timeseries list                               |
//+------------------------------------------------------------------+
bool CTimeSeries::Create(const ENUM_TIMEFRAMES timeframe, const uint required = 0)
{
    CSeries *series_obj = this.m_list_series.At(this.IndexTimeframe(timeframe));
    if(series_obj == NULL)
    {
        ::Print(DFUN, CMessage::Text(MSG_LIB_TEXT_TS_FAILED_GET_SERIES_OBJ), this.m_symbol, " ", TimeframeDescription(timeframe));
        return false;
    }
    if(series_obj.RequiredUsedData() == 0)
    {
        ::Print(DFUN, CMessage::Text(MSG_LIB_TEXT_BAR_TEXT_FIRS_SET_AMOUNT_DATA));
        return false;
    }
    series_obj.SetAvailable(true);
    return (series_obj.Create(required) > 0);
}
//+------------------------------------------------------------------+
//| Create all timeseries lists                                      |
//+------------------------------------------------------------------+
bool CTimeSeries::CreateAll(const uint required = 0)
{
    bool res = true;
    for(int i = 0; i < 21; i++)
    {
        CSeries *series_obj = this.m_list_series.At(i);
        if(series_obj == NULL || series_obj.RequiredUsedData() == 0)
            continue;
        series_obj.SetAvailable(true);
        res &= (series_obj.Create(required) > 0);
    }
    return res;
}
//+------------------------------------------------------------------+
//| Update a specified timeseries list                               |
//+------------------------------------------------------------------+
void CTimeSeries::Refresh(const ENUM_TIMEFRAMES timeframe,
                          const datetime        time = 0,
                          const double open          = 0,
                          const double high          = 0,
                          const double low           = 0,
                          const double close         = 0,
                          const long tick_volume     = 0,
                          const long volume          = 0,
                          const int spread           = 0)
{
    CSeries *series_obj = this.m_list_series.At(this.IndexTimeframe(timeframe));
    if(series_obj == NULL || series_obj.DataTotal() == 0)
        return;
    series_obj.Refresh(time, open, high, low, close, tick_volume, volume, spread);
    if(series_obj.IsNewBar(time))
    {
        series_obj.SendEvent();
        this.SetTerminalServerDate();
    }
}
//+------------------------------------------------------------------+
//| Update all timeseries lists                                      |
//+------------------------------------------------------------------+
void CTimeSeries::RefreshAll(const datetime time    = 0,
                             const double open      = 0,
                             const double high      = 0,
                             const double low       = 0,
                             const double close     = 0,
                             const long tick_volume = 0,
                             const long volume      = 0,
                             const int spread       = 0)
{
    bool upd = false;
    for(int i = 0; i < 21; i++)
    {
        CSeries *series_obj = this.m_list_series.At(i);
        if(series_obj == NULL || series_obj.DataTotal() == 0)
            continue;
        series_obj.Refresh(time, open, high, low, close, tick_volume, volume, spread);
        if(series_obj.IsNewBar(time))
        {
            series_obj.SendEvent();
            upd &= true;
        }
    }
    if(upd)
        this.SetTerminalServerDate();
}
//+------------------------------------------------------------------+
//| Display descriptions of all symbol timeseries in the journal     |
//+------------------------------------------------------------------+
void CTimeSeries::Print(const bool created = true)
{
    ::Print(CMessage::Text(MSG_LIB_TEXT_TS_TEXT_SYMBOL_TIMESERIES), " ", this.m_symbol, ": ");
    for(int i = 0; i < this.m_list_series.Total(); i++)
    {
        CSeries *series = this.m_list_series.At(i);
        if(series == NULL || (created && series.DataTotal() == 0))
            continue;
        series.Print();
    }
}
//+-------------------------------------------------------------------+
//| Display short descriptions of all symbol timeseries in the journal|
//+-------------------------------------------------------------------+
void CTimeSeries::PrintShort(const bool created = true)
{
    ::Print(CMessage::Text(MSG_LIB_TEXT_TS_TEXT_SYMBOL_TIMESERIES), " ", this.m_symbol, ": ");
    for(int i = 0; i < this.m_list_series.Total(); i++)
    {
        CSeries *series = this.m_list_series.At(i);
        if(series == NULL || (created && series.DataTotal() == 0))
            continue;
        series.PrintShort();
    }
}
//+------------------------------------------------------------------+
