//+------------------------------------------------------------------+
//|                                                      BaseObj.mqh |
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
#include "../Services/MTLib.mqh"
#include <Arrays/ArrayObj.mqh>
//+------------------------------------------------------------------+
//| Base object event class for all library objects                  |
//+------------------------------------------------------------------+
class CEventBaseObj : public CObject
{
private:
    long   m_time;
    long   m_chart_id;
    ushort m_event_id;
    long   m_lparam;
    double m_dparam;
    string m_sparam;

public:
    void   Time(const long time) { this.m_time = time; }
    long   Time(void) const { return this.m_time; }
    void   ChartID(const long chart_id) { this.m_chart_id = chart_id; }
    long   ChartID(void) const { return this.m_chart_id; }
    void   ID(const ushort id) { this.m_event_id = id; }
    ushort ID(void) const { return this.m_event_id; }
    void   LParam(const long lparam) { this.m_lparam = lparam; }
    long   LParam(void) const { return this.m_lparam; }
    void   DParam(const double dparam) { this.m_dparam = dparam; }
    double DParam(void) const { return this.m_dparam; }
    void   SParam(const string sparam) { this.m_sparam = sparam; }
    string SParam(void) const { return this.m_sparam; }

    //--- Constructor
    CEventBaseObj(const ushort event_id, const long lparam, const double dparam, const string sparam) :
        m_chart_id(::ChartID())
    {
        this.m_event_id = event_id;
        this.m_lparam   = lparam;
        this.m_dparam   = dparam;
        this.m_sparam   = sparam;
    }
    //--- Comparison method to search for identical event objects
    virtual int Compare(const CObject *node, const int mode = 0) const
    {
        const CEventBaseObj *compared = node;
        return (this.ID() > compared.ID()           ? 1
                : this.ID() < compared.ID()         ? -1
                : this.LParam() > compared.LParam() ? 1
                : this.LParam() < compared.LParam() ? -1
                : this.DParam() > compared.DParam() ? 1
                : this.DParam() < compared.DParam() ? -1
                : this.SParam() > compared.SParam() ? 1
                : this.SParam() < compared.SParam() ? -1
                                                    : 0);
    }
};
//+------------------------------------------------------------------+
//| Library object's base event class                                |
//+------------------------------------------------------------------+
class CBaseEvent : public CObject
{
  private:
    ENUM_BASE_EVENT_REASON m_reason;
    int                    m_event_id;
    double                 m_value;

  public:
    ENUM_BASE_EVENT_REASON Reason(void) const { return this.m_reason; }
    int                    ID(void) const { return this.m_event_id; }
    double                 Value(void) const { return this.m_value; }
    //--- Constructor
    CBaseEvent(const int event_id, const ENUM_BASE_EVENT_REASON reason, const double value) :
        m_reason(reason),
        m_event_id(event_id),
        m_value(value) {}
    //--- Comparison method to search for identical event objects
    virtual int Compare(const CObject *node, const int mode = 0) const
    {
        const CBaseEvent *compared = node;
        return (
            this.Reason() > compared.Reason()   ? 1
            : this.Reason() < compared.Reason() ? -1
            : this.ID() > compared.ID()         ? 1
            : this.ID() < compared.ID()         ? -1
                                                : 0);
    }
};
//+------------------------------------------------------------------+
//| Base object class for all library objects                        |
//+------------------------------------------------------------------+
#define CONTROLS_TOTAL (10)    // The size of the second array dimension
class CBaseObj : public CObject
{
  private:
    int m_long_prop_total;      // Number of integer properties of the object
    int m_double_prop_total;    // Number of double properties of the object
    //--- Fill in the object property array
    template<typename T>
    bool FillPropertySettings(const int index, T &array[][CONTROLS_TOTAL], T &array_prev[][CONTROLS_TOTAL], int &event_id);

