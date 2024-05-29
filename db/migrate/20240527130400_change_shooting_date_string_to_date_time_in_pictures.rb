class ChangeShootingDateStringToDateTimeInPictures < ActiveRecord::Migration[7.1]
  def change
    change_column :pictures, :shooting_date, 'date USING CAST(shooting_date AS date)'
    change_column_null :pictures, :shooting_date, false
  end
end
