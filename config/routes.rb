Rails.application.routes.draw do
  get 'health' => 'rails/health#show', as: :rails_health_check
  get :me, to: 'users#me'
end
