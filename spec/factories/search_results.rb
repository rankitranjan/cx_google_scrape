FactoryBot.define do
  factory :search_result do
    keyword { nil }
    total_ads { 1 }
    total_links { 1 }
    total_results { "MyString" }
    html { "MyText" }
  end
end
