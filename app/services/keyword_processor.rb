class KeywordProcessor
  def self.process(keywords)
    keywords.map(&:downcase).uniq.sort
  end
end
