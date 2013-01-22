class AddFieldsToScreenshots < ActiveRecord::Migration
  def change
    add_column :screenshots, :delivered, :datetime
    add_column :screenshots, :file, :string
  end
end
