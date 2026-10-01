rosetta_scripts.mpi.linuxgccrelease -s Kelch_cycpep_9.pdb -parser:protocol cycpep_target_relax.xml -nstruct 1000 -out:file:silent Kelch_cycpep_9.silent 

rosetta_scripts.mpi.linuxgccrelease -in:file:silent Kelch_cycpep_9.silent -parser:protocol cycpep_evaluation.xml -out:file:score_only score_evaluation.sc