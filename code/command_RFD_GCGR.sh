#!/bin/bash

pdb='/home/user4/RFdiffusion/examples/input_pdbs/8JIT.pdb'
num_designs=1000
script="/home/user4/RFdiffusion/scripts/run_inference.py"
prefix=/home/user4/Results_RFdiffusion/GCGR_9/GCGR_9
$script --config-name base \
inference.output_prefix=$prefix \
inference.num_designs=$num_designs \
'contigmap.contigs=[9-9 R27-416/0]' \
inference.input_pdb=$pdb \
inference.cyclic=True \
diffuser.T=50 \
inference.cyc_chains='a' \
ppi.hotspot_res=[\'R131\',\'R134\',\'R138\',\'R145\',\'R187\',\'R191\',\'R194\',\'R198\',\'R202\',\'R231\',\'R235\',\'R239\',\'R292\',\'R293\',\'R294\',\'R296\',\'R297\',\'R298\',\'R301\',\'R304\',\'R378\',\'R382\',\'R389\'] \
denoiser.noise_scale_ca=1 \
denoiser.noise_scale_frame=1 \


