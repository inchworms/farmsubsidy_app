require 'rubygems'
require 'sinatra'
require 'sequel'

get '/' do
  erb :top_payment
end