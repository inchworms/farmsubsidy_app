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
    number.to_s.gsub(/\D/, '').reverse.gsub(/.{3}/, '\0\'').reverse.gsub(/^\'/, '')
  end
end

get '/' do
  if params[:name]
    @recipients = Recipient.where(Sequel.ilike(:name, "%#{params[:name]}%"))
  else
    @recipients = []
  end
  erb :index
end

get '/recipient/:id' do
  @recipient = Recipient[params[:id]]
  @year_table = @recipient.year_table
  erb :recipient
end

get '/ranked_per_year_per_payment' do
  @default_year = 2004
  if params[:year]
    @ranked_by_year = PaymentYearTotal.sortbyyear(params[:year])
  else
    @ranked_by_year = PaymentYearTotal.sortbyyear(@default_year)
  end
  erb :ranked_per_year_per_payment
end

get '/ranked_all_years_per_payment' do
  @ranked_total = PaymentYearTotal.sortbypayment
  erb :ranked_all_years_per_payment
end

get '/treemap' do
  PaymentYearTotal.treemap_array
  erb :treemap
end

get '/test' do
  @payment_total_treemap_array = PaymentYearTotal.treemap_array
  erb :test
end
