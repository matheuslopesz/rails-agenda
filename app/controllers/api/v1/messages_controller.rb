class Api::V1::MessagesController < ApplicationController
	skip_before_action :verify_authenticity_token

  def index
    messages = api_user.master_api(params[:permission]) ? Message.master_messages.ordered : Message.sent_to(api_user).ordered
  	if authorize_api_user api_user 
  		render json: messages, status: 200
  	else
  		render json: 'msg', status: 401
  	end
  end

  def create
    user = User.find_by_email(message_params[:receiver_email]) 
    message = Message.new(message_params.merge(from: api_user.id))
    message.to = user.id if user

    if message.save
      render json: message, status: 200
    else
     render :json => { :errors => message.errors.full_messages }
    end
  end

  private

  def authorize_api_user(api_user)
		true if api_user.token == params[:token]
  end

  def message_params
    params.require(:message).permit(
      :title,
      :content,
      :receiver_email,
      :to
    )
  end

end
