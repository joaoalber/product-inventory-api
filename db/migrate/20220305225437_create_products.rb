class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.text :description
      t.boolean :archived, null: false
      t.float :price, null: false
      t.integer :quantity, null: false
      t.text :categories, array: false, default: [].to_yaml, null: false

      t.timestamps
    end
  end
end
