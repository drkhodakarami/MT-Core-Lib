//+------------------------------------------------------------------+
//|                                         TimeSeriesCollection.mqh |
//|                                              Alireza Khodakarami |
//|                         https://www.youtube.com/@YourTradeMaster |
//+------------------------------------------------------------------+
#property copyright "Alireza Khodakarami"
#property link "https://www.youtube.com/@YourTradeMaster"
#property version "1.00"
//+------------------------------------------------------------------+
//| Include files                                                    |
//+------------------------------------------------------------------+
#include "..\Objects\Series\TimeSeries.mqh"
#include "..\Objects\Symbols\Symbol.mqh"
//+------------------------------------------------------------------+
//| Symbol timeseries collection                                     |
//+------------------------------------------------------------------+
class CTimeSeriesCollection : public CObject
{
  private:
    CArrayObj m_list;    // List of applied symbol timeseries
                         //--- Return the timeseries index by symbol name
    int       IndexTimeSeries(const string symbol);

  public:
    //--- Return (1) oneself and (2) the timeseries list
    CTimeSeriesCollection *GetObject(void) { return &this; }
    CArrayObj             *GetList(void) { return &this.m_list; }

    //--- Create the symbol timeseries list collection
    bool                   CreateCollection(const CArrayObj *list_symbols);
    //--- Set the flag of using (1) the specified timeseries of the specified symbol, (2) the specified timeseries of all symbols
    //--- (3) all timeseries of the specified symbol and (4) all timeseries of all symbols
    void                   SetAvailable(const string symbol, const ENUM_TIMEFRAMES timeframe, const bool flag = true);
    void                   SetAvailable(const ENUM_TIMEFRAMES timeframe, const bool flag = true);
    void                   SetAvailable(const string symbol, const bool flag = true);
    void                   SetAvailable(const bool flag = true);
    //--- Get the flag of using (1) the specified timeseries of the specified symbol, (2) the specified timeseries of all symbols
    //--- (3) all timeseries of the specified symbol and (4) all timeseries of all symbols
    bool                   IsAvailable(const string symbol, const ENUM_TIMEFRAMES timeframe);
    bool                   IsAvailable(const ENUM_TIMEFRAMES timeframe);
    bool                   IsAvailable(const string symbol);
    bool                   IsAvailable(void);

    //--- Set the history depth of (1) the specified timeseries of the specified symbol, (2) the specified timeseries of all symbols
    //--- (3) all timeseries of the specified symbol and (4) all timeseries of all symbols
    bool                   SetRequiredUsedData(const string symbol, const ENUM_TIMEFRAMES timeframe, const uint required = 0, const int rates_total = 0);
    bool                   SetRequiredUsedData(const ENUM_TIMEFRAMES timeframe, const uint required = 0, const int rates_total = 0);
    bool                   SetRequiredUsedData(const string symbol, const uint required = 0, const int rates_total = 0);
    bool                   SetRequiredUsedData(const uint required = 0, const int rates_total = 0);
    //--- Return the flag of data synchronization with the server data of the (1) specified timeseries of the specified symbol,
    //--- (2) the specified timeseries of all symbols, (3) all timeseries of the specified symbol and (4) all timeseries of all symbols
    bool                   SyncData(const string symbol, const ENUM_TIMEFRAMES timeframe, const uint required = 0, const int rates_total = 0);
    bool                   SyncData(const ENUM_TIMEFRAMES timeframe, const uint required = 0, const int rates_total = 0);
    bool                   SyncData(const string symbol, const uint required = 0, const int rates_total = 0);
    bool                   SyncData(const uint required = 0, const int rates_total = 0);
    //--- Create (1) the specified timeseries of the specified symbol, (2) the specified timeseries of all symbols,
    //--- (3) all timeseries of the specified symbol and (4) all timeseries of all symbols
    bool                   CreateSeries(const string symbol, const ENUM_TIMEFRAMES timeframe, const uint required = 0);
    bool                   CreateSeries(const ENUM_TIMEFRAMES timeframe, const uint required = 0);
    bool                   CreateSeries(const string symbol, const uint required = 0);
    bool                   CreateSeries(const uint required = 0);
    //--- Update (1) the specified timeseries of the specified symbol, (2) the specified timeseries of all symbols,
    //--- (3) all timeseries of the specified symbol and (4) all timeseries of all symbols
    void                   Refresh(const string symbol, const ENUM_TIMEFRAMES timeframe,
                                   const datetime time    = 0,
                                   const double open      = 0,
                                   const double high      = 0,
                                   const double low       = 0,
                                   const double close     = 0,
                                   const long tick_volume = 0,
                                   const long volume      = 0,
                                   const int spread       = 0);
    void                   Refresh(const ENUM_TIMEFRAMES timeframe,
                                   const datetime        time = 0,
                                   const double open          = 0,
                                   const double high          = 0,
                                   const double low           = 0,
                                   const double close         = 0,
                                   const long tick_volume     = 0,
                                   const long volume          = 0,
                                   const int spread           = 0);
    void                   Refresh(const string   symbol,
                                   const datetime time    = 0,
                                   const double open      = 0,
                                   const double high      = 0,
                                   const double low       = 0,
                                   const double close     = 0,
                                   const long tick_volume = 0,
                                   const long volume      = 0,
                                   const int spread       = 0);
    void                   Refresh(const datetime time    = 0,
                                   const double open      = 0,
                                   const double high      = 0,
                                   const double low       = 0,
                                   const double close     = 0,
                                   const long tick_volume = 0,
                                   const long volume      = 0,
                                   const int spread       = 0);

