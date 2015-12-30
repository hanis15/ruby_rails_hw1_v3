class CreateTagStrings < ActiveRecord::Migration
  def change
    create_table :tag_strings do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
