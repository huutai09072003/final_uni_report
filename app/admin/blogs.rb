ActiveAdmin.register Blog do
  actions :all

  permit_params :title, :content, :status, :thumb_nail_url, :view_count, :likes_count, :published_at, :blogger_id

  index do
    selectable_column
    id_column
    column :title
    column :blogger
    column :status
    column :created_at
    actions defaults: false do |blog|
      if blog.status_pending?
        item "✔️ Approve", approve_admin_blog_path(blog), method: :put, class: "member_link"
        item "❌ Reject", reject_admin_blog_path(blog), method: :put, class: "member_link"
      else
        item "↩️ Reset to Pending", pending_admin_blog_path(blog), method: :put, class: "member_link"
      end
    end
  end

  member_action :approve, method: :put do
    resource.update(status: "approved", published_at: Time.current)
    BlogMailer.approved_email(resource).deliver_later
    redirect_to admin_blogs_path, notice: "✅ Blog approved."
  end

  member_action :reject, method: :put do
    resource.update(status: "rejected")
    redirect_to admin_blogs_path, alert: "❌ Blog rejected."
  end

  member_action :pending, method: :put do
    resource.update(status: "pending", published_at: nil)
    redirect_to admin_blogs_path, notice: "↩️ Status reset to pending."
  end

  show do
    attributes_table do
      row :id
      row :title
      row :content
      row :thumb_nail_url
      row :status
      row :published_at
      row :view_count
      row :likes_count
      row :blogger
      row :created_at
      row :updated_at
    end

    panel "Moderation" do
      if blog.status_pending?
        span link_to("✔️ Approve", approve_admin_blog_path(blog), method: :put, class: "button")
        span link_to("❌ Reject", reject_admin_blog_path(blog), method: :put, class: "button")
      else
        span link_to("↩️ Reset to Pending", pending_admin_blog_path(blog), method: :put, class: "button")
      end
    end
  end

  filter :title
  filter :blogger
  filter :status, as: :select, collection: Blog.statuses.keys
  filter :created_at

  form do |f|
    f.inputs do
      f.input :title
      f.input :content
      f.input :thumb_nail_url
      f.input :view_count
      f.input :likes_count
      f.input :published_at
      f.input :status, as: :select, collection: Blog.statuses.keys
      f.input :blogger
    end
    f.actions
  end
end
