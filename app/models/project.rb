# Project Model
class Project < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy
  validates :name, presence: true, length: { maximum: 255 }
  validates :memo, length: { maximum: 100_000 }
end
