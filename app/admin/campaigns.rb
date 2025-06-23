ActiveAdmin.register Campaign do
  actions :all

  permit_params :title, :description, :goal, :location, :status, :thumbnail, :founder_id

  includes :founder, :donations

  # == INDEX
  index title: "📢 Danh sách Chiến dịch" do
    selectable_column
    id_column
    column :title
    column "👤 Người tạo", :founder
    column "🎯 Mục tiêu", :goal
    column "📍 Địa điểm", :location
    column "📌 Trạng thái", :status
    column "🗓 Ngày tạo", :created_at
    actions defaults: false do |campaign|
      if campaign.status_pending?
        item "✔️ Duyệt", approve_admin_campaign_path(campaign), method: :put, class: "member_link"
        item "❌ Từ chối", reject_admin_campaign_path(campaign), method: :put, class: "member_link"
      else
        item "↩️ Reset", pending_admin_campaign_path(campaign), method: :put, class: "member_link"
      end
      item "⚠️ Gửi cảnh báo", warning_admin_campaign_path(campaign), class: "member_link"
    end
  end

  # == MEMBER ACTIONS
  member_action :approve, method: :put do
    resource.status_approved!
    CampaignMailer.approved_email(resource).deliver_later
    redirect_to admin_campaigns_path, notice: "✅ Campaign đã được duyệt."
  end

  member_action :reject, method: :put do
    resource.status_rejected!
    CampaignMailer.rejected_email(resource).deliver_later
    redirect_to admin_campaigns_path, alert: "❌ Campaign đã bị từ chối."
  end

  member_action :pending, method: :put do
    resource.status_pending!
    redirect_to admin_campaigns_path, notice: "↩️ Campaign đã được chuyển về trạng thái chờ duyệt."
  end

  member_action :warning, method: :get do
    @campaign = Campaign.find(params[:id])
    render "admin/campaigns/warning"
  end

  member_action :send_warning, method: :post do
    @campaign = Campaign.find(params[:id])
    subject = params[:subject]
    body = params[:body]

    if subject.present? && body.present?
      CampaignMailer.warning_email(@campaign, subject, body).deliver_later
      redirect_to admin_campaign_path(@campaign), notice: "⚠️ Cảnh báo đã được gửi."
    else
      redirect_to warning_admin_campaign_path(@campaign), alert: "❌ Vui lòng nhập đủ tiêu đề và nội dung."
    end
  end

  # == SHOW
  show title: proc { |campaign| "📢 Chi tiết Campaign ##{campaign.id}" } do
    attributes_table title: "🔍 Thông tin chiến dịch" do
      row :id
      row :title
      row :description
      row("Ảnh đại diện") do |c|
        if c.thumbnail.attached?
          image_tag url_for(c.thumbnail), style: "max-height: 150px"
        else
          em "Chưa có ảnh"
        end
      end
      row :goal do |c|
        number_to_currency(c.goal)
      end
      row :location
      row :status
      row :is_get_donated
      row :founder
      row :created_at
      row :updated_at
    end

    panel "🎁 Thống kê đóng góp" do
      total_amount = campaign.donations.where(status: "completed").sum(:amount)
      donation_count = campaign.donations.where(status: "completed").count
      average_amount = donation_count > 0 ? (total_amount / donation_count).round(2) : 0
      goal = campaign.goal.to_f.nonzero? || 1
      percent = ((total_amount / goal) * 100).round(1)
      latest = campaign.donations.where(status: "completed").order(created_at: :desc).first

      attributes_table_for campaign do
        row("Tổng số tiền đã nhận") { number_to_currency(total_amount) }
        row("Số lượt ủng hộ") { donation_count }
        row("Trung bình mỗi lần") { number_to_currency(average_amount) }
        row("% Đã đạt") { "#{percent}%" }
        row("Lần ủng hộ gần nhất") do
          latest ? "#{latest.full_name} (#{time_ago_in_words(latest.created_at)} trước)" : "Chưa có"
        end
      end
    end

    panel "📄 Danh sách ủng hộ (mới nhất)" do
      table_for campaign.donations.where(status: "completed").order(created_at: :desc).limit(20) do
        column("Người ủng hộ") { |d| d.full_name }
        column("Email") { |d| d.stripe_customer_id }
        column("Số tiền") { |d| number_to_currency(d.amount) }
        column("Tần suất") { |d| d.frequency }
        column("Loại") { |d| d.donation_type }
        column("Thời gian") { |d| l(d.created_at, format: :short) }
      end
    end

    panel "⚠️ Gửi cảnh báo tới người tạo" do
      render partial: "admin/campaigns/warning", locals: { campaign: campaign }
    end
  end

  # == FORM
  form multipart: true do |f|
    f.semantic_errors
    f.inputs "📋 Thông tin chiến dịch" do
      f.input :title
      f.input :description
      f.input :goal
      f.input :location
      f.input :status, as: :select, collection: Campaign.statuses.keys
      f.input :founder, collection: Subscriber.all.map { |s| [s.full_name, s.id] }
      f.input :thumbnail, as: :file, hint: f.object.thumbnail.attached? ? image_tag(url_for(f.object.thumbnail), style: "max-height: 100px") : content_tag(:span, "Chưa có ảnh")
    end
    f.actions
  end
end
