# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    username { 'johndoe' }
    auth_token { SecureRandom.hex }
  end
end
