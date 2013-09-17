require 'rubygems'
require 'sinatra'
require 'sequel'
require 'sinatra/reloader' if development?
require 'logger'

# connect to an in-memory database
DB = Sequel.postgres("farmsubsidy_development")

# connect to the models
project_root = File.dirname(File.absolute_path(__FILE__))
Dir.glob(project_root + "/models/*.rb").each{|f| require f}

helpers do
  def format_large_number(number)
    number.to_s.gsub(/\D/, '').reverse.gsub(/.{3}/, '\0.').reverse.gsub(/^\./, '')
  end
end

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
  erb :recipient
end

get '/ranked' do
  if params[:year]
    @ranked_by_year = PaymentYearTotal.sortbyyear(params[:year])
  else
    @ranked_by_year = PaymentYearTotal.sortbyyear(2007)
  end
  erb :ranked
end

get '/ranked_total' do
  @ranked_total = PaymentYearTotal.sortbypayment
  erb :ranked_total
end


