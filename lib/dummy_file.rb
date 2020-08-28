module GithubInvaders
  # Deals with our dummy file that we increment in each commit (just because we need something to commit)
  module DummyFile
    def self.increment_dummy_file(dummy_file_path)
      cur_value = if File.exists?(dummy_file_path)
                    File.open(dummy_file_path).read.strip.to_i
                  else
                    0
                  end

      cur_value += 1

      File.open(dummy_file_path, "w"){ |f| f.write("#{cur_value}\n") }

      cur_value
    end
  end
end
