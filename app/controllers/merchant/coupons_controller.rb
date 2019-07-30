class Merchant::CouponsController < Merchant::BaseController
  def index
    @merchant = Merchant.find(current_user.merchant_id)
    @coupons = @merchant.coupons
  end
end
