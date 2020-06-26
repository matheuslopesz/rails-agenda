class Api::V1::MessagesController < ApplicationController
  def index
    messages = api_user.master_api(params[:permission]) ? Message.master_messages.ordered : Message.sent_to(api_user).ordered
  	if authorize_api_user api_user 
  		render json: messages, status: 200
  	else
  		render json: 'msg', status: 401
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
