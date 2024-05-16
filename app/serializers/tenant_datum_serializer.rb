# frozen_string_literal: true

class TenantDatumSerializer < ActiveModel::Serializer
  attributes :id, :data, :data_structure, :select_options

  def data_structure
    object.tenant.data_structure
  end

  def select_options
    object.tenant.select_options
  end
end
