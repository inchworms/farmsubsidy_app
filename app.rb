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
  @min_amount = params[:min] || 10000000
  @number_of_recipients = PaymentRecipientTotal.payment_over(@min_amount)[:children].length
  erb :treemap
end

get '/treemap.json' do
  PaymentRecipientTotal.payment_over(params[:min]).to_json
end

get '/payments_grouped' do
  @payments_grouped = PaymentRecipientTotal.payments_grouped
  erb :payments_grouped
end

get '/payments_grouped.json' do
  PaymentRecipientTotal.payments_grouped.to_json
end

get '/partition' do
  @number_of_recipients = PaymentRecipientTotal.payment_over(@min_amount)[:children].length
  erb :partition
end