require 'rails_helper'

RSpec.describe 'User Addresses Index' do
  describe 'As a Registered User' do
    describe 'When I visit my Addresses Index page' do
      before(:each) do
        @user_1 = User.create!(name: 'Megan', email: 'megan_1@example.com', password: 'securepassword')
        @address_1 = @user_1.addresses.create!(address_name: "Home", address: "1234 Main st", city: "Denver", state: "CO", zip: 80229)
      end

      it "I can create a new address" do
        visit login_path
        fill_in :email, with: @user_1.email
        fill_in :password, with: @user_1.password
        click_button 'Log In'

        visit profile_addresses_path

        click_on 'New Address'

        expect(current_path).to eq(profile_addresses_new_path)

        fill_in :address_name, with: 'Work'
        fill_in :address, with: '465 WannaHakkaLougee St'
        fill_in :city, with: 'Honolulu'
        fill_in :state, with: 'HI'
        fill_in :zip, with: 76876

        click_on 'Create New Address'

        expect(current_path).to eq(profile_addresses_path)

        address = Address.last

        expect(page).to have_content(address.address_name)
        expect(page).to have_content(address.address)
        expect(page).to have_content(address.city)
        expect(page).to have_content(address.state)
        expect(page).to have_content(address.zip)
      end
    end
  end
end
