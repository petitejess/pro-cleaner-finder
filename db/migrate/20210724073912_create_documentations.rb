class CreateDocumentations < ActiveRecord::Migration[6.1]
  def change
    create_table :documentations do |t|
      t.string :npc_reference
      t.string :abn_number
      t.boolean :insured
      t.references :profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
