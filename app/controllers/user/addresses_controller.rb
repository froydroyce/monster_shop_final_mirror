class User::AddressesController < User::BaseController
  before_action :get_address, only: [:edit, :update, :destroy]
  before_action :exclude_admin

  def index
    @user = current_user
  end

  def new
  end

  def create
    @user = current_user
    @address = current_user.addresses.new(address_params)
    if @address.save
      flash[:notice] = "New address for #{@address.address_name} has been created."
      if request.referer.include?("/profile/orders/new")
        redirect_to '/profile/orders/new'
      else
        redirect_to profile_addresses_path
      end
    else
      flash[:alert] = @address.errors.full_messages.to_sentence
      if request.referer.include?("/profile/orders/new")
        redirect_to "/profile/orders/new?#{address_params.to_param}"
      else
        render :new
      end
    end
  end

  def edit
    if @address.shipped_orders.empty?
      render :edit
    else
      flash[:alert] = "Address for #{@address.address_name} is used in an order that is shipped. Cannot be updated"
      redirect_to profile_addresses_path
    end
  end

  def update
    if @address.update(address_params)
      flash[:notice] = "Address for #{@address.address_name} has been updated."
      redirect_to profile_addresses_path
    else
      flash[:alert] = @address.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    if !@address.shipped_orders.empty?
      flash[:alert] = "Address for #{@address.address_name} is used in an order that is shipped. Cannot be deleted"
    elsif current_user.addresses.count == 1 && !@address.orders.empty?
      flash[:alert] = "Only one address on file. Please add another address and update your current orders to the new address before deleting"
    elsif !@address.orders.empty?
      flash[:alert] = "Please update orders using the address for #{@address.address_name} to a different address before deleting"
    else
      @address.destroy
      flash[:notice] = "Address for #{@address.address_name} has been removed."
    end
    redirect_to profile_addresses_path
  end

  private

  def address_params
    params.permit(:address_name, :address, :city, :state, :zip)
  end

  def get_address
    @address = Address.find(params[:id])
  end
end
