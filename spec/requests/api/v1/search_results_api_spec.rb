# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API::V1::SearchResults' do
  describe 'GET /api/v1/users/:user_id/keywords' do
    context 'when user is authenticated' do
      let!(:user) { create(:user, :with_authentication_token) }
      let(:headers) { { 'Authorization' => "Bearer #{user.authentication_token}" } }

      let(:error_msg) { 'Search result not found' }

      context 'when user is authenticated' do
        let(:keyword) { create(:keyword, :success, user:) }
        let(:search_result) { keyword.search_result }
        let(:expected_search_result) do
          {
            'adwords_advertisers' => search_result.adwords_advertisers,
            'total_links' => search_result.total_links,
            'total_search_results' => search_result.total_search_results,
            'html' => search_result.html
          }
        end

        before do
          get("/api/v1/keywords/#{keyword.id}/search_result", headers:)
        end

        context 'when user has keyword with successful scraping' do
          include_examples 'response success status'

          it 'returns the search result for a valid keyword' do
            expect(json_attributes).to include(expected_search_result)
          end
        end

        context 'when user has keyword with failed scraping' do
          let(:keyword) { create(:keyword, :fail, user:) }

          include_examples 'response not found status'

          it 'returns error message' do
            expect(json_errors).to include('detail' => error_msg)
          end
        end

        context 'when user has no keyword' do
          let(:keyword) { Struct.new(:id).new(1) }

          before do
            get("/api/v1/keywords/#{keyword.id}/search_result", headers:)
          end

          include_examples 'response not found status'

          it 'returns error message' do
            expect(json_errors).to include('detail' => error_msg)
          end
        end
      end
    end

    context 'when user is not authenticated' do
      let(:keyword) { Struct.new(:id).new(1) }
      let(:headers) { { 'Authorization' => "Bearer #{Faker::Internet.password}" } }

      it 'returns unauthorized' do
        get("/api/v1/keywords/#{keyword.id}/search_result", headers:)

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
