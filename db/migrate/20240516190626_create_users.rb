# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users, id: :uuid do |t|
      t.string :auth_token
      t.string :username

      t.timestamps
    end

    add_index :users, :auth_token
  end
end
