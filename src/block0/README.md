# Block 0 — Setup + Core Math Tools

**Goal:** Build a tiny numerical toolbox and understand Mojo fundamentals

## Projects

1. Vector/matrix operations (shapes, broadcasting)
2. Random seed control + reproducibility
3. Dataset utilities (train/val split, batching, shuffling)
4. Plotting utilities (loss curves, decision boundaries)

## Key Learning Objectives

- Understand tensor shapes and why bugs are often "shape bugs"
- Why reproducibility matters (seeds, determinism limits)
- How Mojo's `fn` vs `def` affects performance
- SIMD basics for vectorized operations

## Files

- `vector_ops.mojo` - Basic vector/matrix operations
- `random_utils.mojo` - Seeding and random number generation
- `dataset_utils.mojo` - Data splitting and batching
- `plot_utils.mojo` - Visualization helpers

## Success Criteria

- [ ] Can multiply matrices of compatible shapes
- [ ] Can reproduce random results with seeds
- [ ] Can split dataset into train/val
- [ ] Can export data for plotting (CSV format)

## Notes

Start here. Get comfortable with Mojo syntax and tooling before diving into ML.
