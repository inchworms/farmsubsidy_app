require 'spec_helper'

describe "test the payment methods" do
  before(:each) do
    @payment = Payment.new(:year_id => "1")
  end

  it "get the date for the payment" do
    expect(@payment.date()).to eq(2004)
  end

end