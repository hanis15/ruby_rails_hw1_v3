# Post model
class Post < ActiveRecord::Base
  has_and_belongs_to_many :tag_strings

  validates :title, presence: true
  validates :body, presence: true
  validates :author, presence: true
end
