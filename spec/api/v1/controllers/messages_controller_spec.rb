require 'rails_helper'

RSpec.describe Api::V1::MessagesController, type: :controller do

  let(:user) { FactoryBot.create(:user)}
  let(:user1) { FactoryBot.create(:user)}
  let(:invalid_user) { FactoryBot.create(:invalid_user)}
  let(:message) { FactoryBot.create(:message,to: user.id,from: user1.id)}
  let(:archived_message) { FactoryBot.create(:message,:archived,to: user.id)}


  describe '#index' do
    before do
      allow_any_instance_of(Api::V1::MessagesController).to receive(:api_user) { user }
    end
    context 'when is master user' do
      it 'when master user list all not archived messages' do
        get :index, params: { token: user.token, permission: 'master' }
        expect(response).to have_http_status(:success)
      end 

      it 'when token default user list that were sent to user' do
        get :index, params: { token: user.token, permission: 'user'}
        expect(response).to have_http_status(:success)
      end

      it 'when invalid token' do
        get :index, params: { token: 'invalid_token'}
        expect(response).to have_http_status(:unauthorized)
      end         
    end
  end

end