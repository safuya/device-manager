class CreateDevices < ActiveRecord::Migration[5.1]
  def change
    create_table :devices do |t|
      t.string :serial_number
      t.string :model
      t.datetime :last_contact
      t.datetime :last_activation
    end
  end
end
