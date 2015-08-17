class AddRulesContentToLeague < ActiveRecord::Migration
  def change
    add_column :leagues, :rules_content, :text
  end
end