  protected:
    CArrayObj m_list_events_base;    // Object base event list
    CArrayObj m_list_events;         // Object event list
    MqlTick   m_tick;                // Tick structure for receiving quote data
    double    m_hash_sum;            // Object data hash sum
    double    m_hash_sum_prev;       // Object data hash sum during the previous check
    int       m_digits_currency;     // Number of decimal places in an account currency
    int       m_global_error;        // Global error code
    long      m_chart_id;            // Control program chart ID
    bool      m_is_event;            // Object event flag
    int       m_event_code;          // Object event code
    int       m_event_id;            // Event ID (equal to the object property value)
    string    m_name;                // Object name
    string    m_folder_name;         // Name of the folder storing CBaseObj descendant objects
    bool      m_first_start;         // First launch flag
    int       m_type;                // Object type (corresponds to the collection IDs)
    //--- Data for storing, controlling and returning tracked properties:
    //--- [Property index][0] Controlled property increase value
    //--- [Property index][1] Controlled property decrease value
    //--- [Property index][2] Controlled property value level
    //--- [Property index][3] Property value
    //--- [Property index][4] Property value change
    //--- [Property index][5] Flag of a property change exceeding the increase value
    //--- [Property index][6] Flag of a property change exceeding the decrease value
    //--- [Property index][7] Flag of a property increase exceeding the control level
    //--- [Property index][8] Flag of a property decrease being less than the control level
    //--- [Property index][9] Flag of a property value being equal to the control level
    long      m_long_prop_event[][CONTROLS_TOTAL];           // The array for storing object's integer properties values and controlled property change values
    double    m_double_prop_event[][CONTROLS_TOTAL];         // The array for storing object's real properties values and controlled property change values
    long      m_long_prop_event_prev[][CONTROLS_TOTAL];      // The array for storing object's controlled integer properties values during the previous check
    double    m_double_prop_event_prev[][CONTROLS_TOTAL];    // The array for storing object's controlled real properties values during the previous check

