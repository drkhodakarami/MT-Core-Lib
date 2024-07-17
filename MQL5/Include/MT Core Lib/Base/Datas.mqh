//+------------------------------------------------------------------+
//|                                                        Datas.mqh |
//|                                              Alireza Khodakarami |
//|                         https://www.youtube.com/@YourTradeMaster |
//+------------------------------------------------------------------+
#property copyright "Alireza Khodakarami"
#property link "https://www.youtube.com/@YourTradeMaster"
//+------------------------------------------------------------------+
//| Enumerations                                                     |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Modes of working with symbols                                    |
//+------------------------------------------------------------------+
enum ENUM_SYMBOLS_MODE
{
    SYMBOLS_MODE_CURRENT,         // Work with the current symbol only
    SYMBOLS_MODE_DEFINES,         // Work with the specified symbol list
    SYMBOLS_MODE_MARKET_WATCH,    // Work with the Market Watch window symbols
    SYMBOLS_MODE_ALL              // Work with the full symbol list
};
//+------------------------------------------------------------------+
//| Data sets                                                        |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Major Forex symbols                                              |
//+------------------------------------------------------------------+
string DataSymbolsFXMajors[]      = {"AUDCAD", "AUDCHF", "AUDJPY", "AUDNZD", "AUDUSD", "CADCHF", "CADJPY", "CHFJPY", "EURAUD", "EURCAD", "EURCHF", "EURGBP", "EURJPY", "EURNZD",
                                     "EURUSD", "GBPAUD", "GBPCAD", "GBPCHF", "GBPJPY", "GBPNZD", "GBPUSD", "NZDCAD", "NZDCHF", "NZDJPY", "NZDUSD", "USDCAD", "USDCHF", "USDJPY"};
//+------------------------------------------------------------------+
//| Minor Forex symbols                                              |
//+------------------------------------------------------------------+
string DataSymbolsFXMinors[]      = {"EURCZK", "EURDKK", "EURHKD", "EURNOK", "EURPLN", "EURSEK", "EURSGD", "EURTRY", "EURZAR", "GBPSEK", "GBPSGD",
                                     "NZDSGD", "USDCZK", "USDDKK", "USDHKD", "USDNOK", "USDPLN", "USDSEK", "USDSGD", "USDTRY", "USDZAR"};
//+------------------------------------------------------------------+
//| Exotic Forex symbols                                             |
//+------------------------------------------------------------------+
string DataSymbolsFXExotics[]     = {"EURMXN", "USDCNH", "USDMXN", "EURTRY", "USDTRY"};
//+------------------------------------------------------------------+
//| Forex RUB symbols                                                |
//+------------------------------------------------------------------+
string DataSymbolsFXRub[]         = {"EURRUB", "USDRUB"};
//+------------------------------------------------------------------+
//| Indicative Forex symbols                                         |
//+------------------------------------------------------------------+
string DataSymbolsFXIndicatives[] = {"EUREUC", "USDEUC", "USDUSC"};
//+------------------------------------------------------------------+
//| Metal symbols                                                    |
//+------------------------------------------------------------------+
string DataSymbolsMetalls[]       = {"XAGUSD", "XAUUSD"};
//+------------------------------------------------------------------+
//| Commodity symbols                                                |
//+------------------------------------------------------------------+
string DataSymbolsCommodities[]   = {"BRN", "WTI", "NG"};
//+------------------------------------------------------------------+
//| Indices                                                          |
//+------------------------------------------------------------------+
string DataSymbolsIndexes[]       = {"CAC40",
                                     "HSI50",
                                     "ASX200",
                                     "STOXX50",
                                     "NQ100",
                                     "FTSE100",
                                     "DAX30",
                                     "IBEX35",
                                     "SPX500",
                                     "NIKK225",
                                     "Volatility 10 Index",
                                     "Volatility 25 Index",
                                     "Volatility 50 Index",
                                     "Volatility 75 Index",
                                     "Volatility 100 Index",
                                     "HF Volatility 10 Index",
                                     "HF Volatility 50 Index",
                                     "Crash 1000 Index",
                                     "Boom 1000 Index",
                                     "Step Index"};
//+------------------------------------------------------------------+
//| Cryptocurrency symbols                                           |
//+------------------------------------------------------------------+
string DataSymbolsCrypto[]        = {"BCHUSD", "BTCEUR", "BTCUSD", "DSHUSD", "EOSUSD", "ETHEUR", "ETHUSD", "LTCUSD", "XRPUSD"};
//+------------------------------------------------------------------+
//| Options                                                          |
//+------------------------------------------------------------------+
string DataSymbolsOptions[]       = {"BO Volatility 10 Index", "BO Volatility 25 Index", "BO Volatility 50 Index", "BO Volatility 75 Index", "BO Volatility 100 Index"};
//+------------------------------------------------------------------+
//| List of the library's text message indices                       |
//+------------------------------------------------------------------+
enum ENUM_MESSAGES_LIB
{
    MSG_LIB_PARAMS_LIST_BEG = ERR_USER_ERROR_FIRST,      // Beginning of the parameter list
    MSG_LIB_PARAMS_LIST_END,                             // End of the parameter list
    MSG_LIB_PROP_NOT_SUPPORTED,                          // Property not supported
    MSG_LIB_PROP_NOT_SUPPORTED_MQL4,                     // Property not supported in MQL4
    MSG_LIB_PROP_NOT_SUPPORTED_POSITION,                 // Property not supported for position
    MSG_LIB_PROP_NOT_SUPPORTED_PENDING,                  // Property not supported for pending order
    MSG_LIB_PROP_NOT_SUPPORTED_MARKET,                   // Property not supported for market order
    MSG_LIB_PROP_NOT_SUPPORTED_MARKET_HIST,              // Property not supported for historical market order
    MSG_LIB_PROP_NOT_SET,                                // Value not set
    MSG_LIB_PROP_EMPTY,                                  // Not set

    MSG_LIB_SYS_ERROR,                                   // Error
    MSG_LIB_SYS_NOT_SYMBOL_ON_SERVER,                    // Error. No such symbol on server
    MSG_LIB_SYS_FAILED_PUT_SYMBOL,                       // Failed to place to market watch. Error:
    MSG_LIB_SYS_NOT_GET_PRICE,                           // Failed to get current prices. Error:
    MSG_LIB_SYS_NOT_GET_MARGIN_RATES,                    // Failed to get margin ratios. Error:
    MSG_LIB_SYS_NOT_GET_DATAS,                           // Failed to get data

    MSG_LIB_SYS_FAILED_CREATE_STORAGE_FOLDER,            // Failed to create folder for storing files. Error:
    MSG_LIB_SYS_FAILED_ADD_ACC_OBJ_TO_LIST,              // Error. Failed to add current account object to collection list
    MSG_LIB_SYS_FAILED_CREATE_CURR_ACC_OBJ,              // Error. Failed to create account object with current account data
    MSG_LIB_SYS_FAILED_OPEN_FILE_FOR_WRITE,              // Could not open file for writing
    MSG_LIB_SYS_INPUT_ERROR_NO_SYMBOL,                   // Input error: no symbol
    MSG_LIB_SYS_FAILED_CREATE_SYM_OBJ,                   // Failed to create symbol object
    MSG_LIB_SYS_FAILED_ADD_SYM_OBJ,                      // Failed to add symbol

    MSG_LIB_SYS_NOT_GET_CURR_PRICES,                     // Failed to get current prices by event symbol
    MSG_LIB_SYS_EVENT_ALREADY_IN_LIST,                   // This event is already in the list
    MSG_LIB_SYS_FILE_RES_ALREADY_IN_LIST,                // This file already created and added to list:
    MSG_LIB_SYS_FAILED_CREATE_RES_LINK,                  // Error. Failed to create object pointing to resource file
    MSG_LIB_SYS_ERROR_ALREADY_CREATED_COUNTER,           // Error. Counter with ID already created
    MSG_LIB_SYS_FAILED_CREATE_COUNTER,                   // Failed to create timer counter
    MSG_LIB_SYS_FAILED_CREATE_TEMP_LIST,                 // Error creating temporary list
    MSG_LIB_SYS_ERROR_NOT_MARKET_LIST,                   // Error. This is not a market collection list
    MSG_LIB_SYS_ERROR_NOT_HISTORY_LIST,                  // Error. This is not a history collection list
    MSG_LIB_SYS_FAILED_ADD_ORDER_TO_LIST,                // Could not add order to list
    MSG_LIB_SYS_FAILED_ADD_DEAL_TO_LIST,                 // Could not add deal to list
    MSG_LIB_SYS_FAILED_ADD_CTRL_ORDER_TO_LIST,           // Failed to add control order
    MSG_LIB_SYS_FAILED_ADD_CTRL_POSITION_TO_LIST,        // Failed to add control position
    MSG_LIB_SYS_FAILED_ADD_MODIFIED_ORD_TO_LIST,         // Could not add modified order to list of modified orders

    MSG_LIB_SYS_NO_TICKS_YET,                            // No ticks yet
    MSG_LIB_SYS_FAILED_CREATE_OBJ_STRUCT,                // Could not create object structure
    MSG_LIB_SYS_FAILED_WRITE_UARRAY_TO_FILE,             // Could not write uchar array to file
    MSG_LIB_SYS_FAILED_LOAD_UARRAY_FROM_FILE,            // Could not load uchar array from file
    MSG_LIB_SYS_FAILED_CREATE_OBJ_STRUCT_FROM_UARRAY,    // Could not create object structure from uchar array
    MSG_LIB_SYS_FAILED_SAVE_OBJ_STRUCT_TO_UARRAY,        // Failed to save object structure to uchar array, error
    MSG_LIB_SYS_ERROR_INDEX,                             // Error. "index" value should be within 0 - 3
    MSG_LIB_SYS_ERROR_FAILED_CONV_TO_LOWERCASE,          // Failed to convert string to lowercase, error

    MSG_LIB_SYS_ERROR_EMPTY_STRING,                      // Error. Predefined symbols string empty, to be used
    MSG_LIB_SYS_FAILED_PREPARING_SYMBOLS_ARRAY,          // Failed to prepare array of used symbols. Error
    MSG_LIB_SYS_INVALID_ORDER_TYPE,                      // Invalid order type:

    MSG_LIB_SYS_ERROR_FAILED_GET_PRICE_ASK,              // Failed to get Ask price. Error
    MSG_LIB_SYS_ERROR_FAILED_GET_PRICE_BID,              // Failed to get Bid price. Error
    MSG_LIB_SYS_ERROR_FAILED_OPEN_BUY,                   // Failed to open Buy position. Error
    MSG_LIB_SYS_ERROR_FAILED_PLACE_BUYLIMIT,             // Failed to set BuyLimit order. Error
    MSG_LIB_SYS_ERROR_FAILED_PLACE_BUYSTOP,              // Failed to set BuyStop order. Error
    MSG_LIB_SYS_ERROR_FAILED_PLACE_BUYSTOPLIMIT,         // Failed to set BuyStopLimit order. Error
    MSG_LIB_SYS_ERROR_FAILED_OPEN_SELL,                  // Failed to open Sell position. Error
    MSG_LIB_SYS_ERROR_FAILED_PLACE_SELLLIMIT,            // Failed to set SellLimit order. Error
    MSG_LIB_SYS_ERROR_FAILED_PLACE_SELLSTOP,             // Failed to set SellStop order. Error
    MSG_LIB_SYS_ERROR_FAILED_PLACE_SELLSTOPLIMIT,        // Failed to set SellStopLimit order. Error
    MSG_LIB_SYS_ERROR_FAILED_SELECT_POS,                 // Failed to select position. Error
    MSG_LIB_SYS_ERROR_POSITION_ALREADY_CLOSED,           // Position already closed
    MSG_LIB_SYS_ERROR_NOT_POSITION,                      // Error. Not a position:
    MSG_LIB_SYS_ERROR_FAILED_CLOSE_POS,                  // Failed to closed position. Error
    MSG_LIB_SYS_ERROR_FAILED_SELECT_POS_BY,              // Failed to select opposite position. Error
    MSG_LIB_SYS_ERROR_POSITION_BY_ALREADY_CLOSED,        // Opposite position already closed
    MSG_LIB_SYS_ERROR_NOT_POSITION_BY,                   // Error. Opposite position is not a position:
    MSG_LIB_SYS_ERROR_FAILED_CLOSE_POS_BY,               // Failed to close position by opposite one. Error
    MSG_LIB_SYS_ERROR_FAILED_SELECT_ORD,                 // Failed to select order. Error
    MSG_LIB_SYS_ERROR_ORDER_ALREADY_DELETED,             // Order already deleted
    MSG_LIB_SYS_ERROR_NOT_ORDER,                         // Error. Not an order:
    MSG_LIB_SYS_ERROR_FAILED_DELETE_ORD,                 // Failed to delete order. Error
    MSG_LIB_SYS_ERROR_SELECT_CLOSED_POS_TO_MODIFY,       // Error. Closed position selected for modification:
    MSG_LIB_SYS_ERROR_FAILED_MODIFY_POS,                 // Failed to modify position. Error
    MSG_LIB_SYS_ERROR_SELECT_DELETED_ORD_TO_MODIFY,      // Error. Removed order selected for modification:
    MSG_LIB_SYS_ERROR_FAILED_MODIFY_ORD,                 // Failed to modify order. Error
    MSG_LIB_SYS_ERROR_CODE_OUT_OF_RANGE,                 // Return code out of range of error codes

    MSG_LIB_TEXT_YES,                                    // Yes
    MSG_LIB_TEXT_NO,                                     // No
    MSG_LIB_TEXT_AND,                                    // and
    MSG_LIB_TEXT_IN,                                     // in
    MSG_LIB_TEXT_TO,                                     // to
    MSG_LIB_TEXT_OPENED,                                 // Opened
    MSG_LIB_TEXT_PLACED,                                 // Placed
    MSG_LIB_TEXT_DELETED,                                // Deleted
    MSG_LIB_TEXT_CLOSED,                                 // Closed
    MSG_LIB_TEXT_CLOSED_BY,                              // close by
    MSG_LIB_TEXT_CLOSED_VOL,                             // Closed volume
    MSG_LIB_TEXT_AT_PRICE,                               // at price
    MSG_LIB_TEXT_ON_PRICE,                               // on price
    MSG_LIB_TEXT_TRIGGERED,                              // Triggered
    MSG_LIB_TEXT_TURNED_TO,                              // turned to
    MSG_LIB_TEXT_ADDED,                                  // Added
    MSG_LIB_TEXT_SYMBOL_ON_SERVER,                       // on server
    MSG_LIB_TEXT_SYMBOL_TO_LIST,                         // to list
    MSG_LIB_TEXT_FAILED_ADD_TO_LIST,                     // failed to add to list
    MSG_LIB_TEXT_SUNDAY,                                 // Sunday
    MSG_LIB_TEXT_MONDAY,                                 // Monday
    MSG_LIB_TEXT_TUESDAY,                                // Tuesday
    MSG_LIB_TEXT_WEDNESDAY,                              // Wednesday
    MSG_LIB_TEXT_THURSDAY,                               // Thursday
    MSG_LIB_TEXT_FRIDAY,                                 // Friday
    MSG_LIB_TEXT_SATURDAY,                               // Saturday
    MSG_LIB_TEXT_SYMBOL,                                 // symbol:
    MSG_LIB_TEXT_ACCOUNT,                                // account:

    MSG_LIB_TEXT_PROP_VALUE,                             // Property value
    MSG_LIB_TEXT_INC_BY,                                 // increased by
    MSG_LIB_TEXT_DEC_BY,                                 // decreased by
    MSG_LIB_TEXT_MORE_THEN,                              // more than
    MSG_LIB_TEXT_LESS_THEN,                              // less than
    MSG_LIB_TEXT_EQUAL,                                  // equal

    MSG_LIB_TEXT_ERROR_COUNTER_WITN_ID,                  // Error. Counter with ID
    MSG_LIB_TEXT_STEP,                                   // , step
    MSG_LIB_TEXT_AND_PAUSE,                              //  and pause
    MSG_LIB_TEXT_ALREADY_EXISTS,                         // already exists

    MSG_LIB_TEXT_BASE_OBJ_UNKNOWN_EVENT,                 // Base object unknown event

    MSG_LIB_TEXT_NOT_MAIL_ENABLED,                       // Sending emails disabled in terminal
    MSG_LIB_TEXT_NOT_PUSH_ENABLED,                       // Sending push notifications disabled in terminal
    MSG_LIB_TEXT_NOT_FTP_ENABLED,                        // Sending files to FTP address disabled in terminal

    MSG_LIB_TEXT_ARRAY_DATA_INTEGER_NULL,                // Controlled integer properties data array has zero size
    MSG_LIB_TEXT_NEED_SET_INTEGER_VALUE,                 // You should first set the size of the array equal to the number of object integer properties
    MSG_LIB_TEXT_TODO_USE_INTEGER_METHOD,                // To do this, use the method
    MSG_LIB_TEXT_WITH_NUMBER_INTEGER_VALUE,              // with number value of integer properties of object in the parameter

