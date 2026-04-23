# Strategy D: Parallel Streams

**Use when:** Multiple developers/sub-teams, mix of independent and dependent units, maximize parallelism.

**Decompose:** Identify dependency graph. Group independent units into parallel streams. Add sync units at merge points. Number parallel units with lane suffix (02a, 02b).

**Example:**
```
01-foundation        (everyone depends on this)
02a-user-auth        (stream A)
02b-data-pipeline    (stream B, parallel with 02a)
03-integration       (sync point: merges A and B)
```
