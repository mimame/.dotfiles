function pdfc
    if test -z "$argv"
        echo "Usage: file.pdf ... fileN.pdf [resolution_in_dpi]"
        return 1
    end

    if string match --quiet --regex '\d' "$argv[-1]"
        set resolution "$argv[-1]"
        set pdfs $argv[1..-2]
    else
        set resolution 90
        set pdfs $argv
    end

    for pdf in $pdfs

        set original_pdf "$(string split --max 1 --field 1 "." "$pdf")_original.pdf"

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
            set pdf_size (wc -c "$pdf" | cut -f1 -d' ' )
            set original_pdf_size (wc -c "$original_pdf" | cut -f1 -d' ')
            if test "$original_pdf_size" -le "$pdf_size"
                echo "'$pdf' can't be compressed!" 2>&1
                mv "$original_pdf" "$pdf"
            else
                set compression_ration (awk "BEGIN{printf \"%0.2f\", $original_pdf_size/$pdf_size}")
                echo "$pdf"
                echo "Compression ration: $compression_ration"
                echo "Final size: $(du -h $pdf | cut -f1)"
            end
        else
            echo "'$pdf' can't be processed!" 2>&1
        end
    end
end
