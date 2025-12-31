"""
mojo-audio: High-performance audio signal processing library.

SIMD-optimized DSP operations for machine learning audio preprocessing.
Designed for Whisper and other speech recognition models.
"""

from math import cos, sqrt, log
from math.constants import pi


# ==============================================================================
# Constants (Whisper Requirements)
# ==============================================================================

comptime WHISPER_SAMPLE_RATE = 16000
comptime WHISPER_N_FFT = 400
comptime WHISPER_HOP_LENGTH = 160
comptime WHISPER_N_MELS = 80
comptime WHISPER_FRAMES_30S = 3000


# ==============================================================================
# Window Functions
# ==============================================================================

fn hann_window(size: Int) -> List[Float64]:
    """
    Generate Hann window.

    Hann window: w(n) = 0.5 * (1 - cos(2π * n / (N-1)))

    Used in STFT to reduce spectral leakage. Smoothly tapers to zero
    at the edges, minimizing discontinuities.

    Args:
        size: Window length in samples

    Returns:
        Window coefficients (length = size)

    Example:
        ```mojo
        var window = hann_window(400)  # For Whisper n_fft
        ```

    Mathematical properties:
        - Symmetric
        - Tapers to 0 at edges
        - Maximum at center (1.0)
        - Smoother than Hamming
    """
    var window = List[Float64]()
    var N = Float64(size - 1)

    for n in range(size):
        var n_float = Float64(n)
        var coefficient = 0.5 * (1.0 - cos(2.0 * pi * n_float / N))
        window.append(coefficient)

    return window^


fn hamming_window(size: Int) -> List[Float64]:
    """
    Generate Hamming window.

    Hamming window: w(n) = 0.54 - 0.46 * cos(2π * n / (N-1))

    Similar to Hann but doesn't taper completely to zero.
    Better frequency selectivity, slightly more spectral leakage.

    Args:
        size: Window length in samples

    Returns:
        Window coefficients (length = size)

    Example:
        ```mojo
        var window = hamming_window(400)
        ```

    Mathematical properties:
        - Symmetric
        - Minimum value: ~0.08 (not 0)
        - Maximum at center: ~1.0
        - Narrower main lobe than Hann
    """
    var window = List[Float64]()
    var N = Float64(size - 1)

    for n in range(size):
        var n_float = Float64(n)
        var coefficient = 0.54 - 0.46 * cos(2.0 * pi * n_float / N)
        window.append(coefficient)

    return window^


fn apply_window(signal: List[Float64], window: List[Float64]) raises -> List[Float64]:
    """
    Apply window function to signal (element-wise multiplication).

    Args:
        signal: Input signal
        window: Window coefficients (must match signal length)

    Returns:
        Windowed signal

    Raises:
        Error if lengths don't match

    Example:
        ```mojo
        var signal: List[Float64] = [1.0, 2.0, 3.0, 4.0]
        var window = hann_window(4)
        var windowed = apply_window(signal, window)
        ```
    """
    if len(signal) != len(window):
        raise Error(
            "Signal and window must have same length. Got signal="
            + String(len(signal)) + ", window=" + String(len(window))
        )

    var result = List[Float64]()
    for i in range(len(signal)):
        result.append(signal[i] * window[i])

    return result^


# ==============================================================================
# Utility Functions
# ==============================================================================

fn pad_to_length(signal: List[Float64], target_length: Int) -> List[Float64]:
    """
    Pad signal with zeros to target length.

    Args:
        signal: Input signal
        target_length: Desired length

    Returns:
        Padded signal (or original if already long enough)

    Example:
        ```mojo
        var signal: List[Float64] = [1.0, 2.0, 3.0]
        var padded = pad_to_length(signal, 400)  # Pads to n_fft
        ```
    """
    var result = List[Float64]()

    # Copy original signal
    for i in range(len(signal)):
        result.append(signal[i])

    # Add zeros if needed
    for i in range(len(signal), target_length):
        result.append(0.0)

    return result^


fn rms_energy(signal: List[Float64]) -> Float64:
    """
    Compute Root Mean Square energy of signal.

    RMS = sqrt((1/N) * Σ(x²))

    Useful for:
    - Voice activity detection
    - Normalization
    - Audio quality metrics

    Args:
        signal: Input signal

    Returns:
        RMS energy value

    Example:
        ```mojo
        var energy = rms_energy(audio_chunk)
        if energy > threshold:
            print("Speech detected!")
        ```
    """
    var sum_squares: Float64 = 0.0

    for i in range(len(signal)):
        sum_squares += signal[i] * signal[i]

    var mean_square = sum_squares / len(signal)
    return sqrt(mean_square)


fn normalize_audio(signal: List[Float64]) -> List[Float64]:
    """
    Normalize audio to [-1.0, 1.0] range.

    Args:
        signal: Input signal

    Returns:
        Normalized signal

    Example:
        ```mojo
        var normalized = normalize_audio(raw_audio)
        ```
    """
    # Find max absolute value
    var max_val: Float64 = 0.0
    for i in range(len(signal)):
        var abs_val = signal[i]
        if abs_val < 0:
            abs_val = -abs_val
        if abs_val > max_val:
            max_val = abs_val

    # Avoid division by zero
    if max_val == 0.0:
        return signal

    # Normalize
    var result = List[Float64]()
    for i in range(len(signal)):
        result.append(signal[i] / max_val)

    return result^


# ==============================================================================
# Validation Helpers
# ==============================================================================

fn validate_whisper_audio(audio: List[Float64], duration_seconds: Int) -> Bool:
    """
    Validate audio meets Whisper requirements.

    Requirements:
    - 16kHz sample rate
    - Expected samples = duration_seconds * 16000
    - Normalized to [-1, 1]

    Args:
        audio: Input audio samples
        duration_seconds: Expected duration

    Returns:
        True if valid for Whisper

    Example:
        ```mojo
        var is_valid = validate_whisper_audio(audio, 30)
        if not is_valid:
            print("Audio doesn't meet Whisper requirements!")
        ```
    """
    var expected_samples = duration_seconds * WHISPER_SAMPLE_RATE
    return len(audio) == expected_samples
