# Create a Year model.
class Year < Sequel::Model
  one_to_many :recipients

  def self.id_for(year)
    Year.where(year: year.to_i).first[:id]
  end
end


