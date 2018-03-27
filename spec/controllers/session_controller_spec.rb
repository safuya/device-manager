require 'spec_helper'

describe 'SessionController' do
  describe 'Login' do
    it 'displays a login page if not logged in' do
      visit '/'
      expect(page.body).to include('Apply for Access')
      expect(page.body).to include('Username')
      expect(page.body).to include('Password')
      expect(page.body).to include('Sign In')
      expect(page.body).to include('computer managed by BT')
    end

    it 'lets valid users login' do
      User.create(username: 'rob',
                  password: 'P@ssword',
                  email: '1@2.co',
                  name: 'rob')
      visit '/'
      fill_in :username, with: 'rob'
      fill_in :password, with: 'P@ssword'
      click_button 'Sign In'
      expect(page.body).to include('Devices')
    end

    it 'blocks invalid users' do
      visit '/'
      fill_in :username, with: 'bad man'
      fill_in :password, with: 'letmein'
      click_button 'Sign In'
      expect(page.body).to include('Sign In')
    end
  end
end
