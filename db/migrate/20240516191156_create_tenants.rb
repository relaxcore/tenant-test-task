# frozen_string_literal: true

class CreateTenants < ActiveRecord::Migration[7.1]
  def change
    create_table :tenants, id: :uuid do |t|
      t.jsonb :data_structure, default: {}, null: false
      t.jsonb :select_options, default: {}, null: false

      t.timestamps
    end
  end
end
