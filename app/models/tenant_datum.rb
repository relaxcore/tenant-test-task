# frozen_string_literal: true

class TenantDatum < ApplicationRecord
  belongs_to :entity, polymorphic: true
end
