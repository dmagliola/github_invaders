require_relative "../../lib/dummy_file"

describe GithubInvaders::DummyFile do
  TEST_DUMMY_PATH = "/tmp/github_invaders_test_dummy.txt"

  before(:each) do
    FileUtils.rm(TEST_DUMMY_PATH) if File.exists?(TEST_DUMMY_PATH)
  end

  it "creates a file if one doesn't exist" do
    expect(File.exists?(TEST_DUMMY_PATH)).to be(false)

    described_class.increment_dummy_file(TEST_DUMMY_PATH)
    expect(File.exists?(TEST_DUMMY_PATH)).to be(true)

    expect(File.open(TEST_DUMMY_PATH).read).to eq("1\n")
  end

  it "increments a file" do
    described_class.increment_dummy_file(TEST_DUMMY_PATH)
    described_class.increment_dummy_file(TEST_DUMMY_PATH)
    expect(File.open(TEST_DUMMY_PATH).read).to eq("2\n")
  end
end