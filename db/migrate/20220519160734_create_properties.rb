class CreateProperties < ActiveRecord::Migration[6.1]
  def change
    create_table :properties do |t|
      t.string :name
      t.integer :price
      t.integer :size
      t.text :image_data

      t.timestamps
    end
  end
end
