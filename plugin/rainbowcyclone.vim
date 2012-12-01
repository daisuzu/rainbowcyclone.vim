" rainbowcyclone.vim - Rainbow Cyclone
" Author: daisuzu <daisuzu@gmail.com>
" License: Same terms as Vim itself (see :help license)

let s:save_cpo = &cpo
set cpo&vim

if exists('g:loaded_rainbowcyclone')
    finish
endif

" commands "{{{
command! -nargs=1 -bang RC       call rainbowcyclone#search(<q-args>, <bang>1)
command!                RCReset  call rainbowcyclone#reset()
command!                RCList   call rainbowcyclone#list()
command! -nargs=*       RCConcat call rainbowcyclone#concatenate(<q-args>)
"}}}
" keymappings "{{{
nnoremap <Plug>(rc_search_forward)
            \ :<C-u>RC/
nnoremap <Plug>(rc_search_backward)
            \ :<C-u>RC?
nnoremap <Plug>(rc_search_forward_with_cursor)
            \ :<C-u>execute 'RC/' . expand('<cword>')<CR>
nnoremap <Plug>(rc_search_backward_with_cursor)
            \ :<C-u>execute 'RC?' . expand('<cword>')<CR>
nnoremap <Plug>(rc_search_forward_with_cursor_complete)
            \ :<C-u>execute 'RC/' . '\<' . expand('<cword>') . '\>'<CR>
nnoremap <Plug>(rc_search_backward_with_cursor_complete)
            \ :<C-u>execute 'RC?' . '\<' . expand('<cword>') . '\>'<CR>
nnoremap <Plug>(rc_search_forward_with_last_pattern)
            \ :<C-u>execute 'RC/' . @/<CR>
nnoremap <Plug>(rc_search_backward_with_last_pattern)
            \ :<C-u>execute 'RC?' . @/<CR>

nnoremap <Plug>(rc_highlight)
            \ :<C-u>RC!/
nnoremap <Plug>(rc_highlight_with_cursor)
            \ :<C-u>execute 'RC!/' . expand('<cword>')<CR>
nnoremap <Plug>(rc_highlight_with_cursor_complete)
            \ :<C-u>execute 'RC!/' . '\<' . expand('<cword>') . '\>'<CR>
nnoremap <Plug>(rc_highlight_with_last_pattern)
            \ :<C-u>execute 'RC!/' . @/<CR>

nnoremap <Plug>(rc_reset)
            \ :<C-u>RainbowCycloneReset<CR>
"}}}

let g:loaded_rainbowcyclone = 1

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
