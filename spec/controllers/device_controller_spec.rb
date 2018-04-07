require 'spec_helper'

describe 'DeviceController' do
  describe '/devices' do
    before do
      @read = Group.create(name: 'read', privilege: 'read')
      @rob = User.create(name: 'rob',
                         username: 'rob',
                         password: 'P@ssword',
                         email: 'rob@rob.com',
                         group: @read)
      @nogroup = User.create(name: 'jim',
                             username: 'jim',
                             password: 'Pa$$word',
                             email: 'jim@jim.com')
      @hub = Device.create(serial_number: '+012345+0123456789',
                           model: 'HH6A',
                           firmware_version: 'ABC123',
                           last_contact: Time.now,
                           last_activation: Time.now - 54_432_000)
      @stb = Device.create(serial_number: '+123456+1234567890', model: 'TLA')
      visit '/'
      fill_in :username, with: 'rob'
      fill_in :password, with: 'P@ssword'
      click_button 'Sign In'
    end

    it 'allows you to view all devices' do
      visit '/devices'
      expect(page.body).to include(@hub.serial_number)
      expect(page.body).to include(@hub.model)
      expect(page.body).to include(@hub.firmware_version)
      expect(page.body).to include(@hub.last_contact.to_s)
      expect(page.body).to include(@hub.last_activation.to_s)
      expect(page.body).to include(@stb.serial_number)
      expect(page.body).to include(@stb.model)
    end

    it 'has links to view individual devices' do
      visit '/devices'
      expect(page.body).to include("href=\"/devices/#{@hub.id}\"")
    end

    it 'does not let unauthenticated users to view devices' do
      click_link 'Sign Out'
      visit '/'
      fill_in :username, with: 'jim'
      fill_in :password, with: 'Pa$$word'
      click_button 'Sign In'
      visit '/devices'
      expect(page.body).to include('HTTP 401')
    end

    it 'does not let anonymous users view devices' do
      click_link 'Sign Out'
      visit '/devices'
      expect(page.body).to include('HTTP 401')
    end
  end

  describe '/devices/:id' do
    before do
      @hub = Device.create(serial_number: '+012345+0123456789',
                           model: 'HH6A',
                           firmware_version: 'ABC123',
                           last_contact: Time.now,
                           last_activation: Time.now - 54_432_000)
      @admin = Group.create(name: 'admin', privilege: 'admin')
      @write = Group.create(name: 'room 210 lead', privilege: 'write')
      @hub.groups = [@admin, @write]
      @hub.save
      @jim = User.create(name: 'jim',
                         username: 'jim',
                         password: 'Pa$$word',
                         email: 'jim@jim.com',
                         group: @admin)
      visit '/'
      fill_in :username, with: 'jim'
      fill_in :password, with: 'Pa$$word'
      click_button 'Sign In'
    end

    it 'allows you to view an individual device' do
      visit "/devices/#{@hub.id}"
      expect(page.body).to include(@hub.serial_number)
      expect(page.body).to include(@hub.model)
      expect(page.body).to include(@hub.firmware_version)
      expect(page.body).to include(@hub.last_contact.to_s)
      expect(page.body).to include(@hub.last_activation.to_s)

      expect(page.body).to include(@admin.name)
      expect(page.body).to include(@write.name)
    end

    it 'links to the groups if you are an admin' do
      visit "/devices/#{@hub.id}"
      expect(page.body).to include("href=\"/groups/#{@admin.id}\"")
    end

    it 'does not link to the groups if you are not an admin' do
      click_link 'Sign Out'
      fill_in :username, with: 'rob'
      fill_in :password, with: 'P@ssword'
      click_button 'Sign In'
      visit "/devices/#{@hub.id}"
      expect(page.body).not_to include("href=\"/groups/#{@admin.id}\"")
    end

    it 'allows you to edit the device' do
      visit "/devices/#{@hub.id}"
      click_link 'edit'
      expect(page.status_code).to eql(200)
    end

    it 'allows you to delete the device' do
      visit "/devices/#{@hub.id}"
      click_button 'Delete'
      expect(Device.find_by(id: @hub.id)).to eql(nil)
    end

    it 'does not allow viewing devices if not signed in' do
      click_link 'Sign Out'
      visit "/devices/#{@hub.id}"
      expect(page.body).to include('HTTP 401')
    end

    it 'does not allow unassigned groups to view the device' do
      click_link 'Sign Out'
      read = Group.create(name: 'read', privilege: 'read')
      rob = User.create(name: 'rob',
                        username: 'rob',
                        password: 'P@ssword',
                        email: 'rob@rob.com',
                        group: read)
      fill_in :username, with: 'rob'
      fill_in :password, with: 'P@ssword'
      click_button 'Sign In'
      visit "/devices/#{@hub.id}"
      expect(page.body).to include('HTTP 401')
    end

    it 'does not allow non admins to edit, delete or view groups' do
      rob = User.create(name: 'rob',
                        username: 'rob',
                        password: 'P@ssword',
                        email: 'rob@rob.com',
                        group: @write)
      click_link 'Sign Out'
      fill_in :username, with: 'rob'
      fill_in :password, with: 'P@ssword'
      click_button 'Sign In'
      visit "/devices/#{@hub.id}"
      expect(page.body).to include(@hub.serial_number)
      expect(page.body).to include(@hub.model)
      expect(page.body).to include(@hub.firmware_version)
      expect(page.body).to include(@hub.last_contact.to_s)
      expect(page.body).to include(@hub.last_activation.to_s)

      expect(page.body).not_to include(@admin.name)
      expect(page.body).not_to include(@write.name)
      expect(page.body).not_to include('Edit')
      expect(page.body).not_to include('Delete')
    end
  end

  describe '/devices/new' do
    before do
      @admin = Group.create(name: 'admin', privilege: 'admin')
      @write = Group.create(name: 'room 210 lead', privilege: 'write')
    end

    it 'creates a new device' do
      User.create(username: 'rob',
                  name: 'Rob',
                  email: 'rob@rob.com',
                  password: 'P@ssword',
                  group: @admin)
      visit '/'
      fill_in :username, with: 'rob'
      fill_in :password, with: 'P@ssword'
      click_button 'Sign In'
      serial_number = '+065432+0123456789'
      visit '/devices/new'
      fill_in :serial_number, with: serial_number
      fill_in :model, with: 'HH6A'
      fill_in :last_contact, with: '180203T11:24'
      fill_in :last_activation, with: '160203T10:09'
      check "group_#{@write.id}"
      click_button 'Add Device'
      hub = Device.find_by(serial_number: '+065432+0123456789')
      expect(hub.model).to eql('HH6A')
      expect(hub.groups).to include(@write)
    end

    it 'blocks anonymous users' do
      visit '/devices/new'
      expect(page.body).to include('HTTP 401')
    end

    it 'blocks non administrators' do
      User.create(username: 'rob',
                  name: 'Rob',
                  email: 'rob@rob.com',
                  password: 'P@ssword',
                  group: @write)
      visit '/'
      fill_in :username, with: 'rob'
      fill_in :password, with: 'P@ssword'
      click_button 'Sign In'
      visit '/devices/new'
      expect(page.body).to include('HTTP 401')
    end

    it 'displays errors with invalid parameters' do
      User.create(username: 'rob',
                  name: 'Rob',
                  email: 'rob@rob.com',
                  password: 'P@ssword',
                  group: @admin)
      visit '/'
      fill_in :username, with: 'rob'
      fill_in :password, with: 'P@ssword'
      click_button 'Sign In'
      visit '/devices/new'
      click_button 'Add Device'
      expect(page.body).to include('serial_number: ["can\'t be blank"]')
      expect(page.body).to include('model: ["can\'t be blank"]')
    end
  end

  describe '/devices/:id/edit' do
    before do
      @hub = Device.create(serial_number: 'old serial number',
                           model: 'HH6A',
                           firmware_version: 'ABC123',
                           last_contact: Time.now,
                           last_activation: Time.now - 54_432_000)
      @admin = Group.create(name: 'admin', privilege: 'admin')
      User.create(name: 'Andy',
                  username: 'andy',
                  email: 'andy@admin.com',
                  password: 'P@ssword',
                  group: @admin)
      visit '/'
      fill_in :username, with: 'andy'
      fill_in :password, with: 'P@ssword'
      click_button 'Sign In'
    end

    it 'allows you to edit a device' do
      visit "/devices/#{@hub.id}/edit"
      expect(page.body).to include('hidden')
      fill_in :serial_number, with: 'new serial number'
      fill_in :model, with: 'HH6A'
      fill_in :last_contact, with: '180203T11:24'
      fill_in :last_activation, with: '160203T10:09'
      click_button 'Update'
      @hub.reload
      expect(@hub.serial_number).to eql('new serial number')
    end

    it 'allows you to delete a device' do
      visit "/devices/#{@hub.id}/edit"
      expect(page.body).to include('onClick="delete_device()"')
    end

    it 'allows you to add a group' do
      group = Group.create(name: 'a', privilege: 'b')
      visit "/devices/#{@hub.id}/edit"
      check "group_#{group.id}"
      click_button 'Update'
      @hub.reload
      expect(@hub.groups).to include(group)
    end

    it 'allows you to remove a group' do
      group = Group.create(name: 'a', privilege: 'b')
      @hub.groups = [group]
      visit "/devices/#{@hub.id}/edit"
      uncheck "group_#{group.id}"
      click_button 'Update'
      @hub.reload
      expect(@hub.groups).to include(group)
    end

    it 'blocks anonymous users' do
      click_link 'Sign Out'
      visit "/devices/#{@hub.id}/edit"
      expect(page.body).to include('HTTP 401')
    end

    it 'blocks non admins' do
      click_link 'Sign Out'
      write = Group.create(name: 'write', privilege: 'write')
      User.create(name: 'Rob',
                  username: 'rob',
                  email: 'rob@rob.com',
                  password: 'P@ssword',
                  group: write)
      visit '/'
      fill_in :username, with: 'rob'
      fill_in :password, with: 'P@ssword'
      click_button 'Sign In'
      visit "/devices/#{@hub.id}/edit"
      expect(page.body).to include('HTTP 401')
    end

    it 'displays errors with invalid parameters' do
      visit "/devices/#{@hub.id}/edit"
      fill_in :serial_number, with: ''
      fill_in :model, with: ''
      click_button 'Update'
      expect(page.body).to include('serial_number: ["can\'t be blank"]')
      expect(page.body).to include('model: ["can\'t be blank"]')
    end
  end
end
