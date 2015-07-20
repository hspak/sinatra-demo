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
brew install mysql

bundle install

mysql.server start
mysql -u root -e "create databases demo;"

# rake db:create_migration NAME="create_lists"
# rake db:create_migration NAME="create_items"
