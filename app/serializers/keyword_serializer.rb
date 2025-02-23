class KeywordSerializer < ActiveModel::Serializer
  attributes :id, :name, :total_ads, :total_links, :total_results, :status, :created_at
end
