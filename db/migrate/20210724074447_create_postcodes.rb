class CreatePostcodes < ActiveRecord::Migration[6.1]
  def change
    create_table :postcodes do |t|
      t.integer :number
      t.references :state, null: false, foreign_key: true

      t.timestamps
    end
  end
end
