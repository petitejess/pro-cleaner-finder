class CreateJobs < ActiveRecord::Migration[6.1]
  def change
    create_table :jobs do |t|
      t.date :date
      t.float :service_hour
      t.float :total_cost
      t.string :status
      t.references :quote, null: false, foreign_key: true

      t.timestamps
    end
  end
end
