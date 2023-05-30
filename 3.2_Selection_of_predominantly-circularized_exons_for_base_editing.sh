# editing information analysis

# below command will output 3bss.bed 3bss2th.bed 5bss.bed 5bss2th.bed
# in the 293FT_pm_circ folder
python extract_bss.py 293FT_pm_circ/circ_predom.txt

python extract_sequences.py hg38.fa 293FT_pm_circ/3bss.bed 293FT_pm_circ/3bss.seq
python extract_sequences.py hg38.fa 293FT_pm_circ/3bss2th.bed 293FT_pm_circ/3bss2th.seq

python BEable_Cas9_CtoT.py 293FT_pm_circ/3bss.seq NGG 20 3 8 > 293FT_pm_circ/3bss_hA3A_Y130F.txt
python BEable_Cas9_CtoT.py 293FT_pm_circ/3bss2th.seq NGG 20 3 8 > 293FT_pm_circ/3bss2th_hA3A_Y130F.txt
