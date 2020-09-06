require_relative "../../lib/calendar"

describe GithubInvaders::Calendar do
  it "calculates the first date in the wall correctly" do
    expected_dates = {
        "2020-09-01" => "2019-09-01",
        "2020-09-02" => "2019-09-01",
        "2020-09-03" => "2019-09-01",
        "2020-09-04" => "2019-09-01",
        "2020-09-05" => "2019-09-01",
        "2020-09-06" => "2019-09-08",
        "2020-09-07" => "2019-09-08",
        "2020-09-08" => "2019-09-08",
        "2020-09-09" => "2019-09-08",
        "2020-09-10" => "2019-09-08",
        "2020-09-11" => "2019-09-08",
        "2020-09-12" => "2019-09-08",
        "2020-09-13" => "2019-09-15",
        "2020-09-14" => "2019-09-15",
    }

    expected_dates.each do |today, expected_first_date|
      expect(described_class.first_wall_date(Date.parse(today))).
        to eq(Date.parse(expected_first_date))
    end
  end

  it "converts dates to coordinates correctly" do
    wall_start_date = Date.parse("2019-09-08")

    expected_points = {
        "2019-09-08" => Point.new(0,0),
        "2019-09-09" => Point.new(0,1),
        "2019-09-14" => Point.new(0,6),
        "2019-09-15" => Point.new(1,0),
        "2020-09-12" => Point.new(52,6),
    }

    expected_points.each do |date, expected_point|
      expect(described_class.date_to_coordinates(Date.parse(date), wall_start_date)).
        to eq(expected_point)
    end
  end
end