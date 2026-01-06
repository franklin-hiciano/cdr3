import pandas as pd
import os
import argparse

RESULTS = "/sc/arion/work/hiciaf01/projects/cdr3/results/2025-11-06_light_chain_changeos/"

def process_changeo(args):
    df = pd.read_csv(args.changeo, sep='\t')
    print(df)
    df = df[df["locus"] == args.locus]
    print(df)
    df = df.drop_duplicates(subset=['sequence', "sample_id"])
    print(df)
    df = df[
        (df["v_identity"] >= args.v_identity) &
        (df["j_identity"] >= args.j_identity) &
        (df["productive"] == "T")
    ]
    print(df)
    df.to_csv(args.outfile, sep='\t', index=False)

def main():
    parser = argparse.ArgumentParser("A script that processes the changeo file.")
    parser.add_argument("--changeo", type=str, required=True, help="A file path.")
    parser.add_argument("--locus", type=str, required=True, help="IGK, IGH or IGL")
    parser.add_argument("--v_identity", type=int, required=True, help="An integer between 0 and 100 without the percent sign.")
    parser.add_argument("--j_identity", type=int, required=True, help="An integer between 0 and 100 without the percent sign.")
    parser.add_argument("--outfile", type=str, required=True, help="An output file path for the modified TSV.")

    args = parser.parse_args()

    process_changeo(args)

if __name__ == "__main__":
    main()



