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
    top_payments = self.reverse_order(:amount_euro).limit(limit).all
    
    top_payments_hash = { name: "farmsubsidys",
                          amount_euro: self.total_payments_sum,
                          children: []}

    top_payments.each do |payment|
      top_payments_hash[:children] << 
                            {name: Recipient.where(id: payment[:recipient_id]).
                                            first[:name],
                             amount_euro: payment.amount_euro.to_i,
                            }
    end

    top_payments_hash[:children] << 
                            {name: "Rest",
                             amount_euro: self.total_payments_sum.to_i - self.reverse_order(:amount_euro).limit(limit).sum(:amount_euro).to_i,
                            }

    File.open("public/d3_data/temp.json","w") do |f|
      f.write(top_payments_hash.to_json)
    end
  end

  def self.payment_over(amount)

    # [#<PaymentRecipientTotal @values={:id=>1, :amount_euro=... ]
    top_payments = self.reverse_order(:amount_euro).where('amount_euro >= ?', amount).all

    top_payments_hash = { name: "farmsubsidys",
                          children: []}

    total_amount = 0

    top_payments.each do |payment|
      amount = payment.amount_euro.to_i
      top_payments_hash[:children] << 
                            {name: Recipient.where(id: payment[:recipient_id]).
                                            first[:name],
                             amount_euro: amount,
                            }
      total_amount += amount
    end

    # top_payments_hash[:children] << 
    #                         {name: "Rest",
    #                          amount_euro: self.total_payments_sum.to_i - total_amount
    #                         }
    top_payments_hash[:amount_euro] = total_amount
    p top_payments_hash
    top_payments_hash
  end



  def self.total_payments_sum
    self.all.inject(0.0) do |sum,payment|
      sum = sum + payment.amount_euro.to_i
      sum
    end
  end
end







