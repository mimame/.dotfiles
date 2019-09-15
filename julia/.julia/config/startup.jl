# Syntax highlighting and other enhancements for the Julia REPL with Monokai theme by default
using OhMyREPL
colorscheme!("Monokai24bit")
# Load Debugger with Monokai theme by default
using Highlights
using Debugger
Debugger.set_theme(Highlights.Themes.MonokaiTheme)
# Automatically update function definitions in a running Julia session
# Use includet() instead include() to track the files
atreplinit() do repl
    try
        @eval using Revise
        @async Revise.wait_steal_repl_backend()
    catch
    end
end
