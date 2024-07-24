//+------------------------------------------------------------------+
//|                                                PendReqRemove.mqh |
//|                                              Alireza Khodakarami |
//|                         https://www.youtube.com/@YourTradeMaster |
//+------------------------------------------------------------------+
#property copyright "Alireza Khodakarami"
#property link "https://www.youtube.com/@YourTradeMaster"
#property version "1.00"
//+------------------------------------------------------------------+
//| Include files                                                    |
//+------------------------------------------------------------------+
#include "PendRequest.mqh"
//+------------------------------------------------------------------+
//| Pending request to remove a pending order                        |
//+------------------------------------------------------------------+
class CPendReqRemove : public CPendRequest
{
  public:
    //--- Constructor
    CPendReqRemove(const uchar            id,
                   const double           price,
                   const ulong            time,
                   const MqlTradeRequest &request,
                   const int              retcode) :
        CPendRequest(PEND_REQ_STATUS_REMOVE, id, price, time, request, retcode) {}

    //--- Supported deal properties (1) real, (2) integer
    virtual bool SupportProperty(ENUM_PEND_REQ_PROP_INTEGER property);
    virtual bool SupportProperty(ENUM_PEND_REQ_PROP_DOUBLE property);
    virtual bool   SupportProperty(ENUM_PEND_REQ_PROP_STRING property);
    //--- Display a brief message with request data and (2) a short request name in the journal
    virtual void   PrintShort(void);
    virtual string Header(void);
};
//+------------------------------------------------------------------+
//| Return 'true' if an order supports a passed                      |
//| integer property, otherwise return 'false'                       |
//+------------------------------------------------------------------+
bool CPendReqRemove::SupportProperty(ENUM_PEND_REQ_PROP_INTEGER property)
{
    return (property > PEND_REQ_PROP_MQL_REQ_ORDER ? false : true);
}
//+------------------------------------------------------------------+
//| Return 'true' if an order supports a passed                      |
//| real property, otherwise return 'false'                          |
//+------------------------------------------------------------------+
bool CPendReqRemove::SupportProperty(ENUM_PEND_REQ_PROP_DOUBLE property)
{
    return (property == PEND_REQ_PROP_PRICE_CREATE || property == PEND_REQ_PROP_MQL_REQ_PRICE ? true : false);
}
//+------------------------------------------------------------------+
//| Return 'true' if an order supports a passed                      |
//| string property, otherwise return 'false'                        |
//+------------------------------------------------------------------+
bool CPendReqRemove::SupportProperty(ENUM_PEND_REQ_PROP_STRING property)
{
    return true;
}
//+------------------------------------------------------------------+
//| Display a brief message with request data in the journal         |
//+------------------------------------------------------------------+
void CPendReqRemove::PrintShort(void)
{
    string params = this.GetProperty(PEND_REQ_PROP_MQL_REQ_SYMBOL) + " " + ::DoubleToString(this.GetProperty(PEND_REQ_PROP_MQL_REQ_VOLUME), this.m_digits_lot) + " " +
                    OrderTypeDescription((ENUM_ORDER_TYPE) this.GetProperty(PEND_REQ_PROP_MQL_REQ_TYPE)) + (" #") + (string) this.GetProperty(PEND_REQ_PROP_MQL_REQ_ORDER);
    string price     = CMessage::Text(MSG_LIB_TEXT_REQUEST_PRICE) + " " + ::DoubleToString(this.GetProperty(PEND_REQ_PROP_MQL_REQ_PRICE), this.m_digits);
    string stoplimit = this.GetProperty(PEND_REQ_PROP_MQL_REQ_STOPLIMIT) > 0 ? ", " + CMessage::Text(MSG_LIB_TEXT_REQUEST_STOPLIMIT) + " " + ::DoubleToString(this.GetProperty(PEND_REQ_PROP_MQL_REQ_STOPLIMIT), this.m_digits) : "";
    string time      = this.IDDescription() + ", " + CMessage::Text(MSG_LIB_TEXT_CREATED) + " " + TimeMSCtoString(this.GetProperty(PEND_REQ_PROP_TIME_CREATE));
    string attempts  = CMessage::Text(MSG_LIB_TEXT_ATTEMPTS) + " " + (string) this.GetProperty(PEND_REQ_PROP_TOTAL);
    string wait      = CMessage::Text(MSG_LIB_TEXT_WAIT) + " " + ::TimeToString(this.GetProperty(PEND_REQ_PROP_WAITING) / 1000, TIME_SECONDS);
    string end       = CMessage::Text(MSG_LIB_TEXT_END) + " " +
                 TimeMSCtoString(this.GetProperty(PEND_REQ_PROP_TIME_CREATE) + this.GetProperty(PEND_REQ_PROP_WAITING) * this.GetProperty(PEND_REQ_PROP_TOTAL));
    //---
    string message = CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_STATUS_REMOVE) + ": " +
                     "\n- " + params + ", " + price + stoplimit +
                     "\n- " + time + ", " + attempts + ", " + wait + ", " + end + "\n";
    ::Print(message);
}
//+------------------------------------------------------------------+
//| Return the short request name                                    |
//+------------------------------------------------------------------+
string CPendReqRemove::Header(void)
{
    return CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_STATUS_REMOVE) + (", ID #") + (string) this.GetProperty(PEND_REQ_PROP_ID);
}
//+------------------------------------------------------------------+
