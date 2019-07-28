require 'rails_helper'

RSpec.describe 'User Addresses Index' do
  describe 'As a Registered User' do
    describe 'When I visit my Addresses Edit page' do
      before(:each) do
        @user_1 = User.create!(name: 'Megan', email: 'megan_1@example.com', password: 'securepassword')
        @address_1 = @user_1.addresses.create!(address_name: "Home", address: "1234 Main st", city: "Denver", state: "CO", zip: 80229)
        visit login_path
        fill_in :email, with: @user_1.email
        fill_in :password, with: @user_1.password
        click_button 'Log In'
      end

      it "I can update my addresses" do
        visit profile_addresses_path

        within "#address-#{@address_1.id}" do
          click_button 'Edit'
        end

        expect(current_path).to eq(profile_address_edit_path(@address_1))

        fill_in :address_name, with: 'Work'
        fill_in :address, with: '465 WannaHakkaLougee St'
        fill_in :city, with: 'Honolulu'
        fill_in :state, with: 'HI'
        fill_in :zip, with: 76876

        click_button 'Update Address'

        expect(current_path).to eq(profile_addresses_path)

        within "#address-#{@address_1.id}" do
          address = Address.last

          expect(page).to have_content(address.address_name)
          expect(page).to have_content(address.address)
          expect(page).to have_content(address.city)
          expect(page).to have_content(address.state)
          expect(page).to have_content(address.zip)
        end
      end

      it "I cannot update an address with missing fields" do
        visit profile_addresses_path

        within "#address-#{@address_1.id}" do
          click_button 'Edit'
        end

        expect(current_path).to eq(profile_address_edit_path(@address_1))

        fill_in :address_name, with: ""
        fill_in :address, with: ""
        fill_in :city, with: ""
        fill_in :state, with: ""
        fill_in :zip, with: ""

        click_button 'Update Address'

        expect(page).to have_content("Address name can't be blank, Address can't be blank, City can't be blank, State can't be blank, Zip can't be blank, and Zip is not a number")
      end

      it "I cannot update an address if it's been used in a 'shipped' order." do
        @order_1 = @user_1.orders.create!(address_id: @address_1.id, status: 2)

        visit profile_addresses_path

        within "#address-#{@address_1.id}" do
          click_button 'Edit'
        end

        expect(page).to have_content("Address for #{@address_1.address_name} is used in an order that is shipped. Cannot be updated")

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
