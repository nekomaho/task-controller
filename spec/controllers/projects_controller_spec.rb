require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  before do
    user = FactoryGirl.create(:user)
    sign_in user
  end
  describe 'GET #new' do
    before do
      xhr :get, :new
    end
    it 'get status 200' do
      expect(response).to have_http_status 200
    end
  end

  describe 'GET #show' do
    let(:project) { FactoryGirl.create(:project) }

    before do
      sign_in User.find(project.user_id)
      xhr :get, :show, id: project
    end
    it 'get status 200' do
      expect(response).to have_http_status 200
    end
  end

  describe 'GET #index' do
    before do
      xhr :get, :index
    end
    it 'get status 200' do
      expect(response).to have_http_status 200
    end
  end

  describe 'POST #create' do
    let(:input) { FactoryGirl.attributes_for(:project) }

    before do
      xhr :get, :new
    end
    it 'save the new task in the database' do
      expect do
        xhr :post, :create, params: { project: input }
      end.to change(Project, :count).by(1)
    end
  end

  describe 'GET #edit' do
    let(:update_project) { FactoryGirl.create(:update_project) }

    before do
      sign_in User.find(update_project.user_id)
      xhr :get, :edit, id: update_project
    end
    it 'get status 200' do
      expect(response).to have_http_status 200
    end
  end

  describe 'PATCH #update' do
    let(:update_project) { FactoryGirl.create(:update_project) }

    before do
      sign_in User.find(update_project.user_id)
      xhr :get, :new, id: update_project
    end
    context 'validation sucess' do
      before do
        patch_input = { name: 'Sample', memo: 'one' }
        xhr :patch, :update, id: update_project, project: patch_input
        update_project.reload
      end
      it 'update name coloumn in the database' do
        expect(update_project.name).to eq('Sample')
      end
      it 'update memo coloumn in the database' do
        expect(update_project.memo).to eq('one')
      end
      it 'get status 200' do
        expect(response).to have_http_status 200
      end
    end

    context 'validation failure' do
      before do
        patch_input = { name: '', memo: 'one' }
        xhr :patch, :update, id: update_project, project: patch_input
        update_project.reload
      end
      it 'not update name coloumn in the database' do
        expect(update_project.name).to eq('MyString test')
      end
      it 'not update memo coloumn in the database' do
        expect(update_project.memo).to eq('MyText test test')
      end
      it 'get status 200' do
        expect(response).to have_http_status 200
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:delete_project) { FactoryGirl.create(:delete_project) }

    before do
      sign_in User.find(delete_project.user_id)
      xhr :get, :new, id: delete_project
    end
    it 'delete from the database' do
      expect do
        xhr :delete, :destroy, id: delete_project
      end.to change(Project, :count).by(-1)
    end
  end
end
