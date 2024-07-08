//+------------------------------------------------------------------+
//|                                                   TestPart08.mq5 |
//|                                              Alireza Khodakarami |
//|                         https://www.youtube.com/@YourTradeMaster |
//+------------------------------------------------------------------+
#property copyright "Alireza Khodakarami"
#property link      "https://www.youtube.com/@YourTradeMaster"
#property version   "1.00"
//--- includes
#include <MT Core Lib\Base\Engine.mqh>
#include <Trade\Trade.mqh>
//--- enums
enum ENUM_BUTTONS
{
    BUTT_BUY,
    BUTT_BUY_LIMIT,
    BUTT_BUY_STOP,
    BUTT_BUY_STOP_LIMIT,
    BUTT_CLOSE_BUY,
    BUTT_CLOSE_BUY2,
    BUTT_CLOSE_BUY_BY_SELL,
    BUTT_SELL,
    BUTT_SELL_LIMIT,
    BUTT_SELL_STOP,
    BUTT_SELL_STOP_LIMIT,
    BUTT_CLOSE_SELL,
    BUTT_CLOSE_SELL2,
    BUTT_CLOSE_SELL_BY_BUY,
    BUTT_DELETE_PENDING,
    BUTT_CLOSE_ALL,
    BUTT_PROFIT_WITHDRAWAL,
    BUTT_SET_STOP_LOSS,
    BUTT_SET_TAKE_PROFIT,
    BUTT_TRAILING_ALL
};
#define TOTAL_BUTT   (20)
//--- structures
struct SDataButt
{
    string           name;
    string           text;
};
//--- input variables
input ulong    InpMagic             =  123;  // Magic number
input double   InpLots              =  0.1;  // Lots
input uint     InpStopLoss          =  50;   // StopLoss in points
input uint     InpTakeProfit        =  50;   // TakeProfit in points
input uint     InpDistance          =  50;   // Pending orders distance (points)
input uint     InpDistanceSL        =  50;   // StopLimit orders distance (points)
input uint     InpSlippage          =  0;    // Slippage in points
input double   InpWithdrawal        =  10;   // Withdrawal funds (in tester)
input uint     InpButtShiftX        =  40;   // Buttons X shift
input uint     InpButtShiftY        =  10;   // Buttons Y shift
input uint     InpTrailingStop      =  50;   // Trailing Stop (points)
input uint     InpTrailingStep      =  20;   // Trailing Step (points)
input uint     InpTrailingStart     =  0;    // Trailing Start (points)
input uint     InpStopLossModify    =  20;   // StopLoss for modification (points)
input uint     InpTakeProfitModify  =  60;   // TakeProfit for modification (points)
//--- global variables
CEngine        engine;
CTrade         trade;
SDataButt      butt_data[TOTAL_BUTT];
string         prefix;
double         lot;
double         withdrawal = (InpWithdrawal < 0.1 ? 0.1 : InpWithdrawal);
ulong          magic_number;
uint           stoploss;
uint           takeprofit;
uint           distance_pending;
uint           distance_stoplimit;
uint           slippage;
bool           trailing_on;
double         trailing_stop;
double         trailing_step;
uint           trailing_start;
uint           stoploss_to_modify;
uint           takeprofit_to_modify;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
//--- Calling the function displays the list of enumeration constants in the journal
//--- (the list is set in the strings 22 and 25 of the DELib.mqh file) for checking the constants validity
//EnumNumbersTest();
//--- check for undeleted objects
    if(IsPresentObects(prefix))
        ObjectsDeleteAll(0, prefix);
//--- set global variables
    prefix = MQLInfoString(MQL_PROGRAM_NAME) + "_";
    for(int i = 0; i < TOTAL_BUTT; i++)
    {
        butt_data[i].name = prefix + EnumToString((ENUM_BUTTONS)i);
        butt_data[i].text = EnumToButtText((ENUM_BUTTONS)i);
    }
    lot = NormalizeLot(Symbol(), fmax(InpLots, MinimumLots(Symbol()) * 2.0));
    magic_number = InpMagic;
    stoploss = InpStopLoss;
    takeprofit = InpTakeProfit;
    distance_pending = InpDistance;
    distance_stoplimit = InpDistanceSL;
    slippage = InpSlippage;
    trailing_stop = InpTrailingStop * Point();
    trailing_step = InpTrailingStep * Point();
    trailing_start = InpTrailingStart;
    stoploss_to_modify = InpStopLossModify;
    takeprofit_to_modify = InpTakeProfitModify;
//--- create buttons
    if(!CreateButtons(InpButtShiftX, InpButtShiftY))
        return INIT_FAILED;
//--- set button trailing
    ButtonState(butt_data[TOTAL_BUTT - 1].name, trailing_on);
//--- setting trade parameters
    trade.SetDeviationInPoints(slippage);
    trade.SetExpertMagicNumber(magic_number);
    trade.SetTypeFillingBySymbol(Symbol());
    trade.SetMarginMode();
    trade.LogLevel(LOG_LEVEL_NO);
//---
    return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
//--- delete objects
    ObjectsDeleteAll(0, prefix);
    Comment("");
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
//--- Initialize the last trading event
    static ENUM_TRADE_EVENT last_event = WRONG_VALUE;
