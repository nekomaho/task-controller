# Next Task Relationships Controller
class NextTaskRelationshipsController < ApplicationController
  before_action :authenticate_user!

  include RelationTask

  def create
    add_relation_to_current(params[:next_task], params[:prev_task], :add_next_task)
  end

  def destroy
    delete_relation_from_current(params[:delete_id], params[:id], :delete_next_task)
  end
end
