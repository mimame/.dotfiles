# Display PATH entries as a structured table with existence checks
#
# Usage:
#   paths                 # Show all PATH entries
#   paths | where exists  # Show only existing paths
#   paths | where not exists # Show broken paths
def paths [] {
    $env.PATH
    | split row (char esep)
    | wrap path
    | reverse
    | insert exists { |row| $row.path | path exists }
    | upsert type { |row|
        if not ($row.path | path exists) {
            "missing"
        } else {
            $row.path | path type
        }
    }
}
