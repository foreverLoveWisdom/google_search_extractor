# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API::V1::Keywords' do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }

  describe 'GET /api/v1/users/:user_id/keywords' do
    context 'when user is authenticated' do
      let(:headers) { { 'Authorization' => "Bearer #{user.authentication_token}" } }

      context 'when user has keywords' do
        before do
          create_list(:keyword, 3, :success, user:)

          get("/api/v1/users/#{user.id}/keywords", headers:)
        end

        it 'returns list of keywords' do
          expect(json_data.size).to eq(3)
        end

        include_examples 'response success status'
      end

      context 'when user has no keywords' do
        let(:headers) { { 'Authorization' => "Bearer #{another_user.authentication_token}" } }

        before { get("/api/v1/users/#{another_user.id}/keywords", headers:) }

        it 'returns no keywords' do
          expect(json_data).to eq([])
        end

        include_examples 'response success status'
      end

      context "when user cannot see another user's keywords" do
        let(:headers) { { 'Authorization' => "Bearer #{user.authentication_token}" } }

        before do
          create_list(:keyword, 3, :success, user: another_user)
          create_list(:keyword, 3, :success, user:)

          get("/api/v1/users/#{user.id}/keywords", headers:)
        end

        it 'returns his own keywords' do
          expect(json_attributes.pluck('name')).not_to include([another_user.keywords.pluck(:name)])
        end

        include_examples 'response success status'
      end
    end

    context 'when user is not authenticated' do
      let(:headers) { { 'Authorization' => "Bearer #{Faker::Internet.password}" } }

      it 'returns unauthorized' do
        get("/api/v1/users/#{user.id}/keywords", headers:)

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /api/v1/users/:user_id/keywords' do
    let(:user) { create(:user) }
    let(:upload_csv) { post("/api/v1/users/#{user.id}/keywords", headers:, params: { keyword_file: }) }
    let(:keyword_file) { fixture_file_upload('keywords.csv') }

    context 'when user is authenticated' do
      let(:headers) { { 'Authorization' => "Bearer #{user.authentication_token}" } }

      context 'when file is uploaded successfully' do
        it 'returns status code 202' do
          upload_csv

          expect(response).to have_http_status(:accepted)
        end

        it 'enqueue scraping job' do
          expect do
            upload_csv
          end.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
        end
      end

      context 'when file upload fails' do
        let(:keyword_file) { fixture_file_upload('keywords.xlsx') }
        let(:error_msg) { I18n.t('keywords.upload_csv_failed') }

        it 'returns unprocessable entity status' do
          upload_csv

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'not enqueue scraping job' do
          expect do
            upload_csv
          end.not_to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size)
        end

        it 'returns error message' do
          upload_csv

          expect(json_errors).to include('detail' => error_msg)
        end
      end
    end

    context 'when user is not authenticated' do
      let(:headers) { { 'Authorization' => "Bearer #{Faker::Internet.password}" } }

      it 'returns unauthorized' do
        upload_csv

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
