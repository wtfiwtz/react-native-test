class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Require authentication by default
  #before_filter :require_login

  # CanCan authorization in everything
  check_authorization unless: :authorized_controllers?

  # Rescues
  #rescue_from ActiveRecord::RecordNotUnique do |e| handle_email_not_unique(e); end
  rescue_from CanCan::AccessDenied do |exception|
    render file: "#{Rails.root}/public/403", status: 403, formats: [:html, :json], layout: false
  end

protected

  def not_authenticated
    redirect_to login_path, alert: 'Please login first'
  end

  def authorized_controllers?
    devise_controller? or kind_of? ActiveAdmin::BaseController or kind_of? OauthsController
  end

  #def handle_email_not_unique(e)
  #  render json: {error: 'Email address is not unique'}, status: :unprocessable_entity
  #end

end
