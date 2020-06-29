class ApiController < ApplicationController
  protect_from_forgery with: :exception
  before_action :api_user
  before_action :validate_api_token

  private

  def api_user
    User.where(token: params[:token]).last if params[:token].present?
  end  

  def validate_api_token
    render json: 'not authorized', status: 401 if api_user.nil? || api_user.token != params[:token]
  end
end