    MSG_LIB_TEXT_ARRAY_DATA_DOUBLE_NULL,                 // Controlled double properties data array has zero size
    MSG_LIB_TEXT_NEED_SET_DOUBLE_VALUE,                  // You should first set the size of the array equal to the number of object double properties
    MSG_LIB_TEXT_TODO_USE_DOUBLE_METHOD,                 // To do this, use the method
    MSG_LIB_TEXT_WITH_NUMBER_DOUBLE_VALUE,               // with number value of double properties of object in the parameter

    MSG_LIB_PROP_BID,                                    // Bid price
    MSG_LIB_PROP_ASK,                                    // Ask price
    MSG_LIB_PROP_LAST,                                   // Last deal price
    MSG_LIB_PROP_PRICE_SL,                               // StopLoss price
    MSG_LIB_PROP_PRICE_TP,                               // TakeProfit price
    MSG_LIB_PROP_PROFIT,                                 // Profit
    MSG_LIB_PROP_SYMBOL,                                 // Symbol
    MSG_LIB_PROP_BALANCE,                                // Balance operation
    MSG_LIB_PROP_CREDIT,                                 // Credit operation
    MSG_LIB_PROP_CLOSE_BY_SL,                            // Closing by StopLoss
    MSG_LIB_PROP_CLOSE_BY_TP,                            // Closing by TakeProfit
    MSG_LIB_PROP_ACCOUNT,                                // Account

                                                         //--- COrder
    MSG_ORD_BUY,               // Buy
    MSG_ORD_SELL,              // Sell
    MSG_ORD_TO_BUY,            // Buy order
    MSG_ORD_TO_SELL,           // Sell order
    MSG_DEAL_TO_BUY,           // Buy deal
    MSG_DEAL_TO_SELL,          // Sell deal
    MSG_ORD_HISTORY,           // Historical order
    MSG_ORD_DEAL,              // Deal
    MSG_ORD_POSITION,          // Position
    MSG_ORD_PENDING_ACTIVE,    // Active pending order
    MSG_ORD_PENDING,           // Pending order
    MSG_ORD_UNKNOWN_TYPE,      // Unknown order type
    MSG_POS_UNKNOWN_TYPE,      // Unknown position type
    MSG_POS_UNKNOWN_DEAL,      // Unknown deal type
    //---
    MSG_ORD_SL_ACTIVATED,              // Due to StopLoss
    MSG_ORD_TP_ACTIVATED,              // Due to TakeProfit
    MSG_ORD_PLACED_FROM_MQL4,          // Placed from mql4 program
    MSG_ORD_STATE_CANCELLED,           // Order cancelled
    MSG_ORD_STATE_CANCELLED_CLIENT,    // Order withdrawn by client
    MSG_ORD_STATE_STARTED,             // Order verified but not yet accepted by broker
    MSG_ORD_STATE_PLACED,              // Order accepted
    MSG_ORD_STATE_PARTIAL,             // Order filled partially
    MSG_ORD_STATE_FILLED,              // Order filled in full
    MSG_ORD_STATE_REJECTED,            // Order rejected
    MSG_ORD_STATE_EXPIRED,             // Order withdrawn upon expiration
    MSG_ORD_STATE_REQUEST_ADD,         // Order in the state of registration (placing in the trading system)
    MSG_ORD_STATE_REQUEST_MODIFY,      // Order in the state of modification
    MSG_ORD_STATE_REQUEST_CANCEL,      // Order in deletion state
    MSG_ORD_STATE_UNKNOWN,             // Unknown state
    //---
    MSG_ORD_REASON_CLIENT,           // Order set from desktop terminal
    MSG_ORD_REASON_MOBILE,           // Order set from mobile app
    MSG_ORD_REASON_WEB,              // Order set from web platform
    MSG_ORD_REASON_EXPERT,           // Order set from EA or script
    MSG_ORD_REASON_SO,               // Due to Stop Out
    MSG_ORD_REASON_DEAL_CLIENT,      // Deal carried out from desktop terminal
    MSG_ORD_REASON_DEAL_MOBILE,      // Deal carried out from mobile app
    MSG_ORD_REASON_DEAL_WEB,         // Deal carried out from web platform
    MSG_ORD_REASON_DEAL_EXPERT,      // Deal carried out from EA or script
    MSG_ORD_REASON_DEAL_STOPOUT,     // Due to Stop Out
    MSG_ORD_REASON_DEAL_ROLLOVER,    // Due to position rollover
    MSG_ORD_REASON_DEAL_VMARGIN,     // Due to variation margin
    MSG_ORD_REASON_DEAL_SPLIT,       // Due to split
    MSG_ORD_REASON_POS_CLIENT,       // Position opened from desktop terminal
    MSG_ORD_REASON_POS_MOBILE,       // Position opened from mobile app
    MSG_ORD_REASON_POS_WEB,          // Position opened from web platform
    MSG_ORD_REASON_POS_EXPERT,       // Position opened from EA or script
    //---
    MSG_ORD_MAGIC,                // Magic number
    MSG_ORD_TICKET,               // Ticket
    MSG_ORD_TICKET_FROM,          // Parent order ticket
    MSG_ORD_TICKET_TO,            // Inherited order ticket
    MSG_ORD_TIME_EXP,             // Expiration date
    MSG_ORD_TYPE,                 // Type
    MSG_ORD_TYPE_BY_DIRECTION,    // Direction
    MSG_ORD_REASON,               // Reason
    MSG_ORD_POSITION_ID,          // Position ID
    MSG_ORD_DEAL_ORDER_TICKET,    // Deal by order ticket
    MSG_ORD_DEAL_ENTRY,           // Deal direction
    MSG_ORD_DEAL_IN,              // Entry to market
    MSG_ORD_DEAL_OUT,             // Out from market
    MSG_ORD_DEAL_INOUT,           // Reversal
    MSG_ORD_DEAL_OUT_BY,          // Close by
    MSG_ORD_POSITION_BY_ID,       // Opposite position ID
    MSG_ORD_TIME_OPEN,            // Open time in milliseconds
    MSG_ORD_TIME_CLOSE,           // Close time in milliseconds
    MSG_ORD_TIME_UPDATE,          // Position change time in milliseconds
    MSG_ORD_STATE,                // State
    MSG_ORD_STATUS,               // Status
    MSG_ORD_DISTANCE_PT,          // Distance from price in points
    MSG_ORD_PROFIT_PT,            // Profit in points
    MSG_ORD_GROUP_ID,             // Group ID
    MSG_ORD_PRICE_OPEN,           // Open price
    MSG_ORD_PRICE_CLOSE,          // Close price
    MSG_ORD_PRICE_STOP_LIMIT,     // Limit order price when StopLimit order activated
    MSG_ORD_COMMISSION,           // Commission
    MSG_ORD_SWAP,                 // Swap
    MSG_ORD_VOLUME,               // Volume
    MSG_ORD_VOLUME_CURRENT,       // Unfulfilled volume
    MSG_ORD_PROFIT_FULL,          // Profit+commission+swap
    MSG_ORD_COMMENT,              // Comment
    MSG_ORD_COMMENT_EXT,          // Custom comment
    MSG_ORD_EXT_ID,               // Exchange ID
    MSG_ORD_CLOSE_BY,             // Closing order

                                  //--- CEvent
    MSG_EVN_TYPE,                        // Event type
    MSG_EVN_TIME,                        // Event time
    MSG_EVN_STATUS,                      // Event status
    MSG_EVN_REASON,                      // Event reason
    MSG_EVN_TYPE_DEAL,                   // Deal type
    MSG_EVN_TICKET_DEAL,                 // Deal ticket
    MSG_EVN_TYPE_ORDER,                  // Event order type
    MSG_EVN_TYPE_ORDER_POSITION,         // Position order type
    MSG_EVN_TICKET_ORDER_POSITION,       // Position first order ticket
    MSG_EVN_TICKET_ORDER_EVENT,          // Event order ticket
    MSG_EVN_POSITION_ID,                 // Position ID
    MSG_EVN_POSITION_BY_ID,              // Opposite position ID
    MSG_EVN_MAGIC_BY_ID,                 // Opposite position magic number
    MSG_EVN_TIME_ORDER_POSITION,         // Position open time
    MSG_EVN_TYPE_ORD_POS_BEFORE,         // Position order type before changing direction
    MSG_EVN_TICKET_ORD_POS_BEFORE,       // Position order ticket before changing direction
    MSG_EVN_TYPE_ORD_POS_CURRENT,        // Current position order type
    MSG_EVN_TICKET_ORD_POS_CURRENT,      // Current position order ticket
    MSG_EVN_PRICE_EVENT,                 // Price during an event
    MSG_EVN_VOLUME_ORDER_INITIAL,        // Order initial volume
    MSG_EVN_VOLUME_ORDER_EXECUTED,       // Executed order volume
    MSG_EVN_VOLUME_ORDER_CURRENT,        // Remaining order volume
    MSG_EVN_VOLUME_POSITION_EXECUTED,    // Current position volume
    MSG_EVN_PRICE_OPEN_BEFORE,           // Price open before modification
    MSG_EVN_PRICE_SL_BEFORE,             // StopLoss price before modification
    MSG_EVN_PRICE_TP_BEFORE,             // TakeProfit price before modification
    MSG_EVN_PRICE_EVENT_ASK,             // Ask price during an event
    MSG_EVN_PRICE_EVENT_BID,             // Bid price during an event
    MSG_EVN_SYMBOL_BY_POS,               // Opposite position symbol
    //---
    MSG_EVN_STATUS_MARKET_PENDING,      // Pending order placed
    MSG_EVN_STATUS_MARKET_POSITION,     // Position opened
    MSG_EVN_STATUS_HISTORY_PENDING,     // Pending order removed
    MSG_EVN_STATUS_HISTORY_POSITION,    // Position closed
    MSG_EVN_STATUS_UNKNOWN,             // Unknown status
    //---
    MSG_EVN_NO_EVENT,                            // No trading event
    MSG_EVN_PENDING_ORDER_PLASED,                // Pending order placed
    MSG_EVN_PENDING_ORDER_REMOVED,               // Pending order removed
    MSG_EVN_ACCOUNT_CREDIT,                      // Accruing credit
    MSG_EVN_ACCOUNT_CREDIT_WITHDRAWAL,           // Withdrawal of credit
    MSG_EVN_ACCOUNT_CHARGE,                      // Additional charges
    MSG_EVN_ACCOUNT_CORRECTION,                  // Correcting entry
    MSG_EVN_ACCOUNT_BONUS,                       // Charging bonuses
    MSG_EVN_ACCOUNT_COMISSION,                   // Additional commissions
    MSG_EVN_ACCOUNT_COMISSION_DAILY,             // Commission charged at the end of a day
    MSG_EVN_ACCOUNT_COMISSION_MONTHLY,           // Commission charged at the end of a trading month
    MSG_EVN_ACCOUNT_COMISSION_AGENT_DAILY,       // Agent commission charged at the end of a trading day
    MSG_EVN_ACCOUNT_COMISSION_AGENT_MONTHLY,     // Agent commission charged at the end of a month
    MSG_EVN_ACCOUNT_INTEREST,                    // Accruing interest on free funds
    MSG_EVN_BUY_CANCELLED,                       // Canceled buy deal
    MSG_EVN_SELL_CANCELLED,                      // Canceled sell deal
    MSG_EVN_DIVIDENT,                            // Accruing dividends
    MSG_EVN_DIVIDENT_FRANKED,                    // Accrual of franked dividend
    MSG_EVN_TAX,                                 // Tax accrual
    MSG_EVN_BALANCE_REFILL,                      // Balance refill
    MSG_EVN_BALANCE_WITHDRAWAL,                  // Withdrawing funds from balance
    MSG_EVN_ACTIVATED_PENDING,                   // Pending order activated
    MSG_EVN_ACTIVATED_PENDING_PARTIALLY,         // Pending order partial activation
    MSG_EVN_POSITION_OPENED_PARTIALLY,           // Position opened partially
    MSG_EVN_POSITION_CLOSED_PARTIALLY,           // Position closed partially
    MSG_EVN_POSITION_CLOSED_BY_POS,              // Position closed by opposite position
    MSG_EVN_POSITION_CLOSED_PARTIALLY_BY_POS,    // Position closed partially by opposite position
    MSG_EVN_POSITION_CLOSED_BY_SL,               // Position closed by StopLoss
    MSG_EVN_POSITION_CLOSED_BY_TP,               // Position closed by TakeProfit
    MSG_EVN_POSITION_CLOSED_PARTIALLY_BY_SL,     // Position closed partially by StopLoss
    MSG_EVN_POSITION_CLOSED_PARTIALLY_BY_TP,     // Position closed partially by TakeProfit
    MSG_EVN_POSITION_REVERSED_BY_MARKET,         // Position reversal by market request
    MSG_EVN_POSITION_REVERSED_BY_PENDING,        // Position reversal by triggered a pending order
    MSG_EVN_POSITION_REVERSE_PARTIALLY,          // Position reversal by partial request execution
    MSG_EVN_POSITION_VOLUME_ADD_BY_MARKET,       // Added volume to position by market request
    MSG_EVN_POSITION_VOLUME_ADD_BY_PENDING,      // Added volume to a position by activating a pending order
    MSG_EVN_MODIFY_ORDER_PRICE,                  // Modified order price
    MSG_EVN_MODIFY_ORDER_PRICE_SL,               // Modified order price and StopLoss
    MSG_EVN_MODIFY_ORDER_PRICE_TP,               // Modified order price and TakeProfit
    MSG_EVN_MODIFY_ORDER_PRICE_SL_TP,            // Modified order price, StopLoss and TakeProfit
    MSG_EVN_MODIFY_ORDER_SL_TP,                  // Modified order's StopLoss and TakeProfit
    MSG_EVN_MODIFY_ORDER_SL,                     // Modified order StopLoss
    MSG_EVN_MODIFY_ORDER_TP,                     // Modified order TakeProfit
    MSG_EVN_MODIFY_POSITION_SL_TP,               // Modified of position StopLoss and TakeProfit
    MSG_EVN_MODIFY_POSITION_SL,                  // Modified position's StopLoss
    MSG_EVN_MODIFY_POSITION_TP,                  // Modified position's TakeProfit
    //---
    MSG_EVN_REASON_ADD,                                // Added volume to position
    MSG_EVN_REASON_ADD_PARTIALLY,                      // Volume added to the position by partially completed request
    MSG_EVN_REASON_ADD_BY_PENDING_PARTIALLY,           // Added volume to a position by partial activation of a pending order
    MSG_EVN_REASON_STOPLIMIT_TRIGGERED,                // StopLimit order triggered
    MSG_EVN_REASON_MODIFY,                             // Modification
    MSG_EVN_REASON_CANCEL,                             // Cancelation
    MSG_EVN_REASON_EXPIRED,                            // Expired
    MSG_EVN_REASON_DONE,                               // Fully completed market request
    MSG_EVN_REASON_DONE_PARTIALLY,                     // Partially completed market request
    MSG_EVN_REASON_REVERSE,                            // Position reversal
    MSG_EVN_REASON_REVERSE_BY_PENDING_PARTIALLY,       // Position reversal in case of a pending order partial execution
    MSG_EVN_REASON_DONE_SL_PARTIALLY,                  // Partial closing by StopLoss
    MSG_EVN_REASON_DONE_TP_PARTIALLY,                  // Partial closing by TakeProfit
    MSG_EVN_REASON_DONE_BY_POS,                        // Close by
    MSG_EVN_REASON_DONE_PARTIALLY_BY_POS,              // Partial closing by an opposite position
    MSG_EVN_REASON_DONE_BY_POS_PARTIALLY,              // Closed by incomplete volume of opposite position
    MSG_EVN_REASON_DONE_PARTIALLY_BY_POS_PARTIALLY,    // Closed partially by incomplete volume of opposite position

