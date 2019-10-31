" Vim filetype plugin file
" Language:	    Dockerfile
" Maintainer:	Danish Prakash <https://danishprakash.github.io>
" Last Change:	2019 Oct 9

" define commands
command! -nargs=+ DockerTag         call docker#cmd#docker_tag(<f-args>)
command! -nargs=0 DockerDocBrowse   call docker#cmd#browse_reference()
command! -nargs=0 DockerHubBrowse   call docker#cmd#browse_base_image_docker_hub()
command! -nargs=1 DockerPush        call docker#cmd#docker_push(<f-args>)
command! -nargs=? DockerBuild       call docker#cmd#docker_build(<q-args>)
