"""
Window Functions Demo

Demonstrates Hann and Hamming windows for audio signal processing.
Shows how windowing reduces spectral leakage in STFT.
"""

from audio import (
    hann_window, hamming_window, apply_window,
    WHISPER_N_FFT
)


fn print_window_samples(window: List[Float64], name: String):
    """Print key samples from window."""
    var N = len(window)
    print(name, "window (size:", N, ")")
    print("  Start:  ", window[0])
    print("  1/4:    ", window[N // 4])
    print("  Center: ", window[N // 2])
    print("  3/4:    ", window[3 * N // 4])
    print("  End:    ", window[N - 1])
    print()


fn main() raises:
    print("\n" + "="*70)
    print("Window Functions Demo - mojo-audio")
    print("="*70 + "\n")

    # Example 1: Hann Window
    print("="*70)
    print("1. Hann Window")
    print("="*70 + "\n")

    var hann = hann_window(100)
    print_window_samples(hann, "Hann")

    print("Properties:")
    print("  - Tapers to exactly 0 at edges")
    print("  - Smooth bell curve shape")
    print("  - Maximum = 1.0 at center")
    print("  - Best for general-purpose STFT")
    print()

    # Example 2: Hamming Window
    print("="*70)
    print("2. Hamming Window")
    print("="*70 + "\n")

    var hamming = hamming_window(100)
    print_window_samples(hamming, "Hamming")

    print("Properties:")
    print("  - Minimum value ~0.08 (not 0)")
    print("  - Narrower main lobe than Hann")
    print("  - Better frequency selectivity")
    print("  - Slightly more spectral leakage")
    print()

    # Example 3: Apply Window to Signal
    print("="*70)
    print("3. Applying Window to Signal")
    print("="*70 + "\n")

    # Create test signal (constant amplitude)
    var signal: List[Float64] = []
    for i in range(10):
        signal.append(1.0)

    print("Original signal (constant 1.0):", signal)
    print()

    var windowed = apply_window(signal, hann_window(10))
    print("After Hann window:            ", windowed)
    print()

    print("Notice:")
    print("  - Edges attenuated to 0")
    print("  - Center remains close to 1.0")
    print("  - Smooth taper reduces discontinuities")
    print()

    # Example 4: Whisper-Compatible Window
    print("="*70)
    print("4. Whisper-Compatible Window (n_fft = 400)")
    print("="*70 + "\n")

    var whisper_window = hann_window(WHISPER_N_FFT)

    print("Created Hann window with size:", len(whisper_window))
    print("Whisper requirement:         ", WHISPER_N_FFT)
    print()

    print("Key properties:")
    print("  Edge value:  ", whisper_window[0])
    print("  Center value:", whisper_window[200])
    print("  Edge value:  ", whisper_window[399])
    print()

    print("✓ Ready for Whisper STFT preprocessing!")
    print()

    # Example 5: Why Windowing Matters
    print("="*70)
    print("5. Why Windowing Matters")
    print("="*70 + "\n")

    print("Without windowing:")
    print("  - Signal edges have sharp discontinuities")
    print("  - Creates spectral leakage (energy bleeds into other frequencies)")
    print("  - False frequency components in FFT")
    print()

    print("With Hann window:")
    print("  - Smooth taper to zero")
    print("  - Minimizes spectral leakage")
    print("  - Cleaner frequency representation")
    print("  - Better for speech recognition!")
    print()

    print("="*70)
    print("✓ Window functions are the foundation of STFT!")
    print("  Next: FFT operations → Mel filterbank → Full spectrogram")
    print("="*70 + "\n")
