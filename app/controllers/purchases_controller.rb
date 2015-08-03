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

    respond_to do |format|
        format.html { redirect_to :back, notice: 'List was successfully updated.' }
        format.json { redirect_to :back }
    end
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

    respond_to do |format|
      if @purchase.save
        format.html { redirect_to @purchase.list, notice: 'Purchase was successfully added.' }
        format.json { render :show, status: :created, location: @purchase.list }
      else
        format.html { render :new }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end
end