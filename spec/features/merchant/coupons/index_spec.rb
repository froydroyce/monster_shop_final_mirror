require 'rails_helper'

RSpec.describe 'As a merchant' do
  describe 'When I visit my Coupons Index Page' do
    before(:each) do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, enabled: true)
      @m_user = @megan.users.create(name: 'Megan', email: 'megan@example.com', password: 'securepassword')
      @marma_10 = @megan.coupons.create!(name: "marma10", amount: 10)
      @marma_20 = @megan.coupons.create!(name: "marma20", amount: 20)
      @marma_30 = @megan.coupons.create!(name: "marma30", amount: 30)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
      # visit login_path
      # fill_in :email, with: 'megan@example.com'
      # fill_in :password, with: 'securepassword'
      # click_button 'Log In'
    end

    it "I see all of my coupons" do
      visit merchant_dashboard_path
      
      click_link 'My Coupons'

      expect(current_path).to eq(merchant_coupons_path)

      expect(page).to have_content("My Coupons")

      within "#coupon-#{@marma_10.id}" do
        expect(page).to have_content(@marma_10.name)
        expect(page).to have_content("#{number_to_currency(@marma_10.amount)} off")
        expect(page).to have_content("Status: #{@marma_10.status}")
      end

      within "#coupon-#{@marma_20.id}" do
        expect(page).to have_content(@marma_20.name)
        expect(page).to have_content("#{number_to_currency(@marma_20.amount)} off")
        expect(page).to have_content("Status: #{@marma_20.status}")
      end

      within "#coupon-#{@marma_30.id}" do
        expect(page).to have_content(@marma_30.name)
        expect(page).to have_content("#{number_to_currency(@marma_30.amount)} off")
        expect(page).to have_content("Status: #{@marma_30.status}")
      end
    end
  end
end
