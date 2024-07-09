//+------------------------------------------------------------------+
//|                                                      ListObj.mqh |
//|                                              Alireza Khodakarami |
//|                         https://www.youtube.com/@YourTradeMaster |
//+------------------------------------------------------------------+
#property copyright "Alireza Khodakarami"
#property link "https://www.youtube.com/@YourTradeMaster"
#property version "1.00"
//+------------------------------------------------------------------+
//| Include files                                                    |
//+------------------------------------------------------------------+
#include <Arrays\ArrayObj.mqh>
//+------------------------------------------------------------------+
//| Collections lists class                                          |
//+------------------------------------------------------------------+
class CListObj : public CArrayObj
{
  private:
    int m_type;    // List type

  public:
    void        Type(const int type) { this.m_type = type; }
    virtual int Type(void) const { return (this.m_type); }
    CListObj() { this.m_type = 0x7778; }
};
//+------------------------------------------------------------------+
