# Prev Task Relationships Controller
class PrevTaskRelationshipsController < ApplicationController
  before_action :authenticate_user!

  include RelationTask

  def create
    add_relation_to_current(params[:prev_task], params[:next_task], :add_prev_task)
  end

  def destroy
    delete_relation_from_current(params[:delete_id], params[:id], :delete_prev_task)
  end
end
