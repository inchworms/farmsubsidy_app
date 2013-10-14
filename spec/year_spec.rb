require 'spec_helper'

describe "find the year_id for a year" do
  it { Year.id_for(2004).should eq(1) }
end

describe "find the year for a year_id" do
  it { Year.year_for(1).should eq(2004) }
end

describe "full_range" do
  it { Year.full_range.should eq(Year.first.year..Year.last.year) }
end