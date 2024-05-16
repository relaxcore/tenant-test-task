# frozen_string_literal: true

class Tenant < ApplicationRecord
  has_many :tenant_data, dependent: :destroy
end
