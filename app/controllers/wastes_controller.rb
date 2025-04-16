class WastesController < ApplicationController
  include ActionView::Helpers::AssetUrlHelper
  before_action :authenticate_user!, only: [:index, :identify, :new]
  skip_before_action :verify_authenticity_token, only: [:create]

  def index
    @wastes = current_user.wastes.page(params[:page]).per(10)
    render inertia: 'Waste/Index', props: {
      wastes: @wastes.map { |waste| 
        waste.as_json(only: [:id, :waste_type, :status]).merge(
          image_url: waste.image.attached? ? url_for(waste.image) : nil
        )
      },
      pagination: {
        current_page: @wastes.current_page,
        total_pages: @wastes.total_pages,
        total_count: @wastes.total_count,
        per_page: @wastes.limit_value
      }
    }
  end

  def identify
    render inertia: 'Waste/Identify'
  end

  def create
    uploaded_image = params[:waste][:image]
    waste_types = Array(params.dig(:waste, :waste_types))

    created = []

    waste_types.each do |waste_type|
      waste = current_user.wastes.new(waste_params.except(:image))
      waste.waste_type = waste_type
      waste.status = 'identified'
      waste.image.attach(uploaded_image) if uploaded_image.present?

      if waste.save
        created << waste

        # Gửi Waste qua waste_channel
        ActionCable.server.broadcast("waste_channel_user_#{current_user.id}", {
          id: waste.id,
          waste_type: waste.waste_type,
          status: waste.status,
          image_url: waste.image.attached? ? url_for(waste.image) : nil,
          created_at: waste.created_at.strftime("%Y-%m-%d %H:%M:%S")
        })
      end
    end

    if created.any?
      # Tạo Notification
      notification = Notification.create!(
        user: current_user,
        title: "Waste identified",
        body: "Có thêm rác đã được nhận diện.",
        read: false
      )

      # Gửi Notification qua notification_channel
      ActionCable.server.broadcast("notification_channel_user_#{current_user.id}", {
        id: notification.id,
        title: notification.title,
        body: notification.body,
        read: notification.read,
        created_at: notification.created_at.strftime("%Y-%m-%d %H:%M:%S")
      })

      render json: {
        success: true,
        message: 'Wastes saved successfully',
        wastes: created.map { |w| { id: w.id, waste_type: w.waste_type, status: w.status } }
      }, status: :created
    else
      render json: {
        success: false,
        errors: ['Không lưu được loại rác nào.']
      }, status: :unprocessable_entity
    end
  end

  def new
    render inertia: 'Waste/New'
  end

  def show
    @waste = current_user.wastes.find(params[:id])
    render inertia: 'Waste/Show', props: {
      waste: @waste.as_json(only: [:id, :waste_type, :status]).merge(
        image_url: @waste.image.attached? ? url_for(@waste.image) : nil
      )
    }
  end

  private

  def waste_params
    params.require(:waste).permit(:name, :description, :image)
  end
end