                                                       //--- CSymbol
    MSG_SYM_PROP_INDEX,                    // Index in \"Market Watch window\"
    MSG_SYM_PROP_CUSTOM,                   // Custom symbol
    MSG_SYM_PROP_CHART_MODE,               // Price type used for generating symbols bars
    MSG_SYM_PROP_EXIST,                    // Symbol with this name exists
    MSG_SYM_PROP_SELECT,                   // Symbol selected in Market Watch
    MSG_SYM_PROP_VISIBLE,                  // Symbol visible in Market Watch
    MSG_SYM_PROP_SESSION_DEALS,            // Number of deals in the current session
    MSG_SYM_PROP_SESSION_BUY_ORDERS,       // Number of Buy orders at the moment
    MSG_SYM_PROP_SESSION_SELL_ORDERS,      // Number of Sell orders at the moment
    MSG_SYM_PROP_VOLUME,                   // Volume of the last deal
    MSG_SYM_PROP_VOLUMEHIGH,               // Maximal day volume
    MSG_SYM_PROP_VOLUMELOW,                // Minimal day volume
    MSG_SYM_PROP_TIME,                     // Latest quote time
    MSG_SYM_PROP_DIGITS,                   // Number of decimal places
    MSG_SYM_PROP_DIGITS_LOTS,              // Digits after a decimal point in the value of the lot
    MSG_SYM_PROP_SPREAD,                   // Spread in points
    MSG_SYM_PROP_SPREAD_FLOAT,             // Floating spread
    MSG_SYM_PROP_TICKS_BOOKDEPTH,          // Maximum number of orders displayed in the Depth of Market
    MSG_SYM_PROP_TRADE_CALC_MODE,          // Contract price calculation mode
    MSG_SYM_PROP_TRADE_MODE,               // Order filling type
    MSG_SYM_PROP_START_TIME,               // Symbol trading start date
    MSG_SYM_PROP_EXPIRATION_TIME,          // Symbol trading end date
    MSG_SYM_PROP_TRADE_STOPS_LEVEL,        // Minimal indention from the close price to place Stop orders
    MSG_SYM_PROP_TRADE_FREEZE_LEVEL,       // Freeze distance for trading operations
    MSG_SYM_PROP_TRADE_EXEMODE,            // Trade execution mode
    MSG_SYM_PROP_SWAP_MODE,                // Swap calculation model
    MSG_SYM_PROP_SWAP_ROLLOVER3DAYS,       // Triple-day swap day
    MSG_SYM_PROP_MARGIN_HEDGED_USE_LEG,    // Calculating hedging margin using the larger leg
    MSG_SYM_PROP_EXPIRATION_MODE,          // Flags of allowed order expiration modes
    MSG_SYM_PROP_FILLING_MODE,             // Flags of allowed order filling modes
    MSG_SYM_PROP_ORDER_MODE,               // Flags of allowed order types
    MSG_SYM_PROP_ORDER_GTC_MODE,           // Expiration of Stop Loss and Take Profit orders
    MSG_SYM_PROP_OPTION_MODE,              // Option type
    MSG_SYM_PROP_OPTION_RIGHT,             // Option right
    MSG_SYM_PROP_BACKGROUND_COLOR,         // Background color of the symbol in Market Watch
    //---
    MSG_SYM_PROP_BIDHIGH,                              // Maximal Bid of the day
    MSG_SYM_PROP_BIDLOW,                               // Minimal Bid of the day
    MSG_SYM_PROP_ASKHIGH,                              // Maximum Ask of the day
    MSG_SYM_PROP_ASKLOW,                               // Minimal Ask of the day
    MSG_SYM_PROP_LASTHIGH,                             // Maximal Last of the day
    MSG_SYM_PROP_LASTLOW,                              // Minimal Last of the day
    MSG_SYM_PROP_VOLUME_REAL,                          // Real volume of the last deal
    MSG_SYM_PROP_VOLUMEHIGH_REAL,                      // Maximum real volume of the day
    MSG_SYM_PROP_VOLUMELOW_REAL,                       // Minimum real volume of the day
    MSG_SYM_PROP_OPTION_STRIKE,                        // Strike price
    MSG_SYM_PROP_POINT,                                // One point value
    MSG_SYM_PROP_TRADE_TICK_VALUE,                     // Calculated tick price for a position
    MSG_SYM_PROP_TRADE_TICK_VALUE_PROFIT,              // Calculated tick value for a winning position
    MSG_SYM_PROP_TRADE_TICK_VALUE_LOSS,                // Calculated tick value for a losing position
    MSG_SYM_PROP_TRADE_TICK_SIZE,                      // Minimum price change
    MSG_SYM_PROP_TRADE_CONTRACT_SIZE,                  // Trade contract size
    MSG_SYM_PROP_TRADE_ACCRUED_INTEREST,               // Accrued interest
    MSG_SYM_PROP_TRADE_FACE_VALUE,                     // Initial bond value set by the issuer
    MSG_SYM_PROP_TRADE_LIQUIDITY_RATE,                 // Liquidity rate
    MSG_SYM_PROP_VOLUME_MIN,                           // Minimum volume for a deal
    MSG_SYM_PROP_VOLUME_MAX,                           // Maximum volume for a deal
    MSG_SYM_PROP_VOLUME_STEP,                          // Minimum volume change step for deal execution
    MSG_SYM_PROP_VOLUME_LIMIT,                         // Maximum allowed aggregate volume of an open position and pending orders in one direction
    MSG_SYM_PROP_SWAP_LONG,                            // Long swap value
    MSG_SYM_PROP_SWAP_SHORT,                           // Short swap value
    MSG_SYM_PROP_MARGIN_INITIAL,                       // Initial margin
    MSG_SYM_PROP_MARGIN_MAINTENANCE,                   // Maintenance margin for an instrument
    MSG_SYM_PROP_MARGIN_LONG_INITIAL,                  // Initial margin requirement applicable to long positions
    MSG_SYM_PROP_MARGIN_SHORT_INITIAL,                 // Initial margin requirement applicable to short positions
    MSG_SYM_PROP_MARGIN_LONG_MAINTENANCE,              // Maintenance margin requirement applicable to long positions
    MSG_SYM_PROP_MARGIN_SHORT_MAINTENANCE,             // Maintenance margin requirement applicable to short positions
    MSG_SYM_PROP_MARGIN_BUY_STOP_INITIAL,              // Initial margin requirement applicable to BuyStop orders
    MSG_SYM_PROP_MARGIN_BUY_LIMIT_INITIAL,             // Initial margin requirement applicable to BuyLimit orders
    MSG_SYM_PROP_MARGIN_BUY_STOPLIMIT_INITIAL,         // Initial margin requirement applicable to BuyStopLimit orders
    MSG_SYM_PROP_MARGIN_SELL_STOP_INITIAL,             // Initial margin requirement applicable to SellStop orders
    MSG_SYM_PROP_MARGIN_SELL_LIMIT_INITIAL,            // Initial margin requirement applicable to SellLimit orders
    MSG_SYM_PROP_MARGIN_SELL_STOPLIMIT_INITIAL,        // Initial margin requirement applicable to SellStopLimit orders
    MSG_SYM_PROP_MARGIN_BUY_STOP_MAINTENANCE,          // Maintenance margin requirement applicable to BuyStop orders
    MSG_SYM_PROP_MARGIN_BUY_LIMIT_MAINTENANCE,         // Maintenance margin requirement applicable to BuyLimit orders
    MSG_SYM_PROP_MARGIN_BUY_STOPLIMIT_MAINTENANCE,     // Maintenance margin requirement applicable to BuyStopLimit orders
    MSG_SYM_PROP_MARGIN_SELL_STOP_MAINTENANCE,         // Maintenance margin requirement applicable to SellStop orders
    MSG_SYM_PROP_MARGIN_SELL_LIMIT_MAINTENANCE,        // Maintenance margin requirement applicable to SellLimit orders
    MSG_SYM_PROP_MARGIN_SELL_STOPLIMIT_MAINTENANCE,    // Maintenance margin requirement applicable to SellStopLimit orders
    MSG_SYM_PROP_SESSION_VOLUME,                       // Summary volume of the current session deals
    MSG_SYM_PROP_SESSION_TURNOVER,                     // Summary turnover of the current session
    MSG_SYM_PROP_SESSION_INTEREST,                     // Summary open interest
    MSG_SYM_PROP_SESSION_BUY_ORDERS_VOLUME,            // Current volume of Buy orders
    MSG_SYM_PROP_SESSION_SELL_ORDERS_VOLUME,           // Current volume of Sell orders
    MSG_SYM_PROP_SESSION_OPEN,                         // Session open price
    MSG_SYM_PROP_SESSION_CLOSE,                        // Session close price
    MSG_SYM_PROP_SESSION_AW,                           // Average weighted session price
    MSG_SYM_PROP_SESSION_PRICE_SETTLEMENT,             // Settlement price of the current session
    MSG_SYM_PROP_SESSION_PRICE_LIMIT_MIN,              // Minimum session price
    MSG_SYM_PROP_SESSION_PRICE_LIMIT_MAX,              // Maximum session pric
    MSG_SYM_PROP_MARGIN_HEDGED,                        // Size of a contract or margin for one lot of hedged positions
    //---
    MSG_SYM_PROP_NAME,               // Symbol name
    MSG_SYM_PROP_BASIS,              // Underlying asset of derivative
    MSG_SYM_PROP_CURRENCY_BASE,      // Basic currency of symbol
    MSG_SYM_PROP_CURRENCY_PROFIT,    // Profit currency
    MSG_SYM_PROP_CURRENCY_MARGIN,    // Margin currency
    MSG_SYM_PROP_BANK,               // Feeder of the current quote
    MSG_SYM_PROP_DESCRIPTION,        // Symbol description
    MSG_SYM_PROP_FORMULA,            // Formula used for custom symbol pricing
    MSG_SYM_PROP_ISIN,               // Symbol name in ISIN system
    MSG_SYM_PROP_PAGE,               // Address of web page containing symbol information
    MSG_SYM_PROP_PATH,               // Location in symbol tree
    //---
    MSG_SYM_STATUS_FX,            // Forex symbol
    MSG_SYM_STATUS_FX_MAJOR,      // Major Forex symbo
    MSG_SYM_STATUS_FX_MINOR,      // Minor Forex symbol
    MSG_SYM_STATUS_FX_EXOTIC,     // Exotic Forex symbol
    MSG_SYM_STATUS_FX_RUB,        // Forex symbol/RUB
    MSG_SYM_STATUS_METAL,         // Metal
    MSG_SYM_STATUS_INDEX,         // Index
    MSG_SYM_STATUS_INDICATIVE,    // Indicative
    MSG_SYM_STATUS_CRYPTO,        // Cryptocurrency symbol
    MSG_SYM_STATUS_COMMODITY,     // Commodity symbol
    MSG_SYM_STATUS_EXCHANGE,      // Exchange symbol
    MSG_SYM_STATUS_FUTURES,       // Futures
    MSG_SYM_STATUS_CFD,           // CFD
    MSG_SYM_STATUS__STOCKS,       // Security
    MSG_SYM_STATUS_BONDS,         // Bond
    MSG_SYM_STATUS_OPTION,        // Option
    MSG_SYM_STATUS_COLLATERAL,    // Non-tradable asset
    MSG_SYM_STATUS_CUSTOM,        // Custom symbol
    MSG_SYM_STATUS_COMMON,        // General group symbol
    //---
    MSG_SYM_CHART_MODE_BID,                  // Bars are based on Bid prices
    MSG_SYM_CHART_MODE_LAST,                 // Bars are based on Last prices
    MSG_SYM_CALC_MODE_FOREX,                 // Forex mode
    MSG_SYM_CALC_MODE_FOREX_NO_LEVERAGE,     // Forex No Leverage mode
    MSG_SYM_CALC_MODE_FUTURES,               // Futures mode
    MSG_SYM_CALC_MODE_CFD,                   // CFD mode
    MSG_SYM_CALC_MODE_CFDINDEX,              // CFD index mode
    MSG_SYM_CALC_MODE_CFDLEVERAGE,           // CFD Leverage mode
    MSG_SYM_CALC_MODE_EXCH_STOCKS,           // Exchange mode
    MSG_SYM_CALC_MODE_EXCH_FUTURES,          // Futures mode
    MSG_SYM_CALC_MODE_EXCH_FUTURES_FORTS,    // FORTS Futures mode
    MSG_SYM_CALC_MODE_EXCH_BONDS,            // Exchange Bonds mode
    MSG_SYM_CALC_MODE_EXCH_STOCKS_MOEX,      // Exchange MOEX Stocks mode
    MSG_SYM_CALC_MODE_EXCH_BONDS_MOEX,       // Exchange MOEX Bonds mode
    MSG_SYM_CALC_MODE_SERV_COLLATERAL,       // Collateral mode
    MSG_SYM_MODE_UNKNOWN,                    // Unknown mode
    //---
    MSG_SYM_TRADE_MODE_DISABLED,     // Trading disabled for symbol
    MSG_SYM_TRADE_MODE_LONGONLY,     // Only long positions allowed
    MSG_SYM_TRADE_MODE_SHORTONLY,    // Only short positions allowed
    MSG_SYM_TRADE_MODE_CLOSEONLY,    // Close only
    MSG_SYM_TRADE_MODE_FULL,         // No trading limitations
    //---
    MSG_SYM_TRADE_EXECUTION_REQUEST,     // Execution by request
    MSG_SYM_TRADE_EXECUTION_INSTANT,     // Instant execution
    MSG_SYM_TRADE_EXECUTION_MARKET,      // Market execution
    MSG_SYM_TRADE_EXECUTION_EXCHANGE,    // Exchange execution
    //---
    MSG_SYM_SWAP_MODE_DISABLED,            // No swaps
    MSG_SYM_SWAP_MODE_POINTS,              // Swaps charged in points
    MSG_SYM_SWAP_MODE_CURRENCY_SYMBOL,     // Swaps charged in money in symbol base currency
    MSG_SYM_SWAP_MODE_CURRENCY_MARGIN,     // Swaps charged in money in symbol margin currency
    MSG_SYM_SWAP_MODE_CURRENCY_DEPOSIT,    // Swaps charged in money in client deposit currency
    MSG_SYM_SWAP_MODE_INTEREST_CURRENT,    // Swaps charged in money in client deposit currency
    MSG_SYM_SWAP_MODE_INTEREST_OPEN,       // Swaps charged as specified annual interest from position open price
    MSG_SYM_SWAP_MODE_REOPEN_CURRENT,      // Swaps charged by reopening positions by close price
    MSG_SYM_SWAP_MODE_REOPEN_BID,          // Swaps charged by reopening positions by the current Bid price
    //---
    MSG_SYM_ORDERS_GTC,                      // Pending orders and Stop Loss/Take Profit levels valid for unlimited period until their explicit cancellation
    MSG_SYM_ORDERS_DAILY,                    // At the end of the day, all Stop Loss and Take Profit levels, as well as pending orders deleted
    MSG_SYM_ORDERS_DAILY_EXCLUDING_STOPS,    // At the end of the day, only pending orders deleted, while Stop Loss and Take Profit levels preserved
    //---
    MSG_SYM_OPTION_MODE_EUROPEAN,    // European option may only be exercised on specified date
    MSG_SYM_OPTION_MODE_AMERICAN,    // American option may be exercised on any trading day or before expiry
    MSG_SYM_OPTION_MODE_UNKNOWN,     // Unknown option type
    MSG_SYM_OPTION_RIGHT_CALL,       // Call option gives you right to buy asset at specified price
    MSG_SYM_OPTION_RIGHT_PUT,        // Put option gives you right to sell asset at specified price
    //---
    MSG_SYM_MARKET_ORDER_ALLOWED_YES,             // Market order (Yes)
    MSG_SYM_MARKET_ORDER_ALLOWED_NO,              // Market order (No)
    MSG_SYM_LIMIT_ORDER_ALLOWED_YES,              // Limit order (Yes)
    MSG_SYM_LIMIT_ORDER_ALLOWED_NO,               // Limit order (No)
    MSG_SYM_STOP_ORDER_ALLOWED_YES,               // Stop order (Yes)
    MSG_SYM_STOP_ORDER_ALLOWED_NO,                // Stop order (No)
    MSG_SYM_STOPLIMIT_ORDER_ALLOWED_YES,          // Stop limit order (Yes)
    MSG_SYM_STOPLIMIT_ORDER_ALLOWED_NO,           // Stop limit order (No)
    MSG_SYM_STOPLOSS_ORDER_ALLOWED_YES,           // StopLoss (Yes)
    MSG_SYM_STOPLOSS_ORDER_ALLOWED_NO,            // StopLoss (No)
    MSG_SYM_TAKEPROFIT_ORDER_ALLOWED_YES,         // TakeProfit (Yes)
    MSG_SYM_TAKEPROFIT_ORDER_ALLOWED_NO,          // TakeProfit (No)
    MSG_SYM_CLOSEBY_ORDER_ALLOWED_YES,            // Close by (Yes)
    MSG_SYM_CLOSEBY_ORDER_ALLOWED_NO,             // Close by (No)
    MSG_SYM_FILLING_MODE_RETURN_YES,              // Return (Yes)
    MSG_SYM_FILLING_MODE_FOK_YES,                 // Fill or Kill (Yes)
    MSG_SYM_FILLING_MODE_FOK_NO,                  // Fill or Kill (No)
    MSG_SYM_FILLING_MODE_IOK_YES,                 // Immediate or Cancel order (Yes)
    MSG_SYM_FILLING_MODE_IOK_NO,                  // Immediate or Cancel order (No)
    MSG_SYM_EXPIRATION_MODE_GTC_YES,              // Unlimited (Yes)
    MSG_SYM_EXPIRATION_MODE_GTC_NO,               // Unlimited (No)
    MSG_SYM_EXPIRATION_MODE_DAY_YES,              // Valid till the end of the day (Yes)
    MSG_SYM_EXPIRATION_MODE_DAY_NO,               // Valid till the end of the day (No)
    MSG_SYM_EXPIRATION_MODE_SPECIFIED_YES,        // Time is specified in the order (Yes)
    MSG_SYM_EXPIRATION_MODE_SPECIFIED_NO,         // Time is specified in the order (No)
    MSG_SYM_EXPIRATION_MODE_SPECIFIED_DAY_YES,    // Date specified in order (Yes)
    MSG_SYM_EXPIRATION_MODE_SPECIFIED_DAY_NO,     // Date specified in order (No)

