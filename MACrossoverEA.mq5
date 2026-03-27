//+------------------------------------------------------------------+
//|                                            MA_Crossover_EA.mq5   |
//|                          MA Crossover + ADX Filter - USD/JPY     |
//+------------------------------------------------------------------+
#property copyright "Madanw"
#property version   "2.00"

#include <Trade\Trade.mqh>

//--- Input Parameters
input int      FastMA_Period = 9;          // Fast MA Period
input int      SlowMA_Period = 21;         // Slow MA Period
input int      ADX_Period    = 14;         // ADX Period
input double   ADX_Minimum   = 25.0;       // Minimum ADX strength
input double   LotSize       = 0.01;       // Lot Size
input int      StopLoss      = 200;        // Stop Loss in points
input int      TakeProfit    = 400;        // Take Profit in points
input int      MagicNumber   = 12345;      // Unique EA identifier

//--- Global Variables
CTrade trade;
int fastMAHandle;
int slowMAHandle;
int adxHandle;

//+------------------------------------------------------------------+
//| Expert initialization function                                     |
//+------------------------------------------------------------------+
int OnInit()
  {
   fastMAHandle = iMA(_Symbol, _Period, FastMA_Period, 0, MODE_EMA, PRICE_CLOSE);
   slowMAHandle = iMA(_Symbol, _Period, SlowMA_Period, 0, MODE_EMA, PRICE_CLOSE);
   adxHandle    = iADX(_Symbol, _Period, ADX_Period);

   if(fastMAHandle == INVALID_HANDLE || 
      slowMAHandle == INVALID_HANDLE || 
      adxHandle    == INVALID_HANDLE)
     {
      Print("Error creating indicators!");
      return INIT_FAILED;
     }

trade.SetExpertMagicNumber(MagicNumber);
   return INIT_SUCCEEDED;
  }

//+------------------------------------------------------------------+
//| Expert deinitialization function                                   |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   IndicatorRelease(fastMAHandle);
   IndicatorRelease(slowMAHandle);
   IndicatorRelease(adxHandle);
  }

//+------------------------------------------------------------------+
//| Expert tick function                                               |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(!IsNewBar()) return;

   // Get MA values
   double fastMA[], slowMA[];
   ArraySetAsSeries(fastMA, true);
   ArraySetAsSeries(slowMA, true);

   if(CopyBuffer(fastMAHandle, 0, 0, 3, fastMA) < 3) return;
   if(CopyBuffer(slowMAHandle, 0, 0, 3, slowMA) < 3) return;

   // Get ADX value
   double adxVal[];
   ArraySetAsSeries(adxVal, true);
   if(CopyBuffer(adxHandle, 0, 0, 3, adxVal) < 3) return;

   // ADX filter — only trade in strong trends
   bool trendIsStrong = (adxVal[1] >= ADX_Minimum);

   // Crossover signals
   bool bullishCross = (fastMA[1] > slowMA[1]) && (fastMA[2] <= slowMA[2]);
   bool bearishCross = (fastMA[1] < slowMA[1]) && (fastMA[2] >= slowMA[2]);

   int openPositions = CountPositions();

   // BUY — crossover + strong trend
   if(bullishCross && trendIsStrong && openPositions == 0)
     {
      double sl  = _Point * StopLoss;
      double tp  = _Point * TakeProfit;
      double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
      trade.Buy(LotSize, _Symbol, ask, ask - sl, ask + tp, "MA+ADX Buy");
      Print("BUY | ADX: ", adxVal[1], " | Fast MA: ", fastMA[1], " | Slow MA: ", slowMA[1]);
     }

   // SELL — crossover + strong trend
   if(bearishCross && trendIsStrong && openPositions == 0)
     {
      double sl  = _Point * StopLoss;
      double tp  = _Point * TakeProfit;
      double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
      trade.Sell(LotSize, _Symbol, bid, bid + sl, bid - tp, "MA+ADX Sell");
      Print("SELL | ADX: ", adxVal[1], " | Fast MA: ", fastMA[1], " | Slow MA: ", slowMA[1]);
     }
  }

//+------------------------------------------------------------------+
//| Check if a new bar has opened                                      |
//+------------------------------------------------------------------+
bool IsNewBar()
  {
   static datetime lastBarTime = 0;
   datetime currentBarTime = iTime(_Symbol, _Period, 0);
   if(currentBarTime != lastBarTime)
     {
      lastBarTime = currentBarTime;
      return true;
     }
   return false;
  }

//+------------------------------------------------------------------+
//| Count open positions for this EA                                   |
//+------------------------------------------------------------------+
int CountPositions()
  {
   int count = 0;
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      if(PositionGetSymbol(i) == _Symbol &&
         PositionGetInteger(POSITION_MAGIC) == MagicNumber)
         count++;
     }
   return count;
  }
//+------------------------------------------------------------------+