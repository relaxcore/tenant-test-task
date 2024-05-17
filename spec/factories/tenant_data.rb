# frozen_string_literal: true

FactoryBot.define do
  factory :tenant_datum do
    entity factory: :user
    tenant
    data {
      {
        'First name' => 'John',
        'Last name' => 'Doe',
        'Phone number' => 123456789,
        'Year of birth' => 1996,
        'Gender' => 'Male',
        'Preferable type of work' => 'Remote',
        'Skills' => %w[Ruby Elixir SQL],
        'Hobbies' => %w[Reading Videogames]
      }
    }
  end
end
