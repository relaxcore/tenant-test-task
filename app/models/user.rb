# frozen_string_literal: true

class User < ApplicationRecord
  has_many :tenant_data, as: :entity, dependent: :destroy
end
