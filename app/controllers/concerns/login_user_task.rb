# check task that bloging login user
module LoginUserTask
  extend ActiveSupport::Concern
  def check_login_user_task?(task)
    current_user.id == Project.find(task.project_id).user_id
  end
end
