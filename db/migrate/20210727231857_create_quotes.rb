class CreateQuotes < ActiveRecord::Migration[6.1]
  def change
    create_table :quotes do |t|
      t.date :date
      t.float :service_hour
      t.float :total_cost
      t.string :status
      t.references :request, null: false, foreign_key: true

      t.timestamps
    end
  end
end
