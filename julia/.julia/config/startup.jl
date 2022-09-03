# Syntax highlighting and other enhancements for the Julia REPL with Monokai theme by default
using OhMyREPL
@async begin
    # reinstall keybindings to work around https://github.com/KristofferC/OhMyREPL.jl/issues/166
    sleep(1)
    OhMyREPL.Prompt.insert_keybindings()
end
colorscheme!("Monokai24bit")
using Revise
