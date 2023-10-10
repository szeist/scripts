#!/bin/bash

source "${HOME}/.todo/config"

cd $TODO_DIR

git pull --rebase
git add .
git commit -m "update from ${HOST}"
git push
