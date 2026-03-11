---
title: "NeuroSkill™: Proactive Real-Time Agentic System Capable of Modeling Human State of Mind"
authors:
  - Nataliya Kosmyna
  - Eugene Hauptmann
source: "arXiv:2603.03212v1"
tags:
  - paper
  - ai/deep-learning
  - ai/agent
  - ai/llm
affiliations:
  - MIT Media Lab
date_published: 2026-03-03
date_read: 2026-03-05
type: paper_summary
category: ai
venue: "Preprint (Brain-Computer Interface, AI Agents)"
---
# NeuroSkill™: Modeling Human State of Mind

## Paper Metadata

| Field | Value |
|-------|-------|
| **Title** | NeuroSkill™: Proactive Real-Time Agentic System Capable of Modeling Human State of Mind |
| **arXiv ID** | 2603.03212v1 |
| **Authors** | Nataliya Kosmyna, Eugene Hauptmann (MIT Media Lab) |
| **Type** | System paper + Open source release |
| **License** | GPLv3 (code) + AI100 (markdown skills) |

---

## The Big Idea

**What if AI agents could understand not just what you say, but how you FEEL?**

This paper presents **NeuroSkill™** — a system that gives AI agents access to your brain and biophysical data in real-time, creating a searchable "State of Mind" that the agent can use to adapt its behavior.

**Key innovation:** The agent doesn't just respond to your words. It can:
- Detect if you're stressed, focused, tired, or overwhelmed
- Adapt its responses based on your cognitive state
- Learn from patterns in your brain activity over time
- Do all this **offline, on your own computer**

---

## Why This Matters

### The Problem with Current AI Agents

Current agentic systems assume you're a **"rational actor"** who:
- Always knows what you want
- Can accurately describe your state
- Has stable judgment under uncertainty
- Reacts predictably to outputs

**But in reality:**
- You might not realize you're stressed
- You might be unable or unwilling to describe your feelings
- External factors affect your reactions
- You might just want the agent to "be there" without offering solutions

### The Motivating Example

> A user is stuck at Boston Logan Airport due to weather, about to miss their parents' anniversary celebration. The airline offers only a 72-hour-delayed flight.
>
> The user feels anger, anxiety, and sadness. Standard LLM responses like "take a deep breath" might frustrate them further.
>
> **What would help:** A simple "I am available if you need me" — inaction might be more beneficial than suggestions.
>
> **Current agents can't do this** because they don't know the user's emotional state.

---

## The System: NeuroSkill™ + NeuroLoop™

### Two Components

| Component | What It Does |
|-----------|--------------|
| **NeuroSkill™** | App that collects BCI data, creates embeddings, exposes via API/CLI |
| **NeuroLoop™** | LLM harness that uses this data to adapt agent behavior |

### How It Works

```
┌─────────────────────────────────────────────────────────────┐
│                    THE FULL PIPELINE                        │
└─────────────────────────────────────────────────────────────┘

  1. BRAIN SIGNALS          2. EMBEDDINGS           3. STATE OF MIND
  ┌──────────────┐          ┌──────────────┐       ┌──────────────┐
  │   BCI Device │ ──────▶  │ Foundation   │ ───▶  │ Searchable   │
  │  (EEG, etc.) │          │ EXG Model    │       │ Vector Space │
  └──────────────┘          └──────────────┘       └──────────────┘
        │                                                   │
        │                 4. API/CLI                         │
        │           ┌──────────────────┐                    │
        └──────────▶│ npx neuroskill   │◀───────────────────┘
                    │ <command>        │
                    └──────────────────┘
                              │
                              ▼
                    5. NEUROLOOP™ HARNESS
                    ┌──────────────────┐
                    │ LLM + Skills +    │
                    │ State Management  │
                    └──────────────────┘
                              │
                              ▼
                    6. ADAPTIVE RESPONSE
                    ┌──────────────────┐
                    │ Agent responds   │
                    │ based on your    │
                    │ State of Mind    │
                    └──────────────────┘
```

---

## What is "State of Mind"?

### The Concept

Your **State of Mind** is a continuous, searchable representation of:
- **Cognitive states:** Focus, engagement, confusion, cognitive load
- **Affective states:** Emotions, stress, calm, excitement
- **Behavioral patterns:** How you react in different situations
- **Temporal patterns:** How your states change over time

### How It's Built

1. **EXG signals** (EEG, ECG, etc.) from BCI devices
2. **Foundation models** (ZUNA, LUNA) convert signals to embeddings
3. **Text embeddings** align brain states with your descriptions
4. **Search subsystem** lets you query: "When was I feeling focused?"

