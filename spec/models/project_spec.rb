require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'relation' do
    it { is_expected.to have_many(:tasks) }
    it { is_expected.to belong_to(:user) }
  end
  describe '#name' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(255) }
  end
  describe '#memo' do
    it { is_expected.to validate_length_of(:memo).is_at_most(100_000) }
  end
end
