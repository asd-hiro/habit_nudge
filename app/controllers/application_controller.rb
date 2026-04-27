class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: :devise_controller?
  before_action :basic_auth
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def configure_permitted_parameters
    # サインアップ時にnameとnicknameカラムを許容する
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :character_name])
  end

  def basic_auth
    # ログ出力（RenderのLogsで確認してください）
    Rails.logger.info '--- Basic Auth Check Start ---'
    Rails.logger.info "ENV USER: #{ENV['BASIC_AUTH_USER'].inspect}"
    Rails.logger.info "ENV PASS: #{ENV['BASIC_AUTH_PASSWORD'].inspect}"

    authenticate_or_request_with_http_basic do |username, password|
      # 比較処理
      username == ENV['BASIC_AUTH_USER'] && password == ENV['BASIC_AUTH_PASSWORD']
    end
  end
end
