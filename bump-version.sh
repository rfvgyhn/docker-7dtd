#!/bin/bash

set -ex

[[ $1 =~ ^[0-9.]+$ ]] || { echo "First arg should be version" >&2; exit 1; }
[[ $2 =~ ^(stable)$ ]] || { echo "Invalid channel (stable)." >&2; exit 1; }

version=$1
channel=$2
commit_message="upgrade $channel to $version"

stable() {
    sed -i "s/^stable.*$/stable: $version/" version.txt
    sed -i "s|^\[4\].*|[4]: https://img.shields.io/badge/v-$version-blue|" README.md
}

echo "Version: $version"
echo "Channel: $channel"

if [[ $channel = "beta" ]]; then
    echo "not supported"
    #beta
elif [[ $channel = "stable" ]]; then
    stable
else
    #beta
    stable
    commit_message="upgrade to $version"
fi

git add version.txt README.md
git commit -m "$commit_message" || true
git tag "v${version}"
