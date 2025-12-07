# Heterogeneous-LLM-Inference
your Frankenstein local ai rig

# 🚀 Heterogeneous-LLM-Inference
**Distributed Inference on Mixed-Generation Consumer Hardware**
**STEPS:**

1- setup your hardware

2- download the latest nvidia driver (from geforce experience for easy installation)

3- download and install Kobold.cpp

4- download a .gguf llm model (example: qwen 2.5)

5- put both the kobold.cpp and your model into 1 single folder (no sub folders, it would not find the model)

6- edit the .bat file with your exact llm model name (otherwise your kobold will not see your model and will not launch)

example: in the .bat file I have a line: koboldcpp.exe --usecuda 0 1 2 --gpulayers 40 --tensor_split 1.5 4.5 3 --contextsize 4096 --model Qwen2.5-32B-Instruct-Q4_K_M.gguf

((CHANGE THIS PART TO YOUR OWN MODEL: Qwen2.5-32B-Instruct-Q4_K_M.gguf))

7- wait for it to launch!

Note: you can change the "--tensor_split 1.5 4.5 3" in the same .bat file, for best optimization between your gpu vrams to have the best outcome according to your build.

## 💡 The Problem
Running State-of-the-Art (SOTA) 32B+ parameter Large Language Models (LLMs) typically requires enterprise-grade hardware with unified memory (e.g., RTX 3090/4090 24GB or A100 80GB). This creates a high financial barrier for local, private AI research and deployment.

## 🛠️ The Solution ("The Phoenix Cluster")
I engineered a split-computing cluster that aggregates VRAM across three generations of mismatched NVIDIA architectures (Turing, Pascal) to run **Qwen 2.5 32B** at functional speeds with **zero cloud costs**.

By manually optimizing tensor split ratios and leveraging high-bandwidth system RAM for partial offloading, I achieved stable inference on 18GB of aggregated VRAM using deprecated hardware.

## 🖥️ The Hardware Stack
* **Platform:** Standard Enterprise Workstation (Broadwell/Haswell Architecture)
* **System RAM:** 64GB DDR4 (Quad Channel Configuration)
* **GPU Cluster (Heterogeneous Mix - 18GB Total):**
    * **GPU 0:** NVIDIA Pascal Architecture (4GB VRAM)
    * **GPU 1:** NVIDIA Turing Architecture (8GB VRAM)
    * **GPU 2:** NVIDIA Pascal Architecture (6GB VRAM)

*(Note: Hardware models are anonymized. The cluster utilizes a mix of consumer-grade cards from different generations to demonstrate broad compatibility.)*

## ⚙️ Engineering Challenges & Solutions

### 1. VRAM Orchestration (The "Tetris" Problem)
Standard automated splitters failed to account for the mismatched bandwidth and VRAM ceilings of the cards, leading to immediate OOM (Out of Memory) crashes on the weakest link (1050 Ti).

**Solution:** I calculated custom tensor split ratios to balance the load based on VRAM headroom rather than raw compute power.
* **Optimized Split Ratio:** `1.5 : 4.5 : 3`
* **Result:** Prevented the 4GB card from crashing during Context Window (KV Cache) allocation while maximizing the throughput of the 8GB RTX 2080.

### 2. Latency Optimization via CPU Offloading
The 18GB VRAM pool was insufficient for the full 20GB Model (Q4 Quant).
* **Solution:** Implemented a hybrid offload strategy (`--gpulayers 40`), shifting the final 24 layers to System RAM.
* **Throughput:** Achieved **~2.50 T/s** generation speed by leveraging the Workstation's Quad-Channel Memory architecture to minimize CPU-to-GPU latency.

## 📊 Performance Results
* **Model:** Qwen 2.5 32B Instruct (Q4_K_M)
* **Context:** 4096 Tokens
* **Stability:** 100% (Zero OOM crashes under load)
* **Throughput:** ~2.5 T/s (Viable for real-time RAG applications/Chat)

## 💻 How to Replicate

### Prerequisites
* **Software:** [KoboldCPP](https://github.com/LostRuins/koboldcpp/releases) (CUDA 12 Build recommended)
* **Drivers:** Latest NVIDIA GeForce Drivers

### Launch Command
If running via command line manually:
```bash
koboldcpp.exe --usecuda 0 1 2 --gpulayers 40 --tensor_split 1.5 4.5 3 --contextsize 4096 --model "Your_Model_Name.gguf"