### The Search Interface

You can search your State of Mind using:
- **Text queries:** "Show me when I was working"
- **Time ranges:** "What was I feeling yesterday at 3pm?"
- **State queries:** "Find similar brain states to right now"

**Example output:**

| Query | Text Matches | EEG Neighbors | Found Labels |
|-------|--------------|---------------|--------------|
| "work" | "working", "Working" | Similar EEG patterns | "drawing charts", "typing", "writing" |

---

## Three Use Cases

### 1. Education

**Scenario:** A student studying for midterms, overwhelmed.

**What NeuroLoop™ does:**
- Monitors engagement and fatigue
- Simplifies answers when student is tired
- Suggests breaks when focus drops
- Detects distraction (phone, games) → recovery protocol
- Adapts learning style based on cognitive state

**Key insight:** The system helps students make their own choices — parental controls would undermine autonomy and dignity.

### 2. Gaming

**Scenario:** A player in an intense gaming session.

**What NeuroSkill™ can do:**
- **Passive tracking:** Monitor state without intervention
- **Active intervention:** Execute protocols when stress gets too high
- **Time management:** Like "Screen Time" but based on actual mental state
- **Balance:** Preserve the "good" parts of gaming while limiting harm

**Why it matters:** Games are designed to manipulate dopamine and stress. Players often don't realize the influence on their State of Mind.

### 3. Communication (Healthcare)

**Scenario:** People with ALS, autism, Alzheimer's, Parkinson's — who struggle with communication.

**What NeuroSkill™ enables:**
- Decoding intent from non-verbal signals
- Personalized vocabulary for caregiver communication
- Future: Control of smart homes, speech interfaces, robots, exoskeletons
- **Privacy-preserving:** Runs locally, no cloud dependency

**Key insight:** The system can execute protocols on behalf of users who can't speak for themselves, guided by policies they designed.

---

## Technical Architecture

### The Five Layers

| Layer | Function |
|-------|----------|
| **1. Transport** | BLE, WiFi, USB from BCI device |
| **2. NeuroSkill™ App** | Preprocessing, embeddings, search |
| **3. API/CLI** | `npx neuroskill <command>` |
| **4. Skill Layer** | Markdown files describing functionality |
| **5. NeuroLoop™ Harness** | LLM + tools + state management |

### Key Design Principles

1. **Offline-first:** Everything runs locally, no cloud required
2. **Edge computing:** Uses your GPU, not a data center
3. **Open source:** GPLv3 license, community-driven development
4. **Ethical licensing:** AI100 license prevents harmful use cases
5. **Human dignity:** User always owns and controls their data

---

## What Makes This Unique

### vs. Current BCI + AI Research

| Approach | What It Does | Limitation |
|----------|--------------|------------|
| Brain decoding | Reconstruct visual/auditory info | Not real-time interaction |
| State classification | Classify brain states | Doesn't adapt behavior |
| Clinical systems | Help patients communicate | Clinical settings only |
| **NeuroSkill™** | Real-time adaptive agentic system | — |

### vs. Commercial Wearables

| System | Data Ownership | Privacy | Adaptation |
|--------|---------------|---------|------------|
| Apple Watch | Apple owns/aggregates | Cloud-dependent | Limited |
| Oura, Fitbit | Company controls | Cloud-dependent | Limited |
| **NeuroSkill™** | **You own everything** | **Local-only** | **Full agent integration** |

---

## Privacy and Ethics

### The Core Principles

1. **You own your data:** Delete anytime, anywhere
2. **Offline-first:** No cloud required after initial setup
3. **Air-gapped capable:** Can run in completely isolated environments
4. **No third-party dependency:** Not controlled by any company
5. **Human dignity:** System never forces choices on you

### The AI100 License

The skill markdown files use a special license that:
- Allows any constructive use
- **Prohibits** building systems designed to harm humans
- Ensures ethical alignment

### Ethical Limitations Acknowledged

The paper explicitly addresses:
1. **Purpose limitations:** Cannot be used against human rights/dignity
2. **Data exchange:** External LLMs = different jurisdiction rules
3. **Healthcare:** Must comply with local regulations
4. **NEVER on others:** You can only use it on yourself

---

## Limitations

### Technical

| Limitation | Mitigation |
|------------|------------|
| **Context window size** | Limited to 24-hour comparisons by default |
| **GPU load** | Search operations can occupy 100% GPU |
| **BCI noise** | Artifact detection, IMU data supplement |
| **Missing data** | Foundation models interpolate latent states |

