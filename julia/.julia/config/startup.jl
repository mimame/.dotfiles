# Syntax highlighting and other enhancements for the Julia REPL
using OhMyREPL
# Automatically update function definitions in a running Julia session
# Use includet() instead include() to track the files
atreplinit() do repl
    try
        @eval using Revise
        @async Revise.wait_steal_repl_backend()
    catch
    end
end
