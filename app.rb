require 'rubygems'
require 'sinatra'
require 'sequel'

get '/' do
  erb :bar
end