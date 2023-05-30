import sys
import pybedtools

def extract_sequence(feature, fasta):
    sequence = fasta.sequence(fi=feature).seq.upper()
    if feature.strand == '-':
        sequence = sequence.reverse_complement()
    return sequence

def extract_sequences_from_bed_file(fasta_file, positions_file, output_file):
    fasta = pybedtools.BedTool(fasta_file)
    positions = pybedtools.BedTool(positions_file)

    output_data = []

    for position in positions:
        start_position = position.start - 30
        end_position = position.end + 30

        region = pybedtools.create_interval_from_list(
            [
                position.chrom,
                str(start_position),
                str(end_position),
                position.name,
                position.score,
                position.strand,
            ]
        )

        extracted_sequence = extract_sequence(region, fasta)
        output_data.append((position.name, extracted_sequence))

    with open(output_file, 'w') as outfile:
        for data in output_data:
            outfile.write("{0}\n{1}\n".format(data[0], data[1]))

if __name__ == '__main__':
    if len(sys.argv) < 4:
        print "Usage: python extract_sequences.py <fasta_file> <positions_file.bed> <output_sequences.txt>"
        sys.exit(1)

    fasta_file = sys.argv[1]
    positions_file = sys.argv[2]
    output_file = sys.argv[3]

    extract_sequences_from_bed_file(fasta_file, positions_file, output_file)
