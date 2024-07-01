class CreatePagePictures < ActiveRecord::Migration[7.1]
  def change
    create_table :page_pictures do |t|
      t.references :page, null: false, foreign_key: true
      t.references :picture, null: false, foreign_key: true
      t.integer :position, null: false

      t.timestamps
    end
    add_index :page_pictures, [:page_id, :picture_id], unique: true
    add_index :page_pictures, [:page_id, :position], unique: true
  end
end
