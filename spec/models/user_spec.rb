require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'relation' do
    it { is_expected.to have_many(:projects) }
  end
  describe '#email' do
    it { is_expected.to validate_uniqueness_of(:email) }
  end
end
