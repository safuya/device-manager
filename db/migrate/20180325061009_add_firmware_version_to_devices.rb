class AddFirmwareVersionToDevices < ActiveRecord::Migration[5.1]
  def change
    add_column :devices, :firmware_version, :string
  end
end