    //--- Display (1) the complete and (2) short collection description in the journal
    void                   Print(const bool created = true);
    void                   PrintShort(const bool created = true);

    //--- Constructor
    CTimeSeriesCollection();
};
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CTimeSeriesCollection::CTimeSeriesCollection()
{
    this.m_list.Clear();
    this.m_list.Sort();
}
//+------------------------------------------------------------------+
//| Return the timeseries index by symbol name                       |
//+------------------------------------------------------------------+
int CTimeSeriesCollection::IndexTimeSeries(const string symbol)
{
    CTimeSeries *tmp = new CTimeSeries(symbol);
    if(tmp == NULL)
        return WRONG_VALUE;
    this.m_list.Sort();
    int index = this.m_list.Search(tmp);
    delete tmp;
    return index;
}
//+------------------------------------------------------------------+
//| Create the symbol timeseries collection list                     |
//+------------------------------------------------------------------+
bool CTimeSeriesCollection::CreateCollection(const CArrayObj *list_symbols)
{
    //--- If an empty list of symbol objects is passed, exit
    if(list_symbols == NULL)
        return false;
    //--- Get the number of symbol objects in the passed list
    int total = list_symbols.Total();
    //--- Clear the timeseries collection list
    this.m_list.Clear();
    //--- In a loop by all symbol objects
    for(int i = 0; i < total; i++)
    {
        //--- get the next symbol object
        CSymbol *symbol_obj = list_symbols.At(i);
        //--- if failed to get a symbol object, move on to the next one in the list
        if(symbol_obj == NULL)
            continue;
        //--- Create a new timeseries object with the current symbol name
        CTimeSeries *timeseries = new CTimeSeries(symbol_obj.Name());
        //--- If failed to create the timeseries object, move on to the next symbol in the list
        if(timeseries == NULL)
            continue;
        //--- Set the sorted list flag for the timeseries collection list
        this.m_list.Sort();
        //--- If the object with the same symbol name is already present in the timeseries collection list, remove the timeseries object
        if(this.m_list.Search(timeseries) > WRONG_VALUE)
            delete timeseries;
        //--- if failed to add the timeseries object to the collection list, remove the timeseries object
        else if(!this.m_list.Add(timeseries))
            delete timeseries;
    }
    //--- Return the flag indicating that the created collection list has a size greater than zero
    return this.m_list.Total() > 0;
}
//+-----------------------------------------------------------------------+
//|Set the flag of using the specified timeseries of the specified symbol |
//+-----------------------------------------------------------------------+
void CTimeSeriesCollection::SetAvailable(const string symbol, const ENUM_TIMEFRAMES timeframe, const bool flag = true)
{
    int index = this.IndexTimeSeries(symbol);
    if(index == WRONG_VALUE)
        return;
    CTimeSeries *timeseries = this.m_list.At(index);
    if(timeseries == NULL)
        return;
    CSeries *series = timeseries.GetSeries(timeframe);
    if(series == NULL)
        return;
    series.SetAvailable(flag);
}
//+------------------------------------------------------------------+
//|Set the flag of using the specified timeseries of all symbols     |
//+------------------------------------------------------------------+
void CTimeSeriesCollection::SetAvailable(const ENUM_TIMEFRAMES timeframe, const bool flag = true)
{
    int total = this.m_list.Total();
    for(int i = 0; i < total; i++)
    {
        CTimeSeries *timeseries = this.m_list.At(i);
        if(timeseries == NULL)
            continue;
        CSeries *series = timeseries.GetSeries(timeframe);
        if(series == NULL)
            continue;
        series.SetAvailable(flag);
    }
}
//+------------------------------------------------------------------+
//|Set the flag of using all timeseries of the specified symbol      |
//+------------------------------------------------------------------+
void CTimeSeriesCollection::SetAvailable(const string symbol, const bool flag = true)
{
    int index = this.IndexTimeSeries(symbol);
    if(index == WRONG_VALUE)
        return;
    CTimeSeries *timeseries = this.m_list.At(index);
    if(timeseries == NULL)
        return;
    CArrayObj *list = timeseries.GetListSeries();
    if(list == NULL)
        return;
    int total = list.Total();
    for(int i = 0; i < total; i++)
    {
        CSeries *series = list.At(i);
        if(series == NULL)
            continue;
        series.SetAvailable(flag);
    }
}
//+------------------------------------------------------------------+
//| Set the flag of using all timeseries of all symbols              |
//+------------------------------------------------------------------+
void CTimeSeriesCollection::SetAvailable(const bool flag = true)
{
    int total = this.m_list.Total();
    for(int i = 0; i < total; i++)
    {
        CTimeSeries *timeseries = this.m_list.At(i);
        if(timeseries == NULL)
            continue;
        CArrayObj *list = timeseries.GetListSeries();
        if(list == NULL)
            continue;
        int total_series = list.Total();
        for(int j = 0; j < total_series; j++)
        {
            CSeries *series = list.At(j);
            if(series == NULL)
                continue;
            series.SetAvailable(flag);
        }
    }
}
//+-------------------------------------------------------------------------+
//|Return the flag of using the specified timeseries of the specified symbol|
//+-------------------------------------------------------------------------+
bool CTimeSeriesCollection::IsAvailable(const string symbol, const ENUM_TIMEFRAMES timeframe)
{
    int index = this.IndexTimeSeries(symbol);
    if(index == WRONG_VALUE)
        return false;
    CTimeSeries *timeseries = this.m_list.At(index);
    if(timeseries == NULL)
        return false;
    CSeries *series = timeseries.GetSeries(timeframe);
    if(series == NULL)
        return false;
    return series.IsAvailable();
}
//+------------------------------------------------------------------+
//| Return the flag of using the specified timeseries of all symbols |
//+------------------------------------------------------------------+
bool CTimeSeriesCollection::IsAvailable(const ENUM_TIMEFRAMES timeframe)
{
    bool res   = true;
    int  total = this.m_list.Total();
    for(int i = 0; i < total; i++)
    {
        CTimeSeries *timeseries = this.m_list.At(i);
        if(timeseries == NULL)
            continue;
        CSeries *series = timeseries.GetSeries(timeframe);
        if(series == NULL)
            continue;
        res &= series.IsAvailable();
    }
    return res;
}
//+------------------------------------------------------------------+
//| Return the flag of using all timeseries of the specified symbol  |
//+------------------------------------------------------------------+
bool CTimeSeriesCollection::IsAvailable(const string symbol)
{
    bool res   = true;
    int  index = this.IndexTimeSeries(symbol);
    if(index == WRONG_VALUE)
        return false;
    CTimeSeries *timeseries = this.m_list.At(index);
    if(timeseries == NULL)
        return false;
    CArrayObj *list = timeseries.GetListSeries();
    if(list == NULL)
        return false;
    int total = list.Total();
    for(int i = 0; i < total; i++)
    {
        CSeries *series = list.At(i);
        if(series == NULL)
            continue;
        res &= series.IsAvailable();
    }
    return res;
}
//+------------------------------------------------------------------+
//| Return the flag of using all timeseries of all symbols           |
//+------------------------------------------------------------------+
bool CTimeSeriesCollection::IsAvailable(void)
{
    bool res   = true;
    int  total = this.m_list.Total();
    for(int i = 0; i < total; i++)
    {
        CTimeSeries *timeseries = this.m_list.At(i);
        if(timeseries == NULL)
            continue;
        CArrayObj *list = timeseries.GetListSeries();
        if(list == NULL)
            continue;
        int total_series = list.Total();
        for(int j = 0; j < total_series; j++)
        {
            CSeries *series = list.At(j);
            if(series == NULL)
                continue;
            res &= series.IsAvailable();
        }
    }
    return res;
}
//+--------------------------------------------------------------------------+
//|Set the history depth for the specified timeseries of the specified symbol|
//+--------------------------------------------------------------------------+
bool CTimeSeriesCollection::SetRequiredUsedData(const string symbol, const ENUM_TIMEFRAMES timeframe, const uint required = 0, const int rates_total = 0)
{
    int index = this.IndexTimeSeries(symbol);
    if(index == WRONG_VALUE)
        return false;
    CTimeSeries *timeseries = this.m_list.At(index);
    if(timeseries == NULL)
        return false;
    CSeries *series = timeseries.GetSeries(timeframe);
    if(series == NULL)
        return false;
    return series.SetRequiredUsedData(required, rates_total);
}
//+------------------------------------------------------------------+
//| Set the history depth of the specified timeseries of all symbols |
//+------------------------------------------------------------------+
bool CTimeSeriesCollection::SetRequiredUsedData(const ENUM_TIMEFRAMES timeframe, const uint required = 0, const int rates_total = 0)
{
    bool res   = true;
    int  total = this.m_list.Total();
    for(int i = 0; i < total; i++)
    {
        CTimeSeries *timeseries = this.m_list.At(i);
        if(timeseries == NULL)
            continue;
        CSeries *series = timeseries.GetSeries(timeframe);
        if(series == NULL)
            continue;
        res &= series.SetRequiredUsedData(required, rates_total);
    }
    return res;
}
//+------------------------------------------------------------------+
//| Set the history depth for all timeseries of the specified symbol |
//+------------------------------------------------------------------+
bool CTimeSeriesCollection::SetRequiredUsedData(const string symbol, const uint required = 0, const int rates_total = 0)
{
    bool res   = true;
    int  index = this.IndexTimeSeries(symbol);
    if(index == WRONG_VALUE)
        return false;
    CTimeSeries *timeseries = this.m_list.At(index);
    if(timeseries == NULL)
        return false;
    CArrayObj *list = timeseries.GetListSeries();
    if(list == NULL)
        return false;
    int total = list.Total();
    for(int i = 0; i < total; i++)
    {
        CSeries *series = list.At(i);
        if(series == NULL)
            continue;
        res &= series.SetRequiredUsedData(required, rates_total);
    }
    return res;
}
//+------------------------------------------------------------------+
//| Set the history depth for all timeseries of all symbols          |
//+------------------------------------------------------------------+
bool CTimeSeriesCollection::SetRequiredUsedData(const uint required = 0, const int rates_total = 0)
{
    bool res   = true;
    int  total = this.m_list.Total();
    for(int i = 0; i < total; i++)
    {
        CTimeSeries *timeseries = this.m_list.At(i);
        if(timeseries == NULL)
            continue;
        CArrayObj *list = timeseries.GetListSeries();
        if(list == NULL)
            continue;
        int total_series = list.Total();
        for(int j = 0; j < total_series; j++)
        {
            CSeries *series = list.At(j);
            if(series == NULL)
                continue;
            res &= series.SetRequiredUsedData(required, rates_total);
        }
    }
    return res;
}
//+------------------------------------------------------------------+
//| Return the flag of data synchronization with the server data     |
//| for a specified timeseries of a specified symbol                 |
//+------------------------------------------------------------------+
bool CTimeSeriesCollection::SyncData(const string symbol, const ENUM_TIMEFRAMES timeframe, const uint required = 0, const int rates_total = 0)
{
    int index = this.IndexTimeSeries(symbol);
    if(index == WRONG_VALUE)
        return false;
    CTimeSeries *timeseries = this.m_list.At(index);
    if(timeseries == NULL)
        return false;
    CSeries *series = timeseries.GetSeries(timeframe);
    if(series == NULL)
        return false;
    return series.SyncData(required, rates_total);
}
//+------------------------------------------------------------------+
//| Return the flag of data synchronization with the server data     |
//| for a specified timeseries of all symbols                        |
//+------------------------------------------------------------------+
bool CTimeSeriesCollection::SyncData(const ENUM_TIMEFRAMES timeframe, const uint required = 0, const int rates_total = 0)
{
    bool res   = true;
    int  total = this.m_list.Total();
    for(int i = 0; i < total; i++)
    {
        CTimeSeries *timeseries = this.m_list.At(i);
        if(timeseries == NULL)
            continue;
        CSeries *series = timeseries.GetSeries(timeframe);
        if(series == NULL)
            continue;
        res &= series.SyncData(required, rates_total);
    }
    return res;
}
//+------------------------------------------------------------------+
//| Return the flag of data synchronization with the server data     |
//| for all timeseries of a specified symbol                         |
//+------------------------------------------------------------------+
bool CTimeSeriesCollection::SyncData(const string symbol, const uint required = 0, const int rates_total = 0)
{
    bool res   = true;
    int  index = this.IndexTimeSeries(symbol);
    if(index == WRONG_VALUE)
        return false;
    CTimeSeries *timeseries = this.m_list.At(index);
    if(timeseries == NULL)
        return false;
    CArrayObj *list = timeseries.GetListSeries();
    if(list == NULL)
        return false;
    int total = list.Total();
    for(int i = 0; i < total; i++)
    {
        CSeries *series = list.At(i);
        if(series == NULL)
            continue;
        res &= series.SyncData(required, rates_total);
    }
    return res;
}
//+------------------------------------------------------------------+
//| Return the flag of data synchronization with the server data     |
//| for all timeseries of all symbols                                |
//+------------------------------------------------------------------+
bool CTimeSeriesCollection::SyncData(const uint required = 0, const int rates_total = 0)
{
    bool res   = true;
    int  total = this.m_list.Total();
    for(int i = 0; i < total; i++)
    {
        CTimeSeries *timeseries = this.m_list.At(i);
        if(timeseries == NULL)
            continue;
        CArrayObj *list = timeseries.GetListSeries();
        if(list == NULL)
            continue;
        int total_series = list.Total();
        for(int j = 0; j < total_series; j++)
        {
            CSeries *series = list.At(j);
            if(series == NULL)
                continue;
            res &= series.SyncData(required, rates_total);
        }
    }
    return res;
}
//+------------------------------------------------------------------+
//| Create the specified timeseries of the specified symbol          |
//+------------------------------------------------------------------+
bool CTimeSeriesCollection::CreateSeries(const string symbol, const ENUM_TIMEFRAMES timeframe, const uint required = 0)
{
    int index = this.IndexTimeSeries(symbol);
    if(index == WRONG_VALUE)
        return false;
    CTimeSeries *timeseries = this.m_list.At(index);
    if(timeseries == NULL)
        return false;
    return timeseries.Create(timeframe, required);
}
//+------------------------------------------------------------------+
//| Create the specified timeseries of all symbols                   |
//+------------------------------------------------------------------+
bool CTimeSeriesCollection::CreateSeries(const ENUM_TIMEFRAMES timeframe, const uint required = 0)
{
    bool res   = true;
    int  total = this.m_list.Total();
    for(int i = 0; i < total; i++)
    {
        CTimeSeries *timeseries = this.m_list.At(i);
        if(timeseries == NULL)
            continue;
        res &= timeseries.Create(timeframe, required);
    }
    return res;
}
//+------------------------------------------------------------------+
//| Create all timeseries of the specified symbol                    |
//+------------------------------------------------------------------+
bool CTimeSeriesCollection::CreateSeries(const string symbol, const uint required = 0)
{
    int index = this.IndexTimeSeries(symbol);
    if(index == WRONG_VALUE)
        return false;
    CTimeSeries *timeseries = this.m_list.At(index);
    if(timeseries == NULL)
        return false;
    return timeseries.CreateAll(required);
}
//+------------------------------------------------------------------+
//| Create all timeseries of all symbols                             |
//+------------------------------------------------------------------+
bool CTimeSeriesCollection::CreateSeries(const uint required = 0)
{
    bool res   = true;
    int  total = this.m_list.Total();
    for(int i = 0; i < total; i++)
    {
        CTimeSeries *timeseries = this.m_list.At(i);
        if(timeseries == NULL)
            continue;
        res &= timeseries.CreateAll(required);
    }
    return res;
}
//+------------------------------------------------------------------+
//| Update the specified timeseries of the specified symbol          |
//+------------------------------------------------------------------+
void CTimeSeriesCollection::Refresh(const string symbol, const ENUM_TIMEFRAMES timeframe,
                                    const datetime time    = 0,
                                    const double open      = 0,
                                    const double high      = 0,
                                    const double low       = 0,
                                    const double close     = 0,
                                    const long tick_volume = 0,
                                    const long volume      = 0,
                                    const int spread       = 0)
{
    int index = this.IndexTimeSeries(symbol);
    if(index == WRONG_VALUE)
        return;
    CTimeSeries *timeseries = this.m_list.At(index);
    if(timeseries == NULL)
        return;
    timeseries.Refresh(timeframe, time, open, high, low, close, tick_volume, volume, spread);
}
//+------------------------------------------------------------------+
//| Update the specified timeseries of all symbols                   |
//+------------------------------------------------------------------+
void CTimeSeriesCollection::Refresh(const ENUM_TIMEFRAMES timeframe,
                                    const datetime        time = 0,
                                    const double open          = 0,
                                    const double high          = 0,
                                    const double low           = 0,
                                    const double close         = 0,
                                    const long tick_volume     = 0,
                                    const long volume          = 0,
                                    const int spread           = 0)
{
    int total = this.m_list.Total();
    for(int i = 0; i < total; i++)
    {
        CTimeSeries *timeseries = this.m_list.At(i);
        if(timeseries == NULL)
            continue;
        timeseries.Refresh(timeframe, time, open, high, low, close, tick_volume, volume, spread);
    }
}
//+------------------------------------------------------------------+
//| Update all timeseries of the specified symbol                    |
//+------------------------------------------------------------------+
void CTimeSeriesCollection::Refresh(const string   symbol,
                                    const datetime time    = 0,
                                    const double open      = 0,
                                    const double high      = 0,
                                    const double low       = 0,
                                    const double close     = 0,
                                    const long tick_volume = 0,
                                    const long volume      = 0,
                                    const int spread       = 0)
{
    int index = this.IndexTimeSeries(symbol);
    if(index == WRONG_VALUE)
        return;
    CTimeSeries *timeseries = this.m_list.At(index);
    if(timeseries == NULL)
        return;
    timeseries.RefreshAll(time, open, high, low, close, tick_volume, volume, spread);
}
//+------------------------------------------------------------------+
//| Update all timeseries of all symbols                             |
//+------------------------------------------------------------------+
void CTimeSeriesCollection::Refresh(const datetime time    = 0,
                                    const double open      = 0,
                                    const double high      = 0,
                                    const double low       = 0,
                                    const double close     = 0,
                                    const long tick_volume = 0,
                                    const long volume      = 0,
                                    const int spread       = 0)
{
    int total = this.m_list.Total();
    for(int i = 0; i < total; i++)
    {
        CTimeSeries *timeseries = this.m_list.At(i);
        if(timeseries == NULL)
            continue;
        timeseries.RefreshAll(time, open, high, low, close, tick_volume, volume, spread);
    }
}
//+------------------------------------------------------------------+
//| Display complete collection description in the journal           |
//+------------------------------------------------------------------+
void CTimeSeriesCollection::Print(const bool created = true)
{
    int total = this.m_list.Total();
    for(int i = 0; i < total; i++)
    {
        CTimeSeries *timeseries = this.m_list.At(i);
        if(timeseries == NULL)
            continue;
        timeseries.Print(created);
    }
}
//+------------------------------------------------------------------+
//| Display the short collection description in the journal          |
//+------------------------------------------------------------------+
void CTimeSeriesCollection::PrintShort(const bool created = true)
{
    int total = this.m_list.Total();
    for(int i = 0; i < total; i++)
    {
        CTimeSeries *timeseries = this.m_list.At(i);
        if(timeseries == NULL)
            continue;
        timeseries.PrintShort(created);
    }
}
//+------------------------------------------------------------------+
