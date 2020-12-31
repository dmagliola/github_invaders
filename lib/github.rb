require "fileutils"
require "git"
require_relative "dummy_file"

module GithubInvaders
  class Github
    LOCAL_REPO_NAME = "github_invaders"

    attr_reader :github_repo, :work_dir

    def initialize(github_repo:, work_dir: "/tmp/github_invaders")
      @github_repo = github_repo
      @work_dir = work_dir
    end

    def clone_repo
      clean_work_dir
      Git.clone(github_repo, LOCAL_REPO_NAME, path: work_dir)
    end

    def make_dummy_commit(date: Time.now)
      commit_number = DummyFile.increment_dummy_file(dummy_file_path)
      commit_message = "Dummy commit ##{ commit_number }"

      date = date.strftime("%Y-%m-%d %H:%M:%S") unless date.is_a?(String)

      # Set commit date in addition to author date (not supported by Git gem)
      ENV['GIT_COMMITTER_DATE'] = date

      g = Git.open(dummy_repo_path)
      g.add(dummy_file_path)
      g.commit(commit_message, date: date)
    end

    def push_repo
      g = Git.open(dummy_repo_path)
      g.push
    end

    private

    def dummy_repo_path
      File.join(work_dir, LOCAL_REPO_NAME)
    end

    def dummy_file_path
      File.join(dummy_repo_path, "dummy.txt")
    end

    def clean_work_dir
      FileUtils.rm_rf(work_dir)
    end
  end
end
