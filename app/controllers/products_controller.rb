class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :update, :destroy]
  before_action :set_products

  def index
  end

    def show
        @product = Product.find(params[:id])
     end


  def create
  end

  def update
  end

  def destroy
  end

  private
  def set_product
    @product = Product.find(params[:id])
  end

  def set_products
      @products = Product.all
    end



end
