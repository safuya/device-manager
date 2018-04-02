require 'spec_helper'

describe 'GroupController' do
  describe '/groups' do
    before(:each) do
      @admin = Group.create(name: 'admin', privilege: 'admin')
      @read = Group.create(name: 'reader', privilege: 'read')
      @content_admin = Group.create(name: 'content', privilege: 'admin')
      @andy = User.create(name: 'Andy',
                          username: 'andy',
                          email: 'andy@admin.com',
                          password: 'i@f0ub#zFJbb*XFV0ANn',
                          group_id: @admin.id)
      @robbie = User.create(name: 'Robbie',
                            username: 'robbie',
                            email: 'robbie@read.com',
                            password: 'L3tmein!',
                            group_id: @read.id)
    end

    it 'shows unauthorized if not logged in' do
      visit '/groups'
      expect(page.body).to include('HTTP 401')
    end

    it 'shows unauthorized if the user is not an admin' do
      visit '/'
      fill_in :username, with: 'robbie'
      fill_in :password, with: 'L3tmein!'
      click_button 'Sign In'
      visit '/groups'
      expect(page.body).to include('HTTP 401')
    end

    it 'lists all the groups' do
      visit '/'
      fill_in :username, with: 'andy'
      fill_in :password, with: 'i@f0ub#zFJbb*XFV0ANn'
      click_button 'Sign In'
      visit '/groups'
      expect(page.body).to include(@admin.name)
      expect(page.body).to include(@admin.privilege)
      expect(page.body).to include(@read.privilege)
      expect(page.body).to include(@content_admin.name)
    end

    it 'links to individual groups' do
      visit '/'
      fill_in :username, with: 'andy'
      fill_in :password, with: 'i@f0ub#zFJbb*XFV0ANn'
      click_button 'Sign In'
      visit '/groups'
      click_link @admin.name
      expect(page.status_code).to eql(200)
    end
  end

  describe '/groups/:id' do
    before do
      @admin = Group.create(name: 'admin', privilege: 'admin')
      @read = Group.create(name: 'read', privilege: 'read')
      @hub = Device.create(serial_number: '123',
                           model: 'HH6A',
                           groups: [@admin])
      @stb = Device.create(serial_number: '321',
                           model: 'TLA',
                           groups: [@admin])
      @andy = User.create(name: 'Andy',
                          username: 'andy',
                          email: 'andy@admin.com',
                          password: 'i@f0ub#zFJbb*XFV0ANn',
                          group_id: @admin.id)
      @richy = User.create(name: 'Richy',
                           username: 'rich',
                           email: 'rich@write.com',
                           password: 'Fug7tuff!e',
                           group_id: @admin.id)
      @notadmin = User.create(name: 'Groot',
                              username: 'groot',
                              email: 'groot@gotg.org',
                              password: 'IAmGr00t',
                              group_id: @read.id)
      visit '/'
      fill_in :username, with: 'andy'
      fill_in :password, with: 'i@f0ub#zFJbb*XFV0ANn'
      click_button 'Sign In'
    end

    it 'allows you to view an individual group' do
      visit "/groups/#{@admin.id}"
      expect(page.body).to include(@admin.name)
      expect(page.body).to include(@admin.privilege)
      expect(page.body).to include(@hub.serial_number)
      expect(page.body).to include(@stb.serial_number)
      expect(page.body).to include(@andy.name)
      expect(page.body).to include(@richy.name)
    end

    it 'links to editing a group' do
      visit "/groups/#{@admin.id}"
      click_link 'edit'
      expect(page.status_code).to eql(200)
    end

    it 'lets you delete a group' do
      visit "/groups/#{@admin.id}"
      click_button 'delete'
      expect(Group.find_by(name: 'admin')).to eql(nil)
    end

    it 'stops people who are not logged in' do
      click_link 'Sign Out'
      visit "/groups/#{@admin.id}"
      expect(page.body).to include('HTTP 401')
    end

    it 'stops non admins' do
      click_link 'Sign Out'
      fill_in :username, with: 'groot'
      fill_in :password, with: 'IAmGr00t'
      visit "/groups/#{@admin.id}"
      expect(page.body).to include('HTTP 401')
    end
  end

  describe '/groups/:id/edit' do
    before do
      @admin = Group.create(name: 'admin', privilege: 'admin')
      @read = Group.create(name: 'read', privilege: 'read')
      @hub = Device.create(serial_number: '123',
                           model: 'HH6A',
                           groups: [@admin])
      @stb = Device.create(serial_number: '321',
                           model: 'TLA',
                           groups: [@admin])
      @andy = User.create(name: 'Andy',
                          username: 'andy',
                          email: 'andy@admin.com',
                          password: 'i@f0ub#zFJbb*XFV0ANn',
                          group_id: @admin.id)
      @richy = User.create(name: 'Richy',
                           username: 'rich',
                           email: 'rich@write.com',
                           password: 'Fug7tuff!e',
                           group_id: @admin.id)
      @notadmin = User.create(name: 'Groot',
                              username: 'groot',
                              email: 'groot@gotg.org',
                              password: 'IAmGr00t',
                              group_id: @read.id)
    end

    it 'blocks people who are not logged in' do
      visit "/groups/#{@admin.id}/edit"
      expect(page.body).to include('HTTP 401')
    end

    it 'lets you edit a group' do
      visit '/'
      fill_in :username, with: 'andy'
      fill_in :password, with: 'i@f0ub#zFJbb*XFV0ANn'
      click_button 'Sign In'
      visit "/groups/#{@admin.id}/edit"
      fill_in :name, with: 'administrator'
      fill_in :privilege, with: 'admin'
      uncheck "user_#{@richy.id}"
      uncheck "device_#{@stb.id}"
      click_button 'Update'
      @admin.reload
      expect(@admin.name).to eql('administrator')
      expect(@admin.devices.size).to eql(1)
      expect(@admin.users.size).to eql(1)
    end
  end

  describe '/groups/new' do
    before do
      @read = Group.create(name: 'read', privilege: 'read')
      @hub = Device.create(serial_number: '123',
                           model: 'HH6A')
      @stb = Device.create(serial_number: '321',
                           model: 'TLA')
      @andy = User.create(name: 'Andy',
                          username: 'andy',
                          email: 'andy@admin.com',
                          password: 'i@f0ub#zFJbb*XFV0ANn')
      @fudgemin = Group.create(name: 'fudgemin', privilege: 'admin')
      @richy = User.create(name: 'Richy',
                           username: 'rich',
                           email: 'rich@write.com',
                           password: 'Fug7tuff!e',
                           group: @fudgemin)
      @notadmin = User.create(name: 'Groot',
                              username: 'groot',
                              email: 'groot@gotg.org',
                              password: 'IAmGr00t',
                              group_id: @read.id)
      visit '/'
      fill_in :username, with: 'rich'
      fill_in :password, with: 'Fug7tuff!e'
      click_button 'Sign In'
    end

    it 'creates a new device' do
      visit '/groups/new'
      fill_in :name, with: 'administrator'
      fill_in :privilege, with: 'admin'
      check "device_#{@hub.id}"
      check "user_#{@andy.id}"
      click_button 'create'
      admin = Group.find_by(name: 'administrator', privilege: 'admin')
      expect(admin.name).to eql('administrator')
      expect(admin.users).to include(@andy)
      expect(admin.devices).to include(@hub)
    end

    it 'blocks non admins' do
      click_link 'Sign Out'
      fill_in :username, with: 'groot'
      fill_in :password, with: 'IAmGr00t'
      visit '/groups/new'
      expect(page.body).to include('HTTP 401')
    end

    it 'blocks users not logged in' do
      click_link 'Sign Out'
      visit '/groups/new'
      expect(page.body).to include('HTTP 401')
    end
  end
end
