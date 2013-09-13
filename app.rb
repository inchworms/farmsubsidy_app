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
  if params[:name]
    @recipients = Recipient.where(Sequel.like(:name, "%#{params[:name]}%"))
  else
    @recipients = Recipient.all
  end
  erb :index
end

get '/search' do
  erb :search
end

get '/:id' do
  @id = params[:id]
  @recipient = Recipient[params[:id]]
  erb :recipient
end