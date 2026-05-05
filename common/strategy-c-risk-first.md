# Strategy C: Risk-First

**Use when:** High uncertainty in one or more areas, experimental integrations, unfamiliar technology.

**Decompose:** Isolate uncertain areas into spike units with time-box and clear question to answer. Spikes produce decisions + proof-of-concept, not production code. Remaining units planned after spike. Spikes are always unit 01 or 02.

**Example:**

```text
01-spike-realtime    (validate WebSocket approach, time-boxed 3 days)
02-foundation        (built on validated approach from spike)
```text
