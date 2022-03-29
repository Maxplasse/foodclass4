class CreateChefs < ActiveRecord::Migration[6.1]
  def change
    create_table :chefs do |t|
      t.string :restaurant_name
      t.string :specialty
      t.string :level
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
