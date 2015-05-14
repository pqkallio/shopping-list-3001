require 'rails_helper'

describe "List" do
  let(:list){FactoryGirl.create(:list)}

  it "is valid if it has a user" do
    expect(list).to be_valid
    list.save
    expect(List.count).to eq(1)
  end

  it "is not valid if it doesn't have a user" do
    another_list = FactoryGirl.build(:list, user: nil)

    expect(another_list).not_to be_valid
    another_list.save
    expect(List.count).to eq(0)
  end

  it "has no purchases in the beginning" do
    expect(list.purchases.count).to eq(0)
  end

  it "has one purchase when one purchase is added" do
    list.purchases << Purchase.create(product: FactoryGirl.create(:product))

    expect(list.purchases.count).to eq(1)
  end

  it "has two purchases when two purchases are added" do
    list.purchases << Purchase.create(product: FactoryGirl.create(:product))
    list.purchases << Purchase.create(product: FactoryGirl.create(:product2))

    expect(list.purchases.count).to eq(2)
  end
end