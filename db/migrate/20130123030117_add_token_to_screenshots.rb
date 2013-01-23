class AddTokenToScreenshots < ActiveRecord::Migration
  def change
    add_column :screenshots, :token, :string
  end
end
