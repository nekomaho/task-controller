require 'rails_helper'

RSpec.describe PrevTaskRelationshipsController, type: :controller do
  describe 'POST #creta' do
    let!(:project) { FactoryGirl.create(:project) }
    let!(:input) { FactoryGirl.create(:task, project: project) }
    let!(:prev_task) { FactoryGirl.create(:task, project: project) }
    let!(:another_project_task) { FactoryGirl.create(:task) }

    context 'when access no login user' do
      it 'redirect to login page' do
        expect(
          post(:create, params: { next_task: input.id, prev_task: { id: prev_task.id } })
        ).to redirect_to(new_user_session_path)
      end
    end
    context 'when access login user' do
      before do
        project = Project.find(input.project_id)
        sign_in User.find(project.user_id)
      end
      it 'add task relation' do
        expect do
          post(:create, params: { next_task: input.id, prev_task: { id: prev_task.id } })
        end.to change(TaskRelationship, :count).by(1)
      end
    end
    context 'another project task' do
      before do
        project = Project.find(input.project_id)
        sign_in User.find(project.user_id)
      end
      it 'redirect to top page' do
        expect(
          post(:create, params: { next_task: input.id,
                                  prev_task: { id: another_project_task.id } })
        ).to redirect_to(top_index_url)
      end
    end
  end
  describe 'DELETE #destroy' do
    let!(:project) { FactoryGirl.create(:project) }
    let!(:input) { FactoryGirl.create(:task, project: project) }
    let!(:prev_task) { FactoryGirl.create(:task, project: project) }

    context 'when access no login user' do
      it 'redirect to login page' do
        expect(
          delete(:destroy, params: { id: input.id, delete_id: prev_task.id })
        ).to redirect_to(new_user_session_path)
      end
    end
    context 'when access login user' do
      before do
        project = Project.find(input.project_id)
        sign_in User.find(project.user_id)
        post(:create, params: { next_task: input.id, prev_task: { id: prev_task.id } })
      end
      it 'delete task relation' do
        expect do
          delete(:destroy, params: { id: input.id, delete_id: prev_task.id })
        end.to change(TaskRelationship, :count).by(-1)
      end
    end
  end
end
