# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id, :username

  has_many :tenant_data
end
