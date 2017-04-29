require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'relation' do
    it { is_expected.to belong_to(:project) }
    it { is_expected.to have_many(:prev_relationships) }
    it { is_expected.to have_many(:prev_tasks).through(:prev_relationships) }
    it { is_expected.to have_many(:next_relationships) }
    it { is_expected.to have_many(:next_tasks).through(:next_relationships) }
  end
  describe '#name' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(255) }
  end
  describe '#memo' do
    it { is_expected.to validate_length_of(:memo).is_at_most(100_000) }
  end
  describe '#days' do
    it { is_expected.to validate_presence_of(:days) }
    it { is_expected.to validate_inclusion_of(:days).in_range(0..10_000) }
  end
  describe '#add_prev_task' do
    let(:task) { FactoryGirl.create(:task) }
    let(:prev_task) { FactoryGirl.create(:task) }

    before { task.add_prev_task(prev_task) }
    it { expect(task).to be_prev_task(prev_task) }
  end
  describe '#delete_prev_task' do
    let(:task) { FactoryGirl.create(:task) }
    let(:prev_task) { FactoryGirl.create(:task) }

    before do
      task.add_prev_task(prev_task)
      task.delete_prev_task(prev_task)
    end
    it { expect(task).not_to be_prev_task(prev_task) }
  end
  describe '#prev_task?' do
    let(:task) { FactoryGirl.create(:task) }
    let(:prev_task) { FactoryGirl.create(:task) }

    it { expect(task).not_to be_prev_task(prev_task) }
  end
  describe '#add_next_task' do
    let(:task) { FactoryGirl.create(:task) }
    let(:next_task) { FactoryGirl.create(:task) }

    before { task.add_next_task(next_task) }
    it { expect(task).to be_next_task(next_task) }
  end
  describe '#delete_next_task' do
    let(:task) { FactoryGirl.create(:task) }
    let(:next_task) { FactoryGirl.create(:task) }

    before do
      task.add_next_task(next_task)
      task.delete_next_task(next_task)
    end
    it { expect(task).not_to be_next_task(next_task) }
  end
  describe '#next_task?' do
    let(:task) { FactoryGirl.create(:task) }
    let(:next_task) { FactoryGirl.create(:task) }

    it { expect(task).not_to be_next_task(next_task) }
  end
  describe '#candidate_task' do
    let(:project) { FactoryGirl.create(:project) }
    let(:task) { FactoryGirl.create(:task, project: project) }
    let(:next_task) { FactoryGirl.create(:task, project: project) }
    let(:next_next_task) { FactoryGirl.create(:task, project: project) }
    let!(:no_relate_task) { FactoryGirl.create(:task, project: project) }

    before do
      task.add_next_task(next_task)
      next_task.add_next_task(next_next_task)
    end
    it { expect(task.candidate_task).to eq([no_relate_task]) }
  end
  describe '#same_project_task?' do
    let(:same_project) { FactoryGirl.create(:project) }
    let(:task1) { FactoryGirl.create(:task, project: same_project) }
    let(:task2) { FactoryGirl.create(:task, project: same_project) }
    let(:task3) { FactoryGirl.create(:task) }

    it { expect(task1).to be_same_project_task(task2) }
    it { expect(task1).not_to be_same_project_task(task3) }
  end
end
