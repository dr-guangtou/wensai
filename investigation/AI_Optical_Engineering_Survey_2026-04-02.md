# AI/ML in Optical Design and Manufacturing: A Curated Resource List

**Date:** 2026-04-02
**Context:** MUST project (6.5m MUltiplexed Survey Telescope) — landscape survey for AI-enabled optical engineering
**Scope:** AI/ML methods (beyond simple DNNs) applied to optical and optomechanical design, fabrication, metrology, and active control
**Stage:** Initial reconnaissance — collecting sources and establishing references

---

## How to Use This Document

This document consolidates findings from three independent search campaigns into a single, de-duplicated reference. It is organized by **application area**, not by source. Each entry includes a working URL. Entries without verifiable URLs have been excluded.

The focus is on **optical design and fabrication** for precision instruments; fiber positioner and spectrograph fiber systems are out of scope.

---

## Table of Contents

1. [Use Cases: Labs, Companies, and Projects](#1-use-cases)
2. [Published Papers and Reviews](#2-published-papers-and-reviews)
3. [Available Tools, Libraries, and Models](#3-available-tools-libraries-and-models)
4. [Conferences to Monitor](#4-conferences-to-monitor)
5. [Gap Analysis and Critical Assessment](#5-gap-analysis-and-critical-assessment)
6. [Summary of Key Resources](#6-summary-of-key-resources)

---

## 1. Use Cases

### 1.1 Telescope and Observatory Projects

| Organization | AI Application | Evidence | Link |
|---|---|---|---|
| **Rubin Observatory** | CNN-based wavefront estimation for active optics; two-stage approach (CNN + linear regression) trained on 600k simulated donut images | Published paper + workshop presentation | [arXiv:2402.08094](https://arxiv.org/html/2402.08094) |
| **ESO — PO4AO** | Model-based reinforcement learning for extreme AO control; tested on GHOST bench at ESO HQ (Garching) | Peer-reviewed (JATIS 2024) | [JATIS 10(1), 019001](https://doi.org/10.1117/1.JATIS.10.1.019001) |
| **ESO — Microsoft partnership** | AI in astronomy operations (broad scope) | Press release | [Microsoft News](https://news.microsoft.com/source/latam/company-news-es/eso-and-microsoft-will-work-with-artificial-intelligence-to-boost-astronomy/) |
| **Safran Reosc — ELT M1** | Factory 4.0 for polishing 931 ELT M1 segments; robotization, digital manufacturing data, interconnected production; throughput of 4–10 segments/week | SPIE talk + company page | [Safran Factory 4.0](https://www.safran-group.com/news/factory-40-made-safran-mirrors-extremely-large-telescope-2020-02-04) |

**Note on Safran Reosc:** Their "smart factory" uses Industry 4.0 automation (robotics, digital twins, interconnected production) but it is unclear from public sources whether ML/AI is used for process control vs. classical automation. Worth investigating further.

### 1.2 Research Institutions — Optical Design

| Institution | Focus | Link |
|---|---|---|
| **KAUST — Visual Computing Center** (Heidrich group) | DeepLens: differentiable ray tracing, curriculum learning for automated lens design from scratch | [DeepLens GitHub](https://github.com/vccimaging/DeepLens) |
| **Stanford — Fan Lab** | MetaChat: multi-agentic framework for autonomous metasurface design using FiLM WaveY-Net surrogate Maxwell solver | [Science Advances (2025)](https://www.science.org/doi/10.1126/sciadv.adx8006) |
| **U. Michigan — Guo Lab** | OptoGPT: GPT-based foundation model for inverse design of optical multilayer thin films | [Opto-Electron. Adv. 7(7), 240062](https://www.oejournal.org/oea/article/doi/10.29026/oea.2024.240062) |
| **Stanford — Vučković Lab** | Inverse design and implementation of photonic devices | [YouTube lecture](https://www.youtube.com/watch?v=ec8sK-HgLnw) |
| **U. Rochester — NSF OPAL** | Optics + AI integration, freeform optics manufacturing | [NSF OPAL](https://nsf-opal.rochester.edu/) |
| **TU Delft** | Topology optimization for optomechanical structures using differentiable ray tracing | [TU Delft thesis](https://resolver.tudelft.nl/uuid:cc5ca948-c318-4da2-90cc-78d4411c715e) |
| **Fraunhofer ILT** | RL for automated design of optical systems | [Annual Report (PDF)](https://www.ilt.fraunhofer.de/content/dam/ilt/en/documents/annual_reports/ar21/tf5/ar21-p97-reinforcement-learning-for-automated-design-of-optical-systems.pdf) |
| **Fraunhofer IOF** | Applied optics, freeform metal optics for ELT MICADO instrument | [Fraunhofer IOF](https://www.iof.fraunhofer.de/) |
| **MIT CSAIL** | Closing design-to-manufacturing gap for optical devices | [MIT News](https://news.mit.edu/2023/closing-design-manufacturing-gap-optical-devices-1213) |
| **MIT Lincoln Lab** | ML for adaptive optics enhancement | [Technical Report (PDF)](https://dspace.mit.edu/bitstream/handle/1721.1/164899/MIT-LIN-151375.pdf) |

### 1.3 Commercial Platforms and Companies

| Organization | Product/Service | Status | Link |
|---|---|---|---|
| **ZEISS** | AI-driven metrology and automated defect inspection | Production | [ZEISS AI Inspection](https://www.zeiss.com/metrology/en/explore/quality-insights/ai-driven-inspection.html) |
| **OptoTech** | AI in precision optics fabrication (grinding, polishing, predictive maintenance) | Talk at OptiFab 2025 | [OptiFab 2025 Program](https://spie.org/OFB25/conferencedetails/optical-fabrication) |
| **Ansys (Zemax)** | OpticStudio + Ansys AI/ML multiphysics ecosystem | Commercial | [Ansys Blog](https://www.ansys.com/blog/role-ai-multiphysics-future-optical-design-ansys-optics-edmund-optics) |
| **Peak Nano** | HawkAI™: prompt-driven AI optics design platform | Commercial (claims NLP interface) | [Peak Nano](https://www.peaknano.com/hawkai-optics-design-design-software) |
| **opdo.ai** | AI-powered optics design and manufacturing platform | Startup | [opdo.ai](https://opdo.ai/) |
| **Flexcompute (Tidy3D)** | Inverse design with adjoint method for photonic devices | Commercial + educational | [Tidy3D](https://www.flexcompute.com/tidy3d/) |

**Caveat on Peak Nano and opdo.ai:** Independent verification of their claims through peer-reviewed sources is lacking. Treat as leads, not established references.

---

## 2. Published Papers and Reviews

### 2.1 Comprehensive Reviews

| Title | Venue | Year | Link |
|---|---|---|---|
| Artificial intelligence in optical lens design | *Artif. Intell. Rev.* 57, 193 | 2024 | [Springer](https://link.springer.com/article/10.1007/s10462-024-10842-y) |
| Deep learning across optical system workflow | *J. Phys. Photonics* | 2024 | [IOP](https://iopscience.iop.org/article/10.1088/2515-7647/ae3f6b) |
| AI for optical metasurface | *npj Nanophotonics* 1, 36 | 2024 | [Nature](https://www.nature.com/articles/s44310-024-00037-2) |
| Deep learning in optical metrology: a review | *Light: Sci. Appl.* | 2022 | [Nature](https://www.nature.com/articles/s41377-022-00714-x) |
| Applying machine learning to optical metrology | *Meas. Sci. Technol.* | 2024 | [IOP](https://iopscience.iop.org/article/10.1088/1361-6501/ad7878) |
| Adaptive optics based on machine learning: a review | *Opto-Electron. Adv.* | 2022 | [OEA](https://www.oejournal.org/article/doi/10.29026/oea.2022.200082) |
| A review of machine learning methods for wavefront control | arXiv | 2023 | [arXiv (PDF)](https://arxiv.org/pdf/2309.00730) |
| AI and ML in optics: tutorial | *JOSA B* | 2024 | [Optica](https://opg.optica.org/josab/fulltext.cfm?uri=josab-41-8-1739) |
| AI inspired freeform optics design: a review | ResearchGate | 2024 | [ResearchGate](https://www.researchgate.net/publication/384681153_Artificial_intelligence_inspired_freeform_optics_design_a_review) |
| Synergy between AI and optical metasurfaces | *Photonics* 11(5), 442 | 2024 | [MDPI](https://www.mdpi.com/2304-6732/11/5/442) |
| AI in astronomical optical telescopes: present status and future | ResearchGate | 2024 | [ResearchGate](https://www.researchgate.net/publication/380439717_Artificial_Intelligence_in_Astronomical_Optical_Telescopes_Present_Status_and_Future_Perspectives) |
| AI Opens Up Optical System Design | *OPN* | 2026 | [Optica OPN](https://www.optica-opn.org/home/articles/volume_37/january_2026/features/ai_opens_up_optical_system_design/) |
| Future of optical system and lens design in the AI era | SPIE Proc. 13019, 1301902 | 2024 | [SPIE](https://doi.org/10.1117/12.3025345) |

### 2.2 Differentiable Optics and Automated Lens Design

| Title | Venue | Year | Link |
|---|---|---|---|
| Curriculum learning for ab initio deep learned refractive optics | *Nature Communications* | 2024 | [Nature](https://www.nature.com/articles/s41467-024-50835-7) |
| dO: A differentiable engine for Deep Lens design | *IEEE Trans. Comput. Imaging* | 2022 | [Paper (PDF)](https://vccimaging.org/Publications/Wang2022DiffOptics/Wang2022DiffOptics.pdf) |
| End-to-end hybrid refractive-diffractive lens design (ray-wave model) | SIGGRAPH Asia 2024 | 2024 | [ACM DL](https://dl.acm.org/doi/10.1145/3680528.3687640) |
| Freeform optical system design with differentiable 3D ray tracing | *Optics Express* | 2023 | [Optica](https://opg.optica.org/oe/fulltext.cfm?uri=oe-31-5-7450) |
| End-to-end automatic lens design with a differentiable diffraction model | *Optics Express* | 2024 | [Optica](https://opg.optica.org/oe/fulltext.cfm?uri=oe-32-25-44328) |
| A generalized differential optical design library with NURBS | *JEOS* | 2024 | [EDP Sciences](https://jeos.edpsciences.org/articles/jeos/full_html/2024/01/jeos20230041/jeos20230041.html) |

### 2.3 Reinforcement Learning for Optical Design and Control

| Title | Venue | Year | Link |
|---|---|---|---|
| Toward on-sky AO control using RL (PO4AO theory) | *A&A* | 2022 | [A&A](https://www.aanda.org/articles/aa/full_html/2022/08/aa43311-22/aa43311-22.html) |
| Lab experiments of model-based RL for AO control | *JATIS* 10(1) | 2024 | [SPIE](https://doi.org/10.1117/1.JATIS.10.1.019001) |
| RL for photonic component design | *Appl. Phys. Rev.* | 2023 | [AIP](https://pubs.aip.org/aip/app/article/8/10/106101/2913915/Reinforcement-learning-for-photonic-component) |
| RL method for optical thin-film design | arXiv | 2021 | [arXiv](https://arxiv.org/abs/2102.09398) |
| Automated multi-layer optical design via deep RL | *ML: Sci. Technol.* | 2020 | [IOP](https://iopscience.iop.org/article/10.1088/2632-2153/abc327) |
| Designing freeform imaging systems based on RL | *Optics Express* | 2020 | [Optica](https://opg.optica.org/oe/fulltext.cfm?uri=oe-28-20-30309) |
| RL for adaptive optical coating design | SPIE Proc. | 2025 | [SPIE](https://www.spiedigitallibrary.org/conference-proceedings-of-spie/14014/1401413/Reinforcement-learning-for-adaptive-optical-coating-design/10.1117/12.3094141.full) |
| Self-adjusting optical systems based on RL | *Photonics* | 2023 | [MDPI](https://www.mdpi.com/2304-6732/10/10/1097) |

### 2.4 Adaptive Optics and Wavefront Sensing

| Title | Venue | Year | Link |
|---|---|---|---|
| ML-driven control of deformable mirror for aberration-free X-ray wavefronts | *Optics Express* | 2023 | [Optica](https://opg.optica.org/oe/abstract.cfm?uri=oe-31-13-21264) |
| ML-assisted wavefront sensor in AO feedback loop | SPIE Proc. | 2025 | [SPIE](https://www.spiedigitallibrary.org/conference-proceedings-of-spie/13860/1386005/Machine-learning-assisted-wavefront-sensor/10.1117/12.3084846.full) |
| Experimental wavefront sensing based on deep learning | *Sci. Reports* | 2024 | [Nature](https://www.nature.com/articles/s41598-024-80615-8) |
| Wavefront sensor-less AO using deep RL | *PMC* | 2021 | [PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC8515990/) |
| Deep learning for optical misalignment diagnostics | arXiv | 2025 | [arXiv](https://arxiv.org/html/2506.23173) |
| Phasing segmented telescopes via deep learning | arXiv | 2024 | [arXiv](https://arxiv.org/html/2403.18712v1) |
| A review of wavefront sensing based on data-driven methods | *Aerospace* | 2025 | [MDPI](https://www.mdpi.com/2226-4310/12/5/399) |

### 2.5 Optical Coating Design

| Title | Venue | Year | Link |
|---|---|---|---|
| OptoGPT: foundation model for inverse design in optical multilayer thin film structures | *Opto-Electron. Adv.* 7(7), 240062 | 2024 | [OEA](https://www.oejournal.org/oea/article/doi/10.29026/oea.2024.240062) |
| Efficient optical coating design using autoencoder-based NN | *J. Phys. Photonics* | 2024 | [IOP](https://iopscience.iop.org/article/10.1088/2515-7647/ae1b53) |
| ML-based design optimization of aperiodic multilayer optical structures | *Energy* | 2024 | [ScienceDirect](https://www.sciencedirect.com/science/article/abs/pii/S0017931024001352) |
| Enhanced prediction and optimization of thin metal film optical properties | *Sci. Reports* | 2025 | [Nature](https://www.nature.com/articles/s41598-025-27524-6) |
| Thin-film neural networks for optical inverse problem | *Light: Adv. Manuf.* | 2021 | [Light AM](https://www.light-am.com/en/article/doi/10.37188/lam.2021.027) |

### 2.6 Inverse Design and Metasurfaces

| Title | Venue | Year | Link |
|---|---|---|---|
| MetaChat: multi-agentic framework for real-time metasurface design | *Science Advances* 11(44) | 2025 | [Science](https://www.science.org/doi/10.1126/sciadv.adx8006) |
| Generative model for the inverse design of metasurfaces | *Nano Letters* | 2018 | [ACS](https://pubs.acs.org/doi/abs/10.1021/acs.nanolett.8b03171) |
| Deep generative modeling and inverse design of manufacturable metasurfaces | *ACS Photonics* | 2023 | [ACS](https://pubs.acs.org/doi/10.1021/acsphotonics.2c01006) |
| Exploring AI in metasurface structures with forward and inverse design | *iScience* | 2025 | [ScienceDirect](https://www.sciencedirect.com/science/article/pii/S258900422500255X) |
| Neural-adjoint method for inverse design of metasurfaces | *Optics Express* | 2021 | [Optica](https://opg.optica.org/oe/abstract.cfm?uri=oe-29-5-7526) |

### 2.7 Digital Twins and Surrogate Modeling

| Title | Venue | Year | Link |
|---|---|---|---|
| Bridging optical and thermoelastic simulations with surrogate models | SPIE Proc. | 2025 | [SPIE](https://spie.org/optical-systems-design/presentation/Bridging-Optical-and-Thermoelastic-Simulations-with-Surrogate-Models-for-System/14106-55) |
| Thermo-mechanical-optical coupling within a digital twin framework | *Optical Materials* | 2023 | [ScienceDirect](https://www.sciencedirect.com/science/article/abs/pii/S0026271422004395) |
| Review on digital twin model for IR optical-mechanical systems | *Taylor & Francis* | 2025 | [T&F](https://www.tandfonline.com/doi/full/10.1080/27525783.2025.2493074) |
| Surrogate model based multi-objective optimization for optical design | *Applied Sciences* | 2022 | [MDPI](https://www.mdpi.com/2076-3417/12/13/6810) |
| Surrogate NN model for sensitivity analysis of optical systems | *Computers & Structures* | 2022 | [ScienceDirect](https://www.sciencedirect.com/science/article/abs/pii/S0045794922001031) |

### 2.8 Optomechanical Structure Optimization

| Title | Venue | Year | Link |
|---|---|---|---|
| Topology optimization of optomechanical structures leveraging differentiable ray tracing | TU Delft thesis | 2024 | [TU Delft](https://resolver.tudelft.nl/uuid:cc5ca948-c318-4da2-90cc-78d4411c715e) |
| RL-based topology optimization for generative design | *PMC* | 2025 | [PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC12355488/) |
| SOgym: structural design through RL | arXiv | 2024 | [arXiv](https://arxiv.org/abs/2407.07288) |

### 2.9 Optical Alignment and Assembly Automation

| Title | Venue | Year | Link |
|---|---|---|---|
| A review of automation of laser optics alignment with focus on ML | *Opt. Lasers Eng.* | 2024 | [ScienceDirect](https://www.sciencedirect.com/science/article/pii/S0143816623004529) |
| Application of deep learning in active alignment | *Optics Express* | 2024 | [Optica](https://opg.optica.org/abstract.cfm?uri=oe-32-25-43834) |
| Three approaches to the automation of laser system alignment | arXiv | 2024 | [arXiv](https://arxiv.org/html/2409.11090v1) |

### 2.10 Stray Light Analysis

| Title | Venue | Year | Link |
|---|---|---|---|
| Using deep learning for effective simulation of ghost images | *ScienceDirect* | 2024 | [ScienceDirect](https://www.sciencedirect.com/science/article/pii/S2666950124000403) |
| Model for suppressing stray light in astronomical images based on DL | *Sci. Reports* | 2024 | [Nature](https://www.nature.com/articles/s41598-024-78472-6) |

### 2.11 Optical Metrology and Inspection

| Title | Venue | Year | Link |
|---|---|---|---|
| DL-based fringe-pattern analysis with uncertainty estimation | *Optica* | 2021 | [Optica](https://opg.optica.org/optica/fulltext.cfm?uri=optica-8-12-1507) |
| DL-based fringe-print-through error and noise removal | *Opt. Laser Technol.* | 2025 | [ScienceDirect](https://www.sciencedirect.com/science/article/pii/S0030399225009041) |
| DL-based deflectometry for freeform surface measurement | *Optics Letters* | 2022 | [Optica](https://opg.optica.org/abstract.cfm?uri=ol-47-1-78) |
| A review of optical metrology techniques for advanced manufacturing | *PMC* | 2024 | [PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC12654731/) |

### 2.12 Physics-Informed Neural Networks (PINNs)

| Title | Venue | Year | Link |
|---|---|---|---|
| Physics-informed deep learning for 3D modeling of light diffraction | *Optics Express* | 2025 | [Optica](https://opg.optica.org/oe/fulltext.cfm?uri=oe-33-1-1371) |
| PINNs for inverse problems in nano-photonics | *Optics Express* | 2020 | [Optica](https://opg.optica.org/oe/abstract.cfm?URI=oe-28-8-11618) |
| Physics-informed ML for inverse design of optical metamaterials | *Adv. Photonics Res.* | 2024 | [Wiley](https://advanced.onlinelibrary.wiley.com/doi/10.1002/adpr.202300158) |

### 2.13 Bayesian Optimization for Optical Design

| Title | Venue | Year | Link |
|---|---|---|---|
| Safe Bayesian optimization for tuning optical systems | IFAC Proc. | 2024 | [ScienceDirect](https://www.sciencedirect.com/science/article/abs/pii/S2405896323018463) |
| Selecting robust silicon photonic designs after Bayesian optimization | *Optics Express* | 2024 | [Optica](https://opg.optica.org/oe/fulltext.cfm?uri=oe-32-21-37585) |
| Combining Bayesian optimization, SVD and ML for optical design | arXiv | 2024 | [arXiv](https://arxiv.org/html/2411.05496v1) |
| Bayesian optimization for inverse problems in diffractive optical elements | ResearchGate | 2018 | [ResearchGate](https://www.researchgate.net/publication/325407223_Solving_inverse_problems_appearing_in_design_and_metrology_of_diffractive_optical_elements_by_using_Bayesian_optimization) |

### 2.14 Agentic AI and LLMs for Optical Design

| Title | Venue | Year | Link |
|---|---|---|---|
| OPTIAGENT: physics-driven agentic framework for automated optical design | arXiv | 2025 | [arXiv](https://arxiv.org/abs/2602.23761) |
| StarWhisper Telescope: AI framework for automating astronomical observations | *Nature Commun. Eng.* | 2025 | [Nature](https://www.nature.com/articles/s44172-025-00520-4) |
| AI approach takes optical system design from months to milliseconds | *Phys.org / Nanophotonics* | 2026 | [Phys.org](https://phys.org/news/2026-01-ai-approach-optical-months-milliseconds.html) |

### 2.15 Differentiable Methods and Adjoint Optimization (Photonics)

| Title | Venue | Year | Link |
|---|---|---|---|
| Adjoint method and inverse design for nonlinear nanophotonic devices | *ACS Photonics* | 2019 | [ACS](https://pubs.acs.org/doi/10.1021/acsphotonics.8b01522) |
| Merging automatic differentiation and the adjoint method | arXiv | 2023 | [arXiv](https://arxiv.org/abs/2309.16731) |
| DL and adjoint method accelerated inverse design in photonics | *Photonics* | 2023 | [MDPI](https://www.mdpi.com/2304-6732/10/7/852) |
| Inverse design in photonics: adjoint method (lecture) | Flexcompute | — | [Tidy3D Learning](https://www.flexcompute.com/tidy3d/learning-center/inverse-design/Lecture-2-Inverse-Design-in-Photonics-Lecture-2-Adjoint-Method/) |

---

## 3. Available Tools, Libraries, and Models

### 3.1 Differentiable Optics (Open Source)

| Tool | Origin | Key Features | Link |
|---|---|---|---|
| **DeepLens** | KAUST (Xinge Yang, Wolfgang Heidrich) | Differentiable ray tracer; curriculum learning for automated lens design; hybrid refractive-diffractive; PyTorch | [GitHub](https://github.com/vccimaging/DeepLens) |
| **DiffOptics (dO)** | KAUST | Memory-efficient differentiable ray tracing engine; predecessor to DeepLens | [GitHub](https://github.com/vccimaging/DiffOptics) |
| **AutoLens** | AI4Optics (Xinge Yang) | Automated lens design from scratch using gradient backpropagation | [GitHub](https://github.com/AI4Optics/AutoLens) |
| **MetaChat** | Stanford (Fan Lab) | Multi-agentic metasurface design; FiLM WaveY-Net Maxwell surrogate solver; GPT-4o backbone | [GitHub](https://github.com/jonfanlab/metachat) |
| **LensRL** | Harrison Kramer | RL for optical design using Zemax backend | [GitHub](https://github.com/HarrisonKramer/LensRL) |
| **TorchOptics** | Community | Differentiable Fourier optics simulations; GPU-accelerated; PyTorch | [arXiv](https://arxiv.org/html/2411.18591v1) |
| **Torch Lens Maker** | Victor Poughon | Differentiable geometric optics (experimental) | [Docs](https://victorpoughon.github.io/torchlensmaker/) |

### 3.2 General Optical Design (Open Source)

| Tool | Features | Link |
|---|---|---|
| **Optiland** | Open-source optical design software with AI potential | [Reddit discussion](https://www.reddit.com/r/Optics/comments/1mpusss/open_source_optical_design_software_optiland/) |
| **Raypier** | Non-sequential ray tracing; Python | [GitHub](https://github.com/bryancole/raypier_optics) |
| **rayopt** | Geometric, paraxial, Gaussian ray tracing; Python | [GitHub](https://github.com/quartiq/rayopt) |
| **pyOpTools** | Non-sequential ray tracing of complex 3D systems | [Docs](https://pyoptools.readthedocs.io/) |
| **Open Optical Designer** | Free browser-based lens design | [Web](https://alexbock.github.io/open-optical-designer/) |

### 3.3 Commercial Software with AI/ML Integration

| Software | Vendor | AI/ML Status | Link |
|---|---|---|---|
| **OpticStudio** | Ansys (Zemax) | Integration with Ansys AI/ML ecosystem; early stage | [Ansys](https://www.ansys.com/products/optics/ansys-zemax-opticstudio) |
| **Speos** | Ansys | GPU-accelerated optical simulation; multiphysics integration | [Ansys](https://www.ansys.com/products/optics/ansys-speos) |
| **CODE V** | Keysight | Classical optimizer + tolerancing; no public AI integration | [Keysight](https://www.keysight.com/us/en/products/software/optical-solutions-software/optical-design-solutions/codev.html) |
| **Tidy3D** | Flexcompute | Inverse design with adjoint method for photonics | [Flexcompute](https://www.flexcompute.com/tidy3d/) |
| **HawkAI™** | Peak Nano | Claims NLP-driven optical design (unverified independently) | [Peak Nano](https://www.peaknano.com/hawkai-optics-design-design-software) |

---

## 4. Conferences to Monitor

| Event | Next Date | Focus | Link |
|---|---|---|---|
| **SPIE OptiFab** | Oct 2025, Rochester, NY | Optical fabrication; includes "AI in precision optics fabrication" session | [SPIE OptiFab](https://spie.org/conferences-and-exhibitions/optifab) |
| **SPIE Optics + Photonics** | Aug 2025, San Diego | Broad optics; optical engineering tracks | [SPIE O+P](https://spie.org/conferences-and-exhibitions/optics-and-photonics) |
| **SPIE Photonics West** | Jan (annual) | Premier photonics event; includes "Generative AI for Optical System Design" | [SPIE PW](https://spie.org/conferences-and-exhibitions/photonics-west) |
| **SPIE Optical Systems Design** | Apr 2026 | Optical systems design conference series | [SPIE OSD](https://spie.org/conferences-and-exhibitions/optical-systems-design) |
| **SPIE Astronomical Telescopes + Instrumentation** | Next: 2026 | Telescope optics, fabrication, AIT | [SPIE AT+I](https://spie.org/conferences-and-exhibitions/astronomical-telescopes-and-instrumentation) |
| **SPIE Optical Design Automation** | 2025 | AI in end-to-end optical system design process | [SPIE Proc. Vol. 13601](https://spie.org/Publications/Proceedings/Volume/13601) |

---

## 5. Gap Analysis and Critical Assessment

### Maturity by Application Area

| Area | Maturity | Key Evidence | MUST Relevance |
|---|---|---|---|
| Adaptive optics wavefront control | **High** | On-sky and lab demos (ESO PO4AO, Rubin) | High — active optics |
| Differentiable ray tracing for lens design | **High** | Multiple open-source tools; Nature Comms paper | Medium — spectrograph design |
| Optical coating / thin-film inverse design | **Medium** | OptoGPT, RL methods, autoencoder approaches | Medium — filter/AR coatings |
| Metasurface inverse design | **Medium–High** | Fastest-growing sub-field; MetaChat | Low — not telescope scale |
| Optical metrology and inspection | **Medium** | ZEISS commercial; DL for interferometry | Medium — mirror/lens QC |
| Digital twins / surrogate models for TSO | **Low–Medium** | Mostly conference papers; few operational | High — large mirror analysis |
| AI for optical fabrication processes | **Low** | OptoTech talk upcoming; Safran automation is classical | High — MUST mirror fabrication |
| Large mirror figuring with ML | **Low** | Few ML papers; classical CCP/MRF methods dominant | High — MUST primary |
| Freeform surface manufacturing with AI | **Low** | Limited published work | High — MUST correctors |
| Full optomechanical system-level AI design | **Very Low** | No integrated frameworks exist | High — MUST system design |

### AI/ML Method Categories in Use

| Method | Typical Application | Key Advantage |
|---|---|---|
| **Differentiable ray tracing** | Lens design, end-to-end optimization | Exact gradients through optical system; GPU-accelerated |
| **Reinforcement learning (PPO, MBRL)** | AO control, coating design, freeform design | Handles sequential decisions; no labeled data needed |
| **Bayesian optimization (GP)** | Robust design tuning, optical system alignment | Sample-efficient; handles expensive evaluations |
| **Physics-informed NNs (PINNs)** | Inverse problems, wave propagation modeling | No training data needed; respects physics constraints |
| **Generative models (GANs, VAEs)** | Metasurface generation, structural design | Multi-solution inverse design |
| **Foundation models (GPT-style)** | Thin-film design (OptoGPT); metasurface design (MetaChat) | Generalization across design tasks |
| **CNNs** | Wavefront sensing, metrology, defect inspection | Fast inference from image-like inputs |

### Key Gaps Relevant to MUST

1. **Scale mismatch:** Most AI tools target mm-to-cm scale optics (cameras, photonics), not meter-class telescope optics.
2. **Manufacturing integration:** Very few tools address the design-to-fabrication pipeline for large precision optics; AI for grinding/polishing process control is nearly absent in the literature.
3. **No system-level AI frameworks:** Existing work is component-level (one lens, one coating, one mirror). No published framework optimizes across the full optomechanical system.
4. **Segmented mirror phasing:** Some early deep learning work exists ([arXiv:2403.18712](https://arxiv.org/html/2403.18712v1)) but the field is nascent.
5. **Freeform astronomical optics:** AI-assisted freeform design exists for commercial optics but not for large astronomical correctors.

---

## 6. Summary of Key Resources

For someone starting from zero on this topic, the following resources provide the best entry points:

**If you read five things:**

1. **Review — AI in lens design:** Yow et al. 2024, *Artif. Intell. Rev.* — the most comprehensive review of AI methods for optical design. [Link](https://link.springer.com/article/10.1007/s10462-024-10842-y)
2. **Tool — DeepLens:** Open-source differentiable ray tracer from KAUST; the leading open tool for automated lens design with curriculum learning. Published in *Nature Communications* (2024). [GitHub](https://github.com/vccimaging/DeepLens) | [Paper](https://www.nature.com/articles/s41467-024-50835-7)
3. **Agentic AI — MetaChat:** Stanford's multi-agent framework for photonic device design; published in *Science Advances* (2025). The closest example to a full AI-driven optical design workflow. [GitHub](https://github.com/jonfanlab/metachat) | [Paper](https://www.science.org/doi/10.1126/sciadv.adx8006)
4. **RL for AO — PO4AO:** Model-based RL for adaptive optics control from ESO/ETH Zürich; the most mature AI application in telescope operations. [Paper](https://doi.org/10.1117/1.JATIS.10.1.019001) | [A&A theory paper](https://www.aanda.org/articles/aa/full_html/2022/08/aa43311-22/aa43311-22.html)
5. **Foundation model — OptoGPT:** GPT-style inverse design for optical thin films from U. Michigan; demonstrates how transformer architectures can be adapted for optical engineering. [Paper](https://www.oejournal.org/oea/article/doi/10.29026/oea.2024.240062) | [arXiv](https://arxiv.org/abs/2304.10294)

**For fabrication specifically:** Monitor the SPIE OptiFab 2025 proceedings (Oct 2025), especially the OptoTech talk on AI in precision optics fabrication. The Safran Reosc ELT Factory 4.0 is the closest real-world example of advanced automation for large astronomical optics, though its ML content is unclear. [OptiFab](https://spie.org/OFB25/conferencedetails/optical-fabrication) | [Safran](https://www.safran-group.com/news/factory-40-made-safran-mirrors-extremely-large-telescope-2020-02-04)

**For wavefront sensing / active optics:** The Rubin Observatory active optics work is most directly relevant to MUST's needs. [arXiv:2402.08094](https://arxiv.org/html/2402.08094)

---

*This document merges results from three independent search campaigns (2026-04-02). Sources were cross-checked for URL availability. Compiled for the MUST project optical engineering team.*
