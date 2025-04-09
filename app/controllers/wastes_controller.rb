class WastesController < ApplicationController
  before_action :authenticate_user!, only: [:index, :create, :identify, :new]

  def index
    @wastes = current_user.wastes.page(params[:page]).per(4)
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
  
    response = HTTParty.post(
      'http://localhost:8000/predict',
      body: {
        image: uploaded_image
      },
      headers: {
        'Content-Type' => 'multipart/form-data'
      }
    )

    binding.pry
  
    detected_type = response.parsed_response["type"] rescue "Unknown"
  
    @waste = current_user.wastes.new(waste_params.except(:image))
    @waste.waste_type = detected_type
    @waste.image.attach(uploaded_image) if uploaded_image.present?
    @waste.status = 'identified'
  
    if @waste.save
      flash[:notice] = 'Waste identified successfully!'
      redirect_to wastes_path
    else
      render inertia: 'Waste/Identify', props: {
        errors: @waste.errors.messages,
        flash: flash.to_hash
      }
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
    params.require(:waste).permit(:image, :waste_type, :status)
  end
end