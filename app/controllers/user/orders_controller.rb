class User::OrdersController < User::BaseController
  before_action :exclude_admin

  def index
    @orders = current_user.orders
  end

  def show
    @order = current_user.orders.find(params[:id])
    @user = current_user
    @address = @order.address
  end

  def new
    @user = current_user
    @order = Order.new
  end

  def create
    address = current_user.find_address_by_name(order_params[:address_id]).first
    order = current_user.orders.new(address_id: address.id)
    order.save
      cart.items.each do |item|
        order.order_items.create({
          item: item,
          quantity: cart.count_of(item.id),
          price: item.price
          })
      end
    session.delete(:cart)
    flash[:notice] = "Order created successfully!"
    redirect_to '/profile/orders'
  end

  def update
    address = current_user.find_address_by_name(address_params[:address_id]).first
    order = Order.find(params[:id])
    if order.pending?
      order.update(address_id: address.id)
      flash[:notice] = "Shipping address updated."
    else
      flash[:alert] = "Order has been #{order.status}. Address cannot be changed"
    end
    redirect_to "/profile/orders/#{order.id}"
  end

  def cancel
    order = current_user.orders.find(params[:id])
    order.cancel
    redirect_to "/profile/orders/#{order.id}"
  end

  private

  def order_params
    params.require(:order).permit(:address_id)
  end

  def address_params
    params.permit(:address_id)
  end
end
