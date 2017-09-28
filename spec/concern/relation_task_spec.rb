require 'rails_helper'

RSpec.describe RelationTask, type: :controller do
  controller do
    include RelationTask
    before_action :authenticate_user!
    def fake_add
      add_relation_to_current(params[:add_task], params[:current], :add_next_task)
    end

    def fake_delete
      delete_relation_from_current(params[:delete], params[:current], :delete_next_task)
    end
  end

  before do
    routes.draw do
      post 'fake_add' => 'anonymous#fake_add'
      delete 'fake_delete' => 'anonymous#fake_delete'
    end
  end

  describe '#add_relation_to_current' do
    let!(:project) { FactoryGirl.create(:project) }
    let!(:input) { FactoryGirl.create(:task, project: project) }
    let!(:prev_task) { FactoryGirl.create(:task, project: project) }

    context 'when access no login user' do
      it 'redirect to login page' do
        expect(
          post(:fake_add, params: { current: input.id, add_task: { id: prev_task.id } })
        ).to redirect_to(new_user_session_path)
      end
    end
    context 'when access login user but adding different project task' do
      let!(:other_project) { FactoryGirl.create(:project) }
      let!(:other) { FactoryGirl.create(:task, project: other_project) }

      before do
        project = Project.find(input.project_id)
        sign_in User.find(project.user_id)
      end
      it 'redirect to top page' do
        expect(
          post(:fake_add, params: { current: input.id, add_task: { id: other.id } })
        ).to redirect_to(top_index_url)
      end
    end
    context 'when add same task and access login user' do
      before do
        project = Project.find(input.project_id)
        sign_in User.find(project.user_id)
      end
      it 'add relationships' do
        expect do
          post(:fake_add, params: { current: input.id, add_task: { id: prev_task.id } })
        end.to change(TaskRelationship, :count).by(1)
      end
    end
  end
  describe '#add_relation_to_current' do
    let!(:project) { FactoryGirl.create(:project) }
    let!(:input) { FactoryGirl.create(:task, project: project) }
    let!(:prev_task) { FactoryGirl.create(:task, project: project) }

    context 'when access no login user' do
      it 'redirect to login page' do
        expect(
          delete(:fake_delete, params: { current: input.id, delete: prev_task.id })
        ).to redirect_to(new_user_session_path)
      end
    end
    context 'when access login user' do
      before do
        project = Project.find(input.project_id)
        sign_in User.find(project.user_id)
        post(:fake_add, params: { current: input.id, add_task: { id: prev_task.id } })
      end
      it 'delete task relation' do
        expect do
          delete(:fake_delete, params: { current: input.id, delete: prev_task.id })
        end.to change(TaskRelationship, :count).by(-1)
      end
    end
  end
end
