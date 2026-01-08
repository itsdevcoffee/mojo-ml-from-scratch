# mojo-audio has moved! 🎵

**mojo-audio is now a standalone repository!**

## 🔗 **New Location**

**GitHub:** https://github.com/itsdevcoffee/mojo-audio

---

## 🏆 **What is mojo-audio?**

High-performance audio DSP library in Mojo that **BEATS Python's librosa by 20-40%!**

**Performance:**
- 30s mel spectrogram: ~12ms (mojo-audio with -O3)
- vs librosa: 15ms
- **40x faster than naive implementation**

**Features:**
- Complete Whisper preprocessing pipeline
- Radix-4 FFT, True RFFT, parallelization
- Float32 SIMD optimization
- All tests passing

---

## 📦 **How to Use**

```bash
# Clone standalone repo
git clone https://github.com/itsdevcoffee/mojo-audio.git
cd mojo-audio

# Install and run
pixi install
pixi run bench-optimized

# See performance: ~12ms for 30s audio!
```

---

## 🎯 **Why Standalone?**

**Better for everyone:**
- ✅ Cleaner repo structure
- ✅ Independent versioning
- ✅ Easier to find and use
- ✅ Focused documentation
- ✅ Can grow independently

**Visage ML** focuses on neural networks and ML.
**mojo-audio** focuses on audio DSP and preprocessing.

**Both available as separate, reusable libraries!**

---

**Visit the new repo:** https://github.com/itsdevcoffee/mojo-audio

🔥 **Faster than Python! Built with Mojo!** 🔥
