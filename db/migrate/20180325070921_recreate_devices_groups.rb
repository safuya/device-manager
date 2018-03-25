class RecreateDevicesGroups < ActiveRecord::Migration[5.1]
  def change
    drop_table :devices_groups

    create_table :devices_groups, id: false do |t|
      t.belongs_to :device, index: true
      t.belongs_to :group, index: true
    end
  end
end
