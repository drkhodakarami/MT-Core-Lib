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
//+------------------------------------------------------------------+
//| Timeseries class                                                 |
//+------------------------------------------------------------------+
class CTimeSeries : public CObject
{
  private:
    string          m_symbol;         // Timeseries symbol
    CArrayObj       m_list_series;    // List of timeseries by timeframes
                                      //--- Return (1) the timeframe index in the list and (2) the timeframe by index
    char            IndexTimeframe(const ENUM_TIMEFRAMES timeframe) const;
    ENUM_TIMEFRAMES TimeframeByIndex(const uchar index) const;

  public:
    //--- Return (1) the full list of timeseries, (2) specified timeseries object and (3) timeseries object by index
    CArrayObj *GetList(void) { return &this.m_list_series; }
    CSeries   *GetSeries(const ENUM_TIMEFRAMES timeframe) { return this.m_list_series.At(this.IndexTimeframe(timeframe)); }
    CSeries   *GetSeriesByIndex(const uchar index) { return this.m_list_series.At(index); }
    //--- Set/return timeseries symbol
    void       SetSymbol(const string symbol) { this.m_symbol = (symbol == NULL || symbol == "" ? ::Symbol() : symbol); }
    string     Symbol(void) const { return this.m_symbol; }
    //--- Set the history depth (1) of a specified timeseries and (2) of all applied symbol timeseries
    bool       SetAmountUsedData(const ENUM_TIMEFRAMES timeframe, const uint amount = 0, const int rates_total = 0);
    bool       SetAmountAllUsedData(const uint amount = 0, const int rates_total = 0);
    //--- Return the flag of data synchronization with the server data of the (1) specified timeseries, (2) all timeseries
    bool       SyncData(const ENUM_TIMEFRAMES timeframe, const uint amount = 0, const uint rates_total = 0);
    bool       SyncAllData(const uint amount = 0, const uint rates_total = 0);

