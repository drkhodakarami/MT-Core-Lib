//+------------------------------------------------------------------+
//|                                                      Message.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                             https://mql5.com/en/users/artmedia70 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link "https://mql5.com/en/users/artmedia70"
#property version "1.00"
//+------------------------------------------------------------------+
//| Include files                                                    |
//+------------------------------------------------------------------+
#include "../Defines.mqh"
#include "Translator.mqh"
//+------------------------------------------------------------------+
//| Message class                                                    |
//+------------------------------------------------------------------+
class CMessage
{
  private:
    static int            m_global_error;
    static string         m_subject;
    static string         m_text;
    static bool           m_log;
    static bool           m_push;
    static bool           m_mail;
    //--- Get a message from the necessary array by message ID
    static void           GetTextByID(const int msg_id);
    static CTranslator    m_tr_object;
    static ENUM_LANGUAGES m_country_language;
    static bool           m_tr_initialized;
    static string         m_program_name;

  public:
    //--- (1) Display a text message in the journal, send a push notification and e-mail,
    //--- (2) Display a message by ID, send a push notification and e-mail,
    //--- (3) play an audio file
    static bool   Out(const string text, const bool push = false, const bool mail = false, const string subject = NULL);
    static bool   OutByID(const int msg_id, const bool code = true);
    static bool   PlaySound(const string file_name);
    static bool   StopPlaySound(void);
    //--- Return (1) a message, (2) a code in the "(code)" format
    static string Text(const int msg_id);
    static string Retcode(const int msg_id) { return "(" + (string) msg_id + ")"; }
    //--- Set (1) the text message language index (0 - user's country language, 1 - English, 2 ... N - added by a user),
    //--- (2) email header,
    //--- the flag of sending messages (3) to the journal, (4) a mobile device, (5) a mailbox
    static void   SetLangName(const ENUM_LANGUAGES lang) { CMessage::m_country_language = lang; }
    static void   SetSubject(const string subj) { CMessage::m_subject = subj; }
    static void   SetLog(const bool flag) { CMessage::m_log = flag; }
    static void   SetPush(const bool flag) { CMessage::m_push = flag; }
    static void   SetMail(const bool flag) { CMessage::m_mail = flag; }
    static void   SetProgramName(const string name) { CMessage::m_program_name = name; }
    //--- (1) display a message in the journal by ID, (2) e-mail, (3) mobile device
    static void   ToLog(const int msg_id, const bool code = false);
    static bool   ToMail(const string message, const string subject = NULL);
    static bool   Push(const string message);
    //--- (1) send a file to FTP, (2) return an error code
    static bool   ToFTP(const string filename, const string ftp_path = NULL);
    static int    GetError(void) { return CMessage::m_global_error; }
};
//+------------------------------------------------------------------+
//| Initialization of static variables                               |
//+------------------------------------------------------------------+
int            CMessage::m_global_error     = ERR_SUCCESS;
string         CMessage::m_subject          = ::MQLInfoString(MQL_PROGRAM_NAME);
string         CMessage::m_text             = NULL;
bool           CMessage::m_log              = true;
bool           CMessage::m_push             = true;
bool           CMessage::m_mail             = false;
ENUM_LANGUAGES CMessage::m_country_language = EN;
string         CMessage::m_program_name     = "MTCoreLib";
bool           CMessage::m_tr_initialized   = false;
CTranslator    CMessage::m_tr_object        = new CTranslator();

