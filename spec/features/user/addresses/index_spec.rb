require 'rails_helper'

RSpec.describe 'User Addresses Index' do
  describe 'As a Registered User' do
    describe 'When I visit my Addresses Index page' do
      before(:each) do
        @user_1 = User.create!(name: 'Megan', email: 'megan_1@example.com', password: 'securepassword')
        @address_1 = @user_1.addresses.create!(address_name: "Home", address: "1234 Main st", city: "Denver", state: "CO", zip: 80229)
        @address_2 = @user_1.addresses.create!(address_name: "Work", address: "456 Not-Main st", city: "Denver", state: "CO", zip: 80236)
        @address_3 = @user_1.addresses.create!(address_name: "Office", address: "2342 Officey", city: "Englewood", state: "CO", zip: 80003)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
      end

      it "I see all my addresses including:\n
      -Address name\n
      -Address\n
      -City\n
      -State\n
      -zip" do

        visit profile_addresses_path

        expect(page).to have_content("My Addresses")

        within "#address-#{@address_1.id}" do
          expect(page).to have_content(@address_1.address_name)
          expect(page).to have_content(@address_1.address)
          expect(page).to have_content(@address_1.city)
          expect(page).to have_content(@address_1.state)
          expect(page).to have_content(@address_1.zip)
          expect(page).to have_button('Edit')
          expect(page).to have_button('Delete')
        end

        within "#address-#{@address_2.id}" do
          expect(page).to have_content(@address_2.address_name)
          expect(page).to have_content(@address_2.address)
          expect(page).to have_content(@address_2.city)
          expect(page).to have_content(@address_2.state)
          expect(page).to have_content(@address_2.zip)
          expect(page).to have_button('Edit')
          expect(page).to have_button('Delete')
        end

        within "#address-#{@address_3.id}" do
          expect(page).to have_content(@address_3.address_name)
          expect(page).to have_content(@address_3.address)
          expect(page).to have_content(@address_3.city)
          expect(page).to have_content(@address_3.state)
          expect(page).to have_content(@address_3.zip)
          expect(page).to have_button('Edit')
          expect(page).to have_button('Delete')
        end
      end
    end
  end
end
