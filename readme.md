# EA Backtest Log

Personal log of MQL5 Expert Advisors and their MetaTrader 5 backtest results.

---

## Expert Advisors

### BB Scalper (`bb_scalper.mq5`) — v4.00
A mean-reversion scalper using Bollinger Bands with volume and session filters.

**Strategy:** Enters long when price closes at/below the lower band with high volume; enters short when price closes at/above the upper band with high volume. Only trades during London and NY sessions (GMT).

**Default Parameters (optimized over 3,625 passes):**
| Parameter | Value |
|---|---|
| BB Period | 15 |
| BB Deviation | 2.4 |
| Volume MA Period | 20 |
| Volume Multiplier | 2.0x above average |
| Stop Loss / Take Profit | 150 pts / 150 pts |
| Sessions | London 08:00–12:00, NY 13:00–17:00 GMT |

**Backtest results:** `bb-test1.xlsx`, `bb-test2.xlsx`

---

### MA Crossover EA (`MACrossoverEA.mq5`) — v2.00
A trend-following EA using EMA crossover filtered by ADX strength, designed for USD/JPY.

**Strategy:** Enters long on a bullish EMA crossover (fast > slow) and short on a bearish crossover, but only when ADX confirms a strong trend. One position at a time.

**Default Parameters:**
| Parameter | Value |
|---|---|
| Fast EMA | 9 |
| Slow EMA | 21 |
| ADX Period | 14 |
| ADX Minimum | 25.0 |
| Stop Loss / Take Profit | 200 pts / 400 pts |
| Pair | USD/JPY |

**Backtest results:** `MA-test1.xlsx`, `MA-reportv2.xlsx`

---

## Files

| File | Description |
|---|---|
| `bb_scalper.mq5` | Bollinger Bands scalper source |
| `MACrossoverEA.mq5` | MA Crossover EA source |
| `bb-test1.xlsx` | BB Scalper backtest run 1 |
| `bb-test2.xlsx` | BB Scalper backtest run 2 |
| `MA-test1.xlsx` | MA Crossover backtest run 1 |
| `MA-reportv2.xlsx` | MA Crossover report v2 |
