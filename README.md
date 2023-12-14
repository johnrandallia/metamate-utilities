# metamate-utilities

The following tools and worksteps reflect one possible way to preprocess metabarcoding datasets.

## Installation of Utilities that are used for quality controll and preprocessing of metabarcoding data
To avoid dependency issues and for easier management of the tools we used miniconda with a new environment.

The conda environment was created as follows:

```
conda create --name metamate_env
conda init fish # other shells, such as bash or zsh, can also be used
conda activate metamate_env
```

Now, within the newly created metamate_env, the installation of these tools can be done using the **installation_utils.sh** bash script. 
- fastqc 
- fastx_trimmer
- trimmomatic
- Samtools pairtosam 
- vsearch


## Change Log
v1 
