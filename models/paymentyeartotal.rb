# Create a Total Payment model.
class PaymentYearTotal < Sequel::Model
  many_to_many :recipient
  many_to_many :year
  one_to_many :payments

  def number
    self.count
  end

end

