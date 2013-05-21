require './spec_helper'

feature 'Visitor accesses' do

  scenario 'home page' do
    visit '/'
    page.assert_selector('h2', :text => 'Own your own data')
    page.should have_link('Login', :href=>'/login')
    page.should have_link('Mail', :href=>'https://mail.hubesco.com')
    page.should have_link('Cloud', :href=>'https://cloud.hubesco.com')
    page.should have_link('Autoblog', :href=>'https://autoblog.hubesco.com')
    page.should have_link('Contact us', :href=>'mailto:paolo.escobar@hubesco.com')
  end

  scenario 'login page' do
    visit '/login'
    page.assert_selector('h2', :text => 'Login')
  end

  scenario 'about page' do
    visit '/about'
    page.assert_selector('h2', :text => 'The crew')
  end

end

