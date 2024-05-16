# frozen_string_literal: true

class TenantDatum < ApplicationRecord
  belongs_to :entity, polymorphic: true
  belongs_to :tenant
end
