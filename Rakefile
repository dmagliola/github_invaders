require "dotenv/load"
require "active_support/all"
require_relative "lib/github_invaders"
require_relative "lib/console_output"

Dotenv.require_keys("GITHUB_DUMMY_REPO")

# rake test_pattern[FilePattern,pacman]
desc "Calls the specified pattern generator, and outputs the result to console"
task :test_pattern, [:generator_klass, :generator_params, :columns] do |_t, args|
  generator = generator_instance_from_cli_args(args)
  columns = args[:columns] ? args[:columns].to_i : 53
  rows = 7
  pattern = GithubInvaders.generate_pattern(generator: generator, rows: rows, columns: columns)
  GithubInvaders::ConsoleOutput.print_pattern(pattern)
end

# Fills the wall with the pattern specified. Assumes it's never run before.
# If it has run before, make sure to reset your dummy repo, check the README.
# Doesn't store any information about how far it got, or where the wall starts.
# rake fill_once[FilePattern,pacman]
desc "Fills the Github wall, once, from scratch"
task :fill_once, [:generator_klass, :generator_params] do |_t, args|
  generator = generator_instance_from_cli_args(args)
  github = GithubInvaders::Github.new(github_repo: ENV["GITHUB_DUMMY_REPO"])
  GithubInvaders.fill_wall(generator: generator, github: github)
end

#------------------------------------------------------------------

def generator_instance_from_cli_args(args)
  generator_klass = args[:generator_klass]
  generator_params =  args[:generator_params]
  require_relative "lib/pattern_generators/#{ generator_klass.underscore }"
  "GithubInvaders::PatternGenerators::#{ generator_klass }".constantize.new(*generator_params)
end
