class PurchasesController < ApplicationController

  def show
    @purchase = Purchase.find(params[:id])
  end

  def last
    @purchase = Purchase.where(list: params[:list]).order(created_at: :desc).first
  end

  def toggle_bought
    purchase_ids = params[:ids]

    purchase_ids.each do |id|
      purchase = Purchase.find_by(id: id)
      purchase.purchase_date = Time.now
      purchase.save
    end

    redirect_to :back
  end

  def create
    shopping_list = List.find_by(id: params[:list])
    product = Product.find_by(name: params[:product].downcase)
    amount = params[:amount]

    if product.nil?
      product = Product.create(name: params[:product])
    end

    @purchase = Purchase.new
    @purchase.product = product
    @purchase.list = shopping_list
    @purchase.amount = amount

    @purchase.save

    redirect_to :back
  end
end