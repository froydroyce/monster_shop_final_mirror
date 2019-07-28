class User::AddressesController < User::BaseController
  before_action :get_address, only: [:edit, :update, :destroy]

  def index
    @user = current_user
  end

  def new
    @address = current_user.addresses.new
  end

  def create
    @address = current_user.addresses.new(address_params)
    if @address.save
      flash[:notice] = "New address for #{@address.address_name} has been created."
      redirect_to profile_addresses_path
    else
      flash[:alert] = @address.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
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
    @address.destroy
    flash[:notice] = "Address for #{@address.address_name} has been removed."
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
