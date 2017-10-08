set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'kien/ctrlp.vim'
Bundle 'bling/vim-airline'
Bundle 'x1024/vim-cyrillic'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-sensible'
Bundle 'tpope/vim-commentary'
Bundle 'ElmCast/elm-vim'
Bundle 'vimwiki/vimwiki'
Bundle 'valloric/YouCompleteMe'
"Bundle 'Lokaltog/vim-powerline'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'scrooloose/syntastic'
Bundle 'vim-scripts/busybee'
Bundle 'altercation/vim-colors-solarized'
Bundle 'kien/rainbow_parentheses.vim'
Bundle 'rust-lang/rust.vim'

filetype plugin indent on

" Search
set ignorecase 
set smartcase
set showmatch
set hlsearch

" Undo
set undodir=~/.vim/undodir
set undofile
set undolevels=1000 "maximum number of changes that can be undone
set undoreload=10000 "maximum number lines to save for undo on a buffer reload

" Looks
syntax on
set number
set laststatus=2 " Always show the statusline
set encoding=utf-8 " Necessary to show unicode glyphs

if has('gui_running')
		colorscheme solarized
		set background=light
		set guioptions=
		set guifont=Droid\ Sans\ Mono\ for\ Powerline
    vnoremap <LeftRelease> "*ygv
    let g:airline_powerline_fonts = 1
"    let g:Powerline_symbols = 'fancy'
else
		colorscheme BusyBee
		set background=light
endif

" Movement
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
map <A-h> :call TabMove(-1)<CR>
map <A-l> :call TabMove(1)<CR>
nmap <A-j> gt
nmap <A-k> gT

" Move current tab into the specified direction.
" @param direction -1 for left, 1 for right.
function! TabMove(direction)
    " get number of tab pages.
    let ntp=tabpagenr("$")
    " move tab, if necessary.
    if ntp > 1
        " get number of current tab page.
        let ctpn=tabpagenr()
        " move left.
        if a:direction < 0
            let index=((ctpn-1+ntp-1)%ntp)
        else
            let index=(ctpn%ntp)
        endif

        " move tab page.
        execute "tabmove ".index
    endif
endfunction

" Plugin Configuration
let g:vimwiki_list=[{'path': '~/docs/vimwiki', 'path_html': 'docs/wiki', 'auto_export': 'true'}]

" Misc
nmap t :tabnew 
map! jk <ESC>
map! йк <ESC>

set tabstop=2 shiftwidth=2 expandtab
set backup
set backupdir=~/.vim/backup
set directory=~/.vim/tmp
let mapleader=","
 
let g:ctrlp_open_new_file = 't'

"will put icons in Vim's gutter on lines that have a diagnostic set.
"Turning this off will also turn off the YcmErrorLine and YcmWarningLine
"highlighting

let g:ycm_enable_diagnostic_signs = 1
let g:ycm_enable_diagnostic_highlighting = 0
let g:ycm_always_populate_location_list = 1 "default 0
let g:ycm_open_loclist_on_ycm_diags = 1 "default 1


let g:ycm_complete_in_strings = 1 "default 1
let g:ycm_collect_identifiers_from_tags_files = 0 "default 0
let g:ycm_path_to_python_interpreter = '' "default ''


let g:ycm_server_use_vim_stdout = 0 "default 0 (logging to console)
let g:ycm_server_log_level = 'info' "default info


let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'  "where to search for .ycm_extra_conf.py if not found
let g:ycm_confirm_extra_conf = 1


let g:ycm_goto_buffer_command = 'same-buffer' "[ 'same-buffer', 'horizontal-split', 'vertical-split', 'new-tab' ]
let g:ycm_filetype_whitelist = { '*': 1 }
let g:ycm_key_invoke_completion = '<A-Space>'
