class AddStatusToScreenshots < ActiveRecord::Migration
  def change
    add_column :screenshots, :error, :boolean
  end
end
