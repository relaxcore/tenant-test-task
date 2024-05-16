# frozen_string_literal: true

class Tenant < ApplicationRecord
  STRING = 'string'
  NUMBER = 'number'
  SINGLE_SELECT = 'single_select'
  MULTI_SELECT = 'multi_select'
  VALID_DATA_TYPES = [STRING, NUMBER, SINGLE_SELECT, MULTI_SELECT].freeze

  has_many :tenant_data, dependent: :destroy
end
