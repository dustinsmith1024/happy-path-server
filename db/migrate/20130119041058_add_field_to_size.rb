class AddFieldToSize < ActiveRecord::Migration
  def change
    add_column :sizes, :file, :string
  end
end
