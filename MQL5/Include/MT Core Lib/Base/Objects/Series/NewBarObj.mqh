//+------------------------------------------------------------------+
//|                                                    NewBarObj.mqh |
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
#include "../../Objects/BaseObj.mqh"
//+------------------------------------------------------------------+
//| "New bar" object class                                           |
//+------------------------------------------------------------------+
class CNewBarObj : public CBaseObj
{
  private:
    string            m_symbol;                 // Symbol
    ENUM_TIMEFRAMES   m_timeframe;              // Timeframe
    datetime          m_new_bar_time;           // New bar time for auto time management
    datetime          m_prev_time;              // Previous time for auto time management
    datetime          m_new_bar_time_manual;    // New bar time for manual time management
    datetime          m_prev_time_manual;       // Previous time for manual time management
                                                //--- Return the current bar data
    datetime          GetLastBarDate(const datetime time);

  public:
    //--- Set (1) symbol and (2) timeframe
    void            SetSymbol(const string symbol) { this.m_symbol = (symbol == NULL || symbol == "" ? ::Symbol() : symbol); }
    void            SetPeriod(const ENUM_TIMEFRAMES timeframe) { this.m_timeframe = (timeframe == PERIOD_CURRENT ? (ENUM_TIMEFRAMES)::Period() : timeframe); }
    //--- Save the new bar time during the manual time management
    void            SaveNewBarTime(const datetime time) { this.m_prev_time_manual = this.GetLastBarDate(time); }
    //--- Return (1) symbol and (2) timeframe
    string          Symbol(void) const { return this.m_symbol; }
    ENUM_TIMEFRAMES Period(void) const { return this.m_timeframe; }
    //--- Return the (1) new bar time
    datetime        TimeNewBar(void) const { return this.m_new_bar_time; }
    //--- Return the new bar opening flag during the time (1) auto, (2) manual management
    bool            IsNewBar(const datetime time);
    bool            IsNewBarManual(const datetime time);
    //--- Constructors
    CNewBarObj(void) :
        m_symbol(::Symbol()),
        m_timeframe((ENUM_TIMEFRAMES)::Period()),
        m_prev_time(0), m_new_bar_time(0),
        m_prev_time_manual(0), m_new_bar_time_manual(0) {}
    CNewBarObj(const string symbol, const ENUM_TIMEFRAMES timeframe);
};
//+------------------------------------------------------------------+
//| Parametric constructor                                           |
//+------------------------------------------------------------------+
CNewBarObj::CNewBarObj(const string symbol, const ENUM_TIMEFRAMES timeframe) :
    m_symbol(symbol), m_timeframe(timeframe)
{
    this.m_prev_time = this.m_prev_time_manual = this.m_new_bar_time = this.m_new_bar_time_manual = 0;
}
//+------------------------------------------------------------------+
//| Return new bar opening flag                                      |
//+------------------------------------------------------------------+
bool CNewBarObj::IsNewBar(const datetime time)
{
    //--- Get the current bar time
    datetime tm = this.GetLastBarDate(time);
    //--- If the previous and current time are equal to zero, this is the first launch
    if(this.m_prev_time == 0 && this.m_new_bar_time == 0)
    {
        //--- set the new bar opening time,
        //--- set the previous bar time as the current one and return 'false'
        this.m_new_bar_time = this.m_prev_time = tm;
        return false;
    }
    //--- If the previous time is not equal to the current bar open time, this is a new bar
    if(this.m_prev_time != tm)
    {
        //--- set the new bar opening time,
        //--- set the previous time as the current one and return 'true'
        this.m_new_bar_time = this.m_prev_time = tm;
        return true;
    }
    //--- in other cases, return 'false'
    return false;
}
//+------------------------------------------------------------------+
//| Return the new bar opening flag during the manual management     |
//+------------------------------------------------------------------+
bool CNewBarObj::IsNewBarManual(const datetime time)
{
    //--- Get the current bar time
    datetime tm = this.GetLastBarDate(time);
    //--- If the previous and current time are equal to zero, this is the first launch
    if(this.m_prev_time_manual == 0 && this.m_new_bar_time_manual == 0)
    {
        //--- set the new bar opening time,
        //--- set the previous bar time as the current one and return 'false'
        this.m_new_bar_time_manual = this.m_prev_time_manual = tm;
        return false;
    }
    //--- If the previous time is not equal to the current bar open time, this is a new bar
    if(this.m_prev_time_manual != tm)
    {
        //--- set the new bar opening time and return 'true'
        //--- Save the previous time as the current one from the program using the SaveNewBarTime() method
        //--- Till the previous time is forcibly set as the current one from the program,
        //--- the method returns the new bar flag allowing the completion of all the necessary actions on the new bar.
        this.m_new_bar_time = tm;
        return true;
    }
    //--- in other cases, return 'false'
    return false;
}
//+------------------------------------------------------------------+
//| Return the current bar time                                      |
//+------------------------------------------------------------------+
datetime CNewBarObj::GetLastBarDate(const datetime time)
{
    return ( this.m_program == PROGRAM_INDICATOR && 
             this.m_symbol == ::Symbol() && 
             this.m_timeframe == ::Period() 
                  ? time 
                  : (datetime)::SeriesInfoInteger(this.m_symbol, this.m_timeframe, SERIES_LASTBAR_DATE));
}
//+------------------------------------------------------------------+
