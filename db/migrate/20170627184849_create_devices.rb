class CreateDevices < ActiveRecord::Migration[5.1]
  def change
    create_table :devices do |t|
      t.string :device_name
      t.string :password_digest
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
