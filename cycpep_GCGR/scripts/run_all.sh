#!/usr/bin/env bash
#
# cycpep_GCGR - entry point of the cyclic peptide design campaign against the
# glucagon receptor (GCGR, PDB 8JIT, chain R = residues 27-421).
#
# The shared pipeline code lives in ../../src/ ; this script drives the
# target-specific inputs (hotspots, lengths, results) of this directory.
#
# IMPORTANT: the campaign ran on the laboratory Linux server and its per-stage
# command lines were not archived. The stage list below documents what was run and
# in which order, and keeps the file layout that ../results follows. The exact tool
# flags still have to be recovered before this can be executed end to end.
#
set -euo pipefail

TARGET_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="$TARGET_DIR/../../src"

TARGET_PDB="$TARGET_DIR/data/8JIT.pdb"        # chain R only
HS1="$TARGET_DIR/configs/hotspots_HS1.txt"    # 72 residues
DATA="$TARGET_DIR/data"
LOGS="$TARGET_DIR/logs"
RESULTS="$TARGET_DIR/results"

# ---------------------------------------------------------------------------
# Stage 1 - RFdiffusion peptide backbone generation
#   round 1: lengths 12-17 aa, 60 backbones retained
#   round 2: lengths 9-12 aa,  60 backbones retained
#   folder:  $RESULTS/structures/length_scan/
#   command line: not recorded
# ---------------------------------------------------------------------------
echo "[1/5] RFdiffusion backbone generation (rounds 1-2) - command line not recorded"

# ---------------------------------------------------------------------------
# Stage 2 - sequence design on the fixed backbones (batch 1)
#   The designed sequences are archived in $RESULTS/results.csv
# ---------------------------------------------------------------------------
echo "[2/5] sequence design - tool run not archived"

# ---------------------------------------------------------------------------
# Stage 3 - RFpeptide round 3 and the GCGRcyc set
#   Batch-1 candidates were screened with AlphaFold3 first; round 3 generated
#   30 further designs of 9/12/15 aa and the GCGRcyc set added ten designs of
#   9/12 aa.
# ---------------------------------------------------------------------------
echo "[3/5] round-3 RFpeptide / GCGRcyc design sets - see $RESULTS/results.csv"

# ---------------------------------------------------------------------------
# Stage 4 - AlphaFold3 complex prediction (ipTM ranking)
#   local run : seed 42378, 5 samples, inputs and confidence summaries in
#               $LOGS/af3_summary
#   server    : https://alphafoldserver.com/ (model 0 archived for the eight
#               candidates that went on to Rosetta)
# ---------------------------------------------------------------------------
echo "[4/5] AlphaFold3 prediction - inputs and confidence summaries in $LOGS/af3_summary"

# ---------------------------------------------------------------------------
# Stage 5 - Rosetta refinement of the 17 candidates that passed the pose check
#   9 GCGRcyc designs + 8 batch-1 / round-3 designs
#   inputs  : $RESULTS/structures/rosetta_input/
#   outputs : $RESULTS/structures/rosetta_relax/  
# ---------------------------------------------------------------------------
echo "[5/5] Rosetta refinement - inputs and refined models archived"

echo "done - every number in $RESULTS/results.csv is a copy of the archived run records"
