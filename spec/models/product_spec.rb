require 'rails_helper'

describe "Product" do
  let(:product){FactoryGirl.create(:product)}

  it "is valid with name" do
    expect(product).to be_valid
    expect(Product.count).to eq(1)
  end

  it "is not valid without a name" do
    another_product = FactoryGirl.build(:product, name: nil)
    expect(another_product).not_to be_valid
    another_product.save
    expect(Product.count).to eq(0)
  end

  it "is not valid if another product with the same name is already in db" do
    product.save
    another_product = FactoryGirl.build(:product)
    expect(another_product).not_to be_valid
    another_product.save
    expect(Product.count).to eq(1)
  end
end