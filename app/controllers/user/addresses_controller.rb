class User::AddressesController < User::BaseController
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

  private

  def address_params
    params.permit(:address_name, :address, :city, :state, :zip)
  end
end
