# Generates a looping pattern based on a file in /patterns.
# This allows drawing any specific picture by creating new patterns
#
# Defining pattern files:
# - must be in `REPO_ROOT/patterns`
# - must have 7 lines, with spaces for "off" pixels, and any non-space character for "on" pixels
# - not all lines need to be the same width. Whichever row is widest will set the pattern width for looping
# - There will be 2 pixels added for padding at the right edge of the pattern before padding
# - must be called {pattern_filename}.txt. E.g: To render `pacman.txt`, pass in "pacman" as initializer parameter
module GithubInvaders
  module PatternGenerators
    class FilePattern
      attr_reader :pattern, :pattern_filename

      def initialize(pattern_filename)
        @pattern_filename = pattern_filename
        @pattern = load_pattern
      end

      def generate(point)
        pattern_x = point.x % pattern_width
        pattern[point.y][pattern_x] # We store the pattern rows first, as it's simpler to read that way
      end

      private

      def pattern_width
        pattern.map(&:length).max + 2
      end

      def full_pattern_file_path
        "patterns/#{ pattern_filename }.txt"
      end

      # Loads
      def load_pattern
        file_lines = File.open(full_pattern_file_path).readlines
        raise "Invalid number of lines, expected 7: #{ file_lines.length }" unless file_lines.length == 7

        pattern = file_lines.map do |line|
          line = line.rstrip.tr("\s", "0").tr("^0", "1") # Turn spaces into "0" and everythig else into "1"
          line.chars.map(&:to_i)  # Split into chart, and turn them into ints
        end
      end
    end
  end
end