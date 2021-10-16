-- The vim.api.nvim_set_keymap() function allows you to define a new mapping
-- Specific behaviors such as noremap must be passed as a table to that function
-- Here is a helper to create mappings with the noremap option set to true by default:

local function map(modes, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  if type(modes) ~= 'table' then
    modes = { modes }
  end
  for _, mode in ipairs(modes) do
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
  end
end

-- Paste from clipboard
map({ 'n', 'v' }, 'p', '"+p')
map({ 'n', 'v' }, 'P', '"+P')

-- Don't yank replaced text after pasting in visual mode
map('v', 'p', '"_dP')

-- Set up Y to be consistent with the C and D operators, which act from the cursor to the end of the line
-- The default behavior of Y is to yank the whole line
map('n', 'Y', '"+y$')

-- Very magic by default (Perl Regex almost compatible) {{{
map('n', '?', '?\\v')
map('v', '?', '?\\v')
map('n', '/', '/\\v')
map('v', '/', '/\\v')
map('c', '%s/', '%s/\\v')
map('c', '>%s/', '>%s/\\v')
map('c', '\\>%s/', '\\>%s/\\v')
-- map('n', ':g/', ':g/\\v')
-- map('n', ':g//', ':g//\\v')
-- }}}

--
-- Search results centered {{{
map('n', 'n', 'nzz', { silent = true })
map('n', 'N', 'Nzz', { silent = true })
map('n', '*', '*zz', { silent = true })
map('n', '#', '#zz', { silent = true })
map('n', 'g*', 'g*zz', { silent = true })
-- }}}

-- Use ex mode map to call last macro instead
-- Bram Moolenaar recommends mapping Q to something else
-- To call ex map use the less error prone alias gQ
map('n', 'Q', 'QQ')

-- Input command faster
map({ 'n', 'x' }, ',', ':')

-- Use ZZ to save all buffer inclusive readonly and exit
map('n', 'ZZ', ':xa!<CR>')
map('i', 'ZZ', '<ESC>:xa!<CR>')
map('n', 'ZQ', ':qa!<CR>')
map('i', 'ZQ', '<ESC>:qa!<CR>')

-- Esc Esc for Highlight off the searched term
map('n', '<ESC><ESC>', ':<C-u>nohlsearch<CR>')

-- Always start with insert mode in new files
cmd('autocmd BufNewFile * startinsert')

-- Inner entire buffer
-- map('o', 'bb', ':exec "normal! ggVG<CR>')
map('v', 'bb', '<ESC>ggVG<CR>')
-- Select all buffer with v inside visual mode
map('n', 'vv', '<ESC>ggVG<CR>')
-- Current viewable text in the buffer
map('o', 'iv', ':exec "normal! HVL<CR>')

-- It makes j and k move by wrapped line unless I had a count,
-- in:which case it behaves normally.
-- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
-- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
-- empty mode is same as using :map
map('', 'k', 'v:count ? "k" : "gk"', { expr = true })
map('', 'j', 'v:count ? "j" : "gj"', { expr = true })

-- Make a simple "search" text object.
-- map('v', 's', [[
-- vnoremap <silent> s //e<C-r>=&selection=='exclusive'?'+1':''<CR><CR>
--     \\:<C-u>call histdel('search',-1)<Bar>let @/=histget('search',-1)<CR>gv
-- ]])
-- map('o', 's', ':normal vs<CR>')

-- Split line by delimiters (J inverted) {{{
cmd([[
function! SplitLine()
   let splitted_line = substitute(getline(line('.')), '\([,;.:]\)','\1\n', 'g')
   " substitute() doesn't print new lines
   " So the variable has to be printed using a register
   " The first step is backup any register
   let old_register = @l
   let @l = splitted_line
   " From normal mode to Visual Line mode and then paste the register
   normal! V"lp
   let @l = old_register
endfunction
]])
map('n', 'J', ':call SplitLine()<CR>')
-- }}}

-- Use arrows to resize panels {{{
map('n', '<Up>', ':resize -2<CR>')
map('n', '<Down>', ':resize +2<CR>')
map('n', '<Left>', ':vertical resize -2<CR>')
map('n', '<Right>', ':vertical resize +2<CR>')
-- }}}

-- s for substitute {{{
map('n', 's', '<plug>(SubversiveSubstitute)', { noremap = false })
map('n', 'ss', '<plug>(SubversiveSubstituteLine)', { noremap = false })
map('n', 'S', '<plug>(SubversiveSubstituteToEndOfLine)', { noremap = false })
-- }}}
