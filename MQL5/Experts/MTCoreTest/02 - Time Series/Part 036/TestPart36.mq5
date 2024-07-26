//+------------------------------------------------------------------+
//|                                                   TestPart36.mq5 |
//|                                              Alireza Khodakarami |
//|                         https://www.youtube.com/@YourTradeMaster |
//+------------------------------------------------------------------+
#property copyright "Alireza Khodakarami"
#property link "https://www.youtube.com/@YourTradeMaster"
#property version "1.00"
//--- includes
#include <MT Core Lib/Base/Engine.mqh>

//--- global variables
CEngine                 engine;
CTimeSeries             timeseries;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int                     OnInit()
{
    //--- Set a symbol for created timeseries
    timeseries.SetSymbol(Symbol());
  #define TIMESERIES_ALL
    //--- Create two timeseries
  #ifndef TIMESERIES_ALL
    timeseries.SyncData(PERIOD_CURRENT, 10);
    timeseries.Create(PERIOD_CURRENT);
    timeseries.SyncData(PERIOD_M15, 2);
    timeseries.Create(PERIOD_M15);
    //--- Create all timeseries
  #else
    timeseries.SyncAllData();
    timeseries.CreateAll();
  
  #endif
    //--- Check created timeseries
    CArrayObj *list = timeseries.GetList();
    Print(TextByLanguage("Data of created timeseries:"));
    for(int i = 0; i < list.Total(); i++)
    {
        CSeries *series_obj = timeseries.GetSeriesByIndex((uchar) i);
        if(series_obj == NULL || series_obj.AmountUsedData() == 0 || series_obj.DataTotal() == 0)
            continue;
        Print(
            DFUN, i, ": ", series_obj.Symbol(), " ", TimeframeDescription(series_obj.Timeframe()),
            TextByLanguage(": AmountUsedData="), series_obj.AmountUsedData(),
            TextByLanguage(", DataTotal="), series_obj.DataTotal(),
            TextByLanguage(", Bars="), series_obj.Bars());
    }
    Print("");
    //---
    return (INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    Comment("");
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
    //--- If working in the tester
    if(MQLInfoInteger(MQL_TESTER))
        engine.OnTimer();    // Working in the timer
    //--- Update created timeseries
    CArrayObj *list = timeseries.GetList();
    for(int i = 0; i < list.Total(); i++)
    {
        CSeries *series_obj = timeseries.GetSeriesByIndex((uchar) i);
        if(series_obj == NULL || series_obj.DataTotal() == 0)
            continue;
        series_obj.Refresh();
        if(series_obj.IsNewBar(0))
        {
            Print(TextByLanguage("New bar on "), series_obj.Symbol(), " ", TimeframeDescription(series_obj.Timeframe()), " ", TimeToString(series_obj.Time(0)));
            if(series_obj.Timeframe() == Period())
                engine.PlaySoundByDescription(SND_NEWS);
        }
    }
}
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
{
    //--- Launch the library timer (only not in the tester)
    if(!MQLInfoInteger(MQL_TESTER))
        engine.OnTimer();
}
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int     id,
                  const long   &lparam,
                  const double &dparam,
                  const string &sparam)
{
}
//+------------------------------------------------------------------+
