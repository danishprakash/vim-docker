let s:status_prefix = ''
let s:vim_docker_echo_prefix = 'vim-docker'

" return neovim options for jobstart()
function! docker#job#get_job_options()
    let l:file_dir = expand('%:h')

    " make sure file dir is valid
    if !isdirectory(l:file_dir)
        return
    endif

    let l:job_options = {
                \ 'on_exit': function('docker#job#on_exit_callback'),
                \ 'on_stdout': function('docker#job#on_exit_callback'),
                \ 'cwd': l:file_dir
                \ }

    return l:job_options
endfunction

" echo build status after job completion
function! docker#job#on_exit_callback(job_id, data, event)
    let l:build_status = ''
    let l:build_echo_prefix = '[build]'
    let l:build_echo_prefix = '[' . s:status_prefix . ']'

    " echo response based on exit code
    if a:event == 'exit' && a:data[0] != ''
        if a:data == 0
            let l:build_status = 'SUCCESS'
        else
            let l:build_status = 'FAILED'
        endif
        echo printf('%s: %s %s', s:vim_docker_echo_prefix, l:build_echo_prefix, l:build_status)
    endif
endfunction

" start neovim job
function! docker#job#start_job(command_string, job_options)
    let l:job_id = jobstart(a:command_string, a:job_options)
endfunction

function! s:check_filetype()
    if &ft == 'Dockerfile'
        return 1
    else
        return 0
    endif
endfunction

