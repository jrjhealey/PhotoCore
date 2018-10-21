# Download all the available Photo genomes
$ python3 ~/repos/ncbi-genome-download/contrib/gimme_taxa.py -u -o Photo_taxa.txt -j 29487
$ ncbi-genome-download -v -s genbank --taxid Photo_taxa.txt bacteria

# *Discarded GCA_003287725.1_ASM328772v1_genomic as its seemingly the same as GCA_003287715.1_ASM328771v1_genomic (according to IQTree)

# Since many files were missing annotations, and using different annotation sources adds noise to results, everything was reannotated
# Files were converted with my own biopython script:
$ x2y.py -i seq.gbff -j genbank -o seq.fasta -p fasta

# Annotation script:
prokka1.11 --force --compliant \
           --genus Photorhabdus \
           --species "$2" \
            --usegenus --gram neg \
            --proteins ~/Sequences/Reference/Databases/all_genome_protein_features/all_photorhabdus_proteins \
            --cpus 32 \
            --strain "$1" --locustag "$1" \
            "$3"

$ bash reannotate.sh Locustag species assembly.fasta :-
       reannotate.sh PTNC19 temperata GCA_000517265.1_Photorhabdus_temperata_NC19_genomic.fasta 
       reannotate.sh PLBA1 luminescens GCA_000612035.1_P_lum_BA1_v1_genomic.fasta
       reannotate.sh PADSM asymbiotica GCA_000711895.1_ASM71189v1_genomic.fasta
       reannotate.sh PTMEG1 temperata GCA_000722995.1_Meg1v1_genomic.fasta
       reannotate.sh PLH75HRPL105 luminescens GCA_000826725.2_ASM82672v2_genomic.fasta 
       reannotate.sh PHVMG heterorhabditis GCA_001280945.1_ASM128094v1_genomic.fasta
       reannotate.sh PLS5P8 luminescens GCA_003287555.1_ASM328755v1_genomic.fasta
       reannotate.sh PLS1255 luminescens GCA_003287565.1_ASM328756v1_genomic.fasta
       reannotate.sh PCBOJ47 clarkei GCA_003287575.1_ASM328757v1_genomic.fasta
       reannotate.sh PLS1054 luminescens GCA_003287585.1_ASM328758v1_genomic.fasta
       reannotate.sh PLHUG39 luminescens GCA_003287635.1_ASM328763v1_genomic.fasta
       reannotate.sh PLS751 laumondii GCA_003287645.1_ASM328764v1_genomic.fasta
       reannotate.sh PLS1460 laumondii GCA_003287655.1_ASM328765v1_genomic.fasta
       reannotate.sh PLS1556 GCA_003287665.1_ASM328766v1_genomic.fasta
       reannotate.sh PLS1556 laumondii GCA_003287665.1_ASM328766v1_genomic.fasta
       reannotate.sh PLS953 laumondii GCA_003287715.1_ASM328771v1_genomic.fasta
       reannotate.sh PLS852 laumondii GCA_003287725.1_ASM328772v1_genomic.fasta
       reannotate.sh PBLJ2463 bodei GCA_003287735.1_ASM328773v1_genomic.fasta

# Also added all the existing reannotations we had made (Beau/43951/Hit/Jun etc)

# Finally, Roary is run on all the sequences.
# Explanation of options: (p) 30 threads, (e) codon aware alignment (slow but accurate, with PRANK), (i) blast ID of 90%
# (cd) 94% of isolates must contain genes to be core (this is 32 out of 34 total genomes), (r) makes plots.
roary -p 30 -e -i 90 -cd 94 -r -v master_gff3_store/*.gff |& tee -a output.log

# Core genome tree is generated from the resulting concatenated PRANK alignments:
iqtree -m gtr core_gene_sequences.aln
