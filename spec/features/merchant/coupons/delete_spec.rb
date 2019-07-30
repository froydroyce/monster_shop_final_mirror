require 'rails_helper'

RSpec.describe 'As a merchant' do
  describe 'When I visit my Coupons Index Page' do
    describe 'I see a button to delete my coupons' do
      before(:each) do
        @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, enabled: true)
        @m_user = @megan.users.create(name: 'Megan', email: 'megan@example.com', password: 'securepassword')
        @marma_10 = @megan.coupons.create!(name: "marma10", amount: 10)
        @marma_20 = @megan.coupons.create!(name: "marma20", amount: 20)
        @marma_30 = @megan.coupons.create!(name: "marma30", amount: 30)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
      end

      it "I can delete a coupon" do
        visit merchant_coupons_path

        within "#coupon-#{@marma_10.id}" do
          click_button 'Delete'
        end
        save_and_open_page
        expect(current_path).to eq(merchant_coupons_path)

        expect(page).to have_content("#{@marma_10.name} has been deleted.")

        expect(page).to_not have_css("#coupon-#{@marma_10.id}")
      end
    end
  end
end
