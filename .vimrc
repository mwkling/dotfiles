set nocompatible

set tabstop=2 shiftwidth=2 expandtab

" fix issues with slow escape
set ttimeout
set ttimeoutlen=5
set timeoutlen=1000

" vertical help
cnoreabbrev h vert h
cnoreabbrev help vert help

" always status line
set laststatus=2
set statusline=%f\ %y\ %h%w%m%r\ %=%(%{FugitiveStatusline()}\ %l,%c%V\ %=\ %P%)

filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'pbrisbin/vim-mkdir'

Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-rhubarb'

Plugin 'kassio/neoterm'
let g:neoterm_default_mod = 'vertical'
let g:neoterm_autoinsert = 1
let g:neoterm_keep_term_open = 0
let g:neoterm_autoscroll = 1
let g:neoterm_automap_keys = ',,t'

" TODO figure out way to make this work when creating new file
Plugin 'airblade/vim-rooter'
let g:rooter_silent_chdir = 1

Plugin 'ycm-core/YouCompleteMe'
" Don't show preview on top when completing
set completeopt-=preview
" Interferes with ALE
let g:ycm_show_diagnostics_ui = 0

Plugin 'SirVer/ultisnips'
let g:UltiSnipsExpandTrigger="<leader><leader>"
let g:UltiSnipsEditSplit="vertical"

let hostname = substitute(system('hostname'), '\n', '', '')

if hostname ==? "mkling-tempo"
  Plugin 'dense-analysis/ale'
  Plugin 'hashivim/vim-terraform'
  let g:ycm_language_server =
    \ [
    \   {
    \     'name': 'terraform',
    \     'cmdline': [ 'terraform-lsp' ],
    \     'filetypes': [ 'terraform' ]
    \   }
    \ ]

  augroup filetype_terraform
    autocmd!
    autocmd BufEnter *.hcl setlocal filetype=terraform
    autocmd FileType terraform Tmap terraform validate
  augroup END
else
  Plugin 'leafgarland/typescript-vim'
  Plugin 'kchmck/vim-coffee-script'
  Plugin 'pangloss/vim-javascript'
  Plugin 'MaxMEllon/vim-jsx-pretty'
  Plugin 'peitalin/vim-jsx-typescript'
  Plugin 'tpope/vim-rails'
endif

Plugin 'jacoborus/tender.vim'

call vundle#end()
filetype plugin indent on

set wildmenu
autocmd vimenter * colorscheme tender

" Tab management
nnoremap <C-t> :tabnew<CR>
nnoremap <C-j> :tabn<CR>
nnoremap <C-k> :tabp<CR>

" Show tabs/trailing whitespace
set list
set listchars=tab:>-,trail:~,extends:>,precedes:<
set wrap

" Move between linting errors
nnoremap ]l :ALENextWrap<CR>
nnoremap [l :ALEPreviousWrap<CR>

" ale runs on save only
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_set_highlights = 0

" let g:ale_terraform_langserver_executable = "terraform-ls"
" let g:ale_terraform_langserver_options = "serve"

let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

" search stuff
set incsearch
set hlsearch
nnoremap <CR> :noh<CR>:<backspace>

" line numbering
set number
set relativenumber
highlight CursorLineNr ctermfg=grey
highlight LineNr ctermfg=darkgrey

set scrolloff=2
set history=1000

nnoremap Y y$

" Leader mappings
let mapleader=","
noremap <leader>w :w<CR>
noremap <leader>q :q<CR>
noremap <leader>Q :qa<CR>
noremap <leader>f :Files<CR>
noremap <leader>e :Buffers<CR>
let g:fzf_buffers_jump = 1
noremap <leader>v :vsp<CR>
noremap <leader>s :sp<CR>
noremap <leader>e :e<space>
noremap <leader>g :Rg<CR>
noremap <leader>t :vertical :term<CR>
noremap <leader>h :History<CR>
noremap <leader>t :Topen<CR>

" System copy/paste
noremap <leader>y "+y
noremap <leader>d "+d
noremap <leader>p "+p

" fugitive
noremap <leader><leader>gb :Gblame<CR>
noremap <leader><leader>gs :Gstatus<CR>
noremap <leader><leader>gh :GBrowse<CR>

noremap ; :

noremap <F9> :e ~/.vimrc<CR>
tnoremap <Esc> <C-W>N

" Slightly weird but easier to type
noremap S ^
noremap K $

" Fix visual indent
vnoremap > >gv
vnoremap < <gv

" Macro replay
noremap Q @@

" Formatting functions
function! Black()
  if &modified != 0
    echoh ErrorMsg | echo "Save changes before running black" | echoh None
    return
  endif
  call system("black -q -l 79 " . bufname("%"))
  if v:shell_error != 0
    echoh ErrorMsg | echo "Error running black" | echoh None
    return
  endif
  edit
endfunction
command! -nargs=0 Black call Black()

function! Tfmt()
  if &modified != 0
    echoh ErrorMsg | echo "Save changes before running terraform fmt" | echoh None
    return
  endif
  call system("terraform fmt " . bufname("%"))
  if v:shell_error != 0
    echoh ErrorMsg | echo "Error running terraform fmt" | echoh None
    return
  endif
  edit
endfunction
command! -nargs=0 Tfmt call Tfmt()

" TODO disable Arrow keys in Normal mode
