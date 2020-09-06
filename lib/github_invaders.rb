require_relative "calendar"
require_relative "github"
require 'logger'

module GithubInvaders
  NUM_COMMITS_FOR_PIXEL_ON = 100 # how many commits do we need to fully turn a pixel on
  COMMIT_TIME = 23.hours # what time on the date we're committing the commit lands

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

  # Given a generator, and an initialized Github client, generates fake commits
  # for the specified dates, and pushes to Github, updating the wall.
  #
  # - wall_start_date: What was the wall start date when we first started drawing.
  #     This is used when filling progressively, to allow for scrolling.
  # - from_date: First date to fill in
  # - to_date: Last date to fill in.
  def self.fill_wall(generator:,
                     github:,
                     wall_start_date: Calendar.first_wall_date,
                     from_date: Calendar.first_wall_date,
                     to_date: Date.today)

    github.clone_repo
    logger.info("Repo Cloned")

    (from_date..to_date).each do |date|
      coords = Calendar.date_to_coordinates(date, wall_start_date)
      pixel = generator.generate(coords)
      next unless pixel == 1

      # Generate the dummy commits to turn the pixel on for this dayte
      commit_datetime = date.to_datetime + COMMIT_TIME
      NUM_COMMITS_FOR_PIXEL_ON.times do
        github.make_dummy_commit(date: commit_datetime)
      end
      logger.info("Commits created for #{ commit_datetime }")

      # It seems if you push too much at once, it gets kind of ignored by the chart
      # Hopefully pushing on every date, while inefficient, will get around that.
      github.push_repo
      logger.info("Repo pushed")
    end
  end

  private

  def self.logger
    @logger ||= Logger.new(STDOUT)
  end
end