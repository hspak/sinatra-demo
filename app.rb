require 'uri'
require 'sinatra'
require 'sinatra/activerecord'
require 'tilt/erb' # removes warning about thread-safety
require './models/lists'
require './models/items'

# lets sinatra/activerecord know how to connect to our database
set :database, { adapter: 'mysql2', database: 'demo' }

get '/' do
  @name = params["list_name"]
  if @name && @name.strip.length > 0
    redirect "/list/#{URI.encode(@name)}"
  else
    @lists = Lists.limit(10).order("count desc").as_json
    erb :index
  end
end

get '/list/:list' do
  @list_name = params['list']
  @items = Items.where(:list_title => @list_name)
  if Lists.where(:title => @list_name).blank?
    @list = Lists.new(:title => @list_name)
    @list.save
  end
  erb :list
end

post '/list/:list' do |list_name|
  item = params["item"]
  if item && list_name
    list = Lists.where(:title => list_name).first || List.new(:title => list_name)
    list.count += 1
    list.save
    Items.new(:list_title => list_name, :task => item).save
  end
  redirect "list/#{list_name}"
end

post '/rm/:list_name/:id' do |list_name, id|
  list = Lists.where(:title => list_name).first
  if id && list_name && list
    list.count -= 1
    list.save
    item = Items.where(:list_title => list_name, :id => id).first
    item.destroy
    item.save
  end
  redirect "list/#{list_name}"
end

get '/api/list' do
  Lists.all.to_json
end

get '/api/get/:list' do
  Lists.all.to_json
end

delete '/api/rm/:list/:item' do
  Lists.all.to_json
end
