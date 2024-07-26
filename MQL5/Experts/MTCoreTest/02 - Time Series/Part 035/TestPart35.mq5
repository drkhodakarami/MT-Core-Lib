//+------------------------------------------------------------------+
//|                                                   TestPart35.mq5 |
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
CSeries                 series;
CSeries                 series_m1;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int                     OnInit()
{
    //--- Set the M1 timeseries object parameters
    series_m1.SetSymbolPeriod(Symbol(), PERIOD_M1);
    //--- If symbol and M1 timeframe data are synchronized
    if(series_m1.SyncData(2, 0))
    {
        //--- create the timeseries list of two bars (the current and previous ones),
        //--- if the timeseries is created, display the appropriate message in the journal
        int total = series_m1.Create(2);
        if(total > 0)
            Print(TextByLanguage("Created timeseries M1 with size "), (string) total);
    }
    //--- Check filling price data on the current symbol and timeframe
    series.SetSymbolPeriod(Symbol(), (ENUM_TIMEFRAMES) Period());
    //--- If symbol and the current timeframe data are synchronized
    if(series.SyncData(10, 0))
    {
        //--- create the timeseries list of ten bars (bars 0 - 9),
        //--- if the timeseries is created, display three lists:
        //--- 1. the list of bars sorted by candle size (from bars' High to Low)
        //--- 2. the list of bars sorted by bar indices (according to their sequence in the timeseries)
        //--- 3. the full list of all properties of the previous bar object (bar properties with the timeseries index of 1)
        int total = series.Create(10);
        if(total > 0)
        {
            CArrayObj *list = series.GetList();
            CBar      *bar  = NULL;
            //--- Display short properties of the bar list by the candle size
            Print("\n", TextByLanguage("Bars sorted by candle size from High to Low:"));
            list.Sort(SORT_BY_BAR_CANDLE_SIZE);
            for(int i = 0; i < total; i++)
            {
                bar = series.GetBarByListIndex(i);
                if(bar == NULL)
                    continue;
                bar.PrintShort();
            }
            //--- Display short properties of the bar list by the timeseries index
            Print("\n", TextByLanguage("Bars sorted by timeseries index:"));
            list.Sort(SORT_BY_BAR_INDEX);
            for(int i = 0; i < total; i++)
            {
                bar = series.GetBarByListIndex(i);
                if(bar == NULL)
                    continue;
                bar.PrintShort();
            }
            //--- Display all bar 1 properties
            Print("");
            list = CSelect::ByBarProperty(list, BAR_PROP_INDEX, 1, EQUAL);
            if(list.Total() == 1)
            {
                bar = list.At(0);
                bar.Print();
            }
        }
    }
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
    {
        engine.OnTimer();         // Working in the timer
    }
    //--- Check the update of the current and M1 timeseries
    series.Refresh();
    if(series.IsNewBar(0))
    {
        Print("New bar on ", series.Symbol(), " ", TimeframeDescription(series.Period()), " ", TimeToString(series.Time(0)));
        engine.PlaySoundByDescription(SND_NEWS);
    }
    series_m1.Refresh();
    if(series_m1.IsNewBar(0))
        Print("New bar on ", series_m1.Symbol(), " ", TimeframeDescription(series_m1.Period()), " ", TimeToString(series_m1.Time(0)));
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
