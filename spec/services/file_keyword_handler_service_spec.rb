# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FileKeywordHandlerService do
  subject(:service) do
    described_class.call(
      user:,
      file:,
      dependencies: {
        file_validation_service:,
        keyword_repository:
      }
    )
  end

  let(:result) { service.result }
  let(:file_validation_service) { class_double(KeywordFileValidationService) }
  let(:keyword_repository) { instance_double(KeywordRepository) }

  describe '#call' do
    context 'when the file is valid' do
      let(:user) { create(:user, :with_keywords) }
      let(:file) { fixture_file_upload('keywords.csv') }
      let(:keyword) { instance_double(Keyword, id: 1) }
      let(:file_validation_result) do
        instance_double(KeywordFileValidationService,
                        call: instance_double(KeywordFileValidationService, success?: true))
      end

      before do
        allow(file_validation_service).to receive(:new).with(user, file).and_return(file_validation_result)
        allow(keyword_repository).to receive(:create).and_return(keyword)
      end

      it 'succeeds' do
        expect(service).to be_success
      end

      it 'parses and saves keywords' do
        expect(result.count).to eq(11)
      end
    end

    context 'when the file is empty' do
      let(:error_message) { 'File is empty' }
      let(:file) { fixture_file_upload('empty.csv') }
      let(:user) { create(:user, :with_keywords, keywords_file: file) }
      let(:errors) { instance_double(ActiveModel::Errors, full_messages: [error_message]) }
      let(:keyword_repository) { instance_double(KeywordRepository, create: '') }
      let(:file_validation_result) do
        instance_double(KeywordFileValidationService,
                        call: instance_double(KeywordFileValidationService, success?: false, errors:))
      end

      before do
        allow(file_validation_service).to receive(:call).and_return(file_validation_result)
        allow(file_validation_service).to receive(:new).with(user, file).and_return(file_validation_result)
      end

      it 'fails' do
        expect(service).to be_failure
      end

      it 'returns without parsing and saving' do
        expect(result).to eq([])
      end

      it 'does not save any keywords' do
        expect(keyword_repository).not_to have_received(:create)
      end
    end

    context 'when user and file are not present' do
      let(:user) { nil }
      let(:file) { nil }

      it 'fails' do
        expect(service).to be_failure
      end

      it 'returns error messages' do
        expect(service.errors.full_messages).to eq(["File can't be blank", "User can't be blank"])
      end
    end
  end
end
