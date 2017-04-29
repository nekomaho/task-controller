# Prev Task Relationships Controller
class PrevTaskRelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :search_create_task, only: [:create]

  include LoginUserTask

  def create
    unless check_login_user_task?(@task) && @task.same_project_task?(@prev_task)
      return redirect_to(top_index_url)
    end
    @task.add_prev_task(@prev_task)
    redirect_to(project_tasks_path(Project.find(@task.project_id)))
  end

  def destroy
    task = Task.find(params[:id])
    delete_task = Task.find(params[:delete_id])
    return redirect_to(top_index_url) unless check_login_user_task?(task)
    task.delete_prev_task(delete_task)
    project = Project.find(task.project_id)
    redirect_to(project_tasks_path(project))
  end

  private

  # HACK : use concerns same process that prev_task and destory
  def search_create_task
    @prev_task = Task.find(params[:prev_task][:id])
    @task = Task.find(params[:next_task])
  end
end
