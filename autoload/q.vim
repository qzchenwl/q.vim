function! q#get_visual_selection()
    let [lnum1, col1] = getpos("'<")[1:2]
    let [lnum2, col2] = getpos("'>")[1:2]
    let lines = getline(lnum1, lnum2)
    let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][col1 - 1:]
    return join(lines, "\n")
endfunction

function! q#query_selection()
    let l:query = q#get_visual_selection()
    return q#query(l:query)
endfunction

function! q#query_file()
    let l:query = join(getline(1, '$'), "\n")
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

