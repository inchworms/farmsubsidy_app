require 'json'
require 'sequel'


# Create a Total Payment model.
class PaymentRecipientTotal < Sequel::Model
  one_to_one :recipient

  def number
    self.count
  end


  def self.array_for_treemap_highest_payments(limit)

    # [#<PaymentRecipientTotal @values={:id=>1, :amount_euro=... ]
    top_payments = self.all.order(:amount_euro)
    p top_payments

    # top_payments_hash = { name: "farmsubsidys",
    #                       amount_euro: self.total_payments_sum,
    #                       children: []}

    # top_payments.each do |payment|
    #   top_payments_hash[:children] << 
    #                         {name: Recipient.where(id: payment[:recipient_id]).
    #                                         first[:name],
    #                          amount_euro: payment.amount_euro.to_i,
    #                         }
    # end

    # File.open("public/d3_data/temp.json","w") do |f|
    #   f.write(top_payments_hash.to_json)
    # end
  end

  def self.total_payments_sum
    self.all.inject(0.0) do |sum,payment|
      sum = sum + payment.amount_euro.to_i
      sum
    end
  end
end







