//+------------------------------------------------------------------+
//|                                                  PendReqSLTP.mqh |
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
//| Pending request to modify position stop orders                   |
//+------------------------------------------------------------------+
class CPendReqSLTP : public CPendRequest
{
  public:
    //--- Constructor
    CPendReqSLTP(const uchar            id,
                 const double           price,
                 const ulong            time,
                 const MqlTradeRequest &request,
                 const int              retcode) :
        CPendRequest(PEND_REQ_STATUS_SLTP, id, price, time, request, retcode) {}

    //--- Supported deal properties (1) real, (2) integer
    virtual bool SupportProperty(ENUM_PEND_REQ_PROP_INTEGER property);
    virtual bool SupportProperty(ENUM_PEND_REQ_PROP_DOUBLE property);
    virtual bool SupportProperty(ENUM_PEND_REQ_PROP_STRING property);
    //--- Display a brief message with request data in the journal
    virtual void PrintShort(void);
};
//+------------------------------------------------------------------+
//| Return 'true' if an order supports a passed                      |
//| integer property, otherwise return 'false'                       |
//+------------------------------------------------------------------+
bool CPendReqSLTP::SupportProperty(ENUM_PEND_REQ_PROP_INTEGER property)
{
    if(property == PEND_REQ_PROP_MQL_REQ_POSITION_BY ||
       property == PEND_REQ_PROP_MQL_REQ_ORDER ||
       property == PEND_REQ_PROP_MQL_REQ_EXPIRATION ||
       property == PEND_REQ_PROP_MQL_REQ_DEVIATION ||
       property == PEND_REQ_PROP_MQL_REQ_TYPE_FILLING ||
       property == PEND_REQ_PROP_MQL_REQ_TYPE_TIME)
        return false;
    return true;
}
//+------------------------------------------------------------------+
//| Return 'true' if an order supports a passed                      |
//| real property, otherwise return 'false'                          |
//+------------------------------------------------------------------+
bool CPendReqSLTP::SupportProperty(ENUM_PEND_REQ_PROP_DOUBLE property)
{
    if(property == PEND_REQ_PROP_PRICE_CREATE ||
       property == PEND_REQ_PROP_MQL_REQ_SL ||
       property == PEND_REQ_PROP_MQL_REQ_TP)
        return true;
    return false;
}
//+------------------------------------------------------------------+
//| Return 'true' if an order supports a passed                      |
//| string property, otherwise return 'false'                        |
//+------------------------------------------------------------------+
bool CPendReqSLTP::SupportProperty(ENUM_PEND_REQ_PROP_STRING property)
{
    return true;
}
//+------------------------------------------------------------------+
//| Display a brief message with request data in the journal         |
//+------------------------------------------------------------------+
void CPendReqSLTP::PrintShort(void)
{
    string params = this.GetProperty(PEND_REQ_PROP_MQL_REQ_SYMBOL) + " " + ::DoubleToString(this.GetProperty(PEND_REQ_PROP_MQL_REQ_VOLUME), this.m_digits_lot) + " " +
                    PositionTypeDescription((ENUM_POSITION_TYPE) this.GetProperty(PEND_REQ_PROP_MQL_REQ_TYPE)) + (" #") + (string) this.GetProperty(PEND_REQ_PROP_MQL_REQ_POSITION);
    string sl       = this.GetProperty(PEND_REQ_PROP_MQL_REQ_SL) > 0 ? ", " + CMessage::Text(MSG_LIB_TEXT_REQUEST_SL) + " " + ::DoubleToString(this.GetProperty(PEND_REQ_PROP_MQL_REQ_SL), this.m_digits) : "";
    string tp       = this.GetProperty(PEND_REQ_PROP_MQL_REQ_TP) > 0 ? ", " + CMessage::Text(MSG_LIB_TEXT_REQUEST_TP) + " " + ::DoubleToString(this.GetProperty(PEND_REQ_PROP_MQL_REQ_TP), this.m_digits) : "";
    string time     = this.IDDescription() + ", " + CMessage::Text(MSG_LIB_TEXT_CREATED) + " " + TimeMSCtoString(this.GetProperty(PEND_REQ_PROP_TIME_CREATE));
    string attempts = CMessage::Text(MSG_LIB_TEXT_ATTEMPTS) + " " + (string) this.GetProperty(PEND_REQ_PROP_TOTAL);
    string wait     = CMessage::Text(MSG_LIB_TEXT_WAIT) + " " + ::TimeToString(this.GetProperty(PEND_REQ_PROP_WAITING) / 1000, TIME_SECONDS);
    string end      = CMessage::Text(MSG_LIB_TEXT_END) + " " +
                 TimeMSCtoString(this.GetProperty(PEND_REQ_PROP_TIME_CREATE) + this.GetProperty(PEND_REQ_PROP_WAITING) * this.GetProperty(PEND_REQ_PROP_TOTAL));
    //---
    string message = CMessage::Text(MSG_LIB_TEXT_PEND_REQUEST_STATUS_SLTP) + ": " +
                     "\n- " + params + sl + tp +
                     "\n- " + time + ", " + attempts + ", " + wait + ", " + end + "\n";
    ::Print(message);
}
//+------------------------------------------------------------------+
