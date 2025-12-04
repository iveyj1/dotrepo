
--========================================================
-- Basic Settings
--========================================================
vim.g.mapleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.swapfile = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.undofile = true
vim.opt.incsearch = true
vim.opt.undolevels = 10000
vim.opt.scrolloff = 10
-- Treesitter folds
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false

vim.opt.makeprg = [[./b $*]]

--========================================================
-- Keymaps
--========================================================
local map = vim.keymap.set

local function toggle_relativenumber()
    vim.opt.relativenumber = not vim.opt.relativenumber:get()
end

map('n', '<leader>er', ':MRU<CR>',  { silent = true, desc = 'MRU' })
map('n', '<leader>eo', ':Oil<CR>',   { silent = true, desc = 'Oil file explorer' })
map("n", "<leader>ec", ":edit $MYVIMRC<CR>:only<CR>", { silent = true, desc = "Open config as only window" })   
map("n", "<leader>ez", ":edit ~/.wezterm.lua<CR>:only<CR>", { silent = true, desc = "Open wezterm config as only window" })   
map('n', '<leader>ew', ':new<CR>:only<CR>', { silent = true; desc = 'open new file as only window'})
map('n', '<leader>eb', ':edit $HOME/.bashrc<CR>:only<CR>:edit $HOME/.bash_aliases<CR>', { silent = true; desc = 'open .bashrc, .bash_aliases'})
map('n', '<leader>et', ':edit $HOME/.config/tmuxp/fcsw.yaml<CR>:edit $HOME/.config/tmux/tmux.conf<CR>:only<CR>', { silent = true; desc = 'open tmux.conf tmuxp'})


map('n', '<leader>gk', 'O<esc>j', { silent = true; desc = 'add new line above cursor'})
map('n', '<leader>gj', 'o<esc>k', { silent = true; desc = 'add new line below cursor'})

map('n', '<leader>mk', ':make ', { desc = 'run make command, wait for arguments'})

map('n', '<leader>l',  ':ls<CR>', {silent = true, desc = 'list buffers'})
map('n', '<leader>x', '<C-w>c',     { silent = true, desc = 'Close window' })
map('n', '<leader>k', ':bd<CR>',     { silent = true, desc = 'Close buffer' })
-- map('n', '<leader>w', ':w<CR>', { silent = true, desc = 'Write buffer' })
map('n', '<leader>q', ':quit<CR>',  { silent = true, desc = 'Quit' })
map('n', '<leader>n', ':bn<CR>',  { silent = true, desc = 'next buffer' })

map('n', 'go', ':put _<CR>', {silent = true, desc = 'open new line below cursor'})
map('n', 'gO', ':put! _<CR>', {silent = true, desc = 'open new line above cursor'})
-- map('i', 'jj', '<esc>',  { silent = true, desc = 'insert mode <escape> alias' })
map({'n','v','x'}, '<leader>rn', toggle_relativenumber, { desc = 'Toggle relative number' })

