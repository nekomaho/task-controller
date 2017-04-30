FactoryGirl.define do
  factory :task do
    association :project
    name 'MyString test'
    memo 'MyText test test'
    days 1
  end
  factory :task_ex_project, class: Task do
    name 'MyString test'
    memo 'MyText test test'
    days 1
  end
  factory :update_task, class: Task do
    association :project, factory: :project
    name 'MyString test'
    memo 'MyText test test'
    days 2
  end
  factory :delete_task, class: Task do
    association :project, factory: :project
    name 'MyString test'
    memo 'MyText test test'
    days 5
  end
end
