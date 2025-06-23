ActiveAdmin.register Blog do
  actions :all

  permit_params :title, :content, :status, :view_count, :likes_count, :published_at, :blogger_id, :thumbnail

  # == INDEX
  index title: "📚 Danh sách Blog" do
    selectable_column
    id_column
    column :title
    column "👤 Tác giả", :blogger
    column "📅 Ngày tạo", :created_at
    column "📌 Trạng thái", :status
    actions defaults: false do |blog|
      if blog.status_pending?
        item "✔️ Duyệt", approve_admin_blog_path(blog), method: :put, class: "member_link"
        item "❌ Từ chối", reject_admin_blog_path(blog), method: :put, class: "member_link"
      else
        item "↩️ Reset", pending_admin_blog_path(blog), method: :put, class: "member_link"
      end

      item "⚠️ Gửi cảnh báo", warning_admin_blog_path(blog), class: "member_link"
    end
  end

  # == MEMBER ACTIONS
  member_action :approve, method: :put do
    resource.update(status: "approved", published_at: Time.current)
    BlogMailer.approved_email(resource).deliver_later
    redirect_to admin_blogs_path, notice: "✅ Blog đã được duyệt."
  end

  member_action :reject, method: :put do
    resource.update(status: "rejected")
    BlogMailer.rejected_email(resource).deliver_later
    redirect_to admin_blogs_path, alert: "❌ Blog đã bị từ chối."
  end

  member_action :pending, method: :put do
    resource.update(status: "pending", published_at: nil)
    redirect_to admin_blogs_path, notice: "↩️ Blog đã được chuyển về trạng thái chờ duyệt."
  end

  member_action :warning, method: :get do
    @blog = resource
    render "admin/blogs/warning"
  end

  member_action :send_warning, method: :post do
    subject = params[:subject]
    body = params[:body]

    if subject.present? && body.present?
      BlogMailer.warning_email(resource, subject, body).deliver_later
      redirect_to admin_blog_path(resource), notice: "⚠️ Cảnh báo đã được gửi."
    else
      redirect_to warning_admin_blog_path(resource), alert: "❌ Vui lòng nhập đủ tiêu đề và nội dung."
    end
  end

  # == SHOW
  show title: proc { |blog| "📝 Chi tiết Blog ##{blog.id}" } do
    attributes_table title: "🔍 Thông tin chi tiết" do
      row :id
      row :title
      row :content
      row("Ảnh đại diện") do |b|
        if b.thumbnail.attached?
          image_tag url_for(b.thumbnail), style: "max-height: 150px"
        else
          em "Chưa có ảnh"
        end
      end
      row :status
      row :published_at
      row :view_count
      row :likes_count
      row :blogger
      row :created_at
      row :updated_at
    end

    panel "🛠 Moderation" do
      if blog.status_pending?
        span link_to("✔️ Duyệt", approve_admin_blog_path(blog), method: :put, class: "button")
        span link_to("❌ Từ chối", reject_admin_blog_path(blog), method: :put, class: "button")
      else
        span link_to("↩️ Reset", pending_admin_blog_path(blog), method: :put, class: "button")
      end
    end
  end

  # == FORM
  form multipart: true do |f|
    f.semantic_errors
    f.inputs "📝 Thông tin Blog" do
      f.input :title
      f.input :content
      f.input :view_count
      f.input :likes_count
      f.input :published_at
      f.input :status, as: :select, collection: Blog.statuses.keys
      f.input :blogger
      f.input :thumbnail, as: :file, hint: f.object.thumbnail.attached? ? image_tag(url_for(f.object.thumbnail), style: "max-height: 100px") : content_tag(:span, "Chưa có ảnh")
    end
    f.actions
  end
end
