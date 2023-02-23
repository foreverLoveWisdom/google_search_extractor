# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'View a list of uploaded keywords' do
  let(:user) { create(:user) }
  let(:bitcoin) { 'Bitcoin' }
  let(:ethereum) { 'Ethereum' }
  let(:litecoin) { 'Litecoin' }
  let(:ripple) { 'Ripple' }
  let(:headers) { ['Keyword', 'Status', 'Created At'] }
  let(:keywords) { [bitcoin, ethereum, litecoin] }
  let(:path) { keywords_path }

  context 'when user signs in' do
    before do
      create(:keyword, :success, user:, name: bitcoin)
      create(:keyword, :success, user:, name: ethereum)
      create(:keyword, :success, user:, name: litecoin)

      sign_in user
    end

    it 'displays the correct table header' do
      visit keywords_path

      headers.each do |header|
        expect(page).to have_selector('table.table.table-striped thead tr th', text: header)
      end
    end

    it 'displays the list of uploaded keywords' do
      visit keywords_path

      keywords.each do |keyword|
        expect(page).to have_content(keyword)
      end
    end

    it 'allows a user to click on each keyword to navigate to the detailed page' do
      Keyword.all.each do |keyword|
        visit keywords_path

        expect(page).to have_link(keyword.name)
      end
    end

    it 'does not display keywords uploaded by other users' do
      other_user = create(:user)
      create(:keyword, :success, user: other_user, name: ripple)

      visit keywords_path
      expect(page).not_to have_content(ripple)
    end
  end

  context 'when user is not signed in' do
    include_context 'when user is not signed in'

    it 'redirects user to sign in path' do
      visit keywords_path

      expect_to_be_redirected_to_sign_in_page
    end
  end
end
