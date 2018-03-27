require 'spec_helper'

describe 'Group' do
  it 'has all its attributes' do
    group = Group.new(name: 'admin', privilege: 'admin')
    group.save
    expect(group.name).to eql('admin')
    expect(group.privilege).to eql('admin')
  end

  it 'must have a name' do
    group = Group.new
    expect(group.save).to eql(false)
    group.name = 'admin'
    expect(group.save).to eql(true)
  end
end
