class Api::V1::UsersController < ApplicationController
	before_action :validate_api_token
  skip_before_action :verify_authenticity_token
  before_action :set_user, except: [:index]


	def index
		if api_user.master_api(params[:permission])
			users = User.all
			render json: users, status: 200
		else
			render json: 'not authorized', status: 401
		end 
	end

	def update
		if @user.update(user_params)
			render json: @user, status: 200
		else
			 render :json => { :errors => @user.errors.full_messages }
		end
  end

	def messages
    if @user.master_api(params[:permission])
    	sent = Message.sent_from(api_user).ordered
    	received = Message.sent_to(api_user).ordered
    	render json: { sent: sent, received: received }, status: :ok
    else
			render json: 'not authorized', status: 401
    end
  end

	private

	def set_user
		@user = User.find(params[:id])
	end

	def validate_api_token
		################# JOGAR PRA UM FUTURO API CONTROLLER
  	render json: 'not authorized', status: 401 if api_user.nil?  || api_user.token != params[:token]
  end

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation
    )
  end
end