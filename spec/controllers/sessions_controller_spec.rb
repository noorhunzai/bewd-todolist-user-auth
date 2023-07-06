require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'POST /sessions' do
    it 'renders new session object' do
      user = FactoryBot.create(:user, username: 'asdasdasd', password: 'asdasdasd')

      post :create, params: {
        username: 'asdasdasd',
        password: 'asdasdasd'
      }

      session = Session.last # Fetch the latest session object from the database

      expect(response.body).to eq({ success: true, session_token: session.token }.to_json)
    end
  end

  describe 'GET /authenticated' do
    let(:user) { FactoryBot.create(:user, username: 'user1', password: 'password') }

    it 'renders authenticated user object' do
      session = user.sessions.create
      get :authenticated, params: { session_token: session.token }
      expect(response.body).to eq({ authenticated: true, username: 'user1' }.to_json)
    end

    it 'renders unauthenticated user object' do
      get :authenticated
      expect(response.body).to eq({ authenticated: false, username: nil }.to_json)
    end
  end

  describe 'DELETE /sessions' do
    let(:user) { FactoryBot.create(:user, username: 'user1', password: 'password') }

    it 'renders success' do
      session = user.sessions.create
      delete :destroy, params: { session_token: session.token }
      expect(response.body).to eq({ success: true }.to_json)
    end

    it 'renders failure for invalid session token' do
      delete :destroy, params: { session_token: 'invalid_token' }
      expect(response.body).to eq({ success: false }.to_json)
    end
  end
end
