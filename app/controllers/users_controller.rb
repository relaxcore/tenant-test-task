# frozen_string_literal: true

class UsersController < ApplicationController
  def me
    render json: Current.user
  end
end
