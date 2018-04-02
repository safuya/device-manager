require 'spec_helper'

describe 'GroupController' do
  describe '/groups' do
    before do
      @admin = Group.create(name: 'admin', privilege: 'admin')
      @write = Group.create(name: 'writer', privilege: 'write')
      @read = Group.create(name: 'reader', privilege: 'read')
      @content_admin = Group.create(name: 'content', privilege: 'admin')
    end

    it 'lists all the groups' do
      visit '/groups'
      expect(page.body).to include(@admin.name)
      expect(page.body).to include(@admin.privilege)
      expect(page.body).to include(@read.privilege)
      expect(page.body).to include(@content_admin.name)
    end

    it 'links to individual groups' do
      visit '/groups'
      click_link @admin.name
      expect(page.status_code).to eql(200)
    end
  end

  describe '/groups/:id' do
    before do
      @admin = Group.create(name: 'admin', privilege: 'admin')
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
  end

  describe '/groups/:id/edit' do
    before do
      @admin = Group.create(name: 'admin', privilege: 'admin')
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
    end

    it 'lets you edit a group' do
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
end
