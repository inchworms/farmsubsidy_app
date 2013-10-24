require 'spec_helper'
require 'database_cleaner'

RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:transaction)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end

describe "test the year methods" do
  before(:each) do
    db = Sequel.postgres("farmsubsidy_test")
    year = db[:years]

    years_array = [2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012]
    years_array.each do |x|
      year.insert(
        year: [x]
      )
    end
  end

  it "find the year_id for the year" do
    expect(Year.id_for(2004)).to eq(1)
  end

  it "find the year for a year_id" do
    expect(Year.year_for(1)).to eq(2004)
  end

  it "full_range" do
    expect(Year.full_range.should eq(Year.first.year..Year.last.year))
  end
end

