# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Keyword CSV upload' do
  before do
    user = create(:user)
    sign_in user
  end

  it 'when user uploads a CSV file of keywords successfully' do
    visit new_keyword_path

    attach_file('keyword_file', Rails.root.join('spec/fixtures/files/keywords.csv'))
    click_button 'Upload'

    expect(page).to have_content('CSV file was uploaded successfully.')
  end

  context 'when user fails to uploads a CSV file of keywords' do
    it 'shows an error message if file is missing' do
      visit new_keyword_path

      click_button 'Upload'

      expect(page).to have_content('The file must be in CSV format and must be present.')
    end

    it 'shows an error message if file is not a CSV' do
      visit new_keyword_path

      attach_file('keyword_file', Rails.root.join('spec/fixtures/files/keywords.xlsx'))
      click_button 'Upload'

      expect(page).to have_content('The file must be in CSV format and must be present.')
    end
  end
end
