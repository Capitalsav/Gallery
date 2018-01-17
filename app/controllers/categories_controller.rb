class CategoriesController < ApplicationController

  skip_before_action :user_click, only: [:create, :update, :destroy]
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create]

  # GET /categories
  # GET /categories.json
  def index
    @categories_with_images = Category.all.map do |category| {category_key: category, image_key: category.images.order("RANDOM()").first} end
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
    @category = Category.friendly.find(params[:id])
    if user_signed_in?
      @subscription = @category.subscriptions.find_by(user_id: current_user.id)
      @images_with_likes = Category.friendly.find(params[:id]).images.map do |image| {image_key: image, like_key: image.likes.find_by(user_id: current_user.id), likes_count_key: image.likes.count} end
    else
      @images_with_likes = Category.friendly.find(params[:id]).images.map do |image| {image_key: image, likes_count_key: image.likes.count} end
    end
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(category_params)
    respond_to do |format|
      if @category.save
        format.html { redirect_to @category, notice: 'Category was successfully created.' }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit(:name, :user_id)
    end
end