-- System clipboard
map({'n','v','x'}, '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
map({'n','v','x'}, '<leader>Y', '"+y$', { desc = 'Yank to end of line to system clipboard' })
map({'n','v','x'}, '<leader>d', '"+d', { desc = 'Delete to system clipboard' })
map({'n','v','x'}, '<leader>D', '"+D', { desc = 'Delete to end of line to system clipboard' })
map({'n','v','x'}, '<leader>p', '"+p', { desc = 'Paste from system clipboard' })

-- Navigation niceties
map({'n','v','x'}, '<C-d>', '<C-d>zz', { desc = 'Page down centered' })
map({'n','v','x'}, '<C-u>', '<C-u>zz', { desc = 'Page up centered' })
map({'n','v','x'}, 'U', function() print("Do not use 'U'") end, { silent = true })

local function pack_hooks(ev)
    local name, kind = ev.data.spec.name, ev.data.kind

    if name == 'telescope-fzf-native.nvim'
       and (kind == 'install' or kind == 'update') then
        -- configure
        vim.system(
            { 'cmake', '-S.', '-Bbuild', '-DCMAKE_BUILD_TYPE=Release' },
            { cwd = ev.data.path }
        ):wait()

        -- build + install
        vim.system(
            { 'cmake', '--build', 'build', '--config', 'Release', '--target', 'install' },
            { cwd = ev.data.path }
        ):wait()
    end
end

-- IMPORTANT: before vim.pack.add()
vim.api.nvim_create_autocmd('PackChanged', { callback = pack_hooks })

vim.pack.add({ 
    -- { src = "https://github.com/vague2k/vague.nvim" }, 
    { src = "https://github.com/stevearc/oil.nvim" }, 
    { src = "https://github.com/nvim-mini/mini.bufremove" }, 
    { src = "https://github.com/yegappan/mru" }, 
    { src = "https://github.com/folke/which-key.nvim" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" }, 
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
      build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release --target install", 
    },
    { src = "https://github.com/nvim-telescope/telescope.nvim" },
    { src = "https://github.com/MunifTanjim/nui.nvim" },
    { src = "https://github.com/nvim-neo-tree/neo-tree.nvim" },
    { src = "https://github.com/rose-pine/neovim"  },
    { src = "https://github.com/lewis6991/gitsigns.nvim"},
    { src = "https://github.com/alexghergh/nvim-tmux-navigation" },
    { src = "https://github.com/ThePrimeagen/harpoon.git",
      version = "harpoon2",      
    },
})

require("nvim-treesitter.configs").setup({
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "python" },
  highlight = { enable = true },
  indent = { enable = true },
})   

require('telescope').setup()
require('telescope').load_extension('fzf')

require('gitsigns').setup()

local nvim_tmux_nav = require('nvim-tmux-navigation')

nvim_tmux_nav.setup({
    disable_when_zoomed = true, -- defaults to false
})

