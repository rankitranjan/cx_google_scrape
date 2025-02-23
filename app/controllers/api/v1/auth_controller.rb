class Api::V1::AuthController < Api::V1::ApiApplicationController
  def sign_in
    user = User.find_by(email: params[:email])

    if user&.valid_password?(params[:password])
      token = generate_jwt_token(user.id)
      render json: { token: token }, status: :ok
    else
      render_unauthorized
    end
  end

  private

  def secret_key
    @secret_key ||= Rails.application.secret_key_base
  end

  def generate_jwt_token(user_id)
    payload = { user_id: user_id, exp: 24.hours.from_now.to_i }
    JWT.encode(payload, secret_key, 'HS256')
  end

  def render_unauthorized
    render json: { error: 'Invalid email or password' }, status: :unauthorized
  end
end
