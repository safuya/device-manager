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
  end
end
