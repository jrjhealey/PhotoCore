# Download all the available Photo genomes
$ python3 ~/repos/ncbi-genome-download/contrib/gimme_taxa.py -u -o Photo_taxa.txt -j 29487
$ ncbi-genome-download -v -s genbank --taxid Photo_taxa.txt bacteria

# Since many files were missing annotations, and using different annotation sources adds noise to results, everything was reannotated
# Files were converted with my own biopython script:
$ x2y.py -i seq.gbff -j genbank -o seq.fasta -p fasta

# Annotation script:
bash reannotate.sh Locustag species assembly.fasta > /dev/null 2>&1&




prokka1.11 \
--force \
--compliant\
--locustag CRCIA \
--genus Photorhabdus \
--species CRCIA-P01 \
--strain CRCIA-P01 \
--usegenus \
--gram neg \
--proteins ~/Sequences/Reference/Databases/all_genome_protein_features/all_photorhabdus_proteins \
--cpus 30 \
GCA_003545805.1_ASM354580v1_genomic.fasta

prokka1.11 --force \
--compliant \
--locustag NBAII \
--genus Photorhabdus \
--species luminescens \
--strain NBAII \
--usegenus \
--gram neg \
--proteins ~/Sequences/Reference/Databases/all_genome_protein_features/all_photorhabdus_proteins \
--cpus 30 \
GCA_000798635.2_ASM79863v2_genomic.fasta

prokka1.11 \
--force \
--compliant \
--locustag DSM \
--genus Photorhabdus \
--species asymbiotica \
--strain DSM \
--usegenus \
--gram neg \
--proteins ~/Sequences/Reference/Databases/all_genome_protein_features/all_photorhabdus_proteins \
--cpus 30 \
GCA_000711895.1_ASM71189v1_genomic.fasta

# Finally, Roary is run on all the sequences.
# Explanation of options: (p) 30 threads, (e) codon aware alignment (slow but accurate, with PRANK), (i) blast ID of 90%
# (cd) 94% of isolates must contain genes to be core (this is 36 out of 38 total genomes), (r) makes plots.
roary -p 30 -e -i 90 -cd 94 -r -v *.gff
