class ChangeIdToStringScreenshots < ActiveRecord::Migration
  def up
  	change_column :screenshots, :id, :string
  end

  def down
  	change_column :screenshots, :id, :integer
  end
end