    //--- Create (1) the specified timeseries list and (2) all timeseries lists
    bool       Create(const ENUM_TIMEFRAMES timeframe, const uint amount = 0);
    bool       CreateAll(const uint amount = 0);
    //--- Update (1) the specified timeseries list and (2) all timeseries lists
    void       Refresh(const ENUM_TIMEFRAMES timeframe,
                       const datetime        time = 0,
                       const double open          = 0,
                       const double high          = 0,
                       const double low           = 0,
                       const double close         = 0,
                       const long tick_volume     = 0,
                       const long volume          = 0,
                       const int spread           = 0);
    void       RefreshAll(const datetime time    = 0,
                          const double open      = 0,
                          const double high      = 0,
                          const double low       = 0,
                          const double close     = 0,
                          const long tick_volume = 0,
                          const long volume      = 0,
                          const int spread       = 0);
    //--- Constructor
    CTimeSeries(void);
};
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CTimeSeries::CTimeSeries() :
    m_symbol(NULL)
{
    this.m_list_series.Clear();
    this.m_list_series.Sort();
    for(int i = 0; i < 21; i++)
    {
        CSeries *series_obj = new CSeries();
        series_obj.SetSymbolPeriod(this.m_symbol, this.TimeframeByIndex((uchar) i));
        this.m_list_series.Add(series_obj);
    }
}
//+------------------------------------------------------------------+
//| Set a history depth of a specified timeseries                    |
//+------------------------------------------------------------------+
bool CTimeSeries::SetAmountUsedData(const ENUM_TIMEFRAMES timeframe, const uint amount = 0, const int rates_total = 0)
{
    if(this.m_symbol == NULL)
    {
        ::Print(DFUN, CMessage::Text(MSG_LIB_TEXT_TS_TEXT_FIRS_SET_SYMBOL));
        return false;
    }
    CSeries *series_obj = this.m_list_series.At(this.IndexTimeframe(timeframe));
    return series_obj.SetAmountUsedData(amount, rates_total);
}
//+------------------------------------------------------------------+
//| Set the history depth of all applied symbol timeseries           |
//+------------------------------------------------------------------+
bool CTimeSeries::SetAmountAllUsedData(const uint amount = 0, const int rates_total = 0)
{
    if(this.m_symbol == NULL)
    {
        ::Print(DFUN, CMessage::Text(MSG_LIB_TEXT_TS_TEXT_FIRS_SET_SYMBOL));
        return false;
    }
    bool res = true;
    for(int i = 0; i < 21; i++)
    {
        CSeries *series_obj = this.m_list_series.At(i);
        if(series_obj == NULL)
            continue;
        res &= series_obj.SetAmountUsedData(amount, rates_total);
    }
    return res;
}
//+------------------------------------------------------------------+
//| Return the flag of data synchronization                          |
//| with the server data                                             |
//+------------------------------------------------------------------+
bool CTimeSeries::SyncData(const ENUM_TIMEFRAMES timeframe, const uint amount = 0, const uint rates_total = 0)
{
    if(this.m_symbol == NULL)
    {
        ::Print(DFUN, CMessage::Text(MSG_LIB_TEXT_TS_TEXT_FIRS_SET_SYMBOL));
        return false;
    }
    CSeries *series_obj = this.m_list_series.At(this.IndexTimeframe(timeframe));
    if(series_obj == NULL)
    {
        ::Print(DFUN, CMessage::Text(MSG_LIB_TEXT_TS_FAILED_GET_SERIES_OBJ), this.m_symbol, " ", TimeframeDescription(timeframe));
        return false;
    }
    return series_obj.SyncData(amount, rates_total);
}
//+------------------------------------------------------------------+
//| Return the flag of data synchronization                          |
//| of all timeseries with the server data                           |
//+------------------------------------------------------------------+
bool CTimeSeries::SyncAllData(const uint amount = 0, const uint rates_total = 0)
{
    if(this.m_symbol == NULL)
    {
        ::Print(DFUN, CMessage::Text(MSG_LIB_TEXT_TS_TEXT_FIRS_SET_SYMBOL));
        return false;
    }
    bool res = true;
    for(int i = 0; i < 21; i++)
    {
        CSeries *series_obj = this.m_list_series.At(i);
        if(series_obj == NULL)
            continue;
        res &= series_obj.SyncData(amount, rates_total);
    }
    return res;
}
//+------------------------------------------------------------------+
//| Create a specified timeseries list                               |
//+------------------------------------------------------------------+
bool CTimeSeries::Create(const ENUM_TIMEFRAMES timeframe, const uint amount = 0)
{
    CSeries *series_obj = this.m_list_series.At(this.IndexTimeframe(timeframe));
    if(series_obj == NULL)
    {
        ::Print(DFUN, CMessage::Text(MSG_LIB_TEXT_TS_FAILED_GET_SERIES_OBJ), this.m_symbol, " ", TimeframeDescription(timeframe));
        return false;
    }
    if(series_obj.AmountUsedData() == 0)
    {
        ::Print(DFUN, CMessage::Text(MSG_LIB_TEXT_BAR_TEXT_FIRS_SET_AMOUNT_DATA));
        return false;
    }
    return (series_obj.Create(amount) > 0);
}
//+------------------------------------------------------------------+
//| Create all timeseries lists                                      |
//+------------------------------------------------------------------+
bool CTimeSeries::CreateAll(const uint amount = 0)
{
    bool res = true;
    for(int i = 0; i < 21; i++)
    {
        CSeries *series_obj = this.m_list_series.At(i);
        if(series_obj == NULL || series_obj.AmountUsedData() == 0)
            continue;
        res &= (series_obj.Create(amount) > 0);
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
    for(int i = 0; i < 21; i++)
    {
        CSeries *series_obj = this.m_list_series.At(i);
        if(series_obj == NULL || series_obj.DataTotal() == 0)
            continue;
        series_obj.Refresh(time, open, high, low, close, tick_volume, volume, spread);
    }
}
//+------------------------------------------------------------------+
//| Return the timeframe index in the list                           |
//+------------------------------------------------------------------+
char CTimeSeries::IndexTimeframe(ENUM_TIMEFRAMES timeframe) const
{
    int statement = (timeframe == PERIOD_CURRENT ? ::Period() : timeframe);
    switch(statement)
    {
        case PERIOD_M1  : return 0;
        case PERIOD_M2  : return 1;
        case PERIOD_M3  : return 2;
        case PERIOD_M4  : return 3;
        case PERIOD_M5  : return 4;
        case PERIOD_M6  : return 5;
        case PERIOD_M10 : return 6;
        case PERIOD_M12 : return 7;
        case PERIOD_M15 : return 8;
        case PERIOD_M20 : return 9;
        case PERIOD_M30 : return 10;
        case PERIOD_H1  : return 11;
        case PERIOD_H2  : return 12;
        case PERIOD_H3  : return 13;
        case PERIOD_H4  : return 14;
        case PERIOD_H6  : return 15;
        case PERIOD_H8  : return 16;
        case PERIOD_H12 : return 17;
        case PERIOD_D1  : return 18;
        case PERIOD_W1  : return 19;
        case PERIOD_MN1 : return 20;
        default         : ::Print(DFUN, CMessage::Text(MSG_LIB_TEXT_TS_TEXT_UNKNOWN_TIMEFRAME)); return WRONG_VALUE;
    }
}
//+------------------------------------------------------------------+
//| Return a timeframe by index                                      |
//+------------------------------------------------------------------+
ENUM_TIMEFRAMES CTimeSeries::TimeframeByIndex(const uchar index) const
{
    switch(index)
    {
        case 0  : return PERIOD_M1;
        case 1  : return PERIOD_M2;
        case 2  : return PERIOD_M3;
        case 3  : return PERIOD_M4;
        case 4  : return PERIOD_M5;
        case 5  : return PERIOD_M6;
        case 6  : return PERIOD_M10;
        case 7  : return PERIOD_M12;
        case 8  : return PERIOD_M15;
        case 9  : return PERIOD_M20;
        case 10 : return PERIOD_M30;
        case 11 : return PERIOD_H1;
        case 12 : return PERIOD_H2;
        case 13 : return PERIOD_H3;
        case 14 : return PERIOD_H4;
        case 15 : return PERIOD_H6;
        case 16 : return PERIOD_H8;
        case 17 : return PERIOD_H12;
        case 18 : return PERIOD_D1;
        case 19 : return PERIOD_W1;
        case 20 : return PERIOD_MN1;
        default : ::Print(DFUN, CMessage::Text(MSG_LIB_SYS_NOT_GET_DATAS), "... ", CMessage::Text(MSG_SYM_STATUS_INDEX), ": ", (string) index); return WRONG_VALUE;
    }
}
//+------------------------------------------------------------------+
