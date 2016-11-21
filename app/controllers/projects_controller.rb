# Handle request for Project Model
class ProjectsController < ApplicationController
  before_action :project_list, only: [:index]
  after_action :verify_authorized

  def index
    authorize(:project)
  end

  def new
    authorize(:project)
    @clients = Client.select(:name, :id)
    @project = Project.new
  end

  def create
    authorize(:project)
    project = Project.new(project_params)
    project.save
    flash[:notice] = "Project successfuly created !"
    redirect_to projects_url
  end

  def destroy
    authorize(:project)
    project = Project.find(params[:id])
    project.destroy
    flash[:notice] = "Project successfuly deleted !"
    redirect_to projects_url
  end

  private

  def project_params
    params.require(:project).permit(:client_id, :name)
  end

  def project_list
    @client = Client.all
    @projects = Project.all
    # binding.pry
  end
end
