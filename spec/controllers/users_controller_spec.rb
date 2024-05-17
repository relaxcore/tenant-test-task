# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::UsersController, type: :controller do
  describe 'GET me' do
    context 'when the user is authenticated' do
      it 'returns current user' do
        user = create(:user)
        request.headers.merge!(Authorization: user.auth_token)

        get :me, params: {}

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to eq(
          {
            'id' => user.id,
            'username' => 'johndoe',
            'tenant_data' => []
          }
        )
      end
    end

    context 'when the user is not authenticated' do
      it 'returns empty repsonse with 401 status code' do
        get :me, params: {}

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PUT update' do
    context 'when the user is authenticated' do
      context 'when params are valid' do
        it 'updates the user tenant data' do
          user = create(:user)
          tenant = create(:tenant)
          request.headers.merge!(Authorization: user.auth_token)

          put :update, params: {
            tenant_id: tenant.id,
            data: {
              'First name' => 'John',
              'Last name' => 'Doe',
              'Phone number' => '123456789',
              'Year of birth' => 2000,
              'Gender' => 'Male',
              'Preferable type of work' => 'Office',
              'Skills' => %w[Ruby Python],
              'Hobbies' => %w[Reading Drawing]
            }
          }

          tenant_data = tenant.tenant_data
          expect(tenant_data.count).to eq(1)
          expect(response).to have_http_status(:ok)
          expect(response.parsed_body).to eq(
            {
              'id' => tenant_data.take.id,
              'data' => {
                'First name' => 'John',
                'Gender' => 'Male',
                'Hobbies' => ['Reading', 'Drawing'],
                'Last name' => 'Doe',
                'Phone number' => 123456789,
                'Preferable type of work' => 'Office',
                'Skills' => ['Ruby', 'Python'],
                'Year of birth' => 2000
              },
              'data_structure' => {
                'Gender' => 'single_select_required',
                'Skills' => 'multi_select_required',
                'Hobbies' => 'multi_select',
                'Last name' => 'string',
                'First name' => 'string_required',
                'Phone number' => 'number_required',
                'Year of birth' => 'number',
                'Preferable type of work' => 'single_select'
              },
              'select_options'=> {
                'Gender' => ['Male', 'Female'],
                'Skills' => ['Ruby', 'Python', 'JavaScript', 'Java', 'Elixir', 'SQL', 'Go', 'Rust'],
                'Hobbies' => ['Reading', 'Drawing', 'Dancing', 'Videogames', 'Photography', 'Chess'],
                'Preferable type of work' => ['Office', 'Hybrid', 'Home']
              }
            }
          )
        end
      end

      context 'when params are invalid' do
        it 'returns error message with 422 status code when tenant_id is missing' do
          user = create(:user)
          tenant = create(:tenant)
          request.headers.merge!(Authorization: user.auth_token)

          put :update, params: {
            data: {
              'First name' => 'John',
              'Last name' => 'Doe',
              'Phone number' => '123456789',
              'Year of birth' => 2000,
              'Gender' => 'Male',
              'Preferable type of work' => 'Office',
              'Skills' => %w[Ruby Python],
              'Hobbies' => %w[Reading Drawing]
            }
          }

          tenant_data = tenant.tenant_data
          expect(tenant_data.count).to be_zero
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.parsed_body).to eq({ 'errors' => ['Tenant ID can\'t be blank'] })
        end

        it 'returns error message with 422 status code when tenant_id is invalid' do
          user = create(:user)
          tenant = create(:tenant)
          request.headers.merge!(Authorization: user.auth_token)

          put :update, params: {
            tenant_id: 'invalid_id',
            data: {
              'First name' => 'John',
              'Last name' => 'Doe',
              'Phone number' => '123456789',
              'Year of birth' => 2000,
              'Gender' => 'Male',
              'Preferable type of work' => 'Office',
              'Skills' => %w[Ruby Python],
              'Hobbies' => %w[Reading Drawing]
            }
          }

          tenant_data = tenant.tenant_data
          expect(tenant_data.count).to be_zero
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.parsed_body).to eq({ 'errors' => ['Tenant ID is invalid'] })
        end

        it 'returns error message with 422 status code when data is missing' do
          user = create(:user)
          tenant = create(:tenant)
          request.headers.merge!(Authorization: user.auth_token)

          put :update, params: { tenant_id: tenant.id, data: {} }

          tenant_data = tenant.tenant_data
          expect(tenant_data.count).to be_zero
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.parsed_body).to eq({ 'errors' => ['Data can\'t be blank'] })
        end

        it 'returns error message with 422 status code when the data contains fields other that tenant has' do
          user = create(:user)
          tenant = create(:tenant)
          request.headers.merge!(Authorization: user.auth_token)

          put :update, params: { tenant_id: tenant.id, data: { 'Field 1' => 'value', 'Fields2' => 'value'} }

          tenant_data = tenant.tenant_data
          expect(tenant_data.count).to be_zero
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.parsed_body).to eq({ 'errors' => ["Data contains invalid fields: 'Field 1, Fields2'"] })
        end

        it 'returns error message with 422 status code when required fields are missing' do
          user = create(:user)
          tenant = create(:tenant)
          request.headers.merge!(Authorization: user.auth_token)

          put :update, params: { tenant_id: tenant.id, data: { 'Last name' => 'Doe' } }

          tenant_data = tenant.tenant_data
          expect(tenant_data.count).to be_zero
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.parsed_body).to eq(
            {
              'errors' => [
                "Data must contain field 'Gender' with type 'single_select'",
                "Data must contain field 'Skills' with type 'multi_select'",
                "Data must contain field 'First name' with type 'string'",
                "Data must contain field 'Phone number' with type 'number'"
              ]
            }
          )
        end

        it 'returns error message with 422 status code when the fields has invalid data type or invalid selection' do
          user = create(:user)
          tenant = create(:tenant)
          request.headers.merge!(Authorization: user.auth_token)

          put :update, params: {
            tenant_id: tenant.id,
            data: {
              'First name' => 123,
              'Gender' => 'Helicopter',
              'Skills' => ['Nothing'],
              'Phone number' => '123abc456',
              }
            }

          tenant_data = tenant.tenant_data
          expect(tenant_data.count).to be_zero
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.parsed_body).to eq(
            {
              "errors"=> [
                "Data field 'First name' must be a string",
                "Invalid selection in field 'Gender': must be one of 'Male, Female'",
                "Data field 'Phone number' must be a number",
                "Invalid selection in field 'Skills': must be one or more of 'Ruby, Python, JavaScript, Java, Elixir, SQL, Go, Rust'"
              ]
            }
          )
        end
      end
    end

    context 'when the user is not authenticated' do
      it 'returns empty repsonse with 401 status code' do
        put :update, params: {}

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
