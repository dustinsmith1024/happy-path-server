class CreateScreenshots < ActiveRecord::Migration
  def change
    create_table :screenshots do |t|
      t.string :name
      t.string :description
      t.string :url
      t.string :email

      t.timestamps
    end
  end
end
