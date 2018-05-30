#!/usr/bin/env bash
# A re-write of GNU stow in pure bash
# TODO: add help, add simulate function, add force option

# Variables
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
stowDir="$DIR"
targetDir="$HOME" # This is different from stow's default "parent dir"

# Help
_usage() {
    cat <<EOH
USAGE:
    "$(basename $0)" [OPTION ...] [-D|-S|-R] PACKAGE ... [-D|-S|-R] PACKAGE ...

OPTIONS:
    -d DIR, --dir DIR     Set stow dir to DIR (default is current dir)
    -t DIR, --target DIR  Set target to DIR (default is parent of stow dir)

    -S, --stow            Stow the package names that follow this option
    -D, --delete          Unstow the package names that follow this option
    -R, --restow          Restow (like stow -D followed by stow -S)

    -h, --help            Show this help

Report bugs at https://www.github.com/eddyyousef/stow.sh
EOH
}





# Parse CLI input
_parse_input() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -d|--dir)
                        stowDir="$2"
                        shift ;;
            -t|--target)
                        targetDir="$2"
                        shift ;;
            -S|--stow)
                        # default operation if none provided
                        operation="stow" ;;
            -D|--delete)
                        operation="delete" ;;
            -R|--restow)
                        operation="restow" ;;
            -h|--help)
                        _usage && exit 0 ;;
        esac
        shift
    done
}
_parse_input "$@"



            

