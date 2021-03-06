filetype off

if &compatible
  set nocompatible               " Be iMproved
endif

call plug#begin('~/.nvim/plugged')
call plug#begin()
Plug 'tpope/vim-repeat'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-surround' " Revived for use outside clojure
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-fugitive'
Plug 'kien/ctrlp.vim'
Plug 'tpope/vim-fireplace' " Talks to nREPL to provide code evaluation in vim
Plug 'tpope/vim-salve' " Auto connect fireplace to nREPL(or auto start it w/ :Console
Plug 'tpope/vim-dispatch' " Mainly for kicking off liengen asynchronusly by vim-salve, but generally to leverage the power of Vim's compiler plugins without being bound by synchronicity. Kick off builds and test suites using one of several asynchronous adapters (including tmux, screen, iTerm, Windows, and a headless mode, and when the job completes, errors will be loaded and parsed automatically.
Plug 'kovisoft/paredit'
Plug 'guns/vim-clojure-static' "  Syntax stuff
Plug 'guns/vim-clojure-highlight' " Syntax stuff
Plug 'itissid/Nvim-R'
Plug 'maverickg/stan.vim'

call plug#end()

filetype plugin indent on
syntax enable


filetype plugin indent on
syntax on

let g:SuperTabMappingForward = '<c-space>'
let g:SuperTabMappingBackward= '<s-c-space>'
let mapleader=","
inoremap <Leader>t <Tab>
" The mapping of tab to sec costs me jump navigation of <C-i>, reclaim it
nnoremap <c-u> <c-i>

" Fast saving
nmap <leader>w :w!<cr>
" Fast quitting
nmap <leader>q :q!<cr>

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Visual mode pressing * or # searches for the current selection Super useful!
" From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l


" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Remember info about open buffers on close
set viminfo^=%

