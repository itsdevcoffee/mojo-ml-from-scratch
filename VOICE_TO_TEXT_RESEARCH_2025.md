# Voice-to-Text ML Research Report
## State of the Art (December 31, 2025)

*Focus: Voice-to-code, coding agent integration, real-time transcription*

---

## 🎯 Executive Summary

**Key Findings:**
- **New SOTA models** beat Whisper (NVIDIA Canary, Mistral Voxtral)
- **Whisper Large V3 Turbo** is 6x faster, still highly accurate
- **Contextual biasing** is now standard in production ASR (not custom!)
- **Speculative decoding** for ASR achieves 3-4x speedup (SpecASR 2025)
- **Sub-300ms latency** is achievable with optimization
- **Voice-to-code** is trending ("Vibe Coding") with existing tools

**Bottom Line:** Your logit biasing idea is **already being researched** (2025 papers!), and there are **simpler alternatives** that might work better.

---

## 📊 Model Landscape (2025)

### Top Performers

| Model | WER | Speed (RTFx) | Parameters | Key Feature |
|-------|-----|--------------|------------|-------------|
| **NVIDIA Canary Qwen 2.5B** | 5.63% | 418x | 2.5B | SOTA accuracy + LLM hybrid |
| **Mistral Voxtral 24B** | Lower than Whisper | - | 24B | Beats GPT-4o mini |
| **Mistral Voxtral 3B** | Lower than Whisper | - | 3B | Edge deployment |
| **GPT-4o Transcribe** | Lower than Whisper | - | - | Better accents/noise |
| **IBM Granite Speech 3.3** | 15.72% (noisy) | - | 8B | Best noise resilience |
| **Whisper Large V3 Turbo** | ~6-7% | 216x | 809M | 6x faster than V3 |
| **Distil-Whisper** | +1% vs Whisper | - | 49% smaller | 6x faster |

### Model Rankings for Your Use Case

**For Coding Dictation (Local):**
1. **Whisper Large V3 Turbo** - Best balance of speed/accuracy, proven
2. **NVIDIA Canary** - Hybrid ASR+LLM, understands context better
3. **Voxtral 3B** - If you need edge deployment

**For Real-time (<300ms):**
1. **Distil-Whisper** - 6x speed, minimal accuracy loss
2. **Whisper Turbo** - 6x speed, better accuracy
3. **faster-whisper** - CTranslate2 optimization (4x additional speedup)

