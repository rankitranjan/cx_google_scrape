require 'csv'

class CsvParser
  def self.parse(csv_content)
    return [] if csv_content.strip.empty?

    parsed_data = CSV.parse(csv_content, headers: true)

    # Normalize headers for case-insensitive lookup
    headers = parsed_data.headers.map(&:downcase)

    # Try to find "keywords" or "keyword" (case-insensitive)
    keyword_column = headers.find { |h| h.match?(/\Akeywords?\z/i) }

    # Get the column data; if not found, use the first column
    column_key = keyword_column || parsed_data.headers.first
    keywords = parsed_data.by_col[column_key]

    keywords.compact.reject(&:empty?).reject { |keyword| keyword.match?(/^\W+$/) }
  end
end
