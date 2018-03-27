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
end
