# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Search Across Report' do
  let(:user) { create(:user) }
  let(:bitcoin) { 'Bitcoin' }
  let(:keyword) { bitcoin }
  let(:relevant_keyword) { 'bIt' }
  let(:headers) do
    ['Keyword',
     'Status',
     'Total Number of AdWords',
     'Total Number of Links',
     'Total Search Results',
     'HTML Source Code',
     'Created At']
  end
  let!(:bitcoin_keyword) { create(:keyword, :success, name: bitcoin, user:) }
  let(:ethereum_keyword) { create(:keyword, :success, name: 'Ethereum', user:) }
  let(:search_result_attributes) do
    bitcoin_keyword.search_result.attributes.except('id', 'keyword_id', 'updated_at', 'created_at')
  end

  before do
    sign_in user
    visit search_path
    fill_in 'keyword', with: keyword
    click_on 'Search'
  end

  context 'when there are matching keywords' do
    RSpec.shared_examples 'does not include irrelevant keyword' do
      it 'not return irrelevant keyword' do
        expect(page).not_to have_content(irrelevant_keyword)
      end
    end

    context 'when enters the exact keyword' do
      it_behaves_like 'does not include irrelevant keyword' do
        let(:irrelevant_keyword) { ethereum_keyword.name }
      end

      it 'displays the correct table header' do
        headers.each do |header|
          expect(page).to have_selector('table.table.table-striped thead tr th', text: header)
        end
      end

      it 'displays search result infor for matching keywords' do
        search_result_attributes.each do |_column_name, value|
          expect(page).to have_content(value)
        end
      end
    end

    context 'when enters relevant keyword' do
      let(:keyword) { relevant_keyword }

      it_behaves_like 'does not include irrelevant keyword' do
        let(:irrelevant_keyword) { ethereum_keyword.name }
      end

      it 'displays the correct table header' do
        headers.each do |header|
          expect(page).to have_selector('table.table.table-striped thead tr th', text: header)
        end
      end

      it 'displays search result infor for matching keywords' do
        search_result_attributes.each do |_column_name, value|
          expect(page).to have_content(value)
        end
      end
    end
  end

  context 'when there are not matching keywords' do
    let(:keyword) { 'Tesla' }

    it 'user searches for a keyword with no matching results' do
      expect(page).to have_content('No matching keywords found.')
    end
  end
end
