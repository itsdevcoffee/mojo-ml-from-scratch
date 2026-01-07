"""Tests for window functions."""

from audio import hann_window, hamming_window, apply_window


fn abs(x: Float32) -> Float32:
    """Absolute value."""
    if x < 0:
        return -x
    return x


fn test_hann_window_properties() raises:
    """Test mathematical properties of Hann window."""
    print("Testing Hann window properties...")

    var window = hann_window(400)

    # Check length
    assert_equal(len(window), 400, "Window should have 400 samples")

    # Check symmetry (window[i] should equal window[N-1-i])
    var N = len(window)
    for i in range(N // 2):
        assert_close(window[i], window[N - 1 - i], 1e-5, "Window should be symmetric")

    # Check edges taper to ~0 (Float32 tolerance)
    assert_close(window[0], 0.0, 1e-6, "Hann window should start at 0")
    assert_close(window[N - 1], 0.0, 1e-6, "Hann window should end at 0")

    # Check center is maximum (~1.0)
    var center_idx = N // 2
    assert_close(window[center_idx], 1.0, 0.01, "Hann window maximum should be ~1.0")

    # Check all values in [0, 1]
    for i in range(len(window)):
        assert_true(window[i] >= 0.0, "Window values should be >= 0")
        assert_true(window[i] <= 1.0, "Window values should be <= 1")

    print("  ✓ Hann window properties validated")


fn test_hamming_window_properties() raises:
    """Test mathematical properties of Hamming window."""
    print("Testing Hamming window properties...")

    var window = hamming_window(400)

    # Check length
    assert_equal(len(window), 400, "Window should have 400 samples")

    # Check symmetry (Float32 tolerance)
    var N = len(window)
    for i in range(N // 2):
        assert_close(window[i], window[N - 1 - i], 1e-5, "Window should be symmetric")

    # Hamming doesn't taper to 0 (minimum ~0.08)
    assert_true(window[0] > 0.05, "Hamming window should not reach 0")
    assert_true(window[N - 1] > 0.05, "Hamming window should not reach 0")

    # Check center is maximum
    var center_idx = N // 2
    assert_true(window[center_idx] > 0.9, "Hamming window maximum should be >0.9")

    print("  ✓ Hamming window properties validated")


fn test_hann_vs_hamming() raises:
    """Test differences between Hann and Hamming."""
    print("Testing Hann vs Hamming differences...")

    var hann = hann_window(100)
    var hamming = hamming_window(100)

    # At edges: Hann = 0, Hamming > 0
    assert_close(hann[0], 0.0, 1e-10, "Hann starts at 0")
    assert_true(hamming[0] > 0.05, "Hamming starts above 0")

    # Both should have same length
    assert_equal(len(hann), len(hamming), "Same length")

    # Center values similar but slightly different
    var center = 50
    var diff = abs(hann[center] - hamming[center])
    assert_true(diff < 0.1, "Centers should be close but not identical")

    print("  ✓ Hann vs Hamming differences validated")


fn test_apply_window() raises:
    """Test applying window to signal."""
    print("Testing apply_window...")

    # Simple test signal
    var signal: List[Float32] = [1.0, 1.0, 1.0, 1.0]
    var window = hann_window(4)

    var windowed = apply_window(signal, window)

    # Windowed signal should be attenuated at edges (Float32 tolerance)
    assert_close(windowed[0], 0.0, 1e-6, "Edges should be 0 with Hann")
    assert_close(windowed[3], 0.0, 1e-6, "Edges should be 0 with Hann")

    # Center should be close to 1.0 (window[center] ≈ 1.0)
    assert_true(windowed[1] > 0.5, "Center values should be less attenuated")
    assert_true(windowed[2] > 0.5, "Center values should be less attenuated")

    print("  ✓ apply_window tests passed")


fn test_apply_window_error_handling() raises:
    """Test error handling for mismatched lengths."""
    print("Testing apply_window error handling...")

    var signal: List[Float32] = [1.0, 2.0, 3.0]
    var window = hann_window(5)  # Wrong length!

    var raised = False
    try:
        _ = apply_window(signal, window)
    except:
        raised = True

    assert_true(raised, "Should raise error for length mismatch")

    print("  ✓ Error handling validated")


fn test_whisper_compatible_window() raises:
    """Test window size matches Whisper requirements."""
    print("Testing Whisper-compatible window...")

    # Whisper uses n_fft = 400
    var window = hann_window(400)

    assert_equal(len(window), 400, "Window should match Whisper n_fft")

    # Verify it's a valid window (Float32 tolerance)
    assert_close(window[0], 0.0, 1e-6, "Should start at 0")
    assert_close(window[399], 0.0, 1e-6, "Should end at 0")

    print("  ✓ Whisper-compatible window validated")


# ==============================================================================
# Test Helpers
# ==============================================================================

fn assert_equal(value: Int, expected: Int, message: String) raises:
    """Assert integer equality."""
    if value != expected:
        raise Error(message)


fn assert_close(value: Float32, expected: Float32, tolerance: Float32, message: String) raises:
    """Assert float values are close within tolerance."""
    if abs(value - expected) > tolerance:
        raise Error(message + " (got " + String(value) + ", expected " + String(expected) + ")")


fn assert_true(condition: Bool, message: String) raises:
    """Assert condition is true."""
    if not condition:
        raise Error(message)


# ==============================================================================
# Test Runner
# ==============================================================================

fn main() raises:
    """Run all window function tests."""
    print("\n" + "="*60)
    print("mojo-audio: Window Function Tests")
    print("="*60 + "\n")

    test_hann_window_properties()
    test_hamming_window_properties()
    test_hann_vs_hamming()
    test_apply_window()
    test_apply_window_error_handling()
    test_whisper_compatible_window()

    print("\n" + "="*60)
    print("✓ All window function tests passed!")
    print("="*60 + "\n")
