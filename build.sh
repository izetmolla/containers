#!/bin/bash

for dir in $(find . -maxdepth 2 -type d ! -name '.*' ! -path '*/.*'); do
    if [ -f "$dir/Dockerfile" ]; then
        imgstr=$(echo "${dir#./}" | tr / :)
        docker build "${dir#./}"/ -t izetmolla/$imgstr 
        docker push izetmolla/$imgstr 
    fi
done
