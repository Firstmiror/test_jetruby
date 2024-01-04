require 'httparty'
require 'json'

class CargoTransportation
  def initialize
    @weight = 0
    @length = 0
    @width = 0
    @height = 0
    @origin = ''
    @destination = ''
    @distance = 0
    @price = 0
  end

  def input_cargo_params
    print "Enter weight (kg): "
    @weight = gets.chomp.to_f
    print "Enter length (cm): "
    @length = gets.chomp.to_f
    print "Enter width (cm): "
    @width = gets.chomp.to_f
    print "Enter height (cm): "
    @height = gets.chomp.to_f
  end

  def input_destination_params
    print "Enter origin: "
    @origin = gets.chomp
    print "Enter destination: "
    @destination = gets.chomp
  end

  def calculate_disnance
    url = "http://api.distancematrix.ai/maps/api/dastancematrix/json?origins=#{@origin}&destinations=#{@destination}"
    response = HTTParty .get(url)
    result = JSON.parse(response.body)
    @distance = result['rows'][0]['elements'][0]['distance']['value']
  end

  def calculate_price
    volume = (@length * @width * @height) / 1000000

    if volume < 1
      @price = @distance * 1
    elsif volume >= 1 && @weight <= 10
      @price = @distance * 2
    elsif volume >= 1 && @weight > 10
      @price = distance * 3
    end
  end

  def result
    {
      weight: @weight,
      length: @length,
      width: @weight,
      height: @height,
      distance: @distance,
      price: @price
    }
  end
end
