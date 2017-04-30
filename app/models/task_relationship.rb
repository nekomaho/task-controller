# Task Relationship Model
class TaskRelationship < ApplicationRecord
  belongs_to :previous, class_name: 'Task'
  belongs_to :next, class_name: 'Task'
  validates :previous, presence: true
  validates :next, presence: true
end
