class GamesController < ApplicationController
  include Rails.application.routes.url_helpers
  require 'open-uri'

  def index
    games = Game.includes(:images, :featured_image_attachment).all.map do |game|
      {
        id: game.id,
        name: game.name,
        description: game.description,
        featured_image_url: game.featured_image.attached? ? url_for(game.featured_image) : nil,
        images: game.images.map do |image|
          {
            id: image.id,
            name: image.name,
            url: image.file.attached? ? url_for(image.file) : nil
          }
        end
      }
    end

    render json: games
  end

  def show
    game = Game.includes(:images, :featured_image_attachment).find(params[:id])

    render json: {
      id: game.id,
      name: game.name,
      description: game.description,
      featured_image_url: game.featured_image.attached? ? url_for(game.featured_image) : nil,
      images: game.images.map do |image|
        {
          id: image.id,
          name: image.name,
          url: image.file.attached? ? url_for(image.file) : nil
        }
      end
    }
  end

  def upload_image
    game = Game.find(params[:id])
    image = game.images.build(name: params[:name])
    image.file.attach(params[:file])

    if image.save
      render json: {
        id: image.id,
        name: image.name,
        url: image.file.attached? ? url_for(image.file) : nil
      }, status: :created
    else
      render json: { error: image.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def upload_image_from_url
    image_url = params[:url]
    raise ActionController::BadRequest, "Thiếu URL" if image_url.blank?

    game = Game.find(params[:id])  # lấy đúng game theo route

    downloaded_image = URI.open(image_url)

    image = game.images.new(name: params[:name] || File.basename(URI.parse(image_url).path))
    image.file.attach(io: downloaded_image, filename: "image_#{SecureRandom.hex(6)}.jpg")

    if image.save
      render json: {
        id: image.id,
        name: image.name,
        url: image.file.attached? ? url_for(image.file) : nil
      }, status: :created
    else
      render json: { error: image.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Không tìm thấy game" }, status: :not_found
  rescue OpenURI::HTTPError => e
    render json: { error: "Lỗi tải ảnh từ URL: #{e.message}" }, status: :bad_request
  rescue => e
    render json: { error: "Lỗi xử lý ảnh: #{e.message}" }, status: :unprocessable_entity
  end
end
