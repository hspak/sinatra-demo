# Sinatra Demo
### Basic todo list

## Setup
Install Ruby and Mysql. `setup.sh` exists to help, but is not meant to be dependable.

## To Run
    $ bundle exec rackup

## Routes
    /
    /list/:list

## API
    GET    /api/list
    GET    /api/get/:list
    PUT    /api/add/:list/:task
    DELETE /api/rm/:list/:id
