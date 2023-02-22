# frozen_string_literal: true

require 'rails_helper'

RSpec.describe KeywordScrapingHandlerService do
  subject(:service) { described_class.call(user_id:, keywords:, dependencies:) }

  describe '#call' do
    let(:user_id) { 1 }
    let(:keywords) { %w[insurance] }
    let(:dependencies) do
      {
        scraping_service: KeywordScrapingService,
        keyword_repository: instance_double(KeywordRepository),
        search_result_repository: instance_double(SearchResultRepository)
      }
    end

    context 'when succeeds' do
      let(:persisted_keyword) { instance_double(Keyword, id: 1, status: Keyword.statuses[:success], user_id:) }
      let(:persisted_search_result) { instance_double(SearchResult, id: 1) }
      let(:keyword_repository) do
        instance_double(KeywordRepository, create!: persisted_keyword, update!: persisted_keyword)
      end
      let(:scraper) { instance_double(dependencies[:scraping_service], success?: true) }

      before do
        allow(dependencies[:scraping_service]).to receive(:call).and_return(scraper)
        allow(dependencies[:keyword_repository]).to receive(:create!).and_return(persisted_keyword)
        allow(dependencies[:keyword_repository]).to receive(:update!).and_return(persisted_keyword)
        allow(dependencies[:search_result_repository]).to receive(:create!).and_return(persisted_search_result)
      end

      it 'succeeds' do
        expect(service).to be_success
      end

      it 'returns a list of created search result' do
        expect(service.result).to eq([persisted_search_result.id])
      end
    end

    context 'when fails' do
      let(:general_error_message) do
        "We're sorry, something went wrong on our end. Please try again later or contact support if the problem persists. We apologize for the inconvenience."
      end

      context 'when scraping service fails' do
        let(:persisted_keyword) { instance_double(Keyword, id: 1, status: Keyword.statuses[:fail], user_id:) }
        let(:keyword_repository) do
          instance_double(KeywordRepository, create!: persisted_keyword, update!: persisted_keyword)
        end
        let(:scraper) { instance_double(dependencies[:scraping_service], success?: false) }
        let(:error_message) { "The scraping for the keyword: #{keywords.first}, has failed." }

        before do
          allow(dependencies[:scraping_service]).to receive(:call).and_return(scraper)
          allow(dependencies[:keyword_repository]).to receive(:create!).and_return(persisted_keyword)
          allow(dependencies[:keyword_repository]).to receive(:update!).and_return(persisted_keyword)
        end

        it 'fails' do
          expect(service).to be_failure
        end

        it 'returns an error message' do
          expect(service.errors.map(&:full_message)).to include(error_message)
        end
      end

      context 'when update keyword status fails' do
        let(:persisted_keyword) { instance_double(Keyword, id: 1, status: Keyword.statuses[:fail], user_id:) }
        let(:keyword_repository) do
          instance_double(KeywordRepository, create!: persisted_keyword, update!: persisted_keyword)
        end
        let(:scraper) { instance_double(dependencies[:scraping_service], success?: true) }

        before do
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
        let(:keyword_repository) do
          instance_double(KeywordRepository, create!: persisted_keyword, update!: persisted_keyword)
        end
        let(:scraper) { instance_double(dependencies[:scraping_service], success?: true) }

        before do
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
