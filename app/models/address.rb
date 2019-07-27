class Address < ApplicationRecord
  belongs_to :user
  has_many :orders, through: :user

  validates_presence_of :address_name
  validates_presence_of :address
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :zip

  validates :zip, numericality: true
end
