class AddLeagueToRules < ActiveRecord::Migration
  def change
    add_reference :rules, :league, index: true
  end
end
