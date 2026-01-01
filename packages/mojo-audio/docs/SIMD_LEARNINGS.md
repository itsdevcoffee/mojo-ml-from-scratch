# SIMD Optimization Learnings

**Date:** December 31, 2025

---

## Experiment: Naive SIMD Implementation

### What We Tried

Added SIMD vectorization to:
1. `apply_window_simd()` - Element-wise window multiplication
2. `power_spectrum_simd()` - Complex power computation

**Implementation approach:**
```mojo
alias simd_w = 4

# Load into SIMD
var sig_simd = SIMD[DType.float64, simd_w]()
for j in range(simd_w):
    sig_simd[j] = signal[i + j]  # Manual load

# SIMD operation
var result_simd = sig_simd * window_simd

# Store from SIMD
for j in range(simd_w):
    result[i + j] = result_simd[j]  # Manual store
```

### Results

**Performance DECREASED:**

| Version | 30s Audio Time | Change |
|---------|----------------|--------|
| Scalar (before) | 476ms | Baseline |
| SIMD (naive) | 562ms | **+18% slower!** ❌ |

---

## Why Naive SIMD Failed

### Problem 1: Manual Load/Store Overhead

**The bottleneck:**
```mojo
for j in range(simd_w):
    sig_simd[j] = signal[i + j]  // Scalar loop!
```

- **Expected:** Direct memory load into SIMD register
- **Reality:** Scalar loop defeats SIMD purpose
- **Overhead:** Loop iteration + bounds checking

### Problem 2: List Memory Layout

**Issue:** `List[Float64]` not optimized for SIMD access
- Non-contiguous memory possible
- No alignment guarantees
- Indirect access through List structure

**Need:** Raw pointer or Buffer with guaranteed layout

### Problem 3: Small SIMD Width

**Current:** SIMD width = 4 (process 4 Float64 at once)
- Modern CPUs can do 8 (AVX-512)
- DGX Spark ARM: Different optimal width

### Problem 4: Amortization

**Window application overhead:**
- Small data: 400 samples per frame
- SIMD setup cost not amortized
- Better for larger continuous buffers

---

## Lessons Learned

### ✅ What WORKED

1. **SIMD code compiles and runs**
2. **Tests still pass** - Correctness maintained
3. **Learning SIMD syntax** - Now understand Mojo SIMD
4. **Identified real bottlenecks** - Not what we expected!

### ❌ What DIDN'T Work

1. **Manual load/store** - Too much overhead
2. **List-based SIMD** - Wrong memory layout
3. **Small chunk sizes** - Can't amortize SIMD cost
4. **Naive vectorization** - Need smarter approach

---

## Correct SIMD Approach

### Strategy 1: Pointer-Based SIMD

**Use raw pointers for direct memory access:**
```mojo
fn apply_window_simd_proper(
    signal: UnsafePointer[Float64],
    window: UnsafePointer[Float64],
    result: UnsafePointer[Float64],
    length: Int
):
    alias simd_w = 8

    for i in range(0, length, simd_w):
        # Direct SIMD load from memory
        var sig = signal.load[width=simd_w](i)
        var win = window.load[width=simd_w](i)

        # SIMD operation
        var res = sig * win

        # Direct SIMD store to memory
        result.store(i, res)
```

**Benefits:**
- No manual load/store loops
- Direct memory operations
- Hardware SIMD instructions used
- Much faster!

### Strategy 2: Buffer-Based Processing

**Use Mojo Buffers instead of Lists:**
```mojo
from memory import Buffer

fn process_audio_simd(audio: Buffer[Float64]) -> Buffer[Float64]:
    # SIMD operations on contiguous memory
    # ...
```

### Strategy 3: Batch Processing

**Process entire spectrogram at once:**
- Don't SIMD individual frames (400 samples too small)
- SIMD across all 3000 frames simultaneously
- Better amortization of SIMD overhead

---

## Real Bottlenecks (Profiling Needed)

**Current theory (to validate):**
1. **FFT recursion** - Cache misses, function call overhead
2. **Memory allocation** - Many small List creations
3. **Mel filterbank** - Triple nested loop, not vectorized
4. **List operations** - Indirection overhead

**Next steps:**
- Profile to find actual hotspots
- Use Buffer/Tensor instead of List
- Pointer-based SIMD for large arrays
- Algorithmic improvements (iterative FFT)

---

## Action Plan

### Phase 5a: Proper SIMD (Revised)

**Don't:**
- ❌ Manually load/store in loops
- ❌ SIMD small chunks (400 samples)
- ❌ Use List for SIMD operations

**Do:**
- ✅ Use UnsafePointer for direct access
- ✅ SIMD large contiguous buffers
- ✅ Optimize memory layout first
- ✅ Profile before optimizing

### Phase 5b: Algorithm Improvements

**Higher impact than SIMD:**
1. **Iterative FFT** - Better cache locality
2. **Pre-allocate memory** - Reduce allocations
3. **Better data structures** - Tensor instead of List[List]
4. **Batch operations** - Process multiple frames together

---

## Conclusion

**Key Learning:**
> SIMD is not a magic speedup - naive vectorization can make things slower!

**What we gained:**
- Understanding of Mojo SIMD syntax ✓
- Knowledge of proper SIMD patterns ✓
- Identified real optimization needs ✓
- Valuable learning experience ✓

**Next approach:**
- Keep naive scalar version (it's correct!)
- Focus on algorithmic improvements
- Use proper pointer-based SIMD when ready
- Profile first, optimize second

**Current status:**
- Scalar implementation: 476ms (acceptable for MVP)
- SIMD functions exist but not used (kept for future)
- Tests all passing ✓
- Ready for integration as-is

---

**Learning:** Sometimes the best optimization is better algorithms, not just SIMD!
