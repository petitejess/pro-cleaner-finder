class CreateListings < ActiveRecord::Migration[6.1]
  def change
    create_table :listings do |t|
      t.string :title
      t.text :description
      t.float :rate_per_hour
      t.references :profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
