# cycpep_Kelch — cyclic peptide design against the Keap1 Kelch domain (PDB 3WN7)

This directory covers target 1: the **Keap1 Kelch domain (PDB 3WN7, chain A)**. It holds
only what is specific to this target — configurations, input data, results and run logs.
The shared pipeline code lives in `src/`, and the entry point is `scripts/run_all.sh`.

## 1. Data provenance

The files in this directory were compiled by Du Siyu from the laboratory working
directory. `data/logs/results` gives the file-by-file mapping.

## 2. Design workflow

### 2.1 RFdiffusion + ProteinMPNN (batch 1)

1. **Backbone generation (RFdiffusion)** — chain A of 3WN7 was the only fixed target.
   Cyclic peptide backbones were generated per length under the 27 HS1 hotspot restraints
   with denoising noise = 1, using the `complex_base_ckpt` / `complex_beta_ckpt`
   checkpoints. The length scan covered **8–15 aa**, keeping 8–9 backbones per length.
2. **Hotspot-restraint check (HS2)** — the residues of HS1 that sit at the rim of the
   interface were replaced by residues lining the bottom of the pocket (18 residues, see
   `configs/hotspots_HS2.txt`), and lengths of **8–11 aa** were generated to test whether
   binding depth depends on the hotspot choice.
3. **Sequence design (ProteinMPNN)** — several sequences were generated per backbone and
   the lowest-scoring ones were passed to AlphaFold3. The number of sequences per backbone
   is not identical across runs, so the original flags remain the authoritative record.
4. **Complex prediction (AlphaFold3)** — target–peptide complexes were predicted and ranked
   by ipTM; the 26 candidates above the ipTM threshold (roughly 0.75) went on to Rosetta.

### 2.2 BoltzGen joint backbone–sequence generation (batch 2)

Using the same HS1 hotspot set, ten cyclic peptides of **10–12 aa** were generated and then
taken through the same AlphaFold3 ipTM pre-filter, RosettaScript relax/scoring and
`simple_cycpep_predict` free-state analysis.

### 2.3 Energy and conformational filtering

- **RosettaScript** — about 1000 relaxed conformers per candidate; ddG before and after
  cyclisation and the contact molecular surface were computed, and the RMSD–ddG
  distribution was used to judge whether an energy funnel forms.
  - `mpirun -np 10 rosetta_scripts.mpi.linuxgccrelease @flags_cycpep_target_relax`
  - `mpirun -np 50 score_jd2.mpi.linuxgccrelease @flags_evaluaton_cycpep`
- **simple_cycpep_predict** — about 5000 free-state conformers per candidate; the
  lowest-energy representative was compared with the AlphaFold3 bound state to assess
  conformational pre-organisation.
  - `mpirun -np 25 simple_cycpep_predict.mpi.linuxgccrelease @flags_simple_cycpep_predict`

The key parameters of every stage are collected in `configs/design_parameters.yaml`.

## 3. Directory contents

| Path | Contents |
| --- | --- |
| `configs/` | HS1 (27 residues) and HS2 (18 deep-pocket residues) hotspot lists, design lengths and key parameters |
| `data/` | 3WN7/Kelch structures, hotspot figures, the PyMOL hotspot session, low-complexity control inputs for AlphaFold3, and data provenance |
| `results/results.csv` | the nine candidates that completed AlphaFold3 + Rosetta and entered BLI evaluation (sequence, ipTM, ddG, binding signal) |
| `results/structures/af3_bound/` | AlphaFold complex CIF files for those nine candidates |
| `results/structures/free_state/` | lowest-energy `simple_cycpep_predict` free-state structures |
| `results/structures/rosetta_relax/` | Rosetta-relaxed structures of the four batch-2 BoltzGen candidates |
| `results/structures/length_scan/` | backbone designs of the 8–15 aa length scan, grouped by peptide length (`L08`–`L15`) |
| `logs/` | copies of the AlphaFold3 input and confidence JSON files, random seeds and run metadata |

## 4. Key results

- RFdiffusion + ProteinMPNN candidates reach a high ipTM more easily, whereas the BoltzGen
  candidates show a lower ddG overall and a slightly larger contact molecular surface; the
  two strategies are complementary.
- A high ipTM alone does not guarantee a BLI signal (for example KCP8_20, ipTM = 0.80, gave
  no detectable binding), which is why the Rosetta ddG and the free-state conformational
  analysis were added as a second filter.
- Among the nine candidates that completed AlphaFold3/Rosetta, `KCP_BZ_002`, `KCP_BZ_003`,
  `KCP_BZ_007`, `KCP_BZ_010`, `KCP8_9` and `KCP9_15` showed detectable binding in the BLI
  assay of 2026-05-20.
- Structures of the high-confidence intermediate candidate KCP9_6 (ipTM = 0.87) are
  archived next to the rest of the free-state ensemble, in `results/structures/free_state/`.


