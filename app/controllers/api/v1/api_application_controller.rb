class Api::V1::ApiApplicationController < ApplicationController
  protect_from_forgery unless: -> { request.format.json? }

  def authenticate_api_user!
    header = request.headers['Authorization']
    return render_unauthorized unless header

    token = header.split(' ').last
    return render_unauthorized unless token

    begin
      decoded = JWT.decode(token, Rails.application.secret_key_base, true, algorithm: 'HS256')
      user_id = decoded[0]['user_id']
      @current_user ||= User.find_by(id: user_id)
      return render_unauthorized unless @current_user

    rescue StandardError => e
      Rails.logger.error("JWT Error: #{e.message}")
      render_unauthorized
    end
  end

  def current_user
    @current_user
  end

  private

  def render_unauthorized
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
end
