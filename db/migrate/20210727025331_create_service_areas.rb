class CreateServiceAreas < ActiveRecord::Migration[6.1]
  def change
    create_table :service_areas do |t|
      t.references :suburb, null: false, foreign_key: true
      t.references :listing, null: false, foreign_key: true

      t.timestamps
    end
  end
end
