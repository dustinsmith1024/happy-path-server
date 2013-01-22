class CreateSizes < ActiveRecord::Migration
  def change
    create_table :sizes do |t|
      t.integer :height
      t.integer :width
      t.references :screenshot

      t.timestamps
    end
    add_index :sizes, :screenshot_id
  end
end