### Ethical

- Purpose must align with human rights
- External LLMs subject to third-party terms
- Healthcare uses require professional oversight
- Cannot be used on others without consent

---

## Open Source Resources

| Resource | URL |
|----------|-----|
| NeuroSkill™ app | github.com/NeuroSkill-com/skill |
| NeuroLoop™ harness | github.com/NeuroSkill-com/neuroloop |
| Skill markdown files | github.com/NeuroSkill-com/skills |
| CLI tool | github.com/NeuroSkill-com/neuroskill |
| Main app website | neuroskill.com |
| Harness website | neuroloop.io |
| CLI website | neuroskill.dev |

---

## Why This Is Interesting

### For AI Development

1. **Beyond text:** Agents can access data you can't or won't express in words
2. **Real-time adaptation:** Not just responding to queries, but sensing your state
3. **Proactive behavior:** Agent can act before you ask

### For Neuroscience

1. **Consumer BCI made useful:** Translates raw signals into actionable insights
2. **Longitudinal tracking:** Build State of Mind over time
3. **Sleep research:** Can model subconscious states too

### For Privacy Advocates

1. **You control everything:** No cloud, no company, no third party
2. **Open source:** Inspect, modify, extend the code
3. **Ethical licensing:** Cannot be weaponized against humans

---

## The Vision

> "My wife has always been eager to change the world. But I'll just settle for understanding it first."
> — Will Caster, *Transcendence* (2014)

The authors' goal: Make your brain work for **you** — not for big tech, not for corporations, but for your own benefit.

---

## What This Means for You

### As an AI User

**Current state:** AI responds to your words
**NeuroSkill™ future:** AI responds to your brain state

**Implications:**
- More empathetic interactions
- Better timing for interventions
- Personalized adaptation without manual configuration

### As a Researcher

**Potential applications:**
- Study cognitive patterns during research work
- Track focus and fatigue during long analysis sessions
- Correlate brain states with scientific breakthroughs
- Model how you think about problems

### As a Human

**The key question:** Are you comfortable with an AI that knows your brain state?

**The trade-off:**
- ✅ More helpful, adaptive AI
- ✅ Privacy-preserving (local-only)
- ✅ You own your data
- ❌ Requires wearing a BCI device
- ❌ New category of intimate data

---

## Summary Table

| Aspect | Traditional AI Agents | NeuroSkill™ |
|--------|----------------------|-------------|
| **Input** | Text, voice | Text + brain signals |
| **Awareness** | None of your state | Full cognitive/affective model |
| **Adaptation** | Manual configuration | Automatic, real-time |
| **Privacy** | Cloud-dependent | Local-only, air-gapped capable |
| **Ownership** | Company owns data | You own everything |
| **Agency** | Reactive | Proactive |

---

## Citation

```bibtex
@article{kosmyna2026neuroskill,
  title={NeuroSkill™: Proactive Real-Time Agentic System Capable of Modeling Human State of Mind},
  author={Kosmyna, Nataliya and Hauptmann, Eugene},
  journal={arXiv preprint arXiv:2603.03212},
  year={2026}
}
```

---

## Personal Notes (Dr. Guangtou)

**Key insight to remember:**
> AI agents can now access your brain state in real-time through BCI devices, creating a searchable "State of Mind" that enables proactive, adaptive behavior — all running locally on your own hardware.

**What surprised me:**
- This is a complete, open-source system you can use TODAY
- The privacy-first, offline-first design is intentional and thorough
- The authors explicitly address human dignity and ethical use
- It works for both conscious and subconscious (sleep) states

**Connections to my work:**
1. **Research workflow:** Could track focus states during paper reading/analysis
2. **Teaching:** Monitor student engagement during lectures (with consent)
3. **Telescope operations:** Track operator fatigue during long observing nights
4. **Data analysis:** Correlate brain states with insight/discovery moments

**Questions to explore:**
- [ ] How accurate are consumer BCI devices for cognitive state detection?
- [ ] Could this help optimize my research workflow?
- [ ] What are the privacy implications for collaborative research?
- [ ] How does this compare to traditional mindfulness/meditation tracking?

**Skepticism to resolve:**
- Consumer BCI devices are notoriously noisy — how reliable is the State of Mind model?
- Foundation EXG models trained on clinical data — do they work for healthy individuals?
- GPU requirements for real-time processing — practical for everyday use?

**The bigger question:** Are we ready for AI that knows how we feel?
