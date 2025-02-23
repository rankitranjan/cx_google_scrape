FactoryBot.define do
  factory :keyword do
    user { nil }
    sequence(:name) { |n| "name_#{n}" }
    status { :pending }
  end
end
