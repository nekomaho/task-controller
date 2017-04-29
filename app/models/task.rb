# Task Model
class Task < ApplicationRecord
  belongs_to :project
  has_many :prev_relationships,
           class_name: :TaskRelationship,
           foreign_key: 'next_id',
           dependent: :destroy
  has_many :prev_tasks, through: :prev_relationships, source: :previous
  has_many :next_relationships,
           class_name: :TaskRelationship,
           foreign_key: 'previous_id',
           dependent: :destroy
  has_many :next_tasks, through: :next_relationships, source: :next
  validates :name, presence: true, length: { maximum: 255 }
  validates :memo, length: { maximum: 100_000 }
  validates :days, presence: true, inclusion: { in: 0..10_000 }

  def add_prev_task(prev_task)
    prev_relationships.create(previous_id: prev_task.id)
  end

  def delete_prev_task(prev_task)
    prev_relationships.find_by(previous_id: prev_task.id).delete
  end

  def prev_task?(prev_task)
    prev_tasks.include?(prev_task)
  end

  def add_next_task(next_task)
    next_relationships.create(next_id: next_task.id)
  end

  def delete_next_task(next_task)
    next_relationships.find_by(next_id: next_task.id).delete
  end

  def next_task?(next_task)
    next_tasks.include?(next_task)
  end

  def candidate_task
    Task.find_by_sql(['select * from Tasks as ts
                      where not exists(select 1
                                         from task_relationships as ts_re
                                         where ts.id = ts_re.previous_id)
                        and not exists(select 1
                                         from task_relationships as ts_re
                                         where ts.id = ts_re.next_id)
                        and ts.project_id = ?
                        and ts.id != ?', project_id, id])
  end

  def same_project_task?(task)
    project_id == task.project_id
  end
end
