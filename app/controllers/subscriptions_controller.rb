# frozen_string_literal: true

# Controller for perform actions with user subscriptions on categories
class SubscriptionsController < ApplicationController
  skip_before_action :user_click, only: %i[create destroy]
  before_action :authenticate_user!, only: %i[create destroy]

  def create
    @category = Category.find(params[:category_id])
    @subscription = current_user.subscriptions.create!(category_id: params[:category_id])
    Resque.enqueue(CategoryNotificationJobJob, current_user, @category)
    respond_to do |format|
      format.html { redirect_back fallback_location: root_path }
      format.js
    end
  end

  def destroy
    @category = Category.find(params[:category_id])
    current_user.subscriptions.find_by(category_id: params[:category_id]).destroy!
    respond_to do |format|
      format.html { redirect_back fallback_location: root_path }
      format.js
    end
  end
end
