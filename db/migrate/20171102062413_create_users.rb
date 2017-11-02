# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.integer :internal_id
      t.string :screen_name
      t.integer :data_status
      t.integer :followers_count
      t.integer :friends_count

      t.timestamps

      t.index :internal_id, unique: true
    end
  end
end
