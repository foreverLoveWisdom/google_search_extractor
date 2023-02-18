# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Keyword CSV upload' do
  before do
    user = create(:user)
    sign_in user
  end

  it 'when user uploads a CSV file of keywords successfully' do
    visit new_keyword_path

    attach_file('keyword', Rails.root.join('spec/fixtures/files/keywords.csv'))
    click_button 'Upload'

    expect(page).to have_content('CSV file was uploaded successfully.')
  end

  context 'when user fails to uploads a CSV file of keywords' do
    it 'shows an error message if file is missing' do
      visit new_keyword_path

      attach_file('keyword')
      click_button 'Upload'

      expect(page).to have_content('Sorry, please upload a CSV file.')
    end

    it 'shows an error message if file is not a CSV' do
      visit new_keyword_path

      attach_file('keyword')
      click_button 'Upload'

      expect(page).to have_content('Sorry, only CSV files are allowed.')
    end
  end
end