    //--- Return (1) time in milliseconds, (2) milliseconds from the MqlTick time value
    long      TickTime(void) const { return #ifdef __MQL5__ this.m_tick.time_msc #else this.m_tick.time * 1000 #endif; }
    ushort    MSCfromTime(const long time_msc) const { return #ifdef __MQL5__ ushort(this.TickTime() % 1000) #else 0 #endif; }
    //--- return the flag of the event code presence in the event object
    bool      IsPresentEventFlag(const int change_code) const { return (this.m_event_code & change_code) == change_code; }
    //--- Return the number of decimal places of the account currency
    int       DigitsCurrency(void) const { return this.m_digits_currency; }
    //--- Returns the number of decimal places in the 'double' value
    int       GetDigits(const double value) const;

    //--- Set the size of the array of controlled (1) integer and (2) real object properties
    bool      SetControlDataArraySizeLong(const int size);
    bool      SetControlDataArraySizeDouble(const int size);
    //--- Check the array size of object properties
    bool      CheckControlDataArraySize(bool check_long = true);

    //--- Set the (1) controlled value and (2) object property change value
    template<typename T>
    void SetControlledValue(const int property, const T value);
    template<typename T>
    void SetControlledChangedValue(const int property, const T value);

    //--- Set the value of the pbject property controlled (1) increase, (2) decrease, (3) control level
    template<typename T>
    void SetControlledValueINC(const int property, const T value);
    template<typename T>
    void SetControlledValueDEC(const int property, const T value);
    template<typename T>
    void SetControlledValueLEVEL(const int property, const T value);

    //--- Set the flag of a property change exceeding the (1) increase and (2) decrease values
    template<typename T>
    void SetControlledFlagINC(const int property, const T value);
    template<typename T>
    void SetControlledFlagDEC(const int property, const T value);
    //--- Set the flag of a property change (1) exceeding, (2) being less than the control level, (3) being equal to the level
    template<typename T>
    void SetControlledFlagMORE(const int property, const T value);
    template<typename T>
    void SetControlledFlagLESS(const int property, const T value);
    template<typename T>
    void         SetControlledFlagEQUAL(const int property, const T value);

    //--- Return the set value of the controlled (1) integer and (2) real object properties increase
    long         GetControlledValueLongINC(const int property) const { return this.m_long_prop_event[property][0]; }
    double       GetControlledValueDoubleINC(const int property) const { return this.m_double_prop_event[property - this.m_long_prop_total][0]; }
    //--- Return the set value of the controlled (1) integer and (2) real object properties decrease
    long         GetControlledValueLongDEC(const int property) const { return this.m_long_prop_event[property][1]; }
    double       GetControlledValueDoubleDEC(const int property) const { return this.m_double_prop_event[property - this.m_long_prop_total][1]; }
    //--- Return the control level of object's (1) integer and (2) real properties
    long         GetControlledValueLongLEVEL(const int property) const { return this.m_long_prop_event[property][2]; }
    double       GetControlledValueDoubleLEVEL(const int property) const { return this.m_double_prop_event[property - this.m_long_prop_total][2]; }
    //--- Return the value of the object (1) integer and (2) real property
    long         GetControlledValueLong(const int property) const { return this.m_long_prop_event[property][3]; }
    double       GetControlledValueDouble(const int property) const { return this.m_double_prop_event[property - this.m_long_prop_total][3]; }
    //--- Return the change value of the controlled (1) integer and (2) real object property
    long         GetControlledChangedValueLong(const int property) const { return this.m_long_prop_event[property][4]; }
    double       GetControlledChangedValueDouble(const int property) const { return this.m_double_prop_event[property - this.m_long_prop_total][4]; }

    //--- Return the flag of an (1) integer and (2) real property value change exceeding the increase value
    long         GetControlledFlagLongINC(const int property) const { return this.m_long_prop_event[property][5]; }
    double       GetControlledFlagDoubleINC(const int property) const { return this.m_double_prop_event[property - this.m_long_prop_total][5]; }
    //--- Return the flag of an (1) integer and (2) real property value change exceeding the decrease value
    long         GetControlledFlagLongDEC(const int property) const { return this.m_long_prop_event[property][6]; }
    double       GetControlledFlagDoubleDEC(const int property) const { return this.m_double_prop_event[property - this.m_long_prop_total][6]; }
    //--- Return the flag of an (1) integer and (2) real property value increase exceeding the control level
    long         GetControlledFlagLongMORE(const int property) const { return this.m_long_prop_event[property][7]; }
    double       GetControlledFlagDoubleMORE(const int property) const { return this.m_double_prop_event[property - this.m_long_prop_total][7]; }
    //--- Return the flag of an (1) integer and (2) real property value decrease being less than the control level
    long         GetControlledFlagLongLESS(const int property) const { return this.m_long_prop_event[property][8]; }
    double       GetControlledFlagDoubleLESS(const int property) const { return this.m_double_prop_event[property - this.m_long_prop_total][8]; }
    //--- Return the flag of an (1) integer and (2) real property being equal to the control level
    long         GetControlledFlagLongEQUAL(const int property) const { return this.m_long_prop_event[property][9]; }
    double       GetControlledFlagDoubleEQUAL(const int property) const { return this.m_double_prop_event[property - this.m_long_prop_total][9]; }

    //--- (1) Pack a 'ushort' number to a passed 'long' number
    //--- (2) convert a 'ushort' value to a specified 'long' number byte
    //--- (Index 0 => bytes 0-1, Index 1 => bytes 2-3, Index 2 => bytes 4-5)
    long         UshortToLong(const ushort ushort_value, const uchar to_byte, long &long_value);
    long         UshortToByte(const ushort value, const uchar index) const;

  public:
    //--- Reset the variables of (1) tracked and (2) controlled object data (can be reset in the descendants)
    void           ResetChangesParams(void);
    virtual void   ResetControlsParams(void);
    //--- Add the (1) object event and (2) the object event reason to the list
    bool           EventAdd(const ushort event_id, const long lparam, const double dparam, const string sparam);
    bool           EventBaseAdd(const int event_id, const ENUM_BASE_EVENT_REASON reason, const double value);
    //--- Return the occurred event flag to the object data
    bool           IsEvent(void) const { return this.m_is_event; }
    //--- Return (1) the list of events, (2) the object event code and (3) the global error code
    CArrayObj     *GetListEvents(void) { return &this.m_list_events; }
    int            GetEventCode(void) const { return this.m_event_code; }
    int            GetError(void) const { return this.m_global_error; }
    //--- Return (1) an event object and (2) a base event by its number in the list
    CEventBaseObj *GetEvent(const int shift = WRONG_VALUE, const bool check_out = true);
    CBaseEvent    *GetEventBase(const int index);
    //--- Return the number of (1) object events
    int            GetEventsTotal(void) const { return this.m_list_events.Total(); }
    //--- (1) Set and (2) return the chart ID of the control program
    void           SetChartID(const long id) { this.m_chart_id = id; }
    long           GetChartID(void) const { return this.m_chart_id; }
    //--- (1) Set the sub-folder name, (2) return the folder name for storing descendant object files
    void           SetSubFolderName(const string name) { this.m_folder_name = DIRECTORY + name; }
    string         GetFolderName(void) const { return this.m_folder_name; }
    //--- Return the object name
    string         GetName(void) const { return this.m_name; }
    //--- Update the object data to search for changes (Calling from the descendants: CBaseObj::Refresh())
    virtual void   Refresh(void);
    //--- Return an object type
    virtual int    Type(void) const { return this.m_type; }
    //--- Return an object event description
    string         EventDescription(const int                    property,
                                    const ENUM_BASE_EVENT_REASON reason,
                                    const int                    source,
                                    const string                 value,
                                    const string                 property_descr,
                                    const int                    digits);
    //--- Constructor
    CBaseObj();
};
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CBaseObj::CBaseObj() :
    m_global_error(ERR_SUCCESS),
    m_hash_sum(0), m_hash_sum_prev(0),
    m_is_event(false), m_event_code(WRONG_VALUE),
    m_chart_id(::ChartID()),
    m_folder_name(DIRECTORY),
    m_name(__FUNCTION__),
    m_long_prop_total(0),
    m_double_prop_total(0),
    m_first_start(true)
{
    ::ArrayResize(this.m_long_prop_event, 0, 100);
    ::ArrayResize(this.m_double_prop_event, 0, 100);
    ::ArrayResize(this.m_long_prop_event_prev, 0, 100);
    ::ArrayResize(this.m_double_prop_event_prev, 0, 100);
    ::ZeroMemory(this.m_tick);
    this.m_digits_currency = (#ifdef __MQL5__(int) ::AccountInfoInteger(ACCOUNT_CURRENCY_DIGITS) #else 2 #endif);
    this.m_list_events.Clear();
    this.m_list_events.Sort();
    this.m_list_events_base.Clear();
    this.m_list_events_base.Sort();
}
//+------------------------------------------------------------------+
//| Update the object data to search changes in them                 |
//| Call from descendants: CBaseObj::Refresh()                       |
//+------------------------------------------------------------------+
void CBaseObj::Refresh(void)
{
    //--- Check the size of the arrays, Exit if it is zero
    if(!this.CheckControlDataArraySize() || !this.CheckControlDataArraySize(false))
        return;
    //--- Reset the event flag and clear all lists
    this.m_is_event = false;
    this.m_list_events.Clear();
    this.m_list_events.Sort();
    this.m_list_events_base.Clear();
    this.m_list_events_base.Sort();
    //--- Fill in the array of integer properties and control their changes
    for(int i = 0; i < this.m_long_prop_total; i++)
        if(!this.FillPropertySettings(i, this.m_long_prop_event, this.m_long_prop_event_prev, this.m_event_id))
            continue;
    //--- Fill in the array of real properties and control their changes
    for(int i = 0; i < this.m_double_prop_total; i++)
        if(!this.FillPropertySettings(i, this.m_double_prop_event, this.m_double_prop_event_prev, this.m_event_id))
            continue;
    //--- First launch
    if(this.m_first_start)
    {
        ::ArrayCopy(this.m_long_prop_event_prev, this.m_long_prop_event);
        ::ArrayCopy(this.m_double_prop_event_prev, this.m_double_prop_event);
        this.m_hash_sum_prev = this.m_hash_sum;
        this.m_first_start   = false;
        this.m_is_event      = false;
        this.m_list_events_base.Clear();
        this.m_list_events_base.Sort();
        return;
    }
}
//+------------------------------------------------------------------+
//| Fill in the object property array                                |
//+------------------------------------------------------------------+
template<typename T>
bool CBaseObj::FillPropertySettings(const int index, T &array[][CONTROLS_TOTAL], T &array_prev[][CONTROLS_TOTAL], int &event_id)
{
    //--- Data in the array cells
    //--- [Property index][0] Controlled property increase value
    //--- [Property index][1] Controlled property decrease value
    //--- [Property index][2] Controlled property value level
    //--- [Property index][3] Property value
    //--- [Property index][4] Property value change
    //--- [Property index][5] Flag of a property change exceeding the increase value
    //--- [Property index][6] Flag of a property change exceeding the decrease value
    //--- [Property index][7] Flag of a property increase exceeding the control level
    //--- [Property index][8] Flag of a property decrease being less than the control level
    //--- [Property index][9] Flag of a property value being equal to the control level

    //--- If controlled values are not set, exit with 'false'
    if(this.m_first_start)
        return false;
    //--- Set the shift of the 'double' property index and the event ID
    event_id = index + (typename(T) == "double" ? this.m_long_prop_total : 0);
    //--- Reset all event flags
    for(int j = 5; j < CONTROLS_TOTAL; j++)
        array[index][j] = false;
    //--- Property change value
    T value         = array[index][3] - array_prev[index][3];
    array[index][4] = value;
    //--- If the controlled property increase value is set
    if(array[index][0] < LONG_MAX)
    {
        //--- If the property change value exceeds the controlled increase value - there is an event,
        //--- add the event to the list, set the flag and save the new property value size
        if(value > 0 && value > array[index][0])
        {
            if(this.EventBaseAdd(event_id, BASE_EVENT_REASON_INC, value))
            {
                array[index][5]      = true;
                array_prev[index][4] = value;
            }
        }
    }
    //--- If the controlled property decrease value is set
    if(array[index][1] < LONG_MAX)
    {
        //--- If the property change value exceeds the controlled decrease value - there is an event,
        //--- add the event to the list, set the flag and save the new property value size
        if(value < 0 && fabs(value) > array[index][1])
        {
            if(this.EventBaseAdd(event_id, BASE_EVENT_REASON_DEC, value))
            {
                array[index][6]      = true;
                array_prev[index][4] = value;
            }
        }
    }
    //--- If the controlled level value is set
    if(array[index][2] < LONG_MAX)
    {
        value = array[index][3] - array[index][2];
        //--- If a property value exceeds the control level, there is an event
        //--- add the event to the list and set the flag
        if(value > 0 && array_prev[index][3] <= array[index][2])
        {
            if(this.EventBaseAdd(event_id, BASE_EVENT_REASON_MORE_THEN, array[index][2]))
                array[index][7] = true;
        }
        //--- If a property value is less than the control level, there is an event,
        //--- add the event to the list and set the flag
        else if(value < 0 && array_prev[index][3] >= array[index][2])
        {
            if(this.EventBaseAdd(event_id, BASE_EVENT_REASON_LESS_THEN, array[index][2]))
                array[index][8] = true;
        }
        //--- If a property value is equal to the control level, there is an event,
        //--- add the event to the list and set the flag
        else if(value == 0 && array_prev[index][3] != array[index][2])
        {
            if(this.EventBaseAdd(event_id, BASE_EVENT_REASON_EQUALS, array[index][2]))
                array[index][9] = true;
        }
    }
    //--- Save the current property value as a previous one
    array_prev[index][3] = array[index][3];
    return true;
}
//+------------------------------------------------------------------+
//| Set the size of the arrays of the object integer properties      |
//+------------------------------------------------------------------+
bool CBaseObj::SetControlDataArraySizeLong(const int size)
{
    int x                  = (#ifdef __MQL4__ CONTROLS_TOTAL #else 1 #endif);
    this.m_long_prop_total = ::ArrayResize(this.m_long_prop_event, size, 100) / x;
    return ((::ArrayResize(this.m_long_prop_event_prev, size, 100) / x) == size && this.m_long_prop_total == size ? true : false);
}
//+------------------------------------------------------------------+
//| Set the size of the arrays of the object real properties         |
//+------------------------------------------------------------------+
bool CBaseObj::SetControlDataArraySizeDouble(const int size)
{
    int x                    = (#ifdef __MQL4__ CONTROLS_TOTAL #else 1 #endif);
    this.m_double_prop_total = ::ArrayResize(this.m_double_prop_event, size, 100) / x;
    return ((::ArrayResize(this.m_double_prop_event_prev, size, 100) / x) == size && this.m_double_prop_total == size ? true : false);
}
//+------------------------------------------------------------------+
//| Check the array size of object properties                        |
//+------------------------------------------------------------------+
bool CBaseObj::CheckControlDataArraySize(bool check_long = true)
{
    string txt1 = "";
    string txt2 = "";
    string txt3 = "";
    string txt4 = "";
    bool   res  = true;
    if(check_long)
    {
        if(this.m_long_prop_total == 0)
        {
            txt1 = TextByLanguage("Controlled integer properties data array has zero size");
            txt2 = TextByLanguage("You should first set the size of the array equal to the number of object integer properties");
            txt3 = TextByLanguage("To do this, use CBaseObj::SetControlDataArraySizeLong() method");
            txt4 = TextByLanguage("with value of number of integer properties of object in \"size\" parameter");
            res  = false;
        }
    }
    else if(this.m_double_prop_total == 0)
    {
        txt1 = TextByLanguage("Controlled double properties data array has zero size");
        txt2 = TextByLanguage("You should first set the size of the array equal to the number of object double properties");
        txt3 = TextByLanguage("To do this, use CBaseObj::SetControlDataArraySizeDouble() method");
        txt4 = TextByLanguage("with the value of the number of double properties of the object in the parameter \"size\"");
        res  = false;
    }
    if(res)
        return true;
#ifdef __MQL5__
    ::Print(DFUN, "\n", txt1, "\n", txt2, "\n", txt3, "\n", txt4);
#else
    ::Print(DFUN);
    ::Print(txt1);
    ::Print(txt2);
    ::Print(txt3);
    ::Print(txt4);
#endif
    this.m_global_error = ERR_ZEROSIZE_ARRAY;
    return false;
}
//+------------------------------------------------------------------+
//| Reset the variables of controlled object data values             |
//+------------------------------------------------------------------+
void CBaseObj::ResetControlsParams(void)
{
    if(!this.CheckControlDataArraySize(true) || !this.CheckControlDataArraySize(false))
        return;
    //--- Data in the array cells
    //--- [Property index][0] Controlled property increase value
    //--- [Property index][1] Controlled property decrease value
    //--- [Property index][2] Controlled property value level
    for(int i = this.m_long_prop_total - 1; i > WRONG_VALUE; i--)
        for(int j = 0; j < 3; j++)
            this.m_long_prop_event[i][j] = LONG_MAX;
    for(int i = this.m_double_prop_total - 1; i > WRONG_VALUE; i--)
        for(int j = 0; j < 3; j++)
            this.m_double_prop_event[i][j] = (double) LONG_MAX;
}
//+------------------------------------------------------------------+
//| Reset the variables of tracked object data                       |
//+------------------------------------------------------------------+
void CBaseObj::ResetChangesParams(void)
{
    if(!this.CheckControlDataArraySize(true) || !this.CheckControlDataArraySize(false))
        return;
    this.m_list_events.Clear();
    this.m_list_events.Sort();
    this.m_list_events_base.Clear();
    this.m_list_events_base.Sort();
    //--- Data in the array cells
    //--- [Property index][3] Property value
    //--- [Property index][4] Property value change
    //--- [Property index][5] Flag of a property change exceeding the increase value
    //--- [Property index][6] Flag of a property change exceeding the decrease value
    //--- [Property index][7] Flag of a property increase exceeding the control level
    //--- [Property index][8] Flag of a property decrease being less than the control level
    //--- [Property index][9] Flag of a property value being equal to the controlled value
    for(int i = this.m_long_prop_total - 1; i > WRONG_VALUE; i--)
        for(int j = 3; j < CONTROLS_TOTAL; j++)
            this.m_long_prop_event[i][j] = (j < 5 ? LONG_MAX : 0);
    for(int i = this.m_double_prop_total - 1; i > WRONG_VALUE; i--)
        for(int j = 3; j < CONTROLS_TOTAL; j++)
            this.m_double_prop_event[i][j] = (j < 5 ? (double) LONG_MAX : 0);
}
//+------------------------------------------------------------------+
//| Add the event object to the list                                 |
//+------------------------------------------------------------------+
bool CBaseObj::EventAdd(const ushort event_id, const long lparam, const double dparam, const string sparam)
{
    CEventBaseObj *event = new CEventBaseObj(event_id, lparam, dparam, sparam);
    if(event == NULL) return false;
    this.m_list_events.Sort();
    if(this.m_list_events.Search(event) > WRONG_VALUE)
    {
        delete event;
        return false;
    }
    return this.m_list_events.Add(event);
}
//+------------------------------------------------------------------+
//| Add the object base event to the list                            |
//+------------------------------------------------------------------+
bool CBaseObj::EventBaseAdd(const int event_id, const ENUM_BASE_EVENT_REASON reason, const double value)
{
    CBaseEvent *event = new CBaseEvent(event_id, reason, value);
    if(event == NULL)
        return false;
    this.m_list_events_base.Sort();
    if(this.m_list_events_base.Search(event) > WRONG_VALUE)
    {
        delete event;
        return false;
    }
    return this.m_list_events_base.Add(event);
}
//+------------------------------------------------------------------+
//| Return the object event by its index in the list                 |
//+------------------------------------------------------------------+
CEventBaseObj *CBaseObj::GetEvent(const int shift = WRONG_VALUE, const bool check_out = true)
{
    int total = this.m_list_events.Total();
    if(total == 0 || (!check_out && shift > total - 1)) return NULL;
    int            index = (shift <= 0 ? total - 1 : shift > total - 1 ? 0
                                                                       : total - shift - 1);
    CEventBaseObj *event = this.m_list_events.At(index);
    return (event != NULL ? event : NULL);
}
//+------------------------------------------------------------------+
//| Return a base event by its index in the list                     |
//+------------------------------------------------------------------+
CBaseEvent *CBaseObj::GetEventBase(const int index)
{
    int total = this.m_list_events_base.Total();
    if(total == 0 || index < 0 || index > total - 1)
        return NULL;
    CBaseEvent *event = this.m_list_events_base.At(index);
    return (event != NULL ? event : NULL);
}
//+------------------------------------------------------------------+
//| Return the number of decimal places in the 'double' value        |
//+------------------------------------------------------------------+
int CBaseObj::GetDigits(const double value) const
{
    string val_str = (string) value;
    int    len     = ::StringLen(val_str);
    int    n       = len - ::StringFind(val_str, ".", 0) - 1;
    if(::StringSubstr(val_str, len - 1, 1) == "0") n--;
    return n;
}
//+------------------------------------------------------------------+
//| Methods of setting controlled parameters                         |
//+------------------------------------------------------------------+
//--- Data for storing, controlling and returning tracked properties:
//--- [Property index][0] Controlled property increase value
//--- [Property index][1] Controlled property decrease value
//--- [Property index][2] Controlled property value level
//--- [Property index][3] Property value
//--- [Property index][4] Property value change
//--- [Property index][5] Flag of a property change exceeding the increase value
//--- [Property index][6] Flag of a property change exceeding the decrease value
//--- [Property index][7] Flag of a property increase exceeding the control level
//--- [Property index][8] Flag of a property decrease being less than the control level
//--- [Property index][9] Flag of a property value being equal to the control level
//+------------------------------------------------------------------+
//| Set the value of the controlled increase of object properties    |
//+------------------------------------------------------------------+
template<typename T>
void CBaseObj::SetControlledValueINC(const int property, const T value)
{
    if(property < this.m_long_prop_total)
        this.m_long_prop_event[property][0] = (long) value;
    else
        this.m_double_prop_event[property - this.m_long_prop_total][0] = (double) value;
}
//+------------------------------------------------------------------+
//| Set the value of the controlled decrease of object properties    |
//+------------------------------------------------------------------+
template<typename T>
void CBaseObj::SetControlledValueDEC(const int property, const T value)
{
    if(property < this.m_long_prop_total)
        this.m_long_prop_event[property][1] = (long) value;
    else
        this.m_double_prop_event[property - this.m_long_prop_total][1] = (double) value;
}
//+------------------------------------------------------------------+
//| Set the control level of object properties                       |
//+------------------------------------------------------------------+
template<typename T>
void CBaseObj::SetControlledValueLEVEL(const int property, const T value)
{
    if(property < this.m_long_prop_total)
        this.m_long_prop_event[property][2] = (long) value;
    else
        this.m_double_prop_event[property - this.m_long_prop_total][2] = (double) value;
}
//+------------------------------------------------------------------+
//| Set the object property value                                    |
//+------------------------------------------------------------------+
template<typename T>
void CBaseObj::SetControlledValue(const int property, const T value)
{
    if(property < this.m_long_prop_total)
        this.m_long_prop_event[property][3] = (long) value;
    else
        this.m_double_prop_event[property - this.m_long_prop_total][3] = (double) value;
}
//+------------------------------------------------------------------+
//| Set the object property change value                             |
//+------------------------------------------------------------------+
template<typename T>
void CBaseObj::SetControlledChangedValue(const int property, const T value)
{
    if(property < this.m_long_prop_total)
        this.m_long_prop_event[property][4] = (long) value;
    else
        this.m_double_prop_event[property - this.m_long_prop_total][4] = (double) value;
}
//+------------------------------------------------------------------+
//| Set the flag of the property value change                        |
//| exceeding the increase value                                     |
//+------------------------------------------------------------------+
template<typename T>
void CBaseObj::SetControlledFlagINC(const int property, const T value)
{
    if(property < this.m_long_prop_total)
        this.m_long_prop_event[property][5] = (long) value;
    else
        this.m_double_prop_event[property - this.m_long_prop_total][5] = (double) value;
}
//+------------------------------------------------------------------+
//| Set the flag of the property value change                        |
//| exceeding the decrease value                                     |
//+------------------------------------------------------------------+
template<typename T>
void CBaseObj::SetControlledFlagDEC(const int property, const T value)
{
    if(property < this.m_long_prop_total)
        this.m_long_prop_event[property][6] = (long) value;
    else
        this.m_double_prop_event[property - this.m_long_prop_total][6] = (double) value;
}
//+------------------------------------------------------------------+
//| Set the flag of the property value increase                      |
//| exceeding the control level                                      |
//+------------------------------------------------------------------+
template<typename T>
void CBaseObj::SetControlledFlagMORE(const int property, const T value)
{
    if(property < this.m_long_prop_total)
        this.m_long_prop_event[property][7] = (long) value;
    else
        this.m_double_prop_event[property - this.m_long_prop_total][7] = (double) value;
}
//+------------------------------------------------------------------+
//| Set the flag of the property value decrease                      |
//| being less than the control level                                |
//+------------------------------------------------------------------+
template<typename T>
void CBaseObj::SetControlledFlagLESS(const int property, const T value)
{
    if(property < this.m_long_prop_total)
        this.m_long_prop_event[property][8] = (long) value;
    else
        this.m_double_prop_event[property - this.m_long_prop_total][8] = (double) value;
}
//+------------------------------------------------------------------+
//| Set the flag of the property value being equal to the            |
//| control level                                                    |
//+------------------------------------------------------------------+
template<typename T>
void CBaseObj::SetControlledFlagEQUAL(const int property, const T value)
{
    if(property < this.m_long_prop_total)
        this.m_long_prop_event[property][9] = (long) value;
    else
        this.m_double_prop_event[property - this.m_long_prop_total][9] = (double) value;
}
//+------------------------------------------------------------------+
//| Pack a 'ushort' number to a passed 'long' number                 |
//+------------------------------------------------------------------+
long CBaseObj::UshortToLong(const ushort ushort_value, const uchar index, long &long_value)
{
    if(index > 3)
    {
        ::Print(DFUN, TextByLanguage("Error. The \"index\" value must be between 0 - 3"));
        return 0;
    }
    return (long_value |= UshortToByte(ushort_value, index));
}
//+------------------------------------------------------------------+
//| Convert a 'ushort' value to a specified 'long' number byte       |
//+------------------------------------------------------------------+
long CBaseObj::UshortToByte(const ushort value, const uchar index) const
{
    if(index > 3)
    {
        ::Print(DFUN, TextByLanguage("Error. The \"index\" value must be between 0 - 3"));
        return 0;
    }
    return (long) value << (16 * index);
}
//+------------------------------------------------------------------+
//| Return an object event description                               |
//+------------------------------------------------------------------+
string CBaseObj::EventDescription(const int                    property,
                                  const ENUM_BASE_EVENT_REASON reason,
                                  const int                    source,
                                  const string                 value,
                                  const string                 property_descr,
                                  const int                    digits)
{
    //--- Depending on the collection ID, create th object type description
    string type =
        (this.Type() == COLLECTION_SYMBOLS_ID   ? TextByLanguage("symbol property: ")
         : this.Type() == COLLECTION_ACCOUNT_ID ? TextByLanguage("account property: ")
                                                : "");
    //--- Depending on the property type, create the property change value description
    string level =
        (property < this.m_long_prop_total ? ::DoubleToString(this.GetControlledValueLongLEVEL(property), digits) : ::DoubleToString(this.GetControlledValueDoubleLEVEL(property), digits));
    //--- Depending on the event reason, create the event description text
    string res =
        (reason == BASE_EVENT_REASON_INC         ? TextByLanguage("Value of the ") + type + property_descr + TextByLanguage(" increased by ") + value
         : reason == BASE_EVENT_REASON_DEC       ? TextByLanguage("Value of the ") + type + property_descr + TextByLanguage(" decreased by ") + value
         : reason == BASE_EVENT_REASON_MORE_THEN ? TextByLanguage("Value of the ") + type + property_descr + TextByLanguage(" became more than ") + level
         : reason == BASE_EVENT_REASON_LESS_THEN ? TextByLanguage("Value of the ") + type + property_descr + TextByLanguage(" became less than ") + level
         : reason == BASE_EVENT_REASON_EQUALS    ? TextByLanguage("Value of the ") + type + property_descr + TextByLanguage(" is equal to ") + level
                                                 : TextByLanguage("Unknown ") + type);
    //--- Return the object name+created event description text
    return this.m_name + ": " + res;
}
//+------------------------------------------------------------------+
