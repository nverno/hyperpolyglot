#!/usr/bin/env bash

# get resources:

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
pushd "$DIR">/dev/null

# files
files=("http://hyperpolyglot.org/")

# repos
declare -A repos=()

# get files
get_resource_files () {
    for f in ${files[@]}; do
        if [[ ! -f $(basename $f) ]]; then
            wget $f
        fi
    done
}

# get / update resource repos
get_resource_repos () {
    for repo in "${!repos[@]}"; do
        if [[ ! -d "${repos["$repo"]}" ]]; then
            git clone --depth 1 "$repo" "${repos["$repo"]}"
        else
            pushd "${repos["$repo"]}">/dev/null
            git pull --depth 1
            popd>/dev/null
        fi
    done
}

# ------------------------------------------------------------
# get stuff

if [ ! -f "../index.html" ]; then
    get_resource_files
    mv index.html ..
fi

get_resource_repos

popd>/dev/null

# Local Variables:
# sh-shell: bash
# End:
