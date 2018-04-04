require 'spec_helper'

describe 'UserController' do
  describe '/users' do
    before do
      fudgemin = Group.create(name: 'admin', privilege: 'admin')
      read_group = Group.create(name: 'read', privilege: 'read')
      @admin = User.create(name: 'Andy',
                           username: 'andy',
                           email: 'andy@admin.com',
                           password: 'i@f0ub#zFJbb*XFV0ANn',
                           group: fudgemin)
      @write = User.create(name: 'Richy',
                           username: 'rich',
                           email: 'rich@write.com',
                           password: 'Fug7tuff!e')
      @read = User.create(name: 'Robbie',
                          username: 'rob',
                          email: 'rob@read.com',
                          password: 'WiggleW@0p',
                          group: read_group)
      visit '/'
      fill_in :username, with: 'andy'
      fill_in :password, with: 'i@f0ub#zFJbb*XFV0ANn'
      click_button 'Sign In'
    end

    it 'lists users' do
      visit '/users'
      expect(page.body).to include(@admin.name)
      expect(page.body).to include(@admin.username)
      expect(page.body).to include(@admin.email)
    end

    it 'has links to individual users' do
      visit '/users'
      expect(page.body).to include("href=\"/users/#{@admin.id}\"")
    end

    it 'does not let anonymous people view users' do
      click_link 'Sign Out'
      visit '/users'
      expect(page.body).to include('HTTP 401')
    end

    it 'does not let non admins view users' do
      click_link 'Sign Out'
      fill_in :username, with: 'rob'
      fill_in :password, with: 'WiggleW@0p'
      visit '/users'
      expect(page.body).to include('HTTP 401')
    end
  end

  describe '/users/:id' do
    before do
      fudgemin = Group.create(name: 'admin', privilege: 'admin')
      read_group = Group.create(name: 'read', privilege: 'read')
      @admin = User.create(name: 'Andy',
                           username: 'andy',
                           email: 'andy@admin.com',
                           group: fudgemin,
                           password: 'i@f0ub#zFJbb*XFV0ANn')
      @read = User.create(name: 'Robbie',
                          username: 'rob',
                          email: 'rob@read.com',
                          group: read_group,
                          password: 'WiggleW@0p')
      visit '/'
      fill_in :username, with: 'rob'
      fill_in :password, with: 'WiggleW@0p'
      click_button 'Sign In'
    end

    it 'has the users details' do
      visit "/users/#{@read.id}"
      expect(page.body).to include(@read.name)
      expect(page.body).to include(@read.username)
      expect(page.body).to include(@read.email)
    end

    it 'links to editing a user' do
      visit "/users/#{@read.id}"
      expect(page.body).to include("/users/#{@read.id}/edit")
    end

    it 'allows a user to delete themselves' do
      visit "/users/#{@read.id}"
      click_button 'delete'
    end

    it 'does not allow users to view others profiles' do
      visit "/users/#{@admin.id}"
      expect(page.body).to include('HTTP 401')
    end
  end

  describe '/user/:id/edit' do
    before do
      @admin = Group.create(name: 'admin', privilege: 'admin')
      @write = Group.create(name: 'write', privilege: 'write')
      @read = Group.create(name: 'read', privilege: 'read')
      @admin = User.create(name: 'Andy',
                           username: 'andy',
                           email: 'andy@admin.com',
                           password: 'i@f0ub#zFJbb*XFV0ANn',
                           group: @admin)
      @richy = User.create(name: 'Richy',
                           username: 'rich',
                           email: 'rich@write.com',
                           password: 'Fug7tuff!e',
                           group: @write)
      @robbie = User.create(name: 'Robbie',
                            username: 'rob',
                            email: 'rob@read.com',
                            password: 'WiggleW@0p',
                            group: @read)
      visit '/'
      fill_in :username, with: 'andy'
      fill_in :password, with: 'i@f0ub#zFJbb*XFV0ANn'
      click_button 'Sign In'
    end

    it 'allows a user to edit their profile' do
      visit "/users/#{@admin.id}/edit"
      fill_in :username, with: 'andy'
      fill_in :name, with: 'Andrew'
      fill_in :email, with: 'andrew@admin.com'
      fill_in :current_password, with: 'i@f0ub#zFJbb*XFV0ANn'
      fill_in :new_password, with: 'N3wP@ssw0rd'
      choose "group_#{@write.id}"
      click_button 'update'
      @admin.reload
      expect(@admin.name).to eql('Andrew')
      expect(@admin.email).to eql('andrew@admin.com')
      expect(@admin.authenticate('N3wP@ssw0rd')).to be_truthy
      expect(@admin.group).to eql(@write)
    end

    it 'does not let anyone edit anyone elses profile' do
      visit "/users/#{@richy.id}/edit"
      expect(page.body).to include('HTTP 401')
    end

    it 'does not let someone not signed in edit someones profile' do
      click_link 'Sign Out'
      visit "/users/#{@admin.id}/edit"
      expect(page.body).to include('HTTP 401')
    end

    it 'does not update the profile without a valid current password' do
      visit "/users/#{@admin.id}/edit"
      fill_in :username, with: 'andy'
      fill_in :name, with: 'Andrew'
      fill_in :email, with: 'andrew@admin.com'
      fill_in :current_password, with: 'hehehe'
      fill_in :new_password, with: 'N3wP@ssw0rd'
      choose "group_#{@write.id}"
      click_button 'update'
      expect(page.body).to include('Failed to update profile')
    end

    it 'does not update the profile without valid details' do
      visit "/users/#{@admin.id}/edit"
      fill_in :username, with: ''
      fill_in :name, with: 'Andrew'
      fill_in :email, with: 'andrew@admin.com'
      fill_in :current_password, with: 'hehehe'
      fill_in :new_password, with: 'N3wP@ssw0rd'
      choose "group_#{@write.id}"
      click_button 'update'
      expect(page.body).to include('Failed to update profile')
    end
  end

  describe '/users/approvals' do
    before do
      @read = Group.create(name: 'read', privilege: 'read')
    end

    it 'blocks anonymous users' do
      visit '/users/approval'
      expect(page.body).to include('HTTP 401')
    end

    it 'blocks non admins' do
      User.create(name: 'Rob',
                  username: 'rob',
                  email: 'rob@rob.com',
                  password: 'P@ssword',
                  group: @read)
      visit '/'
      fill_in :username, with: 'rob'
      fill_in :password, with: 'P@ssword'
      click_button 'Sign In'
      visit '/users/approval'
      expect(page.body).to include('HTTP 401')
    end

    it 'allows admins to assign groups' do
      admin = Group.create(name: 'admin', privilege: 'admin')
      User.create(name: 'Andy',
                  username: 'andy',
                  email: 'andy@admin.com',
                  password: 'P@ssword',
                  group: admin)
      rob = User.create(name: 'Rob',
                        username: 'rob',
                        email: 'rob@rob.com',
                        password: 'L3tme!nn')
      visit '/'
      fill_in :username, with: 'andy'
      fill_in :password, with: 'P@ssword'
      click_button 'Sign In'
      visit '/users/approval'
      choose "user#{rob.id}_group#{admin.id}"
      click_button 'approve'
      expect(page.body).to include('User validated')
      rob.reload
      expect(rob.group.name).to eql('admin')
    end
  end
end