""""""""""""""""""""""""""""""
" => Status line
"""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Format the status line
"set statusline=\ %{HasPaste()}%f%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l
set statusline=\ %{HasPaste()}%f%m%r%h\ %w\ \ CWD:\ %{fnamemodify(getcwd(),':t')}%h\ \ \ Line:\ %(%l/%L%)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vimgrep searching and cope displaying
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSelection('gv')<CR>

" Open vimgrep and put the cursor in the right position
map <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>

" Vimgreps in the current file
map <leader><space> :vimgrep // <C-R>%<C-A><right><right><right><right><right><right><right><right><right>

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>v :call VisualSelection('gq')<CR>

" Do :help cope if you are unsure what cope is. It's super useful!
"
" When you search with vimgrep, display your results in cope by doing:
"   <leader>cc
"
" To go to the next search result do:
"   <leader>n
"
" To go to the previous search results do:
"   <leader>p
"
map <leader>cc :botright cope<cr>
map <leader>co ggVGy:tabnew<cr>:set syntax=qf<cr>pgg
map <leader>n :cn<cr>
map <leader>p :cp<cr>

" Code folding made easy
nnoremap <space> za
vnoremap <space> zc

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! Get_visual_selection()
  " Why is this not a built-in Vim script function?!
  " Sid: Got it to work for me
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  return join(lines, "\n")
endfunction

function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'gq'
        call CmdLine("%s" . '/'. Get_visual_selection() . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    en
    return ''
endfunction


" noremap <Up> <NOP>
" noremap <Down> <NOP>
" noremap <Left> <NOP>
" noremap <Right> <NOP>

" Spell check for the git commit file
autocmd FileType gitcommit setlocal spell
autocmd BufWritePre *.py :%s/\s\+$//e

" This will open a new split after you navigate from a 'tag' or
" it will goto the existing buffer for the tag, if one exists.
" TODO(Sid): Still need to complete this.
set switchbuf=useopen,usetab,split
function! AutoImportAutoImport()
    echom 'Fill me in some how...'
endfunction
" inoremap <expr> <space>  pumvisible() ? AutoImportAutoImport() : '\<space>'

let g:vimwiki_list=[{'path': '~/Dropbox/vimwiki/'}, {'path_html': '~/Dropbox/vimwiki_html/'}]

" Some Fugitive bindings.

"This helps you move up and down the tree.
autocmd User fugitive
  \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
  \   nnoremap <buffer> .. :edit %:h<CR> |
  \ endif
" Dont select the first completion utesm insert the lingest common test of all
" matches and the menu will comeup even if there's only one match.
set completeopt=longest,menuone

" Neo cache compl with jedi/rope
" let g:neocomplcache_enable_at_startup = 1
" let g:neocomplete#enable_at_startup = 1
" let g:neocomplete#enable_smart_case = 1
" imap neosnippet#expandable() ? "(neosnippet_expand_or_jump)" : pumvisible() ? "" : ""
" smap neosnippet#expandable() ? "(neosnippet_expand_or_jump)" :
" let g:neocomplcache_force_overwrite_completefunc = 1
" if !exists('g:neocomplcache_omni_functions')
"   let g:neocomplcache_omni_functions = {}
" endif
" if !exists('g:neocomplcache_force_omni_patterns')
"     let g:neocomplcache_force_omni_patterns = {}
" endif
" let g:neocomplcache_force_overwrite_completefunc = 1
" let g:neocomplcache_force_omni_patterns['python'] = '[^. t].w*'
set ofu=syntaxcomplete#Complete
au FileType python set omnifunc=pythoncomplete#Complete
au FileType python let b:did_ftplugin = 1

" So am going to replace my new neocomplcache snippets with

" let g:neosnippet#snippets_directory="~/.vim/bundle/vim-snippets"
let g:UltiSnipsExpandTrigger="<c-k>"
let g:UltiSnipsJumpForwardTrigger="<c-l>"
let g:UltiSnipsJumpBackwardTrigger="<c-h>"


" A long time coming... I think I should just get used to this more
" and let the tab key alone
"onoremap jk <Esc>
"inoremap jk <Esc>`^

" Note to self: seems like the escape key is not that bad of an idea
" I seem to be able to reach it easily and also changing the defaults is
" not as bad as it seems!
" inoremap <Esc> <nop>


" For SQLFormatting
let g:sqlutil_keyword_case = '\U'
let g:sqlutil_align_comma=1

" For vim powerline. Need to install this more out of the box
" python from powerline.vim import setup as powerline_setup
" python powerline_setup()
" python del powerline_setup
" Since we are using spaces every where we should make this happen
set expandtab
" Use spaces only: http://vim.wikia.com/wiki/Indenting_source_code
set shiftwidth=4
set softtabstop=4


" Nerdtree auto on vim start
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

let NERDTreeIgnore=['\.pyc', '__pycache__', '\~$']

" Neocomplcache customizations
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"


" <C-h>, <BS>: close popup and delete backword char.
" inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
" inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" inoremap <expr><C-y>  neocomplete#close_popup()
" inoremap <expr><C-e>  neocomplete#cancel_popup()

" Mouse for quick select!
set mouse=a

set runtimepath^=~/.vim/bundle/ctrlp.vim

" leave insert mode quickly
" This happened to me when escape would not get out of the insert mode quickly
" enough
if ! has('gui_running')
  set ttimeoutlen=10
  augroup FastEscape
    autocmd!
    au InsertEnter * set timeoutlen=0
    au InsertLeave * set timeoutlen=1000
  augroup END
endif

" Show trailing white spaces and remove em

function ShowSpaces(...)
  let @/='\v(\s+$)|( +\ze\t)'
  let oldhlsearch=&hlsearch
  if !a:0
    let &hlsearch=!&hlsearch
  else
    let &hlsearch=a:1
  end
  return oldhlsearch
endfunction

function TrimSpaces() range
  let oldhlsearch=ShowSpaces(1)
  execute a:firstline.",".a:lastline."substitute ///gec"
  let &hlsearch=oldhlsearch
endfunction
command -bar -nargs=? ShowSpaces call ShowSpaces(<args>)
command -bar -nargs=0 -range=% TrimSpaces <line1>,<line2>call TrimSpaces()
nnoremap <leader>s :ShowSpaces 1<CR>
nnoremap <leader>tw   m`:TrimSpaces<CR>``
vnoremap <leader>t   :TrimSpaces<CR>
" Copied this scheme as it was the most pleasant coding experience
" https://raw.githubusercontent.com/mbbill/vim-seattle/master/colors/seattle.vim
" colorscheme 256_noir
colorscheme seattle

"For NVim-R plugin
let R_vsplit=1
let R_in_buffer=1
let R_applescript=0
let R_tmux_split=1
let R_screen_split=0
let R_openhtml=2
let R_darwin_browser='chrome'

" Making the highlighting colors same as in my VI. This is useful for
" highlighting searches with * and # that were enabled by visualmode.
" SO thread
" https://stackoverflow.com/questions/7103173/vim-how-to-change-the-highlight-color-for-search-hits-and-quickfix-selection
hi Search term=reverse ctermfg=0 ctermbg=3 guifg=Black guibg=Yellow

"Use Escape key to map to normal mode
tnoremap <Esc> <C-\><C-n>

" The art cat welcome
echo ">^.^< hi sid!"
