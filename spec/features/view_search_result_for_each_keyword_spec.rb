# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'View search result information for each keyword' do
  let(:user) { create(:user) }
  let(:bitcoin) { 'Bitcoin' }
  let(:ethereum) { 'Ethereum' }
  let(:litecoin) { 'Litecoin' }
  let!(:keyword) { create(:keyword, :success, user:, name: bitcoin) }
  let(:search_result_attributes) do
    keyword.search_result.attributes.except('id', 'keyword_id', 'updated_at', 'created_at')
  end
  let(:headers) { ['Total Number of AdWords', 'Total Number of Links', 'Total Search Results', 'HTML Source Code'] }

  context 'when user signs in' do
    before do
      create(:keyword, :success, user:, name: ethereum)
      create(:keyword, :success, user:, name: litecoin)

      sign_in user

      visit keywords_path
      link = find('a', text: keyword.name)
      link.click
    end

    it 'User views search result information for a keyword' do
      expect(page).to have_current_path("/keywords/#{keyword.id}")
    end

    it 'displays the correct table header' do
      headers.each do |header|
        expect(page).to have_selector('table.table.table-striped thead tr th', text: header)
      end
    end

    it 'displays search result info for a keyword' do
      search_result_attributes.each do |_column_name, value|
        expect(page).to have_content(value)
      end
    end
  end

  context 'when user is not signed in' do
    include_context 'when user is not signed in'

    it 'redirects user to sign in path' do
      visit keyword_path(keyword.id)

      expect_to_be_redirected_to_sign_in_page
    end
  end
end
