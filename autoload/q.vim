function! q#get_visual_selection()
    let [l:num1, l:col1] = getpos("'<")[1:2]
    let [l:num2, l:col2] = getpos("'>")[1:2]
    let l:lines = getline(l:num1, l:num2)
    let l:lines[-1] = l:lines[-1][: l:col2 - (&selection == 'inclusive' ? 1 : 2)]
    let l:lines[0]  = l:lines[0][l:col1 - 1:]
    return join(l:lines, " ")
endfunction

function! q#query_selection()
    let l:query = q#get_visual_selection()
    return q#query(l:query)
endfunction

function! q#query_file()
    let l:query = join(getline(1, '$'), " ")
    return q#query(l:query)
endfunction

function! q#query(query)
    let l:result = system('q -OHt ' . shellescape(a:query))

    let bn = bufnr('__result__')
    if bn > 0
        let wi = index(tabpagebuflist(tabpagenr()), bn)
        " If the __result__ buffer is open in the current tab, jump to it
        if wi >= 0
            silent execute (wi+1).'wincmd w'
        else
            silent execute 'sbuffer '.bn
        endif
    else
        split '__result__'
    endif

    setlocal modifiable
    setlocal noswapfile
    setlocal buftype=nofile
    silent normal! ggdG
    silent $put=l:result
    silent normal! 1Gdd
    setlocal nomodifiable
    setlocal nomodified

    setlocal tabstop=20
    setlocal nowrap
    setlocal filetype=tsv
endfunction

