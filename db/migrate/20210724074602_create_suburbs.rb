class CreateSuburbs < ActiveRecord::Migration[6.1]
  def change
    create_table :suburbs do |t|
      t.string :name
      t.references :postcode, null: false, foreign_key: true

      t.timestamps
    end
  end
end
