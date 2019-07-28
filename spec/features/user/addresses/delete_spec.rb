require 'rails_helper'

RSpec.describe 'User Addresses Index' do
  describe 'As a Registered User' do
    describe 'When I visit my Addresses Index page' do
      before(:each) do
        @user_1 = User.create!(name: 'Megan', email: 'megan_1@example.com', password: 'securepassword')
        @address_1 = @user_1.addresses.create!(address_name: "House", address: "1234 Main st", city: "Aurora", state: "FL", zip: 80229)
        @address_2 = @user_1.addresses.create!(address_name: "Work", address: "456 Not-Main st", city: "Denver", state: "CO", zip: 80236)
        @address_3 = @user_1.addresses.create!(address_name: "Office", address: "2342 Officey", city: "Englewood", state: "CO", zip: 80003)
        visit login_path
        fill_in :email, with: @user_1.email
        fill_in :password, with: @user_1.password
        click_button 'Log In'
      end

      it "I can delete an address" do
        visit profile_addresses_path

        within "#address-#{@address_1.id}" do
          click_button 'Delete'
        end

        expect(current_path).to eq(profile_addresses_path)
        expect(page).to have_content("Address for #{@address_1.address_name} has been removed.")
        expect(page).to_not have_content(@address_1.address)
        expect(page).to_not have_content(@address_1.city)
        expect(page).to_not have_content(@address_1.state)
        expect(page).to_not have_content(@address_1.zip)
      end

      it "I cannot delete an address if it's been used in a 'shipped' order." do
        @order_1 = @user_1.orders.create!(address_id: @address_1.id, status: 2)

        visit profile_addresses_path

        within "#address-#{@address_1.id}" do
          click_button 'Delete'
        end

        expect(page).to have_content("Address for #{@address_1.address_name} is used in an order that is shipped. Cannot be deleted")

        within "#address-#{@address_1.id}" do
          expect(page).to have_content(@address_1.address_name)
          expect(page).to have_content(@address_1.address)
          expect(page).to have_content(@address_1.city)
          expect(page).to have_content(@address_1.state)
          expect(page).to have_content(@address_1.zip)
        end
      end
    end
  end
end
