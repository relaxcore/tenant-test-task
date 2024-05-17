# frozen_string_literal: true

module UserServices
  class UpdateUserTenantData
    def self.call(...)
      new(...).call
    end

    def initialize(tenant_id:, data: {})
      @data = data || {}
      @tenant_id = tenant_id
    end

    def call
      Result.new(errors: errors, tenant_data: tenant_data)
    end

    private

    attr_reader :data, :tenant_id

    Result = Data.define(:errors, :tenant_data)
    private_constant :Result

    def errors
      @errors ||= ::TenantServices::ValidateData.call(tenant_id: tenant_id, data: normalized_data)
    end

    def tenant_data
      return if errors.any?

      object = TenantDatum.find_or_initialize_by(tenant: tenant, entity: Current.user)
      object.data = normalized_data
      object.save

      object
    end

    def normalized_data
      @normalized_data ||= ::TenantServices::NormalizeData.call(data: data, tenant: tenant)
    end

    def tenant
      @tenant ||= Tenant.find_by(id: tenant_id)
    end
  end
end
