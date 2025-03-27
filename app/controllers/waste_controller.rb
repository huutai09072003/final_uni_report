class WasteController < ApplicationController
  before_action :authenticate_user!, only: [:index, :create, :identify]

  def index
    @wastes = current_user.wastes # Giả sử có model Waste liên kết với User
    render inertia: 'Waste/Index', props: {
      wastes: @wastes.map { |waste| waste.as_json(only: [:id, :type, :status]) }
    }
  end

  def identify
    render inertia: 'Waste/Identify'
  end

  def create
    # Xử lý upload ảnh và nhận diện (dùng ML hoặc API bên thứ 3)
    waste = current_user.wastes.create(waste_params)
    if waste.persisted?
      flash[:notice] = 'Waste identified successfully!'
      redirect_to waste_path
    else
      render inertia: 'Waste/Identify', props: {
        errors: waste.errors.messages,
        flash: flash.to_hash
      }
    end
  end

  private

  def waste_params
    params.require(:waste).permit(:image, :type, :status)
  end
end