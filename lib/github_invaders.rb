require_relative "calendar"
require_relative "github"

module GithubInvaders
  # Given a Pattern Generator, generates a full pattern.
  # This is generally just used for debugging purposes, to output it to the console / a file.
  def self.generate_pattern(generator:, columns: 53, rows: 7)
    pattern = []

    columns.times do |x|
      column = []
      rows.times do |y|
        column << generator.generate(Point.new(x,y))
      end
      pattern << column
    end

    pattern
  end
end