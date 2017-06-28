class CreatePositions < ActiveRecord::Migration[5.1]
  def change
    create_table :positions do |t|
      t.float :lat
      t.float :long
      t.integer :alt
      t.datetime :time
      t.integer :prev_pos
      t.integer :next_pos
      t.belongs_to :device, foreign_key: true

      t.timestamps
    end
  end
end
