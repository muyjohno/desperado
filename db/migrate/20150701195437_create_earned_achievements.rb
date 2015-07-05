class CreateEarnedAchievements < ActiveRecord::Migration
  def change
    create_table :earned_achievements do |t|
      t.references :player
      t.references :game
      t.references :achievement

      t.timestamps null: false
    end
  end
end
