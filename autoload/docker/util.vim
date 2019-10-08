" open final_url using `open` utility
function! docker#util#open_external_link(final_url)
    if executable('xdg-open')
        let l:open_executable = 'xdg-open'
    elseif executable('open')
        let l:open_executable = 'open'
    else
        echoerr 'vim-docker: no `open` or equivalent command found.'
    endif

    call jobstart(l:open_executable . " " . a:final_url, {})
endfunction

" return complete command string
function! docker#util#get_cmd_string(cmd)
    let l:cmd_string = ['docker']
    return add(l:cmd_string, a:cmd)
endfunction


" return image name by parsing `FROM` command
function! docker#util#get_base_image_name()
    " save cursor position to restore later on
    let l:previous_cursor_position = getpos('.')

    " move to end of buffer, to search for
    " the first occurrence of `FROM` command
    let l:total_buffer_lines = line('$')
    call cursor([l:total_buffer_lines + 1, 1])

    " parse image name from `FROM` command
    let l:base_cmd_line_no = search('FROM', 'n')
    if l:base_cmd_line_no == 0
        return 0
    endif

    let l:base_cmd = getline(l:base_cmd_line_no)
    let l:base_image_name = split(l:base_cmd, ' ')[1]

    " restore cursor position
    call cursor(l:previous_cursor_position[1], l:previous_cursor_position[2])

    return l:base_image_name
endfunction
