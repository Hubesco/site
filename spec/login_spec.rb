require_relative './spec_helper'

feature 'Visitor signs up' do
  scenario 'with valid email and password' do
    sign_up_with $vars['user']['username'], $vars['user']['password']
    expect(page).to have_content('Logout')
  end

  scenario 'with invalid email' do
    sign_up_with 'invalid_email', 'password'
    expect(page).to have_content('Could not match user and password.')
  end

  scenario 'with blank password' do
    sign_up_with 'valid@example.com', ''
    expect(page).to have_content('Could not match user and password.')
  end

  def sign_up_with(email, password)
    visit '/login'
    fill_in 'username', with: email
    fill_in 'password', with: password
    click_button 'submit'
  end
end