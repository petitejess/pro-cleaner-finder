class CreatePayments < ActiveRecord::Migration[6.1]
  def change
    create_table :payments do |t|
      t.datetime :payment_date
      t.string :payment_method
      t.float :payment_amount
      t.references :job, null: false, foreign_key: true

      t.timestamps
    end
  end
end
