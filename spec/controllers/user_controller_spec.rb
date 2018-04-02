require 'spec_helper'

describe 'UserController' do
  describe '/users' do
    before do
      @admin = User.create(name: 'Andy',
                           username: 'andy',
                           email: 'andy@admin.com',
                           password: 'i@f0ub#zFJbb*XFV0ANn')
      @write = User.create(name: 'Richy',
                           username: 'rich',
                           email: 'rich@write.com',
                           password: 'Fug7tuff!e')
      @read = User.create(name: 'Robbie',
                          username: 'rob',
                          email: 'rob@read.com',
                          password: 'WiggleW@0p')
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
  end

  describe '/users/:id' do
    before do
      @admin = User.create(name: 'Andy',
                           username: 'andy',
                           email: 'andy@admin.com',
                           password: 'i@f0ub#zFJbb*XFV0ANn')
      @write = User.create(name: 'Richy',
                           username: 'rich',
                           email: 'rich@write.com',
                           password: 'Fug7tuff!e')
      @read = User.create(name: 'Robbie',
                          username: 'rob',
                          email: 'rob@read.com',
                          password: 'WiggleW@0p')
    end

    it 'has the users details' do
      visit "/users/#{@admin.id}"
      expect(page.body).to include(@admin.name)
      expect(page.body).to include(@admin.username)
      expect(page.body).to include(@admin.email)
    end

    it 'links to editing a user' do
      visit "/users/#{@admin.id}"
      expect(page.body).to include("/users/#{@admin.id}/edit")
    end

    it 'allows you to delete a user' do
      visit "/users/#{@admin.id}"
      click_button 'delete'
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
  end
end
