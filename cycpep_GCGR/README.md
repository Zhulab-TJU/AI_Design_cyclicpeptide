# cycpep_GCGR - cyclic peptide design against the glucagon receptor (GCGR, PDB 8JIT)

## 1. Design workflow

### 1.1 RFdiffusion backbone generation (rounds 1 and 2)

1. **Round 1** - chain R of 8JIT was the fixed target; a poly-glycine peptide chain was
   generated per length under the HS1 hotspot restraints. 60 peptide backbones were
   retained, covering **12-17 aa**.
2. **Round 2** - a denser scan of the short lengths; another 60 backbones were retained,
   covering **9-12 aa**.

Both sets are archived in `results/structures/length_scan/` (`round1_length_12_17/` and
`round2_length_9_12/`); `logs/length_scan_manifest.csv` lists every backbone with its
peptide length and, where applicable, the candidate that was designed on it. The contig
and hotspot command lines, the checkpoints and the number of designs generated per
length are not recorded in the archived material.

### 1.2 Sequence design and batch 1 (15 designs)

Sequences were designed on the round-1 and round-2 backbones. Fifteen candidates were
taken on to AlphaFold3: `GCGR_0`-`GCGR_37` (13-17 aa, from round-1 backbones) and
`GCGR_9_12_2`, `GCGR_9_12_8`, `GCGR_9_12_15`, `GCGR_9_12_41`, `GCGR_9_12_51`
(9-12 aa, from round-2 backbones). 

The sequence-design tool itself is not documented for this target: the backbones and the
designed sequences are archived, but no ProteinMPNN run directory or log exists. The
`generator` column therefore marks the ProteinMPNN step of these 15 rows as *inferred*.

### 1.3 RFpeptide round 3 (30 designs)

Ten designs per length for **9, 12 and 15 aa** were generated with the tool that the
laboratory record calls *RFpeptide*; all 30 were screened by AlphaFold3. This round
produced the two highest ipTM values of the campaign (`GCGR_9_0` and `GCGR_9_11`,
ipTM = 0.85). The backbone complex of each round-3 design (poly-glycine peptide chain A
plus the same fixed receptor chain B as the RFdiffusion scans) is archived in
`results/structures/round3_RFpeptide/`.

### 1.4 GCGRcyc set (10 designs)

Ten further cyclic peptides of 9 and 12 aa. Their generation route is not documented in
the archived material, so the `generator` column reports `not recorded` rather than
guessing. Nine of the ten passed the AlphaFold3 pose check; `GCGRcyc_507` was rejected
because the predicted binding site was wrong, and it was not passed on to Rosetta.

### 1.5 Complex prediction (AlphaFold3)

Every candidate was predicted as a receptor-peptide complex and ranked by ipTM. All
AlphaFold3 inputs specify seed 42378; the 18 runs that kept their per-sample output used
five samples per candidate (`logs/ranking_scores/`), while for the remaining candidates
only the top-ranked model and its confidence summary were archived
(`logs/af3_summary/`). For the eight candidates that went on to Rosetta, model 0 of the
AlphaFold Server run is archived as well. No screening threshold is recorded for this
target.

For the GCGRcyc set the ipTM in the laboratory record is systematically 0.02-0.03 higher
than the value in the archived local AlphaFold3 summary. Both numbers are reported
(`iptm` and `iptm_af3_archive`) instead of silently choosing one; for all other
candidates the two agree exactly.

### 1.6 Rosetta refinement

Seventeen candidates (9 GCGRcyc designs and 8 batch-1 / round-3 designs) were refined and
scored; ddG and the contact molecular surface are reported in `results/results.csv`. The
complex used as input is archived in `results/structures/rosetta_input/` and one refined
model per candidate in `results/structures/rosetta_relax/`, where the file name keeps the
original Rosetta model index. The Rosetta flags, the number of generated conformers and
the RMSD-vs-ddG energy-funnel analysis are not archived.

## 2. Directory contents

| Path | Contents |
| --- | --- |
| `configs/` | HS1 (72 surface residues) and HS2 (4 core residues) hotspot lists, design lengths and key parameters |
| `data/8JIT.pdb` | the target structure (chain R = human GCGR residues 27-421) |
| `data/gcgr_receptor.fasta` | the receptor sequence extracted from `8JIT.pdb` |
| `data/hotspots/` | the two PyMOL hotspot sessions (`HS1_GCGR.pse`, `HS2_GCGR.pse`) |
| `data/figures/` | the ipTM-vs-length figures and the slide images of the GCGR/GIPR discussion deck |
| `data/lab_records/` | the archived ipTM-by-length spreadsheet and the discussion deck |
| `data/provenance.md` | source mapping, laboratory documents and the checks performed |
| `results/results.csv` | all 55 candidates with sequence, length, campaign, ipTM and, where available, ddG and contact molecular surface |
| `results/structures/af3_bound/` | AlphaFold3 complex models (`<id>.cif` = local top-ranked model, `<id>_af3server.cif` = AlphaFold Server model 0) |
| `results/structures/rosetta_input/` | the complexes submitted to Rosetta |
| `results/structures/rosetta_relax/` | one Rosetta-refined model per candidate |
| `results/structures/length_scan/` | the RFdiffusion backbones of both scans, grouped by round |
| `results/structures/round3_RFpeptide/` | the round-3 backbone complex of each RFpeptide design |
| `logs/af3_summary/` | AlphaFold3 input JSON files (`<id>_input.json`) and confidence summaries (`<id>.json`) |
| `logs/ranking_scores/` | the five per-sample ranking scores of the 18 local AlphaFold3 runs |
| `logs/run_metadata.csv` | per-candidate mapping to the source files of every stage |
| `logs/length_scan_manifest.csv` | all 120 scan backbones with length and the candidate designed on them |



