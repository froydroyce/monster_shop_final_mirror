class User::AddressesController < ApplicationController
  def index
    @user = current_user
  end
end
