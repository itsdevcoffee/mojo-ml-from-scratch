"""Tests for mel filterbank and mel spectrogram."""

from audio import (
    hz_to_mel, mel_to_hz,
    create_mel_filterbank,
    mel_spectrogram
)


fn abs(x: Float64) -> Float64:
    """Absolute value."""
    if x < 0:
        return -x
    return x


fn test_hz_mel_conversion() raises:
    """Test Hz ↔ Mel conversions."""
    print("Testing Hz/Mel conversions...")

    # Test known conversions
    var mel_1000 = hz_to_mel(1000.0)
    print("  1000 Hz =", mel_1000, "mels")

    # Test round-trip conversion
    var hz = 1000.0
    var mel = hz_to_mel(hz)
    var hz_back = mel_to_hz(mel)

    assert_close(hz_back, hz, 0.01, "Round-trip conversion should match")

    # Test multiple frequencies
    var freqs: List[Float64] = [100.0, 500.0, 1000.0, 4000.0, 8000.0]
    for i in range(len(freqs)):
        var hz_orig = freqs[i]
        var mel_val = hz_to_mel(hz_orig)
        var hz_restored = mel_to_hz(mel_val)
        assert_close(hz_restored, hz_orig, 0.1, "Round-trip for " + String(hz_orig) + " Hz")

    print("  ✓ Hz/Mel conversions validated")


fn test_mel_filterbank_shape() raises:
    """Test mel filterbank matrix dimensions."""
    print("Testing mel filterbank shape...")

    # Whisper parameters
    var filterbank = create_mel_filterbank(80, 400, 16000)

    # Check shape: (80, 201)
    assert_equal(len(filterbank), 80, "Should have 80 mel bands")
    assert_equal(len(filterbank[0]), 201, "Each band should have 201 freq bins")

    print("  Filterbank shape: (", len(filterbank), ",", len(filterbank[0]), ")")
    print("  Expected:         ( 80 , 201 )")
    print("  ✓ Filterbank shape correct!")


fn test_mel_filterbank_properties() raises:
    """Test mathematical properties of mel filters."""
    print("Testing mel filterbank properties...")

    var filterbank = create_mel_filterbank(80, 400, 16000)

    # Each filter should be non-negative
    for mel_idx in range(len(filterbank)):
        for freq_idx in range(len(filterbank[mel_idx])):
            assert_true(
                filterbank[mel_idx][freq_idx] >= 0.0,
                "Filterbank values should be non-negative"
            )

    # Count filters with non-zero values
    var nonzero_filters = 0
    for mel_idx in range(len(filterbank)):
        for freq_idx in range(len(filterbank[mel_idx])):
            if filterbank[mel_idx][freq_idx] > 0.0:
                nonzero_filters += 1
                break

    # Most filters should have energy (allow some edge cases)
    assert_true(nonzero_filters > len(filterbank) // 2, "Most mel bands should have energy")

    print("  Active filters:", nonzero_filters, "/", len(filterbank))
    print("  ✓ Filterbank properties validated")


fn test_mel_spectrogram_whisper_shape() raises:
    """Test mel spectrogram produces Whisper-compatible output."""
    print("Testing mel spectrogram Whisper compatibility...")

    # Create 30s audio @ 16kHz
    var audio = List[Float64]()
    for _ in range(30 * 16000):  # 480,000 samples
        audio.append(0.1)

    print("  Input: 30s audio (480,000 samples @ 16kHz)")

    # Compute mel spectrogram with Whisper parameters
    var mel_spec = mel_spectrogram(audio, 16000, 400, 160, 80)

    var n_mels = len(mel_spec)
    var n_frames = len(mel_spec[0])

    print("  Output shape: (", n_mels, ",", n_frames, ")")
    print("  Expected:     ( 80 , ~3000 )")

    # Validate dimensions
    assert_equal(n_mels, 80, "Should have 80 mel bands")

    # Allow small tolerance for frame count
    var frame_diff = n_frames - 3000
    if frame_diff < 0:
        frame_diff = -frame_diff

    assert_true(frame_diff <= 5, "Should have ~3000 frames")

    print("  ✓ Mel spectrogram shape validated!")
    print("  ✓ READY FOR WHISPER! 🎉")


fn test_mel_spectrogram_basic() raises:
    """Test basic mel spectrogram functionality."""
    print("Testing mel spectrogram basic functionality...")

    # Short audio for quick test
    var audio = List[Float64]()
    for _ in range(16000):  # 1s
        audio.append(0.5)

    var mel_spec = mel_spectrogram(audio, 16000, 400, 160, 80)

    # Should produce output
    assert_true(len(mel_spec) > 0, "Should produce mel bands")
    assert_true(len(mel_spec[0]) > 0, "Should produce time frames")

    # Should have 80 mel bands
    assert_equal(len(mel_spec), 80, "Should have 80 mel bands")

    print("  ✓ Basic mel spectrogram working")


# ==============================================================================
# Test Helpers
# ==============================================================================

fn assert_equal(value: Int, expected: Int, message: String) raises:
    """Assert integer equality."""
    if value != expected:
        raise Error(message + " (got " + String(value) + ", expected " + String(expected) + ")")


fn assert_close(value: Float64, expected: Float64, tolerance: Float64, message: String) raises:
    """Assert float values are close."""
    if abs(value - expected) > tolerance:
        raise Error(message)


fn assert_true(condition: Bool, message: String) raises:
    """Assert condition is true."""
    if not condition:
        raise Error(message)


# ==============================================================================
# Test Runner
# ==============================================================================

fn main() raises:
    """Run all mel filterbank tests."""
    print("\n" + "="*60)
    print("mojo-audio: Mel Filterbank Tests")
    print("="*60 + "\n")

    test_hz_mel_conversion()
    test_mel_filterbank_shape()
    test_mel_filterbank_properties()
    test_mel_spectrogram_basic()
    test_mel_spectrogram_whisper_shape()

    print("\n" + "="*60)
    print("✓ All mel filterbank tests passed!")
    print("="*60 + "\n")
