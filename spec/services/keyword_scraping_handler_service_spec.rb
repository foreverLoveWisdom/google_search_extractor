# frozen_string_literal: true

require 'rails_helper'

RSpec.describe KeywordScrapingHandlerService do
  subject(:service) { described_class.call(keyword_id:, dependencies:) }

  describe '#call' do
    let(:keyword) { create(:keyword, :pending) }
    let(:keyword_id) { keyword.id }
    let(:user_id) { keyword.user_id }
    let(:dependencies) do
      {
        scraping_service: KeywordScrapingService,
        keyword_repository: instance_double(KeywordRepository),
        search_result_repository: instance_double(SearchResultRepository)
      }
    end

    let(:extracted_scrape_data) do
      { adwords_advertisers: 1,
        html: "alert('HTML!!')",
        total_links: 12,
        total_search_results: 'About 605,000,000 results (0.42 seconds)' }
    end

    context 'when succeeds' do
      let(:persisted_keyword) { instance_double(Keyword, id: 1, status: Keyword.statuses[:success], user_id:) }
      let(:persisted_search_result) { instance_double(SearchResult, id: 1) }
      let(:scraper) do
        instance_double(dependencies[:scraping_service], success?: true,
                                                         result: extracted_scrape_data)
      end
      let(:search_result_params) do
        { keyword_id: }.merge(extracted_scrape_data)
      end

      before do
        allow(dependencies[:scraping_service]).to receive(:call).and_return(scraper)
        allow(dependencies[:keyword_repository]).to receive(:find_by).and_return(keyword)
        allow(dependencies[:keyword_repository]).to receive(:update!).and_return(persisted_keyword)
        allow(dependencies[:search_result_repository]).to receive(:create!).and_return(persisted_search_result)
      end

      it 'succeeds' do
        expect(service).to be_success
      end

      it 'update keyword status to success' do
        service

        expect(dependencies[:keyword_repository]).to have_received(:update!).with(keyword_id, status: :success)
      end

      it 'creates a search result' do
        service

        expect(dependencies[:search_result_repository]).to have_received(:create!).with(search_result_params)
      end
    end

    context 'when fails' do
      let(:general_error_message) do
        # rubocop:disable Layout/LineLength
        "We're sorry, something went wrong on our end. Please try again later or contact support if the problem persists. We apologize for the inconvenience."
        # rubocop:enable Layout/LineLength
      end

      context 'when scraping service fails' do
        let(:persisted_keyword) { instance_double(Keyword, id: 1, status: Keyword.statuses[:fail], user_id:) }
        let(:scraper) { instance_double(dependencies[:scraping_service], success?: false) }
        let(:error_message) { "The scraping for the keyword: #{keyword.name}, has failed." }
        let(:errors) { instance_double(ActiveModel::Errors, full_messages: [error_message]) }

        before do
          allow(dependencies[:scraping_service]).to receive(:call).and_return(scraper)
          allow(scraper).to receive(:errors).and_return(errors)
          allow(errors.full_messages).to receive(:to_sentence).and_return(error_message)
          allow(dependencies[:keyword_repository]).to receive(:find_by).and_return(keyword)
          allow(dependencies[:keyword_repository]).to receive(:create!).and_return(persisted_keyword)
          allow(dependencies[:keyword_repository]).to receive(:update!).and_return(persisted_keyword)
        end

        it 'fails' do
          expect(service).to be_failure
        end

        it 'returns an error message' do
          expect(service.errors.map(&:full_message)).to include(error_message)
        end

        it 'update keyword status to fail' do
          service

          expect(dependencies[:keyword_repository]).to have_received(:update!).with(keyword_id, status: :fail)
        end
      end

      context 'when update keyword status fails' do
        let(:persisted_keyword) { instance_double(Keyword, id: 1, status: Keyword.statuses[:fail], user_id:) }
        let(:scraper) do
          instance_double(dependencies[:scraping_service], success?: true, result: extracted_scrape_data)
        end

        before do
          allow(dependencies[:keyword_repository]).to receive(:find_by).and_return(keyword)
          allow(dependencies[:scraping_service]).to receive(:call).and_return(scraper)
          allow(dependencies[:keyword_repository]).to receive(:create!).and_return(persisted_keyword)
          allow(dependencies[:keyword_repository]).to receive(:update!).and_raise(ActiveRecord::RecordInvalid)
        end

        it 'fails' do
          expect(service).to be_failure
        end

        it 'returns an error message' do
          expect(service.errors.map(&:full_message)).to include(general_error_message)
        end
      end

      context 'when create_search result fails' do
        let(:persisted_keyword) { instance_double(Keyword, id: 1, status: Keyword.statuses[:success], user_id:) }
        let(:scraper) do
          instance_double(dependencies[:scraping_service], success?: true, result: extracted_scrape_data)
        end

        before do
          allow(dependencies[:keyword_repository]).to receive(:find_by).and_return(keyword)
          allow(dependencies[:scraping_service]).to receive(:call).and_return(scraper)
          allow(dependencies[:keyword_repository]).to receive(:create!).and_return(persisted_keyword)
          allow(dependencies[:keyword_repository]).to receive(:update!).and_return(persisted_keyword)
          allow(dependencies[:search_result_repository]).to receive(:create!).and_raise(ActiveRecord::RecordInvalid)
        end

        it 'fails' do
          expect(service).to be_failure
        end

        it 'returns an error message' do
          expect(service.errors.map(&:full_message)).to include(general_error_message)
        end
      end
    end
  end
end