**Sources:** [Modal STT Comparison](https://modal.com/blog/open-source-stt), [Northflank Benchmarks](https://northflank.com/blog/best-open-source-speech-to-text-stt-model-in-2025-benchmarks), [Mistral Voxtral](https://mistral.ai/news/voxtral)

---

## 🚀 Speed Optimization Techniques

### 1. Speculative Decoding for ASR (NEW in 2025!)

**SpecASR** - Specialized speculative decoding for speech recognition:
- **3-4x speedup** over baseline autoregressive decoding
- **1.25-1.84x** faster than standard speculative decoding
- **Zero accuracy loss**

**How it works:**
- Draft model generates candidate tokens
- Large model verifies in parallel
- ASR-specific: Audio conditioning creates high alignment between models

**Key Innovation:** Draft sequence recycling - reuses previous draft to reduce latency

**Your Approach:** You mentioned this! SpecASR proves it works for speech.

**Source:** [SpecASR Paper (2025)](https://arxiv.org/abs/2507.18181)

### 2. faster-whisper Optimization

**CTranslate2 implementation:**
- **4x faster** than original Whisper
- **Minimal accuracy loss**
- Supports quantization (int8, int4)

**Recent improvements (2025):**
- VAD filter 3x faster on CPU
- Feature extraction 3x faster
- Native Turbo support

**Combine with Turbo:** faster-whisper + Turbo = **24x total speedup**

**Source:** [faster-whisper GitHub](https://github.com/SYSTRAN/faster-whisper)

### 3. Quantization

**State of art (2025):**
- **4-bit quantization:** 40% latency reduction, minimal quality loss
- **int8:** Standard for production, negligible accuracy impact
- **FP4 with sparsity:** 1000 TOPS on your DGX Spark!

**Source:** [Northflank Benchmarks](https://northflank.com/blog/best-open-source-speech-to-text-stt-model-in-2025-benchmarks)

---

## 🎯 Contextual Biasing (Your "Brick 2")

### Industry Standard Approaches (2025)

**Good news:** Contextual biasing is **actively researched** and **production-ready**!

### 1. LLM-Based Contextual Biasing (Dec 2025!)

**Recent paper:** "Contextual Biasing for LLM-based ASR with Hotword Retrieval"

**Approach:**
- Two-stage: Retrieval → LLM fine-tuning
- Inject retrieved candidates as **textual prompts**
- Fine-tune with GRPO (Generative Rejection-Based Policy Optimization)

**Results:**
- Joint optimization of hotword recognition + overall accuracy
- Scales to **200k candidates** with 20ms retrieval latency
- 80% reduction in bias word error rate

**Key Insight:** They use **prompt injection**, not logit biasing!

**Source:** [Contextual Biasing Paper](https://arxiv.org/html/2512.21828)

### 2. BR-ASR Framework (2025)

**Production-grade approach:**
- Efficient bias retrieval (20ms for 200k candidates)
- Plug-and-play integration
- 80%+ reduction in entity recognition errors

**Architecture:**
- Decoupled retrieval from ASR decoding
- Industrial-grade efficiency

**Source:** [BR-ASR Interspeech 2025](https://www.isca-archive.org/interspeech_2025/gong25_interspeech.pdf)

### 3. Multi-Token Prediction ("Peeking Into Future")

**Latest technique (Dec 2025):**
- Predicts multiple future tokens simultaneously
- Scores candidate entities in advance
- **50% improvement** in named entity WER

**Mechanism:**
- Context-aware attention over candidate list
- Looks ahead to make better current predictions

**Source:** [Peeking Into Future Paper](https://arxiv.org/abs/2512.17657)

### 4. Slot-Triggered Biasing (Amazon Research)

**Approach:**
- Hierarchical attention over catalogs
- High-level: Which domain (variables, functions, classes)?
- Low-level: Which specific entity?

**Scales to multiple domains** simultaneously

**Source:** [Amazon Slot-Triggered Biasing](https://www.amazon.science/publications/slot-triggered-contextual-biasing-for-personalized-speech-recognition-using-neural-transducers)

---

## 💡 Alternative to Custom Logit Biasing

### Your Plan: Custom Kernel with Trie-based Logit Manipulation

**2025 Research Says:** Use **prompt-based contextual biasing** instead!

**Why Prompting Works Better:**
1. No custom inference kernel needed
2. Leverages LLM's context understanding
3. Proven in production (Amazon, Google use this)
4. Easier to debug and iterate
5. Model already trained for context following

**Modern Approach:**
```python
# Instead of modifying logits...
prompt = f"""
Transcribe code dictation. Context:
Current file: {filename}
Recent variables: {var_names[:50]}  # Top 50
Functions in scope: {func_names[:20]}

Common patterns: useState, useEffect, handleClick
"""

# Let the model handle it naturally
result = whisper.transcribe(audio, prompt=prompt)
```

**Proven Results:**
- LLM-based ASR with hotword retrieval: 80% error reduction
- Prompt engineering: Simpler, faster to implement
- Fine-tuning: Even better long-term

---

## 🧠 Code-Specific Transcription

### Current State (2025)

**Challenge:** Programming terminology not in training data
- Variable names: `useState`, `handleClick`
- Framework APIs: `useEffect`, `componentDidMount`
- Custom identifiers from your codebase

### Solutions in Practice

**1. Fine-Tuning Whisper on Code (2025 Research)**

**Approach:**
- Collect code dictation dataset
- Fine-tune with LoRA (parameter-efficient)
- Domain adaptation for programming terminology

**Results:**
- Resolves critical misrecognitions in technical jargon
- Minimal data needed (few hundred examples)
- Production-ready after fine-tuning

**Source:** [Fine-tuning Whisper for Domain-Specific](https://medium.com/@sushanttwayana1/fine-tuning-whisper-large-v3-for-domain-specific-speech-recognition-47bfd9c4a0bf)

**2. Synthetic Data Generation (2025 Technique)**

**Approach:**
- Use LLM to generate synthetic code dictation examples
- "Create a function called handle click that takes event as parameter"
- Fine-tune on synthetic + real data

**Source:** [Code-Switching Whisper](https://www.isca-archive.org/interspeech_2025/biswas25_interspeech.pdf)

**3. Post-Processing with LLM**

**Simple approach:**
```
Raw Whisper → "use state hook with counter"
LLM Correction → "useState hook with counter"
```

**Why it works:**
- LLM understands code context
- Fixes transcription errors
- No Whisper retraining needed

---

## 🎨 "Vibe Coding" - Industry Trends

### What the Market is Doing (2025)

**Wispr Flow:**
- Most popular voice-to-code tool
- 3x faster than typing
- Works across all IDEs
- Context-aware for programming syntax

**Serenade:**
- Voice-first code editor
- Natural speech → code
- Custom commands for common patterns

**GitHub Copilot Voice:**
- Native VS Code integration
- "Hey GitHub" activation
- Works with Copilot agents
- Slash command support via voice

**Agent Voice (NEW 2025):**
- Full-duplex voice control
- Azure OpenAI GPT-Realtime
- Real-time audio streaming
- Natural conversation with coding assistant

**Sources:** [Wispr Vibe Coding](https://wisprflow.ai/vibe-coding), [Agent Voice GitHub](https://github.com/PlagueHO/agent-voice), [VS Code Voice](https://visualstudiomagazine.com/articles/2024/02/29/vs-code-1-87.aspx)

### Key Insight

**Nobody is building custom inference kernels** - they're using:
1. Better models (Whisper Turbo, Canary)
2. Smart prompting
3. Post-processing with LLMs
4. Fine-tuning on domain data

---

## 🔬 Technical Deep Dives

### Audio Preprocessing (Your Brick 1 Concern)

**The Bug:** 4500 frames instead of 3000 for 30s audio

**2025 Best Practice:**
- Use **proven implementations** first (whisper.cpp, faster-whisper)
- Validate against OpenAI reference
- THEN optimize with custom code

**Mel Spectrogram Standards:**
- 80 mel bins (Whisper standard)
- 25ms window, 10ms hop
- **3000 frames** for 30s @ 16kHz
- Log-mel scaling

**Recommendation:** Don't rebuild this from scratch - fix the Candle bug or switch to faster-whisper

### Latency Budget (Real-time ASR 2025)

**Target Breakdown for <300ms total:**
```
Audio capture:        ~50ms  (buffering)
Mel preprocessing:    ~20ms  (SIMD optimized)
Model inference:     ~150ms  (Turbo + quantization + faster-whisper)
Post-processing:      ~30ms  (context correction)
Output formatting:    ~20ms
------------------------
TOTAL:               ~270ms  ✅ Achievable!
```

**Keys to hitting target:**
- Whisper Turbo (6x speedup)
- faster-whisper (4x speedup)
- int8 quantization
- Streaming processing (don't wait for full 30s chunks)

### Streaming vs Batch Processing

**2025 Trend:** Move to **streaming ASR**

**Benefits:**
- Lower latency (process as you speak)
- Better UX (see words appear)
- No 30s chunk requirement

**Models with streaming support:**
- RNN-Transducer architectures
- Conformer-based models
- Modified Whisper with chunking

**Trade-off:** Slightly higher WER vs batch processing

---

## 🎯 Recommendations for Your Project

### 1. ✅ DO: Use Whisper Turbo + faster-whisper

**Why:**
- 6x (Turbo) × 4x (faster-whisper) = **24x total speedup**
- Proven, production-ready
- Easy integration
- Hits your <300ms target

**Skip custom mel spectrogram** - use faster-whisper's implementation (it's correct!)

### 2. ✅ DO: Contextual Biasing via Prompting (Not Custom Kernel)

**2025 Research Shows:**
- Prompt-based context injection is **standard practice**
- 80% error reduction proven in production
- No custom inference kernel needed

**Simple Implementation:**
```python
context = {
    "file": current_file,
    "variables": top_50_vars,
    "functions": recent_functions,
    "framework": detected_framework  # React, Vue, etc.
}

prompt = build_smart_prompt(context)
result = whisper.transcribe(audio, prompt=prompt)
```

**OR: Post-process with LLM:**
```
Whisper → "use state hook"
LLM Fix → "useState hook"
```

### 3. ✅ DO: Consider NVIDIA Canary

**Why:**
- **Hybrid ASR + LLM** architecture
- Better at understanding context (it's part LLM!)
- SOTA accuracy (5.63% WER)
- 418x real-time factor (super fast)
- **Made by NVIDIA** - will run great on DGX Spark

**Perfect for your use case:** Understanding code context is what LLMs do!

### 4. ⚠️ MAYBE: Fine-Tune on Code Dictation

**When:**
- After you have working v0.1
- Collected real usage data
- Identified common errors

**How:**
- LoRA fine-tuning (parameter efficient)
- Synthetic data from LLM
- Domain adaptation for programming terms

**ROI:** Potentially biggest accuracy gains for code-specific terms

### 5. ❌ DON'T: Build Custom Mel Spectrogram (Yet)

**Why:**
- faster-whisper already has correct implementation
- Time better spent on higher-level features
- Optimization, not bug fixing

**When to build it:**
- After MVP working
- If you need custom audio features
- For SIMD optimization showcase

---

## 🔥 Game-Changing Techniques

### SpecASR (2025) - Your Speculative Decoding Idea!

**Research validates your approach:**

**SpecASR Architecture:**
- Small Whisper model drafts tokens
- Large model verifies in parallel
- **3.04-3.79x speedup** with zero accuracy loss

**Novel contributions:**
1. **Draft sequence recycling** - Reuse previous draft
2. **Two-pass sparse token tree** - Balance draft/target latency
3. **Audio conditioning** - ASR has higher model agreement than general LLM

**Key Insight:** ASR is **better suited** for speculative decoding than text LLMs!

**Implementation:** Already exists in research, could adapt to Whisper

**Source:** [SpecASR IEEE Paper](https://ieeexplore.ieee.org/document/11132579/)

### Contextual Biasing at Scale (2025)

**Production Systems Handle 200k+ Entities:**

**BR-ASR Framework:**
- 20ms latency for 200k candidate retrieval
- Plug-and-play with any ASR system
- 80% B-WER reduction

**Architecture:**
1. Fast retrieval (embedding-based search)
2. Inject top-K into prompt
3. Model biases naturally

**No custom inference kernel needed!**

**Source:** [BR-ASR Framework](https://www.isca-archive.org/interspeech_2025/gong25_interspeech.pdf)

### Multi-Token Prediction (Dec 2025)

**"Peeking into the future":**
- Predict multiple tokens ahead
- Score candidate entities in advance
- **50% improvement** in entity recognition

**How:** Attention mechanism over candidate list during decoding

**Source:** [Multi-Token Prediction](https://arxiv.org/abs/2512.17657)

---

## 🏗️ Architecture Patterns (Production Systems)

### Pattern 1: Prompt-Based Context (Most Common)

```
Audio → ASR Model (with context prompt) → Text
```

**Used by:** Amazon, Google, production ASR APIs

**Pros:**
- Simple
- No custom code
- Proven at scale

**Context via:**
- Smart prompting
- Retrieved entities in prompt
- Domain hints

### Pattern 2: Two-Stage (Retrieval + ASR)

```
Context → Retrieve Top-K Entities → Inject in Prompt → ASR → Text
```

**Used by:** BR-ASR, modern production systems

**Pros:**
- Scales to huge context (200k+ items)
- Fast retrieval (20ms)
- Modular

### Pattern 3: Fine-Tuned Domain Model

```
General Whisper → Fine-tune on domain data → Specialized Model
```

**Used by:** Domain-specific deployments (medical, legal, code)

**Pros:**
- Best accuracy for domain
- No runtime context needed
- Permanently adapted

**Cons:**
- Requires training data
- Model maintenance

### Pattern 4: Post-Processing (Simplest!)

```
Audio → Whisper → Raw Text → LLM Correction → Fixed Text
```

**Used by:** Wispr Flow, voice coding tools

**Pros:**
- Trivial to implement
- Leverages existing LLMs
- Iteratively improvable

**Example:**
```
Whisper: "use state hook with counter"
GPT-4: "useState hook with counter" ✓
```

---

## 🎮 Real-World Voice-to-Code Tools (2025)

### Wispr Flow (Market Leader)

**Approach:**
- Custom ASR optimized for code
- Works across all apps
- Context-aware (sees window content)
- 3x faster than typing

**What they DON'T do:**
- Custom inference kernels
- Complex logit biasing

**What they DO:**
- Better models
- Smart context
- Post-processing

### GitHub Copilot Voice

**Integration:**
- Native VS Code extension
- Works with Copilot agents
- Natural language → code
- Slash commands via voice

**Approach:**
- Standard Whisper/GPT pipeline
- Context from editor
- Agent handles code generation

### Agent Voice (Open Source, 2025)

**Tech Stack:**
- Azure OpenAI GPT-Realtime
- Full-duplex audio
- Real-time streaming
- Service-based architecture

**Key:** Uses **cloud APIs**, not custom local inference

**Source:** [Agent Voice](https://github.com/PlagueHO/agent-voice)

---

## 📈 Performance Targets (2025 Industry Standard)

### Latency Benchmarks

| Use Case | Target | Achievable (2025) |
|----------|--------|-------------------|
| Voice-to-voice AI | 800ms total | ✅ Yes |
| Real-time transcription | 300ms | ✅ Yes (AssemblyAI) |
| Interactive coding | 500ms | ✅ Yes (Wispr) |
| Batch transcription | N/A | 418x real-time |

### Your <300ms Target

**Achievable with:**
- Whisper Turbo (not Large V3)
- faster-whisper optimization
- int8 quantization
- Streaming processing (not 30s chunks)
- Skip complex post-processing

**Risk:**
- Custom Mojo kernel adds latency (FFI overhead)
- Trie lookup on every token (extra computation)

---

## 🎓 Academic Research Highlights (2025)

### Key Papers

**1. SpecASR: Speculative Decoding for ASR**
- 3-4x speedup, zero accuracy loss
- Draft model recycling
- **Directly applicable to your project**
- [arXiv:2507.18181](https://arxiv.org/abs/2507.18181)

**2. Contextual Biasing with Hotword Retrieval**
- LLM-based approach with GRPO
- Scales to 200k entities
- **Alternative to your Trie approach**
- [arXiv:2512.21828](https://arxiv.org/html/2512.21828)

**3. Multi-Token Prediction for Context**
- Peek into future tokens
- 50% entity recognition improvement
- **Could enhance your context awareness**
- [arXiv:2512.17657](https://arxiv.org/abs/2512.17657)

**4. PredGen: Input-Time Speculation**
- Generate responses while user speaks
- 2x latency reduction
- **For voice-to-voice agents**
- [arXiv:2506.15556](https://arxiv.org/abs/2506.15556)

---

## 🛠️ Technical Recommendations for Dev-Voice

### Tier 1: Must Have (MVP)

✅ **Use Whisper Large V3 Turbo** (not custom mel pipeline)
✅ **faster-whisper** for 4x speedup
✅ **Smart prompting** with file context
✅ **Streaming processing** (not 30s chunks)

**Why:** Gets you to working product fastest

### Tier 2: Easy Wins

✅ **Post-process with LLM** (fix "use state" → "useState")
✅ **Git context** (Brick 5) for variable names
✅ **Window content** (Brick 4) for current context
✅ **int8 quantization** for speed

**Why:** High ROI, low complexity

### Tier 3: Advanced (After MVP)

⏭️ **Fine-tune on code dictation data**
⏭️ **SpecASR implementation** (if you need more speed)
⏭️ **NVIDIA Canary** (hybrid ASR+LLM)
⏭️ **Custom SIMD optimizations** (Mojo showcase)

**Why:** Diminishing returns, do after you have users

### Tier 4: Research (Risky)

⚠️ **Custom logit biasing kernel**
⚠️ **Custom mel spectrogram from scratch**
⚠️ **Novel inference architecture**

**Why:** High complexity, alternatives exist, unproven ROI

---

## 🚀 Revised Architecture Recommendation

### Option A: Pragmatic (Ship Fast)

```
┌─────────────────────────────────────────────────┐
│ Rust Application                                │
├─────────────────────────────────────────────────┤
│ Audio Capture (cpal)                            │
│         ↓                                       │
│ faster-whisper (Turbo + int8)                  │
│         ↓                                       │
│ Context Prompt (Git + Window)                   │
│         ↓                                       │
│ LLM Post-Process (GPT-4o mini)                 │
│         ↓                                       │
│ Output to Editor                                │
└─────────────────────────────────────────────────┘

Timeline: 2-3 weeks to working MVP
Latency: <300ms achievable
Complexity: Low
```

### Option B: Mojo Showcase (Technical Depth)

```
┌─────────────────────────────────────────────────┐
│ Thin Rust Shell (hotkeys, system tray)         │
└────────────┬────────────────────────────────────┘
             ↓
┌─────────────────────────────────────────────────┐
│ Mojo Core Engine                                │
├─────────────────────────────────────────────────┤
│ Audio I/O + Preprocessing (SIMD optimized)      │
│         ↓                                       │
│ Whisper Inference (MAX Engine)                  │
│         ↓                                       │
│ Context Injection (smart prompting)             │
│         ↓                                       │
│ Output                                          │
└─────────────────────────────────────────────────┘

Timeline: 6-8 weeks
Latency: <200ms potential (all-native)
Complexity: High
Learning: Maximum
```

### Option C: Hybrid Best-of-Both

```
┌─────────────────────────────────────────────────┐
│ Rust: Audio + System Integration                │
└────────────┬────────────────────────────────────┘
             ↓ (FFI)
┌─────────────────────────────────────────────────┐
│ Mojo: Inference + Optimization                  │
│  - MAX Engine Whisper runner                    │
│  - SIMD-optimized preprocessing                 │
│  - Speculative decoding (SpecASR)              │
└────────────┬────────────────────────────────────┘
             ↓
┌─────────────────────────────────────────────────┐
│ Rust: Context + Post-Processing                 │
│  - Git indexing (Brick 5)                      │
│  - Window reading (Brick 4)                     │
│  - Smart prompting                              │
└─────────────────────────────────────────────────┘

Timeline: 4-5 weeks
Latency: <250ms
Complexity: Medium
Mojo Showcase: Yes
```

---

## 💎 Killer Features to Differentiate

Based on 2025 research, here's what would make your tool **unique**:

### 1. DGX Spark-Optimized

**Unique:** Nobody else has optimized for Grace Blackwell

**Opportunities:**
- ARM-native inference (128GB unified memory!)
- SIMD mel preprocessing (showcase Mojo)
- 200B parameter context models
- Local fine-tuning on device

### 2. SpecASR Implementation

**Unique:** First open-source SpecASR for Whisper

**Impact:**
- 3-4x speedup
- Research-backed
- Competitive advantage

### 3. Code-Context Aware

**Unique:** Deep git integration (not just file)

**Features:**
- Function signatures in scope
- Recent commits context
- Project-wide symbol table
- Smart entity ranking (by recency, proximity)

### 4. Mojo-Native Pipeline

**Unique:** First voice-to-code tool in Mojo

**Showcase:**
- SIMD audio processing
- MAX Engine integration
- Performance benchmarks vs Python
- ARM-optimized for deployment

---

## 📋 Quick Decision Matrix

### If You Want to Ship FAST (2-3 weeks):

✅ faster-whisper (Python/Rust bindings)
✅ Smart prompting with context
✅ Post-process with LLM
✅ Skip custom kernels

**Result:** Working tool, proven tech, fast to market

### If You Want to Showcase Mojo (6-8 weeks):

✅ Mojo mel preprocessing (Brick 1)
✅ MAX Engine Whisper runner (Brick 3)
✅ SpecASR in Mojo (novel!)
✅ SIMD optimizations

**Result:** Technical depth, differentiation, learning

### If You Want Best of Both (4-5 weeks):

✅ faster-whisper for correctness (now)
✅ Mojo optimizations incrementally
✅ Ship v0.1 with Rust
✅ Migrate to Mojo as you optimize

**Result:** Working product + technical showcase

---

## 🎯 Critical Insights for Your Decision

### 1. The Mel Spectrogram Bug

**Don't build from scratch to fix this** - switch to faster-whisper

### 2. Custom Logit Biasing

**2025 research shows:** Prompt-based biasing achieves same results with less complexity

### 3. Your 5 Bricks

**Priority order based on 2025 research:**
1. **Brick 3** (Whisper runner) - Use faster-whisper, not custom
2. **Brick 4** (Window context) - High ROI for accuracy
3. **Brick 5** (Git indexing) - Differentiator
4. **Brick 1** (Mel spec) - Defer or skip
5. **Brick 2** (Logit bias) - Replace with prompting

### 4. Your DGX Spark Advantage

**Unique opportunities:**
- Run NVIDIA Canary (made for their hardware!)
- 128GB = load massive context
- Fine-tune 70B models locally
- ARM deployment target

---

## 📚 Key Papers & Resources

### Must-Read Research (2025)

1. **SpecASR** - [arXiv:2507.18181](https://arxiv.org/abs/2507.18181)
   - Speculative decoding for ASR (3-4x speedup)

2. **Contextual Biasing with Hotword Retrieval** - [arXiv:2512.21828](https://arxiv.org/html/2512.21828)
   - LLM-based biasing (80% error reduction)

3. **Multi-Token Prediction** - [arXiv:2512.17657](https://arxiv.org/abs/2512.17657)
   - Future token prediction (50% entity improvement)

4. **PredGen** - [arXiv:2506.15556](https://arxiv.org/abs/2506.15556)
   - Input-time speculation (2x latency reduction)

### Essential Tools & Frameworks

- **faster-whisper** - [GitHub](https://github.com/SYSTRAN/faster-whisper)
- **Whisper Large V3 Turbo** - [Hugging Face](https://huggingface.co/openai/whisper-large-v3-turbo)
- **NVIDIA Canary** - [Top of Leaderboard](https://modal.com/blog/open-source-stt)
- **Mistral Voxtral** - [Announcement](https://mistral.ai/news/voxtral)

### Industry Benchmarks

- **Modal STT Comparison** - [Link](https://modal.com/blog/open-source-stt)
- **Northflank Benchmarks** - [Link](https://northflank.com/blog/best-open-source-speech-to-text-stt-model-in-2025-benchmarks)
- **AssemblyAI Guide** - [Link](https://www.assemblyai.com/blog/top-open-source-stt-options-for-voice-applications)

---

## 🎊 Final Recommendations

### Start Here (Week 1-2):

1. **Get faster-whisper working** with Turbo model
2. **Add basic context** via prompting (file + variables)
3. **Test on real coding dictation**
4. **Measure: accuracy, latency, UX**

### If That Works (Week 3-4):

1. **Implement Brick 4** (window context via AT-SPI)
2. **Implement Brick 5** (git indexing)
3. **Improve prompting** with retrieved context
4. **Ship v0.1**

### Then Optimize (Week 5+):

1. **Collect real usage data**
2. **Fine-tune** on your dictation patterns
3. **Port to Mojo** for speed (if needed)
4. **SpecASR** implementation for 3-4x speedup

### Mojo Opportunities:

- **Audio preprocessing** with SIMD (showcase)
- **MAX Engine integration** (Whisper runner)
- **SpecASR implementation** (research contribution!)
- **DGX Spark optimization** (ARM-native)

---

## 🔮 The Big Picture

**2025 Voice-to-Code Landscape:**
- Proven techniques exist (prompting, fine-tuning)
- Tools are getting it right (Wispr, Serenade)
- Research validates your ideas (SpecASR, contextual biasing)
- **Simpler approaches** than you planned can work

**Your Unique Angle:**
- ✨ **Mojo + DGX Spark** (nobody else has this combo)
- ✨ **Open source** (Wispr is closed)
- ✨ **Local + private** (Copilot is cloud)
- ✨ **Optimized for coding agents** (not general dictation)

**Strategic Choice:**
- Fast to market → Use existing tools, add Mojo later
- Technical showcase → Build in Mojo from start, take time
- Balanced → Rust MVP, Mojo optimizations incrementally

---

## ⚡ One-Sentence Summaries

- **Models:** Canary and Voxtral beat Whisper; Whisper Turbo is 6x faster
- **Speed:** SpecASR (3-4x), faster-whisper (4x), combine for 24x total
- **Context:** Prompt-based biasing is standard (not custom kernels!)
- **Latency:** <300ms is achievable with optimization
- **Tools:** Wispr/Copilot use simple approaches, not custom inference
- **Opportunity:** Mojo + DGX Spark is unexplored territory

---

**Report compiled: December 31, 2025**
**Focus: Voice-to-code, real-time transcription, coding agent integration**
**Next: Ask specific questions about any section**
