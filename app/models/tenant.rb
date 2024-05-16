# frozen_string_literal: true

class Tenant < ApplicationRecord
  STRING = 'string'
  STRING_REQUIRED = 'string_required'

  NUMBER = 'number'
  NUMBER_REQUIRED = 'number_required'

  SINGLE_SELECT = 'single_select'
  SINGLE_SELECT_REQUIRED = 'single_select_required'

  MULTI_SELECT = 'multi_select'
  MULTI_SELECT_REQUIRED = 'multi_select_required'

  VALID_DATA_TYPES = [
    STRING, STRING_REQUIRED,
    NUMBER, NUMBER_REQUIRED,
    SINGLE_SELECT, SINGLE_SELECT_REQUIRED,
    MULTI_SELECT, MULTI_SELECT_REQUIRED
  ].freeze

  has_many :tenant_data, dependent: :destroy
end
