class CreatePictures < ActiveRecord::Migration[7.1]
  def change
    create_table :pictures do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.string :memo
      t.string :shooting_date, null: false
      t.boolean :is_sample, null: false, default: false

      t.timestamps
    end

    add_index :pictures, :shooting_date
  end
end
