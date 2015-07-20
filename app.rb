require 'uri'
require 'sinatra'
require 'sinatra/activerecord'
require 'tilt/erb' # removes warning about thread-safety
require './models/lists'
require './models/items'

# lets sinatra/activerecord know how to connect to our database
set :database, { adapter: 'mysql2', database: 'demo' }

get '/' do
  name = params["list_name"]
  if name && name.strip.length > 0
    redirect "/list/#{URI.encode(name)}"
  else
    @lists = Lists.limit(10).order("count desc").as_json
    erb :index
  end
end

get '/list/:list' do
  @list_name = params['list']
  @items = Items.where(:list_title => @list_name)
  if Lists.where(:title => @list_name).blank?
    list = Lists.new(:title => @list_name)
    list.save
  end
  erb :list
end

post '/list/:list' do |list_name|
  item = params["item"]
  if item && item.strip.length > 0 && list_name
    list = Lists.where(:title => list_name).first || Lists.new(:title => list_name)
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

get '/api/get/:list' do |list|
  '{"status":"failure","reason":"The list field is blank."}' if list.strip.length == 0

  Items.where(:list_title => list).to_json
end

delete '/api/:list/:id' do |list, id|
  '{"status":"failure","reason":"The list field is blank."}' if list.strip.length == 0
  '{"status":"failure","reason":"The id field is blank."}' if id.strip.length == 0
  "{\"status\":\"failure\",\"reason\":\"List #{list} does not exist.\"}" unless Lists.where(:title => list)
  "{\"status\":\"failure\",\"reason\":\"Id #{id} does not exist.\"}" unless Items.where(:id => id)

  begin
    item = Items.where(:id => id).first
    list = Lists.where(:title => list).first
    item.destroy
    list.count -= 1
    item.save
    list.save
    '{"status":"success"}'
  rescue
    status 500
    '{"status":"failure","reason":"You broke it."}'
  end
end

put '/api/:list/:item' do |list, item|
  '{"status":"failure","reason":"The list field is blank."}' if list.strip.length == 0
  '{"status":"failure","reason":"The item field is blank."}' if item.strip.length == 0

  begin
    item = Items.new(:list_title => list, :task => item)
    item.save
    list = Lists.where(:title => list).first || Lists.new(:title => list)
    list.count += 1
    list.save
    '{"status":"success"}'
  rescue
    status 500
    '{"status":"failure","reason":"You broke it."}'
  end
end
