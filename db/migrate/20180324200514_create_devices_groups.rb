class CreateDevicesGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :devices_groups, id: false do |t|
      t.belongs_to :devices, index: true
      t.belongs_to :groups, index: true
    end
  end
end
