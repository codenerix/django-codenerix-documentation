#!/bin/bash

case $1 in
    clean)
        if [[ -e build ]] ; then
            echo "--- HTML: Cleaning ---"
            rm -R build
        fi
        if [[ -e docs ]] ; then
            echo "--- VERSIONING: Cleaning ---"
            rm -R docs
        fi
        ;;
    html)
        if [[ -e build ]] ; then
            echo "--- HTML: Cleaning ---"
            rm -R build
        fi
        echo "--- HTML: Building ---"
        make html
        ;;
    versions)
        if [[ -e docs ]] ; then
            echo "--- VERSIONING: Cleaning ---"
            rm -R docs
        fi
        echo "--- VERSIONING: Building ---"
        sphinx-versioning build -r master source/docs docs/_build/html
        ;;
        
    help)
        echo "Usage: $0 [clean|html|versions|all|help]"
        ;;
    *|all)
        echo "=== VERSIONS === ==========================================================="
        $0 versions
        echo
        echo "=== HTML === ==============================================================="
        $0 html

esac
