//+------------------------------------------------------------------+
//|                                                 TimerCounter.mqh |
//|                                              Alireza Khodakarami |
//|                         https://www.youtube.com/@YourTradeMaster |
//+------------------------------------------------------------------+
#property copyright "Alireza Khodakarami"
#property link      "https://www.youtube.com/@YourTradeMaster"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Include files                                                    |
//+------------------------------------------------------------------+
#include <Object.mqh>
#include "MTLib.mqh"
//+------------------------------------------------------------------+
//| Timer counter class                                              |
//+------------------------------------------------------------------+
class CTimerCounter : public CObject
{
private:
    int               m_counter_id;
    ulong             m_counter;
    ulong             m_counter_step;
    ulong             m_counter_pause;
public:
    //--- Return the waiting completion flag
    bool              IsTimeDone(void);
    //--- Set the counter parameters
    void              SetParams(const ulong step,const ulong pause)         { this.m_counter_step=step; this.m_counter_pause=pause;  }
    //--- Return the counter id
    virtual  int      Type(void)                                      const { return this.m_counter_id;                              }
    //--- Compare counter objects
    virtual int       Compare(const CObject *node,const int mode=0)   const;
    //--- Constructor
                     CTimerCounter(const int id);
};
//+------------------------------------------------------------------+
//| CTimerCounter constructor                                        |
//+------------------------------------------------------------------+
CTimerCounter::CTimerCounter(const int id) : m_counter(0), m_counter_step(16), m_counter_pause(16)
{
    this.m_counter_id = id;
}
//+------------------------------------------------------------------+
//| CTimerCounter returns the pause completion flag                  |
//+------------------------------------------------------------------+
bool CTimerCounter::IsTimeDone(void)
{
    if(this.m_counter >= ULONG_MAX)
        this.m_counter = 0;
    if(this.m_counter < this.m_counter_pause)
    {
        this.m_counter += this.m_counter_step;
        return false;
    }
    this.m_counter = 0;
    return true;
}
//+------------------------------------------------------------------+
//| Compare CTimerCounter objects by id                              |
//+------------------------------------------------------------------+
int CTimerCounter::Compare(const CObject *node, const int mode = 0) const
{
    const CTimerCounter *counter_compared = node;
    int value_compared = counter_compared.Type();
    int value_current = this.Type();
    return(value_current > value_compared ? 1 : value_current < value_compared ? -1 : 0);
    return 0;
}
//+------------------------------------------------------------------+
