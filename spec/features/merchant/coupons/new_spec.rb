require 'rails_helper'

RSpec.describe 'As a merchant' do
  describe 'When I visit my Coupons Index Page' do
    describe 'I see a link to create a new coupon' do
      before(:each) do
        @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, enabled: true)
        @m_user = @megan.users.create(name: 'Megan', email: 'megan@example.com', password: 'securepassword')
        @marma_10 = @megan.coupons.create!(name: "marma10", amount: 10)
        @marma_20 = @megan.coupons.create!(name: "marma20", amount: 20)
        @marma_30 = @megan.coupons.create!(name: "marma30", amount: 30)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
      end

      it "I can Create a new coupon" do
        visit merchant_coupons_path

        click_link 'New Coupon'

        expect(current_path).to eq(new_merchant_coupon_path)

        fill_in :name, with: 'marma40'
        fill_in :amount, with: 40

        click_button 'Create New Coupon'

        expect(current_path).to eq(merchant_coupons_path)

        coupon = Coupon.last

        within "#coupon-#{coupon.id}" do
          expect(page).to have_content(coupon.name)
          expect(page).to have_content("#{number_to_currency(coupon.amount)} off")
          expect(page).to have_content("Status: #{coupon.status}")
        end
      end

      it "I must fill in all fields" do
        visit new_merchant_coupon_path

        click_button 'Create New Coupon'

        expect(current_path).to eq(merchant_coupons_path)
        expect(page).to have_content("Name can't be blank and Amount can't be blank")
      end

      it "I cannot have more than 5 coupons" do
        @marma_40 = @megan.coupons.create!(name: "marma40", amount: 40)
        @marma_50 = @megan.coupons.create!(name: "marma50", amount: 50)

        visit new_merchant_coupon_path

        fill_in :name, with: 'marma60'
        fill_in :amount, with: 60

        click_button 'Create New Coupon'

        expect(current_path).to eq(merchant_coupons_path)
        expect(page).to have_content("You cannot have more than 5 coupons")
      end
    end
  end
end
