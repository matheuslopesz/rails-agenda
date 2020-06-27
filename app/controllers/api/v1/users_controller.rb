class Api::V1::UsersController < ApplicationController
	before_action :validate_api_token

	def index
		if api_user.master_api(params[:permission])
			users = User.all
			render json: users, status: 200
		end 
	end

	def validate_api_token
  	render json: 'not authorized', status: 401 if api_user.nil?  || api_user.token != params[:token]
  end
end