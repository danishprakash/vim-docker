" return image name by parsing `FROM` command
function! s:get_base_image_name()
    " save cursor position to restore later on
    let l:previous_cursor_position = getpos('.')

    " move to end of buffer, to search for
    " the first occurrence of `FROM` command
    let l:total_buffer_lines = line('$')
    call cursor([l:total_buffer_lines + 1, 1])

    " parse image name from `FROM` command
    let l:base_cmd_line_no = search('FROM', 'n')
    let l:base_cmd = getline(l:base_cmd_line_no)
    let l:base_image_name = split(l:base_cmd, ' ')[1]

    " restore cursor position
    call cursor(l:previous_cursor_position[1], l:previous_cursor_position[2])

    return l:base_image_name
endfunction

function! s:open_base_image()
    let l:base_image_name = s:get_base_image_name()
    echo l:base_image_name
endfunction

command! Docker call s:open_base_image()
