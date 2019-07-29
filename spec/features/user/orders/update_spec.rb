require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'Create Order' do
  describe 'As a Registered User' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @user = User.create!(name: 'Megan', email: 'megan@example.com', password: 'securepassword')
      @user_home_address = @user.addresses.create!(address_name: "Home", address: "1234 Main st", city: "Denver", state: "CO", zip: 80229)
      @user_work_address = @user.addresses.create!(address_name: "Work", address: "1789 Main st", city: "San Francisco", state: "CA", zip: 90210)
      @order_1 = @user.orders.create!(address_id: @user_home_address.id)
      @order_1.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it "I can update an order's address if the status is still pending" do
      visit "/profile/orders/#{@order_1.id}"

      expect(page).to have_content(@user_home_address.address_name)
      expect(page).to have_content(@user_home_address.address)
      expect(page).to have_content(@user_home_address.city)
      expect(page).to have_content(@user_home_address.state)
      expect(page).to have_content(@user_home_address.zip)

      page.select(@user_work_address.address_name, :from => 'Shipping Address')

      click_button 'Change Address'
      expect(current_path).to eq("/profile/orders/#{@order_1.id}")

      expect(page).to have_content("Shipping address updated.")
      expect(page).to have_content(@user_work_address.address_name)
      expect(page).to have_content(@user_work_address.address)
      expect(page).to have_content(@user_work_address.city)
      expect(page).to have_content(@user_work_address.state)
      expect(page).to have_content(@user_work_address.zip)

      @order_1.update(status: 1)
      @order_1.reload

      visit "/profile/orders/#{@order_1.id}"

      page.select(@user_home_address.address_name, :from => 'Shipping Address')

      click_button 'Change Address'

      expect(page).to have_content("Order has been #{@order_1.status}. Address cannot be changed")
      expect(page).to have_content(@user_work_address.address_name)
      expect(page).to have_content(@user_work_address.address)
      expect(page).to have_content(@user_work_address.city)
      expect(page).to have_content(@user_work_address.state)
      expect(page).to have_content(@user_work_address.zip)
    end
  end
end
