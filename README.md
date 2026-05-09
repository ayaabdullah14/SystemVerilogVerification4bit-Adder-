# SystemVerilog Verification — 4-bit Adder

![Data Structures](https://img.shields.io/badge/Data%20Structures-Queues%20%7C%20Linked%20Lists%20%7C%20Trees-blueviolet?style=for-the-badge)
![Digital Design](https://img.shields.io/badge/Digital%20Design-RTL%20%7C%20FSM%20%7C%20Logic%20Design-1BA0D7?style=for-the-badge)
![Verification](https://img.shields.io/badge/Verification-Testbench%20%7C%20Scoreboard%20%7C%20Randomization-success?style=for-the-badge)

---

## Overview

A SystemVerilog verification environment for a simple **4-bit adder** DUT. The testbench generates 20 randomized transactions, drives them through the DUT, monitors the output, and checks correctness in a scoreboard.

---

## File Structure

```
project/
├── adder.sv          # DUT — 4-bit adder with synchronous reset
├── interface.sv      # Interface connecting TB and DUT
├── wrapper.sv        # Module wrapper instantiating the DUT with interface
├── transaction.sv    # Transaction class (stimulus data)
├── generator.sv      # Generates randomized transactions
├── driver.sv         # Drives transactions onto the interface
├── monitor.sv        # Observes DUT outputs and forwards to scoreboard
├── scoreboard.sv     # Checks actual vs expected output
├── agent.sv          # Bundles generator, driver, and monitor
├── environment.sv    # Top-level environment (agent + scoreboard)
├── test.sv           # Test class — reset + environment run
└── testbench.sv      # Top-level module — clock, interface, test launch
```

---

## Architecture

```
┌─────────────────────────────────────────────────────┐
│                    top_testbench                    │
│                                                     │
│  ┌──────────────────────────────────────────────┐  │
│  │                 environment                  │  │
│  │                                              │  │
│  │  ┌──────────────────────────┐  ┌──────────┐ │  │
│  │  │          agent           │  │scoreboard│ │  │
│  │  │                          │  └──────────┘ │  │
│  │  │ generator → driver  ─────┼──→  DUT       │  │
│  │  │              ↑           │               │  │
│  │  │           monitor ───────┼──→ scoreboard │  │
│  │  └──────────────────────────┘               │  │
│  └──────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────┘
```

**Mailboxes (communication channels):**
- `gen2driv` — generator → driver (capacity 1, blocking)
- `mon2scb`  — monitor → scoreboard (unbounded)

---

## Component Descriptions

### `adder.sv` — DUT
4-bit adder with a clock, active-high reset, and a `valid` enable signal.
```
c = a + b   (when valid=1, registered on posedge clk)
Reset drives c to 0 on posedge reset.
```

### `transaction.sv`
Holds one stimulus packet: `rand a[3:0]`, `rand b[3:0]`, output `c[4:0]`, and `rand delay[3:0]` (constrained to 1–5 cycles).

### `generator.sv`
Creates and randomizes 20 transactions, puts each into `gen2driv` mailbox.

### `driver.sv`
- Gets a transaction from `gen2driv`
- Syncs to `posedge clk`
- Drives `a`, `b`, `valid` onto the interface (zeros on reset)
- Waits `delay` extra clock cycles between transactions

### `monitor.sv`
- Watches `posedge clk`
- When `valid` is high, captures `a`, `b`, `c` from the interface
- Sends captured transaction to `mon2scb`

### `scoreboard.sv`
- Receives transactions from `mon2scb`
- Computes `exp = a + b`
- Prints `PASS` or `FAIL — expected: X, actual: Y`

### `agent.sv`
Bundles generator, driver, and monitor. Runs all three in parallel with `fork/join_any`.

### `environment.sv`
Instantiates and connects the agent and scoreboard. Runs both with `fork/join`.

### `test.sv`
Applies reset for 10 time units, then calls `env.run()`.

### `testbench.sv`
Top module: generates clock (period = 2 units), instantiates interface + wrapper, launches test, ends simulation at t=300.

---



### Locally with Icarus Verilog
```bash
iverilog -g2012 -o adder_tb testbench.sv
vvp adder_tb
```

### View Waveforms
```bash
gtkwave dump.vcd
```

---

## Expected Output

```
[DRIVER] count=1  a=5  b=3  delay=2
[MONITOR] a=5 b=3 c=8
PASS
[DRIVER] count=2  a=12 b=7  delay=4
[MONITOR] a=12 b=7 c=19
PASS
...
```

All 20 transactions should print `PASS` if the DUT is correct.

---

## Signal Summary

| Signal | Width | Direction | Description |
|---|---|---|---|
| `clk` | 1 | Input | Clock |
| `reset` | 1 | Input | Active-high synchronous reset |
| `a` | 4 | Input | First operand |
| `b` | 4 | Input | Second operand |
| `valid` | 1 | Input | Enable addition |
| `c` | 5 | Output | Sum (a + b) |

---

## Notes

- The `delay` constraint (`[1:5]` cycles) spaces out transactions to avoid back-to-back collisions on the registered output.
- Waveform dump is written to `dump.vcd` and can be viewed in GTKWave or EPWave.
