# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::TenantServices::ValidateData do
  describe 'call' do
    context 'tenant validations' do
      it 'returns error message when tenant_id is blank' do
        result = described_class.call(tenant_id: nil)

        expect(result).to eq(['Tenant ID can\'t be blank'])
      end

      it 'returns error message when tenant is not found' do
        result = described_class.call(tenant_id: 'invalid_id')

        expect(result).to eq(['Tenant ID is invalid'])
      end
    end

    context 'data validations' do
      it 'returns error message when data is blank' do
        tenant = create(:tenant)
        result = described_class.call(tenant_id: tenant.id, data: {})

        expect(result).to eq(['Data can\'t be blank'])
      end

      it 'returns error message when data has invalid keys' do
        tenant = create(:tenant)
        result = described_class.call(tenant_id: tenant.id, data: { invalid_key: 'value' })

        expect(result).to eq(["Data contains invalid fields: 'invalid_key'"])
      end

      it 'returns error message when data is missing required fields' do
        tenant = create(
          :tenant,
          data_structure: { 'required_field' => 'string_required', 'optional_field' => 'string' }
        )
        result = described_class.call(tenant_id: tenant.id, data: { 'optional_field' => 'John' })

        expect(result).to eq(["Data must contain field 'required_field' with type 'string'"])
      end

      context 'data types validations' do
        it 'returns error message when data has string field with invalid value' do
          tenant = create(:tenant, data_structure: { 'name' => 'string' })
          result = described_class.call(tenant_id: tenant.id, data: { 'name' => '1' })

          expect(result).to eq(["Data field 'name' must be a string"])
        end

        it 'returns error message when data has number field with invalid value' do
          tenant = create(:tenant, data_structure: { 'age' => 'number' })
          result = described_class.call(tenant_id: tenant.id, data: { 'age' => 'John' })

          expect(result).to eq(["Data field 'age' must be a number"])
        end

        it 'returns error message when data has single_select field with invalid value' do
          tenant = create(
            :tenant,
            data_structure: { 'hobbies' => 'single_select' },
            select_options: { 'hobbies' => %w[reading writing] }
          )
          result = described_class.call(tenant_id: tenant.id, data: { 'hobbies' => 'value' })

          expect(result).to eq(["Invalid selection in field 'hobbies': must be one of 'reading, writing'"])
        end

        it 'returns error message when data has multi_select field with invalid value' do
          tenant = create(
            :tenant,
            data_structure: { 'hobbies' => 'multi_select' },
            select_options: { 'hobbies' => %w[reading writing] }
          )
          result = described_class.call(tenant_id: tenant.id, data: { 'hobbies' => ['value'] })

          expect(result).to eq(["Invalid selection in field 'hobbies': must be one or more of 'reading, writing'"])
        end
      end
    end
  end
end
