It is now recommended to use the fully supported Illumina solution [DRAGEN Array](https://www.illumina.com/products/by-type/informatics-products/microarray-software/dragen-array.html) to convert IDAT to VCF files


`./main.sh -h`
```
A simple program to covert .idat files to plink format files.
Options:
-b     A path to .bpm manifest.
-s     A path to .csv manifest.
-c     A path to cluster .egt.
-i     A path idat files directory.
-o     A path to gtc output directory.
-g     A path to reference genome .fasta.
-p     A prefix for output file.
-h     Show this help and exit
```

In order to run the scripts, you have to have following files:
- Manifest file from your microarray experiment. This file can be found in Illumina website. For instance, [Infinium ASA Screening Array](https://support.illumina.com/array/array_kits/infinium-asian-global-screening-array/downloads.html). Download both .csv and .bpm
- Cluster file in format .egt from your microarray experiment. For instance, [Infinium ASA Screening Array](https://support.illumina.com/array/array_kits/infinium-asian-global-screening-array/downloads.html)
- Reference genome in .fasta format. The reference build version should follow your manifest and cluster files. [Which human reference genome to use](https://lh3.github.io/2017/11/13/which-human-reference-genome-to-use)

Also, you have to install these following programs and move the binaries to your $PATH:
- [IAAP Genotyping Command Line Interface (CLI)](https://support.illumina.com/downloads/iaap-genotyping-cli.html)
- [bcftools and gtc2vcf](https://github.com/freeseek/gtc2vcf)
- [PLINK](https://www.cog-genomics.org/plink/2.0/)
- [BeadArrayFiles](https://github.com/Illumina/BeadArrayFiles)




