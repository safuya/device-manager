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
end
