class Api::V1::MessagesController < ApplicationController
	skip_before_action :verify_authenticity_token
	before_action :validate_api_token
	before_action :set_message, only: [:show, :archive]

  def index
    messages = api_user.master_api(params[:permission]) ? Message.master_messages.ordered : Message.sent_to(api_user).ordered 
  	render json: messages, status: 200
  end

  def create
    user = User.find_by_email(message_params[:receiver_email]) 
    @message = Message.new(message_params.merge(from: api_user.id))
    @message.to = user.id if user

    if @message.save
      render json: @message, status: 200
    else
     render :json => { :errors => @message.errors.full_messages }
    end
  end

  def sent
    messages = Message.sent_from(api_user).ordered
    render json: messages, status: 200
  end

  def archived
    # metodo de master ???
  	if api_user.master_api(params[:permission])
    	messages = Message.includes(:sender).archived.ordered
    	render json: messages, status: 200
    else
    	render json: 'not authorized', status: 401
    end
  end

   def show
   	# metodo verificar se é dono
    if api_user == @message.receiver
      @message.read!
      render json: @message, status: 200
    else
    	render json: 'not authorized', status: 401
    end
  end

  def archive
  	# metodo verificar se é dono
    if api_user == @message.receiver
      @message.read!
      render json: @message, status: 200
    else
    	render json: 'not authorized', status: 401
    end
  end

  def archive_multiple
    messages = Message.find(params[:message_ids])
    Message.archive_multiple(messages)
    render json: messages, status: 200 
  end

  private

  def set_message
		@message = Message.find(params[:id])
	end

  def validate_api_token
  	render json: 'not authorized', status: 401 if api_user.nil?  || api_user.token != params[:token]
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
