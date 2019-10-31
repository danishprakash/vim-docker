# vim-docker
Docker development plugin for Vim

## Features
vim-docker adds Docker development support for Vim with support for the following features:

* Look up Dockerfile instructions with `:DockerDocBrowse`.
* Quickly open base Docker image with `:DockerHubBrowse`.
* Use `:DockerPush` to push Docker images asynchronously to specified registry.
* Easily build Docker images asynchronously with `:DockerBuild`.
* Tag Docker images with `:DockerTag`.
* Syntax highlighting for Dockerfile.
* Write Dockerfiles faster using snippets for commonly used instructions.

## Installation
vim-docker can be installed via the following plugin managers for Vim:

* [vim-plug](https://github.com/junegunn/vim-plug)
  * `Plug 'danishprakash/vim-docker'`
* [Vim 8 packages](http://vimhelp.appspot.com/repeat.txt.html#packages)
  * `git clone https://github.com/danishprakash/vim-docker.git ~/.vim/pack/plugins/start/vim-docker`
* [Pathogen](https://github.com/tpope/vim-pathogen)
  * `git clone https://github.com/danishprakash/vim-docker.git ~/.vim/bundle/vim-docker`
* [Vundle](https://github.com/VundleVim/Vundle.vim)
  * `Plugin 'danishprakash/vim-docker'`

## Usage

### Commands

- `:DockerDocBrowse`
    - Opens official Docker reference for the instruction under cursor using `open` or `xdg-open` on the default browser.
- `:DockerHubBrowse` 
    - Opens Docker hub page for the base image regardless of variant or version using `open` or `xdg-open` on the default browser.
- `:DockerPush`
    - Push Docker image to the specified registry using `jobs`.
    - Requires one argument - `image_name`.
    - Eg `:DockerPush <built_image>`
- `:DockerBuild`
    - Builds Docker image, uses image label specified by `-t`.
    - Eg `:DockerBuild -t <optional_label>`
- `:DockerTag`
    - Tags Docker image, accepts required arguments.
    - Eg `:DockerTag <built_image> <tag>`

### Extras

- Snippets
    - Snippets for most commonly used instructions while writing Dockerfiles quickly and easily.
- Internal Mappings
    - Non-problematic configuration using internal mappings.
- Syntax Highlighting

**Note**: vim-docker uses `job-control` for asynchronous processing and is still under active development.

## Contributing
Do you want to make this better? Open an issue and/or a PR on Github. Thanks!

## License

GPL-3.0 - see [`LICENSE`](LICENSE) for more details
