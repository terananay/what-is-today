class CreateAlbums < ActiveRecord::Migration[7.1]
  def change
    create_table :albums do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.boolean :is_sample, null: false, default: false

      t.timestamps
    end
  end
end
