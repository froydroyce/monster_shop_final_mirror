require 'rails_helper'

RSpec.describe Address do
  describe 'validations' do
    it {should validate_presence_of :address_name}
    it {should validate_presence_of :address}
    it {should validate_presence_of :city}
    it {should validate_presence_of :state}
    it {should validate_presence_of :zip}
  end

  describe 'relations' do
    it {should belong_to :user}
    it {should have_many :orders}
  end

  describe 'instance_methods' do
    before(:each) do
      @user = User.create!(name: 'Megan', email: 'megan@example.com', password: 'securepassword')
      @user_home_address = @user.addresses.create!(address_name: "Home", address: "1234 Main st", city: "Denver", state: "CO", zip: 80229)
      @user_work_address = @user.addresses.create!(address_name: "Work", address: "1789 Main st", city: "San Francisco", state: "CA", zip: 90210)
      @order_1 = @user.orders.create!(address_id: @user_home_address.id)
      @order_2 = @user.orders.create!(address_id: @user_home_address.id, status: 2)
    end
    
    it ".shipped_orders" do
      expect(@user_home_address.shipped_orders).to eq([@order_2])
    end
  end
end
