# Development Tools for Mojo ML Learning

## ✅ Already Installed

### Mojo Toolchain (via pixi)
- ✅ **mojo compiler** - Build executables
- ✅ **mojo repl** - Interactive Mojo shell
- ✅ **mojo debug** - LLDB-based debugger
- ✅ **mojo format** - Code formatter (80 char default)
- ✅ **mojo doc** - Documentation generator
- ✅ **mojo package** - Package management
- ✅ **MAX engine** - Modular's AI/ML runtime
- ✅ **Python 3.14** - For interop/plotting
- ✅ **NumPy 2.3.5** - For validation/comparison
- ✅ **Jupyter client** - Notebook support (optional)

### System Tools (Already on your machine)
- ✅ **Git** - Version control
- ✅ **NeoVim** - Your editor
- ✅ **VS Code** - Alternative editor
- ✅ **Python 3** - System Python

## 🎯 Recommended Additions

### 1. Editor Setup (Choose One)

#### Option A: NeoVim (Your current editor)
**Mojo LSP support is available!**

Add to your NeoVim config:
```lua
-- ~/.config/nvim/lua/plugins/mojo.lua (if using lazy.nvim)
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        mojo = {
          cmd = { vim.fn.expand("~/.pixi/envs/default/bin/mojo-lsp-server") },
          filetypes = { "mojo" },
          root_dir = require("lspconfig.util").root_pattern("pixi.toml", ".git"),
        },
      },
    },
  },
}
```

**Syntax highlighting:**
```bash
# Tree-sitter support (if not auto-detected)
# Add to your nvim config
# Will auto-detect .mojo files
```

#### Option B: VS Code (If you prefer GUI)
```bash
# Install official Mojo extension
code --install-extension modular-mojotools.vscode-mojo
```

Features:
- Syntax highlighting
- LSP (autocomplete, go-to-def, hover)
- Debugger integration
- Format on save
- Inline error checking

### 2. Visualization Tools

**For plotting loss curves, decision boundaries, etc.**

#### Option A: Python matplotlib (via pixi - RECOMMENDED)
```bash
pixi add matplotlib scipy
```

Then create Mojo → Python interop for plotting:
```mojo
# You'll build this in Block 0!
fn export_to_csv(data: List[Float64], filename: String):
    # Export results to CSV
    # Then use Python to plot
```

#### Option B: gnuplot (terminal-based)
```bash
sudo dnf install gnuplot  # or your package manager
```

Simple terminal plots without Python dependency.

### 3. Build Automation (Optional)

#### Option A: just (modern make alternative)
```bash
pixi add just
```

Create `justfile`:
```make
# Run all tests
test:
    mojo test tests/

# Format all code
fmt:
    find src -name "*.mojo" -exec mojo format {} \;

# Run specific block
block n:
    mojo src/block{{n}}/
```

#### Option B: Makefile (traditional)
Already have `make` on system, just create `Makefile`.

### 4. Additional Python Tools (Optional)

For validation/comparison of your from-scratch implementations:

```bash
# Add to pixi if needed later
pixi add pandas scikit-learn torch  # For reference checking
```

**BUT:** Only use these to **validate** your implementations, not to build with!

### 5. Performance Profiling (Advanced - Later)

```bash
# System profiling tools
sudo dnf install perf valgrind

# Mojo has built-in benchmarking
# You already have this via stdlib
```

## 🚫 What You DON'T Need

- ❌ TensorFlow/PyTorch - You're building from scratch!
- ❌ Jupyter (unless you want notebooks)
- ❌ Docker (local development is fine)
- ❌ CUDA toolkit (Mojo handles GPU abstraction)
- ❌ Separate C++ compiler (Mojo includes everything)

## 📝 Minimal Setup Recommendation

**For your learning journey, I recommend:**

1. **Editor: NeoVim** (you already have it)
   - Add Mojo LSP config (5 min setup)
   - Get autocomplete, error checking, go-to-def

2. **Plotting: matplotlib via pixi**
   ```bash
   pixi add matplotlib
   ```
   - Export data from Mojo to CSV
   - Plot with Python (simple interop)

3. **Formatter: Built-in**
   ```bash
   # Format your code regularly
   mojo format src/**/*.mojo
   ```

4. **Optional: just for automation**
   ```bash
   pixi add just
   # Makes running tasks easier
   ```

## ⚙️ Quick Setup Commands

### Minimal (NeoVim + Plotting)
```bash
# Add plotting support
pixi add matplotlib scipy

# Check Mojo LSP server exists
ls ~/.pixi/envs/default/bin/mojo-lsp-server

# Add NeoVim LSP config (manual - see above)
```

### Full Featured (NeoVim + Tools)
```bash
# Add all helpful tools
pixi add matplotlib scipy just

# Configure NeoVim LSP (manual)
# Add justfile for automation
```

### VS Code Alternative
```bash
# If you prefer VS Code
code --install-extension modular-mojotools.vscode-mojo

# Still add plotting
pixi add matplotlib scipy
```

## 🎨 NeoVim LSP Setup (Detailed)

Since you have NeoVim, here's how to set up Mojo LSP:

**For LazyVim/lazy.nvim:**
```lua
-- ~/.config/nvim/lua/plugins/mojo.lua
return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.mojo = {
        cmd = { vim.fn.expand("~/.pixi/envs/default/bin/mojo-lsp-server") },
        filetypes = { "mojo" },
        root_dir = require("lspconfig.util").root_pattern("pixi.toml", ".git"),
      }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "mojo" })
    end,
  },
}
```

**For vanilla nvim-lspconfig:**
```lua
-- In your init.lua or lsp config file
require('lspconfig').mojo.setup{
  cmd = { vim.fn.expand('~/.pixi/envs/default/bin/mojo-lsp-server') },
  filetypes = { 'mojo' },
  root_dir = require('lspconfig.util').root_pattern('pixi.toml', '.git'),
}
```

**Test it works:**
1. Open any `.mojo` file in NeoVim
2. Run `:LspInfo` - should show "mojo" client attached
3. Try `gd` (go to definition), `K` (hover), etc.

## 📊 Recommended Workflow

```bash
# 1. Code in NeoVim with LSP
nvim src/block0/vector_ops.mojo

# 2. Format on save or manually
mojo format src/block0/vector_ops.mojo

# 3. Run and test
pixi run mojo src/block0/vector_ops.mojo

# 4. Debug if needed
pixi run mojo debug src/block0/vector_ops.mojo

# 5. Plot results
python scripts/plot_results.py results/block0_loss.csv
```

## 🔧 Need More Later?

You can always add tools as you progress:
- Block 6+: Maybe add text processing tools
- Block 9+: Maybe add visualization for attention weights
- Block 10+: Maybe add profiling tools

**Start minimal, add as needed!**

## 📚 Tool Documentation

- [Mojo LSP Setup for NeoVim](https://forum.modular.com/t/mojo-lsp-setup-for-neovim/501)
- [nvim-lspconfig Mojo](https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/mojo.lua)
- [Mojo VS Code Extension](https://marketplace.visualstudio.com/items?itemName=modular-mojotools.vscode-mojo)
- [Mojo Debugging Guide](https://docs.modular.com/mojo/tools/debugging)
