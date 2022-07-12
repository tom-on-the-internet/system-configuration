#! /usr/bin/env bash

# A script to quickly create a branch, add a commit, and push it up.

set -eo pipefail

current_branch=$(git rev-parse --abbrev-ref HEAD)

if [ "$current_branch" != master ] && [ "$current_branch" != main ]; then
  echo WARNING: YOU BRANCHED OF OFF "$current_branch", not main or master.
fi

if [ -z "$1" ]; then
  echo ERROR: Must have ticket prefix
  exit 1
fi

if [ -z "$2" ]; then
  echo ERROR: Must have description
  exit 1
fi

ticket_prefix=$1                                                            # ENG-123
description=$2                                                              # Fix duplication bug
kebab_name=$(echo "$description" | tr '[:upper:]' '[:lower:]' | tr ' ' '-') # fix-duplication-bug
commit_message="${ticket_prefix} ${description}"                            # ENG-123 Fix duplication bug

git checkout -b "$ticket_prefix"-"$kebab_name"
git add .
git commit -m "$commit_message"
git push -u origin "$ticket_prefix"-"$kebab_name"
