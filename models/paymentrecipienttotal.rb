require 'json'
require 'sequel'


# Create a Total Payment model.
class PaymentRecipientTotal < Sequel::Model
  one_to_many :recipient
  one_to_many :payments

  def number
    self.count
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







