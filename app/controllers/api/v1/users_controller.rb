class Api::V1::UsersController < ApplicationController
	before_action :validate_api_token

	def index
		if api_user.master_api(params[:permission])
			users = User.all
			render json: users, status: 200
		else
			render json: 'not authorized', status: 401
		end 
	end

	def messages
    if api_user.master_api(params[:permission])
    	sent = Message.sent_from(api_user).ordered
    	received = Message.sent_to(api_user).ordered
    	render json: { sent: sent, received: received }, status: :ok
    else
			render json: 'not authorized', status: 401
    end
  end

	private

	def validate_api_token
  	render json: 'not authorized', status: 401 if api_user.nil?  || api_user.token != params[:token]
  end
end