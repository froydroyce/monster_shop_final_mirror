class User < ApplicationRecord
  has_secure_password

  belongs_to :merchant, optional: true
  has_many :orders
  has_many :addresses

  validates_presence_of :name,
                        :email

  validates_uniqueness_of :email

  enum role: ['default', 'merchant_admin', 'admin']

  def address_names
    addresses.pluck(:address_name)
  end
end
