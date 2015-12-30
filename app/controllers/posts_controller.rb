class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
    @tags = TagString.all
  end

  def filter
    #@posts = Post.where(:tag_strings => {id => TagString.where(:name => params[:id]).first.id})
    @post = Post.includes(:tag_strings).where(tag_strings: {name: params[:id]})
    @posts = []
    @post.each do |posty|
      @posts << Post.find(posty[:id])
    end
    #@posts = Post.where(:id => @post.id)
    @tags = TagString.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
    @tags = @post.tag_strings.map { |c| c.name }.join(', ')
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.save
    string_tags = params[:post][:tag_strings].split(/ *[, ] */).uniq
    string_tags.each do |tag|
      curr_tag = TagString.where(:name => tag)
      if curr_tag.blank?
        @post.tag_strings.create(:name => tag)
      else
        @post.tag_strings << curr_tag
      end
    end
    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        existing_tags = @post.tag_strings
        string_tags = params[:post][:tag_strings].split(/ *[, ] */).uniq
        @post.tag_strings.delete
        updated_tags = []
        string_tags.each do |tag|
          TagString.new(:name => tag).save if TagString.where(:name => tag).empty?
        end
        @post.tag_strings = TagString.where(:name => string_tags)
        @post.save
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    existing_tags = @post.tag_strings
    existing_tags.each do |tag|
      edit_tag(tag.id)
    end
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:author, :title, :body, :tag_string_ids => [])
    end

    def edit_tag(tag_id)
      is_exist = false
      Post.all.each do |curr_post|
        is_exist = true if curr_post.tag_strings.map(&:id).include?(tag_id) && @post[:id] != curr_post[:id]
      end
      TagString.find(tag_id).destroy unless is_exist
    end
end
