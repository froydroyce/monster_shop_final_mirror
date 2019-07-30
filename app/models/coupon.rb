class Coupon < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :amount
  validates_presence_of :status
  validates_uniqueness_of :name

  belongs_to :merchant

  enum status: ['enabled', 'disabled']
end