vim.keymap.set('n', "<C-h>",     nvim_tmux_nav.NvimTmuxNavigateLeft)
vim.keymap.set('n', "<C-j>",     nvim_tmux_nav.NvimTmuxNavigateDown)
vim.keymap.set('n', "<C-k>",     nvim_tmux_nav.NvimTmuxNavigateUp)
vim.keymap.set('n', "<C-l>",     nvim_tmux_nav.NvimTmuxNavigateRight)
vim.keymap.set('n', "<C-\\>",    nvim_tmux_nav.NvimTmuxNavigateLastActive)
vim.keymap.set('n', "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)

--========================================================
-- Telescope Setup
--========================================================
local telescope = require('telescope')
local builtin = require('telescope.builtin')
telescope.setup({
    defaults = {
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 8,
        mappings = {
            i = { ["<esc>"] = require('telescope.actions').close },
        },
    },
})

map('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
map('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
map('n', '<leader>fs', builtin.grep_string, { desc = 'Grep string' })
map('n', '<leader>fb', builtin.buffers, { desc = 'List buffers' })
map('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
map('n', '<leader>fm', builtin.oldfiles, { desc = 'Recent files' })
map('n', '<leader>ft', builtin.treesitter, { desc = 'Treesitter' })
map('n', '<leader>fk', builtin.keymaps, { desc = 'Keymaps' })
map('n', '<leader>fw', builtin.grep_string, { desc = 'Find word under cursor' })
map('n', '<leader>gs', builtin.git_status, { desc = 'Git status' })
map('n', '<leader>gc', builtin.git_commits, { desc = 'Git commits' })
map('n', '<leader>gb', builtin.git_branches, { desc = 'Git branches' })
map('n', '<leader>gB', builtin.git_bcommits, { desc = 'Buffer commits' })

-- Project-specific Telescope shortcuts
map('n', '<leader>fcf', function()
    builtin.find_files({ cwd = 'common', prompt_title = 'Search in common/' })
end, { desc = 'Find files in common' })

map('n', '<leader>fcg', function() 
    builtin.live_grep({ cwd = 'common', prompt_title = 'Grep in common/'})
end, { desc = 'Live grep common files' })

map('n', '<leader>frf', function()
    builtin.find_files({ cwd = '../boards/arm' , prompt_title = 'Search in boards/'})
end, { desc = 'Find files in ../boards/arm' })

map('n', '<leader>frg', function() 
    builtin.live_grep({ cwd = '../boards/arm', prompt_title = 'Grep in boards/'})
end, { desc = 'Live grep ../boards/arm' })

map('n', '<leader>fnf', function()
    builtin.find_files({ cwd = '$HOME/ncs/v3.1.1', prompt_title = 'Search in ncs/v3.1.1' })
end, { desc = 'Find files in sdk directory' })

map('n', '<leader>fng', function() 
    builtin.live_grep({cwd = '$HOME/ncs/v3.1.1', prompt_title = 'Grep in ncs/v3.1.1'})
end, { desc = 'Live grep in sdk directory' })

map('n', '<leader>fnf', function()
    builtin.find_files({ cwd = vim.fn.expand("$HOME/notes") , prompt_title = 'Search in boards/'})
end, { desc = 'Find files in notes' })

map('n', '<leader>fng', function() 
    builtin.live_grep({ cwd = vim.fn.expand("$HOME/notes"), prompt_title = 'Grep in notes/'})
end, { desc = 'Grep in notes' })

local function create_file_in_notes_dir()
    local notes_dir = vim.fn.expand("$HOME/notes")

    vim.ui.input({ prompt = "Enter filename: " }, function(file_name)
        if not file_name or file_name == "" then
            return
        end

        local full_path = notes_dir .. "/" .. file_name
        vim.fn.writefile({}, full_path)
        vim.cmd("edit " .. full_path)
    end)
end

vim.keymap.set("n", "<leader>fnw", create_file_in_notes_dir, { desc = "Create file in notes directory" })   

local harpoon = require("harpoon")
-- REQUIRED
harpoon:setup()
-- REQUIRED
vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = "harpoon add"})
vim.keymap.set("n", "<leader>he", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "harpoon toggle quick menu"})

vim.keymap.set("n", "<A-S-h>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<A-S-j>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<A-S-k>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<A-S-l>", function() harpoon:list():select(4) end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<leader>hk", function() harpoon:list():prev() end)
vim.keymap.set("n", "<leader>hj", function() harpoon:list():next() end)

-- cd to buffer directory
vim.keymap.set('n', '<leader>cd', function()
    vim.cmd('cd ' .. vim.fn.expand('%:p:h'))
end, { desc = 'Set working directory to path of buffer.' })

map('n', '<leader>thd',  ':TSDisable highlight<cr>', { silent = true, desc = "Disable Treesitter syntax highlighting"})
map('n', '<leader>the',  ':TSEnable highlight<cr>', { silent = true, desc = "Disable Treesitter syntax highlighting"})

map('n', '<M-j>', '<cmd>cnext<cr>', {silent = true, desc = "Next quickfix item"});
map('n', '<M-k>', '<cmd>cprev<cr>', {silent = true, desc = "Previous quickfix item"});
map('n', '<M-q>', '<cmd>copen<cr>', {silent = true, desc = "Open quickfix"});
map('n', '<M-c>', '<cmd>cclose<cr>', {silent = true, desc = "Close quickfix"});

-- wrap lines in quickfix lis
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.opt_local.wrap = true
  end
})

--========================================================
-- Plugin Configs
--========================================================
require('oil').setup({ default_file_explorer = false })
require('which-key').setup({ delay = 250, show_help = true })
require('mini.bufremove').setup()

-- Map 'k' to delete the current buffer using mini.bufremove
vim.keymap.set('n', '<leader>bd', ':lua require("mini.bufremove").delete(0, false)<CR>', { desc = 'Delete current buffer' })   

--========================================================
-- UI & Misc
--========================================================
-- vim.cmd("colorscheme vague")
require("rose-pine").setup({
    variant = "main", -- auto, main, moon, or dawn
})

vim.cmd.colorscheme("rose-pine")

local bg = "#0c0c0c"
vim.api.nvim_set_hl(0, "Normal",      { bg = bg })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = bg })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = bg })
vim.api.nvim_set_hl(0, "SignColumn",  { bg = bg })
vim.api.nvim_set_hl(0, "LineNr",      { bg = bg })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = bg })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "#282828" }) -- Example dark gray background

vim.cmd("hi StatusLine guibg=none")

vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('highlight_yank', { clear = true }),
    desc = 'Highlight on yank',
    callback = function()
        vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 500 })
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "help", "new" },
    callback = function()
        vim.cmd("wincmd o | resize")
        vim.opt_local.buflisted = true
    end,
})

vim.opt.formatprg = "clang-format --assume-filename=a.c"
