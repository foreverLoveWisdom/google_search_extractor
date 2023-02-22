# frozen_string_literal: true

require 'rails_helper'

RSpec.describe KeywordScrapingJob do
  let(:user_id) { 1 }
  let(:keyword_file_key) { 'file_key' }
  let(:storage_service) { class_double(ActiveStorage::Blob) }
  let(:keyword_file_parser_service) { class_double(KeywordFileParserService) }
  let(:keyword_scraping_handler_service) { class_double(KeywordScrapingHandlerService) }
  let(:blob) { instance_double(ActiveStorage::Blob) }
  let(:file_parser_service_result) { instance_double(:file_parser_service_result) }

  describe '#perform' do
    let(:keywords) { %w[Bitcoin] }
    let(:keyword_file_parser_service_instance) { instance_double(KeywordFileParserService).as_null_object }
    let(:keyword_scraping_handler_service_instance) { instance_double(KeywordScrapingHandlerService).as_null_object }

    context 'when keyword file is found' do
      before do
        allow(storage_service).to receive(:find_by).with(key: keyword_file_key).and_return(blob)
        allow(blob).to receive(:blank?).and_return(false)
        allow(keyword_file_parser_service).to receive(:new).with(blob)
                                                           .and_return(keyword_file_parser_service_instance)
        allow(keyword_file_parser_service_instance).to receive(:result).and_return(keywords)
        # rubocop:disable Layout/LineLength
        allow(keyword_scraping_handler_service).to receive(:new).with(user_id:,
                                                                      keywords:).and_return(keyword_scraping_handler_service_instance)
        # rubocop:enable Layout/LineLength

        described_class.perform_now(user_id:, keyword_file_key:,
                                    dependencies: { storage_service:,
                                                    keyword_file_parser_service:,
                                                    keyword_scraping_handler_service: })
      end

      it 'calls the file parser service with the keyword file' do
        expect(keyword_file_parser_service_instance).to have_received(:call)
      end

      it 'calls the scraping handler service with the parsed keywords' do
        expect(keyword_scraping_handler_service_instance).to have_received(:call)
      end
    end

    context 'when keyword file is not found' do
      before do
        allow(storage_service).to receive(:find_by).with(key: keyword_file_key).and_return(nil)

        described_class.perform_now(user_id:, keyword_file_key:,
                                    dependencies: { storage_service:,
                                                    keyword_file_parser_service:,
                                                    keyword_scraping_handler_service: })
      end

      it 'does not call the file parser service' do
        expect(keyword_file_parser_service_instance).not_to have_received(:call)
      end

      it 'does not call the scraping handler service' do
        expect(keyword_scraping_handler_service_instance).not_to have_received(:call)
      end
    end
  end
end
