# Create a Year model.
class Year < Sequel::Model
  one_to_many :recipients

  def self.id_for(year)
    Year.where(year: year.to_i).first[:id]
  end

  def self.year_for(year_id)
    Year.where(id: year_id.to_i).first[:year]
  end
end


