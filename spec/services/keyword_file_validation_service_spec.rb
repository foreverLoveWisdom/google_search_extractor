# frozen_string_literal: true

require 'rails_helper'

RSpec.describe KeywordFileValidationService do
  subject(:service) { described_class.call(user, file) }

  let(:user) { create(:user) }
  let(:result) { service.result }

  describe '#call' do
    context 'when the file is present' do
      let(:file) { fixture_file_upload(Rails.root.join('spec/fixtures/files/keywords.csv')) }

      it 'does not have any errors' do
        expect(service.errors).to be_empty
      end

      it 'returns true' do
        expect(service).to be_success
      end
    end

    context 'when the file is not present' do
      let(:file) { nil }

      it 'has an error' do
        expect(service.errors[:file]).to include("can't be blank")
      end

      it 'fails' do
        expect(service).to be_failure
      end
    end

    context 'when the number of keywords is below the minimum' do
      let(:file) { fixture_file_upload(Rails.root.join('spec/fixtures/files/empty.csv')) }
      let(:error_message) { "The file must contain at least #{KeywordFileValidationService::MIN_KEYWORDS} keywords." }

      it 'has an error' do
        expect(service.call.errors[:base]).to include(error_message)
      end

      it 'fails' do
        expect(service).to be_failure
      end
    end

    context 'when the number of keywords is above the maximum' do
      let(:file) { fixture_file_upload(Rails.root.join('spec/fixtures/files/over_number_keywords.csv')) }
      let(:error_message) do
        "The file must contain at most #{KeywordFileValidationService::MAX_KEYWORDS} keywords."
      end

      it 'has an error' do
        expect(service.call.errors[:base]).to include(error_message)
      end

      it 'fails' do
        expect(service).to be_failure
      end
    end

    context 'when the file cannot be attached' do
      let(:file) { fixture_file_upload(Rails.root.join('spec/fixtures/files/keywords.xlsx')) }

      it 'has an error' do
        expect(service.call.errors[:base]).to include('The file must be in the CSV format and must be present.')
      end

      it 'fails' do
        expect(service).to be_failure
      end
    end
  end
end
