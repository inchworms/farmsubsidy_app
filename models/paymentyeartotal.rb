require 'json'
require 'sequel'


# Create a Total Payment model.
class PaymentYearTotal < Sequel::Model
  many_to_many :recipient
  many_to_many :year
  one_to_many :payments

  def number
    self.count
  end

  #method to find the top payments by recipient by year
  def self.sortbyyear
    year = 2007
    limit = 20
    
    #find all payments by year, sort, and return limit.
    top_payments_sorted = self.where(year_id: Year.id_for(year)).
              reverse_order(:amount_euro).
              limit(limit).
              all

    top_payments_ranked = []

    top_payments_sorted.each_with_index do |payment, index|
      recipient_name = Recipient.where(id: payment[:recipient_id]).first[:name].gsub("\"", "")
      top_payments_ranked << {rank: index+1, name: recipient_name, amount: payment[:amount_euro].to_i}
    end
  @json_top_payments_ranked = top_payments_ranked.to_json
  end
end





