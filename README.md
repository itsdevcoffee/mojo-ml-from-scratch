# Visage ML - Build From Scratch ML Learning Path

Learning ML/AI fundamentals by building everything from scratch in Mojo 🔥

## Project Structure

```
visage-ml/
├── src/
│   ├── block0/     # Setup + Core Math Tools
│   ├── block1/     # Optimization + Regression
│   ├── block2/     # Classification + Probabilistic Thinking
│   ├── block3/     # Backprop Without Autograd
│   ├── block4/     # Modern Training (Optimizers, Regularization)
│   ├── block5/     # Embeddings + Representation Learning
│   ├── block6/     # Language Modeling Basics
│   ├── block7/     # Sequence Models (RNNs)
│   ├── block8/     # Attention Mechanisms
│   ├── block9/     # Tiny Transformer
│   ├── block10/    # LLM Reality (Inference, Fine-tuning)
│   └── block11/    # Capstone: Mini Chat Model + Tool Use
├── tests/          # Unit tests for each implementation
├── results/        # Loss curves, model outputs, metrics
├── notebooks/      # Exploration and visualization
└── docs/           # Learning notes and explanations

```

## Tech Stack

- **Language:** Mojo 🔥 (v0.26.1 nightly)
- **Package Manager:** pixi
- **Philosophy:** Build everything from scratch, optimize for understanding

## Quick Start

```bash
# Run hello world
pixi run mojo src/hello.mojo

# Run specific block
pixi run mojo src/block1/linear_regression.mojo

# Run tests
pixi run mojo test tests/

# Enter Mojo REPL
pixi run mojo
```

## Learning Guidelines

1. **Build, don't use libraries** - Implement everything yourself
2. **Visualize everything** - Plot loss curves, decision boundaries
3. **Document learnings** - README per block with key insights
4. **Test rigorously** - Sanity checks, gradient checks, unit tests

## Current Progress

- [x] Setup Mojo environment
- [ ] Block 0: Core Math Tools
- [ ] Block 1: Optimization + Regression
- [ ] ... (39+ more projects to go!)

## Resources

- [Mojo Documentation](https://docs.modular.com/mojo/)
- [Learning Outline](docs/learning-outline.md)