//+------------------------------------------------------------------------------+
//| Display a text message in the journal, send a push notification and e-mail   |
//+------------------------------------------------------------------------------+
bool           CMessage::Out(const string text, const bool push = false, const bool mail = false, const string subject = NULL)
{
    bool res = true;
    if(CMessage::m_log)
        ::Print(text);
    if(push)
        res &= CMessage::Push(text);
    if(mail)
        res &= CMessage::ToMail(text, subject);
    return res;
}
//+------------------------------------------------------------------+
//| Display a message in the journal by ID,                          |
//| send a push notification and an e-mail                           |
//+------------------------------------------------------------------+
bool CMessage::OutByID(const int msg_id, const bool code = true)
{
    bool res = true;
    if(CMessage::m_log)
        CMessage::ToLog(msg_id, code);
    else
        CMessage::GetTextByID(msg_id);
    if(CMessage::m_push)
        res &= CMessage::Push(CMessage::m_text);
    if(CMessage::m_mail)
        res &= CMessage::ToMail(CMessage::m_text, CMessage::m_subject);
    return res;
}
//+------------------------------------------------------------------+
//| Display a message in the journal by a message ID                 |
//+------------------------------------------------------------------+
void CMessage::ToLog(const int msg_id, const bool code = false)
{
    CMessage::GetTextByID(msg_id);
    ::Print(m_text, (!code || msg_id > ERR_USER_ERROR_FIRST - 1 ? "" : " " + CMessage::Retcode(msg_id)));
}
//+------------------------------------------------------------------+
//| Send an email                                                    |
//+------------------------------------------------------------------+
bool CMessage::ToMail(const string message, const string subject = NULL)
{
    //--- If sending emails is disabled in the terminal
    if(!::TerminalInfoInteger(TERMINAL_EMAIL_ENABLED))
    {
        //--- display the appropriate message in the journal, write the error code and return 'false'
        CMessage::ToLog(MSG_LIB_TEXT_TERMINAL_NOT_MAIL_ENABLED, false);
        CMessage::m_global_error = ERR_MAIL_SEND_FAILED;
        return false;
    }
    //--- If failed to send a message
    if(!::SendMail(subject == NULL ? CMessage::m_subject : subject, message))
    {
        //--- write an error code, create an error description text, display it in the journal and return 'false'
        CMessage::m_global_error = ::GetLastError();
        string txt               = CMessage::Text(MSG_LIB_SYS_ERROR) + CMessage::Text(CMessage::m_global_error);
        string code              = CMessage::Retcode(CMessage::m_global_error);
        ::Print(txt + " " + code);
        return false;
    }
    //--- Successful - return 'true'
    return true;
}
//+------------------------------------------------------------------+
//| Send push notifications to a mobile device                       |
//+------------------------------------------------------------------+
bool CMessage::Push(const string message)
{
    //--- If sending push notifications is not allowed in the terminal
    if(!::TerminalInfoInteger(TERMINAL_NOTIFICATIONS_ENABLED))
    {
        //--- display the appropriate message in the journal, write the error code and return 'false'
        CMessage::ToLog(MSG_LIB_TEXT_TERMINAL_NOT_PUSH_ENABLED, false);
        CMessage::m_global_error = ERR_NOTIFICATION_SEND_FAILED;
        return false;
    }
    //--- If failed to send a message
    if(!::SendNotification(message))
    {
        //--- write an error code, create an error description text, display it in the journal and return 'false'
        CMessage::m_global_error = ::GetLastError();
        string txt               = CMessage::Text(MSG_LIB_SYS_ERROR) + CMessage::Text(CMessage::m_global_error);
        string code              = CMessage::Retcode(CMessage::m_global_error);
        ::Print(txt + " " + code);
        return false;
    }
    //--- Successful - return 'true'
    return true;
}
//+------------------------------------------------------------------+
//| Send a file to a specified address                               |
//+------------------------------------------------------------------+
bool CMessage::ToFTP(const string filename, const string ftp_path = NULL)
{
    //--- If sending files to an FTP server is not allowed in the terminal
    if(!::TerminalInfoInteger(TERMINAL_FTP_ENABLED))
    {
        //--- display the appropriate message in the journal, write the error code and return 'false'
        CMessage::ToLog(MSG_LIB_TEXT_TERMINAL_NOT_FTP_ENABLED, false);
        CMessage::m_global_error = ERR_FTP_SEND_FAILED;
        return false;
    }
    //--- If failed to send a file
    if(!::SendFTP(filename, ftp_path))
    {
        //--- write an error code, create an error description text, display it in the journal and return 'false'
        CMessage::m_global_error = ::GetLastError();
        string txt               = CMessage::Text(MSG_LIB_SYS_ERROR) + CMessage::Text(CMessage::m_global_error);
        string code              = CMessage::Retcode(CMessage::m_global_error);
        ::Print(txt + " " + code);
        return false;
    }
    return true;
}
//+------------------------------------------------------------------+
//| Play an audio file                                               |
//+------------------------------------------------------------------+
bool CMessage::PlaySound(const string file_name)
{
    if(file_name == NULL)
        return true;
    string pref              = (file_name == SND_ALERT || file_name == SND_ALERT2 || file_name == SND_CONNECT ||
                           file_name == SND_DISCONNECT || file_name == SND_EMAIL || file_name == SND_EXPERT ||
                           file_name == SND_NEWS || file_name == SND_OK || file_name == SND_REQUEST ||
                           file_name == SND_STOPS || file_name == SND_TICK || file_name == SND_TIMEOUT ||
                           file_name == SND_WAIT
                                    ? ""
                                    : "\\Files\\");
    bool   res               = ::PlaySound(pref + file_name);
    CMessage::m_global_error = (res ? ERR_SUCCESS : ::GetLastError());
    return res;
}
//+------------------------------------------------------------------+
//| Stop playing any sound                                           |
//+------------------------------------------------------------------+
bool CMessage::StopPlaySound(void)
{
    bool res                 = ::PlaySound(NULL);
    CMessage::m_global_error = (res ? ERR_SUCCESS : ::GetLastError());
    return res;
}
//+------------------------------------------------------------------+
//| Return the message text by a message ID                          |
//+------------------------------------------------------------------+
string CMessage::Text(const int msg_id)
{
    CMessage::GetTextByID(msg_id);
    return m_text;
}
//+------------------------------------------------------------------+
//| Get messages from the text array by an ID                        |
//+------------------------------------------------------------------+
void CMessage::GetTextByID(const int msg_id)
{
    if(!CMessage::m_tr_initialized)
    {
        CMessage::m_tr_object.init(CMessage::m_program_name, CMessage::m_country_language);
        CMessage::m_tr_initialized = true;
    }
    CMessage::m_text =
        (
            //--- Runtime errors (0, 4001 - 4019)
            msg_id == 0 ? CMessage::m_tr_object.tr(messages_runtime[msg_id]) :
#ifdef __MQL5__
            msg_id > 4000 && msg_id < 4020 ? CMessage::m_tr_object.tr(messages_runtime[msg_id - 4000])
                                           :
                                           //--- Runtime errors (Charts 4101 - 4116)
                msg_id > 4100 && msg_id < 4117 ? CMessage::m_tr_object.tr(messages_runtime_charts[msg_id - 4101])
                                               :
                                               //--- Runtime errors (Charts 4201 - 4205)
                msg_id > 4200 && msg_id < 4206 ? CMessage::m_tr_object.tr(messages_runtime_graph_obj[msg_id - 4201])
                                               :
                                               //--- Runtime errors (MarketInfo 4301 - 4305)
                msg_id > 4300 && msg_id < 4306 ? CMessage::m_tr_object.tr(messages_runtime_market[msg_id - 4301])
                                               :
                                               //--- Runtime errors (Access to history 4401 - 4407)
                msg_id > 4400 && msg_id < 4408 ? CMessage::m_tr_object.tr(messages_runtime_history[msg_id - 4401])
                                               :
                                               //--- Runtime errors (Global Variables 4501 - 4524)
                msg_id > 4500 && msg_id < 4525 ? CMessage::m_tr_object.tr(messages_runtime_global[msg_id - 4501])
                                               :
                                               //--- Runtime errors (Custom indicators 4601 - 4603)
                msg_id > 4600 && msg_id < 4604 ? CMessage::m_tr_object.tr(messages_runtime_custom_indicator[msg_id - 4601])
                                               :
                                               //--- Runtime errors (Account 4701 - 4758)
                msg_id > 4700 && msg_id < 4759 ? CMessage::m_tr_object.tr(messages_runtime_account[msg_id - 4701])
                                               :
                                               //--- Runtime errors (Indicators 4801 - 4812)
                msg_id > 4800 && msg_id < 4813 ? CMessage::m_tr_object.tr(messages_runtime_indicator[msg_id - 4801])
                                               :
                                               //--- Runtime errors (Market depth 4901 - 4904)
                msg_id > 4900 && msg_id < 4905 ? CMessage::m_tr_object.tr(messages_runtime_books[msg_id - 4901])
                                               :
                                               //--- Runtime errors (File operations 5001 - 5027)
                msg_id > 5000 && msg_id < 5028 ? CMessage::m_tr_object.tr(messages_runtime_files[msg_id - 5001])
                                               :
                                               //--- Runtime errors (Converting strings 5030 - 5044)
                msg_id > 5029 && msg_id < 5045 ? CMessage::m_tr_object.tr(messages_runtime_string[msg_id - 5030])
                                               :
                                               //--- Runtime errors (Working with arrays 5050 - 5063)
                msg_id > 5049 && msg_id < 5064 ? CMessage::m_tr_object.tr(messages_runtime_array[msg_id - 5050])
                                               :
                                               //--- Runtime errors (Working with OpenCL 5100 - 5114)
                msg_id > 5099 && msg_id < 5115 ? CMessage::m_tr_object.tr(messages_runtime_opencl[msg_id - 5100])
                                               :
                                               //--- Runtime errors (Working with WebRequest() 5200 - 5203)
                msg_id > 5199 && msg_id < 5204 ? CMessage::m_tr_object.tr(messages_runtime_webrequest[msg_id - 5200])
                                               :
                                               //--- Runtime errors (Working with network (sockets) 5270 - 5275)
                msg_id > 5269 && msg_id < 5276 ? CMessage::m_tr_object.tr(messages_runtime_netsocket[msg_id - 5270])
                                               :
                                               //--- Runtime errors (Custom symbols 5300 - 5310)
                msg_id > 5299 && msg_id < 5311 ? CMessage::m_tr_object.tr(messages_runtime_custom_symbol[msg_id - 5300])
                                               :
                                               //--- Runtime errors (Economic calendar 5400 - 5402)
                msg_id > 5399 && msg_id < 5403 ? CMessage::m_tr_object.tr(messages_runtime_calendar[msg_id - 5400])
                                               :
                                               //--- Trade server return codes (10004 - 10045)
                msg_id > 10003 && msg_id < 10046 ? CMessage::m_tr_object.tr(messages_ts_ret_code[msg_id - 10004])
                                                 :
#else    // MQL4
            msg_id > 0 && msg_id < 10      ? CMessage::m_tr_object.tr(messages_ts_ret_code_mql4[msg_id])
            : msg_id > 63 && msg_id < 66   ? CMessage::m_tr_object.tr(messages_ts_ret_code_mql4[msg_id - 54])
            : msg_id > 127 && msg_id < 151 ? CMessage::m_tr_object.tr(messages_ts_ret_code_mql4[msg_id - 116])
            : msg_id < 4000                ? CMessage::m_tr_object.tr(messages_ts_ret_code_mql4[26])
                                           :
                            //--- MQL4 runtime errors (4000 - 4030)
                msg_id < 4031 ? CMessage::m_tr_object.tr(messages_runtime_4000_4030[msg_id - 4000])
                              :
                              //--- MQL4 runtime errors (4050 - 4075)
                msg_id > 4049 && msg_id < 4076 ? CMessage::m_tr_object.tr(messages_runtime_4050_4075[msg_id - 4050])
                                               :
                                               //--- MQL4 runtime errors (4099 - 4112)
                msg_id > 4098 && msg_id < 4113 ? CMessage::m_tr_object.tr(messages_runtime_4099_4112[msg_id - 4099])
                                               :
                                               //--- MQL4 runtime errors (4200 - 4220)
                msg_id > 4199 && msg_id < 4221 ? CMessage::m_tr_object.tr(messages_runtime_4200_4220[msg_id - 4200])
                                               :
                                               //--- MQL4 runtime errors (4250 - 4266)
                msg_id > 4249 && msg_id < 4267 ? CMessage::m_tr_object.tr(messages_runtime_4250_4266[msg_id - 4250])
                                               :
                                               //--- MQL4 runtime errors (5001 - 5029)
                msg_id > 5000 && msg_id < 5030 ? CMessage::m_tr_object.tr(messages_runtime_5001_5029[msg_id - 5001])
                                               :
                                               //--- MQL4 runtime errors (5200 - 5203)
                msg_id > 5199 && msg_id < 5204 ? CMessage::m_tr_object.tr(messages_runtime_5200_5203[msg_id - 5200])
                                               :
#endif
                                                 //--- Library messages (ERR_USER_ERROR_FIRST)
                msg_id > ERR_USER_ERROR_FIRST - 1 ? CMessage::m_tr_object.tr(messages_library[msg_id - ERR_USER_ERROR_FIRST])
                                                  : CMessage::m_tr_object.tr(messages_library[MSG_LIB_SYS_ERROR_CODE_OUT_OF_RANGE - ERR_USER_ERROR_FIRST]));
}
//+------------------------------------------------------------------+
