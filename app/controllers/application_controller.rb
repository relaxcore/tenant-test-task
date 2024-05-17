# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authenticate_user

  private

  def render_validation_errors(errors)
    render json: { errors: errors }, status: :unprocessable_entity
  end

  def authenticate_user
    user = User.find_by(auth_token: authorization_header)

    head :unauthorized if authorization_header.blank? || user.blank?

    Current.user = user
  end

  def authorization_header
    @authorization_header ||= request.headers['Authorization']
  end
end
