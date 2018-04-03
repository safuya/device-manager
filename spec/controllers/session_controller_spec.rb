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

  describe 'Sign Out' do
    it 'signs users out' do
      admin = Group.create(name: 'admin', privilege: 'admin')
      User.create(username: 'rob',
                  password: 'P@ssword',
                  email: '1@2.co',
                  name: 'rob',
                  group: admin)
      visit '/'
      fill_in :username, with: 'rob'
      fill_in :password, with: 'P@ssword'
      click_button 'Sign In'
      click_link 'Sign Out'
      expect(page.body).to include('Apply for Access')
    end
  end

  describe 'Apply' do
    it 'shows the apply page' do
      visit '/apply'
      expect(page.body).to include('Username')
      expect(page.body).to include('Name')
      expect(page.body).to include('Email')
      expect(page.body).to include('Password')
      expect(page.body).to include('Apply')
    end

    it 'adds the user without a group' do
      visit '/apply'
      fill_in :username, with: 'newbie'
      fill_in :name, with: 'Jim'
      fill_in :email, with: 'jim@jim.com'
      fill_in :password, with: 'S@cur3pass'
      click_button 'Apply'
      jim = User.find_by(username: 'newbie')
      expect(jim.name).to eql('Jim')
      expect(jim.group).to eql(nil)
    end
  end
end
