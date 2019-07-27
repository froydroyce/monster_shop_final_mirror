require 'rails_helper'

RSpec.describe User do
  describe 'Relationships' do
    it {should belong_to(:merchant).optional}
    it {should have_many :orders}
    it {should have_many :addresses}
  end

  describe 'Validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :email}
    it {should validate_uniqueness_of :email}
  end

  describe 'instance methods' do
    before(:each) do
      @user_1 = User.create!(name: 'Megan', email: 'hello@example.com', password: 'securepassword')
      @u1_home_address = @user_1.addresses.create!(address_name: "Home", address: "1234 Main st", city: "Denver", state: "CO", zip: 80229)
      @u1_work_address = @user_1.addresses.create!(address_name: "Work", address: "987 Main st", city: "LA", state: "CA", zip: 90210)
    end

    it ".address_names" do
      expect(@user_1.address_names).to eq([@u1_home_address.address_name, @u1_work_address.address_name])
    end

    it ".find_address_by_name" do
      expect(@user_1.find_address_by_name(@u1_home_address.address_name)).to eq([@u1_home_address])
      expect(@user_1.find_address_by_name(@u1_work_address.address_name)).to eq([@u1_work_address])
    end
  end
end
