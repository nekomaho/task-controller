require 'rails_helper'

RSpec.describe TaskRelationship, type: :model do
  describe 'relation' do
    it { is_expected.to belong_to(:previous).required.class_name('Task') }
    it { is_expected.to belong_to(:next).required.class_name('Task') }
  end
  describe '#previous' do
    it { is_expected.to validate_presence_of(:previous) }
  end
  describe '#next' do
    it { is_expected.to validate_presence_of(:next) }
  end
end
