class AddHomeContentToLeague < ActiveRecord::Migration
  def change
    add_column :leagues, :home_content, :text
  end
end
