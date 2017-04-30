require 'rails_helper'

RSpec.describe LoginUserTask do
  let(:login_user_task) { Class.new { include LoginUserTask }.new }

  describe '#check_login_user_task?' do
    let(:project) { FactoryGirl.create(:project) }
    let(:task) { FactoryGirl.create(:task, project: project) }
    let(:no_login_task) { FactoryGirl.create(:task) }

    # this test may not have means. because current_user using stub method.
    # we sholud call current_user from Devise modul.
    before do
      login_user_task.class_eval { attr_accessor :current_user }
      user = User.find(project.user_id)
      sign_in user
      login_user_task.current_user = user
    end
    it { expect(login_user_task).to be_check_login_user_task(task) }
    it { expect(login_user_task).not_to be_check_login_user_task(no_login_task) }
  end
end
