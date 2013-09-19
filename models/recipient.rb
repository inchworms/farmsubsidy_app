# Create a Recipients model.
class Recipient < Sequel::Model
  one_to_many :payments

  def total_payments_by_recipient(recipient_id)
    beginning = Time.now
    # find payments by recipient
    recipient_payments = Payment.where(recipient_id: recipient_id)

    #add the payments together
    total_recipient_payments = 0
    recipient_payments.each do |payment|
      total_recipient_payments += payment
    end
  end

  def total_payment_amount
    self.payments.inject(0.0) do |sum,payment|
      sum = sum + payment.amount_euro
    end
  end

  def total_payment_amount_per_year(year)
    all_payments = Payment.where(year_id: Year.id_for(year)).
             where(recipient_id: self.id).all
    all_payments.inject(0.0) do |sum,payment|
      sum = sum + payment.amount_euro 
    end
  end
  
  def year_table
    # [[2009, '2324'],[2010, '2324,00']]
    payments_sorted = self.payments.sort_by { |payment| payment[:year_id] }
    payment_amount_year_array = []
    payments_sorted.each do |payment| 
      payment_amount_year_array << [ payment.date, payment.amount_euro.to_i ]
    end
    payment_amount_year_array
  end

end
