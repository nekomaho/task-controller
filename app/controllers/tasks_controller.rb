# Task Controller
class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :parent_project
  skip_before_action :parent_project, only: %i[edit show update destroy]

  include LoginUserTask

  def new
    @task = Task.new
  end

  def index
    @tasks = @project.tasks.all
    @tasks ||= []
  end

  def create
    @task = @project.tasks.build(task_params)
    @task.save ? redirect_to(project_tasks_url) : render('new')
  end

  def edit
    @task = Task.find(params[:id])
    return redirect_to(top_index_url) unless check_login_user_task?(@task)
  end

  def update
    @task = Task.find(params[:id])

    return redirect_to(top_index_url) unless check_login_user_task?(@task)
    if @task.update_attributes(task_params)
      project = Project.find(@task.project_id)
      redirect_to project_tasks_path(project)
    else
      render('edit')
    end
  end

  def show
    @task = Task.find(params[:id])
    return redirect_to(top_index_url) unless check_login_user_task?(@task)
  end

  def destroy
    @task = Task.find(params[:id])
    return redirect_to(top_index_url) unless check_login_user_task?(@task)

    project = Project.find(@task.project_id)

    Task.find(params[:id]).destroy
    redirect_to project_tasks_path(project)
  end

  private

  def task_params
    params.require(:task).permit(:name, :memo, :days)
  end

  def parent_project
    @project = current_user.projects.find(params[:project_id])
  end
end
