class TagStringsController < ApplicationController
  def create
    @tag = TagString.new(post_params)
    @tag.save
  end

  def post_params
    params.require(:tag_strings).permit(:name)
  end
end