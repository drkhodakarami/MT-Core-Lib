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
#include "ListObj.mqh"
#include "..\Objects\Series\TimeSeries.mqh"
#include "..\Objects\Symbols\Symbol.mqh"
//+------------------------------------------------------------------+
//| Symbol timeseries collection                                     |
//+------------------------------------------------------------------+
class CTimeSeriesCollection : public CBaseObjExt
{
  private:
    CListObj  m_list;    // List of applied symbol timeseries
                         //--- Return the timeseries index by symbol name
    int       IndexTimeSeries(const string symbol);

  public:
    //--- Return (1) oneself and (2) the timeseries list
    CTimeSeriesCollection *GetObject(void) { return &this; }
    CArrayObj             *GetList(void) { return &this.m_list; }

    //--- Return (1) the timeseries object of the specified symbol and (2) the timeseries object of the specified symbol/period
    CTimeSeries           *GetTimeseries(const string symbol);
    CSeries               *GetSeries(const string symbol, const ENUM_TIMEFRAMES timeframe);

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
    //--- Return the bar of the specified timeseries of the specified symbol of the specified position
    CBar                  *GetBar(const string symbol, const ENUM_TIMEFRAMES timeframe, const int index, const bool from_series = true);
    //--- Return the flag of opening a new bar of the specified timeseries of the specified symbol
    bool                   IsNewBar(const string symbol, const ENUM_TIMEFRAMES timeframe, const datetime time = 0);

    //--- (1) Create and (2) re-create a specified timeseries of a specified symbol
    bool                   CreateSeries(const string symbol, const ENUM_TIMEFRAMES timeframe, const int rates_total = 0, const uint required = 0);
    bool                   ReCreateSeries(const string symbol, const ENUM_TIMEFRAMES timeframe, const int rates_total = 0, const uint required = 0);
    //--- Return (1) an empty, (2) partially filled timeseries
    CSeries               *GetSeriesEmpty(void);
    CSeries               *GetSeriesIncompleted(void);
    //--- Update (1) the specified timeseries of the specified symbol, (2) all timeseries of all symbols
    void                   Refresh(const string symbol, const ENUM_TIMEFRAMES timeframe, SDataCalculate &data_calculate);
    void                   Refresh(SDataCalculate &data_calculate);

