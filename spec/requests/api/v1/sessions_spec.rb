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

      include_examples 'response success status'

      it 'returns the user authentication token' do
        expect(json_attributes['authentication_token']).to eq(user.authentication_token)
      end
    end

    context 'with invalid credentials' do
      before { post '/api/v1/signin', params: invalid_credentials }

      it 'returns an error message' do
        expect(json_errors).to include('detail' => error_msg)
      end

      include_examples 'response unprocessable entity status'
    end

    context 'with missing parameters' do
      before { post '/api/v1/signin', params: { email: user.email } }

      it 'returns an error message' do
        expect(json_errors).to include('detail' => error_msg)
      end

      include_examples 'response unprocessable entity status'
    end
  end
end
