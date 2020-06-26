class Api::V1::MessagesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
  	binding.pry
    messages = api_user.master_api(params[:permission]) ? Message.master_messages.ordered : Message.sent_to(api_user).ordered
  	render json: messages
  end

  private

  def message_params
    params.require(:message).permit(
      :title,
      :content,
      :receiver_email,
      :to
    )
  end

end
