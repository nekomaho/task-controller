FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password 'password'
    password_confirmation 'password'
    confirmed_at Date.today
  end
  factory :user_task, class: User do
    email { Faker::Internet.email }
    password 'password'
    password_confirmation 'password'
    confirmed_at Date.today
  end
end
