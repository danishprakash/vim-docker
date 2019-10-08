" define commands
command! -nargs=+ DockerTag     call docker#cmd#docker_tag(<f-args>)
command! -nargs=0 DockerDocOpen call docker#cmd#browse_reference()
command! -nargs=0 DockerHubOpen call docker#cmd#browse_base_image_docker_hub()
command! -nargs=1 DockerPush    call docker#cmd#docker_push(<f-args>)
command! -nargs=? DockerBuild   call docker#cmd#docker_build(<q-args>)
