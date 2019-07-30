require 'rails_helper'

RSpec.describe Coupon do
  describe 'Validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :amount }
    it { should validate_presence_of :status }
  end

  describe 'relations' do
    it { should belong_to :merchant }
  end
end
