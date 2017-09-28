# next and previous task operations
module RelationTask
  extend ActiveSupport::Concern
  include LoginUserTask

  def add_relation_to_current(add_task_param, current_task_param, sym_func_name)
    add_task, current = search_add_task(add_task_param, current_task_param)
    unless check_login_user_task?(current) && current.same_project_task?(add_task)
      return redirect_to(top_index_url)
    end
    add_func = current.method(sym_func_name)
    add_func.call(add_task)
    redirect_to(project_tasks_path(Project.find(current.project_id)))
  end

  def delete_relation_from_current(delete_task_id, current_task_id, sym_func_name)
    delete_task, current = search_delete_task(delete_task_id, current_task_id)
    return redirect_to(top_index_url) unless check_login_user_task?(current)
    delete_func = current.method(sym_func_name)
    delete_func.call(delete_task)
    redirect_to(project_tasks_path(Project.find(current.project_id)))
  end

  def search_add_task(add_task, current_task)
    [Task.find(add_task[:id]), Task.find(current_task)]
  end

  def search_delete_task(delete_task_id, current_task_id)
    [Task.find(delete_task_id), Task.find(current_task_id)]
  end
  module_function :search_add_task
  module_function :search_delete_task
end
