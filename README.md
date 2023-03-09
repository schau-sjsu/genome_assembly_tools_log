# Analysis of the complementary capabilities of ribosomal assembly and machine learning tools for microbial identification of organisms with different characteristics

This repository contains a list of commands used to run experiments discussed in the paper *Analysis of the complementary capabilities of ribosomal assembly and machine learning tools for microbial identification of organisms with different characteristics*. 

Documentation for the command line tools are included in command.sh.



## Citation

On the synergies between ribosomal assembly and machine learning tools for microbial identification

Stephanie Chau, Carlos Rojas, Jorjeta G. Jetcheva, Sudha Vijayakumar, Sophia Yuan, Vincent Stowbunenko, Amanda N. Shelton, William B. Andreopoulos

bioRxiv 2022.09.30.510284; doi: https://doi.org/10.1101/2022.09.30.510284



## Data

All genomic data used to run the experiments can be found in this [Google Drive folder](https://drive.google.com/drive/folders/1lq3H0CXwFahBczYqZacRO6HOX-n3_nXH?usp=share_link). The folder includes the following data:

* Reference genomes and reads 
  * MBARC dataset
  * Hot Spring dataset
* DeLUCS commands
  * Modified source code files
  * Code notebook with commands used to run the tool
* DNABERT commands
  * Code notebook with commands used to run the tool
    * Additional commands that were run from the terminal are included in commands.sh



## Tools

The following is a list of tools discussed in the paper:

* Assembly tools
  * [phyloFlash](https://github.com/HRGV/phyloFlash)
  * [MetaSPAdes](https://github.com/ablab/spades)
  * [Megahit](https://github.com/voutcn/megahit)
* Analysis tools
  * [BBtools](https://jgi.doe.gov/data-and-tools/software-tools/bbtools/)
    * [bbmap](https://jgi.doe.gov/data-and-tools/software-tools/bbtools/bb-tools-user-guide/bbmap-guide/)
    * [bbsplit](https://jgi.doe.gov/data-and-tools/software-tools/bbtools/bb-tools-user-guide/bbmap-guide/)
    * [shred](https://jgi.doe.gov/data-and-tools/software-tools/bbtools/bb-tools-user-guide/bbmask-guide/)
    * [reformat](https://jgi.doe.gov/data-and-tools/software-tools/bbtools/bb-tools-user-guide/reformat-guide/)
    * [stats](https://jgi.doe.gov/data-and-tools/software-tools/bbtools/bb-tools-user-guide/statistics-guide/)
  * [BLAST](https://blast.ncbi.nlm.nih.gov/Blast.cgi)
  * [Barrnap](https://github.com/tseemann/barrnap)
  * [SPADE](https://github.com/yachielab/SPADE)
* Machine learning tools
  * [DNABERT](https://github.com/jerryji1993/DNABERT)
  * [DeLUCS](https://github.com/millanp95/DeLUCS/tree/master/src)



## Contact

For any questions, please contact:

William "Bill" Andreopoulos

william.andreopoulos@sjsu.edu
