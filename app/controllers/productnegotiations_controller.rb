class ProductnegotiationsController < ApplicationController
  before_action :set_product_negotiation, only: [:show]
  before_action :set_single_bids, only: [:show]
  before_action :authorize_buyer_seller, only: [:show]
  before_action :get_product_negotiations, only: [:new]
  before_action :buyer_and_seller,  only: [:show]

  def index
    @product_negotiation = ProductNegotiation.all
  end

  def show
    @current_negotiation_bids = ProductNegotiation.get_bids_from_current_negotiation(@single_bids, params).sort_by &:created_at

  end

  def new
    redirect_if_negotiation_already_exists

    if (@already_redirected == false)
      product_negotiation = ProductNegotiation.new
      product_negotiation.update_attributes(product_id: params[:format], user_id: current_user.id)
      product_negotiation.save
      redirect_to productnegotiation_path(product_negotiation.id), notice: "Succesfully created a new negotiation"
    end
  end

  def create
  end

  def update
    @productnegotiation = ProductNegotiation.find(params[:id])
    @productnegotiation.update_attribute(:active, false)

      redirect_to productnegotiations_path, notice: "Negotiation closed"


  end

  def destroy
  end

  private

    def set_product_negotiation
      @product_negotiation = ProductNegotiation.find(params[:id])
    end

    def set_single_bids
      @single_bids = SingleBid.all
    end

    def authorize_buyer_seller
      # if current_user id is equal to Product owner or Product bidder, ok to continue, otherwise not.
      redirect_to product_path, notice: "Sorry, you can't see other peoples negotiations" unless (current_user.id == @product_negotiation.user.id) || (current_user.id == @product_negotiation.product.user_id)
    end

    def get_product_negotiations
      @product_negotiations = ProductNegotiation.all
    end


    def redirect_if_negotiation_already_exists
      # redirect to negotiation if Buyer already has a negotiation for this product
      @already_redirected = false
      found_negotiation = current_user.product_negotiations.find do |negotiation|
        negotiation.product_id == params[:format].to_i
      end
      redirect_to productnegotiation_path(found_negotiation.id), notice: "You already have a negotiation for this product" unless found_negotiation == nil
      @already_redirected = true unless found_negotiation == nil
    end

    def buyer_and_seller
      @buyer = User.find(@product_negotiation.user.id)
      @seller = User.find(@product_negotiation.product.user_id)
    end
end
