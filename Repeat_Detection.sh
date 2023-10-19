#!/usr/bin/bash
#SBATCH -V
#SBATCH -o Repeats_detection.out
#SBATCH -e Repeats_detection.err
#SBATCH -J Repeats_detection
#SBATCH --time=96:00:00
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=10G
#SBATCH --tasks-per-node=4
#SBATCH --nodes=1

#==================#
# Import Module
#==================#
module load bioinfo/RepeatMasker-4.1.0
module load bioinfo/WuBlast2.0
module load bioinfo/RMBlast-2.10.0
module load bioinfo/RepeatModeler-2.0.1
module load system/Python-3.6.3

#==================#
# Infos
#==================#

# This script was created to run RepeatMasker on Genotoul cluster in 3 step
# Long runs expected, you might prefer to dispatch the three steps in three different scripts and launch them separatly
# the pipeline is decomposed as follow :
# 		- Detect repeat in your genome by using the public "RM" database : specify the gender, species or other rank
#		- Create a DeNOVO database from a subset of your genome (or the whole genome if not too big)
# 		- Re-run the Repeat detection on the genome masked in step 1, bu with the new custom database

#==================#
# Load Directories
#==================#

# Absolute Path of your reference genome to mask
Genome_file="/YourPATH/your_genome.fasta"

# Create output directories for the different runs of Repeat Masker

# Create directory for run 1 on RM_database
mkdir "/YourPATH/RM_1"
RM1_output_dir="/YourPATH/RM_1/"
RMl_masked_fasta="/YourPATH/RM_1/syour_genome.fasta.masked"

# Create directory for run 2 on de novo database
mkdir "/YourPATH/RM_2"
RM2_output_dir="/YourPATH/RM_2/"

# Create directory for RepeatModeler
DB_name="My_Genome_Db"
RefForDB_fasta="My_Genome_Subset.fasta"
Lib_De_Novo="/yourPATH/${DB_name}/${DB_name}-families.fa" # File with extension -families.fa created by R_Modeler

#================================================#
# Run 1 Repeat Masker
#================================================#
# INFOS :
#---------#

# RUN 1 
#---------#
# Choose the 'species' argument to compare with
# To check the possible 'species' in genotoul, run (with your own arg in 'species') the perl script "queryTaxonomyDatabase.pl" :
/usr/local/bioinfo/src/RepeatMasker/RepeatMasker-4.1.0/util/queryTaxonomyDatabase.pl -species "Chondrichthyes"

# Run repeat Masker 1
RepeatMasker -species Chondrichthyes -pa 8 -dir ${RM1_output_dir} ${Genome_file}

#=====================================#
# Run Repeat Modeler
#=====================================#

BuildDatabase -name ${DB_name} ${RefForDB_fasta}
nohup RepeatModeler -database ${DB_name}

#==================================================================#
# Run 2 Repeat Masker
#==================================================================#

# No 'species' arg, but -lib specifiy the denovo repeat database 
RepeatMasker -lib ${Lib_De_Novo} -pa 8 -dir ${RM2_output_dir} ${Genome_file}
