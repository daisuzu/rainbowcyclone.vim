" rainbowcyclone.vim - Rainbow Cyclone
" Author: daisuzu <daisuzu@gmail.com>
" License: Same terms as Vim itself (see :help license)

if !exists('g:rainwbow_cyclone_colors')
    let g:rainwbow_cyclone_colors = [
                \ 'term=reverse ctermfg=1 ctermbg=12 gui=bold guifg=Black guibg=Red',
                \ 'term=reverse ctermfg=1 ctermbg=6  gui=bold guifg=Black guibg=Orange',
                \ 'term=reverse ctermfg=1 ctermbg=14 gui=bold guifg=Black guibg=Yellow',
                \ 'term=reverse ctermfg=1 ctermbg=10 gui=bold guifg=Black guibg=Green',
                \ 'term=reverse ctermfg=1 ctermbg=9  gui=bold guifg=Black guibg=Blue',
                \ 'term=reverse ctermfg=1 ctermbg=1  gui=bold guifg=Black guibg=SlateBlue',
                \ 'term=reverse ctermfg=1 ctermbg=5  gui=bold guifg=Black guibg=Purple'
                \ ]
endif

" util "{{{
function! s:generate_highlight()
    for [i, pattern] in map(copy(g:rainwbow_cyclone_colors), '[v:key, v:val]')
        execute 'highlight RainbowCyclone' . i . ' ' . pattern
    endfor
endfunction

function! s:parse_arg(arg)
    if a:arg[0] =~# '^[/?]'
        return {
                    \ 'direction': a:arg[0] == '/' ? 'n' : 'N',
                    \ 'word': a:arg[1:]
                    \ }
    endif
endfunction

function! s:create_hi_pattern(word)
    if &smartcase && a:word =~# '[A-Z]'
        let flag = '\C'
    elseif &ignorecase
        let flag = '\c'
    else
        let flag = '\C'
    endif
    return a:word . flag
endfunction

function! s:jump_to_pattern(direction)
    let v:errmsg = ''
    silent! execute 'normal! ' . a:direction

    if v:errmsg =~# '^E38[45]:'
        echohl WarningMsg  | echo v:errmsg | echohl None
    endif
endfunction
"}}}

if !exists('s:rc') "{{{
    let s:rc = {}
endif

function! s:rc.setup()
    let self.curr_pos = 0
    let self.max_index = len(g:rainwbow_cyclone_colors)
    let self.patterns = []
    call s:generate_highlight()
endfunction

function! s:rc.add(arg)
    if len(self.patterns) < self.max_index
        call add(self.patterns, a:arg)
    else
        for id in map(filter(getmatches(), 'v:val.group =~# "RainbowCyclone" . self.curr_pos') , 'v:val.id')
            call matchdelete(id)
        endfor
        let self.patterns[self.curr_pos] = a:arg
    endif

    let @/ = a:arg
    call histadd('search', @/)
endfunction

function! s:rc.increment()
    if self.curr_pos == self.max_index - 1
        let self.curr_pos = 0
    else
        let self.curr_pos += 1
    endif
endfunction

function! s:rc.search(arg, jump)
    let params = s:parse_arg(a:arg)
    if type(params) != type({})
        return
    endif

    call self.add(params.word)
    call matchadd('RainbowCyclone' . self.curr_pos,
                \ s:create_hi_pattern(params.word))
    call self.increment()

    if a:jump
        call s:jump_to_pattern(params.direction)
    endif
endfunction

function! s:rc.list()
    for [idx, pattern] in map(copy(self.patterns), '[v:key, v:val]')
        echo idx . ': "' . pattern . '"'
    endfor
endfunction

function! s:rc.concatenate(arg)
    if len(a:arg) == 0
        let @/ = join(filter(copy(self.patterns), 'v:val != ""'), '\|')
    else
        let @/ = join(map(split(a:arg), 'self.patterns[v:val]'), '\|')
    endif
    call histadd('search', @/)
endfunction

function! s:rc.clear_highlight()
    for id in map(filter(getmatches(), 'v:val.group =~# "RainbowCyclone\\d"') , 'v:val.id')
        call matchdelete(id)
    endfor
endfunction

function! s:rc.reset()
    windo call self.clear_highlight()
    call self.setup()
endfunction

function! s:rc.refresh()
    for [idx, pattern] in map(copy(self.patterns), '[v:key, v:val]')
        call matchadd('RainbowCyclone' . idx, pattern)
    endfor
endfunction
"}}}
call s:rc.setup()

" autocommands "{{{
augroup RainbowCyclone
    autocmd!
    autocmd VimEnter,WinEnter,TabEnter * call s:rc.refresh()
augroup END
"}}}

" interfaces "{{{
function! rainbowcyclone#search(arg, jump)
    call s:rc.search(a:arg, a:jump)
endfunction
function! rainbowcyclone#reset()
    call s:rc.reset()
endfunction
function! rainbowcyclone#list()
    call s:rc.list()
endfunction
function! rainbowcyclone#concatenate(arg)
    call s:rc.concatenate(a:arg)
endfunction
"}}}

" vim: foldmethod=marker
