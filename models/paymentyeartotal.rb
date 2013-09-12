require 'json'
require 'sequel'


# Create a Total Payment model.
class PaymentYearTotal < Sequel::Model(:payment_year_totals)
  many_to_many :recipient
  many_to_many :year
  one_to_many :payments

  def number
    self.count
  end

  #method to find the top payments (including recipients) by year
  #write this to a JSON file
      #album = Album[1]
      #album.to_json
      # => '{"json_class"=>"Album","id"=>1,"name"=>"RF","artist_id"=>2}'

  def sortbyyear
    year = 2007
    top_number = 20
    
    payments_sorted = PaymentYearTotal.sorted(year, top_number)

    top_payments = []

    payments_sorted.each_with_index do |payment, index|
      recipient_name = Recipient.where(id: payment[:recipient_id]).first[:name].gsub("\"", "")
      top_payments << {rank: index+1, name: recipient_name, amount: payment[:amount_euro]}
    end
  @json_top_payments = top_payments.to_json
  end
end





