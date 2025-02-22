FactoryBot.define do
  factory :keyword do
    user { nil }
    name { "MyString" }
    status { :pending }
  end
end
