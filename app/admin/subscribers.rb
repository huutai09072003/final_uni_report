ActiveAdmin.register Subscriber do
  permit_params :nickname, :full_name, :email, :phone_number

  # == INDEX
  index title: "👥 Danh sách Người dùng" do
    selectable_column
    id_column
    column :full_name
    column :nickname
    column :email
    column :phone_number
    column :created_at
    actions defaults: true do |subscriber|
      item "⚠️ Gửi cảnh báo", warning_admin_subscriber_path(subscriber), class: "member_link"
    end
  end

  # == SHOW
  show title: proc { |subscriber| "👤 Chi tiết Subscriber ##{subscriber.id}" } do
    attributes_table do
      row :id
      row :full_name
      row :nickname
      row :email
      row :phone_number
      row :created_at
      row :updated_at
    end

    panel "⚠️ Gửi cảnh báo" do
      render partial: "admin/subscribers/warning", locals: { subscriber: subscriber }
    end
  end

  # == MEMBER ACTIONS
  member_action :warning, method: :get do
    @subscriber = Subscriber.find(params[:id])
    render "admin/subscribers/warning"
  end

  member_action :send_warning, method: :post do
    @subscriber = Subscriber.find(params[:id])
    subject = params[:subject]
    body = params[:body]

    if subject.present? && body.present?
      SubscriberMailer.warning_email(@subscriber, subject, body).deliver_later
      redirect_to admin_subscriber_path(@subscriber), notice: "⚠️ Cảnh báo đã được gửi."
    else
      redirect_to warning_admin_subscriber_path(@subscriber), alert: "❌ Vui lòng nhập đủ tiêu đề và nội dung."
    end
  end
end
