class SubscribersController < ApplicationController
  def index
    @subscribers = Subscriber.all

    render json: @subscribers, status: :ok
  end

  def show
  end

  def create
    @subscriber = Subscriber.new(subscriber_params)

    if Subscriber.exists?(email: subscriber_params[:email])
      render json: { error: "Email đã được đăng ký", status: 422 }, status: :unprocessable_entity
    elsif @subscriber.save
      SubscriberMailer.confirmation_email(@subscriber).deliver_later
      render json: { message: "Cảm ơn bạn đã đăng ký!", status: 200 }, status: :ok
    else
      render json: { error: @subscriber.errors.full_messages, status: 422 }, status: :unprocessable_entity
    end
  end

  private

  def set_subscriber
    @subscriber = Subscriber.find(params[:id])
  end

  def subscriber_params
    params.require(:subscriber).permit(:full_name, :email, :nickname, :phone_number)
  end
end
