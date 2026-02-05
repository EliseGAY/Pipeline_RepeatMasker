# Run RepeatMasker

## Aim
------

This script was created to detect repeat regions and generate a BED file of repeat regions in a genome.  
Long runtimes are expected; you may prefer to split the pipeline into three separate scripts and launch them independently.

## Input
------

- **Genome_file**: Genome in FASTA format  
- **My_Genome_Subset.fasta**: The first scaffolds/chromosomes of the genome used to build the *de novo* repeat database.  
  There is no need to run RepeatModeler on the entire genome to generate the repeat database.

## Methods
----------

RepeatMasker and RepeatModeler are used.  
The pipeline is decomposed as follows:

- Detect repeats in your genome using the public **RepeatMasker (RM)** database.  
  Specify the genus, species, or another taxonomic rank.  
  Choose the `-species` argument to match the output of the `queryTaxonomyDatabase.pl` script.

  Example of taxonomy search output with `Species = Chondrichthyes`:
			
			#	 RepeatMasker Taxonomy Database Utility
			#	 ======================================
			#	 Species = Chondrichthyes
			#	 Lineage = Chondrichthyes
			#			   Gnathostomata vertebrate
			#			   Vertebrata Metazoa
			#			   Craniata chordata
			#			   Chordata
			#			   Deuterostomia
			#			   Bilateria
			#			   Eumetazoa
			#			   Metazoa
			#			   Opisthokonta
			#			   Eukaryota
			#			   cellular organisms
			#			   root
			
- Create a *de novo* repeat database from a subset of your genome (or the whole genome if it is not too large) using **RepeatModeler**.

- Re-run RepeatMasker on the genome masked in step 1, but this time using the newly generated custom repeat database.

## Output
----------

- **MyGenome.fasta.cat.gz**: Zipped reference genome  
- **MyGenome.fasta.masked**: Reference genome with repeats replaced by `N`  
- **MyGenome.fasta.out**: Detailed repeat annotations (class, position, alignment statistics).  
Use columns **5, 6, and 7** to generate a BED file of repeats in your genome  
(the BED file is required to mask SNPs in a VCF file).

### Example of `*.out` file format


