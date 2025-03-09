function pdfc
    if test -z "$argv"
        echo "Usage: pdfc file.pdf ... fileN.pdf [resolution_in_dpi]"
        return 1
    end

    set -l resolution 90
    set -l pdfs $argv

    if string match --quiet --regex '^\d+$' "$argv[-1]"
        set resolution $argv[-1]
        set pdfs $argv[1..-2]
    end

    for pdf in $pdfs
        if not test -f "$pdf"
            echo "Error: File '$pdf' not found." >&2
            continue
        end

        set -l original_pdf (string replace -r '\.pdf$' '_original.pdf' "$pdf")

        mv "$pdf" "$original_pdf"

        gs \
            -q -dNOPAUSE -dBATCH -dSAFER \
            -sDEVICE=pdfwrite \
            -dCompatibilityLevel=1.3 \
            -dPDFSETTINGS=/screen \
            -dEmbedAllFonts=true \
            -dSubsetFonts=true \
            -dAutoRotatePages=/None \
            -dColorImageDownsampleType=/Bicubic \
            -dColorImageResolution="$resolution" \
            -dGrayImageDownsampleType=/Bicubic \
            -dGrayImageResolution="$resolution" \
            -dMonoImageDownsampleType=/Subsample \
            -dMonoImageResolution="$resolution" \
            -sOutputFile="$pdf" \
            "$original_pdf"

        if test $status -eq 0
            set -l human_pdf_size (du -h "$pdf" | cut -f1)
            set -l human_original_pdf_size (du -h "$original_pdf" | cut -f1)
            set -l pdf_size (stat -c '%s' "$pdf")
            set -l original_pdf_size (stat -c '%s' "$original_pdf")

            if test "$original_pdf_size" -le "$pdf_size"
                echo "'$pdf' could not be compressed (result larger or same size)." >&2
                mv "$original_pdf" "$pdf"
            else
                set -l compression_ratio (printf "%.2f" (math "$original_pdf_size / $pdf_size"))
                echo "$pdf"
                echo "Original size: $human_original_pdf_size"
                echo "Compressed size: $human_pdf_size"
                echo "Compression ratio: $compression_ratio"
                # rm "$original_pdf" # Don't remove the original even successfully compressed.
            end
        else
            echo "Error: '$pdf' could not be processed by Ghostscript." >&2
            mv "$original_pdf" "$pdf" #restore original if gs failed.
        end
    end
end
