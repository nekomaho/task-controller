FactoryGirl.define do
  factory :project do
    association :user
    name 'MyString test'
    memo 'MyText test test'
  end
  factory :update_project, class: Project do
    association :user, factory: :user
    name 'MyString test'
    memo 'MyText test test'
  end
  factory :delete_project, class: Project do
    association :user, factory: :user
    name 'MyString test'
    memo 'MyText test test'
  end
end
