#!/bin/bash

os=$(uname)
if [[ "$os" == "Darwin\n" ]]; then
  printf "error: not OS X, bailing GLHF\n"
  exit 1
fi

which brew
if (( $? != 0 )); then
  printf "error: brew is not install, please install (http://brew.sh)\n"
  exit 1
fi

brew install ruby
brew install postgres

bundle install

# mysql
# initdb /usr/local/var/postgres
# /usr/local/bin/postgres -D /usr/local/var/postgres >> db.log 2>&1 &

# createdb "demo"

# rake db:create_migration NAME="create_lists"
# rake db:create_migration NAME="create_items"
