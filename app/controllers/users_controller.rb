# frozen_string_literal: true

class UsersController < ApplicationController
  def me
    render json: Current.user
  end

  def update
    result = ::UserServices::UpdateUserTenantData.call(
      data: params['data'],
      tenant_id: params['tenant_id']
    )

    return render_validation_errors(result.errors) if result.errors.any?

    render json: result.tenant_data
  end
end
