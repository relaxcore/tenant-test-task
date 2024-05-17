# frozen_string_literal: true

module TenantServices
  class ValidateData
    def self.call(...)
      new(...).call
    end

    def initialize(tenant_id:, data: {})
      @data = data
      @tenant_id = tenant_id
      @errors = []
    end

    def call
      validate_tenant || validate_data

      errors
    end

    private

    attr_reader :data, :tenant_id, :errors

    def validate_tenant
      errors << I18n.t('validations.tenant.cant_be_blank') if tenant_id.blank?
      errors << I18n.t('validations.tenant.invalid') if tenant_id.present? && tenant.blank?
    end

    def validate_data
      validate_data_presence ||
        validate_field_names ||
        validate_required_fields ||
        validate_data_types
    end

    def validate_data_presence
      errors << I18n.t('validations.data.cant_be_blank') if data.blank?
    end

    def validate_field_names
      invalid_fields = data.keys - tenant.data_structure.keys

      errors << I18n.t('validations.data.invalid_keys', fields: invalid_fields.join(', ')) if invalid_fields.any?
    end

    def validate_required_fields
      required_fields = tenant.data_structure.select { |_, v| v =~ /_required/ }

      required_fields.map do |field_name, type|
        type = type.gsub('_required', '')
        errors << I18n.t('validations.data.required_field', field: field_name, type: type) unless data.key?(field_name)
      end.compact.presence
    end

    def validate_data_types
      structure_fields = tenant.data_structure
      data.each do |field_name, value|
        type = structure_fields[field_name]

        case type
        when /string/        then validate_string(field_name, value)
        when /number/        then validate_number(field_name, value)
        when /single_select/ then validate_single_select(field_name, value)
        when /multi_select/  then validate_multi_select(field_name, value)
        end
      end
    end

    def validate_string(field_name, value)
      errors << I18n.t('validations.data.invalid_string', field: field_name) unless value.match?(/\D/)
    end

    def validate_number(field_name, value)
      errors << I18n.t('validations.data.invalid_number', field: field_name) unless value.is_a?(Numeric)
    end

    def validate_single_select(field_name, value)
      possible_options = tenant.select_options[field_name]
      return if possible_options.include?(value)

      errors << I18n.t('validations.data.invalid_single_select', options: possible_options.join(', '))
    end

    def validate_multi_select(field_name, value)
      possible_options = tenant.select_options[field_name]
      return if (value - possible_options).blank?

      errors << I18n.t('validations.data.invalid_multi_select', options: possible_options.join(', '))
    end

    def tenant
      @tenant ||= Tenant.find_by(id: tenant_id)
    end
  end
end
