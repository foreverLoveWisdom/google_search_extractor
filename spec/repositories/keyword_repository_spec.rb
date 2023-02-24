# frozen_string_literal: true

require 'rails_helper'

RSpec.describe KeywordRepository do
  let(:keyword_repository) { described_class.new }

  describe '#search' do
    let(:bitcoin) { 'bitcoin' }
    let(:keyword) { bitcoin }
    let(:user) { create(:user) }
    let(:user_id) { user.id }

    context 'when matching keywords exist' do
      let!(:matching_keywords) do
        [create(:keyword, :success, user:, name: bitcoin),
         create(:keyword, :success, user:, name: 'Bitcoin Cash')]
      end

      let(:keyword_search) { keyword_repository.search(keyword, user_id) }

      it 'returns all matching keywords ordered by name ASC' do
        expect(keyword_search).to match_array(matching_keywords.sort_by(&:name))
      end

      it 'returns corresponding search results' do
        expect(keyword_search.map(&:search_result)).to match_array(matching_keywords.map(&:search_result))
      end
    end

    context 'when no matching keywords exist' do
      before { create(:keyword, user:, name: 'Tesla') }

      it 'returns an empty result' do
        expect(keyword_repository.search(keyword, user_id)).to eq([])
      end
    end
  end
end
