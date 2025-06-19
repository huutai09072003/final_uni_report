class DonationsController < ApplicationController
  before_action :validate_params, only: :create

  def index
    donations = Donation.where(include_name: true, status: 'completed').select(
      :id, :full_name, :amount, :currency, :frequency, :created_at
    ).order(created_at: :desc)

    render json: donations.map { |d|
      {
        id: d.id,
        full_name: d.full_name,
        amount: d.amount,
        currency: d.currency,
        frequency: d.frequency,
        created_at: d.created_at.strftime('%Y-%m-%d %H:%M:%S')
      }
    }
  end

  def create
    amount = params[:amount].to_i
    currency = params[:currency].to_s.downcase
    frequency = params[:frequency].to_s
    full_name = params[:full_name]
    subscribe_newsletter = params[:subscribe_newsletter] || false
    include_name = params[:include_name] || false

    customer = Stripe::Customer.create(
      name: full_name,
      metadata: {
        subscribe_newsletter: subscribe_newsletter,
        include_name: include_name
      }
    )

    session_params = {
      customer: customer.id,
      payment_method_types: ['card'],
      success_url: "#{ENV['FRONTEND_URL']}/success?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: "#{ENV['FRONTEND_URL']}/cancel",
      metadata: {
        full_name: full_name,
        subscribe_newsletter: subscribe_newsletter,
        include_name: include_name
      }
    }

    if frequency == 'once'
      # Thanh toán một lần
      session_params.merge!(
        mode: 'payment',
        line_items: [{
          price_data: {
            currency: currency,
            product_data: {
              name: 'One-time Donation',
            },
            unit_amount: amount,
          },
          quantity: 1,
        }]
      )
    else
      interval = frequency == 'monthly' ? 'month' : 'year'
      price = Stripe::Price.create(
        currency: currency,
        unit_amount: amount,
        recurring: { interval: interval },
        product_data: { name: "#{frequency.capitalize} Donation" }
      )

      session_params.merge!(
        mode: 'subscription',
        line_items: [{
          price: price.id,
          quantity: 1,
        }]
      )
    end

    session = Stripe::Checkout::Session.create(session_params)

    render json: { sessionId: session.id, publishableKey: ENV['STRIPE_PUBLISHABLE_KEY'] }
  rescue Stripe::StripeError => e
    render json: { error: e.message }, status: :bad_request
  rescue StandardError => e
    render json: { error: 'Không thể xử lý quyên góp. Vui lòng thử lại.' }, status: :internal_server_error
  end

  def success
    session = Stripe::Checkout::Session.retrieve(params[:session_id])
    payment_intent = session.payment_intent ? Stripe::PaymentIntent.retrieve(session.payment_intent) : nil
    subscription = session.subscription ? Stripe::Subscription.retrieve(session.subscription) : nil

    response_data = {
      amount: (payment_intent&.amount || subscription&.items&.data&.first&.price&.unit_amount || 0) / 100.0,
      currency: payment_intent&.currency || subscription&.items&.data&.first&.price&.currency,
      donation_type: 'for_web',
      frequency: subscription&.plan&.interval || 'once' ,
      full_name: session.metadata['full_name'] || 'Ẩn danh',
      include_name: session.metadata['include_name'] == 'true',
      status: 'completed',
      subscribe_newsletter: session.metadata['subscribe_newsletter'] == 'true',
      stripe_customer_id: session.customer,
      stripe_payment_id: session.payment_intent,
      stripe_session_id: session.id,
      stripe_subscription_id: session.subscription,
      payment_id: payment_intent&.id,
    }

    existing = Donation.find_by(stripe_session_id: session.id)
    if existing
      render json: response_data
      return
    end

    donation = Donation.create!(
      amount: response_data[:amount],
      currency: response_data[:currency],
      full_name: response_data[:full_name],
      include_name: response_data[:include_name],
      status: response_data[:status],
      subscribe_newsletter: response_data[:subscribe_newsletter],
      donation_type: response_data[:donation_type],
      frequency: response_data[:frequency],
      stripe_customer_id: response_data[:stripe_customer_id],
      stripe_payment_id: response_data[:stripe_payment_id],
      stripe_session_id: response_data[:stripe_session_id],
      stripe_subscription_id: response_data[:stripe_subscription_id]
    )

    render json: response_data
  end

  private

  def validate_params
    unless params[:amount].present? && params[:amount].to_i > 0
      render json: { error: 'Số tiền không hợp lệ.' }, status: :bad_request and return
    end

    unless ['usd', 'gbp', 'eur'].include?(params[:currency].to_s.downcase)
      render json: { error: 'Tiền tệ không được hỗ trợ.' }, status: :bad_request and return
    end

    unless ['once', 'monthly', 'annually'].include?(params[:frequency].to_s)
      render json: { error: 'Tần suất không hợp lệ.' }, status: :bad_request and return
    end

    unless params[:full_name].present?
      render json: { error: 'Vui lòng cung cấp họ và tên.' }, status: :bad_request and return
    end
  end
end