require 'sinatra'
require 'sinatra/activerecord'
require 'tilt/erb' # removes warning about thread-safety
require './models/lists'
require './models/items'

# lets sinatra/activerecord know how to connect to our database
set :database, { adapter: 'mysql2', database: 'demo' }

get '/' do
  @list = Lists.all
  erb :index
end

get '/all' do
  erb :index
end

get '/new' do
  @list = Lists.new(:title => "new")
  @list.save
end

get '/list/:list' do
  list = params['list']
  # query = "select task from items where list_title = '#{list}'"
  # @items = ActiveRecord::Base.connection.execute(query)
  @items = Items.where(:list_title => list)
  erb :list
end

get '/api/get/:list' do
  Lists.all.to_json
end

put '/api/add/:list/:item' do
  list = params['list']
  Lists.all.to_json
end

delete '/api/rm/:list/:item' do
  Lists.all.to_json
end
