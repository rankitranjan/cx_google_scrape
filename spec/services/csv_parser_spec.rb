require 'rails_helper'
require 'csv'

describe CsvParser do
  describe '.parse' do
    let(:csv_content) do
      <<~CSV
        Keywords
        Python
        Ruby
        React
        SOLID principles
        Multi AI Agent
      CSV
    end

    it 'extracts keywords from CSV content' do
      keywords = CsvParser.parse(csv_content)
      expect(keywords).to eq(["Python", "Ruby", "React", "SOLID principles", "Multi AI Agent"])
    end

    it 'handles empty CSV content gracefully' do
      empty_content = ""
      keywords = CsvParser.parse(empty_content)
      expect(keywords).to eq([])
    end

    it 'ignores empty lines in CSV content' do
      csv_with_empty_lines = <<~CSV
        Keywords
        Python

        Ruby
        React

      CSV

      keywords = CsvParser.parse(csv_with_empty_lines)
      expect(keywords).to eq(["Python", "Ruby", "React"])
    end

    it 'ignores keywords with only special characters' do
      csv_with_special_chars = <<~CSV
        Keywords
        Ruby
        $$$$
        @#$%^&
        Python
      CSV

      keywords = CsvParser.parse(csv_with_special_chars)
      expect(keywords).to eq(["Ruby", "Python"])
    end    
  end
end
