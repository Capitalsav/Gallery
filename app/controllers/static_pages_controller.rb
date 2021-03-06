# frozen_string_literal: true

# Controller for static pages (home page)
class StaticPagesController < ApplicationController
  def home
    @top_categories =
      Category
      .left_outer_joins(:images).distinct.select('categories.*, COUNT(images.*) AS images_count')
      .left_outer_joins(:liked_categoties).distinct.select('categories.*, COUNT(likes.*) AS likes_count')
      .left_outer_joins(:commented_categories).distinct.select('categories.*, COUNT(comments.*) AS comments_count')
      .group('categories.id')
      .order('images_count DESC')
      .order('likes_count DESC')
      .order('comments_count DESC').limit(5)
    images_array = Image.order('RANDOM()').limit(5)
    uploaded = true
    if images_array.present?
      @carousel_images = { images_uploaded: uploaded, images: images_array }
    else
      uploaded = false
      static_image = 'default.jpg'
      @carousel_images = { images_uploaded: uploaded, images: static_image }
    end
  end
end
