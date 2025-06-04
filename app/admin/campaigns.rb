ActiveAdmin.register Campaign do
  actions :all

  permit_params :title, :description, :goal, :location, :status, :thumb_nail_url, :founder_id

  index do
    selectable_column
    id_column
    column :title
    column :subscriber
    column :status
    column :created_at
    actions defaults: false do |campaign|
      item "Approve", approve_admin_campaign_path(campaign), method: :put if campaign.status_pending?
      item "Reject", reject_admin_campaign_path(campaign), method: :put if campaign.status_pending?
    end
  end

  member_action :approve, method: :put do
    resource.status_approved!
    CampaignMailer.approved_email(resource).deliver_later
    redirect_to admin_campaigns_path, notice: "Campaign approved."
  end

  member_action :reject, method: :put do
    resource.status_rejected!
    redirect_to admin_campaigns_path, alert: "Campaign rejected."
  end

  member_action :pending, method: :put do
    resource.status_pending!
    redirect_to admin_campaigns_path, alert: "Campaign pending."
  end

  show do
    attributes_table do
      row :id
      row :title
      row :description
      row :subscriber
      row :status
      row :created_at
    end
  end
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :title, :description, :status, :subscriber_ids, :thumb_nail_url, :goal, :location, :founder
  #
  # or
  #
  # permit_params do
  #   permitted = [:title, :description, :status, :subscriber_ids, :thumb_nail_url, :goal, :location, :founder]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  form do |f|
    f.inputs do
      f.input :title
      f.input :description
      f.input :goal
      f.input :location
      f.input :thumb_nail_url
      f.input :status, as: :select, collection: Campaign.statuses.keys
      f.input :founder, collection: Subscriber.all.map { |s| [s.full_name, s.id] }
    end
    f.actions
  end
end
