# frozen_string_literal: true

# Admin dashboard page
ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do
    div class: 'blank_slate_container', id: 'dashboard_default_message' do
      span class: 'blank_slate' do
        span I18n.t('active_admin.dashboard_welcome.welcome')
        small I18n.t('active_admin.dashboard_welcome.call_to_action')
      end
    end

    columns do
      column do
        panel 'Recent Categories' do
          table_for Category.order('id desc').limit(5).map do
            column('Category') do |category|
              link_to category.name,
              category_path(category.name)
            end
          end
        end
      end
    end

    columns do
      column do
        panel 'Recent Comments' do
          table_for Comment.joins(:user).joins(:image).order('id desc').limit(5).map do
            column('Text') { |comment| comment.text }
            column('User') { |comment| comment.user.email }
            column('Image') do |comment|
              link_to 'Image link',
              single_category_image_path(comment.image.category.name, comment.image.id)
            end
          end
        end
      end
    end

    columns do
      column do
        panel 'Recent Images' do
          table_for Image.joins(:user).order('id desc').limit(10).map do
            column('Image') { |image| image_tag image.image.small_thumb.url }
            column('Image Path') do |image|
              link_to image.image,
              single_category_image_path(image.category.name, image.id)
            end
          end
        end
      end
    end
  end
end
