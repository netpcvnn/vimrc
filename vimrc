"" Behaviors
set nocompatible                " choose no compatibility with legacy vi
filetype off

" Neobundle
if filereadable($HOME . "/.bundle.vim")
	source $HOME/.bundle.vim
endif

" Sensible
runtime! plugin/sensible.vim

set wildmode=list:longest " complete files like a shell
set clipboard+=unnamed    " use the pasteboard as the default register
set hidden                " don't raise a warning when navigating away from a hidden buffer with unsaved changes
set visualbell            " no beeping
set virtualedit=block     " cursor can be positioned anywhere in Visual block mode
set autowriteall          " write file contents when moving to another file
set timeoutlen=1200       " more time for macros
set fillchars+=vert:\ ,fold:-
set history=10000
set wildignore+=*/tmp/*,*.so,*.swp,*.zip

" Mouse
set ttyfast
set mouse=nvi               " enable mouse usage in normal, visual, and insert mode
set ttymouse=xterm2

" C-a, C-x don't deal with hex
set nrformats=

" Use space as :
nnoremap <space> :
vnoremap <space> :

" Use ! as :!
nnoremap ! :!
vnoremap ! :!

" Use , as <leader>
let mapleader = ","

" Dot selection
" Works with range
vnoremap . :norm.<cr>

"Disable arrow keys
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>
" Switch between last 2 files
nnoremap <leader><leader> <c-^>

" Remove highlighting
nnoremap <leader><space> :noh<cr>

" Faster drawing
set lazyredraw

" Window handling
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
map <leader>w <C-w>q
"Root privileges for edit root-needed files
cmap w!! w !sudo tee % >/dev/null

" Split more sensibly
set splitbelow
set splitright         

"" Display
set showmode                    " display current mode
set cursorline                  " highlight current line
set cmdheight=2                 " command line height

"" Copy
map <leader>y "*y
set pastetoggle=<F2>

"" Wrapping
set wrap
set linebreak

"" Scheme
set t_Co=256

" For debugging 
map <c-t> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
			\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
			\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" base16
" colorscheme base16-ocean
" set background=dark

" Tomorrow-Night 
colorscheme Tomorrow-Night

hi Search cterm=underline ctermfg=none ctermbg=none

hi clear SignColumn
hi SignifySignAdd cterm=bold ctermbg=none ctermfg=119
hi SignifySignDelete cterm=bold ctermbg=none ctermfg=167
hi SignifySignChange cterm=bold ctermbg=none ctermfg=227

" GRB256
" colorscheme grb256

" Solarized 
" syntax enable
" colorscheme solarized
" hi clear SignColumn
" set background=dark

"" Line number
if !exists("*SetLineNumber")
	function SetLineNumber()
		set relativenumber
		set number
	endfunction
endif

"" Statusline
if !exists("*SetFullStatusLine")
	function SetFullStatusLine()
		setl statusline=[%n]\ 
		setl statusline+=%{&paste?'*paste*\ ':''}
		setl statusline+=[
		setl statusline+=%F
		setl statusline+=%{&modified?'*':''}
		setl statusline+=]
		setl statusline+=%{&readonly?'\ (read-only)\ ':'\ '}\ 
		setl statusline+=%{strlen(&ft)?&ft:'none'}/
		setl statusline+=%{strlen(&syntax)?&syntax:'none'}\ \ 
		setl statusline+=%{&ff}/
		setl statusline+=%{strlen(&fenc)?&fenc:'none'}\ \ 
		setl statusline+=%=
		setl statusline+=%{tagbar#currenttag('[%s]','')}\ \ 
		setl statusline+=%{fugitive#statusline()}\ \ 
		setl statusline+=\ %l,%c
		setl statusline+=/%L\ 
		setl statusline+=[%p%%]
	endfunction

	function SetShortStatusLine()
		setl statusline=[%n]\ 
		setl statusline+=[
		setl statusline+=%F
		setl statusline+=%{&modified?'*':''}
		setl statusline+=]
		setl statusline+=%=
		setl statusline+=%l
		setl statusline+=/%L\ 
		setl statusline+=[%p%%]
	endfunction
endif

"" Whitespace
set tabstop=4                  " indentation every 4 cols
set shiftwidth=4               " indent of 4 spaces
set softtabstop=4              " backspaces delete indentation
set scrolloff=8                " around the cursor
" Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:▸\ ,eol:¬

"" Searching
set hlsearch                    " highlight matches
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter          

"" Undo
set undodir=$HOME/.vim/tmp
set backupdir=$HOME/.vim/tmp
set undofile
set undolevels=1000         " number of undos 
set undoreload=10000        " number of lines to save for undo  

" Use normal regex
nnoremap / /\v
vnoremap / /\v

" Backup files
set noswapfile

if !exists("*ReloadVimrc")
	function ReloadVimrc()
		let l = line(".")
		let c = col(".")
		source $MYVIMRC
		call cursor(l, c)
	endfunction
endif

" Scrollbind
noremap <silent> <leader>sb :<C-u>let @z=&so<CR>:set so=0 noscb<CR>:bo vs<CR>Ljzt:setl scb<CR><C-w>p:setl scb<CR>:let &so=@z<CR>

" Always open help in vertical split
aug helpfiles
	au!
	au BufRead,BufEnter */doc/* wincmd L
aug END

" Quickly open a split
nnoremap yv :vs<CR>

" Open .vimrc for quick editing
if !exists('*SplitIfNecessary')
	function SplitIfNecessary(file)
		if line('$') == 1 && getline(1) == ''
			exec 'e' a:file
		else
			exec 'vsp' a:file
		endif
	endfunction
endif
aug vimrc
	au!
	au! BufWritePost .vimrc :call ReloadVimrc()
	au! BufWritePost .bundle.vim :call ReloadVimrc()
aug END
nmap <leader>v :call SplitIfNecessary($MYVIMRC)<cr>
nmap <leader>b :call SplitIfNecessary("~/.bundle.vim")<cr>

" Test
" http://www.oinksoft.com/blog/view/6/
aug test
	let ft_stdout_mappings = {
				\'applescript': 'osascript',
				\'bash': 'bash',
				\'bc': 'bc',
				\'haskell': 'runghc',
				\'javascript': 'node',
				\'lisp': 'sbcl',
				\'nodejs': 'node',
				\'ocaml': 'ocaml',
				\'perl': 'perl',
				\'php': 'php',
				\'python': 'python',
				\'ruby': 'ruby',
				\'scheme': 'scheme',
				\'sh': 'sh',
				\'sml': 'sml',
				\'spice': 'ngspice'
				\}
	for ft_name in keys(ft_stdout_mappings)
		execute 'au Filetype ' . ft_name . ' nnoremap <buffer> <C-P> :write !'
					\. ft_stdout_mappings[ft_name] . '<CR>'
	endfor
aug END

aug allfiles
	au!

	" Save file on losing focus
	au FocusLost * :wa        

	" Relative number for current window only
	au WinEnter,BufEnter * :call SetLineNumber()
	au WinLeave,BufLeave * set norelativenumber

	" Different statuslines
	au WinEnter,BufEnter * :call SetFullStatusLine()
	au WinLeave,BufLeave * :call SetShortStatusLine()

	" Jump to last cursor position 
	au BufReadPost *
				\ if line("'\"") > 0 && line("'\"") <= line("$") |
				\   exe "normal g`\"" |
				\ endif
aug END

aug filetypes
	au!
	" Misc spacings
	au Filetype ruby,haml,yaml,html,javascript set ai ts=2 sts=2 sw=2 et

	" Autocompletion
	au FileType python set omnifunc=pythoncomplete#Complete
	au FileType javascript set omnifunc=javascriptcomplete#CompleteJS
	au FileType html,markdown set omnifunc=htmlcomplete#CompleteTags
	au FileType css set omnifunc=csscomplete#CompleteCSS
	au FileType xml set omnifunc=xmlcomplete#CompleteTags
	au FileType php set omnifunc=phpcomplete#CompletePHP
	au FileType c set omnifunc=ccomplete#Complete
	au FileType java set omnifunc=javacomplete#Complete

	" Syntax highlighting
	au BufRead,BufNewFile *.blade.php set filetype=blade
	au BufRead,BufNewFile *.hs set filetype=haskell
	au BufRead,BufNewFile *.java set filetype=java
	au BufRead,BufNewFile *.js set filetype=javascript
	au BufRead,BufNewFile *.php set filetype=php
	au BufRead,BufNewFile *.html,.htm set filetype=html
	au BufRead,BufNewFile *.rb set filetype=ruby
	au BufRead,BufNewFile *.vim,.vimrc,.gvimrc set filetype=vim
	au BufNew,BufNewFile *.cpp,.h,.c set filetype=c
	au BufRead,BufNewFile *.blade.php set fileformat=unix
aug END

"Open/View files in same directory
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :<C-u>edit %%

" Indent/Unident
vnoremap > >gv
vnoremap < <gv
nmap <leader>V ggVG
nmap <leader>= gg=G

"" Plugins setup

" Unite
let g:unite_win_height = 10
let g:unite_split_rule = 'topright'
let g:unite_source_history_yank_enable = 2
let g:unite_enable_start_insert = 1
if executable('ag')
	let g:unite_source_grep_command = 'ag'
	let g:unite_source_grep_default_opts =
				\ '--line-numbers --nocolor --nogroup --hidden --ignore ' .
				\  '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
	let g:unite_source_grep_recursive_opt = ''
endif
call unite#custom#source('file_rec,file_rec/async', 'max_candidates', 0)
call unite#custom#source('file_rec,file_rec/async', 'ignore_pattern', join([
			\ '\.\(git\|svn\|vagrant\)\/', 
			\ 'tmp\/',
			\ 'app\/storage\/',
			\ 'bower_components\/',
			\ 'fonts\/',
			\ 'sass-cache\/',
			\ 'node_modules\/',
			\ '\.\(jpe?g\|gif\|png\)$',
			\ ], 
			\ '\|'))
call unite#filters#matcher_default#use(['matcher_fuzzy', 'matcher_hide_hidden_files', 'matcher_project_files'])
call unite#filters#sorter_default#use(['sorter_selecta'])

nnoremap yf :<C-u>Unite -no-split file_rec/async:!<cr>
nnoremap yb :<C-u>Unite -no-split buffer<cr>
nnoremap ya :<C-u>Unite -no-split tag<cr>
nnoremap yt :<C-u>Unite -no-split outline<cr>
nnoremap ym :<C-u>Unite -no-split file_mru<cr>
nnoremap yg :<C-u>Unite grep:.<cr>
nnoremap yk :<C-u>Unite history/yank<cr>

" neocomplete 
let g:neocomplete#enable_at_startup = 3
let g:neocomplete#sources#syntax#min_keyword_length = 2
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
if !exists('g:neocomplete#keyword_patterns')
	let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'
inoremap <silent> <cr> <C-r>=<SID>my_cr_function()<cr>
function! s:my_cr_function()
	return pumvisible() ? neocomplete#close_popup() : "\<cr>"
endfunction
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
if !exists('g:neocomplete#sources#omni#input_patterns')
	let g:neocomplete#sources#omni#input_patterns = {}
endif

" vim-easy-align
vmap <enter> <Plug>(EasyAlign)
nmap <leader>a <Plug>(EasyAlign)
vmap <leader><enter>   <Plug>(LiveEasyAlign)
nmap <leader><leader>a <Plug>(LiveEasyAlign)

" vim-rooter
let g:rooter_manual_only = 2

" vim-signify
let g:signify_vcs_list = ['git', 'svn']

" tagbar
map <leader>t :TagbarToggle<cr>
map <leader>ts :TagbarOpen<cr>\|:TagbarShowTag<cr>
let g:tagbar_autoshowtag = 2

" syntastic
let g:syntastic_check_on_open = 3
let g:syntastic_ignore_files = [
			\ '\c\.js$',
			\ '\c\.hbs$',
			\]

" neosnippet
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
			\ "\<Plug>(neosnippet_expand_or_jump)"
			\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
			\ "\<Plug>(neosnippet_expand_or_jump)"
			\: "\<TAB>"
if has('conceal')
	set conceallevel=2 concealcursor=i
endif
let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'

" undotree
nnoremap <leader>u :UndotreeToggle<cr>

" ZoomWin
nnoremap <leader>z :ZoomWin<cr>

"Quote words under cursor
nnoremap <leader>" viW<esc>a"<esc>gvo<esc>i"<esc>gvo<esc>3l
nnoremap <leader>' viW<esc>a'<esc>gvo<esc>i'<esc>gvo<esc>3l
" Quote current selection
" TODO: This only works for selections that are created "forwardly"
vnoremap <leader>" <esc>a"<esc>gvo<esc>i"<esc>gvo<esc>ll
vnoremap <leader>' <esc>a'<esc>gvo<esc>i'<esc>gvo<esc>ll
" Vimfiler
map <C-n> :VimFilerExplorer<CR>
nmap - :VimFiler -find<CR>
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_ignore_pattern = '^\%(.git\|.svn\|.DS_Store\)$'
let g:vimfiler_safe_mode_by_default = 0
