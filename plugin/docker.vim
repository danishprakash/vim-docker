let g:docker_hub_base_url = 'https://hub.docker.com/_/'
let g:docker_reference_url = 'https://docs.docker.com/engine/reference/builder/#'

let g:supported_keyword = [
    \ 'FROM',
    \ 'RUN',
    \ 'CMD',
    \ 'LABEL',
    \ 'MAINTAINER',
    \ 'EXPOSE',
    \ 'ENV',
    \ 'ADD',
    \ 'COPY',
    \ 'ENTRYPOINT',
    \ 'VOLUME',
    \ 'USER',
    \ 'WORKDIR',
    \ 'ARG',
    \ 'ONBUILD',
    \ 'STOPSIGNAL',
    \ 'HEALTHCHECK',
    \ 'SHELL'
    \ ]

" TODO: create method to define all commands at once


function! s:check_filetype()
    if &ft == 'Dockerfile'
        return 1
    else
        return 0
    endif
endfunction


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
    if l:base_cmd_line_no == 0
        return 0
    endif

    let l:base_cmd = getline(l:base_cmd_line_no)
    let l:base_image_name = split(l:base_cmd, ' ')[1]

    " restore cursor position
    call cursor(l:previous_cursor_position[1], l:previous_cursor_position[2])

    return l:base_image_name
endfunction


" browse base image on docker hub
function! s:browse_base_image_docker_hub()
    if !s:check_filetype()
        echo 'vim-docker: filetype not Dockerfile'
        return
    endif

    let l:base_image = s:get_base_image_name()
    if l:base_image == '0'
        echo 'vim-docker: `FROM` statement not found.'
        return
    endif

    let l:base_image = split(s:get_base_image_name(), ':')
    let l:base_image_name = l:base_image[0]
    " let l:base_image_variant = len(l:base_image) > 1 ? l:base_image[1] : ''

    let l:base_image_url = g:docker_hub_base_url.l:base_image_name
    call s:open_external_link(l:base_image_url)
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

    call jobstart(l:open_executable . " " . a:final_url)
endfunction

command! DockerHubOpen call s:browse_base_image_docker_hub()

" browse reference documentation on docker
function! s:browse_reference()
    let l:keyword = expand('<cword>')
    if index(g:supported_keyword, l:keyword) < 0
        echo 'vim-docker: keyword not supported'
        return
    endif

    let l:reference_url = g:docker_reference_url . tolower(l:keyword)
    call s:open_external_link(l:reference_url)
endfunction

command! DockerDocOpen call s:browse_reference()


" TODO: use conditional logic here to check
" whether the build command succeeded successfully
" or not, figure out how to poll the same cmd again
" probably using job_id?
function! s:job_handler(job_id, data, event) dict
    if a:event == 'stdout' && a:data[0] != ''
        echo a:data[0]
    endif
endfunction


" build current docker image asynchronously
function! s:docker_build(image_name)
    let l:docker_file = ''
    if a:image_name == ''
        let l:docker_file = split(expand('%:t'), '\.')[0]
    else
        let l:docker_file = a:image_name
    endif
    
    " TODO: check whether you are in the correct dir or not
    " or use -f flag to point to the abs path for the
    " Dockerfile open in the current buffer
    let l:command_string = printf("docker build -t %s .", l:docker_file)
    echo l:command_string

    let l:job_args = {
        \ 'on_stdout': function('s:job_handler'),
    \ }
    call jobstart(l:command_string, l:job_args)
endfunction

command! -nargs=? DockerBuild call s:docker_build(<q-args>)
