require 'rails_helper'

RSpec.describe Tenant, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:tenant_data).dependent(:destroy) }
  end
end
