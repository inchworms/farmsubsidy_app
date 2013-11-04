require 'spec_helper'
require 'database_cleaner'


describe "test the year methods" do

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
