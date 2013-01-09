class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.boolean :status
      t.text :message
      t.references :scenario

      t.timestamps
    end
    add_index :results, :scenario_id
  end
end
