# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Authentication' do
  context 'when signing up' do
    before do
      visit new_user_registration_path
    end

    let(:email) { 'user@example.com' }
    let(:password) { 'password' }

    context 'when the input is valid' do
      it 'creates a new user' do
        fill_in 'Email', with: email
        fill_in 'Password', with: password
        fill_in 'Password confirmation', with: password
        click_button 'Sign up'
        expect(page).to have_content('Welcome! You have signed up successfully.')
      end
    end

    context 'when the input is invalid' do
      let(:invalid_password) { 'pass' }

      it 'shows an error message if email is missing' do
        fill_in 'Password', with: password
        fill_in 'Password confirmation', with: password
        click_button 'Sign up'
        expect(page).to have_content("Email can't be blank")
      end

      it 'shows an error message if password is too short' do
        fill_in 'Email', with: email
        fill_in 'Password', with: invalid_password
        fill_in 'Password confirmation', with: invalid_password
        click_button 'Sign up'
        expect(page).to have_content('Password is too short (minimum is 6 characters)')
      end

      it 'shows an error message if password confirmation does not match' do
        fill_in 'Email', with: 'user@example.com'
        fill_in 'Password', with: password
        fill_in 'Password confirmation', with: 'wrong_password'
        click_button 'Sign up'
        expect(page).to have_content("Password confirmation doesn't match Password")
      end
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

  context 'when signing out' do
    pending 'signs out successfully'
    # let(:user) { create(:user) }

    # before do
    #   sign_in user
    #   visit root_path
    # end

    # it 'signs out successfully and redirects to home page' do
    #   click_link 'Sign out'
    #   expect(page).to have_current_path(root_path)
    #   expect(page).to have_content('Signed out successfully.')
    # end
  end
end
