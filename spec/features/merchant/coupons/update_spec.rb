require 'rails_helper'

RSpec.describe 'As a merchant' do
  describe 'When I visit my Coupons Index Page' do
    describe 'I see a links to update my coupons' do
      before(:each) do
        @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, enabled: true)
        @m_user = @megan.users.create(name: 'Megan', email: 'megan@example.com', password: 'securepassword')
        @marma_10 = @megan.coupons.create!(name: "marma10", amount: 10)
        @marma_20 = @megan.coupons.create!(name: "marma20", amount: 20)
        @marma_30 = @megan.coupons.create!(name: "marma30", amount: 30)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
      end

      it "I can edit my coupon" do
        visit merchant_coupons_path

        within "#coupon-#{@marma_10.id}" do
          click_button 'Edit'
        end

        expect(current_path).to eq(edit_merchant_coupon_path(@marma_10))

        fill_in :name, with: 'marma40'
        fill_in :amount, with: 40

        click_button 'Update Coupon'

        expect(current_path).to eq(merchant_coupons_path)

        within "#coupon-#{@marma_10.id}" do
          expect(page).to have_content("marma40")
          expect(page).to have_content("$40.00 off")
        end
      end

      it "I must fill in all forms" do
        visit edit_merchant_coupon_path(@marma_10)

        fill_in :name, with: ""
        fill_in :amount, with: ""

        click_button 'Update Coupon'

        expect(current_path).to eq(merchant_coupon_path(@marma_10))

        expect(page).to have_content("Name can't be blank and Amount can't be blank")
      end

      it "I can disable/enable coupons" do
        visit merchant_coupons_path

        within "#coupon-#{@marma_10.id}" do
          click_button 'Disable'
        end

        expect(current_path).to eq(merchant_coupons_path)

        within "#coupon-#{@marma_10.id}" do
          expect(page).to have_content("Status: disabled")
        end

        within "#coupon-#{@marma_10.id}" do
          click_button 'Enable'
        end

        expect(current_path).to eq(merchant_coupons_path)

        within "#coupon-#{@marma_10.id}" do
          expect(page).to have_content("Status: enabled")
        end
      end
    end
  end
end
