class AddThemeToLeague < ActiveRecord::Migration
  def change
    add_column :leagues, :theme, :integer
  end
end
