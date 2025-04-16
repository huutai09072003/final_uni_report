class StationsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def login
    station = Station.find_by(name: params[:name])
    if station&.authenticate(params[:password])
      render json: { success: true, station: station.slice(:id, :name, :location) }
    else
      render json: { success: false, error: "Sai tên trụ hoặc mật khẩu" }, status: :unauthorized
    end
  end

  def index
    stations = Station.select(:id, :name, :location)
    render json: stations
  end
end
