require 'rails_helper'

RSpec.describe Api::V1::MessagesController, type: :controller do

  let(:user) { FactoryBot.create(:user)}
  let(:user1) { FactoryBot.create(:user)}
  let(:message) { FactoryBot.create(:message,to: user.id,from: user1.id)}
  let(:archived_message) { FactoryBot.create(:message,:archived,to: user.id)}


  describe '#index' do
    context 'when is normal user and valid' do
      controller do
        def api_user
          FactoryBot.create(:user)
        end
      end
      it 'list all personal non archived messages' do
        subject { controller.api_user }
        controller.instance_variable_set(:api_user)
        get :index, params: { token:'ADMI131654' }
        expect(assigns(:messages)).to eq([message])
      end

      it 'can be reached' do
        get :index
        expect(response).to render_template :index
      end

    end
  end

end