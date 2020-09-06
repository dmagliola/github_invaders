require "active_support/core_ext/date"
require "active_support/core_ext/integer/time"
require_relative "point"

module GithubInvaders
  WALL_HEIGHT = 7
  WALL_WIDTH = 53

  # Date calculations, to turn dates into Github Wall's x/y coordinates
  module Calendar
    # Returns the date of the top-left pixel in the wall
    # It's the Sunday 52 weeks ago
    def self.first_wall_date(today = Date.today)
      this_weekday_on_first_column = today - (WALL_WIDTH - 1).weeks

      # round the date now to the Sunday before it
      this_weekday_on_first_column - this_weekday_on_first_column.wday
    end

    # Convert any given date to its x/y coordinates on the wall.
    # Note that `y == Date.wday` in this coordinate system.
    #
    # We can specify what we consider to be the first date the wall "should" have.
    # We can use this for long, scrolling images that will be wider than 53 columns,
    # when we fill the wall continuously over time.
    def self.date_to_coordinates(date, first_wall_date = Calendar.first_wall_date)
      days_since_wall_start = (date - first_wall_date).to_i
      x = (days_since_wall_start / WALL_HEIGHT)
      y = (days_since_wall_start % WALL_HEIGHT)
      Point.new(x, y)
    end
  end
end
