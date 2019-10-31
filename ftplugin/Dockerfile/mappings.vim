" Vim mapping file
" Language:	    Dockerfile
" Maintainer:	Danish Prakash <https://danishprakash.github.io>
" Last Change:	2019 Oct 30

nnoremap <silent> <Plug>(docker-reference) :<C-u>call docker#cmd#browse_reference()<CR>
nnoremap <silent> <Plug>(docker-base-image) :<C-u>call docker#cmd#browse_base_image_docker_hub()<CR>
