#!/usr/bin/env bash
# A re-write of GNU stow in pure bash
# TODO: add help, add simulate function, add force option

# Variables
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
stowDir="$DIR"
targetDir="$HOME" # This is different from GNU stow default parent dir
operation="stow"

# Help
_usage() {
    cat <<EOH
USAGE:
    $(basename $0) [OPTION ...] [-D|-S|-R] PACKAGE ...

OPTIONS:
    -d DIR, --dir DIR     Set stow dir to DIR (default is current dir)
    -t DIR, --target DIR  Set target to DIR (default is parent of stow dir)

    -S, --stow            Stow the package names that follow this option
    -D, --delete          Unstow the package names that follow this option
    -R, --restow          Restow (like stow -D followed by stow -S)

    -v, --verbose         Be verbose
    -h, --help            Show this help

Report bugs at https://www.github.com/adnanyousef/stow.sh
EOH
}



_say() {
    if [[ "$verbose" = "yes" ]]; then
        echo "$@"
    fi
}

_abort() {
    echo "ERROR: package $1 already exists. No operations performed."
    break
}

_test_exist() {
    local file="$1"
    if [[ -L "$file" ]]; then
        # if destination exists but is a symlink, perform operation
        return 0
    elif [[ -e "$file" ]]; then
        return 1
    fi
}



# Stow (create symlinks for PACKAGE/* to ~/.*)
_stow() {
    for p in ${packages[@]}; do
        _test_exist "${targetDir}/.${p}" || _abort $p
        ln -s "${stowDir}/${p}" "${targetDir}/.${p}"
        _say "Created link: $p --> ~/.${p}"
    done
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
            *)
                        packages+=( "$1" ) ;;
        esac
        shift
    done
}
_main() {
    if [[ -z "$packages" ]]; then
        echo "No packages provided. See $(basename $0) -h for usage."
        exit 1
    fi

    if [[ "$operation" = "stow" ]]; then
        _stow 
    elif [[ "$operation" = "delete" ]]; then
        _delete 
    elif [[ "$operation" = "restow" ]]; then
        _restow
    else
        echo "Error. Report this to github: adnanyousef/stow.sh"; exit
    fi
}

_parse_input "$@"
_main
            