    MSG_SYM_EVENT_SYMBOL_ADD,                     // Added symbol to Market Watch window
    MSG_SYM_EVENT_SYMBOL_DEL,                     // Symbol removed from Market Watch window
    MSG_SYM_EVENT_SYMBOL_SORT,                    // Changed location of symbols in Market Watch window
    MSG_SYM_SYMBOLS_MODE_CURRENT,                 // Work with current symbol only
    MSG_SYM_SYMBOLS_MODE_DEFINES,                 // Work with predefined symbol list
    MSG_SYM_SYMBOLS_MODE_MARKET_WATCH,            // Work with Market Watch window symbols
    MSG_SYM_SYMBOLS_MODE_ALL,                     // Work with full list of all available symbols

                                                  //--- CAccount
    MSG_ACC_PROP_LOGIN,              // Account numbe
    MSG_ACC_PROP_TRADE_MODE,         // Trading account type
    MSG_ACC_PROP_LEVERAGE,           // Leverage
    MSG_ACC_PROP_LIMIT_ORDERS,       // Maximum allowed number of active pending orders
    MSG_ACC_PROP_MARGIN_SO_MODE,     // Mode of setting the minimum available margin level
    MSG_ACC_PROP_TRADE_ALLOWED,      // Trading permission of the current account
    MSG_ACC_PROP_TRADE_EXPERT,       // Trading permission of an EA
    MSG_ACC_PROP_MARGIN_MODE,        // Margin calculation mode
    MSG_ACC_PROP_CURRENCY_DIGITS,    // Number of decimal places for the account currency
    MSG_ACC_PROP_SERVER_TYPE,        // Trade server type
    //---
    MSG_ACC_PROP_BALANCE,               // Account balanc
    MSG_ACC_PROP_CREDIT,                // Account credit
    MSG_ACC_PROP_PROFIT,                // Current profit of an account
    MSG_ACC_PROP_EQUITY,                // Account equity
    MSG_ACC_PROP_MARGIN,                // Account margin used in deposit currency
    MSG_ACC_PROP_MARGIN_FREE,           // Free margin of account
    MSG_ACC_PROP_MARGIN_LEVEL,          // Margin level on an account in %
    MSG_ACC_PROP_MARGIN_SO_CALL,        // Margin call level
    MSG_ACC_PROP_MARGIN_SO_SO,          // Margin stop out level
    MSG_ACC_PROP_MARGIN_INITIAL,        // Amount reserved on account to cover margin of all pending orders
    MSG_ACC_PROP_MARGIN_MAINTENANCE,    // Min equity reserved on account to cover min amount of all open positions
    MSG_ACC_PROP_ASSETS,                // Current assets on an account
    MSG_ACC_PROP_LIABILITIES,           // Current liabilities on an account
    MSG_ACC_PROP_COMMISSION_BLOCKED,    // Sum of blocked commissions on an account
    //---
    MSG_ACC_PROP_NAME,        // Client name
    MSG_ACC_PROP_SERVER,      // Trade server name
    MSG_ACC_PROP_CURRENCY,    // Deposit currency
    MSG_ACC_PROP_COMPANY,     // Name of a company serving account
    //---
    MSG_ACC_TRADE_MODE_DEMO,       // Demo account
    MSG_ACC_TRADE_MODE_CONTEST,    // Contest account
    MSG_ACC_TRADE_MODE_REAL,       // Real account
    MSG_ACC_TRADE_MODE_UNKNOWN,    // Unknown account type
    //---
    MSG_ACC_STOPOUT_MODE_PERCENT,           // Account stop out mode in %
    MSG_ACC_STOPOUT_MODE_MONEY,             // Account stop out mode in money
    MSG_ACC_MARGIN_MODE_RETAIL_NETTING,     // Netting mode
    MSG_ACC_MARGIN_MODE_RETAIL_HEDGING,     // Hedging mode
    MSG_ACC_MARGIN_MODE_RETAIL_EXCHANGE,    // Exchange mode

