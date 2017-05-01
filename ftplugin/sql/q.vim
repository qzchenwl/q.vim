command! -nargs=0        Q  call q#query_file()
command! -nargs=0 -range QS <line1>,<line2>call q#query_selection()
