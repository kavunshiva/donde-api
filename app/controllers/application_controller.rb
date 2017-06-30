class ApplicationController < ActionController::API
  private

  def authorize_user!
    if !current_user.present?
      render json: {error: 'no user ID present'}, status: 404
    end
  end

  def authorize_device!
    if !current_device.present?
      render json: {error: 'no device ID present'}, status: 404
    end
  end

  def current_user
    @current_user ||= User.find_by(id: user_id)
  end

  def current_device
    @current_device ||= Device.find_by(id: device_id)
  end

  def user_id
    decoded_token.first['user_id']
  end

  def device_id
    decoded_token.first['device_id']
  end

  def decoded_token
    if token
      begin
        JWT.decode(token, ENV['JWT_SECRET'], true, {algorithm: false})
      rescue JWT::DecodeError
        [{}]
      end
    else
      [{}]
    end
  end

  def token
    request.headers['Authorization']
  end
end
