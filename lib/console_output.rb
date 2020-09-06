require 'colorize'

# Used for debugging / previewing purposes, mostly when developing pattern generators
module GithubInvaders
  module ConsoleOutput
    # Expects a "2d array", which is an outer array of "columns",
    # each an array of 7 "rows", each containing a 0 or a 1.
    def self.print_pattern(pattern)
      rows = pattern.first.length

      rows.times do |y|
        pattern.length.times do |x|
          pixel = pattern[x][y]
          print "  ".colorize(background: (pixel == 1 ? :white : :black))
        end
        puts "\n"
      end
    end
  end
end