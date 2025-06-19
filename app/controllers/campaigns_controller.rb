class CampaignsController < ApplicationController
  def index
    @campaigns = Campaign.status_approved
    render json: @campaigns.as_json(methods: [:thumbnail_url])
  end

  def create
    founder = Subscriber.find_by(email: params[:email])
    unless founder
      render json: { success: false, errors: ["Bạn cần phải là người đã đăng ký để được đăng bài!"] }, status: :unprocessable_entity
      return
    end

    if params[:is_get_donated] && founder.stripe_account.nil?
      render json: {
        success: false,
        errors: ["Bạn cần đăng ký tài khoản Stripe để có thể nhận donate từ cộng đồng."]
      }, status: :unprocessable_entity
      return
    end

    @campaign = Campaign.new(campaign_params)
    @campaign.founder = founder
    @campaign.is_get_donated = params[:is_get_donated]

    if @campaign.save
      CampaignMailer.pending_review_email(@campaign).deliver_later
      render json: {
        success: true,
        campaign: @campaign.as_json(methods: [:thumbnail_url])
      }, status: :created
    else
      render json: { success: false, errors: @campaign.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    @campaign = Campaign.find(params[:id])
    founder = @campaign.founder

    render json: {
      id: @campaign.id,
      title: @campaign.title,
      description: @campaign.description,
      thumb_nail_url: @campaign.thumbnail_url,
      goal: @campaign.goal,
      location: @campaign.location,
      status: @campaign.status,
      is_get_donated: @campaign.is_get_donated,
      created_at: @campaign.created_at,
      founder: {
        id: founder.id,
        name: founder.full_name,
        nickname: founder.nickname,
        email: founder.email,
        stripe_connected: founder.stripe_account.present?
      }
    }
  end

  def donation
    @campaign = Campaign.find(params[:id])
    @donations = @campaign.donations.where(donation_type: 'for_campaign').order(created_at: :desc).limit(5)
    render json: @donations
  end

  def all_donations
    @campaign = Campaign.find(params[:id])
    @donations = @campaign.donations.where(donation_type: 'for_campaign').order(created_at: :desc)
    render json: @donations.map { |d|
      {
        id: d.id,
        full_name: d.full_name,
        amount: d.amount.to_f,
        currency: d.currency,
        created_at: d.created_at&.iso8601
      }
    }
  end

  def donate
    campaign = Campaign.find(params[:id])
    founder = campaign.founder

    unless campaign.is_get_donated && founder.stripe_account.present?
      render json: { error: 'Chiến dịch không nhận donate hoặc chưa liên kết Stripe.' }, status: :unprocessable_entity
      return
    end

    amount = params[:amount].to_i
    currency = params[:currency].to_s.downcase
    full_name = params[:full_name]
    frequency = params[:frequency] || 'once'
    include_name = params[:include_name] || false
    subscribe_newsletter = params[:subscribe_newsletter] || false

    unless amount.positive? && full_name.present?
      render json: { error: 'Thiếu thông tin bắt buộc.' }, status: :bad_request and return
    end

    customer = Stripe::Customer.create(
      name: full_name,
      metadata: {
        campaign_id: campaign.id,
        subscribe_newsletter: subscribe_newsletter,
        include_name: include_name
      }
    )

    session_params = {
      customer: customer.id,
      payment_method_types: ['card'],
      success_url: "#{ENV['FRONTEND_URL']}/campaigns/#{campaign.id}?donation=success&session_id={CHECKOUT_SESSION_ID}",
      cancel_url: "#{ENV['FRONTEND_URL']}/campaigns/#{campaign.id}?donation=cancel",
      metadata: {
        campaign_id: campaign.id,
        full_name: full_name,
        include_name: include_name
      },
      payment_intent_data: {
        transfer_data: {
          destination: founder.stripe_account.stripe_account_id
        }
      }
    }

    session_params.merge!(
      mode: 'payment',
      line_items: [{
      price_data: {
        currency: currency,
        product_data: { name: "Ủng hộ chiến dịch: #{campaign.title} - (Người tạo: #{founder.full_name})" },
        unit_amount: amount
      },
      quantity: 1
      }]
    )

    session = Stripe::Checkout::Session.create(session_params)

    render json: { url: session.url }
  rescue Stripe::StripeError => e
    render json: { error: e.message }, status: :bad_request
  rescue => e
    render json: { error: 'Không thể tạo phiên donate.' }, status: :internal_server_error
  end

  def verify_donation
    session_id = params[:session_id]
    campaign = Campaign.find(params[:id])

    session = Stripe::Checkout::Session.retrieve(session_id)
    customer = Stripe::Customer.retrieve(session.customer)

    existing = Donation.find_by(stripe_session_id: session.id)
    if existing
      render json: { message: "Đã xác nhận trước đó" }, status: :ok
      return
    end

    amount = session.amount_total
    currency = session.currency
    full_name = customer.name || "Ẩn danh"
    metadata = session.metadata || {}
    include_name = ActiveModel::Type::Boolean.new.cast(metadata["include_name"])
    subscribe_newsletter = ActiveModel::Type::Boolean.new.cast(customer.metadata["subscribe_newsletter"])

    donation = Donation.create!(
      campaign: campaign,
      amount: amount / 100.0,
      currency: currency,
      full_name: include_name ? full_name : "Ẩn danh",
      stripe_session_id: session.id,
      stripe_customer_id: customer.id,
      status: 'completed',
      include_name: include_name,
      subscribe_newsletter: subscribe_newsletter,
      donation_type: 'for_campaign',
      frequency: 'once',
    )

    render json: { success: true, donation_id: donation.id }, status: :ok
  rescue Stripe::StripeError => e
    render json: { error: e.message }, status: :bad_request
  rescue => e
    render json: { error: "Lỗi xác nhận donation: #{e.message}" }, status: :internal_server_error
  end

  private

  def campaign_params
    params.require(:campaign).permit(:title, :description, :thumbnail, :goal, :location)
  end
end
