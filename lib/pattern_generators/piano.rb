# Generates a pattern that looks like the keys in a piano/keyboard
module GithubInvaders
  module PatternGenerators
    class Piano
      OCTAVE_WIDTH = 28 # 7 keys, 4 pixels each

      def generate(point)
        # Borders around white keys
        return 1 if point.x % 4 == 0 # every 4th column is full on
        return 1 if point.y == 6 # the bottom row is all on

        # Black keys
        # Black keys are two short lines next to the line that separates keys
        black_key_column = ((point.x - 1) % 4 == 0) || ((point.x + 1) % 4 == 0) # columns where the black key is on
        return 0 unless black_key_column # If we're not in a column that'd have a black key, bail
        return 0 if point.y > 2 # the two short lines are the first 3 rows, bail if we're below that

        # Figure out which key's boundary we're in. The "-2" is an offset so that you don't get a half-black key on
        # both sides of a white key that "has a black key". Instead, we're looking at "the right side" of a key
        current_white_key = (point.x - 2) % OCTAVE_WIDTH / 4 # 0 = Do, 6 = Ti.
        white_keys_with_black_key = [0, 1, 3, 4, 5] # Do, Re, Fa, Sol, La have black keys

        return 1 if current_white_key.in?(white_keys_with_black_key)
      end
    end
  end
end