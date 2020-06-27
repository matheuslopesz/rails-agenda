require 'rails_helper'

RSpec.describe Api::V1::MessagesController, type: :controller do

  let(:user) { FactoryBot.create(:user)}
  let(:user1) { FactoryBot.create(:user)}
  let(:invalid_user) { FactoryBot.create(:invalid_user)}
  let(:message) { FactoryBot.create(:message,to: user.id,from: user1.id)}
  let(:message1) { FactoryBot.create(:message,to: user1.id,from: user.id)}
  let(:archived_message) { FactoryBot.create(:message,:archived,to: user.id)}


  describe '#index' do
    before do
      allow_any_instance_of(Api::V1::MessagesController).to receive(:api_user) { user }
    end
    context 'when is master user' do
      it 'when master user list all not archived messages' do
        get :index, params: { token: user.token, permission: 'master' }
        expect(response).to have_http_status(:success)
        expect(message.attributes.keys).to match_array(["id", "title", "content",
                                                        "from", "to", "visualized", "status",
                                                        "archived", "response", "created_at",
                                                        "updated_at"])
      end 

      it 'when token default user list that were sent to user' do
        get :index, params: { token: user.token, permission: 'user'}
        expect(response).to have_http_status(:success)
        expect(message.attributes.keys).to match_array(["id", "title", "content",
                                                        "from", "to", "visualized", "status",
                                                        "archived", "response", "created_at",
                                                        "updated_at"])
      end

      it 'when invalid token' do
        get :index, params: { token: 'invalid_token'}
        expect(response).to have_http_status(:unauthorized)
      end  

    end
  end

  describe '#create' do
    before do
      allow_any_instance_of(Api::V1::MessagesController).to receive(:api_user) { user }
    end
    
    it 'create a message' do
      post :create, params:
                    { token: user.token, 
                      message: 
                        {title: 'Mensagem 1',
                         content: 'Conteudo da mensagem',
                         receiver_email: user1.email}
                    }
      expect(response).to have_http_status(:success)
    end

    it 'invalid a message' do
      post :create, params:
        { token: user.token, message: {title: 'mensagem invalida', content: 'Conteudo da mensagem'}}
       expect(assigns(:message)).to_not be_valid
    end
  end

  describe '#sent' do
    before do
      allow_any_instance_of(Api::V1::MessagesController).to receive(:api_user) { user }
    end

    it 'show all sent messages' do
      get :sent, params: { token: user.token }
      expect(response).to have_http_status(:success)
    end

    it 'when invalid token' do
      get :sent, params: { token: 'invalid_token' }
      expect(response).to have_http_status(:unauthorized)
    end  
  end

end



def create_invalid_message
  post :create, params:
        {message: {title: 'Mensagem 1', content: 'Conteudo da mensagem'}}
end