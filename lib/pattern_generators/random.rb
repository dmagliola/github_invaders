module GithubInvaders
  module PatternGenerators
    class Random
      def initialize(probability = 0.25)
        @probability = probability.to_f
      end

      def generate(_point)
        if ::Random.new.rand < @probability
          1
        else
          0
        end
      end
    end
  end
end