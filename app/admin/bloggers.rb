ActiveAdmin.register Blogger do
  permit_params :email, :username

  # == INDEX
  index title: "👤 Danh sách Blogger" do
    selectable_column
    id_column
    column :username
    column :email
    column :created_at
    actions defaults: true do |blogger|
      item "⚠️ Gửi cảnh báo", warning_admin_blogger_path(blogger), class: "member_link"
    end
  end

  # == SHOW
  show title: proc { |blogger| "👤 Chi tiết Blogger ##{blogger.id}" } do
    attributes_table title: "Thông tin cá nhân" do
      row :id
      row :username
      row :email
      row :created_at
      row :updated_at
    end

    panel "⚠️ Gửi cảnh báo đến Blogger này" do
      render partial: "admin/bloggers/warning", locals: { blogger: blogger }
    end
  end

  # == MEMBER ACTIONS
  member_action :warning, method: :get do
    @blogger = Blogger.find(params[:id])
    render "admin/bloggers/warning"
  end

  member_action :send_warning, method: :post do
    @blogger = Blogger.find(params[:id])
    subject = params[:subject]
    body = params[:body]

    if subject.present? && body.present?
      BloggerMailer.warning_email(@blogger, subject, body).deliver_later
      redirect_to admin_blogger_path(@blogger), notice: "⚠️ Cảnh báo đã được gửi."
    else
      redirect_to warning_admin_blogger_path(@blogger), alert: "❌ Vui lòng nhập đủ tiêu đề và nội dung."
    end
  end
end
