require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:user) { FactoryBot.create(:user)}

  
  describe '#index' do
    before do
      allow_any_instance_of(Api::V1::UsersController).to receive(:api_user) { user }
    end

    context 'list all users when is master user' do
      it 'when is master' do
        get :index, params: { token: user.token, permission: 'master' }
        expect(response).to have_http_status(:success)
      end 

      it 'when user is not master' do
        get :index, params: { token: user.token, permission: 'user' }
        expect(response).to have_http_status(:unauthorized)
      end

      it 'when invalid token' do
        get :index, params: { token: 'invalid_token', permission: 'user' }
        expect(response).to have_http_status(:unauthorized)
      end  

    end
  end

  describe '#messages' do 

    context 'list messages from user' do
      it 'when is master' do
        get :messages, params: { id:user.id, token: user.token, permission: 'master' }
        expect(response).to have_http_status(:success)
      end 

      it 'when is not master' do
        get :messages, params: { id:user.id, token: user.token, permission: 'user' }
        expect(response).to have_http_status(:unauthorized)
      end 

      it 'when invalid token' do
        get :messages, params: { id:user.id, token: 'invalid_token', permission: 'user' }
        expect(response).to have_http_status(:unauthorized)
      end 

    end
    
  end

end
