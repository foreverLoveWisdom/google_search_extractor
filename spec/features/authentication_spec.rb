# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Authentication' do
  context 'when signing up' do
    before do
      visit new_user_registration_path
    end

    it 'creates a new user' do
      fill_in 'Email', with: 'user@example.com'
      fill_in 'Password', with: 'password'
      fill_in 'Password confirmation', with: 'password'
      click_button 'Sign up'
      expect(page).to have_content('Welcome! You have signed up successfully.')
    end

    it 'shows an error message if email is missing' do
      fill_in 'Password', with: 'password'
      fill_in 'Password confirmation', with: 'password'
      click_button 'Sign up'
      expect(page).to have_content("Email can't be blank")
    end

    it 'shows an error message if password is too short' do
      fill_in 'Email', with: 'user@example.com'
      fill_in 'Password', with: 'pass'
      fill_in 'Password confirmation', with: 'pass'
      click_button 'Sign up'
      expect(page).to have_content('Password is too short (minimum is 6 characters)')
    end

    it 'shows an error message if password confirmation does not match' do
      fill_in 'Email', with: 'user@example.com'
      fill_in 'Password', with: 'password'
      fill_in 'Password confirmation', with: 'wrong_password'
      click_button 'Sign up'
      expect(page).to have_content("Password confirmation doesn't match Password")
    end
  end

  context 'when signing in' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
    end

    it 'signs in successfully' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Log in'
      expect(page).to have_content('Signed in successfully.')
    end

    it 'shows an error message if email is missing' do
      fill_in 'Password', with: user.password
      click_button 'Log in'
      expect(page).to have_content('Invalid Email or password.')
    end

    it 'shows an error message if password is missing' do
      fill_in 'Email', with: user.email
      click_button 'Log in'
      expect(page).to have_content('Invalid Email or password.')
    end

    it 'shows an error message if email and password are incorrect' do
      fill_in 'Email', with: 'wrong_email@example.com'
      fill_in 'Password', with: 'wrong_password'
      click_button 'Log in'
      expect(page).to have_content('Invalid Email or password.')
    end
  end
end
