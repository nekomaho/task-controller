require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  describe 'GET #new' do
    let(:project) { FactoryGirl.create(:project) }

    before do
      sign_in User.find(project.user_id)
      xhr :get, :new, params: { project_id: project.id }
    end
    it 'get status 200' do
      expect(response).to have_http_status 200
    end
  end

  describe 'GET #show' do
    let(:project) { FactoryGirl.create(:project) }
    let(:task) { FactoryGirl.create(:task, project: project) }

    before do
      sign_in User.find(project.user_id)
      xhr :get, :show, id: task
    end
    it 'get status 200' do
      expect(response).to have_http_status 200
    end
  end

  describe 'GET #index' do
    let(:project) { FactoryGirl.create(:project) }
    let(:task) { FactoryGirl.create(:task, project: project) }

    before do
      sign_in User.find(project.user_id)
      get :index, project_id: project.id
    end
    it 'get status 200' do
      expect(response).to have_http_status 200
    end
  end

  describe 'GET #edit' do
    let(:update_task) { FactoryGirl.create(:update_task) }

    before do
      project = Project.find(update_task.project_id)
      sign_in User.find(project.user_id)
      xhr :get, :edit, id: update_task
    end
    it 'get status 200' do
      expect(response).to have_http_status 200
    end
  end

  describe 'POST #new' do
    let(:input) { FactoryGirl.attributes_for(:task) }
    let(:project) { FactoryGirl.create(:project) }

    before do
      sign_in User.find(project.user_id)
    end
    it 'save the new task in the database' do
      expect do
        post :create, params: { project_id: project.id, task: input }
      end.to change(Task, :count).by(1)
    end
  end

  describe 'PATCH #update' do
    let(:update_task) { FactoryGirl.create(:update_task) }

    before do
      project = Project.find(update_task.project_id)
      sign_in User.find(project.user_id)
    end
    context 'update success' do
      before do
        task_parameter = { name: 'Neko', memo: 'hoge', days: 5 }
        xhr :patch, :update, id: update_task, task: task_parameter
        update_task.reload
      end
      it 'update name coloumn in the database' do
        expect(update_task.name).to eq('Neko')
      end
      it 'update memo coloumn in the database' do
        expect(update_task.memo).to eq('hoge')
      end
      it 'update days coloumn in the database' do
        expect(update_task.days).to eq(5)
      end
      it 'get status 200' do
        expect(response).to have_http_status 200
      end
    end

    context 'update failure' do
      before do
        task_parameter = { name: '', memo: 'hoge', days: 5 }
        xhr :patch, :update, id: update_task, task: task_parameter
        update_task.reload
      end
      it 'not update name coloumn in the database' do
        expect(update_task.name).to eq('MyString test')
      end
      it 'not update memo coloumn in the database' do
        expect(update_task.memo).to eq('MyText test test')
      end
      it 'not update days coloumn in the database' do
        expect(update_task.days).to eq(2)
      end
      it 'get status 200' do
        expect(response).to have_http_status 200
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:delete_task) { FactoryGirl.create(:delete_task) }

    it 'delete from the database' do
      project = Project.find(delete_task.project_id)
      sign_in User.find(project.user_id)
      expect { delete :destroy, id: delete_task }.to change(Task, :count).by(-1)
    end
  end
end
