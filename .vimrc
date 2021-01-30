" ironsteel's humble vimrc

" Use Vim settings
set nocompatible

" Enable filetypes
filetype on
filetype plugin on
filetype plugin indent on
syntax on

" Enable omnicompletion
set omnifunc=syntaxcomplete#Complete


let mapleader = ","

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
" Show line numbering
set number

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" Search options
set incsearch
set hlsearch

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

endif " has("autocmd")

set autoindent " always set autoindenting on
set smartindent " be smart when indenting other's code

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest

" Increase / decrease vertical split
map <F8> <C-W>>
map <F7> <C-W><

" Invrease / decrease horizontal split
map <F6> <C-W>+
map <F5> <C-W>-

" Turn off swap files
set nobackup
set nowritebackup
set noswapfile

" Do a replace for the current word
nnoremap <Leader>s :%s/\<<C-r><C-w>\>/

" Build tags for current project
map <C-F12> :!ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

" Show extra whitespaces
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /[^\t]\zs\t\+/
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" It's a bit of a strange colorscheme but I'm used to it
colorscheme bluegreen

" I'm a bit of a control guy...
nnoremap <C-k> :tabnext<CR>
nnoremap <C-j> :tabprevious<CR>

autocmd Filetype c setlocal ts=8 sts=8 sw=8 noexpandtab
autocmd Filetype h setlocal ts=8 sts=8 sw=8 noexpandtab

set nopaste

" Persistent undo
if has("persistent_undo") && !exists('$SUDO_USER')
    set undodir=$HOME/.vim/undodir/
    set undofile
endif

" Function for listing errors from ALE linters
function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))
    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors
    return l:counts.total == 0 ? 'OK' : printf(
        \   '%d⨉ %d⚠ ',
        \   all_non_errors,
        \   all_errors
        \)
endfunction
" Show warnings and errors from linters
set statusline+=%=
set statusline+=\ %{LinterStatus()}

" ALE customization
let g:ale_sign_error = '*'
let g:ale_sign_warning = '>'

" Dont run ALE on every keystroke, only when the file is saved
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0

let g:rustfmt_autosave = 1
