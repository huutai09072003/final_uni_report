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
    @waste = current_user.wastes.new(waste_params.except(:image))
    @waste.waste_waste_type = "Bottle"
    @waste.image.attach(params[:waste][:image]) if params[:waste][:image].present?
    @waste.status = 'identified' # Giả sử đã nhận diện

    if @waste.save
      flash[:notice] = 'Waste identified successfully!'
      redirect_to wastes_path # /wastes
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