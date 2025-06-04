class StripeAccountsController < ApplicationController
  protect_from_forgery with: :null_session

  def create_account
    subscriber = Subscriber.find_by(email: params[:email])

    unless subscriber
      render json: { error: "Không tìm thấy người dùng với email #{params[:email]}" }, status: :unprocessable_entity
      return
    end

    if subscriber.stripe_account.present?
      render json: { account_id: subscriber.stripe_account.stripe_account_id }, status: :ok
      return
    end

    account = Stripe::Account.create({
      type: 'express',
      country: 'US',
      email: subscriber.email,
      capabilities: {
        transfers: { requested: true }
      },
      business_type: 'individual',
    })

    subscriber.create_stripe_account!(
      stripe_account_id: account.id,
      country: 'US',
      account_type: 'express',
      status: 'created',
      details_submitted: false
    )

    render json: { account_id: account.id }
  rescue Stripe::StripeError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end


  def create_account_link
    connected_account_id = params[:account]

    account_link = Stripe::AccountLink.create({
      account: connected_account_id,
      return_url: "#{ENV['FRONTEND_URL']}/campaigns/new?stripe=return",
      refresh_url: "#{ENV['FRONTEND_URL']}/campaigns/new?stripe=refresh",
      type: "account_onboarding"
    })

    render json: { url: account_link.url }
  rescue Stripe::StripeError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
