class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.integer :rating
      t.text :content
      t.references :job, null: false, foreign_key: true
      t.integer :review_from
      t.integer :review_to
      t.references :profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
