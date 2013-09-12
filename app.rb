require 'rubygems'
require 'sinatra'
require 'sequel'
require 'sinatra/reloader' if development?

# connect to an in-memory database
DB = Sequel.postgres("farmsubsidy_performance")

# connect to the models
project_root = File.dirname(File.absolute_path(__FILE__))
Dir.glob(project_root + "/models/*.rb").each{|f| require f}


get '/' do
  @year = Year.year_for(8)
  @recipient = Recipient.all
  erb :top_payment
end

post '/search' do
  @name = params[:name]
  @results = Recipient[:name=>params[:name]]
  @payments = @results.payments
  erb :search
end

get '/:id' do
  @id = params[:id]
  @recipient = Recipient[params[:id]]
  erb :recipient
end