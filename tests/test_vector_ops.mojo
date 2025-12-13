"""
Tests for Block 0: Vector Operations.
Run with: pixi run mojo tests/test_vector_ops.mojo
"""

from testing import assert_equal, assert_raises

# ============================================================================
# CODE UNDER TEST
# ============================================================================

fn vector_add(a: List[Float64], b: List[Float64]) raises -> List[Float64]:
    """Add two vectors element-wise."""
    if len(a) != len(b):
        raise Error("Shape mismatch: vectors must have same length")

    var result = List[Float64]()
    for i in range(len(a)):
        result.append(a[i] + b[i])
    return result^


# ============================================================================
# TEST FUNCTIONS
# ============================================================================

fn test_vector_add_basic() raises:
    """Test basic vector addition."""
    print("  Testing: Basic addition...", end=" ")
    var v1: List[Float64] = [1.0, 2.0, 3.0]
    var v2: List[Float64] = [4.0, 5.0, 6.0]
    var result = vector_add(v1, v2)

    assert_equal(len(result), 3)
    assert_equal(result[0], 5.0)
    assert_equal(result[1], 7.0)
    assert_equal(result[2], 9.0)
    print("✓ PASS")


fn test_vector_add_identity() raises:
    """Test adding zeros (identity property)."""
    print("  Testing: Identity (zeros)...", end=" ")
    var v: List[Float64] = [1.0, 2.0, 3.0]
    var zeros: List[Float64] = [0.0, 0.0, 0.0]
    var result = vector_add(v, zeros)

    assert_equal(len(result), 3)
    assert_equal(result[0], 1.0)
    assert_equal(result[1], 2.0)
    assert_equal(result[2], 3.0)
    print("✓ PASS")


fn test_vector_add_negative() raises:
    """Test with negative numbers."""
    print("  Testing: Negative numbers...", end=" ")
    var v1: List[Float64] = [5.0, -3.0, 2.0]
    var v2: List[Float64] = [-1.0, 3.0, -2.0]
    var result = vector_add(v1, v2)

    assert_equal(result[0], 4.0)
    assert_equal(result[1], 0.0)
    assert_equal(result[2], 0.0)
    print("✓ PASS")


fn test_vector_add_shape_mismatch() raises:
    """Test that shape mismatch raises error."""
    print("  Testing: Shape mismatch error...", end=" ")
    var v1: List[Float64] = [1.0, 2.0, 3.0]
    var v2: List[Float64] = [4.0, 5.0]

    # Should raise an error
    with assert_raises():
        var result = vector_add(v1, v2)
    print("✓ PASS")


fn test_vector_add_empty() raises:
    """Test with empty vectors."""
    print("  Testing: Empty vectors...", end=" ")
    var v1: List[Float64] = []
    var v2: List[Float64] = []
    var result = vector_add(v1, v2)

    assert_equal(len(result), 0)
    print("✓ PASS")


fn test_vector_add_single() raises:
    """Test with single element vectors."""
    print("  Testing: Single element...", end=" ")
    var v1: List[Float64] = [5.0]
    var v2: List[Float64] = [3.0]
    var result = vector_add(v1, v2)

    assert_equal(len(result), 1)
    assert_equal(result[0], 8.0)
    print("✓ PASS")


# ============================================================================
# TEST RUNNER
# ============================================================================

fn main() raises:
    print("\n" + "="*60)
    print("🧪 Running Vector Addition Tests")
    print("="*60 + "\n")

    var tests_run = 0
    var tests_passed = 0

    # Run all tests
    try:
        test_vector_add_basic()
        tests_passed += 1
    except e:
        print("  ✗ FAIL:", e)
    tests_run += 1

    try:
        test_vector_add_identity()
        tests_passed += 1
    except e:
        print("  ✗ FAIL:", e)
    tests_run += 1

    try:
        test_vector_add_negative()
        tests_passed += 1
    except e:
        print("  ✗ FAIL:", e)
    tests_run += 1

    try:
        test_vector_add_shape_mismatch()
        tests_passed += 1
    except e:
        print("  ✗ FAIL:", e)
    tests_run += 1

    try:
        test_vector_add_empty()
        tests_passed += 1
    except e:
        print("  ✗ FAIL:", e)
    tests_run += 1

    try:
        test_vector_add_single()
        tests_passed += 1
    except e:
        print("  ✗ FAIL:", e)
    tests_run += 1

    # Summary
    print("\n" + "="*60)
    print("Test Results:", tests_passed, "/", tests_run, "passed")
    if tests_passed == tests_run:
        print("✅ All tests passed!")
    else:
        print("❌ Some tests failed")
    print("="*60 + "\n")
