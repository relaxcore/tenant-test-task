# frozen_string_literal: true

FactoryBot.define do
  factory :tenant do
    data_structure {
      {
        'First name' => Tenant::STRING_REQUIRED,
        'Last name' => Tenant::STRING,
        'Phone number' => Tenant::NUMBER_REQUIRED,
        'Year of birth' => Tenant::NUMBER,
        'Gender' => Tenant::SINGLE_SELECT_REQUIRED,
        'Preferable type of work' => Tenant::SINGLE_SELECT,
        'Skills' => Tenant::MULTI_SELECT_REQUIRED,
        'Hobbies' => Tenant::MULTI_SELECT
      }
    }
    select_options {
      {
        'Gender' => %w[Male Female],
        'Preferable type of work' => %w[Office Hybrid Home],
        'Skills' => %w[Ruby Python JavaScript Java Elixir SQL Go Rust],
        'Hobbies' => %w[Reading Drawing Dancing Videogames Photography Chess]
      }
    }
  end
end
