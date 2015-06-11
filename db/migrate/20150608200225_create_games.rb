class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :corp_id, references: :players
      t.integer :runner_id, references: :players
      t.integer :result

      t.timestamps null: false
    end
  end
end
