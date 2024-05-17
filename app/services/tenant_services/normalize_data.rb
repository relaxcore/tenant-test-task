# frozen_string_literal: true

module TenantServices
  class NormalizeData
    def self.call(...)
      new(...).call
    end

    def initialize(data:, tenant:)
      @data = data
      @tenant = tenant
    end

    def call
      return if tenant.blank?

      data.to_unsafe_h.each_with_object({}) do |(field_name, value), normalized_data|
        normalized_data[field_name] = case tenant.data_structure[field_name]
                                      when /multi_select/ then parse_array(value)
                                      when /number/ then parse_number(value)
                                      else value
                                      end
      end
    end

    private

    attr_reader :data, :tenant

    def parse_array(value)
      return value if value.is_a?(Array)

      YAML.safe_load(value)
    end

    def parse_number(value)
      Integer(value, exception: false) || Float(value, exception: false)
    end
  end
end
