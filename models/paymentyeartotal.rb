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
  def self.sortbyyear(year)
    #year = 2007
    limit = 10
    
    #find all payments by year, sort, and return limit.
    top_payments_sorted_dataset = self.where(year_id: Year.id_for(year)).
              reverse_order(:amount_euro).
              limit(limit).
              all

    top_payments_sorted_array = []

    top_payments_sorted_dataset.each_with_index do |payment, index|
      recipient_name = Recipient.where(id: payment[:recipient_id]).first[:name].gsub("\"", "")
      top_payments_sorted_array << {rank:   index+1, 
                                    name:   recipient_name, 
                                    amount: payment[:amount_euro].to_i}
    end

    top_payments_sorted_array.to_json
  end

  def self.sortbypayment
    limit = 20

    top_payments_sorted_dataset = self.reverse_order(:amount_euro).limit(limit).all

    top_payments_sorted_array = []

    top_payments_sorted_dataset.each_with_index do |payment, index|
      recipient_name = Recipient.where(id: payment[:recipient_id]).first[:name].gsub("\"", "")
      year = Year.where(id: payment[:year_id]).first[:year]
      top_payments_sorted_array << {rank:   index+1, 
                                    name:   recipient_name, 
                                    amount: payment[:amount_euro].to_i, year: year}
    end

    top_payments_sorted_array.to_json
  end

  def self.array_for_treemap_with_20_highest_payments
    # just for testing purposes
    limit = 20

    # [#<PaymentYearTotal @values={:id=>1, :amount_euro=... ]
    top_payments = self.limit(limit).all

    top_payments_hash = { name: "farmsubsidys",
                          amount_euro: self.total_payments_sum(limit),
                          children: []}

    top_payments.each do |payment|
      top_payments_hash[:children] << 
                            {name: Recipient.where(id: payment[:recipient_id]).first[:name].gsub("\"", ""),
                             amount_euro: payment.amount_euro.to_i,
                             year: Year.year_for(payment.year_id)
                            }
    end

    File.open("public/d3_data/temp.json","w") do |f|
      f.write(top_payments_hash.to_json)
    end
  end

  def self.total_payments_sum(limit)
    self.limit(limit).all.inject(0.0) do |sum,payment|
      sum = sum + payment.amount_euro.to_i
      sum
    end
  end
end







