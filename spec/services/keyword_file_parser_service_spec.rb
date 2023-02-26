# frozen_string_literal: true

require 'rails_helper'

RSpec.describe KeywordFileParserService do
  subject(:keyword_file_parser_service) { described_class.call(file) }

  let(:result) { keyword_file_parser_service.result }
  let(:file) { user.keyword_file }
  let(:escaped_malicious_input) { CGI.escapeHTML("alert('hello world');") }

  describe '#call' do
    let(:user) { create(:user, :with_keywords) }
    let(:expected_keywords) { %w[keyword COVID-19 vaccine crypto GameStop NFT Tesla Dogecoin Zoom Ethereum Bitcoin] }

    context 'when fails' do
      let(:user) { create(:user) }

      context 'when the CSV file is empty' do
        let(:user) { create(:user, :with_keywords, keywords_file: Rails.root.join('spec/fixtures/files/empty.csv')) }
        let(:expected_keywords) { [] }

        it 'returns an empty array' do
          expect(result).to eq(expected_keywords)
        end

        it 'fails' do
          expect(keyword_file_parser_service).to be_failure
        end
      end

      context 'when the CSV file has more than 100 keywords' do
        let(:user) do
          create(:user, :with_keywords, keywords_file: Rails.root.join('spec/fixtures/files/over_number_keywords.csv'))
        end

        it 'returns a list of exceeding keywords' do
          expect(result.count).to eq described_class::MAX_KEYWORDS + 1
        end

        it 'fails' do
          expect(keyword_file_parser_service).to be_failure
        end
      end

      context 'when file is not present' do
        it 'fails' do
          expect(keyword_file_parser_service).to be_failure
        end

        it 'returns an error message' do
          expect(keyword_file_parser_service.errors.full_messages.to_sentence).to eq("File can't be blank")
        end
      end
    end
  end
end
