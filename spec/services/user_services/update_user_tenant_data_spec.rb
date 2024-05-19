# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::UserServices::UpdateUserTenantData do
  describe 'call' do
    it 'calls the ValidateData service' do
      tenant = create(:tenant)
      data = { 'name' => 'John' }
      allow(::TenantServices::ValidateData).to receive(:call).and_return([])
      allow(::TenantServices::NormalizeData).to receive(:call).and_return(data)

      described_class.call(tenant_id: tenant.id, data: data)

      expect(::TenantServices::ValidateData).to have_received(:call).with(tenant_id: tenant.id, data: data)
    end

    it 'calls the NormalizeData service' do
      tenant = create(:tenant)
      data = { 'name' => 'John' }
      allow(::TenantServices::ValidateData).to receive(:call).and_return([])
      allow(::TenantServices::NormalizeData).to receive(:call).and_return(data)

      described_class.call(tenant_id: tenant.id, data: data)

      expect(::TenantServices::NormalizeData).to have_received(:call).with(tenant: tenant, data: data)
    end

    it 'updates the existing tenant data when there are no errors' do
      user = create(:user)
      tenant = create(:tenant)
      tenant_datum = create(:tenant_datum, tenant: tenant, entity: user)
      data = { 'name' => 'John' }
      allow(::TenantServices::ValidateData).to receive(:call).and_return([])
      Current.user = user

      result = described_class.call(tenant_id: tenant.id, data: data)

      expect(tenant_datum.reload.data).to eq(data)

      Current.user = nil
    end

    it 'creates a new tenant data when it is not exist' do
      user = create(:user)
      tenant = create(:tenant)
      data = { 'name' => 'John' }
      allow(::TenantServices::ValidateData).to receive(:call).and_return([])
      Current.user = user

      result = described_class.call(tenant_id: tenant.id, data: data)

      expect(tenant.tenant_data.count).to eq(1)
      expect(tenant.tenant_data.take.data).to eq(data)
      expect(user.tenant_data.count).to eq(1)
      expect(user.tenant_data.take.data).to eq(data)

      Current.user = nil
    end
  end
end