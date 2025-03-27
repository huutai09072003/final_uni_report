class PagesController < ApplicationController
  def index
    render inertia: 'Page/Index'
  end
end