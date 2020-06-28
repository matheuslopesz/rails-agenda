require "application_responder"
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :api_user
  before_action :validate_api_token

  

  layout :layout_by_resource
  self.responder = ApplicationResponder
  respond_to :html

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def after_sign_in_path_for(resource)
    messages_path
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash.now[:danger] = "Acesso negado. Você não está autorizado a acessar essa página"
    redirect_to messages_path, flash: {danger: "Acesso negado. Você não está autorizado a acessar essa página"}
  end
  private

  def layout_by_resource
    if devise_controller?
      'login'
    else
      'application'
    end
  end

  def api_user
    User.where(token: params[:token]).last if params[:token].present?
  end  

  def validate_api_token
    render json: 'not authorized', status: 401 if api_user.nil?  || api_user.token != params[:token]
  end
end
