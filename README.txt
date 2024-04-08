#======================#
# 10/2023
# Elise GAY
# Run Repeat Masker
# please inform the authors before sharing
#======================#

# Aim : 
#------#

This script was created to detect repeat region and get a bed file of repeat region in a genome
Long runs expected, you might prefer to dispatch the three steps in three different scripts and launch them separatly

# Input
#------#
Genome_file : Genome in fasta format
My_Genome_Subset.fasta : The first scaffolds/chr of the genome to build the de novo database of repeat elements. No need to run on the entire genome to get the repeat database

# Methods :
#----------#

RepeatMasker and RepeatModeller 
The pipeline is decomposed as follow :
 		- Detect repeat in your genome by using the public "RM" database : specify the gender, species or other rank
			Choose the 'species' argument to compare with queryTaxonomyDatabase.pl script
			Example of output of taxonomy search with 'Species = Chondrichthyes'
			
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
			
		- Create a DeNOVO database from a subset of your genome (or the whole genome if not too big) with RepeatModeler
 		- Re-run the RepeatMasker detection on the genome masked in step 1, bu with the new custom database

# Output
#----------#

# MyGenome.fasta.cat.gz # zipped reference genome
# MyGenome.fasta.masked # Reference genome with repeats replaced by 'N'
# MyGenome.fasta.out # detailed repeats class, position, alignment statistics. Use columns 5,6,7 to get BED file of repeats in your genome (bed file is needed to mask SNP in vcf file)

'''
   SW   perc perc perc  query     position in query                 matching           repeat                position in repeat
score   div. del. ins.  sequence  begin     end            (left)   repeat             class/family      begin  end    (left)        ID

 9062   20.6  0.3  0.2  SUPER_1           1     44730 (274063215) + GA-rich            Low_complexity         1  44786      (0)       1
  563   27.6  5.1  4.8  SUPER_1       44737     46167 (274061778) + rnd-5_family-589   Simple_repeat          1   1435      (0)       2
 8272   15.0  1.8  1.9  SUPER_1       46758     48309 (274059636) + rnd-4_family-205   LINE/CR1            2254   3804    (425)       3
 1386   21.9  2.2  7.0  SUPER_1       48328     48744 (274059201) + rnd-4_family-85    LINE/CR1-Zenon        33    430   (4497)       4 *
 2673   17.7  7.9  5.4  SUPER_1       48467     49148 (274058797) C rnd-4_family-351   Unknown              (0)    703        6       5
  814   20.1  2.1  2.6  SUPER_1       49088     49281 (274058664) + rnd-4_family-85    LINE/CR1-Zenon       818   1010   (3917)       4 *
   25    9.8  0.0  4.3  SUPER_1       50047     50094 (274057851) + (TGTGAT)n          Simple_repeat          1     46      (0)       6
'''
