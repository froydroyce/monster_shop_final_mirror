class CreateCoupons < ActiveRecord::Migration[5.1]
  def change
    create_table :coupons do |t|
      t.string :name
      t.integer :amount
      t.integer :status, default: 0
      t.references :merchant, foreign_key: true
    end
  end
end
