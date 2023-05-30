import sys

# Function to read BED file
def read_bed_file(file_name):
    with open(file_name) as f:
        bed_data = [line.strip().split("\t") for line in f if not line.startswith("#")]
    return bed_data

# Function to calculate positions of interest
def process_bed_data(bed_data):
    tss_positions = []
    tss_minus_1_positions = []
    tes_positions = []
    tes_plus_1_positions = []

    for entry in bed_data:
        chrom, start, end, name, score, strand = entry
        start = int(start)
        end = int(end)

        if strand == "+":
            tss_positions.append((chrom, start, name, score, strand))
            tss_minus_1_positions.append((chrom, start - 1, name, score, strand))
            tes_positions.append((chrom,end - 1,name,score,strand))
            tes_plus_1_positions.append((chrom,end,name,score,strand))
        else:
            tss_positions.append((chrom,end - 1,name,score,strand))
            tss_minus_1_positions.append((chrom,end,name,score,strand))
            tes_positions.append((chrom,start,name,score,strand))
            tes_plus_1_positions.append((chrom,start - 1,name,score,strand))

    return tss_positions,tss_minus_1_positions ,tes_positions ,tes_plus_1_positions 

# Function to write output BED files
def write_bed_file(output_file_name ,positions_list ):
    with open(output_file_name,'w') as outfile:
        for pos in positions_list :
            chrom,pos ,name,score ,strand=pos 
            outfile.write("{chrom}\t{pos}\t{pos_plus_1}\t{name}\t{score}\t{strand}\n".format(chrom=chrom, pos=pos, pos_plus_1=pos+1, name=name, score=score, strand=strand))

# Main function
def main():
    input_bed_file = sys.argv[1]
    bed_data=read_bed_file(input_bed_file)
    tss,tss_minus_1,tes,tes_plus_1=process_bed_data(bed_data)

    write_bed_file("TSS.bed",tss)
    write_bed_file("TSS-1.bed",tss_minus_1)
    write_bed_file("TES.bed",tes)
    write_bed_file("TES+1.bed",tes_plus_1)

# Run the main function with your input BED file
if __name__ == "__main__":
    main()
