class CreateTiebreakers < ActiveRecord::Migration
  def change
    create_table :tiebreakers do |t|
      t.integer :tiebreaker
      t.integer :ordinal
    end
  end
end
