require 'rubygems'
require 'sinatra'
require 'sequel'

# connect to an in-memory database
DB = Sequel.postgres("farmsubsidy_performance")

# connect to the models
project_root = File.dirname(File.absolute_path(__FILE__))
Dir.glob(project_root + "/models/*.rb").each{|f| require f}


get '/' do
  @recipient = Recipient.first
  erb :top_payment
end