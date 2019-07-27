require 'rails_helper'

RSpec.describe Address do
  describe 'validations' do
    it {should validate_presence_of :address_name}
    it {should validate_presence_of :address}
    it {should validate_presence_of :city}
    it {should validate_presence_of :state}
    it {should validate_presence_of :zip}
  end

  describe 'relations' do
    it {should belong_to :user}
    it {should have_many :orders}
  end
end
