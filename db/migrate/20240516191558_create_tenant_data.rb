# frozen_string_literal: true

class CreateTenantData < ActiveRecord::Migration[7.1]
  def change
    create_table :tenant_data, id: :uuid do |t|
      t.jsonb :data, default: {}, null: false
      t.uuid :entity_id
      t.string :entity_type

      t.timestamps
    end

    add_index :tenant_data, %i[entity_id entity_type]
  end
end
