class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|
      t.string :key
      t.integer :value

      t.timestamps null: false
    end
  end
end