    //--- Get events from the timeseries object and add them to the list
    bool                   SetEvents(CTimeSeries *timeseries);

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
    this.m_list.Type(COLLECTION_SERIES_ID);
}
//+------------------------------------------------------------------+
//| Return the timeseries index by symbol name                       |
//+------------------------------------------------------------------+
int CTimeSeriesCollection::IndexTimeSeries(const string symbol)
{
    const CTimeSeries *obj = new CTimeSeries(symbol == NULL || symbol == "" ? ::Symbol() : symbol);
    if(obj == NULL)
        return WRONG_VALUE;
    this.m_list.Sort();
    int index = this.m_list.Search(obj);
    delete obj;
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
//+------------------------------------------------------------------+
//| Return the timeseries object of the specified symbol             |
//+------------------------------------------------------------------+
CTimeSeries *CTimeSeriesCollection::GetTimeseries(const string symbol)
{
   int index=this.IndexTimeSeries(symbol);
   if(index==WRONG_VALUE)
      return NULL;
   CTimeSeries *timeseries=this.m_list.At(index);
   return timeseries;
  }
//+------------------------------------------------------------------+
//| Return the timeseries object of the specified symbol/period      |
//+------------------------------------------------------------------+
CSeries *CTimeSeriesCollection::GetSeries(const string symbol,const ENUM_TIMEFRAMES timeframe)
  {
   CTimeSeries *timeseries=this.GetTimeseries(symbol);
   if(timeseries==NULL)
      return NULL;
   CSeries *series=timeseries.GetSeries(timeframe);
   return series;
  }
//+-----------------------------------------------------------------------+
//|Set the flag of using the specified timeseries of the specified symbol |
//+-----------------------------------------------------------------------+
void CTimeSeriesCollection::SetAvailable(const string symbol,const ENUM_TIMEFRAMES timeframe,const bool flag=true)
  {
   CSeries *series=this.GetSeries(symbol,timeframe);
   if(series==NULL)
      return;
   series.SetAvailable(flag);
   series.PrintShort();
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
    CTimeSeries *timeseries = this.GetTimeseries(symbol);
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
    CSeries *series = this.GetSeries(symbol, timeframe);
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
    CTimeSeries *timeseries = this.GetTimeseries(symbol);
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
    CSeries *series = this.GetSeries(symbol, timeframe);
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
    CTimeSeries *timeseries = this.GetTimeseries(symbol);
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
//+-----------------------------------------------------------------------+
//| Return the bar of the specified timeseries                            |
//| of the specified symbol of the specified position                     |
//| from_series=true - by the timeseries index, false - by the list index |
//+-----------------------------------------------------------------------+
CBar *CTimeSeriesCollection::GetBar(const string symbol, const ENUM_TIMEFRAMES timeframe, const int index, const bool from_series = true)
{
    CSeries *series = this.GetSeries(symbol, timeframe);
    if(series == NULL)
        return NULL;
    //--- Depending on the from_series flag, return the pointer to the bar
    //--- either by the chart timeseries index or by the bar index in the timeseries list
    return (from_series ? series.GetBarBySeriesIndex(index) : series.GetBarByListIndex(index));
}
//+------------------------------------------------------------------+
//| Return new bar opening flag                                      |
//| for a specified timeseries of a specified symbol                 |
//+------------------------------------------------------------------+
bool CTimeSeriesCollection::IsNewBar(const string symbol, const ENUM_TIMEFRAMES timeframe, const datetime time = 0)
{
    CSeries *series = this.GetSeries(symbol, timeframe);
    if(series == NULL)
        return false;
    //--- Return the result of checking the new bar of the specified timeseries
    return series.IsNewBar(time);
}
//+------------------------------------------------------------------+
//| Return the flag of data synchronization with the server data     |
//| for a specified timeseries of a specified symbol                 |
//+------------------------------------------------------------------+
bool CTimeSeriesCollection::SyncData(const string symbol, const ENUM_TIMEFRAMES timeframe, const uint required = 0, const int rates_total = 0)
{
    CSeries *series = this.GetSeries(symbol, timeframe);
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
    CTimeSeries *timeseries = this.GetTimeseries(symbol);
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
//|Return the empty (created but not filled with data) timeseries    |
//+------------------------------------------------------------------+
CSeries *CTimeSeriesCollection::GetSeriesEmpty(void)
{
    //--- In the loop by the timeseries object list
    int total_timeseries = this.m_list.Total();
    for(int i = 0; i < total_timeseries; i++)
    {
        //--- get the next object of all symbol timeseries by the loop index
        CTimeSeries *timeseries = this.m_list.At(i);
        if(timeseries == NULL || !timeseries.IsAvailable())
            continue;
        //--- get the list of timeseries objects from the object of all symbol timeseries
        CArrayObj *list_series = timeseries.GetListSeries();
        if(list_series == NULL)
            continue;
        //--- in the loop by the symbol timeseries list
        int total_series = list_series.Total();
        for(int j = 0; j < total_series; j++)
        {
            //--- get the next timeseries
            CSeries *series = list_series.At(j);
            if(series == NULL || !series.IsAvailable())
                continue;
            //--- if the timeseries has no bar objects,
            //--- return the pointer to the timeseries
            if(series.DataTotal() == 0)
                return series;
        }
    }
    return NULL;
}
//+------------------------------------------------------------------+
//| Return partially filled timeseries                               |
//+------------------------------------------------------------------+
CSeries *CTimeSeriesCollection::GetSeriesIncompleted(void)
{
    //--- In the loop by the timeseries object list
    int total_timeseries = this.m_list.Total();
    for(int i = 0; i < total_timeseries; i++)
    {
        //--- get the next object of all symbol timeseries by the loop index
        CTimeSeries *timeseries = this.m_list.At(i);
        if(timeseries == NULL || !timeseries.IsAvailable())
            continue;
        //--- get the list of timeseries objects from the object of all symbol timeseries
        CArrayObj *list_series = timeseries.GetListSeries();
        if(list_series == NULL)
            continue;
        //--- in the loop by the symbol timeseries list
        int total_series = list_series.Total();
        for(int j = 0; j < total_series; j++)
        {
            //--- get the next timeseries
            CSeries *series = list_series.At(j);
            if(series == NULL || !series.IsAvailable())
                continue;
            //--- if the timeseries has bar objects,
            //--- but their number is not equal to the requested and available one for the symbol,
            //--- return the pointer to the timeseries
            if(series.DataTotal() > 0 && series.AvailableUsedData() != series.DataTotal())
                return series;
        }
    }
    return NULL;
}
//+------------------------------------------------------------------+
//| Create the specified timeseries of the specified symbol          |
//+------------------------------------------------------------------+
bool CTimeSeriesCollection::CreateSeries(const string symbol, const ENUM_TIMEFRAMES timeframe, const int rates_total = 0, const uint required = 0)
{
    CTimeSeries *timeseries = this.GetTimeseries(symbol);
    if(timeseries == NULL)
        return false;
    if(!timeseries.AddSeries(timeframe, required))
        return false;
    if(!timeseries.SyncData(timeframe, required, rates_total))
        return false;
    return timeseries.CreateSeries(timeframe, required);
}
//+------------------------------------------------------------------+
//| Re-create a specified timeseries of a specified symbol           |
//+------------------------------------------------------------------+
bool CTimeSeriesCollection::ReCreateSeries(const string symbol, const ENUM_TIMEFRAMES timeframe, const int rates_total = 0, const uint required = 0)
{
    CTimeSeries *timeseries = this.GetTimeseries(symbol);
    if(timeseries == NULL)
        return false;
    if(!timeseries.SyncData(timeframe, rates_total, required))
        return false;
    return timeseries.CreateSeries(timeframe, required);
}
//+------------------------------------------------------------------+
//| Update the specified timeseries of the specified symbol          |
//+------------------------------------------------------------------+
void CTimeSeriesCollection::Refresh(const string symbol, const ENUM_TIMEFRAMES timeframe, SDataCalculate &data_calculate)
{
    //--- Reset the flag of an event in the timeseries collection and clear the event list
    this.m_is_event = false;
    this.m_list_events.Clear();
    //--- Get the object of all symbol timeseries by a symbol name
    CTimeSeries *timeseries = this.GetTimeseries(symbol);
    if(timeseries == NULL)
        return;
    //--- If there is no new tick on the timeseries object symbol, exit
    if(!timeseries.IsNewTick())
        return;
    //--- Update the required object timeseries of all symbol timeseries
    timeseries.Refresh(timeframe, data_calculate);
    //--- If the timeseries has the enabled event flag,
    //--- get events from symbol timeseries, write them to the collection event list
    //--- and set the event flag in the collection
    if(timeseries.IsEvent())
        this.m_is_event = this.SetEvents(timeseries);
}
//+------------------------------------------------------------------+
//| Update the specified timeseries of all symbols                   |
//+------------------------------------------------------------------+
void CTimeSeriesCollection::Refresh(SDataCalculate &data_calculate)
{
    //--- Reset the flag of an event in the timeseries collection and clear the event list
    this.m_is_event = false;
    this.m_list_events.Clear();
    //--- In the loop by all symbol timeseries objects in the collection,
    int total = this.m_list.Total();
    for(int i = 0; i < total; i++)
    {
        //--- get the next symbol timeseries object
        CTimeSeries *timeseries = this.m_list.At(i);
        if(timeseries == NULL)
            continue;
        //--- if there is no new tick on a timeseries symbol, move to the next object in the list
        if(!timeseries.IsNewTick())
            continue;
        //--- Update all symbol timeseries
        timeseries.RefreshAll(data_calculate);
        //--- If the event flag enabled for the symbol timeseries object,
        //--- get events from symbol timeseries, write them to the collection event list
        //--- and set the event flag in the collection
        if(timeseries.IsEvent())
            this.m_is_event = this.SetEvents(timeseries);
    }
}
//+------------------------------------------------------------------+
//| Get events from the timeseries object and add them to the list   |
//+------------------------------------------------------------------+
bool CTimeSeriesCollection::SetEvents(CTimeSeries *timeseries)
{
    //--- Set the flag of successfully adding an event to the list and
    //--- get the list of symbol timeseries object events
    bool       res  = true;
    CArrayObj *list = timeseries.GetListEvents();
    if(list == NULL)
        return false;
    //--- In the loop by the obtained list of events,
    int total = list.Total();
    for(int i = 0; i < total; i++)
    {
        //--- get the next event by the loop index and
        CEventBaseObj *event = timeseries.GetEvent(i);
        if(event == NULL)
            continue;
        //--- add the result of adding the obtained event to the flag value
        //--- from the symbol timeseries list to the timeseries collection list
        res &= this.EventAdd(event.ID(), event.LParam(), event.DParam(), event.SParam());
    }
    //--- Return the result of adding events to the list
    return res;
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
