# quality control
fastqc 293FT_pp.fq.gz 293FT_pm.fq.gz 293FT_rm.R1.fq.gz 293FT_rm.R2.fq.gz 293FT_rr.fq.gz
trimmomatic-0.35.jar PE -threads 3 293FT_rm.R1.fq.gz 293FT_rm.R2.fq.gz 293FT_rm.R1.trimmed.fq.gz 293FT_rm.R1.unpaired.fq.gz 293FT_rm.R2.trimmed.fq.gz 293FT_rm.R2.unpaired.fq.gz TruSeq3-PE-2.fa:2:30:10:8:true LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:30
mv 293FT_rm.R1.trimmed.fq.gz 293FT_rm.R1.fq.gz
mv 293FT_rm.R2.trimmed.fq.gz 293FT_rm.R2.fq.gz

# build index
bowtie-build hg38.fa hg38
bowtie2-build hg38.fa hg38
hisat2-build hg38.fa hg38

# align by hisat2 and format the result
hisat2 --no-softclip --score-min L,-16,0 --mp 7,7 --rfg 0,7 --rdg 0,7 --dta -k 1 --max-seeds 20 -p 20 -x hg38 --known-splicesite-infile hg38_gencode_sp.txt -U 293FT_pm.fq.gz -S 293FT_pm.sam &>! 293FT_pm_hisat2.log
samtools view -Sb -f 4 293FT_pm.sam > 293FT_pm_unmapped.bam
bamToFastq -i 293FT_pm_unmapped.bam -fq 293FT_pm_unmapped.fq
samtools view -Sb -F 4 293FT_pm.sam > 293FT_pm_mapped.bam
samtools sort 293FT_pm_mapped.bam 293FT_pm_sorted
samtools index 293FT_pm_sorted.bam

# aligh by TopHat-Fusion and parse fusion reads
tophat2 -o 293FT_pm_fusion -p 20 --fusion-search --keep-fasta-order --bowtie1 --no-coverage-search hg38 293FT_pm_unmapped.fq &> 293FT_pm_fusion.log
mkdir 293FT_pm_circ
CIRCexplorer2 parse -f -t TopHat-Fusion 293FT_pm_fusion/accepted_hits.bam -b 293FT_pm_circ/bsj.bed &>! 293FT_pm_parse.log

# annotate circular RNAs
CIRCexplorer2 annotate -r hg38_gencode_merged.txt -g hg38.fa -b 293FT_pm_circ/bsj.bed -o 293FT_pm_circ/circularRNA.txt &>! 293FT_pm_annotate.log
