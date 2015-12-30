class CreatePostTag < ActiveRecord::Migration
  def change
    create_table :posts_tag_strings, id: false do |t|
      t.belongs_to :post, index: true
      t.belongs_to :tag_string, index: true
    end
  end
end
