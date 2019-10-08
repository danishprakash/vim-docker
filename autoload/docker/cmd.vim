let s:docker_hub_base_url    = 'https://hub.docker.com/_/'
let s:docker_reference_url   = 'https://docs.docker.com/engine/reference/builder/#'

let s:supported_keyword = [
    \ 'ADD',
    \ 'ARG',
    \ 'CMD',
    \ 'COPY',
    \ 'ENTRYPOINT',
    \ 'ENV',
    \ 'EXPOSE',
    \ 'FROM',
    \ 'HEALTHCHECK',
    \ 'LABEL',
    \ 'MAINTAINER',
    \ 'ONBUILD',
    \ 'RUN',
    \ 'SHELL',
    \ 'STOPSIGNAL',
    \ 'USER',
    \ 'VOLUME',
    \ 'WORKDIR'
    \ ]

" browse base image on docker hub
function! docker#cmd#browse_base_image_docker_hub()
    if !s:check_filetype()
        echo 'vim-docker: filetype not Dockerfile'
        return
    endif

    let l:base_image = docker#util#get_base_image_name()
    if l:base_image == '0'
        echo 'vim-docker: `FROM` statement not found.'
        return
    endif

    let l:base_image = split(docker#util#get_base_image_name(), ':')
    let l:base_image_name = l:base_image[0]
    " let l:base_image_variant = len(l:base_image) > 1 ? l:base_image[1] : ''

    let l:base_image_url = s:docker_hub_base_url.l:base_image_name
    echo l:base_image_url
    call docker#util#open_external_link(l:base_image_url)
endfunction

" browse reference documentation on docker
function! docker#cmd#browse_reference()
    let l:keyword = expand('<cword>')
    if index(s:supported_keyword, l:keyword) < 0
        echo 'vim-docker: keyword not supported'
        return
    endif

    let l:reference_url = s:docker_reference_url . tolower(l:keyword)
    call docker#util#open_external_link(l:reference_url)
endfunction

" build current docker image asynchronously
function! docker#cmd#docker_build(image_name)
    let l:command_string = docker#util#get_cmd_string('build')
    
    " use label (-t) if specified by user
    if a:image_name != ''
        let l:command_string = add(l:command_string, '-t')
        let l:command_string = add(l:command_string, a:image_name)
    endif

    let s:status_prefix = 'build'

    let l:file_name = expand('%:p')
    let l:command_string = add(l:command_string, '-f')
    let l:command_string = add(l:command_string, l:file_name)

    " add context to build command
    let l:command_string = add(l:command_string, '.')
    let l:job_options = docker#job#get_job_options()

    echo l:command_string
    call docker#job#start_job(l:command_string, l:job_options)
endfunction

" push docker image
function! docker#cmd#docker_push(image_name)
    " check whether one arg is supplied
    if len(split(a:image_name, ' ')) > 1
        echo 'vim-docker: Exactly 1 argument is required'
        return
    endif

    let l:command_string = docker#util#get_cmd_string('push')
    let l:command_string = add(l:command_string, a:image_name)
    let l:job_options = docker#job#get_job_options()

    let s:status_prefix = 'push'
    call docker#job#start_job(l:command_string, l:job_options)
endfunction

" tag docker image
function! docker#cmd#docker_tag(image_name, tag_name)
    let l:command_string = docker#util#get_cmd_string('tag')
    let l:command_string = extend(l:command_string, [a:image_name, a:tag_name])
    let l:job_options = docker#job#get_job_options()

    let s:status_prefix = 'tag'
    call docker#job#start_job(l:command_string, l:job_options)
endfunction