                                            //--- CEngine
    MSG_ENG_NO_TRADE_EVENTS,                      // There have been no trade events since the last launch of EA
    MSG_ENG_FAILED_GET_LAST_TRADE_EVENT_DESCR,    // Failed to get description of the last trading event

};
//+------------------------------------------------------------------+
//| Array of predefined library messages                             |
//+------------------------------------------------------------------+
string messages_library[] =
    {
        "MSG_LIB_PARAMS_LIST_BEG",                             // Beginning of the parameter list
        "MSG_LIB_PARAMS_LIST_END",                             // End of the parameter list
        "MSG_LIB_PROP_NOT_SUPPORTED",                          // Property not supported
        "MSG_LIB_PROP_NOT_SUPPORTED_MQL4",                     // Property not supported in MQL4
        "MSG_LIB_PROP_NOT_SUPPORTED_POSITION",                 // Property not supported for position
        "MSG_LIB_PROP_NOT_SUPPORTED_PENDING",                  // Property not supported for pending order
        "MSG_LIB_PROP_NOT_SUPPORTED_MARKET",                   // Property not supported for market order
        "MSG_LIB_PROP_NOT_SUPPORTED_MARKET_HIST",              // Property not supported for historical market order
        "MSG_LIB_PROP_NOT_SET",                                // Value not set
        "MSG_LIB_PROP_EMPTY",                                  // Not set
        "MSG_LIB_SYS_ERROR",                                   // Error
        "MSG_LIB_SYS_NOT_SYMBOL_ON_SERVER",                    // Error. No such symbol on server
        "MSG_LIB_SYS_FAILED_PUT_SYMBOL",                       // Failed to place to market watch. Error:
        "MSG_LIB_SYS_NOT_GET_PRICE",                           // Failed to get current prices. Error:
        "MSG_LIB_SYS_NOT_GET_MARGIN_RATES",                    // Failed to get margin ratios. Error:
        "MSG_LIB_SYS_NOT_GET_DATAS",                           // Failed to get data
        "MSG_LIB_SYS_FAILED_CREATE_STORAGE_FOLDER",            // Failed to create folder for storing files. Error:
        "MSG_LIB_SYS_FAILED_ADD_ACC_OBJ_TO_LIST",              // Error. Failed to add current account object to collection list
        "MSG_LIB_SYS_FAILED_CREATE_CURR_ACC_OBJ",              // Error. Failed to create account object with current account data
        "MSG_LIB_SYS_FAILED_OPEN_FILE_FOR_WRITE",              // Could not open file for writing
        "MSG_LIB_SYS_INPUT_ERROR_NO_SYMBOL",                   // Input error: no symbol
        "MSG_LIB_SYS_FAILED_CREATE_SYM_OBJ",                   // Failed to create symbol object
        "MSG_LIB_SYS_FAILED_ADD_SYM_OBJ",                      // Failed to add symbol
        "MSG_LIB_SYS_NOT_GET_CURR_PRICES",                     // Failed to get current prices by event symbol
        "MSG_LIB_SYS_EVENT_ALREADY_IN_LIST",                   // This event is already in the list
        "MSG_LIB_SYS_FILE_RES_ALREADY_IN_LIST",                // This file already created and added to list:
        "MSG_LIB_SYS_FAILED_CREATE_RES_LINK",                  // Error. Failed to create object pointing to resource file
        "MSG_LIB_SYS_ERROR_ALREADY_CREATED_COUNTER",           // Error. Counter with ID already created
        "MSG_LIB_SYS_FAILED_CREATE_COUNTER",                   // Failed to create timer counter
        "MSG_LIB_SYS_FAILED_CREATE_TEMP_LIST",                 // Error creating temporary list
        "MSG_LIB_SYS_ERROR_NOT_MARKET_LIST",                   // Error. This is not a market collection list
        "MSG_LIB_SYS_ERROR_NOT_HISTORY_LIST",                  // Error. This is not a history collection list
        "MSG_LIB_SYS_FAILED_ADD_ORDER_TO_LIST",                // Could not add order to list
        "MSG_LIB_SYS_FAILED_ADD_DEAL_TO_LIST",                 // Could not add deal to list
        "MSG_LIB_SYS_FAILED_ADD_CTRL_ORDER_TO_LIST",           // Failed to add control order
        "MSG_LIB_SYS_FAILED_ADD_CTRL_POSITION_TO_LIST",        // Failed to add control position
        "MSG_LIB_SYS_FAILED_ADD_MODIFIED_ORD_TO_LIST",         // Could not add modified order to list of modified orders
        "MSG_LIB_SYS_NO_TICKS_YET",                            // No ticks yet
        "MSG_LIB_SYS_FAILED_CREATE_OBJ_STRUCT",                // Could not create object structure
        "MSG_LIB_SYS_FAILED_WRITE_UARRAY_TO_FILE",             // Could not write uchar array to file
        "MSG_LIB_SYS_FAILED_LOAD_UARRAY_FROM_FILE",            // Could not load uchar array from file
        "MSG_LIB_SYS_FAILED_CREATE_OBJ_STRUCT_FROM_UARRAY",    // Could not create object structure from uchar array
        "MSG_LIB_SYS_FAILED_SAVE_OBJ_STRUCT_TO_UARRAY",        // Failed to save object structure to uchar array, error
        "MSG_LIB_SYS_ERROR_INDEX",                             // Error. " index " value should be within 0 - 3
        "MSG_LIB_SYS_ERROR_FAILED_CONV_TO_LOWERCASE",            // Failed to convert string to lowercase, error
        "MSG_LIB_SYS_ERROR_EMPTY_STRING",                      // Error. Predefined symbols string empty, to be used
        "MSG_LIB_SYS_FAILED_PREPARING_SYMBOLS_ARRAY",          // Failed to prepare array of used symbols. Error
        "MSG_LIB_SYS_INVALID_ORDER_TYPE",                      // Invalid order type:
        "MSG_LIB_SYS_ERROR_FAILED_GET_PRICE_ASK",              // Failed to get Ask price. Error
        "MSG_LIB_SYS_ERROR_FAILED_GET_PRICE_BID",              // Failed to get Bid price. Error
        "MSG_LIB_SYS_ERROR_FAILED_OPEN_BUY",                   // Failed to open Buy position. Error
        "MSG_LIB_SYS_ERROR_FAILED_PLACE_BUYLIMIT",             // Failed to set BuyLimit order. Error
        "MSG_LIB_SYS_ERROR_FAILED_PLACE_BUYSTOP",              // Failed to set BuyStop order. Error
        "MSG_LIB_SYS_ERROR_FAILED_PLACE_BUYSTOPLIMIT",         // Failed to set BuyStopLimit order. Error
        "MSG_LIB_SYS_ERROR_FAILED_OPEN_SELL",                  // Failed to open Sell position. Error
        "MSG_LIB_SYS_ERROR_FAILED_PLACE_SELLLIMIT",            // Failed to set SellLimit order. Error
        "MSG_LIB_SYS_ERROR_FAILED_PLACE_SELLSTOP",             // Failed to set SellStop order. Error
        "MSG_LIB_SYS_ERROR_FAILED_PLACE_SELLSTOPLIMIT",        // Failed to set SellStopLimit order. Error
        "MSG_LIB_SYS_ERROR_FAILED_SELECT_POS",                 // Failed to select position. Error
        "MSG_LIB_SYS_ERROR_POSITION_ALREADY_CLOSED",           // Position already closed
        "MSG_LIB_SYS_ERROR_NOT_POSITION",                      // Error. Not a position:
        "MSG_LIB_SYS_ERROR_FAILED_CLOSE_POS",                  // Failed to closed position. Error
        "MSG_LIB_SYS_ERROR_FAILED_SELECT_POS_BY",              // Failed to select opposite position. Error
        "MSG_LIB_SYS_ERROR_POSITION_BY_ALREADY_CLOSED",        // Opposite position already closed
        "MSG_LIB_SYS_ERROR_NOT_POSITION_BY",                   // Error. Opposite position is not a position:
        "MSG_LIB_SYS_ERROR_FAILED_CLOSE_POS_BY",               // Failed to close position by opposite one. Error
        "MSG_LIB_SYS_ERROR_FAILED_SELECT_ORD",                 // Failed to select order. Error
        "MSG_LIB_SYS_ERROR_ORDER_ALREADY_DELETED",             // Order already deleted
        "MSG_LIB_SYS_ERROR_NOT_ORDER",                         // Error. Not an order:
        "MSG_LIB_SYS_ERROR_FAILED_DELETE_ORD",                 // Failed to delete order. Error
        "MSG_LIB_SYS_ERROR_SELECT_CLOSED_POS_TO_MODIFY",       // Error. Closed position selected for modification:
        "MSG_LIB_SYS_ERROR_FAILED_MODIFY_POS",                 // Failed to modify position. Error
        "MSG_LIB_SYS_ERROR_SELECT_DELETED_ORD_TO_MODIFY",      // Error. Removed order selected for modification:
        "MSG_LIB_SYS_ERROR_FAILED_MODIFY_ORD",                 // Failed to modify order. Error
        "MSG_LIB_SYS_ERROR_CODE_OUT_OF_RANGE",                 // Return code out of range of error codes
        "MSG_LIB_TEXT_YES",                                    // Yes
        "MSG_LIB_TEXT_NO",                                     // No
        "MSG_LIB_TEXT_AND",                                    // and
        "MSG_LIB_TEXT_IN",                                     // in
        "MSG_LIB_TEXT_TO",                                     // to
        "MSG_LIB_TEXT_OPENED",                                 // Opened
        "MSG_LIB_TEXT_PLACED",                                 // Placed
        "MSG_LIB_TEXT_DELETED",                                // Deleted
        "MSG_LIB_TEXT_CLOSED",                                 // Closed
        "MSG_LIB_TEXT_CLOSED_BY",                              // close by
        "MSG_LIB_TEXT_CLOSED_VOL",                             // Closed volume
        "MSG_LIB_TEXT_AT_PRICE",                               // at price
        "MSG_LIB_TEXT_ON_PRICE",                               // on price
        "MSG_LIB_TEXT_TRIGGERED",                              // Triggered
        "MSG_LIB_TEXT_TURNED_TO",                              // turned to
        "MSG_LIB_TEXT_ADDED",                                  // Added
        "MSG_LIB_TEXT_SYMBOL_ON_SERVER",                       // on server
        "MSG_LIB_TEXT_SYMBOL_TO_LIST",                         // to list
        "MSG_LIB_TEXT_FAILED_ADD_TO_LIST",                     // failed to add to list
        "MSG_LIB_TEXT_SUNDAY",                                 // Sunday
        "MSG_LIB_TEXT_MONDAY",                                 // Monday
        "MSG_LIB_TEXT_TUESDAY",                                // Tuesday
        "MSG_LIB_TEXT_WEDNESDAY",                              // Wednesday
        "MSG_LIB_TEXT_THURSDAY",                               // Thursday
        "MSG_LIB_TEXT_FRIDAY",                                 // Friday
        "MSG_LIB_TEXT_SATURDAY",                               // Saturday
        "MSG_LIB_TEXT_SYMBOL",                                 // symbol:
        "MSG_LIB_TEXT_ACCOUNT",                                // account:
        "MSG_LIB_TEXT_PROP_VALUE",                             // Property value
        "MSG_LIB_TEXT_INC_BY",                                 // increased by
        "MSG_LIB_TEXT_DEC_BY",                                 // decreased by
        "MSG_LIB_TEXT_MORE_THEN",                              // more than
        "MSG_LIB_TEXT_LESS_THEN",                              // less than
        "MSG_LIB_TEXT_EQUAL",                                  // equal
        "MSG_LIB_TEXT_ERROR_COUNTER_WITN_ID",                  // Error. Counter with ID
        "MSG_LIB_TEXT_STEP",                                   // , step
        "MSG_LIB_TEXT_AND_PAUSE",                              //  and pause
        "MSG_LIB_TEXT_ALREADY_EXISTS",                         // already exists
        "MSG_LIB_TEXT_BASE_OBJ_UNKNOWN_EVENT",                 // Base object unknown event
        "MSG_LIB_TEXT_NOT_MAIL_ENABLED",                       // Sending emails disabled in terminal
        "MSG_LIB_TEXT_NOT_PUSH_ENABLED",                       // Sending push notifications disabled in terminal
        "MSG_LIB_TEXT_NOT_FTP_ENABLED",                        // Sending files to FTP address disabled in terminal
        "MSG_LIB_TEXT_ARRAY_DATA_INTEGER_NULL",                // Controlled integer properties data array has zero size
        "MSG_LIB_TEXT_NEED_SET_INTEGER_VALUE",                 // You should first set the size of the array equal to the number of object integer properties
        "MSG_LIB_TEXT_TODO_USE_INTEGER_METHOD",                // To do this, use the method
        "MSG_LIB_TEXT_WITH_NUMBER_INTEGER_VALUE",              // with number value of integer properties of object in the parameter
        "MSG_LIB_TEXT_ARRAY_DATA_DOUBLE_NULL",                 // Controlled double properties data array has zero size
        "MSG_LIB_TEXT_NEED_SET_DOUBLE_VALUE",                  // You should first set the size of the array equal to the number of object double properties
        "MSG_LIB_TEXT_TODO_USE_DOUBLE_METHOD",                 // To do this, use the method
        "MSG_LIB_TEXT_WITH_NUMBER_DOUBLE_VALUE",               // with number value of double properties of object in the parameter
        "MSG_LIB_PROP_BID",                                    // Bid price
        "MSG_LIB_PROP_ASK",                                    // Ask price
        "MSG_LIB_PROP_LAST",                                   // Last deal price
        "MSG_LIB_PROP_PRICE_SL",                               // StopLoss price
        "MSG_LIB_PROP_PRICE_TP",                               // TakeProfit price
        "MSG_LIB_PROP_PROFIT",                                 // Profit
        "MSG_LIB_PROP_SYMBOL",                                 // Symbol
        "MSG_LIB_PROP_BALANCE",                                // Balance operation
        "MSG_LIB_PROP_CREDIT",                                 // Credit operation
        "MSG_LIB_PROP_CLOSE_BY_SL",                            // Closing by StopLoss
        "MSG_LIB_PROP_CLOSE_BY_TP",                            // Closing by TakeProfit
        "MSG_LIB_PROP_ACCOUNT",                                // Account
        "MSG_ORD_BUY",                                         // Buy
        "MSG_ORD_SELL",                                        // Sell
        "MSG_ORD_TO_BUY",                                      // Buy order
        "MSG_ORD_TO_SELL",                                     // Sell order
        "MSG_DEAL_TO_BUY",                                     // Buy deal
        "MSG_DEAL_TO_SELL",                                    // Sell deal
        "MSG_ORD_HISTORY",                                     // Historical order
        "MSG_ORD_DEAL",                                        // Deal
        "MSG_ORD_POSITION",                                    // Position
        "MSG_ORD_PENDING_ACTIVE",                              // Active pending order
        "MSG_ORD_PENDING",                                     // Pending order
        "MSG_ORD_UNKNOWN_TYPE",                                // Unknown order type
        "MSG_POS_UNKNOWN_TYPE",                                // Unknown position type
        "MSG_POS_UNKNOWN_DEAL",                                // Unknown deal type
        "MSG_ORD_SL_ACTIVATED",                                // Due to StopLoss
        "MSG_ORD_TP_ACTIVATED",                                // Due to TakeProfit
        "MSG_ORD_PLACED_FROM_MQL4",                            // Placed from mql4 program
        "MSG_ORD_STATE_CANCELLED",                             // Order cancelled
        "MSG_ORD_STATE_CANCELLED_CLIENT",                      // Order withdrawn by client
        "MSG_ORD_STATE_STARTED",                               // Order verified but not yet accepted by broker
        "MSG_ORD_STATE_PLACED",                                // Order accepted
        "MSG_ORD_STATE_PARTIAL",                               // Order filled partially
        "MSG_ORD_STATE_FILLED",                                // Order filled in full
        "MSG_ORD_STATE_REJECTED",                              // Order rejected
        "MSG_ORD_STATE_EXPIRED",                               // Order withdrawn upon expiration
        "MSG_ORD_STATE_REQUEST_ADD",                           // Order in the state of registration (placing in the trading system)
        "MSG_ORD_STATE_REQUEST_MODIFY",                        // Order in the state of modification
        "MSG_ORD_STATE_REQUEST_CANCEL",                        // Order in deletion state
        "MSG_ORD_STATE_UNKNOWN",                               // Unknown state
        "MSG_ORD_REASON_CLIENT",                               // Order set from desktop terminal
        "MSG_ORD_REASON_MOBILE",                               // Order set from mobile app
        "MSG_ORD_REASON_WEB",                                  // Order set from web platform
        "MSG_ORD_REASON_EXPERT",                               // Order set from EA or script
        "MSG_ORD_REASON_SO",                                   // Due to Stop Out
        "MSG_ORD_REASON_DEAL_CLIENT",                          // Deal carried out from desktop terminal
        "MSG_ORD_REASON_DEAL_MOBILE",                          // Deal carried out from mobile app
        "MSG_ORD_REASON_DEAL_WEB",                             // Deal carried out from web platform
        "MSG_ORD_REASON_DEAL_EXPERT",                          // Deal carried out from EA or script
        "MSG_ORD_REASON_DEAL_STOPOUT",                         // Due to Stop Out
        "MSG_ORD_REASON_DEAL_ROLLOVER",                        // Due to position rollover
        "MSG_ORD_REASON_DEAL_VMARGIN",                         // Due to variation margin
        "MSG_ORD_REASON_DEAL_SPLIT",                           // Due to split
        "MSG_ORD_REASON_POS_CLIENT",                           // Position opened from desktop terminal
        "MSG_ORD_REASON_POS_MOBILE",                           // Position opened from mobile app
        "MSG_ORD_REASON_POS_WEB",                              // Position opened from web platform
        "MSG_ORD_REASON_POS_EXPERT",                           // Position opened from EA or script
        "MSG_ORD_MAGIC",                                       // Magic number
        "MSG_ORD_TICKET",                                      // Ticket
        "MSG_ORD_TICKET_FROM",                                 // Parent order ticket
        "MSG_ORD_TICKET_TO",                                   // Inherited order ticket
        "MSG_ORD_TIME_EXP",                                    // Expiration date
        "MSG_ORD_TYPE",                                        // Type
        "MSG_ORD_TYPE_BY_DIRECTION",                           // Direction
        "MSG_ORD_REASON",                                      // Reason
        "MSG_ORD_POSITION_ID",                                 // Position ID
        "MSG_ORD_DEAL_ORDER_TICKET",                           // Deal by order ticket
        "MSG_ORD_DEAL_ENTRY",                                  // Deal direction
        "MSG_ORD_DEAL_IN",                                     // Entry to market
        "MSG_ORD_DEAL_OUT",                                    // Out from market
        "MSG_ORD_DEAL_INOUT",                                  // Reversal
        "MSG_ORD_DEAL_OUT_BY",                                 // Close by
        "MSG_ORD_POSITION_BY_ID",                              // Opposite position ID
        "MSG_ORD_TIME_OPEN",                                   // Open time in milliseconds
        "MSG_ORD_TIME_CLOSE",                                  // Close time in milliseconds
        "MSG_ORD_TIME_UPDATE",                                 // Position change time in milliseconds
        "MSG_ORD_STATE",                                       // State
        "MSG_ORD_STATUS",                                      // Status
        "MSG_ORD_DISTANCE_PT",                                 // Distance from price in points
        "MSG_ORD_PROFIT_PT",                                   // Profit in points
        "MSG_ORD_GROUP_ID",                                    // Group ID
        "MSG_ORD_PRICE_OPEN",                                  // Open price
        "MSG_ORD_PRICE_CLOSE",                                 // Close price
        "MSG_ORD_PRICE_STOP_LIMIT",                            // Limit order price when StopLimit order activated
        "MSG_ORD_COMMISSION",                                  // Commission
        "MSG_ORD_SWAP",                                        // Swap
        "MSG_ORD_VOLUME",                                      // Volume
        "MSG_ORD_VOLUME_CURRENT",                              // Unfulfilled volume
        "MSG_ORD_PROFIT_FULL",                                 // Profit+commission+swap
        "MSG_ORD_COMMENT",                                     // Comment
        "MSG_ORD_COMMENT_EXT",                                 // Custom comment
        "MSG_ORD_EXT_ID",                                      // Exchange ID
        "MSG_ORD_CLOSE_BY",                                    // Closing order
        "MSG_EVN_TYPE",                                        // Event type
        "MSG_EVN_TIME",                                        // Event time
        "MSG_EVN_STATUS",                                      // Event status
        "MSG_EVN_REASON",                                      // Event reason
        "MSG_EVN_TYPE_DEAL",                                   // Deal type
        "MSG_EVN_TICKET_DEAL",                                 // Deal ticket
        "MSG_EVN_TYPE_ORDER",                                  // Event order type
        "MSG_EVN_TYPE_ORDER_POSITION",                         // Position order type
        "MSG_EVN_TICKET_ORDER_POSITION",                       // Position first order ticket
        "MSG_EVN_TICKET_ORDER_EVENT",                          // Event order ticket
        "MSG_EVN_POSITION_ID",                                 // Position ID
        "MSG_EVN_POSITION_BY_ID",                              // Opposite position ID
        "MSG_EVN_MAGIC_BY_ID",                                 // Opposite position magic number
        "MSG_EVN_TIME_ORDER_POSITION",                         // Position open time
        "MSG_EVN_TYPE_ORD_POS_BEFORE",                         // Position order type before changing direction
        "MSG_EVN_TICKET_ORD_POS_BEFORE",                       // Position order ticket before changing direction
        "MSG_EVN_TYPE_ORD_POS_CURRENT",                        // Current position order type
        "MSG_EVN_TICKET_ORD_POS_CURRENT",                      // Current position order ticket
        "MSG_EVN_PRICE_EVENT",                                 // Price during an event
        "MSG_EVN_VOLUME_ORDER_INITIAL",                        // Order initial volume
        "MSG_EVN_VOLUME_ORDER_EXECUTED",                       // Executed order volume
        "MSG_EVN_VOLUME_ORDER_CURRENT",                        // Remaining order volume
        "MSG_EVN_VOLUME_POSITION_EXECUTED",                    // Current position volume
        "MSG_EVN_PRICE_OPEN_BEFORE",                           // Price open before modification
        "MSG_EVN_PRICE_SL_BEFORE",                             // StopLoss price before modification
        "MSG_EVN_PRICE_TP_BEFORE",                             // TakeProfit price before modification
        "MSG_EVN_PRICE_EVENT_ASK",                             // Ask price during an event
        "MSG_EVN_PRICE_EVENT_BID",                             // Bid price during an event
        "MSG_EVN_SYMBOL_BY_POS",                               // Opposite position symbol
        "MSG_EVN_STATUS_MARKET_PENDING",                       // Pending order placed
        "MSG_EVN_STATUS_MARKET_POSITION",                      // Position opened
        "MSG_EVN_STATUS_HISTORY_PENDING",                      // Pending order removed
        "MSG_EVN_STATUS_HISTORY_POSITION",                     // Position closed
        "MSG_EVN_STATUS_UNKNOWN",                              // Unknown status
        "MSG_EVN_NO_EVENT",                                    // No trading event
        "MSG_EVN_PENDING_ORDER_PLASED",                        // Pending order placed
        "MSG_EVN_PENDING_ORDER_REMOVED",                       // Pending order removed
        "MSG_EVN_ACCOUNT_CREDIT",                              // Accruing credit
        "MSG_EVN_ACCOUNT_CREDIT_WITHDRAWAL",                   // Withdrawal of credit
        "MSG_EVN_ACCOUNT_CHARGE",                              // Additional charges
        "MSG_EVN_ACCOUNT_CORRECTION",                          // Correcting entry
        "MSG_EVN_ACCOUNT_BONUS",                               // Charging bonuses
        "MSG_EVN_ACCOUNT_COMISSION",                           // Additional commissions
        "MSG_EVN_ACCOUNT_COMISSION_DAILY",                     // Commission charged at the end of a day
        "MSG_EVN_ACCOUNT_COMISSION_MONTHLY",                   // Commission charged at the end of a trading month
        "MSG_EVN_ACCOUNT_COMISSION_AGENT_DAILY",               // Agent commission charged at the end of a trading day
        "MSG_EVN_ACCOUNT_COMISSION_AGENT_MONTHLY",             // Agent commission charged at the end of a month
        "MSG_EVN_ACCOUNT_INTEREST",                            // Accruing interest on free funds
        "MSG_EVN_BUY_CANCELLED",                               // Canceled buy deal
        "MSG_EVN_SELL_CANCELLED",                              // Canceled sell deal
        "MSG_EVN_DIVIDENT",                                    // Accruing dividends
        "MSG_EVN_DIVIDENT_FRANKED",                            // Accrual of franked dividend
        "MSG_EVN_TAX",                                         // Tax accrual
        "MSG_EVN_BALANCE_REFILL",                              // Balance refill
        "MSG_EVN_BALANCE_WITHDRAWAL",                          // Withdrawing funds from balance
        "MSG_EVN_ACTIVATED_PENDING",                           // Pending order activated
        "MSG_EVN_ACTIVATED_PENDING_PARTIALLY",                 // Pending order partial activation
        "MSG_EVN_POSITION_OPENED_PARTIALLY",                   // Position opened partially
        "MSG_EVN_POSITION_CLOSED_PARTIALLY",                   // Position closed partially
        "MSG_EVN_POSITION_CLOSED_BY_POS",                      // Position closed by opposite position
        "MSG_EVN_POSITION_CLOSED_PARTIALLY_BY_POS",            // Position closed partially by opposite position
        "MSG_EVN_POSITION_CLOSED_BY_SL",                       // Position closed by StopLoss
        "MSG_EVN_POSITION_CLOSED_BY_TP",                       // Position closed by TakeProfit
        "MSG_EVN_POSITION_CLOSED_PARTIALLY_BY_SL",             // Position closed partially by StopLoss
        "MSG_EVN_POSITION_CLOSED_PARTIALLY_BY_TP",             // Position closed partially by TakeProfit
        "MSG_EVN_POSITION_REVERSED_BY_MARKET",                 // Position reversal by market request
        "MSG_EVN_POSITION_REVERSED_BY_PENDING",                // Position reversal by triggered a pending order
        "MSG_EVN_POSITION_REVERSE_PARTIALLY",                  // Position reversal by partial request execution
        "MSG_EVN_POSITION_VOLUME_ADD_BY_MARKET",               // Added volume to position by market request
        "MSG_EVN_POSITION_VOLUME_ADD_BY_PENDING",              // Added volume to a position by activating a pending order
        "MSG_EVN_MODIFY_ORDER_PRICE",                          // Modified order price
        "MSG_EVN_MODIFY_ORDER_PRICE_SL",                       // Modified order price and StopLoss
        "MSG_EVN_MODIFY_ORDER_PRICE_TP",                       // Modified order price and TakeProfit
        "MSG_EVN_MODIFY_ORDER_PRICE_SL_TP",                    // Modified order price, StopLoss and TakeProfit
        "MSG_EVN_MODIFY_ORDER_SL_TP",                          // Modified order's StopLoss and TakeProfit
        "MSG_EVN_MODIFY_ORDER_SL",                             // Modified order StopLoss
        "MSG_EVN_MODIFY_ORDER_TP",                             // Modified order TakeProfit
        "MSG_EVN_MODIFY_POSITION_SL_TP",                       // Modified of position StopLoss and TakeProfit
        "MSG_EVN_MODIFY_POSITION_SL",                          // Modified position's StopLoss
        "MSG_EVN_MODIFY_POSITION_TP",                          // Modified position's TakeProfit
        "MSG_EVN_REASON_ADD",                                  // Added volume to position
        "MSG_EVN_REASON_ADD_PARTIALLY",                        // Volume added to the position by partially completed request
        "MSG_EVN_REASON_ADD_BY_PENDING_PARTIALLY",             // Added volume to a position by partial activation of a pending order
        "MSG_EVN_REASON_STOPLIMIT_TRIGGERED",                  // StopLimit order triggered
        "MSG_EVN_REASON_MODIFY",                               // Modification
        "MSG_EVN_REASON_CANCEL",                               // Cancelation
        "MSG_EVN_REASON_EXPIRED",                              // Expired
        "MSG_EVN_REASON_DONE",                                 // Fully completed market request
        "MSG_EVN_REASON_DONE_PARTIALLY",                       // Partially completed market request
        "MSG_EVN_REASON_REVERSE",                              // Position reversal
        "MSG_EVN_REASON_REVERSE_BY_PENDING_PARTIALLY",         // Position reversal in case of a pending order partial execution
        "MSG_EVN_REASON_DONE_SL_PARTIALLY",                    // Partial closing by StopLoss
        "MSG_EVN_REASON_DONE_TP_PARTIALLY",                    // Partial closing by TakeProfit
        "MSG_EVN_REASON_DONE_BY_POS",                          // Close by
        "MSG_EVN_REASON_DONE_PARTIALLY_BY_POS",                // Partial closing by an opposite position
        "MSG_EVN_REASON_DONE_BY_POS_PARTIALLY",                // Closed by incomplete volume of opposite position
        "MSG_EVN_REASON_DONE_PARTIALLY_BY_POS_PARTIALLY",      // Closed partially by incomplete volume of opposite position
        "MSG_SYM_PROP_INDEX",                                  // Index in \"Market Watch window\"
        "MSG_SYM_PROP_CUSTOM",                                 // Custom symbol
        "MSG_SYM_PROP_CHART_MODE",                             // Price type used for generating symbols bars
        "MSG_SYM_PROP_EXIST",                                  // Symbol with this name exists
        "MSG_SYM_PROP_SELECT",                                 // Symbol selected in Market Watch
        "MSG_SYM_PROP_VISIBLE",                                // Symbol visible in Market Watch
        "MSG_SYM_PROP_SESSION_DEALS",                          // Number of deals in the current session
        "MSG_SYM_PROP_SESSION_BUY_ORDERS",                     // Number of Buy orders at the moment
        "MSG_SYM_PROP_SESSION_SELL_ORDERS",                    // Number of Sell orders at the moment
        "MSG_SYM_PROP_VOLUME",                                 // Volume of the last deal
        "MSG_SYM_PROP_VOLUMEHIGH",                             // Maximal day volume
        "MSG_SYM_PROP_VOLUMELOW",                              // Minimal day volume
        "MSG_SYM_PROP_TIME",                                   // Latest quote time
        "MSG_SYM_PROP_DIGITS",                                 // Number of decimal places
        "MSG_SYM_PROP_DIGITS_LOTS",                            // Digits after a decimal point in the value of the lot
        "MSG_SYM_PROP_SPREAD",                                 // Spread in points
        "MSG_SYM_PROP_SPREAD_FLOAT",                           // Floating spread
        "MSG_SYM_PROP_TICKS_BOOKDEPTH",                        // Maximum number of orders displayed in the Depth of Market
        "MSG_SYM_PROP_TRADE_CALC_MODE",                        // Contract price calculation mode
        "MSG_SYM_PROP_TRADE_MODE",                             // Order filling type
        "MSG_SYM_PROP_START_TIME",                             // Symbol trading start date
        "MSG_SYM_PROP_EXPIRATION_TIME",                        // Symbol trading end date
        "MSG_SYM_PROP_TRADE_STOPS_LEVEL",                      // Minimal indention from the close price to place Stop orders
        "MSG_SYM_PROP_TRADE_FREEZE_LEVEL",                     // Freeze distance for trading operations
        "MSG_SYM_PROP_TRADE_EXEMODE",                          // Trade execution mode
        "MSG_SYM_PROP_SWAP_MODE",                              // Swap calculation model
        "MSG_SYM_PROP_SWAP_ROLLOVER3DAYS",                     // Triple-day swap day
        "MSG_SYM_PROP_MARGIN_HEDGED_USE_LEG",                  // Calculating hedging margin using the larger leg
        "MSG_SYM_PROP_EXPIRATION_MODE",                        // Flags of allowed order expiration modes
        "MSG_SYM_PROP_FILLING_MODE",                           // Flags of allowed order filling modes
        "MSG_SYM_PROP_ORDER_MODE",                             // Flags of allowed order types
        "MSG_SYM_PROP_ORDER_GTC_MODE",                         // Expiration of Stop Loss and Take Profit orders
        "MSG_SYM_PROP_OPTION_MODE",                            // Option type
        "MSG_SYM_PROP_OPTION_RIGHT",                           // Option right
        "MSG_SYM_PROP_BACKGROUND_COLOR",                       // Background color of the symbol in Market Watch
        "MSG_SYM_PROP_BIDHIGH",                                // Maximal Bid of the day
        "MSG_SYM_PROP_BIDLOW",                                 // Minimal Bid of the day
        "MSG_SYM_PROP_ASKHIGH",                                // Maximum Ask of the day
        "MSG_SYM_PROP_ASKLOW",                                 // Minimal Ask of the day
        "MSG_SYM_PROP_LASTHIGH",                               // Maximal Last of the day
        "MSG_SYM_PROP_LASTLOW",                                // Minimal Last of the day
        "MSG_SYM_PROP_VOLUME_REAL",                            // Real volume of the last deal
        "MSG_SYM_PROP_VOLUMEHIGH_REAL",                        // Maximum real volume of the day
        "MSG_SYM_PROP_VOLUMELOW_REAL",                         // Minimum real volume of the day
        "MSG_SYM_PROP_OPTION_STRIKE",                          // Strike price
        "MSG_SYM_PROP_POINT",                                  // One point value
        "MSG_SYM_PROP_TRADE_TICK_VALUE",                       // Calculated tick price for a position
        "MSG_SYM_PROP_TRADE_TICK_VALUE_PROFIT",                // Calculated tick value for a winning position
        "MSG_SYM_PROP_TRADE_TICK_VALUE_LOSS",                  // Calculated tick value for a losing position
        "MSG_SYM_PROP_TRADE_TICK_SIZE",                        // Minimum price change
        "MSG_SYM_PROP_TRADE_CONTRACT_SIZE",                    // Trade contract size
        "MSG_SYM_PROP_TRADE_ACCRUED_INTEREST",                 // Accrued interest
        "MSG_SYM_PROP_TRADE_FACE_VALUE",                       // Initial bond value set by the issuer
        "MSG_SYM_PROP_TRADE_LIQUIDITY_RATE",                   // Liquidity rate
        "MSG_SYM_PROP_VOLUME_MIN",                             // Minimum volume for a deal
        "MSG_SYM_PROP_VOLUME_MAX",                             // Maximum volume for a deal
        "MSG_SYM_PROP_VOLUME_STEP",                            // Minimum volume change step for deal execution
        "MSG_SYM_PROP_VOLUME_LIMIT",                           // Maximum allowed aggregate volume of an open position and pending orders in one direction
        "MSG_SYM_PROP_SWAP_LONG",                              // Long swap value
        "MSG_SYM_PROP_SWAP_SHORT",                             // Short swap value
        "MSG_SYM_PROP_MARGIN_INITIAL",                         // Initial margin
        "MSG_SYM_PROP_MARGIN_MAINTENANCE",                     // Maintenance margin for an instrument
        "MSG_SYM_PROP_MARGIN_LONG_INITIAL",                    // Initial margin requirement applicable to long positions
        "MSG_SYM_PROP_MARGIN_SHORT_INITIAL",                   // Initial margin requirement applicable to short positions
        "MSG_SYM_PROP_MARGIN_LONG_MAINTENANCE",                // Maintenance margin requirement applicable to long positions
        "MSG_SYM_PROP_MARGIN_SHORT_MAINTENANCE",               // Maintenance margin requirement applicable to short positions
        "MSG_SYM_PROP_MARGIN_BUY_STOP_INITIAL",                // Initial margin requirement applicable to BuyStop orders
        "MSG_SYM_PROP_MARGIN_BUY_LIMIT_INITIAL",               // Initial margin requirement applicable to BuyLimit orders
        "MSG_SYM_PROP_MARGIN_BUY_STOPLIMIT_INITIAL",           // Initial margin requirement applicable to BuyStopLimit orders
        "MSG_SYM_PROP_MARGIN_SELL_STOP_INITIAL",               // Initial margin requirement applicable to SellStop orders
        "MSG_SYM_PROP_MARGIN_SELL_LIMIT_INITIAL",              // Initial margin requirement applicable to SellLimit orders
        "MSG_SYM_PROP_MARGIN_SELL_STOPLIMIT_INITIAL",          // Initial margin requirement applicable to SellStopLimit orders
        "MSG_SYM_PROP_MARGIN_BUY_STOP_MAINTENANCE",            // Maintenance margin requirement applicable to BuyStop orders
        "MSG_SYM_PROP_MARGIN_BUY_LIMIT_MAINTENANCE",           // Maintenance margin requirement applicable to BuyLimit orders
        "MSG_SYM_PROP_MARGIN_BUY_STOPLIMIT_MAINTENANCE",       // Maintenance margin requirement applicable to BuyStopLimit orders
        "MSG_SYM_PROP_MARGIN_SELL_STOP_MAINTENANCE",           // Maintenance margin requirement applicable to SellStop orders
        "MSG_SYM_PROP_MARGIN_SELL_LIMIT_MAINTENANCE",          // Maintenance margin requirement applicable to SellLimit orders
        "MSG_SYM_PROP_MARGIN_SELL_STOPLIMIT_MAINTENANCE",      // Maintenance margin requirement applicable to SellStopLimit orders
        "MSG_SYM_PROP_SESSION_VOLUME",                         // Summary volume of the current session deals
        "MSG_SYM_PROP_SESSION_TURNOVER",                       // Summary turnover of the current session
        "MSG_SYM_PROP_SESSION_INTEREST",                       // Summary open interest
        "MSG_SYM_PROP_SESSION_BUY_ORDERS_VOLUME",              // Current volume of Buy orders
        "MSG_SYM_PROP_SESSION_SELL_ORDERS_VOLUME",             // Current volume of Sell orders
        "MSG_SYM_PROP_SESSION_OPEN",                           // Session open price
        "MSG_SYM_PROP_SESSION_CLOSE",                          // Session close price
        "MSG_SYM_PROP_SESSION_AW",                             // Average weighted session price
        "MSG_SYM_PROP_SESSION_PRICE_SETTLEMENT",               // Settlement price of the current session
        "MSG_SYM_PROP_SESSION_PRICE_LIMIT_MIN",                // Minimum session price
        "MSG_SYM_PROP_SESSION_PRICE_LIMIT_MAX",                // Maximum session pric
        "MSG_SYM_PROP_MARGIN_HEDGED",                          // Size of a contract or margin for one lot of hedged positions
        "MSG_SYM_PROP_NAME",                                   // Symbol name
        "MSG_SYM_PROP_BASIS",                                  // Underlying asset of derivative
        "MSG_SYM_PROP_CURRENCY_BASE",                          // Basic currency of symbol
        "MSG_SYM_PROP_CURRENCY_PROFIT",                        // Profit currency
        "MSG_SYM_PROP_CURRENCY_MARGIN",                        // Margin currency
        "MSG_SYM_PROP_BANK",                                   // Feeder of the current quote
        "MSG_SYM_PROP_DESCRIPTION",                            // Symbol description
        "MSG_SYM_PROP_FORMULA",                                // Formula used for custom symbol pricing
        "MSG_SYM_PROP_ISIN",                                   // Symbol name in ISIN system
        "MSG_SYM_PROP_PAGE",                                   // Address of web page containing symbol information
        "MSG_SYM_PROP_PATH",                                   // Location in symbol tree
        "MSG_SYM_STATUS_FX",                                   // Forex symbol
        "MSG_SYM_STATUS_FX_MAJOR",                             // Major Forex symbo
        "MSG_SYM_STATUS_FX_MINOR",                             // Minor Forex symbol
        "MSG_SYM_STATUS_FX_EXOTIC",                            // Exotic Forex symbol
        "MSG_SYM_STATUS_FX_RUB",                               // Forex symbol/RUB
        "MSG_SYM_STATUS_METAL",                                // Metal
        "MSG_SYM_STATUS_INDEX",                                // Index
        "MSG_SYM_STATUS_INDICATIVE",                           // Indicative
        "MSG_SYM_STATUS_CRYPTO",                               // Cryptocurrency symbol
        "MSG_SYM_STATUS_COMMODITY",                            // Commodity symbol
        "MSG_SYM_STATUS_EXCHANGE",                             // Exchange symbol
        "MSG_SYM_STATUS_FUTURES",                              // Futures
        "MSG_SYM_STATUS_CFD",                                  // CFD
        "MSG_SYM_STATUS__STOCKS",                              // Security
        "MSG_SYM_STATUS_BONDS",                                // Bond
        "MSG_SYM_STATUS_OPTION",                               // Option
        "MSG_SYM_STATUS_COLLATERAL",                           // Non-tradable asset
        "MSG_SYM_STATUS_CUSTOM",                               // Custom symbol
        "MSG_SYM_STATUS_COMMON",                               // General group symbol
        "MSG_SYM_CHART_MODE_BID",                              // Bars are based on Bid prices
        "MSG_SYM_CHART_MODE_LAST",                             // Bars are based on Last prices
        "MSG_SYM_CALC_MODE_FOREX",                             // Forex mode
        "MSG_SYM_CALC_MODE_FOREX_NO_LEVERAGE",                 // Forex No Leverage mode
        "MSG_SYM_CALC_MODE_FUTURES",                           // Futures mode
        "MSG_SYM_CALC_MODE_CFD",                               // CFD mode
        "MSG_SYM_CALC_MODE_CFDINDEX",                          // CFD index mode
        "MSG_SYM_CALC_MODE_CFDLEVERAGE",                       // CFD Leverage mode
        "MSG_SYM_CALC_MODE_EXCH_STOCKS",                       // Exchange mode
        "MSG_SYM_CALC_MODE_EXCH_FUTURES",                      // Futures mode
        "MSG_SYM_CALC_MODE_EXCH_FUTURES_FORTS",                // FORTS Futures mode
        "MSG_SYM_CALC_MODE_EXCH_BONDS",                        // Exchange Bonds mode
        "MSG_SYM_CALC_MODE_EXCH_STOCKS_MOEX",                  // Exchange MOEX Stocks mode
        "MSG_SYM_CALC_MODE_EXCH_BONDS_MOEX",                   // Exchange MOEX Bonds mode
        "MSG_SYM_CALC_MODE_SERV_COLLATERAL",                   // Collateral mode
        "MSG_SYM_MODE_UNKNOWN",                                // Unknown mode
        "MSG_SYM_TRADE_MODE_DISABLED",                         // Trading disabled for symbol
        "MSG_SYM_TRADE_MODE_LONGONLY",                         // Only long positions allowed
        "MSG_SYM_TRADE_MODE_SHORTONLY",                        // Only short positions allowed
        "MSG_SYM_TRADE_MODE_CLOSEONLY",                        // Close only
        "MSG_SYM_TRADE_MODE_FULL",                             // No trading limitations
        "MSG_SYM_TRADE_EXECUTION_REQUEST",                     // Execution by request
        "MSG_SYM_TRADE_EXECUTION_INSTANT",                     // Instant execution
        "MSG_SYM_TRADE_EXECUTION_MARKET",                      // Market execution
        "MSG_SYM_TRADE_EXECUTION_EXCHANGE",                    // Exchange execution
        "MSG_SYM_SWAP_MODE_DISABLED",                          // No swaps
        "MSG_SYM_SWAP_MODE_POINTS",                            // Swaps charged in points
        "MSG_SYM_SWAP_MODE_CURRENCY_SYMBOL",                   // Swaps charged in money in symbol base currency
        "MSG_SYM_SWAP_MODE_CURRENCY_MARGIN",                   // Swaps charged in money in symbol margin currency
        "MSG_SYM_SWAP_MODE_CURRENCY_DEPOSIT",                  // Swaps charged in money in client deposit currency
        "MSG_SYM_SWAP_MODE_INTEREST_CURRENT",                  // Swaps charged in money in client deposit currency
        "MSG_SYM_SWAP_MODE_INTEREST_OPEN",                     // Swaps charged as specified annual interest from position open price
        "MSG_SYM_SWAP_MODE_REOPEN_CURRENT",                    // Swaps charged by reopening positions by close price
        "MSG_SYM_SWAP_MODE_REOPEN_BID",                        // Swaps charged by reopening positions by the current Bid price
        "MSG_SYM_ORDERS_GTC",                                  // Pending orders and Stop Loss/Take Profit levels valid for unlimited period until their explicit cancellation
        "MSG_SYM_ORDERS_DAILY",                                // At the end of the day, all Stop Loss and Take Profit levels, as well as pending orders deleted
        "MSG_SYM_ORDERS_DAILY_EXCLUDING_STOPS",                // At the end of the day, only pending orders deleted, while Stop Loss and Take Profit levels preserved
        "MSG_SYM_OPTION_MODE_EUROPEAN",                        // European option may only be exercised on specified date
        "MSG_SYM_OPTION_MODE_AMERICAN",                        // American option may be exercised on any trading day or before expiry
        "MSG_SYM_OPTION_MODE_UNKNOWN",                         // Unknown option type
        "MSG_SYM_OPTION_RIGHT_CALL",                           // Call option gives you right to buy asset at specified price
        "MSG_SYM_OPTION_RIGHT_PUT",                            // Put option gives you right to sell asset at specified price
        "MSG_SYM_MARKET_ORDER_ALLOWED_YES",                    // Market order (Yes)
        "MSG_SYM_MARKET_ORDER_ALLOWED_NO",                     // Market order (No)
        "MSG_SYM_LIMIT_ORDER_ALLOWED_YES",                     // Limit order (Yes)
        "MSG_SYM_LIMIT_ORDER_ALLOWED_NO",                      // Limit order (No)
        "MSG_SYM_STOP_ORDER_ALLOWED_YES",                      // Stop order (Yes)
        "MSG_SYM_STOP_ORDER_ALLOWED_NO",                       // Stop order (No)
        "MSG_SYM_STOPLIMIT_ORDER_ALLOWED_YES",                 // Stop limit order (Yes)
        "MSG_SYM_STOPLIMIT_ORDER_ALLOWED_NO",                  // Stop limit order (No)
        "MSG_SYM_STOPLOSS_ORDER_ALLOWED_YES",                  // StopLoss (Yes)
        "MSG_SYM_STOPLOSS_ORDER_ALLOWED_NO",                   // StopLoss (No)
        "MSG_SYM_TAKEPROFIT_ORDER_ALLOWED_YES",                // TakeProfit (Yes)
        "MSG_SYM_TAKEPROFIT_ORDER_ALLOWED_NO",                 // TakeProfit (No)
        "MSG_SYM_CLOSEBY_ORDER_ALLOWED_YES",                   // Close by (Yes)
        "MSG_SYM_CLOSEBY_ORDER_ALLOWED_NO",                    // Close by (No)
        "MSG_SYM_FILLING_MODE_RETURN_YES",                     // Return (Yes)
        "MSG_SYM_FILLING_MODE_FOK_YES",                        // Fill or Kill (Yes)
        "MSG_SYM_FILLING_MODE_FOK_NO",                         // Fill or Kill (No)
        "MSG_SYM_FILLING_MODE_IOK_YES",                        // Immediate or Cancel order (Yes)
        "MSG_SYM_FILLING_MODE_IOK_NO",                         // Immediate or Cancel order (No)
        "MSG_SYM_EXPIRATION_MODE_GTC_YES",                     // Unlimited (Yes)
        "MSG_SYM_EXPIRATION_MODE_GTC_NO",                      // Unlimited (No)
        "MSG_SYM_EXPIRATION_MODE_DAY_YES",                     // Valid till the end of the day (Yes)
        "MSG_SYM_EXPIRATION_MODE_DAY_NO",                      // Valid till the end of the day (No)
        "MSG_SYM_EXPIRATION_MODE_SPECIFIED_YES",               // Time is specified in the order (Yes)
        "MSG_SYM_EXPIRATION_MODE_SPECIFIED_NO",                // Time is specified in the order (No)
        "MSG_SYM_EXPIRATION_MODE_SPECIFIED_DAY_YES",           // Date specified in order (Yes)
        "MSG_SYM_EXPIRATION_MODE_SPECIFIED_DAY_NO",            // Date specified in order (No)
        "MSG_SYM_EVENT_SYMBOL_ADD",                            // Added symbol to Market Watch window
        "MSG_SYM_EVENT_SYMBOL_DEL",                            // Symbol removed from Market Watch window
        "MSG_SYM_EVENT_SYMBOL_SORT",                           // Changed location of symbols in Market Watch window
        "MSG_SYM_SYMBOLS_MODE_CURRENT",                        // Work with current symbol only
        "MSG_SYM_SYMBOLS_MODE_DEFINES",                        // Work with predefined symbol list
        "MSG_SYM_SYMBOLS_MODE_MARKET_WATCH",                   // Work with Market Watch window symbols
        "MSG_SYM_SYMBOLS_MODE_ALL",                            // Work with full list of all available symbols
        "MSG_ACC_PROP_LOGIN",                                  // Account numbe
        "MSG_ACC_PROP_TRADE_MODE",                             // Trading account type
        "MSG_ACC_PROP_LEVERAGE",                               // Leverage
        "MSG_ACC_PROP_LIMIT_ORDERS",                           // Maximum allowed number of active pending orders
        "MSG_ACC_PROP_MARGIN_SO_MODE",                         // Mode of setting the minimum available margin level
        "MSG_ACC_PROP_TRADE_ALLOWED",                          // Trading permission of the current account
        "MSG_ACC_PROP_TRADE_EXPERT",                           // Trading permission of an EA
        "MSG_ACC_PROP_MARGIN_MODE",                            // Margin calculation mode
        "MSG_ACC_PROP_CURRENCY_DIGITS",                        // Number of decimal places for the account currency
        "MSG_ACC_PROP_SERVER_TYPE",                            // Trade server type
        "MSG_ACC_PROP_BALANCE",                                // Account balanc
        "MSG_ACC_PROP_CREDIT",                                 // Account credit
        "MSG_ACC_PROP_PROFIT",                                 // Current profit of an account
        "MSG_ACC_PROP_EQUITY",                                 // Account equity
        "MSG_ACC_PROP_MARGIN",                                 // Account margin used in deposit currency
        "MSG_ACC_PROP_MARGIN_FREE",                            // Free margin of account
        "MSG_ACC_PROP_MARGIN_LEVEL",                           // Margin level on an account in %
        "MSG_ACC_PROP_MARGIN_SO_CALL",                         // Margin call level
        "MSG_ACC_PROP_MARGIN_SO_SO",                           // Margin stop out level
        "MSG_ACC_PROP_MARGIN_INITIAL",                         // Amount reserved on account to cover margin of all pending orders
        "MSG_ACC_PROP_MARGIN_MAINTENANCE",                     // Min equity reserved on account to cover min amount of all open positions
        "MSG_ACC_PROP_ASSETS",                                 // Current assets on an account
        "MSG_ACC_PROP_LIABILITIES",                            // Current liabilities on an account
        "MSG_ACC_PROP_COMMISSION_BLOCKED",                     // Sum of blocked commissions on an account
        "MSG_ACC_PROP_NAME",                                   // Client name
        "MSG_ACC_PROP_SERVER",                                 // Trade server name
        "MSG_ACC_PROP_CURRENCY",                               // Deposit currency
        "MSG_ACC_PROP_COMPANY",                                // Name of a company serving account
        "MSG_ACC_TRADE_MODE_DEMO",                             // Demo account
        "MSG_ACC_TRADE_MODE_CONTEST",                          // Contest account
        "MSG_ACC_TRADE_MODE_REAL",                             // Real account
        "MSG_ACC_TRADE_MODE_UNKNOWN",                          // Unknown account type
        "MSG_ACC_STOPOUT_MODE_PERCENT",                        // Account stop out mode in %
        "MSG_ACC_STOPOUT_MODE_MONEY",                          // Account stop out mode in money
        "MSG_ACC_MARGIN_MODE_RETAIL_NETTING",                  // Netting mode
        "MSG_ACC_MARGIN_MODE_RETAIL_HEDGING",                  // Hedging mode
        "MSG_ACC_MARGIN_MODE_RETAIL_EXCHANGE",                 // Exchange mode

        "MSG_ENG_NO_TRADE_EVENTS",                             // There have been no trade events since the last launch of EA
        "MSG_ENG_FAILED_GET_LAST_TRADE_EVENT_DESCR",           // Failed to get description of the last trading event
};
//+---------------------------------------------------------------------+
//| Array of messages for trade server return codes (10004 - 10044)     |
//+---------------------------------------------------------------------+
string messages_ts_ret_code[] =
    {
        "MSG_SYM_CODE_10004",
        "MSG_SYM_CODE_10005",
        "MSG_SYM_CODE_10006",
        "MSG_SYM_CODE_10007",
        "MSG_SYM_CODE_10008",
        "MSG_SYM_CODE_10009",
        "MSG_SYM_CODE_10010",
        "MSG_SYM_CODE_10011",
        "MSG_SYM_CODE_10012",
        "MSG_SYM_CODE_10013",
        "MSG_SYM_CODE_10014",
        "MSG_SYM_CODE_10015",
        "MSG_SYM_CODE_10016",
        "MSG_SYM_CODE_10017",
        "MSG_SYM_CODE_10018",
        "MSG_SYM_CODE_10019",
        "MSG_SYM_CODE_10020",
        "MSG_SYM_CODE_10021",
        "MSG_SYM_CODE_10022",
        "MSG_SYM_CODE_10023",
        "MSG_SYM_CODE_10024",
        "MSG_SYM_CODE_10025",
        "MSG_SYM_CODE_10026",
        "MSG_SYM_CODE_10027",
        "MSG_SYM_CODE_10028",
        "MSG_SYM_CODE_10029",
        "MSG_SYM_CODE_10030",
        "MSG_SYM_CODE_10031",
        "MSG_SYM_CODE_10032",
        "MSG_SYM_CODE_10033",
        "MSG_SYM_CODE_10034",
        "MSG_SYM_CODE_10035",
        "MSG_SYM_CODE_10036",
        "MSG_SYM_CODE_10037",
        "MSG_SYM_CODE_10038",
        "MSG_SYM_CODE_10039",
        "MSG_SYM_CODE_10040",
        "MSG_SYM_CODE_10041",
        "MSG_SYM_CODE_10042",
        "MSG_SYM_CODE_10043",
        "MSG_SYM_CODE_10044"
};
//+------------------------------------------------------------------+
//| Array of execution time error messages (0, 4001 - 4019)          |
//+------------------------------------------------------------------+
string messages_runtime[] =
    {
        "MSG_SYM_CODE_0",
        "MSG_SYM_CODE_4001",
        "MSG_SYM_CODE_4002",
        "MSG_SYM_CODE_4003",
        "MSG_SYM_CODE_4004",
        "MSG_SYM_CODE_4005",
        "MSG_SYM_CODE_4006",
        "MSG_SYM_CODE_4007",
        "MSG_SYM_CODE_4008",
        "MSG_SYM_CODE_4009",
        "MSG_SYM_CODE_4010",
        "MSG_SYM_CODE_4011",
        "MSG_SYM_CODE_4012",
        "MSG_SYM_CODE_4013",
        "MSG_SYM_CODE_4014",
        "MSG_SYM_CODE_4015",
        "MSG_SYM_CODE_4016",
        "MSG_SYM_CODE_4017",
        "MSG_SYM_CODE_4018",
        "MSG_SYM_CODE_4019"
};
//+------------------------------------------------------------------+
//| Array of execution time error messages (4101 - 4116)             |
//| (Charts)                                                         |
//+------------------------------------------------------------------+
string messages_runtime_charts[] =
    {
        "MSG_SYM_CODE_4101",
        "MSG_SYM_CODE_4102",
        "MSG_SYM_CODE_4103",
        "MSG_SYM_CODE_4104",
        "MSG_SYM_CODE_4105",
        "MSG_SYM_CODE_4106",
        "MSG_SYM_CODE_4107",
        "MSG_SYM_CODE_4108",
        "MSG_SYM_CODE_4109",
        "MSG_SYM_CODE_4110",
        "MSG_SYM_CODE_4111",
        "MSG_SYM_CODE_4112",
        "MSG_SYM_CODE_4113",
        "MSG_SYM_CODE_4114",
        "MSG_SYM_CODE_4115",
        "MSG_SYM_CODE_4116"
};
//+------------------------------------------------------------------+
//| Array of execution time error messages (4201 - 4205)             |
//| (Graphical objects)                                              |
//+------------------------------------------------------------------+
string messages_runtime_graph_obj[] =
    {
        "MSG_SYM_CODE_4201",
        "MSG_SYM_CODE_4202",
        "MSG_SYM_CODE_4203",
        "MSG_SYM_CODE_4204",
        "MSG_SYM_CODE_4205"
};
//+------------------------------------------------------------------+
//| Array of execution time error messages (4301 - 4305)             |
//| (MarketInfo)                                                     |
//+------------------------------------------------------------------+
string messages_runtime_market[] =
    {
        "MSG_SYM_CODE_4301",
        "MSG_SYM_CODE_4302",
        "MSG_SYM_CODE_4303",
        "MSG_SYM_CODE_4304",
        "MSG_SYM_CODE_4305"
};
//+------------------------------------------------------------------+
//| Array of execution time error messages (4401 - 4407)             |
//| (Access to history)                                              |
//+------------------------------------------------------------------+
string messages_runtime_history[] =
    {
        "MSG_SYM_CODE_4401",
        "MSG_SYM_CODE_4402",
        "MSG_SYM_CODE_4403",
        "MSG_SYM_CODE_4404",
        "MSG_SYM_CODE_4405",
        "MSG_SYM_CODE_4406",
        "MSG_SYM_CODE_4407"
};
//+------------------------------------------------------------------+
//| Array of execution time error messages (4501 - 4524)             |
//| (Global Variables)                                               |
//| (1) in user's country language                                   |
//| (2) in the international language                                |
//+------------------------------------------------------------------+
string messages_runtime_global[] =
    {
        "MSG_SYM_CODE_4501",
        "MSG_SYM_CODE_4502",
        "MSG_SYM_CODE_4503",
        "MSG_SYM_CODE_4504",
        "MSG_SYM_CODE_4505",
        "MSG_SYM_CODE_4506",
        "MSG_SYM_CODE_4507",
        "MSG_SYM_CODE_4508",
        "MSG_SYM_CODE_4509",
        "MSG_SYM_CODE_4510",
        "MSG_SYM_CODE_4511",
        "MSG_SYM_CODE_4512",
        "MSG_SYM_CODE_4513",
        "MSG_SYM_CODE_4514",
        "MSG_SYM_CODE_4515",
        "MSG_SYM_CODE_4516",
        "MSG_SYM_CODE_4517",
        "MSG_SYM_CODE_4518",
        "MSG_SYM_CODE_4519",
        "MSG_SYM_CODE_4520",
        "MSG_SYM_CODE_4521",
        "MSG_SYM_CODE_4522",
        "MSG_SYM_CODE_4523",
        "MSG_SYM_CODE_4524"
};
//+------------------------------------------------------------------+
//| Array of execution time error messages (4601 - 4603)             |
//| (Custom indicator buffers and properties)                        |
//+------------------------------------------------------------------+
string messages_runtime_custom_indicator[] =
    {
        "MSG_SYM_CODE_4601",
        "MSG_SYM_CODE_4602",
        "MSG_SYM_CODE_4603"
};
//+------------------------------------------------------------------+
//| Array of execution time error messages (4701 - 4758)             |
//| (Account)                                                        |
//+------------------------------------------------------------------+
string messages_runtime_account[] =
    {
        "MSG_SYM_CODE_4701",
        "MSG_SYM_CODE_4702",
        "MSG_SYM_CODE_4703",
        "MSG_SYM_CODE_4704",
        "MSG_SYM_CODE_4705",
        "MSG_SYM_CODE_4706",
        "MSG_SYM_CODE_4707",
        "MSG_SYM_CODE_4708",
        "MSG_SYM_CODE_4709",
        "MSG_SYM_CODE_4710",
        "MSG_SYM_CODE_4711",
        "MSG_SYM_CODE_4712",
        "MSG_SYM_CODE_4713",
        "MSG_SYM_CODE_4714",
        "MSG_SYM_CODE_4715",
        "MSG_SYM_CODE_4716",
        "MSG_SYM_CODE_4717",
        "MSG_SYM_CODE_4718",
        "MSG_SYM_CODE_4719",
        "MSG_SYM_CODE_4720",
        "MSG_SYM_CODE_4721",
        "MSG_SYM_CODE_4722",
        "MSG_SYM_CODE_4723",
        "MSG_SYM_CODE_4724",
        "MSG_SYM_CODE_4725",
        "MSG_SYM_CODE_4726",
        "MSG_SYM_CODE_4727",
        "MSG_SYM_CODE_4728",
        "MSG_SYM_CODE_4729",
        "MSG_SYM_CODE_4730",
        "MSG_SYM_CODE_4731",
        "MSG_SYM_CODE_4732",
        "MSG_SYM_CODE_4733",
        "MSG_SYM_CODE_4734",
        "MSG_SYM_CODE_4735",
        "MSG_SYM_CODE_4736",
        "MSG_SYM_CODE_4737",
        "MSG_SYM_CODE_4738",
        "MSG_SYM_CODE_4739",
        "MSG_SYM_CODE_4740",
        "MSG_SYM_CODE_4741",
        "MSG_SYM_CODE_4742",
        "MSG_SYM_CODE_4743",
        "MSG_SYM_CODE_4744",
        "MSG_SYM_CODE_4745",
        "MSG_SYM_CODE_4746",
        "MSG_SYM_CODE_4747",
        "MSG_SYM_CODE_4748",
        "MSG_SYM_CODE_4749",
        "MSG_SYM_CODE_4750",
        "MSG_SYM_CODE_4751",
        "MSG_SYM_CODE_4752",
        "MSG_SYM_CODE_4753",
        "MSG_SYM_CODE_4754",
        "MSG_SYM_CODE_4755",
        "MSG_SYM_CODE_4756",
        "MSG_SYM_CODE_4757",
        "MSG_SYM_CODE_4758"
};
//+------------------------------------------------------------------+
//| Array of execution time error messages (4801 - 4812)             |
//| (Indicators)                                                     |
//+------------------------------------------------------------------+
string messages_runtime_indicator[] =
    {
        "MSG_SYM_CODE_4801",
        "MSG_SYM_CODE_4802",
        "MSG_SYM_CODE_4803",
        "MSG_SYM_CODE_4804",
        "MSG_SYM_CODE_4805",
        "MSG_SYM_CODE_4806",
        "MSG_SYM_CODE_4807",
        "MSG_SYM_CODE_4808",
        "MSG_SYM_CODE_4809",
        "MSG_SYM_CODE_4810",
        "MSG_SYM_CODE_4811",
        "MSG_SYM_CODE_4812"
};
//+------------------------------------------------------------------+
//| Array of execution time error messages (4901 - 4904)             |
//| (Market depth)                                                   |
//+------------------------------------------------------------------+
string messages_runtime_books[] =
    {
        "MSG_SYM_CODE_4901",
        "MSG_SYM_CODE_4902",
        "MSG_SYM_CODE_4903",
        "MSG_SYM_CODE_4904"
};
//+------------------------------------------------------------------+
//| Array of execution time error messages (5001 - 5027)             |
//| (File operations)                                                |
//+------------------------------------------------------------------+
string messages_runtime_files[] =
    {
        "MSG_SYM_CODE_5001",
        "MSG_SYM_CODE_5002",
        "MSG_SYM_CODE_5003",
        "MSG_SYM_CODE_5004",
        "MSG_SYM_CODE_5005",
        "MSG_SYM_CODE_5006",
        "MSG_SYM_CODE_5007",
        "MSG_SYM_CODE_5008",
        "MSG_SYM_CODE_5009",
        "MSG_SYM_CODE_5010",
        "MSG_SYM_CODE_5011",
        "MSG_SYM_CODE_5012",
        "MSG_SYM_CODE_5013",
        "MSG_SYM_CODE_5014",
        "MSG_SYM_CODE_5015",
        "MSG_SYM_CODE_5016",
        "MSG_SYM_CODE_5017",
        "MSG_SYM_CODE_5018",
        "MSG_SYM_CODE_5019",
        "MSG_SYM_CODE_5020",
        "MSG_SYM_CODE_5021",
        "MSG_SYM_CODE_5022",
        "MSG_SYM_CODE_5023",
        "MSG_SYM_CODE_5024",
        "MSG_SYM_CODE_5025",
        "MSG_SYM_CODE_5026",
        "MSG_SYM_CODE_5027"
};
//+------------------------------------------------------------------+
//| Array of execution time error messages (5030 - 5044)             |
//| (String conversion)                                              |
//+------------------------------------------------------------------+
string messages_runtime_string[] =
    {
        "MSG_SYM_CODE_5030",
        "MSG_SYM_CODE_5031",
        "MSG_SYM_CODE_5032",
        "MSG_SYM_CODE_5033",
        "MSG_SYM_CODE_5034",
        "MSG_SYM_CODE_5035",
        "MSG_SYM_CODE_5036",
        "MSG_SYM_CODE_5037",
        "MSG_SYM_CODE_5038",
        "MSG_SYM_CODE_5039",
        "MSG_SYM_CODE_5040",
        "MSG_SYM_CODE_5041",
        "MSG_SYM_CODE_5042",
        "MSG_SYM_CODE_5043",
        "MSG_SYM_CODE_5044"
};
//+------------------------------------------------------------------+
//| Array of execution time error messages (5050 - 5063)             |
//| (Working with arrays)                                            |
//+------------------------------------------------------------------+
string messages_runtime_array[] =
    {
        "MSG_SYM_CODE_5050",
        "MSG_SYM_CODE_5051",
        "MSG_SYM_CODE_5052",
        "MSG_SYM_CODE_5053",
        "MSG_SYM_CODE_5054",
        "MSG_SYM_CODE_5055",
        "MSG_SYM_CODE_5056",
        "MSG_SYM_CODE_5057",
        "MSG_SYM_CODE_5058",
        "MSG_SYM_CODE_5059",
        "MSG_SYM_CODE_5060",
        "MSG_SYM_CODE_5061",
        "MSG_SYM_CODE_5062",
        "MSG_SYM_CODE_5063"
};
//+------------------------------------------------------------------+
//| Array of execution time error messages (5100 - 5114)             |
//| (Working with OpenCL)                                            |
//+------------------------------------------------------------------+
string messages_runtime_opencl[] =
    {
        "MSG_SYM_CODE_5100",
        "MSG_SYM_CODE_5101",
        "MSG_SYM_CODE_5102",
        "MSG_SYM_CODE_5103",
        "MSG_SYM_CODE_5104",
        "MSG_SYM_CODE_5105",
        "MSG_SYM_CODE_5106",
        "MSG_SYM_CODE_5107",
        "MSG_SYM_CODE_5108",
        "MSG_SYM_CODE_5109",
        "MSG_SYM_CODE_5110",
        "MSG_SYM_CODE_5111",
        "MSG_SYM_CODE_5112",
        "MSG_SYM_CODE_5113",
        "MSG_SYM_CODE_5114"
};
//+------------------------------------------------------------------+
//| Array of execution time error messages (5200 - 5203)             |
//| (Working with WebRequest())                                      |
//+------------------------------------------------------------------+
string messages_runtime_webrequest[] =
    {
        "MSG_SYM_CODE_5200",
        "MSG_SYM_CODE_5201",
        "MSG_SYM_CODE_5202",
        "MSG_SYM_CODE_5203"
};
//+------------------------------------------------------------------+
//| Array of execution time error messages (5270 - 5275)             |
//| (Working with network (sockets))                                 |
//+------------------------------------------------------------------+
string messages_runtime_netsocket[] =
    {
        "MSG_SYM_CODE_5270",
        "MSG_SYM_CODE_5271",
        "MSG_SYM_CODE_5272",
        "MSG_SYM_CODE_5273",
        "MSG_SYM_CODE_5274",
        "MSG_SYM_CODE_5275"
};
//+------------------------------------------------------------------+
//| Array of execution time error messages (5300 - 5310)             |
//| (Custom symbols)                                                 |
//+------------------------------------------------------------------+
string messages_runtime_custom_symbol[] =
    {
        "MSG_SYM_CODE_5300",
        "MSG_SYM_CODE_5301",
        "MSG_SYM_CODE_5302",
        "MSG_SYM_CODE_5303",
        "MSG_SYM_CODE_5304",
        "MSG_SYM_CODE_5305",
        "MSG_SYM_CODE_5306",
        "MSG_SYM_CODE_5307",
        "MSG_SYM_CODE_5308",
        "MSG_SYM_CODE_5309",
        "MSG_SYM_CODE_5310"
};
//+------------------------------------------------------------------+
//| Array of execution time error messages (5400 - 5402)             |
//| (Economic calendar)                                              |
//+------------------------------------------------------------------+
string messages_runtime_calendar[] =
    {
        "MSG_SYM_CODE_5400",
        "MSG_SYM_CODE_5401",
        "MSG_SYM_CODE_5402"
};
#ifdef __MQL4__
//+------------------------------------------------------------------+
//| Array of messages for MQL4 trade server return codes (0 - 150)   |
//+------------------------------------------------------------------+
string messages_ts_ret_code_mql4[] =
    {
        "MSG_SYM_MQL4_CODE_0",
        "MSG_SYM_MQL4_CODE_1",
        "MSG_SYM_MQL4_CODE_2",
        "MSG_SYM_MQL4_CODE_3",
        "MSG_SYM_MQL4_CODE_4",
        "MSG_SYM_MQL4_CODE_5",
        "MSG_SYM_MQL4_CODE_6",
        "MSG_SYM_MQL4_CODE_7",
        "MSG_SYM_MQL4_CODE_8",
        "MSG_SYM_MQL4_CODE_9",
        "MSG_SYM_MQL4_CODE_64",
        "MSG_SYM_MQL4_CODE_65",
        "MSG_SYM_MQL4_CODE_128",
        "MSG_SYM_MQL4_CODE_129",
        "MSG_SYM_MQL4_CODE_130",
        "MSG_SYM_MQL4_CODE_131",
        "MSG_SYM_MQL4_CODE_132",
        "MSG_SYM_MQL4_CODE_133",
        "MSG_SYM_MQL4_CODE_134",
        "MSG_SYM_MQL4_CODE_135",
        "MSG_SYM_MQL4_CODE_136",
        "MSG_SYM_MQL4_CODE_137",
        "MSG_SYM_MQL4_CODE_138",
        "MSG_SYM_MQL4_CODE_139",
        "MSG_SYM_MQL4_CODE_140",
        "MSG_SYM_MQL4_CODE_141",
        "MSG_SYM_MQL4_CODE_142",
        "MSG_SYM_MQL4_CODE_143",
        "MSG_SYM_MQL4_CODE_144",
        "MSG_SYM_MQL4_CODE_145",
        "MSG_SYM_MQL4_CODE_146",
        "MSG_SYM_MQL4_CODE_147",
        "MSG_SYM_MQL4_CODE_148",
        "MSG_SYM_MQL4_CODE_149",
        "MSG_SYM_MQL4_CODE_150"
};
//+------------------------------------------------------------------+
//| Array of MQL4 execution time error messages (4000 - 4030)        |
//+------------------------------------------------------------------+
string messages_runtime_4000_4030[] =
    {
        "MSG_SYM_MQL4_CODE_4000",
        "MSG_SYM_MQL4_CODE_4001",
        "MSG_SYM_MQL4_CODE_4002",
        "MSG_SYM_MQL4_CODE_4003",
        "MSG_SYM_MQL4_CODE_4004",
        "MSG_SYM_MQL4_CODE_4005",
        "MSG_SYM_MQL4_CODE_4006",
        "MSG_SYM_MQL4_CODE_4007",
        "MSG_SYM_MQL4_CODE_4008",
        "MSG_SYM_MQL4_CODE_4009",
        "MSG_SYM_MQL4_CODE_4010",
        "MSG_SYM_MQL4_CODE_4011",
        "MSG_SYM_MQL4_CODE_4012",
        "MSG_SYM_MQL4_CODE_4013",
        "MSG_SYM_MQL4_CODE_4014",
        "MSG_SYM_MQL4_CODE_4015",
        "MSG_SYM_MQL4_CODE_4016",
        "MSG_SYM_MQL4_CODE_4017",
        "MSG_SYM_MQL4_CODE_4018",
        "MSG_SYM_MQL4_CODE_4019",
        "MSG_SYM_MQL4_CODE_4020",
        "MSG_SYM_MQL4_CODE_4021",
        "MSG_SYM_MQL4_CODE_4022",
        "MSG_SYM_MQL4_CODE_4023",
        "MSG_SYM_MQL4_CODE_4024",
        "MSG_SYM_MQL4_CODE_4025",
        "MSG_SYM_MQL4_CODE_4026",
        "MSG_SYM_MQL4_CODE_4027",
        "MSG_SYM_MQL4_CODE_4028",
        "MSG_SYM_MQL4_CODE_4029",
        "MSG_SYM_MQL4_CODE_4030"
};
//+------------------------------------------------------------------+
//| Array of MQL4 execution time error messages (4050 - 4075)        |
//+------------------------------------------------------------------+
string messages_runtime_4050_4075[] =
    {
        "MSG_SYM_MQL4_CODE_4050",
        "MSG_SYM_MQL4_CODE_4051",
        "MSG_SYM_MQL4_CODE_4052",
        "MSG_SYM_MQL4_CODE_4053",
        "MSG_SYM_MQL4_CODE_4054",
        "MSG_SYM_MQL4_CODE_4055",
        "MSG_SYM_MQL4_CODE_4056",
        "MSG_SYM_MQL4_CODE_4057",
        "MSG_SYM_MQL4_CODE_4058",
        "MSG_SYM_MQL4_CODE_4059",
        "MSG_SYM_MQL4_CODE_4060",
        "MSG_SYM_MQL4_CODE_4061",
        "MSG_SYM_MQL4_CODE_4062",
        "MSG_SYM_MQL4_CODE_4063",
        "MSG_SYM_MQL4_CODE_4064",
        "MSG_SYM_MQL4_CODE_4065",
        "MSG_SYM_MQL4_CODE_4066",
        "MSG_SYM_MQL4_CODE_4067",
        "MSG_SYM_MQL4_CODE_4068",
        "MSG_SYM_MQL4_CODE_4069",
        "MSG_SYM_MQL4_CODE_4070",
        "MSG_SYM_MQL4_CODE_4071",
        "MSG_SYM_MQL4_CODE_4072",
        "MSG_SYM_MQL4_CODE_4073",
        "MSG_SYM_MQL4_CODE_4074",
        "MSG_SYM_MQL4_CODE_4075"
};
//+------------------------------------------------------------------+
//| Array of MQL4 execution time error messages (4099 - 4112)        |
//+------------------------------------------------------------------+
string messages_runtime_4099_4112[] =
    {
        "MSG_SYM_MQL4_CODE_4099",
        "MSG_SYM_MQL4_CODE_4100",
        "MSG_SYM_MQL4_CODE_4101",
        "MSG_SYM_MQL4_CODE_4102",
        "MSG_SYM_MQL4_CODE_4103",
        "MSG_SYM_MQL4_CODE_4104",
        "MSG_SYM_MQL4_CODE_4105",
        "MSG_SYM_MQL4_CODE_4106",
        "MSG_SYM_MQL4_CODE_4107",
        "MSG_SYM_MQL4_CODE_4108",
        "MSG_SYM_MQL4_CODE_4109",
        "MSG_SYM_MQL4_CODE_4110",
        "MSG_SYM_MQL4_CODE_4111",
        "MSG_SYM_MQL4_CODE_4112"
};
//+------------------------------------------------------------------+
//| Array of MQL4 execution time error messages (4200 - 4220)        |
//+------------------------------------------------------------------+
string messages_runtime_4200_4220[] =
    {
        "MSG_SYM_MQL4_CODE_4200",
        "MSG_SYM_MQL4_CODE_4201",
        "MSG_SYM_MQL4_CODE_4202",
        "MSG_SYM_MQL4_CODE_4203",
        "MSG_SYM_MQL4_CODE_4204",
        "MSG_SYM_MQL4_CODE_4205",
        "MSG_SYM_MQL4_CODE_4206",
        "MSG_SYM_MQL4_CODE_4207",
        "MSG_SYM_MQL4_CODE_4208",
        "MSG_SYM_MQL4_CODE_4209",
        "MSG_SYM_MQL4_CODE_4210",
        "MSG_SYM_MQL4_CODE_4211",
        "MSG_SYM_MQL4_CODE_4212",
        "MSG_SYM_MQL4_CODE_4213",
        "MSG_SYM_MQL4_CODE_4214",
        "MSG_SYM_MQL4_CODE_4215",
        "MSG_SYM_MQL4_CODE_4216",
        "MSG_SYM_MQL4_CODE_4217",
        "MSG_SYM_MQL4_CODE_4218",
        "MSG_SYM_MQL4_CODE_4219",
        "MSG_SYM_MQL4_CODE_4220"
};
//+------------------------------------------------------------------+
//| Array of MQL4 execution time error messages (4250 - 4266)        |
//+------------------------------------------------------------------+
string messages_runtime_4250_4266[] =
    {
        "MSG_SYM_MQL4_CODE_4250",
        "MSG_SYM_MQL4_CODE_4251",
        "MSG_SYM_MQL4_CODE_4252",
        "MSG_SYM_MQL4_CODE_4253",
        "MSG_SYM_MQL4_CODE_4254",
        "MSG_SYM_MQL4_CODE_4255",
        "MSG_SYM_MQL4_CODE_4256",
        "MSG_SYM_MQL4_CODE_4257",
        "MSG_SYM_MQL4_CODE_4258",
        "MSG_SYM_MQL4_CODE_4259",
        "MSG_SYM_MQL4_CODE_4260",
        "MSG_SYM_MQL4_CODE_4261",
        "MSG_SYM_MQL4_CODE_4262",
        "MSG_SYM_MQL4_CODE_4263",
        "MSG_SYM_MQL4_CODE_4264",
        "MSG_SYM_MQL4_CODE_4265",
        "MSG_SYM_MQL4_CODE_4266"
};
//+------------------------------------------------------------------+
//| Array of MQL4 execution time error messages (5001 - 5029)        |
//+------------------------------------------------------------------+
string messages_runtime_5001_5029[] =
    {
        "MSG_SYM_MQL4_CODE_5001",
        "MSG_SYM_MQL4_CODE_5002",
        "MSG_SYM_MQL4_CODE_5003",
        "MSG_SYM_MQL4_CODE_5004",
        "MSG_SYM_MQL4_CODE_5005",
        "MSG_SYM_MQL4_CODE_5006",
        "MSG_SYM_MQL4_CODE_5007",
        "MSG_SYM_MQL4_CODE_5008",
        "MSG_SYM_MQL4_CODE_5009",
        "MSG_SYM_MQL4_CODE_5010",
        "MSG_SYM_MQL4_CODE_5011",
        "MSG_SYM_MQL4_CODE_5012",
        "MSG_SYM_MQL4_CODE_5013",
        "MSG_SYM_MQL4_CODE_5014",
        "MSG_SYM_MQL4_CODE_5015",
        "MSG_SYM_MQL4_CODE_5016",
        "MSG_SYM_MQL4_CODE_5017",
        "MSG_SYM_MQL4_CODE_5018",
        "MSG_SYM_MQL4_CODE_5019",
        "MSG_SYM_MQL4_CODE_5020",
        "MSG_SYM_MQL4_CODE_5021",
        "MSG_SYM_MQL4_CODE_5022",
        "MSG_SYM_MQL4_CODE_5023",
        "MSG_SYM_MQL4_CODE_5024",
        "MSG_SYM_MQL4_CODE_5025",
        "MSG_SYM_MQL4_CODE_5026",
        "MSG_SYM_MQL4_CODE_5027",
        "MSG_SYM_MQL4_CODE_5028",
        "MSG_SYM_MQL4_CODE_5029"
};
//+------------------------------------------------------------------+
//| Array of MQL4 execution time error messages (5200 - 5203)        |
//+------------------------------------------------------------------+
string messages_runtime_5200_5203[] =
    {
        "MSG_SYM_MQL4_CODE_5200",
        "MSG_SYM_MQL4_CODE_5201",
        "MSG_SYM_MQL4_CODE_5202",
        "MSG_SYM_MQL4_CODE_5203"
};
#endif
        //+------------------------------------------------------------------+