//--- If working in the tester
    if(MQLInfoInteger(MQL_TESTER))
    {
        engine.OnTimer();
        PressButtonsControl();
    }
//--- If the last trading event changed
    if(engine.LastTradeEvent() != last_event)
    {
        last_event = engine.LastTradeEvent();
    }
//--- If the trailing flag is set
    if(trailing_on)
    {
        TrailingPositions();
        TrailingOrders();
    }
}
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
{
    if(!MQLInfoInteger(MQL_TESTER))
        engine.OnTimer();
}
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
    if(MQLInfoInteger(MQL_TESTER))
        return;
    if(id == CHARTEVENT_OBJECT_CLICK && StringFind(sparam, "BUTT_") > 0)
    {
        PressButtonEvents(sparam);
    }
    if(id >= CHARTEVENT_CUSTOM)
    {
        ushort event = ushort(id - CHARTEVENT_CUSTOM);
        Print(DFUN, "id=", id, ", event=", EnumToString((ENUM_TRADE_EVENT)event), ", lparam=", lparam, ", dparam=", DoubleToString(dparam, Digits()), ", sparam=", sparam);
    }
}
//+------------------------------------------------------------------+
//| Return the flag of a prefixed object presence                    |
//+------------------------------------------------------------------+
bool IsPresentObects(const string object_prefix)
{
    for(int i = ObjectsTotal(0) - 1; i >= 0; i--)
        if(StringFind(ObjectName(0, i, 0), object_prefix) > WRONG_VALUE)
            return true;
    return false;
}
//+------------------------------------------------------------------+
//| Tracking the buttons' status                                     |
//+------------------------------------------------------------------+
void PressButtonsControl(void)
{
    int total = ObjectsTotal(0);
    for(int i = 0; i < total; i++)
    {
        string obj_name = ObjectName(0, i);
        if(StringFind(obj_name, prefix + "BUTT_") < 0)
            continue;
        PressButtonEvents(obj_name);
    }
}
//+------------------------------------------------------------------+
//| Create the buttons panel                                         |
//+------------------------------------------------------------------+
bool CreateButtons(const int shift_x = 30, const int shift_y = 0)
{
    int h = 18, w = 84, offset = 2;
    int cx = offset + shift_x, cy = offset + shift_y + (h + 1) * (TOTAL_BUTT / 2) + 3 * h + 1;
    int x = cx, y = cy;
    int shift = 0;
    for(int i = 0; i < TOTAL_BUTT; i++)
    {
        x = x + (i == 7 ? w + 2 : 0);
        if(i == TOTAL_BUTT - 6) x = cx;
        y = (cy - (i - (i > 6 ? 7 : 0)) * (h + 1));
        if(!ButtonCreate(butt_data[i].name, x, y, (i < TOTAL_BUTT - 6 ? w : w * 2 + 2), h, butt_data[i].text, (i < 4 ? clrGreen : i > 6 && i < 11 ? clrRed : clrBlue)))
        {
            Alert(TextByLanguage("Could not create button \""), butt_data[i].text);
            return false;
        }
    }
    ChartRedraw(0);
    return true;
}
//+------------------------------------------------------------------+
//| Create the button                                                |
//+------------------------------------------------------------------+
bool ButtonCreate(const string name, const int x, const int y, const int w, const int h, const string text, const color clr, const string font = "Calibri", const int font_size = 8)
{
    if(ObjectFind(0, name) < 0)
    {
        if(!ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0))
        {
            Print(DFUN, TextByLanguage("Could not create button! Error code="), GetLastError());
            return false;
        }
        ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
        ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
        ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
        ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
        ObjectSetInteger(0, name, OBJPROP_XSIZE, w);
        ObjectSetInteger(0, name, OBJPROP_YSIZE, h);
        ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_LOWER);
        ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_LOWER);
        ObjectSetInteger(0, name, OBJPROP_FONTSIZE, font_size);
        ObjectSetString(0, name, OBJPROP_FONT, font);
        ObjectSetString(0, name, OBJPROP_TEXT, text);
        ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
        ObjectSetString(0, name, OBJPROP_TOOLTIP, "\n");
        ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, clrGray);
        return true;
    }
    return false;
}
//+------------------------------------------------------------------+
//| Return the button status                                         |
//+------------------------------------------------------------------+
bool ButtonState(const string name)
{
    return (bool)ObjectGetInteger(0, name, OBJPROP_STATE);
}
//+------------------------------------------------------------------+
//| Set the button status                                            |
//+------------------------------------------------------------------+
void ButtonState(const string name, const bool state)
{
    ObjectSetInteger(0, name, OBJPROP_STATE, state);
    if(name == butt_data[TOTAL_BUTT - 1].name)
    {
        if(state)
            ObjectSetInteger(0, name, OBJPROP_BGCOLOR, C'220,255,240');
        else
            ObjectSetInteger(0, name, OBJPROP_BGCOLOR, C'240,240,240');
    }
}
//+------------------------------------------------------------------+
//| Transform enumeration into the button text                       |
//+------------------------------------------------------------------+
string EnumToButtText(const ENUM_BUTTONS member)
{
    string txt = StringSubstr(EnumToString(member), 5);
    StringToLower(txt);
    StringReplace(txt, "set_take_profit", "Set TakeProfit");
    StringReplace(txt, "set_stop_loss", "Set StopLoss");
    StringReplace(txt, "trailing_all", "Trailing All");
    StringReplace(txt, "buy", "Buy");
    StringReplace(txt, "sell", "Sell");
    StringReplace(txt, "_limit", " Limit");
    StringReplace(txt, "_stop", " Stop");
    StringReplace(txt, "close_", "Close ");
    StringReplace(txt, "2", " 1/2");
    StringReplace(txt, "_by_", " by ");
    StringReplace(txt, "profit_", "Profit ");
    StringReplace(txt, "delete_", "Delete ");
    return txt;
}
//+------------------------------------------------------------------+
//| Handle pressing the buttons                                      |
//+------------------------------------------------------------------+
void PressButtonEvents(const string button_name)
{
//--- Convert button name into its string ID
    string button = StringSubstr(button_name, StringLen(prefix));
//--- If the button is pressed
    if(ButtonState(button_name))
    {
        //--- If the BUTT_BUY button is pressed: Open Buy position
        if(button == EnumToString(BUTT_BUY))
        {
            //--- Get the correct StopLoss and TakeProfit prices relative to StopLevel
            double sl = CorrectStopLoss(Symbol(), ORDER_TYPE_BUY, 0, stoploss);
            double tp = CorrectTakeProfit(Symbol(), ORDER_TYPE_BUY, 0, takeprofit);
            //--- Open Buy position
            trade.Buy(NormalizeLot(Symbol(), lot), Symbol(), 0, sl, tp);
        }
        //--- If the BUTT_BUY_LIMIT button is pressed: Place BuyLimit
        else if(button == EnumToString(BUTT_BUY_LIMIT))
        {
            //--- Get correct order placement relative to StopLevel
            double price_set = CorrectPricePending(Symbol(), ORDER_TYPE_BUY_LIMIT, distance_pending);
            //--- Get correct StopLoss and TakeProfit prices relative to the order placement level considering StopLevel
            double sl = CorrectStopLoss(Symbol(), ORDER_TYPE_BUY_LIMIT, price_set, stoploss);
            double tp = CorrectTakeProfit(Symbol(), ORDER_TYPE_BUY_LIMIT, price_set, takeprofit);
            //--- Set BuyLimit order
            trade.BuyLimit(lot, price_set, Symbol(), sl, tp);
        }
        //--- If the BUTT_BUY_STOP button is pressed: Set BuyStop
        else if(button == EnumToString(BUTT_BUY_STOP))
        {
            //--- Get correct order placement relative to StopLevel
            double price_set = CorrectPricePending(Symbol(), ORDER_TYPE_BUY_STOP, distance_pending);
            //--- Get correct StopLoss and TakeProfit prices relative to the order placement level considering StopLevel
            double sl = CorrectStopLoss(Symbol(), ORDER_TYPE_BUY_STOP, price_set, stoploss);
            double tp = CorrectTakeProfit(Symbol(), ORDER_TYPE_BUY_STOP, price_set, takeprofit);
            //--- Set BuyStop order
            trade.BuyStop(lot, price_set, Symbol(), sl, tp);
        }
        //--- If the BUTT_BUY_STOP_LIMIT button is pressed: Set BuyStopLimit
        else if(button == EnumToString(BUTT_BUY_STOP_LIMIT))
        {
            //--- Get the correct BuyStop order placement price relative to StopLevel
            double price_set_stop = CorrectPricePending(Symbol(), ORDER_TYPE_BUY_STOP, distance_pending);
            //--- Calculate BuyLimit order price relative to BuyStop level considering StopLevel
            double price_set_limit = CorrectPricePending(Symbol(), ORDER_TYPE_BUY_LIMIT, distance_stoplimit, price_set_stop);
            //--- Get correct StopLoss and TakeProfit prices relative to the order placement level considering StopLevel
            double sl = CorrectStopLoss(Symbol(), ORDER_TYPE_BUY_STOP, price_set_limit, stoploss);
            double tp = CorrectTakeProfit(Symbol(), ORDER_TYPE_BUY_STOP, price_set_limit, takeprofit);
            //--- Set BuyStopLimit order
            trade.OrderOpen(Symbol(), ORDER_TYPE_BUY_STOP_LIMIT, lot, price_set_limit, price_set_stop, sl, tp);
        }
        //--- If the BUTT_SELL button is pressed: Open Sell position
        else if(button == EnumToString(BUTT_SELL))
        {
            //--- Get the correct StopLoss and TakeProfit prices relative to StopLevel
            double sl = CorrectStopLoss(Symbol(), ORDER_TYPE_SELL, 0, stoploss);
            double tp = CorrectTakeProfit(Symbol(), ORDER_TYPE_SELL, 0, takeprofit);
            //--- Open Sell position
            trade.Sell(lot, Symbol(), 0, sl, tp);
        }
        //--- If the BUTT_SELL_LIMIT button is pressed: Set SellLimit
        else if(button == EnumToString(BUTT_SELL_LIMIT))
        {
            //--- Get correct order placement relative to StopLevel
            double price_set = CorrectPricePending(Symbol(), ORDER_TYPE_SELL_LIMIT, distance_pending);
            //--- Get correct StopLoss and TakeProfit prices relative to the order placement level considering StopLevel
            double sl = CorrectStopLoss(Symbol(), ORDER_TYPE_SELL_LIMIT, price_set, stoploss);
            double tp = CorrectTakeProfit(Symbol(), ORDER_TYPE_SELL_LIMIT, price_set, takeprofit);
            //--- Set SellLimit order
            trade.SellLimit(lot, price_set, Symbol(), sl, tp);
        }
        //--- If the BUTT_SELL_STOP button is pressed: Set SellStop
        else if(button == EnumToString(BUTT_SELL_STOP))
        {
            //--- Get correct order placement relative to StopLevel
            double price_set = CorrectPricePending(Symbol(), ORDER_TYPE_SELL_STOP, distance_pending);
            //--- Get correct StopLoss and TakeProfit prices relative to the order placement level considering StopLevel
            double sl = CorrectStopLoss(Symbol(), ORDER_TYPE_SELL_STOP, price_set, stoploss);
            double tp = CorrectTakeProfit(Symbol(), ORDER_TYPE_SELL_STOP, price_set, takeprofit);
            //--- Set SellStop order
            trade.SellStop(lot, price_set, Symbol(), sl, tp);
        }
        //--- If the BUTT_SELL_STOP_LIMIT button is pressed: Set SellStopLimit
        else if(button == EnumToString(BUTT_SELL_STOP_LIMIT))
        {
            //--- Get the correct SellStop order price relative to StopLevel
            double price_set_stop = CorrectPricePending(Symbol(), ORDER_TYPE_SELL_STOP, distance_pending);
            //--- Calculate SellLimit order price relative to SellStop level considering StopLevel
            double price_set_limit = CorrectPricePending(Symbol(), ORDER_TYPE_SELL_LIMIT, distance_stoplimit, price_set_stop);
            //--- Get correct StopLoss and TakeProfit prices relative to the order placement level considering StopLevel
            double sl = CorrectStopLoss(Symbol(), ORDER_TYPE_SELL_STOP, price_set_limit, stoploss);
            double tp = CorrectTakeProfit(Symbol(), ORDER_TYPE_SELL_STOP, price_set_limit, takeprofit);
            //--- Set SellStopLimit order
            trade.OrderOpen(Symbol(), ORDER_TYPE_SELL_STOP_LIMIT, lot, price_set_limit, price_set_stop, sl, tp);
        }
        //--- If the BUTT_CLOSE_BUY button is pressed: Close Buy with the maximum profit
        else if(button == EnumToString(BUTT_CLOSE_BUY))
        {
            //--- Get the list of all open positions
            CArrayObj* list = engine.GetListMarketPosition();
            //--- Select only Buy positions from the list
            list = CSelect::ByOrderProperty(list, ORDER_PROP_TYPE, POSITION_TYPE_BUY, EQUAL);
            //--- Sort the list by profit considering commission and swap
            list.Sort(SORT_BY_ORDER_PROFIT_FULL);
            //--- Get the index of the Buy position with the maximum profit
            int index = CSelect::FindOrderMax(list, ORDER_PROP_PROFIT_FULL);
            if(index > WRONG_VALUE)
            {
                COrder* position = list.At(index);
                if(position != NULL)
                {
                    //--- Get the Buy position ticket and close the position by the ticket
                    trade.PositionClose(position.Ticket());
                }
            }
        }
        //--- If the BUTT_CLOSE_BUY2 button is pressed: Close the half of the Buy with the maximum profit
        else if(button == EnumToString(BUTT_CLOSE_BUY2))
        {
            //--- Get the list of all open positions
            CArrayObj* list = engine.GetListMarketPosition();
            //--- Select only Buy positions from the list
            list = CSelect::ByOrderProperty(list, ORDER_PROP_TYPE, POSITION_TYPE_BUY, EQUAL);
            //--- Sort the list by profit considering commission and swap
            list.Sort(SORT_BY_ORDER_PROFIT_FULL);
            //--- Get the index of the Buy position with the maximum profit
            int index = CSelect::FindOrderMax(list, ORDER_PROP_PROFIT_FULL);
            if(index > WRONG_VALUE)
            {
                COrder* position = list.At(index);
                if(position != NULL)
                {
                    //--- Calculate the closed volume and close the half of the Buy position by the ticket
                    if(engine.IsHedge())
                        trade.PositionClosePartial(position.Ticket(), NormalizeLot(position.Symbol(), position.Volume() / 2.0));
                    else
                        trade.Sell(NormalizeLot(position.Symbol(), position.Volume() / 2.0));
                }
            }
        }
        //--- If the BUTT_CLOSE_BUY_BY_SELL button is pressed: Close Buy with the maximum profit by the opposite Sell with the maximum profit
        else if(button == EnumToString(BUTT_CLOSE_BUY_BY_SELL))
        {
            //--- Get the list of all open positions
            CArrayObj* list_buy = engine.GetListMarketPosition();
            //--- Select only Buy positions from the list
            list_buy = CSelect::ByOrderProperty(list_buy, ORDER_PROP_TYPE, POSITION_TYPE_BUY, EQUAL);
            //--- Sort the list by profit considering commission and swap
            list_buy.Sort(SORT_BY_ORDER_PROFIT_FULL);
            //--- Get the index of the Buy position with the maximum profit
            int index_buy = CSelect::FindOrderMax(list_buy, ORDER_PROP_PROFIT_FULL);
            //--- Get the list of all open positions
            CArrayObj* list_sell = engine.GetListMarketPosition();
            //--- Select only Sell positions from the list
            list_sell = CSelect::ByOrderProperty(list_sell, ORDER_PROP_TYPE, POSITION_TYPE_SELL, EQUAL);
            //--- Sort the list by profit considering commission and swap
            list_sell.Sort(SORT_BY_ORDER_PROFIT_FULL);
            //--- Get the index of the Sell position with the maximum profit
            int index_sell = CSelect::FindOrderMax(list_sell, ORDER_PROP_PROFIT_FULL);
            if(index_buy > WRONG_VALUE && index_sell > WRONG_VALUE)
            {
                //--- Select the Buy position with the maximum profit
                COrder* position_buy = list_buy.At(index_buy);
                //--- Select the Sell position with the maximum profit
                COrder* position_sell = list_sell.At(index_sell);
                if(position_buy != NULL && position_sell != NULL)
                {
                    //--- Close the Buy position by the opposite Sell one
                    trade.PositionCloseBy(position_buy.Ticket(), position_sell.Ticket());
                }
            }
        }
        //--- If the BUTT_CLOSE_SELL button is pressed: Close Sell with the maximum profit
        else if(button == EnumToString(BUTT_CLOSE_SELL))
        {
            //--- Get the list of all open positions
            CArrayObj* list = engine.GetListMarketPosition();
            //--- Select only Sell positions from the list
            list = CSelect::ByOrderProperty(list, ORDER_PROP_TYPE, POSITION_TYPE_SELL, EQUAL);
            //--- Sort the list by profit considering commission and swap
            list.Sort(SORT_BY_ORDER_PROFIT_FULL);
            //--- Get the index of the Sell position with the maximum profit
            int index = CSelect::FindOrderMax(list, ORDER_PROP_PROFIT_FULL);
            if(index > WRONG_VALUE)
            {
                COrder* position = list.At(index);
                if(position != NULL)
                {
                    //--- Get the Sell position ticket and close the position by the ticket
                    trade.PositionClose(position.Ticket());
                }
            }
        }
        //--- If the BUTT_CLOSE_SELL2 button is pressed: Close the half of the Sell with the maximum profit
        else if(button == EnumToString(BUTT_CLOSE_SELL2))
        {
            //--- Get the list of all open positions
            CArrayObj* list = engine.GetListMarketPosition();
            //--- Select only Sell positions from the list
            list = CSelect::ByOrderProperty(list, ORDER_PROP_TYPE, POSITION_TYPE_SELL, EQUAL);
            //--- Sort the list by profit considering commission and swap
            list.Sort(SORT_BY_ORDER_PROFIT_FULL);
            //--- Get the index of the Sell position with the maximum profit
            int index = CSelect::FindOrderMax(list, ORDER_PROP_PROFIT_FULL);
            if(index > WRONG_VALUE)
            {
                COrder* position = list.At(index);
                if(position != NULL)
                {
                    //--- Calculate the closed volume and close the half of the Sell position by the ticket
                    if(engine.IsHedge())
                        trade.PositionClosePartial(position.Ticket(), NormalizeLot(position.Symbol(), position.Volume() / 2.0));
                    else
                        trade.Buy(NormalizeLot(position.Symbol(), position.Volume() / 2.0));
                }
            }
        }
        //--- If the BUTT_CLOSE_SELL_BY_BUY button is pressed: Close Sell with the maximum profit by the opposite Buy with the maximum profit
        else if(button == EnumToString(BUTT_CLOSE_SELL_BY_BUY))
        {
            //--- Get the list of all open positions
            CArrayObj* list_sell = engine.GetListMarketPosition();
            //--- Select only Sell positions from the list
            list_sell = CSelect::ByOrderProperty(list_sell, ORDER_PROP_TYPE, POSITION_TYPE_SELL, EQUAL);
            //--- Sort the list by profit considering commission and swap
            list_sell.Sort(SORT_BY_ORDER_PROFIT_FULL);
            //--- Get the index of the Sell position with the maximum profit
            int index_sell = CSelect::FindOrderMax(list_sell, ORDER_PROP_PROFIT_FULL);
            //--- Get the list of all open positions
            CArrayObj* list_buy = engine.GetListMarketPosition();
            //--- Select only Buy positions from the list
            list_buy = CSelect::ByOrderProperty(list_buy, ORDER_PROP_TYPE, POSITION_TYPE_BUY, EQUAL);
            //--- Sort the list by profit considering commission and swap
            list_buy.Sort(SORT_BY_ORDER_PROFIT_FULL);
            //--- Get the index of the Buy position with the maximum profit
            int index_buy = CSelect::FindOrderMax(list_buy, ORDER_PROP_PROFIT_FULL);
            if(index_sell > WRONG_VALUE && index_buy > WRONG_VALUE)
            {
                //--- Select the Sell position with the maximum profit
                COrder* position_sell = list_sell.At(index_sell);
                //--- Select the Buy position with the maximum profit
                COrder* position_buy = list_buy.At(index_buy);
                if(position_sell != NULL && position_buy != NULL)
                {
                    //--- Close the Sell position by the opposite Buy one
                    trade.PositionCloseBy(position_sell.Ticket(), position_buy.Ticket());
                }
            }
        }
        //--- If the BUTT_CLOSE_ALL is pressed: Close all positions starting with the one with the least profit
        else if(button == EnumToString(BUTT_CLOSE_ALL))
        {
            //--- Get the list of all open positions
            CArrayObj* list = engine.GetListMarketPosition();
            if(list != NULL)
            {
                //--- Sort the list by profit considering commission and swap
                list.Sort(SORT_BY_ORDER_PROFIT_FULL);
                int total = list.Total();
                //--- In the loop from the position with the least profit
                for(int i = 0; i < total; i++)
                {
                    COrder* position = list.At(i);
                    if(position == NULL)
                        continue;
                    //--- close each position by its ticket
                    trade.PositionClose(position.Ticket());
                }
            }
        }
        //--- If the BUTT_DELETE_PENDING button is pressed: Remove the first pending order
        else if(button == EnumToString(BUTT_DELETE_PENDING))
        {
            //--- Get the list of all orders
            CArrayObj* list = engine.GetListMarketPendings();
            if(list != NULL)
            {
                //--- Sort the list by placement time
                list.Sort(SORT_BY_ORDER_TIME_OPEN_MSC);
                int total = list.Total();
                //--- In the loop from the position with the most amount of time
                for(int i = total - 1; i >= 0; i--)
                {
                    COrder* order = list.At(i);
                    if(order == NULL)
                        continue;
                    //--- delete the order by its ticket
                    trade.OrderDelete(order.Ticket());
                }
            }
        }
        //--- If the BUTT_PROFIT_WITHDRAWAL button is pressed: Withdraw funds from the account
        if(button == EnumToString(BUTT_PROFIT_WITHDRAWAL))
        {
            //--- If the program is launched in the tester
            if(MQLInfoInteger(MQL_TESTER))
            {
                //--- Emulate funds withdrawal
                TesterWithdrawal(withdrawal);
            }
        }
        //--- If the BUTT_SET_STOP_LOSS button is pressed: Place StopLoss to all orders and positions where it is not present
        if(button == EnumToString(BUTT_SET_STOP_LOSS))
        {
            SetStopLoss();
        }
        //--- If the BUTT_SET_TAKE_PROFIT button is pressed: Place TakeProfit to all orders and positions where it is not present
        if(button == EnumToString(BUTT_SET_TAKE_PROFIT))
        {
            SetTakeProfit();
        }
        //--- Wait for 1/10 of a second
        Sleep(100);
        //--- "Unpress" the button (if this is not a trailing button)
        if(button != EnumToString(BUTT_TRAILING_ALL))
            ButtonState(button_name, false);
        //--- If the BUTT_TRAILING_ALL button is pressed
        else
        {
            //--- Set the color of the active button
            ButtonState(button_name, true);
            trailing_on = true;
        }
        //--- re-draw the chart
        ChartRedraw();
    }
//--- Return the inactive button color (if this is a trailing button)
    else if(button == EnumToString(BUTT_TRAILING_ALL))
    {
        ButtonState(button_name, false);
        trailing_on = false;
        //--- re-draw the chart
        ChartRedraw();
    }
}
//+------------------------------------------------------------------+
//| Set StopLoss to all orders and positions                         |
//+------------------------------------------------------------------+
void SetStopLoss(void)
{
    if(stoploss_to_modify == 0)
        return;
//--- Set StopLoss to all positions where it is absent
    CArrayObj* list = engine.GetListMarketPosition();
    list = CSelect::ByOrderProperty(list, ORDER_PROP_SL, 0, EQUAL);
    if(list == NULL)
        return;
    int total = list.Total();
    for(int i = total - 1; i >= 0; i--)
    {
        COrder* position = list.At(i);
        if(position == NULL)
            continue;
        double sl = CorrectStopLoss(position.Symbol(), position.TypeByDirection(), 0, stoploss_to_modify);
        trade.PositionModify(position.Ticket(), sl, position.TakeProfit());
    }
//--- Set StopLoss to all pending orders where it is absent
    list = engine.GetListMarketPendings();
    list = CSelect::ByOrderProperty(list, ORDER_PROP_SL, 0, EQUAL);
    if(list == NULL)
        return;
    total = list.Total();
    for(int i = total - 1; i >= 0; i--)
    {
        COrder* order = list.At(i);
        if(order == NULL)
            continue;
        double sl = CorrectStopLoss(order.Symbol(), (ENUM_ORDER_TYPE)order.TypeOrder(), order.PriceOpen(), stoploss_to_modify);
        trade.OrderModify(order.Ticket(), order.PriceOpen(), sl, order.TakeProfit(), trade.RequestTypeTime(), trade.RequestExpiration(), order.PriceStopLimit());
    }
}
//+------------------------------------------------------------------+
//| Set TakeProfit to all orders and positions                       |
//+------------------------------------------------------------------+
void SetTakeProfit(void)
{
    if(takeprofit_to_modify == 0)
        return;
//--- Set TakeProfit to all positions where it is absent
    CArrayObj* list = engine.GetListMarketPosition();
    list = CSelect::ByOrderProperty(list, ORDER_PROP_TP, 0, EQUAL);
    if(list == NULL)
        return;
    int total = list.Total();
    for(int i = total - 1; i >= 0; i--)
    {
        COrder* position = list.At(i);
        if(position == NULL)
            continue;
        double tp = CorrectTakeProfit(position.Symbol(), position.TypeByDirection(), 0, takeprofit_to_modify);
        trade.PositionModify(position.Ticket(), position.StopLoss(), tp);
    }
//--- Set TakeProfit to all pending orders where it is absent
    list = engine.GetListMarketPendings();
    list = CSelect::ByOrderProperty(list, ORDER_PROP_TP, 0, EQUAL);
    if(list == NULL)
        return;
    total = list.Total();
    for(int i = total - 1; i >= 0; i--)
    {
        COrder* order = list.At(i);
        if(order == NULL)
            continue;
        double tp = CorrectTakeProfit(order.Symbol(), (ENUM_ORDER_TYPE)order.TypeOrder(), order.PriceOpen(), takeprofit_to_modify);
        trade.OrderModify(order.Ticket(), order.PriceOpen(), order.StopLoss(), tp, trade.RequestTypeTime(), trade.RequestExpiration(), order.PriceStopLimit());
    }
}
//+------------------------------------------------------------------+
//| Trailing stop of a position with the maximum profit              |
//+------------------------------------------------------------------+
void TrailingPositions(void)
{
    MqlTick tick;
    if(!SymbolInfoTick(Symbol(), tick))
        return;
    double stop_level = StopLevel(Symbol(), 2) * Point();
//--- Get the list of all open positions
    CArrayObj* list = engine.GetListMarketPosition();
//--- Select only Buy positions from the list
    CArrayObj* list_buy = CSelect::ByOrderProperty(list, ORDER_PROP_TYPE, POSITION_TYPE_BUY, EQUAL);
//--- Sort the list by profit considering commission and swap
    list_buy.Sort(SORT_BY_ORDER_PROFIT_FULL);
//--- Get the index of the Buy position with the maximum profit
    int index_buy = CSelect::FindOrderMax(list_buy, ORDER_PROP_PROFIT_FULL);
    if(index_buy > WRONG_VALUE)
    {
        COrder* buy = list_buy.At(index_buy);
        if(buy != NULL)
        {
            //--- Calculate the new StopLoss
            double sl = NormalizeDouble(tick.bid - trailing_stop, Digits());
            //--- If the price and the StopLevel based on it are higher than the new StopLoss (the distance by StopLevel is maintained)
            if(tick.bid - stop_level > sl)
            {
                //--- If the new StopLoss level exceeds the trailing step based on the current StopLoss
                if(buy.StopLoss() + trailing_step < sl)
                {
                    //--- If we trail at any profit or position profit in points exceeds the trailing start, modify StopLoss
                    if(trailing_start == 0 || buy.ProfitInPoints() > (int)trailing_start)
                        trade.PositionModify(buy.Ticket(), sl, buy.TakeProfit());
                }
            }
        }
    }
//--- Select only Sell positions from the list
    CArrayObj* list_sell = CSelect::ByOrderProperty(list, ORDER_PROP_TYPE, POSITION_TYPE_SELL, EQUAL);
//--- Sort the list by profit considering commission and swap
    list_sell.Sort(SORT_BY_ORDER_PROFIT_FULL);
//--- Get the index of the Sell position with the maximum profit
    int index_sell = CSelect::FindOrderMax(list_sell, ORDER_PROP_PROFIT_FULL);
    if(index_sell > WRONG_VALUE)
    {
        COrder* sell = list_sell.At(index_sell);
        if(sell != NULL)
        {
            //--- Calculate the new StopLoss
            double sl = NormalizeDouble(tick.ask + trailing_stop, Digits());
            //--- If the price and StopLevel based on it are below the new StopLoss (the distance by StopLevel is maintained)
            if(tick.ask + stop_level < sl)
            {
                //--- If the new StopLoss level is below the trailing step based on the current StopLoss or a position has no StopLoss
                if(sell.StopLoss() - trailing_step > sl || sell.StopLoss() == 0)
                {
                    //--- If we trail at any profit or position profit in points exceeds the trailing start, modify StopLoss
                    if(trailing_start == 0 || sell.ProfitInPoints() > (int)trailing_start)
                        trade.PositionModify(sell.Ticket(), sl, sell.TakeProfit());
                }
            }
        }
    }
}
//+------------------------------------------------------------------+
//| Trailing the farthest pending orders                             |
//+------------------------------------------------------------------+
void TrailingOrders(void)
{
    MqlTick tick;
    if(!SymbolInfoTick(Symbol(), tick))
        return;
    double stop_level = StopLevel(Symbol(), 2) * Point();
//--- Get the list of all placed orders
    CArrayObj* list = engine.GetListMarketPendings();
//--- Select only Buy orders from the list
    CArrayObj* list_buy = CSelect::ByOrderProperty(list, ORDER_PROP_DIRECTION, ORDER_TYPE_BUY, EQUAL);
//--- Sort the list by distance from the price in points (by profit in points)
    list_buy.Sort(SORT_BY_ORDER_PROFIT_PT);
//--- Get the index of the Buy order with the greatest distance
    int index_buy = CSelect::FindOrderMax(list_buy, ORDER_PROP_PROFIT_PT);
    if(index_buy > WRONG_VALUE)
    {
        COrder* buy = list_buy.At(index_buy);
        if(buy != NULL)
        {
            //--- If the order is below the price (BuyLimit) and it should be "elevated" following the price
            if(buy.TypeOrder() == ORDER_TYPE_BUY_LIMIT)
            {
                //--- Calculate the new order price and stop levels based on it
                double price = NormalizeDouble(tick.ask - trailing_stop, Digits());
                double sl = (buy.StopLoss() > 0 ? NormalizeDouble(price - (buy.PriceOpen() - buy.StopLoss()), Digits()) : 0);
                double tp = (buy.TakeProfit() > 0 ? NormalizeDouble(price + (buy.TakeProfit() - buy.PriceOpen()), Digits()) : 0);
                //--- If the calculated price is below the StopLevel distance based on Ask order price (the distance by StopLevel is maintained)
                if(price < tick.ask - stop_level)
                {
                    //--- If the calculated price exceeds the trailing step based on the order placement price, modify the order price
                    if(price > buy.PriceOpen() + trailing_step)
                    {
                        trade.OrderModify(buy.Ticket(), price, sl, tp, trade.RequestTypeTime(), trade.RequestExpiration(), buy.PriceStopLimit());
                    }
                }
            }
            //--- If the order exceeds the price (BuyStop and BuyStopLimit), and it should be "decreased" following the price
            else
            {
                //--- Calculate the new order price and stop levels based on it
                double price = NormalizeDouble(tick.ask + trailing_stop, Digits());
                double sl = (buy.StopLoss() > 0 ? NormalizeDouble(price - (buy.PriceOpen() - buy.StopLoss()), Digits()) : 0);
                double tp = (buy.TakeProfit() > 0 ? NormalizeDouble(price + (buy.TakeProfit() - buy.PriceOpen()), Digits()) : 0);
                //--- If the calculated price exceeds the StopLevel based on Ask order price (the distance by StopLevel is maintained)
                if(price > tick.ask + stop_level)
                {
                    //--- If the calculated price is lower than the trailing step based on order price, modify the order price
                    if(price < buy.PriceOpen() - trailing_step)
                    {
                        trade.OrderModify(buy.Ticket(), price, sl, tp, trade.RequestTypeTime(), trade.RequestExpiration(), (buy.PriceStopLimit() > 0 ? price - distance_stoplimit * Point() : 0));
                    }
                }
            }
        }
    }
//--- Select only Sell order from the list
    CArrayObj* list_sell = CSelect::ByOrderProperty(list, ORDER_PROP_DIRECTION, ORDER_TYPE_SELL, EQUAL);
//--- Sort the list by distance from the price in points (by profit in points)
    list_sell.Sort(SORT_BY_ORDER_PROFIT_PT);
//--- Get the index of the Sell order having the greatest distance
    int index_sell = CSelect::FindOrderMax(list_sell, ORDER_PROP_PROFIT_PT);
    if(index_sell > WRONG_VALUE)
    {
        COrder* sell = list_sell.At(index_sell);
        if(sell != NULL)
        {
            //--- If the order exceeds the price (SellLimit), and it needs to be "decreased" following the price
            if(sell.TypeOrder() == ORDER_TYPE_SELL_LIMIT)
            {
                //--- Calculate the new order price and stop levels based on it
                double price = NormalizeDouble(tick.bid + trailing_stop, Digits());
                double sl = (sell.StopLoss() > 0 ? NormalizeDouble(price + (sell.StopLoss() - sell.PriceOpen()), Digits()) : 0);
                double tp = (sell.TakeProfit() > 0 ? NormalizeDouble(price - (sell.PriceOpen() - sell.TakeProfit()), Digits()) : 0);
                //--- If the calculated price exceeds the StopLevel distance based on the Bid order price (the distance by StopLevel is maintained)
                if(price > tick.bid + stop_level)
                {
                    //--- If the calculated price is lower than the trailing step based on order price, modify the order price
                    if(price < sell.PriceOpen() - trailing_step)
                    {
                        trade.OrderModify(sell.Ticket(), price, sl, tp, trade.RequestTypeTime(), trade.RequestExpiration(), sell.PriceStopLimit());
                    }
                }
            }
            //--- If the order is below the price (SellStop and SellStopLimit), and it should be "elevated" following the price
            else
            {
                //--- Calculate the new order price and stop levels based on it
                double price = NormalizeDouble(tick.bid - trailing_stop, Digits());
                double sl = (sell.StopLoss() > 0 ? NormalizeDouble(price + (sell.StopLoss() - sell.PriceOpen()), Digits()) : 0);
                double tp = (sell.TakeProfit() > 0 ? NormalizeDouble(price - (sell.PriceOpen() - sell.TakeProfit()), Digits()) : 0);
                //--- If the calculated price is below the StopLevel distance based on the Bid order price (the distance by StopLevel is maintained)
                if(price < tick.bid - stop_level)
                {
                    //--- If the calculated price exceeds the trailing step based on the order placement price, modify the order price
                    if(price > sell.PriceOpen() + trailing_step)
                    {
                        trade.OrderModify(sell.Ticket(), price, sl, tp, trade.RequestTypeTime(), trade.RequestExpiration(), (sell.PriceStopLimit() > 0 ? price + distance_stoplimit * Point() : 0));
                    }
                }
            }
        }
    }
}
//+------------------------------------------------------------------+
