require "dotenv/load"
require "active_support/all"
require_relative "lib/github_invaders"
require_relative "lib/console_output"

Dotenv.require_keys("GITHUB_DUMMY_REPO")

desc "Calls the specified pattern generator, and outputs the result to console"
# rake test_pattern[Random,0.25,53]
task :test_pattern, [:generator_klass, :generator_params, :columns] do |_t, args|
  generator_klass = args[:generator_klass]
  generator_params =  args[:generator_params]
  columns = args[:columns] ? args[:columns].to_i : 53
  rows = 7

  require_relative "lib/pattern_generators/#{ generator_klass.underscore }"
  generator = "GithubInvaders::PatternGenerators::#{ generator_klass }".constantize.new(*generator_params)

  pattern = GithubInvaders.generate_pattern(generator: generator, rows: rows, columns: columns)
  GithubInvaders::ConsoleOutput.print_pattern(pattern)
end

