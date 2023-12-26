# metamate-utilities

The following tools and worksteps reflect one possible way to preprocess metabarcoding datasets.

## Installation of working environment and Utilities for quality control and preprocessing of metabarcoding data
To avoid dependency issues and for easier management of the tools we used miniconda with a new environment.

The conda environment was created as follows:

```
conda create --name metamate_env
conda init fish # other shells, such as bash or zsh, can also be used
conda activate metamate_env python=3.10
```

Now, within the newly created metamate_env, the installation of these tools can be done using the **installation_utils.sh** bash script. 
- fastqc 
- fastx_trimmer
- fastq-pair
- trimmomatic
- Samtools pairtosam 
- vsearch


## Execution of data preprocessing pipeline
To execute the **run_processing.sh** script the binary of usearch needs to be downloaded first (due to licencing issues not included in this git repo)
After running the script follow the steps described on the metamate github repo.


## Change Log
v1 
