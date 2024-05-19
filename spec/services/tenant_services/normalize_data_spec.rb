# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::TenantServices::NormalizeData do
  describe 'call' do
    it 'returns nil when tenant is blank' do
      result = described_class.call(data: { name: 'John' }, tenant: nil)

      expect(result).to be_nil
    end

    it 'returns normalized array data' do
      tenant = create(:tenant, data_structure: { 'name' => 'multi_select' })
      data = { 'name' => '["John", "Doe"]' }

      result = described_class.call(data: data, tenant: tenant)

      expect(result).to eq({ 'name' => ['John', 'Doe'] })
    end

    it 'returns normalized number data' do
      tenant = create(:tenant, data_structure: { 'age' => 'number' })
      data = { 'age' => '25' }

      result = described_class.call(data: data, tenant: tenant)

      expect(result).to eq({ 'age' => 25 })
    end
  end
end
