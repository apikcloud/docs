#!/bin/bash

if [ $# -lt 2 ]; then
    echo "Error: Two arguments are required."
    echo "Usage: $0 <input_file.md> <output_file.pdf>"
    exit 1
fi

INPUT_FILE="$1"
OUTPUT_FILE="$2"
HEADER_FILE="assets/header.tex"

pandoc --listings \                                                                                                                                    
    -H "$HEADER_FILE" \
    -V geometry:"left=2.5cm, top=2.5cm, right=2.5cm, bottom=2.5cm" \
    -V fontsize=11pt \
    -V mainfont="DejaVu Serif" \
    -V monofont="Fira Mono" \
    "$INPUT_FILE" \
    --from=gfm \
    --pdf-engine=xelatex \
    -o "$OUTPUT_FILE"    