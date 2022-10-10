call plug#begin(has('nvim') ? '~/.config/nvim/plugged' : '~/.vim/plugged')

Plug 'tpope/vim-fugitive'
" Disabled in the context of node12 (postman)
" Plug 'github/copilot.vim'

" Note: theme
Plug 'sheerun/vim-polyglot'
Plug 'pineapplegiant/spaceduck', { 'branch': 'main' }

Plug 'preservim/nerdtree'
" Note: see https://github.com/ryanoasis/vim-devicons
Plug 'ryanoasis/vim-devicons'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" status line
Plug 'feline-nvim/feline.nvim'
Plug 'kyazdani42/nvim-web-devicons' " for icons
Plug 'lewis6991/gitsigns.nvim' " git icon

" search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" brew install the_silver_searcher
Plug 'rking/ag.vim'

" Lsp
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp', {'branch': 'main'}
Plug 'hrsh7th/cmp-buffer', {'branch': 'main'}
Plug 'hrsh7th/cmp-path', {'branch': 'main'}
Plug 'hrsh7th/nvim-cmp', {'branch': 'main'}
" Only because nvim-cmp _requires_ snippets
Plug 'hrsh7th/cmp-vsnip', {'branch': 'main'}
Plug 'hrsh7th/vim-vsnip'
Plug 'ray-x/lsp_signature.nvim'

" For Rust syntax
Plug 'rust-lang/rust.vim'

call plug#end()

set number
set relativenumber
set scrolloff=8
set tabstop=2 softtabstop=2
set shiftwidth=2
set expandtab
set smartindent
set encoding=utf-8

syntax on

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

colorscheme spaceduck

let mapleader = " "
inoremap jk <Esc>
inoremap <A-c> <Esc>

" nnoremap <A-j> :m.+1<CR>==
" nnoremap <A-k> :m.-2<CR>==

nnoremap <leader>er :Vex<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>s :w<CR>
nnoremap <leader><CR> :so ~/.config/nvim/init.vim<CR>
nnoremap <C-p> :GFiles<CR>
nnoremap <C-s> :Files<CR>

nnoremap <C-n> :NERDTree<CR>
nnoremap <C-e> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
let NERDTreeShowHidden=1

" LSP config
lua << END

local cmp = require'cmp'
cmp.setup({
  snippet = {
    -- REQUIRED by nvim-cmp. get rid of it once we can
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    -- Tab immediately completes. C-n/C-p to select.
    ['<Tab>'] = cmp.mapping.confirm({ select = true })
  },
  sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'nvim_lua' },
        { name = 'buffer' },
        { name = 'path' },
  }),
  experimental = {
    ghost_text = true,
  },
  formatting = {
        format = function(entry, vim_item)
            vim_item.menu = ({
                nvim_lsp = '〄',
                nvim_lua = '',
                buffer   = '',
            })[entry.source.name]
            vim_item.kind = ({
                Text          = '',
                Method        = '',
                Function      = '',
                Constructor   = '',
                Field         = '',
                Variable      = '',
                Class         = '',
                Interface     = 'ﰮ',
                Module        = '',
                Property      = '',
                Unit          = '',
                Value         = '',
                Enum          = '',
                Keyword       = '',
                Snippet       = '﬌',
                Color         = '',
                File          = '',
                Reference     = '',
                Folder        = '',
                EnumMember    = '',
                Constant      = '',
                Struct        = '',
                Event         = '',
                Operator      = 'ﬦ',
                TypeParameter = '',
            })[vim_item.kind]
            return vim_item
        end
    },
})

-- Setup lspconfig.
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)

  -- Get signatures (and _only_ signatures) when in argument lists.
  require "lsp_signature".on_attach({
    handler_opts = {
      border = "none"
    },
  })

  -- formatting
  if client.name == 'tsserver' then
    client.resolved_capabilities.document_formatting = false
  end

  -- TODO(tony): install eslint lsp
  if client.name == 'eslint' then
    client.resolved_capabilities.document_formatting = true
  end

  if client.name == 'clangd' then
    client.resolved_capabilities.document_formatting = false
  end

 -- enable_formatting_for_eligible_clients
 -- npm i -g vscode-langservers-extracted
  if client.resolved_capabilities.document_formatting then
    vim.api.nvim_command [[augroup Format]]
    vim.api.nvim_command [[autocmd! * <buffer>]]
    vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]]
    vim.api.nvim_command [[augroup END]]
  end
end

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- npm install -g typescript typescript-language-server
require('lspconfig')['tsserver'].setup{
    on_attach = on_attach,
    capabilities = capabilities,
}

require('lspconfig')['rust_analyzer'].setup{
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
      },
      completion = {
	      postfix = {
	        enable = false,
	      },
      },
    },
  },
}

-- brew install llvmj
require("lspconfig").clangd.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})
END

" rust
let g:rustfmt_autosave = 1
