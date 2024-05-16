# frozen_string_literal: true

class AddTenantToTenantData < ActiveRecord::Migration[7.1]
  def change
    add_reference :tenant_data, :tenant, type: :uuid, foreign_key: true
  end
end
