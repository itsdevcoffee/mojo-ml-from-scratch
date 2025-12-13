"""
Block 0: Vector Operations.
Build from scratch to understand shapes, memory, and Mojo fundamentals.
"""

# ============================================================================
# LESSON 1: VECTOR ADDITION
# ============================================================================

fn vector_add(a: List[Float64], b: List[Float64]) raises -> List[Float64]:
    """
    Add two vectors element-wise: c[i] = a[i] + b[i].

    Args:
        a: First vector.
        b: Second vector (must be same length as a).

    Returns:
        New vector containing element-wise sum.

    Raises:
        Error if vectors have different lengths (shape mismatch).

    Why this matters:
        Shape bugs are the #1 source of ML errors.
        Always validate shapes before operating.
        Failing fast saves debugging time.
    """
    # STEP 1: Shape validation (catch bugs early!)
    if len(a) != len(b):
        raise Error("Shape mismatch: vectors must have same length. "
                   + "Got " + String(len(a)) + " and " + String(len(b)))

    # STEP 2: Create result vector
    var result = List[Float64]()

    # STEP 3: Element-wise addition
    for i in range(len(a)):
        result.append(a[i] + b[i])

    # STEP 4: Transfer ownership (Mojo memory management)
    return result^


fn print_vector(v: List[Float64], name: String = "vector"):
    """Helper function to print vectors nicely."""
    print(name + ": [", end="")
    for i in range(len(v)):
        print(v[i], end="")
        if i < len(v) - 1:
            print(", ", end="")
    print("]")


# ============================================================================
# TEST: Vector Addition
# ============================================================================

fn test_vector_add() raises:
    """Test our vector addition implementation."""
    print("\n" + "="*60)
    print("Testing Vector Addition")
    print("="*60)

    # Test 1: Basic addition
    var v1: List[Float64] = [1.0, 2.0, 3.0]
    var v2: List[Float64] = [4.0, 5.0, 6.0]
    var result = vector_add(v1, v2)

    print_vector(v1, "v1")
    print_vector(v2, "v2")
    print_vector(result, "v1 + v2")
    print("Expected: [5.0, 7.0, 9.0]")

    # Test 2: Adding zeros (identity)
    print("\n--- Test 2: Identity (adding zeros) ---")
    var v3: List[Float64] = [1.0, 2.0, 3.0]
    var zeros: List[Float64] = [0.0, 0.0, 0.0]
    var result2 = vector_add(v3, zeros)
    print_vector(v3, "v3")
    print_vector(zeros, "zeros")
    print_vector(result2, "v3 + zeros")
    print("Expected: [1.0, 2.0, 3.0] (same as v3)")

    # Test 3: Negative numbers
    print("\n--- Test 3: Negative numbers ---")
    var v4: List[Float64] = [5.0, -3.0, 2.0]
    var v5: List[Float64] = [-1.0, 3.0, -2.0]
    var result3 = vector_add(v4, v5)
    print_vector(v4, "v4")
    print_vector(v5, "v5")
    print_vector(result3, "v4 + v5")
    print("Expected: [4.0, 0.0, 0.0]")

    # Test 4: Shape mismatch (should error!)
    print("\n--- Test 4: Shape mismatch (should fail) ---")
    var v6: List[Float64] = [1.0, 2.0, 3.0]
    var v7: List[Float64] = [4.0, 5.0]  # Different length!

    try:
        var bad_result = vector_add(v6, v7)
        print("ERROR: Should have caught shape mismatch!")
    except e:
        print("✓ Correctly caught shape mismatch!")
        print("  Error message: Shape mismatch detected")

    print("\n" + "="*60)
    print("Vector Addition Tests Complete!")
    print("="*60 + "\n")


# ============================================================================
# MAIN: Run tests
# ============================================================================

fn main() raises:
    print("\n🔥 Block 0: Vector Operations 🔥")
    print("Building ML fundamentals from scratch in Mojo\n")

    # Run vector addition tests
    test_vector_add()

    print("\n📚 Key Takeaways:")
    print("  1. Always validate shapes first (catch bugs early)")
    print("  2. List[Float64] creates with: List[Float64](1.0, 2.0, 3.0)")
    print("  3. 'fn' requires explicit types and error handling")
    print("  4. 'raises' means function can throw errors")
    print("  5. Use '^' to transfer ownership (Mojo memory management)")
    print("\n💡 Next: We'll implement dot product with SIMD optimization!")
