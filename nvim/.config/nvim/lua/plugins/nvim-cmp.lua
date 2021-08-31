local cmp = require('cmp')

require('nvim-autopairs.completion.cmp').setup({
  map_cr = true, --  map <CR> on insert mode
  map_complete = true, -- it will auto insert `(` after select function or method item
  auto_select = true, -- automatically select the first item
})

local lspkind = require('lspkind')

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

cmp.setup({
  formatting = {
    format = function(entry, vim_item)
      vim_item.kind = lspkind.presets.default[vim_item.kind]
      return vim_item
    end,
  },
})

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col('.') - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

cmp.setup({
  snippet = {
    expand = function(args)
      -- You must install `vim-vsnip` if you use the following as-is.
      vim.fn['vsnip#anonymous'](args.body)
    end,
  },

  -- You must set mapping if you want.
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    }),
    ['<tab>'] = cmp.mapping(function(fallback)
      if vim.fn.pumvisible() == 1 then
        vim.fn.feedkeys(t('<C-n>'), 'n')
        -- elseif vim.fn['vsnip#jumpable'](1)  then
      elseif vim.fn['vsnip#available']() == 1 then
        vim.fn.feedkeys(t('<Plug>(vsnip-expand-or-jump)'), '')
      elseif check_back_space() then
        vim.fn.feedkeys(t('<tab>'), 'n')
      else
        fallback()
      end
    end, {
      'i',
      's',
    }),
    ['<S-tab>'] = cmp.mapping(function(fallback)
      if vim.fn.pumvisible() == 1 then
        vim.fn.feedkeys(t('<C-p>'), 'n')
      elseif vim.fn['vsnip#jumpable'](-1) then
        vim.fn.feedkeys(t('<Plug>(vsnip-jump-prev)'), '')
      else
        fallback()
      end
    end, {
      'i',
      's',
    }),
  },
  -- You should specify your *installed* sources.
  sources = {
    { name = 'buffer' },
    { name = 'nvim_lua' },
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'vsnip' },
    -- { name = 'tmux' }
  },
})
