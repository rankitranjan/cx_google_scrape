require 'csv'

class CsvParser
  def self.parse(csv_content)
    return [] if csv_content.strip.empty?

    parsed_data = CSV.parse(csv_content, headers: true)
    parsed_data['Keywords']
      .compact
      .reject(&:empty?)
      .reject { |keyword| keyword.match?(/^\W+$/) }
  end
end
