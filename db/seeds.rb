# frozen_string_literal: true

require 'factory_bot_rails'

user = FactoryBot.create(:user, auth_token: 'token')
tenant = FactoryBot.create(:tenant)
FactoryBot.create(:tenant_datum, entity: user, tenant: tenant)
