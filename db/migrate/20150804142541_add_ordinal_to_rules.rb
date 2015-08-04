class AddOrdinalToRules < ActiveRecord::Migration
  def change
    add_column :rules, :ordinal, :integer
  end
end
