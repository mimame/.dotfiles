local lsp = require('feline.providers.lsp')
local vi_mode_utils = require('feline.providers.vi_mode')

local api = vim.api

local components = {
  active = {},
  inactive = {},
}

table.insert(components.active, {})
table.insert(components.active, {})

components.active[1] = {
  {
    provider = '▊ ',
    hl = {
      fg = 'skyblue',
    },
  },
  {
    provider = 'vi_mode',
    hl = function()
      return {
        name = vi_mode_utils.get_mode_highlight_name(),
        fg = vi_mode_utils.get_mode_color(),
        style = 'bold',
      }
    end,
    right_sep = ' ',
  },
  {
    provider = 'file_info',
    type = 'relative',
    hl = {
      fg = 'white',
      bg = 'oceanblue',
      style = 'bold',
    },
    left_sep = {
      ' ',
      'slant_left_2',
      { str = ' ', hl = { bg = 'oceanblue', fg = 'NONE' } },
    },
    right_sep = { 'slant_right_2', ' ' },
  },
  {
    provider = 'file_size',
    right_sep = {
      ' ',
      {
        str = 'slant_left_2_thin',
        hl = {
          fg = 'fg',
          bg = 'bg',
        },
      },
    },
  },
  {
    provider = 'position',
    left_sep = ' ',
    right_sep = {
      ' ',
      {
        str = 'slant_right_2_thin',
        hl = {
          fg = 'fg',
          bg = 'bg',
        },
      },
    },
  },
  {
    provider = 'diagnostic_errors',
    enabled = function(winid)
      return lsp.diagnostics_exist('Error', api.nvim_win_get_buf(winid))
    end,
    hl = { fg = 'red' },
  },
  {
    provider = 'diagnostic_warnings',
    enabled = function(winid)
      return lsp.diagnostics_exist('Warning', api.nvim_win_get_buf(winid))
    end,
    hl = { fg = 'yellow' },
  },
  {
    provider = 'diagnostic_hints',
    enabled = function(winid)
      return lsp.diagnostics_exist('Hint', api.nvim_win_get_buf(winid))
    end,
    hl = { fg = 'cyan' },
  },
  {
    provider = 'diagnostic_info',
    enabled = function(winid)
      return lsp.diagnostics_exist('Information', api.nvim_win_get_buf(winid))
    end,
    hl = { fg = 'skyblue' },
  },
}
local function file_osinfo()
  local os = vim.bo.fileformat:upper()
  local icons = {
    linux = ' ',
    macos = ' ',
    windows = ' ',
  }
  local icon
  if os == 'UNIX' then
    icon = icons.linux
  elseif os == 'MAC' then
    icon = icons.macos
  else
    icon = icons.windows
  end
  return icon .. os
end

components.active[2] = {
  {
    provider = 'file_type',
    right_sep = ' ',
  },
  {
    provider = 'file_encoding',
    right_sep = ' ',
  },
  {
    provider = file_osinfo,
    right_sep = ' ',
  },
  {
    provider = 'git_branch',
    hl = {
      fg = 'white',
      bg = 'black',
      style = 'bold',
    },
    right_sep = {
      str = ' ',
      hl = {
        fg = 'NONE',
        bg = 'black',
      },
    },
  },
  {
    provider = 'git_diff_added',
    hl = {
      fg = 'green',
      bg = 'black',
    },
  },
  {
    provider = 'git_diff_changed',
    hl = {
      fg = 'orange',
      bg = 'black',
    },
  },
  {
    provider = 'git_diff_removed',
    hl = {
      fg = 'red',
      bg = 'black',
    },
    right_sep = {
      str = ' ',
      hl = {
        fg = 'NONE',
        bg = 'black',
      },
    },
  },
  {
    provider = 'line_percentage',
    hl = {
      style = 'bold',
    },
    left_sep = '  ',
    right_sep = ' ',
  },
  {
    provider = 'scroll_bar',
    hl = {
      fg = 'skyblue',
      style = 'bold',
    },
  },
}

components.inactive[1] = {
  {
    provider = 'file_type',
    hl = {
      fg = 'white',
      bg = 'oceanblue',
      style = 'bold',
    },
    left_sep = {
      str = ' ',
      hl = {
        fg = 'NONE',
        bg = 'oceanblue',
      },
    },
    right_sep = {
      {
        str = ' ',
        hl = {
          fg = 'NONE',
          bg = 'oceanblue',
        },
      },
      'slant_right',
    },
  },
}

require('feline').setup({
  components = components,
})
