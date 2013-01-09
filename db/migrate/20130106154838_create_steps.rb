class CreateSteps < ActiveRecord::Migration
  def change
    create_table :steps do |t|
      t.string :action
      t.string :what
      t.string :with
      t.integer :x
      t.integer :y
      t.references :scenario

      t.timestamps
    end
    add_index :steps, :scenario_id
  end
end
