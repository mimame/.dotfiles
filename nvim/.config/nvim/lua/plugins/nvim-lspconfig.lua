--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
})

local on_attach = function(client, bufnr)
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
end

local nvim_lsp = require('lspconfig')
local servers = {
  'r_language_server', 'ansiblels', 'bashls', 'cmake', 'crystalline', 'dockerls',
  'dotls', 'gopls', 'html', 'jsonls', 'jedi_language_server', 'pyright', 'vimls', 'yamlls'
}

for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

-- TODO: Fix E492: Not an editor command: require'lspconfig'["diagnosticls"].manager.try_add()
-- require('lspconfig').diagnosticls.setup{}
-- Neovim does not currently include built-in snippets
-- vscode-html-language-server only provides completions
-- when snippet support is enabled. To enable completion,
-- install a snippet plugin and add the following override
-- to your language client capabilities during setup.
require('lspconfig').julials.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  on_new_config = function(new_config, new_root_dir)
    server_path = '/home/paradise/.julia/packages/LanguageServer/JrIEf/src/LanguageServer.jl/src'
    cmd = {
      'julia',
      '--project=' .. server_path,
      '--startup-file=no',
      '--history-file=no',
      '-e',
      [[
      using Pkg
      Pkg.instantiate()
      using LanguageServer
      depot_path = get(ENV, "JULIA_DEPOT_PATH", "")
      project_path = let
      dirname(something(
      ## 1. Finds an explicitly set project (JULIA_PROJECT)
      Base.load_path_expand((
      p = get(ENV, "JULIA_PROJECT", nothing);
      p === nothing ? nothing : isempty(p) ? nothing : p
      )),
      ## 2. Look for a Project.toml file in the current working directory,
      ##    or parent directories, with $HOME as an upper boundary
      Base.current_project(),
      ## 3. First entry in the load path
      get(Base.load_path(), 1, nothing),
      ## 4. Fallback to default global environment,
      ##    this is more or less unreachable
      Base.load_path_expand("@v#.#"),
      ))
    end
    @info "Running language server" VERSION pwd() project_path depot_path
    server = LanguageServer.LanguageServerInstance(stdin, stdout, project_path, depot_path)
    server.runlinter = true
    run(server)
    ]],
    }
    new_config.cmd = cmd
  end,
})

require('lspconfig').texlab.setup({
  settings = {
    texlab = {
      auxDirectory = '.',
      bibtexFormatter = 'texlab',
      build = {
        args = { '--synctex', '--keep-logs', '--keep-intermediates', '%f' },
        executable = 'tectonic',
        forwardSearchAfter = false,
        onSave = true,
      },
      chktex = {
        onEdit = false,
        onOpenAndSave = true,
      },
      diagnosticsDelay = 300,
      formatterLineLength = 80,
      forwardSearch = {
        args = {},
      },
      latexFormatter = 'latexindent',
      latexindent = {
        modifyLineBreaks = false,
      },
    },
  },
})

-- set the path to the sumneko installation; if you previously installed via the now deprecated :LspInstall, use
local sumneko_root_path = '/usr/share/lua-language-server'
local sumneko_binary = '/usr/bin/lua-language-server'

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

require('lspconfig').sumneko_lua.setup({
  cmd = { sumneko_binary, '-E', sumneko_root_path .. '/main.lua' },
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file('', true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
})
