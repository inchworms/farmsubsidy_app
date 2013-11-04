require 'spec_helper'

describe "test the recipient methods" do

  it "find the correct name for the id" do
    expect(Recipient.name_for_id(2)).to eq("Bergmann Pavel")
  end

end