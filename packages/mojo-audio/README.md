# mojo-audio 🎵

> **High-performance audio signal processing library in Mojo**

[![Mojo](https://img.shields.io/badge/Mojo-0.26.1-orange?logo=fire)](https://docs.modular.com/mojo/)
[![Status](https://img.shields.io/badge/status-Alpha-yellow)]()

SIMD-optimized audio DSP operations for machine learning preprocessing. Built from scratch to understand signal processing fundamentals.

---

## Features

### ✅ Implemented (Phase 1)

**Window Functions**
- `hann_window()` - Hann window (smooth taper to zero)
- `hamming_window()` - Hamming window (narrower main lobe)
- `apply_window()` - Apply window to signal
- Whisper-compatible (n_fft = 400)

**Utilities**
- `pad_to_length()` - Zero-padding
- `rms_energy()` - Signal energy calculation
- `normalize_audio()` - Normalize to [-1, 1]
- `validate_whisper_audio()` - Whisper requirement checks

### 🚧 In Progress (Phase 2)

- FFT (Fast Fourier Transform)
- RFFT (Real-valued FFT)
- STFT (Short-Time Fourier Transform)

### 📋 Planned (Phase 3+)

- Mel filterbank
- Mel spectrogram (Whisper-compatible)
- MFCC features
- SIMD optimization

---

## Quick Start

### Installation

From the parent repo:
```bash
cd visage-ml
pixi install
```

### Run Tests

```bash
pixi run audio-test
```

### Run Demo

```bash
pixi run audio-demo
```

---

## Usage

```mojo
from audio import hann_window, apply_window, WHISPER_N_FFT

fn main() raises:
    # Create Whisper-compatible window
    var window = hann_window(WHISPER_N_FFT)  # 400 samples

    # Apply to audio frame
    var audio_frame: List[Float64] = [...]  # 400 samples
    var windowed = apply_window(audio_frame, window)

    print("Ready for FFT!")
```

---

## API Reference

### Window Functions

**`hann_window(size: Int) -> List[Float64]`**
- Generates Hann window coefficients
- Formula: `w(n) = 0.5 * (1 - cos(2π * n / (N-1)))`
- Tapers to exactly 0 at edges
- Use for: General-purpose STFT

**`hamming_window(size: Int) -> List[Float64]`**
- Generates Hamming window coefficients
- Formula: `w(n) = 0.54 - 0.46 * cos(2π * n / (N-1))`
- Minimum value ~0.08 (doesn't reach 0)
- Use for: Better frequency selectivity

**`apply_window(signal: List[Float64], window: List[Float64]) -> List[Float64]`**
- Element-wise multiplication
- Raises error if lengths don't match

### Utilities

**`normalize_audio(signal: List[Float64]) -> List[Float64]`**
- Normalize to [-1.0, 1.0] range

**`rms_energy(signal: List[Float64]) -> Float64`**
- Compute RMS energy
- Useful for voice activity detection

**`pad_to_length(signal: List[Float64], target_length: Int) -> List[Float64]`**
- Zero-pad to target length

---

## Whisper Compatibility

### Requirements

Whisper expects:
- **Sample rate:** 16kHz
- **n_fft:** 400 samples (25ms window)
- **hop_length:** 160 samples (10ms hop)
- **n_mels:** 80 mel bins
- **Output shape:** (80, 3000) for 30s audio

### Validation

```mojo
from audio import validate_whisper_audio, WHISPER_SAMPLE_RATE

var audio: List[Float64] = [...]  # 30 seconds
var is_valid = validate_whisper_audio(audio, 30)
# Checks: len(audio) == 30 * 16000 = 480,000 samples
```

---

## Development Status

| Component | Status | Validated |
|-----------|--------|-----------|
| Window Functions | ✅ Complete | ✅ Tested |
| FFT | 🚧 In Progress | - |
| STFT | 📋 Planned | - |
| Mel Filterbank | 📋 Planned | - |
| Mel Spectrogram | 📋 Planned | - |
| SIMD Optimization | 📋 Planned | - |

---

## Roadmap

**Phase 1: Window Functions** ✅
- [x] Hann window
- [x] Hamming window
- [x] Tests & validation
- [x] Example usage

**Phase 2: FFT Operations** (Current)
- [ ] Cooley-Tukey FFT
- [ ] RFFT (real-valued)
- [ ] STFT implementation
- [ ] Validate against NumPy

**Phase 3: Mel Features**
- [ ] Hz ↔ Mel conversion
- [ ] Mel filterbank matrix
- [ ] Mel spectrogram pipeline
- [ ] Whisper compatibility validation

**Phase 4: Optimization**
- [ ] SIMD-optimized FFT
- [ ] Parallel filterbank application
- [ ] Benchmark vs librosa/torchaudio
- [ ] DGX Spark ARM optimization

---

## Why Mojo?

**Performance:**
- SIMD operations for DSP
- C-level speed for audio processing
- Zero-copy tensor operations

**Correctness:**
- Built from scratch with clear math
- Validated against reference implementations
- Educational - understand every line

**Integration:**
- Native MAX Engine compatibility
- Seamless with Mojo ML pipelines
- No Python dependencies

---

## Contributing

This is part of the Visage ML project. Contributions welcome!

**Current focus:** Implementing FFT operations (Phase 2)

**Areas for contribution:**
- SIMD optimization
- Additional window functions
- Performance benchmarks
- Documentation

---

## License

MIT License - see parent repository

---

## Related Projects

- **Visage ML** - Parent ML library with neural networks
- **Mojo** - The Mojo programming language
- **MAX Engine** - Modular's AI inference engine

---

**Part of the Visage ML ecosystem** 🔥
