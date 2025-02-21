require 'rails_helper'

describe KeywordProcessor do
  describe '.process' do
    it 'removes duplicates and sorts keywords' do
      keywords = ['Hotel', 'Flight', 'hotel', 'flight', 'Car Rental']
      processed_keywords = KeywordProcessor.process(keywords)

      expect(processed_keywords).to eq(['car rental', 'flight', 'hotel'])
    end

    it 'returns an empty array when given an empty input' do
      expect(KeywordProcessor.process([])).to eq([])
    end

    it 'handles case-insensitive duplicates' do
      keywords = ['SEO', 'seo', 'Seo']
      expect(KeywordProcessor.process(keywords)).to eq(['seo'])
    end
  end
end
