set nocompatible

set tabstop=2 shiftwidth=2 expandtab

" fix issues with slow escape
set ttimeout
set ttimeoutlen=5
set timeoutlen=1000

filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'pbrisbin/vim-mkdir'

" Plugin 'dense-analysis/ale'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
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

" Personal laptop
Plugin 'leafgarland/typescript-vim'
Plugin 'kchmck/vim-coffee-script'
Plugin 'pangloss/vim-javascript'
Plugin 'MaxMEllon/vim-jsx-pretty'
Plugin 'peitalin/vim-jsx-typescript'
Plugin 'tpope/vim-rails'

call vundle#end()
filetype plugin indent on

set wildmenu

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

" System copy/paste
noremap <leader>y "+y
noremap <leader>d "+d
noremap <leader>p "+p

noremap ; :

noremap <F9> :e ~/.vimrc<CR>
tnoremap <Esc> <C-W>N

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

" TODO disable Arrow keys in Normal mode
