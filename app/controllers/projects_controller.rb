# Project Controller
class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :current_user_project
  def new
    @project = Project.new
  end

  def index
    @projects = @user_project.all
    @projects ||= []
    respond_to do |format|
      format.js
    end
  end

  def create
    @project = @user_project.build(project_params)
    @project.save ? redirect_to(top_index_url) : render('new')
  end

  def edit
    @project = @user_project.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def update
    @project = @user_project.find(params[:id])
    if @project.update_attributes(project_params)
      redirect_to top_index_url
    else
      render 'edit'
    end
  end

  def show
    @project = @user_project.find(params[:id])
  end

  def destroy
    @user_project.find(params[:id]).destroy
    redirect_to top_index_url
  end

  private

  def current_user_project
    @user_project = current_user.projects
  end

  def project_params
    params.require(:project).permit(:name, :memo)
  end
end
