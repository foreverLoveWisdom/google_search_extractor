# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API::V1::Sessions' do
  describe 'POST /api/v1/signin' do
    let!(:user) { create(:user, :with_authentication_token) }
    let(:valid_credentials) { { email: user.email, password: user.password } }
    let(:invalid_credentials) { { email: user.email, password: 'invalid' } }
    let(:error_msg) { 'Invalid email or password' }

    context 'with valid credentials' do
      before { post '/api/v1/signin', params: valid_credentials }

      it 'returns status code 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the user authentication token' do
        expect(json_attribute_for('authentication_token')).to eq(user.authentication_token)
      end
    end

    context 'with invalid credentials' do
      before { post '/api/v1/signin', params: invalid_credentials }

      it 'returns an error message' do
        expect(json_errors).to include('detail' => error_msg)
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with missing parameters' do
      before { post '/api/v1/signin', params: { email: user.email } }

      it 'returns an error message' do
        expect(json_errors).to include('detail' => error_msg)
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
