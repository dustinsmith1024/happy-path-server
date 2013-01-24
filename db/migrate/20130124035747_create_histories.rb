class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.string :email
      t.references :screenshot

      t.timestamps
    end
    add_index :histories, :screenshot_id
  end
end
