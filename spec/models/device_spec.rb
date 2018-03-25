require 'spec_helper'
require 'date'

describe 'Device' do
  let (:serial_number) { '+012345+0123456789'}
  let (:model) { 'Home Hub 60 Type A' }

  it 'has all its attributes' do
    hub = Device.new(serial_number: serial_number,
                     model: model,
                     last_contact: Time.new(2017, 6, 5, 4, 5, 6),
                     last_activation: Time.new(2016, 2, 3, 4, 5, 6))
    hub.save
    expect(hub.serial_number).to eql(serial_number)
    expect(hub.model).to eql(model)
    expect(hub.last_contact).to eql(Time.new(2017, 6, 5, 4, 5, 6))
    expect(hub.last_activation).to eql(Time.new(2016, 2, 3, 4, 5, 6))
  end

  it 'must have a serial number and it must not be blank' do
    hub = Device.new(model: model)
    expect(hub.save).to eql(false)
    hub.serial_number = ''
    expect(hub.save).to eql(false)
    hub.serial_number = serial_number
    expect(hub.save).to eql(true)
  end

  it 'must have a model' do
    hub = Device.new(serial_number: serial_number)
    expect(hub.save).to eql(false)
    hub.model = model
    expect(hub.save).to eql(true)
  end

  it 'must have a unique serial number' do
    hub = Device.new(serial_number: serial_number, model: model)
    hub.save
    hub2 = Device.new(serial_number: serial_number, model: model)
    expect(hub2.save).to eql(false)
  end
end
