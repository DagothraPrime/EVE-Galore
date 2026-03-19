# EVE Galore — Phase 0 Test Build
## Installation & Testing Guide

### Installation

1. Copy the entire `zzz_dag_evegalore/` folder into your X4 `extensions/` directory
2. Launch X4, enable the extension in the Extension Manager
3. Start or load a game

The `zzz_dag_` prefix ensures late load order. No dependencies on other mods.

### What's included

Four new AI orders that appear in the ship command menu:

| Order | Ship req | Category | Menu location |
|---|---|---|---|
| **EVG: Command Ship** | L or XL | Trade | Right-click ship → Behaviour → Trade |
| **EVG: Jetcan Mine** | Any with mining | Mining | Right-click ship → Behaviour → Mining |
| **EVG: Fleet Trader** | M or L | Trade | Right-click ship → Behaviour → Trade |
| **EVG: ORE Mining Worksite** | L or XL | Mining | Right-click ship → Behaviour → Mining |

### Test procedure

**Minimum test: Command Ship + 1 Miner + 1 Trader**

1. **Get three ships:**
   - 1x L-class ship with cargo (e.g., Behemoth, Crane) → Command Ship
   - 1x S or M miner with mining weapons → Miner
   - 1x M trader with cargo → Trader

2. **Fly the L-class to a resource sector** (any sector with mineable resources)

3. **Set up the Command Ship:**
   - Right-click the L-class → Behaviour → Trade → **EVG: Command Ship**
   - Enable "Debug Logging" for first test
   - Confirm. Ship will park in place.

4. **Assign the Miner as subordinate:**
   - Right-click the miner → assign as subordinate of the L-class
   - Right-click the miner → Behaviour → Mining → **EVG: Jetcan Mine**
   - Set "Command Ship" to your L-class (should auto-detect if subordinate)
   - Set "Direct Transfer" to ON for first test (more reliable than jetcan)
   - Enable "Debug Logging"
   - Confirm. Miner will find resources, mine, and deliver to the L-class.

5. **Assign the Trader as subordinate:**
   - Right-click the trader → assign as subordinate of the L-class
   - Right-click the trader → Behaviour → Trade → **EVG: Fleet Trader**
   - Set "Command Ship" to your L-class
   - Optionally set a "Sell Station" override for predictable behavior
   - Enable "Debug Logging"
   - Confirm. Trader will wait at commander, evaluate cargo, haul to sell.

6. **Observe the loop:**
   - Miner mines → delivers to command ship → mines again
   - Command ship accumulates cargo
   - Trader loads from command ship → sells at station → returns

### Test: ORE Mining Worksite (siege mode)

1. Use the same L-class, but assign **EVG: ORE Mining Worksite** instead of Command Ship
2. The ship will lock in place (Industrial Core mode)
3. It cannot move until the order is cancelled or hull drops below 25%
4. Compression is a **no-op** in Phase 0 (no compressed ore wares defined yet)
5. Otherwise behaves like the Command Ship order

### Test: Jetcan Drop mode

1. On the miner, set "Direct Transfer" to **OFF**
2. The miner will drop cargo as floating containers near the command ship
3. The command ship's cargo drones should collect the drops
4. **Watch for:** Do cargo drones actually pick up the drops? How fast? Any drops lost?

### Debug logs

When "Debug Logging" is enabled, scripts write to:
```
[My Documents]/Egosoft/X4/[saveid]/logs/EVGFleetOps/
```

**IMPORTANT:** X4 only writes script log files when launched with the `-scriptlogfiles` parameter. Add this to your launch options.

Log files:
- `EVGCommandShip.txt` — Command ship tick log
- `EVGJetcanMine.txt` — Miner activity log
- `EVGFleetTrade.txt` — Trader activity log
- `EVGORECommand.txt` — ORE Command activity log

### Known limitations (Phase 0)

1. **Mining uses deplete_yield** — drains resources from the region directly into cargo. This is the same mechanism as vanilla OOS mining. There's no visual mining (shooting asteroids) in this phase. Ships fly to the resource position but the extraction is abstract.

2. **Compression is scaffolded but non-functional** — the ORE Command Config script has the compression loop code but the compression ware table is empty. When compressed ore wares are defined in Phase 1, compression will activate automatically.

3. **Trade finding is local** — the fleet trader searches the commander's sector for buy offers. If no stations in that sector want the mined ware, the trader will idle. Use the "Sell Station" override to point at a known buyer.

4. **No UI indicators** — there's no custom UI showing fleet status. Use the debug logs and the vanilla ship info panel.

5. **Save compatibility** — these orders save with the game. If you update the scripts, existing saves should handle it (version 1, no patch blocks needed yet).

### What to report

After testing, the key questions:

- [ ] Do all four orders appear in the ship command menu?
- [ ] Does the miner successfully find resources and fill cargo?
- [ ] Does the miner transfer/drop cargo to the command ship?
- [ ] Does the trader load from the command ship and sell successfully?
- [ ] Does the full loop (mine → transfer → sell → repeat) sustain?
- [ ] Does jetcan drop mode work? Do cargo drones collect?
- [ ] Does ORE Mining Worksite lock the ship in place?
- [ ] Does emergency unlock trigger below 25% hull?
- [ ] Are debug logs written correctly?
- [ ] Any errors in the X4 debug log / script log?

### Files in this build

```
zzz_dag_evegalore/
  content.xml                                    # Mod manifest
  t/0001-L044.xml                               # English text
  aiscripts/
    order.evg.commandship.xml                   # Command Ship
    order.evg.jetcanmine.xml                    # Jetcan Mining
    order.evg.fleettrade.xml                    # Fleet Trader
    order.evg.ore.commandconfig.xml             # ORE Mining Worksite
```
