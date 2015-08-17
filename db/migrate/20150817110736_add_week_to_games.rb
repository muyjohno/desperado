class AddWeekToGames < ActiveRecord::Migration
  def change
    add_column :games, :week, :integer
  end
end
