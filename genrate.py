#!/home/adimascf/miniconda3/bin/python

from IlluminaBeadArrayFiles import GenotypeCalls
import os
import argparse


def run(gtc_dir):
    
    fnames = []
    results = []
    files = os.listdir(gtc_dir)
    for file in files:
        gtc_path = gtc_dir + "/" + file
        call_rate = GenotypeCalls(gtc_path).get_call_rate()
        file = file.split("/")
        name = file[-1].split("_")[0]
        fnames.append(name)
        results.append(call_rate)
    return fnames, results


def main():
    parser = argparse.ArgumentParser(
        description="Calculate genotype rate of gtc file"
    )
    parser.add_argument(
        "-g,",
        help="Path to .gtc file(s) directory (required)",
        metavar="--genodir",
        dest="genodir",
        type=str,
        required=True,
    )
    args = parser.parse_args()
    names, genrate = run(args.genodir)
    for n, r in zip(names, genrate):
        print(n + "\t" + str(r))


if __name__ == "__main__":
    main()
