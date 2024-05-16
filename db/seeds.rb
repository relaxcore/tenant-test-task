# frozen_string_literal: true

user = User.create(username: 'User', auth_token: 'token')

tenant = Tenant.create(
  data_structure: {
    'First name' => Tenant::STRING_REQUIRED,
    'Last name' => Tenant::STRING,
    'Phone number' => Tenant::NUMBER_REQUIRED,
    'Year of birth' => Tenant::NUMBER,
    'Gender' => Tenant::SINGLE_SELECT_REQUIRED,
    'Preferable type of work' => Tenant::SINGLE_SELECT,
    'Skills' => Tenant::MULTI_SELECT_REQUIRED,
    'Hobbies' => Tenant::MULTI_SELECT
  },
  select_options: {
    'Gender' => %w[Male Female],
    'Preferable type of work' => %w[Office Hybrid Home],
    'Skills' => %w[Ruby Python JavaScript Java Elixir SQL Go Rust],
    'Hobbies' => %w[Reading Drawing Dancing Videogames Photography Chess]
  }
)

TenantDatum.create(
  entity: user,
  data: {
    'First name' => 'John',
    'Last name' => 'Doe',
    'Phone number' => 123456789,
    'Year of birth' => 1996,
    'Gender' => 'Male',
    'Preferable type of work' => 'Remote',
    'Skills' => %w[Ruby Elixir SQL],
    'Hobbies' => %w[Reading Videogames]
  },
  tenant: tenant
)
