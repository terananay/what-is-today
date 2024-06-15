class CreatePages < ActiveRecord::Migration[7.1]
  def change
    create_table :pages do |t|
      t.references :album, null: false, foreign_key: true
      t.integer :page_number, null: false
      t.boolean :is_sample, null: false, default: false

      t.timestamps
    end

    # album_idとpage_numberの組み合わせに一意性制約を追加
    add_index :pages, [:album_id, :page_number], unique: true
  end
end
