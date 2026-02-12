require "test_helper"

class CityTest < ActiveSupport::TestCase
  test "city has name and zip_code" do
    city = City.new(name: "Paris", zip_code: "75000")
    assert city.valid?
  end
end
