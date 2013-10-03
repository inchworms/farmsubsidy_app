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

    # File.open("public/d3_data/temp.json","w") do |f|
    #   f.write(top_payments_hash.to_json)
    # end
  end

  def self.payment_over(amount)
    # set default value if amount == nil
    amount = 1000000 unless amount

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
  end

  def self.payment_between(min,max)
    payments = self.reverse_order(:amount_euro).
                    where('amount_euro >= ?', min).
                    where('amount_euro <  ?', max).
                    all
  end

  def self.payment_over_parent(min_amount)
    # set default value if min_amount == nil
    min_amount = 4_000_000 unless min_amount.to_i
    limit = 30

    # [#<PaymentRecipientTotal @values={:id=>1, :amount_euro=... ]
    top_payments = self.reverse_order(:amount_euro).where('amount_euro >= ?', min_amount).limit(limit).all

    top_payments_hash = { name: "farmsubsidys",
                          children: []}
    total_amount = 0

    top_payments_hash[:children] << { name: "under_50_000_000", children: [] }
    top_payments_hash[:children] << { name: "50_000_000", children: []}
    top_payments_hash[:children] << { name: "60_000_000", children: [] }
    top_payments_hash[:children] << { name: "more_than_60_000_000", children: []}

    # {:name=>"farmsubsidys", :children=>[{:name=>"under_50_000_000", :children=>[]}, {:name=>"50_000_000", :children=>[]}, {:name=>"60_000_000", :children=>[]}, {:name=>"more_than_60_000_000", :children=>[]}]}
    # p top_payments_hash

    top_payments.each do |payment| 
        if payment.amount_euro > 60_000_000
            # füge zu dem top_payments_hash[:children] mit dem richtigem
            # name das payment dazu
            p top_payments_hash[:children]
            p top_payments_hash[:children].class
        end
    end
                
    #     top_payments_hash[:children].each do |special_amount|
    #         special_amount[:children].each do |payment|
    #             payment << {name: Recipient.where(id: top_payments[:recipient_id]).
    #                                            first[:name],
    #                             amount_eu: top_paamount
    #                            }
    #         end
    # end

    # result[:children] << "test"

    # top_payments.each do |payment|
      # amount = payment.amount_euro.to_i

      # if amount < 50_000_000
        # top_payments_hash[:children] << { name: "under_50_000_000", children: []}
        # top_payments_hash[:children][0][:children] << 
        #                       {name: Recipient.where(id: payment[:recipient_id]).
        #                                       first[:name],
        #                        amount_euro: amount
        #                       }
    #   elsif amount < 60_000_000 && amount >= 50_000_000
    #     top_payments_hash[:children] << { name: "50_000_000", children: []}
    #     # top_payments_hash[:children][1][:children] << 
    #     #                       {name: Recipient.where(id: payment[:recipient_id]).
    #     #                                       first[:name],
    #     #                        amount_euro: amount
    #     #                       }
    #   elsif amount < 70_000_000 && amount >= 60_000_000
    #     top_payments_hash[:children] << { name: "60_000_000", children: []}
    #     # top_payments_hash[:children][2][:children] << 
    #     #                       {name: Recipient.where(id: payment[:recipient_id]).
    #     #                                       first[:name],
    #     #                        amount_euro: amount
    #     #                       }
    #   else
    #     top_payments_hash[:children] << { name: "more_than_60_000_000", children: []}
    #   end
      File.open("public/d3_data/test1.json","w") do |f|
        f.write(top_payments_hash.to_json)
      end


    # end
    #   elsif amount < 3000000 && amount >= 2000000
    #     top_payments_hash[:children][:children] << 
    #                           {name: Recipient.where(id: payment[:recipient_id]).
    #                                           first[:name],
    #                            amount_euro: amount,
    #                           }
    #     top_payments_hash[:children] << {name: "twomillion", children: []}
    #     top_payments_hash[:children][:children] << 
    #                           {name: Recipient.where(id: payment[:recipient_id]).
    #                                           first[:name],
    #                            amount_euro: amount,
    #                           }
    #   elsif amount < 4000000 && amount >= 3000000
    #     top_payments_hash[:children][:children] << 
    #                           {name: Recipient.where(id: payment[:recipient_id]).
    #                                           first[:name],
    #                            amount_euro: amount,
    #                           }
    #     top_payments_hash[:children] << {name: "threemillion", children: []}
    #   else
    #     top_payments_hash[:children] << {name: "overfourmillion", children: []}
    #     top_payments_hash[:children][:children] << 
    #                           {name: Recipient.where(id: payment[:recipient_id]).
    #                                           first[:name],
    #                            amount_euro: amount,
    #                           }
    #   end

    #   total_amount += amount
    # end

    # # top_payments_hash[:children] << 
    # #                         {name: "Rest",
    # #                          amount_euro: self.total_payments_sum.to_i - total_amount
    # #                         }
    # top_payments_hash[:amount_euro] = total_amount

    # top_payments_hash
    # File.open("public/d3_data/test1.json","w") do |f|
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







