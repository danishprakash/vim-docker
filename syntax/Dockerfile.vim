" Vim syntax file
" Language:	    Dockerfile
" Maintainer:	Danish Prakash <https://danishprakash.github.io>
" Last Change:	2019 Oct 10

" Don't bother if custom syntax is already set
if exists("b:current_syntax")
    finish
endif

" Instructions
syntax keyword DockerfileKeywords FROM AS MAINTAINER RUN CMD COPY
syntax keyword DockerfileKeywords EXPOSE ADD ENTRYPOINT
syntax keyword DockerfileKeywords VOLUME USER WORKDIR ONBUILD
syntax keyword DockerfileKeywords LABEL ARG HEALTHCHECK SHELL STOPSIGNAL

" Strings
syntax region DockerfileString    start=+\v"+ skip=+\v"+ end=+\v"+
syntax region DockerfileCharacter start=+\v'+ skip=+\v'+ end=+\v'+

" Comment
syntax match DockerfileComment "\v^#.*$"

" Highlighting
hi link DockerfileKeywords   Keyword
hi link DockerfileString     String
hi link DockerfileCharacter  String
hi link DockerfileComment    Comment

let b:current_syntax = "Dockerfile"
