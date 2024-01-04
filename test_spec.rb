require 'rspec'
require 'webmock/rspec'
require_relative './shipping'

describe CargoTransportation do
  let(:cargo) { CargoTransportation.new }
  let(:fake_response) do
    {
      "rows" => [
        {
          "elements" => [
            {
              "distance" => {
                "value" => 100_000 # value in meters (100 km)
              }
            }
          ]
        }
      ]
    }
  end

  before do
    stub_request(:get, /api.distancematrix.ai/).to_return(
      body: fake_response.to_json,
      status: 200
    )
  end

  describe "#calculate_distance" do
    it "sets the distance in kilometers based on the api response" do
      cargo.calculate_distance
      expect(cargo.instance_variable_get(:@distance)).to eq(100) # 100 km check
    end
  end
  
  describe "#calculate_price" do
    it "calculates the price based on distance and volume for small cargo" do
      cargo.instance_variable_set(:@distance, 100) # set test value
      cargo.instance_variable_set(:@length, 100)  # in cm
      cargo.instance_variable_set(:@width, 100)   # in cm
      cargo.instance_variable_set(:@height, 100)  # in cm
      cargo.calculate_price
      expect(cargo.instance_variable_get(:@price)).to eq(200)
    end

    it "calculates the price based on distance and volume for large and light cargo" do
      cargo.instance_variable_set(:@distance, 100)
      cargo.instance_variable_set(:@length, 200)
      cargo.instance_variable_set(:@width, 200)
      cargo.instance_variable_set(:@height, 200)
      cargo.instance_variable_set(:@weight, 10)
      cargo.calculate_price
      expect(cargo.instance_variable_get(:@price)).to eq(200)
    end

    it "calculates the price based on distance and volume for large and heavy cargo" do
      cargo.instance_variable_set(:@distance, 100)
      cargo.instance_variable_set(:@length, 200)
      cargo.instance_variable_set(:@width, 200)
      cargo.instance_variable_set(:@height, 200)
      cargo.instance_variable_set(:@weight, 20)
      cargo.calculate_price
      expect(cargo.instance_variable_get(:@price)).to eq(300)
    end
  end

  describe "#result" do
    it "returns a hash with all cargo and price information" do
      cargo.instance_variable_set(:@weight, 20)
      cargo.instance_variable_set(:@length, 200)
      cargo.instance_variable_set(:@width, 200)
      cargo.instance_variable_set(:@height, 200)
      cargo.instance_variable_set(:@distance, 100)
      cargo.instance_variable_set(:@price, 300)
      expect(cargo.result).to eq({
        weight: 20,
        length: 200,
        width: 200,
        height: 200,
        distance: 100,
        price: 300
      })
    end
  end
end
