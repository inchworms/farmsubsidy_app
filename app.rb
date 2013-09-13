require 'rubygems'
require 'sinatra'
require 'sequel'
require 'sinatra/reloader' if development?
require 'logger'

# connect to an in-memory database

DB = Sequel.postgres("farmsubsidy_development", :loggers => [Logger.new($stdout)])


# connect to the models
project_root = File.dirname(File.absolute_path(__FILE__))
Dir.glob(project_root + "/models/*.rb").each{|f| require f}


get '/' do
  if params[:name]
    @recipients = Recipient.where(Sequel.ilike(:name, "%#{params[:name]}%"))
  else
    @recipients = Recipient.all
  end
  erb :index
end

get '/recipient/:id' do
  @recipient = Recipient[params[:id]]
  @payments = Payment.where(:recipient_id => params[:id])
  erb :recipient
end

get '/ranked' do
  if params[:year]
    @ranked = PaymentYearTotal.sortbyyear(params[:year])
  else
    @ranked = PaymentYearTotal.sortbyyear(2007)
  end
  erb :ranked
end


