" https://github.com/lloydie/vim-fold

set fillchars=fold:\ "
set foldexpr=FoldMethod(v:lnum)
set foldmethod=expr

function! FindIndent(line_number, indent_width)
    let regexp_blank = "^\s*$"
    let non_blank_line = a:line_number
    while non_blank_line > 0 && getline(non_blank_line) =~ regexp_blank
        let non_blank_line = non_blank_line - 1
    endwhile
    return indent(non_blank_line) / a:indent_width
endfunction

function! FoldMethod(line_number)
    let indent_width = &shiftwidth 
    let indent = FindIndent(a:line_number, indent_width)
    let indent_below = FindIndent(a:line_number + 1, indent_width)
    if indent_below > indent
        return indent_below
    elseif indent_below < indent
        return "<" . indent
    else
        return indent
    endif:
endfunction

function! FoldText()
    let lines = v:foldend - v:foldstart 
    let label = substitute(getline(v:foldstart),"^ *","",1)
    let indent_level = indent(v:foldstart)
    let indent = repeat(' ',indent_level)
    let txt = indent . label 
    return txt
endfunction

set foldtext=FoldText()

" insert method fix
autocmd InsertEnter * let w:last_fdm=&foldmethod | setlocal foldmethod=manual
autocmd InsertLeave * let &l:foldmethod=w:last_fdm

