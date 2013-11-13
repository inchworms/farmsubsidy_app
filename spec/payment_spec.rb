require 'spec_helper'

describe "test the payment methods" do

  it "get the date for the payment" do
    expect(Payment.find(:year_id => 7 ).date).to eq(2010)
  end

  it "get the amount of payment" do
    expect(Payment.number).to eq(9)
  end

  it "get sorted payment of a year" do
    expect(Payment.sorted(2010, 5).count).to eq(5)
    expect(Payment.sorted(2010, 5).first.year_id).to eq(7)
    expect(Payment.sorted(2010, 5)[0].amount_euro).to be > Payment.sorted(2010, 5)[1].amount_euro
  end
end