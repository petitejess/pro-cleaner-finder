class CreateProperties < ActiveRecord::Migration[6.1]
  def change
    create_table :properties do |t|
      t.string :type
      t.integer :storey
      t.integer :bed
      t.integer :bath
      t.string :street_address
      t.references :suburb, null: false, foreign_key: true
      t.text :description
      t.references :profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
