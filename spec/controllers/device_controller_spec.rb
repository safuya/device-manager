require 'spec_helper'

describe 'DeviceController' do
  describe '/devices' do
    before do
      @hub = Device.create(serial_number: '+012345+0123456789',
                           model: 'HH6A',
                           firmware_version: 'ABC123',
                           last_contact: Time.now,
                           last_activation: Time.now - 54_432_000)
      @stb = Device.create(serial_number: '+123456+1234567890', model: 'TLA')
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

    it 'links to the groups' do
      visit "/devices/#{@hub.id}"
      expect(page.body).to include("href=\"/groups/#{@admin.id}\"")
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
  end

  describe '/devices/new' do
    before do
      @admin = Group.create(name: 'admin', privilege: 'admin')
      @write = Group.create(name: 'room 210 lead', privilege: 'write')
    end

    it 'allows you to add a new device' do
      visit '/devices/new'
      expect(page.body).to include('<form')
      expect(page.body).to include('device[serial_number]')
      expect(page.body).to include('device[model]')
      expect(page.body).to include('device[last_contact]')
      expect(page.body).to include('device[last_activation]')
      expect(page.body).to include('device[groups][]')
      expect(page.body).to include('submit')
    end

    it 'creates a new device' do
      serial_number = '+065432+0123456789'
      visit '/devices/new'
      fill_in :serial_number, with: serial_number
      fill_in :model, with: 'HH6A'
      fill_in :last_contact, with: '180203T11:24'
      fill_in :last_activation, with: '160203T10:09'
      click_button 'Add Device'
      expect(Device.find_by(serial_number: '+065432+0123456789').model)
        .to eql('HH6A')
    end
  end

  describe '/devices/:id/edit' do
    before do
      @hub = Device.create(serial_number: 'old serial number',
                           model: 'HH6A',
                           firmware_version: 'ABC123',
                           last_contact: Time.now,
                           last_activation: Time.now - 54_432_000)
    end

    it 'allows you to edit a device' do
      visit "/devices/#{@hub.id}/edit"
      expect(page.body).to include('hidden')
      fill_in :serial_number, with: 'new serial number'
      fill_in :model, with: 'HH6A'
      fill_in :last_contact, with: '180203T11:24'
      fill_in :last_activation, with: '160203T10:09'
      click_button 'Update Device'
      @hub.reload
      expect(@hub.serial_number).to eql('new serial number')
    end

    it 'allows you to delete a device' do
      visit "/devices/#{@hub.id}/edit"
      click_button 'Delete Device'
      expect(Device.find_by(serial_number: 'old serial number')).to eql(nil)
    end
  end
end
