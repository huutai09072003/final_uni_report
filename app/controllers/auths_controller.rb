class AuthsController < ApplicationController
  def login
    render inertia: 'Auth/Login'
  end

  def register
    render inertia: 'Auth/Register'
  end
end