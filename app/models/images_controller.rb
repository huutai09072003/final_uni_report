class ImagesController < ApplicationController
  def show
    image = Image.find(params[:id])

    render json: {
      id: image.id,
      url: rails_blob_url(image.file, only_path: false)
    }
  end
end
