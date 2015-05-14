require 'rails_helper'

describe "Purchase" do
  let(:purchase){FactoryGirl.create(:purchase)}

  it "is valid with a list and a product" do
    expect(purchase).to be_valid
  end

  describe "is not valid if it" do
    it "has no list" do
      another_purchase = FactoryGirl.build(:purchase, list: nil)
      doubt(another_purchase)
    end

    it "has no product" do
      another_purchase = FactoryGirl.build(:purchase, product: nil)
      doubt(another_purchase)
    end
  end
end

def doubt(pch)
  expect(pch).not_to be_valid
  pch.save
  expect(Purchase.count).to eq(0)
end