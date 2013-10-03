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

    top_payments_hash

  end

  def self.payment_over(amount)
    # set default value if amount == nil
    amount = 1000000 unless amount

    # [#<PaymentRecipientTotal @values={:id=>1, :amount_euro=... ]
    top_payments = self.reverse_order(:amount_euro).where('amount_euro >= ?', amount).all

    top_payments_hash = { name: "farmsubsidys",
                          children: []}

    top_payments.each do |payment|
      amount = payment.amount_euro.to_i
      top_payments_hash[:children] << 
                      {name: Recipient.name_for_id(payment.recipient_id),
                       amount_euro: amount,
                      }
    end

  end

  def self.payments_between(min,max)
    self.reverse_order(:amount_euro).
        where('amount_euro >= ?', min).
        where('amount_euro <  ?', max).
        all
  end

  def self.payments_between_as_hash(min,max)
    self.payments_between(min,max).map do |payment|
      { name: Recipient.name_for_id(payment.recipient_id),
        amount_euro: payment.amount_euro.to_i }
    end
  end

  def self.payments_grouped
    groups = [
      # { name: 'under 1 mio', min: 0.0, max: 1.0 },
      # { name: 'under 2 mio', min: 1.0, max: 2.0 },
      { name: 'under 5 mio', min: 2.0, max: 5.0 },
      { name: 'under 10 mio', min: 5.0, max: 10.0 },
      { name: 'under 20 mio', min: 10.0, max: 20.0 },
      { name: 'under 50 mio', min: 20.0, max: 50.0 },
      { name: 'over 50 mio',  min: 50.0, max: 70.0 }
    ]

    grouped_payments_hash = { name: "farmsubsidys",
                          children: []}

    groups.each do |group|
      child_hash = { name:     group[:name],
                     children: self.payments_between_as_hash(group[:min]*1_000_000,group[:max]*1_000_000) }
      grouped_payments_hash[:children] << child_hash
    end

    File.open("public/d3_data/payments_grouped.json","w") do |f|
      f.write(grouped_payments_hash.to_json)
    end
  end

  def self.total_payments_sum
    self.all.inject(0.0) do |sum,payment|
      sum = sum + payment.amount_euro.to_i
      sum
    end
  end
end







