class Merchant::CouponsController < Merchant::BaseController
  before_action :get_merchant, only: [:index, :create]
  before_action :get_coupon, only: [:edit, :update, :disable, :enable]

  def index
    @coupons = @merchant.coupons
  end

  def new
    @coupon = Coupon.new
  end

  def create
    @coupon = @merchant.coupons.new(coupon_params)
    if @merchant.coupon_limit?
      flash[:alert] = "You cannot have more than 5 coupons"
      redirect_to merchant_coupons_path
    elsif @coupon.save
      flash[:notice] = "Coupon #{@coupon.name} has been created."
      redirect_to merchant_coupons_path
    else
      flash[:alert] = @coupon.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
  end

  def update
    if @coupon.update(coupon_params)
      redirect_to merchant_coupons_path
    else
      flash[:alert] = @coupon.errors.full_messages.to_sentence
      render :edit
    end
  end

  def disable
    @coupon.update(status: 1)
    redirect_to merchant_coupons_path
  end

  def enable
    @coupon.update(status: 0)
    redirect_to merchant_coupons_path
  end

  private

  def coupon_params
    params.permit(:name, :amount)
  end

  def get_merchant
    @merchant = Merchant.find(current_user.merchant_id)
  end

  def get_coupon
    @coupon = Coupon.find(params[:id])
  end
end
