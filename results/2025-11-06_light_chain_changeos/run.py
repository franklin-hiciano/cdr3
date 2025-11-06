import pandas as pd

df = pd.read_csv("/sc/arion/scratch/hiciaf01/projects/cdr3/data/2025-11-06_light_chain_changeos/changeo/master_changeo_2.deheader.tsv", sep='\t')

for chain in ["IGK", "IGL"]:
    chain_df = df[df["locus"] == chain]
    
    sequence_uniq = chain_df.drop_duplicates(subset=['sequence', "sample_id"])
    
    filtered_df = sequence_uniq[
        (sequence_uniq["v_identity"] == 100) & 
        (sequence_uniq["j_identity"] == 100) & 
        (sequence_uniq["productive"] == True)
    ]
    
    filtered_df.to_csv(chain + ".tsv", sep='\t', index=False)
