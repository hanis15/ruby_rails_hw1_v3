class Post < ActiveRecord::Base
  has_and_belongs_to_many :tag_strings, :join_table => "post_tags"
end
