# metamate-utilities

The following tools and worksteps reflect one possible way to preprocess metabarcoding datasets.

## Installation of working environment and Utilities for quality control and preprocessing of metabarcoding data
To avoid dependency issues and for easier management of the tools we used miniconda with a new environment.

The conda environment was created as follows:

```
conda create --name metamate_env python=3.10
conda init fish # other shells, such as bash or zsh, can also be used
conda activate metamate_env
```

Now, within the newly created metamate_env, the installation of these tools can be done using the **installation_utils.sh** bash script. 
- fastqc 
- fastx_trimmer
- fastq-pair
- trimmomatic
- Samtools pairtosam 
- vsearch


To run the error correction with deblur instead of unoise3 we used
```
conda create -n deblur_env -c bioconda deblur
conda activate deblur_env
```


## Execution of data preprocessing pipeline
To execute the **run_processing.sh** script the binary of usearch needs to be downloaded first (due to licencing issues not included in this git repo)
After running the script follow the steps described on the metamate github repo.


## Using LotuS2
Install lotus2 with
```
conda create -c conda-forge -c bioconda --strict-channel-priority -n lotus2_env lotus2
lotus2 -link_usearch >path_to_usearch<
```


## Prepare Reference Database
In this example we want to create a reference database using the BOLD COI Arthropod dataset.
For this, the qiime plugin RESCRIPt will be used. If there are errors popping up after installation reinstall numpy and h5py
```
conda install -c conda-forge -c bioconda -c qiime2 -c https://packages.qiime2.org/qiime2/2023.5/tested/-c defaults conda activate qiime2-amplicon-2023.9
conda activate qiime2-amplicon-2023.9
mamba install -c conda-forge -c bioconda -c qiime2 -c https://packages.qiime2.org/qiime2/2023.5/tested/ -c defaults qiime2 q2cli q2templates q2-types q2-longitudinal q2-feature-classifier 'q2-types-genomics>2023.2' "pandas>=0.25.3" xmltodict ncbi-datasets-pylib

pip install git+https://github.com/bokulich-lab/RESCRIPt.git

conda install r-taxize
```

First download the bold_datapull_byGroup.R that is provided by the author of RESCRIPt.
Install the dependencies in R
```
library(bold)
library(dplyr)
```

## Change Log
v1 
