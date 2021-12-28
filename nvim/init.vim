imap jk <Esc>
imap <C-n> :NERDTreeToggle<CR>
map <C-q> :x<CR>
    
set clipboard+=unnamedplus

set expandtab
set shiftwidth=4
set tabstop=4
set mouse=a
set number
set background=dark



"autosave
autocmd InsertLeave * if &readonly==0 && filereadable(bufname('%')) | silent update | endif

"markdown
"remember to :PlugInstall any new plugins
call plug#begin('~/.config/nvim/plugins')
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Custom plugin!
    Plug 'shireishi/CustomHighlighting.nvim'
    Plug 'jiangmiao/auto-pairs'
    "Plug 'kana/vim-smartinput'
    Plug 'sheerun/vim-polyglot'
    Plug 'xiyaowong/nvim-transparent'
    "Plug 'kyazdani42/nvim-tree.lua'
    Plug 'iamcco/coc-spell-checker', {'do': 'yarn install && yarn build'}
    Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
    Plug 'tpope/vim-fugitive'
    Plug 'airblade/vim-gitgutter'
    "Plug 'ycm-core/YouCompleteMe'
    Plug 'vim-syntastic/syntastic' 
call plug#end()

"syntastic setup
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

"map tab for coc completion
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

"map tab for cycling through coc options
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"

let g:mkdp_port = '8901'
let g:mkdp_browser = '/usr/bin/firefox-developer-edition'
let g:mkdp_auto_close = 0
let g:mkdp_auto_start = 1
let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {},
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1,
    \ 'sequence_diagrams': {},
    \ 'flowchart_diagrams': {},
    \ 'content_editable': v:false,
    \ 'disable_filename': 0
    \ }
