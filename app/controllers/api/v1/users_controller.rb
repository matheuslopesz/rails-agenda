class Api::V1::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_user, except: [:index]
  before_action :is_master?, only: [:index, :messages]


	def index
		users = User.all
		render json: users, status: 200
	end

	def update
		if @user.update(user_params)
			render json: @user, status: 200
		else
			 render :json => { :errors => @user.errors.full_messages }
		end
  end

	def messages
    sent = Message.sent_from(api_user).ordered
    received = Message.sent_to(api_user).ordered
    render json: { sent: sent, received: received }, status: :ok
  end

	private

	def set_user
		@user = User.find(params[:id])
	end
	
  def is_master?
    render json: 'not authorized', status: 401 unless params['permission'] == 'master'
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