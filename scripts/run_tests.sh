#!/bin/bash
# Run all tests in the tests/ directory

echo "Running all tests..."
for test_file in tests/test_*.mojo; do
    if [ -f "$test_file" ]; then
        mojo "$test_file"
    fi
done
