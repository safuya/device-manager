require 'spec_helper'

describe 'User' do
  let(:username) { 'hughesr0' }
  let(:name) { 'Robert Hughes' }
  let(:email) { 'robert.hughes@hughes.net' }
  let(:password) { 'i@f0ub#zFJbb*XFV0ANn' }
  it 'has all its attributes' do
    user = User.new(username: username,
                    name: name,
                    email: email,
                    password: password)
    user.save
    expect(user.username).to eql(username)
    expect(user.name).to eql(name)
    expect(user.email).to eql(email)
    expect(!!user.authenticate(password)).to eql(true)
  end

  it 'must have a username and it must not be blank' do
    user = User.new(name: name, email: email, password: password)
    expect(user.save).to eql(false)
    user.username = ''
    expect(user.save).to eql(false)
    user.username = username
    expect(user.save).to eql(true)
  end

  it 'must have a name and it must not be blank' do
    user = User.new(username: username, email: email, password: password)
    expect(user.save).to eql(false)
    user.name = ''
    expect(user.save).to eql(false)
    user.name = name
    expect(user.save).to eql(true)
  end

  it 'must have an email and it must not be blank' do
    user = User.new(username: username, name: name, password: password)
    expect(user.save).to eql(false)
    user.email = ''
    expect(user.save).to eql(false)
    user.email = email
    expect(user.save).to eql(true)
  end

  it 'must have a password and it must be longer than 7 characters' do
    user = User.new(username: username, name: name, email: email)
    expect(user.save).to eql(false)
    user.password = 'i@f0ub#'
    expect(user.save).to eql(false)
    user.password = password
    expect(user.save).to eql(true)
  end

  it 'password must have three of lowercase, uppercase, email and symbol' do
    user = User.new(username: username, name: name, email: email)
    not_ok = { lower: 'iamnotok', upper: 'IAMNOTOK', digit: '12345678',
               symbol: '$@&!%*^#', upper_lower: 'IAmNotOk',
               digit_lower: '1amn0t0k', symbol_lower: '!amnot@k',
               upper_digit: '1AMN0T0K', upper_symbol: '!AMN@T@K',
               digit_symbol: '!2345678' }

    not_ok.each do |_, value|
      user.password = value
      expect(user.save).to eql(false), "#{value} shouldn't save but does."
    end

    ok = { lower_upper_digit: 'Passw0rd', lower_upper_symbol: 'Passw@rd',
           lower_digit_symbol: 'p@ssw0rd', upper_digit_symbol: 'P@SSW0RD' }
    ok.each do |_, value|
      user.password = value
      expect(user.save).to eql(true), "#{value} should save but doesn't."
    end
  end
end
