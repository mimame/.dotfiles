function pdfc --description "Compress PDF files using Ghostscript"
    if test -z "$argv"
        echo "Usage: pdfc <file.pdf...> [resolution_in_dpi]"
        echo "Default resolution: 90 DPI"
        return 1
    end

    if not command -q gs
        echo "Error: Ghostscript (gs) is not installed." >&2
        return 1
    end

    set -l resolution 90
    set -l pdfs $argv

    # Check if last argument is a resolution (numeric)
    if string match -qr '^\d+$' -- "$argv[-1]"
        set resolution $argv[-1]
        set pdfs $argv[1..-2]
    end

    for pdf in $pdfs
        if not test -f "$pdf"
            echo "Error: File '$pdf' not found." >&2
            continue
        end

        set -l tmp_pdf (mktemp).pdf
        echo "📄 Compressing: $pdf (Resolution: $resolution DPI)"

        # Ghostscript settings:
        # -dPDFSETTINGS=/screen: Predefined low-resolution (72 dpi) output
        # -dCompatibilityLevel=1.4: Set PDF version
        # -dColorImageResolution: Set DPI for images
        gs \
            -q -dNOPAUSE -dBATCH -dSAFER \
            -sDEVICE=pdfwrite \
            -dCompatibilityLevel=1.4 \
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
            -sOutputFile="$tmp_pdf" \
            "$pdf"

        if test $status -eq 0
            # Portable byte size calculation
            set -l original_size 0
            set -l compressed_size 0
            if test (uname) = Darwin
                set original_size (stat -f %z "$pdf")
                set compressed_size (stat -f %z "$tmp_pdf")
            else
                set original_size (stat -c %s "$pdf")
                set compressed_size (stat -c %s "$tmp_pdf")
            end

            if test "$compressed_size" -lt "$original_size"
                set -l original_name (string replace -r '\.pdf$' '_original.pdf' "$pdf")
                mv "$pdf" "$original_name"
                mv "$tmp_pdf" "$pdf"

                set -l ratio (printf "%.2f" (math "$original_size / $compressed_size"))

                echo "✅ Successfully compressed: $pdf"
                echo "   Original:   $(du -h "$original_name" | cut -f1)"
                echo "   Compressed: $(du -h "$pdf" | cut -f1)"
                echo "   Ratio:      $ratio"
                echo "   Keep:       $original_name"
            else
                echo "⚠️  Skipped: Compression resulted in a larger file ($pdf)"
                rm "$tmp_pdf"
            end
        else
            echo "❌ Error: Failed to process '$pdf' with Ghostscript" >&2
            rm -f "$tmp_pdf"
        end
        echo ""
    end
end
