let g:docker_hub_base_url = 'https://hub.docker.com/_/'

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


" browse base image on docker hub
function! s:browse_base_image_docker_hub()
    let l:base_image = split(s:get_base_image_name(), ':')
    let l:base_image_name = l:base_image[0]
    let l:base_image_variant = l:base_image[1]

    let l:final_url = g:docker_hub_base_url.l:base_image_name
    call s:open_external_link(l:final_url)
endfunction


" open final_url using `open` utility
function! s:open_external_link(final_url)
    if executable('xdg-open')
        let l:open_executable = 'xdg-open'
    elseif executable('open')
        let l:open_executable = 'open'
    else
        echoerr 'vim-docker: no `open` or equivalent command found.'
    endif

    call system(l:open_executable . " " . a:final_url)
endfunction

command! DockerHubOpen call s:browse_base_image_docker_hub()
