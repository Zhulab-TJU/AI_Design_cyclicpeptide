## 1. Project Overview

This project implements a de novo cyclic peptide design pipeline of the form
"AI generation — multi-level computational screening — experimental candidate output".
It targets two classes of targets, Keap1 Kelch (PDB 3WN7) and GCGR (PDB 8JIT) / GIPR,
which correspond to the two target directories `cycpep_Kelch` and `cycpep_GCGR`.
Aside from differing target structures and hotspot constraints, both pipelines share the
same computational code (src/); each target directory stores only that target's
configuration, data, script entry points and results, and outputs a standardized
candidate list results.csv (or results.xlsx) for downstream solid-phase synthesis and
wet-lab validation.
![alt text](image.png)

## 2. Runtime Environment

This project runs on a local Linux compute server. The hardware/software environment and
the computational design tools are listed below.

### 2.1 Hardware Configuration

| Item | Configuration |
| --- | --- |
| CPU | Intel® Xeon® 4210 processor (10 cores / 20 threads, 2.2 GHz) |
| Memory | RECC DDR4 2666, 16 GB |
| GPU | NVIDIA RTX 2080 Ti (11 GB VRAM, 4352 CUDA cores, 260 W) |
| SSD (system disk) | Intel enterprise-grade SSD, 960 GB (SATA) |
| HDD (data disk) | Seagate (ST) enterprise-grade HDD, 6 TB (7200 rpm, 128 MB cache, SATA) |

### 2.2 Software and Parallel Environment

| Category | Information |
| --- | --- |
| Operating system | Linux x86_64 |
| Python interpreter |  |
| Deep learning environment | |
| Compilers and runtime environment | C++, Fortran, Python, Java and other programming environments |
| Parallel environment | MPICH2 and other parallel computing environments |
| Scientific math libraries | BLAS, ATLAS, LAPACK, ScaLAPACK, FFTW |
| Job scheduling and management | PBS job scheduler installed, supporting parallel job scheduling and remote management |

### 2.3 Computational Design Tools

| Tool | Version / Deployment |
| --- | --- |
| PyRosetta | PyRosetta-4 2021; specific version: Release 2024.31 + release |
| RFdiffusion | Local deployment (GitHub: RosettaCommons/RFdiffusion) |
| ProteinMPNN | Local deployment (GitHub: dauparas/ProteinMPNN) |
| BoltzGen | Local deployment version |
| AlphaFold3 | Local deployment; can also be used together with the AlphaFold online prediction platform (https://alphafoldserver.com/) |
| Rosetta | Local deployment (rosetta_scripts.mpi.linuxgccrelease / score_jd2.mpi.linuxgccrelease) |
| simple_cycpep_predict | In-house deployment script |
| Cyclic peptide sequence → SMILES conversion | NovoPro online tool (https://www.novoprolabs.com/tools/convert-peptide-to-smiles-string) |

All third-party computational design tools are open-source / academic software; sources
and license information are given in Section 7.
