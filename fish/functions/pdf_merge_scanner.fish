function pdf_merge_scanner --description "Merge scanner odds/evens PDF files (reversing evens)"
    # Description:
    #   This command is for the typical case where you have to scan a double-sided
    #   document but the scanner can only scan one side. You scan the front (odds),
    #   then flip the stack and scan the back (evens).
    #
    #   Since scanning the back of the stack results in the pages being in reverse
    #   order, this script automatically reverses the second PDF and shuffles it
    #   with the first one.
    #
    #   IMPORTANT: The user DOES NOT need to manually reverse the even-page PDF;
    #   pdftk handles this automatically via the 'Bend-1' argument.
    #
    # Arguments:
    #   odds_file:  The PDF file with odd pages (1, 3, 5...)
    #   evens_file: The PDF file with even pages (reversed order: n, n-2, ... 2)
    #   output:     The filename for the merged result.
    #
    # Usage:
    #   pdf_merge_scanner <odds.pdf> <evens.pdf> <output.pdf>

    if test (count $argv) -ne 3
        echo "Usage: pdf_merge_scanner <odds_file> <evens_file> <output_file>"
        echo "Example: pdf_merge_scanner scan_odds.pdf scan_evens.pdf final_doc.pdf"
        return 1
    end

    set -l odds_file $argv[1]
    set -l evens_file $argv[2]
    set -l output_file $argv[3]

    if not command -q pdftk
        echo "Error: 'pdftk' is not installed." >&2
        return 1
    end

    if not test -f "$odds_file"
        echo "Error: Odds file '$odds_file' not found." >&2
        return 1
    end

    if not test -f "$evens_file"
        echo "Error: Evens file '$evens_file' not found." >&2
        return 1
    end

    echo "📄 Merging scanner files..."
    echo "   Odds:  $odds_file (A)"
    echo "   Evens: $evens_file (B) -> Reversing order"
    echo "   Dest:  $output_file"

    # A=odds, B=evens
    # shuffle A Bend-1: Take from A (normal), take from B (end to 1, reversed)
    pdftk A="$odds_file" B="$evens_file" shuffle A Bend-1 output "$output_file"

    if test $status -eq 0
        echo "✅ Successfully created '$output_file'"
    else
        echo "❌ Merge failed." >&2
        return 1
    end
end
