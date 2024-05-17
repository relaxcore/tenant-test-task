# frozen_string_literal: true

class UsersController < ApplicationController
  def me
    render json: Current.user
  end

  def update
    params_hash = params.to_unsafe_h

    result = ::UserServices::UpdateUserTenantData.call(
      data: params_hash['data'],
      tenant_id: params_hash['tenant_id']
    )

    return render_validation_errors(result.errors) if result.errors.any?

    render json: result.tenant_data
  end
end
