module Towable
  def can_tow?(pounds)
    pounds < 2000 ? true : false
  end
end

class Vehicle
  attr_accessor :color
  attr_reader :model, :year
  @@number_of_vehicles = 0

  def initialize(color, model, year)
    @@number_of_vehicles += 1
    @color = color
    @model = model
    @year = year
    @current_speed = 0
  end

  def self.number_of_vehicles
    puts "#{@@number_of_vehicles} have been created."
  end

  def self.gas_mileage(gallons, miles)
    puts "#{miles / gallons} miles per gallon of gas"
  end

  def spray_paint(color)
    self.color = color
    puts "It's painted #{color} now."
  end

  def speed_up(number)
    @current_speed += number
    puts "You push the gas and speed up by #{number} mph"
  end

  def brake(number)
    @current_speed -= number
    puts "You push the brake and slow down by #{number} mph"
  end

  def current_speed
    puts "You are now going #{@current_speed} mph."
  end

  def turn_off
    @current_speed = 0
    puts "Parking."
  end

  def age
    puts "Your #{self.model} is #{years_old} years old."
  end

  private

  def years_old
    Time.now.year - self.year
  end
end

class MyTruck < Vehicle
  include Towable
  DOORS = 2

  def to_s
    "My car is a #{color}, #{year}, #{@model}!"
  end
end

class MyCar < Vehicle
  DOORS = 4

  def to_s
    "My car is a #{color}, #{year}, #{@model}!"
  end
end

cavalier = MyCar.new("blue", "chevy cavalier", 1988)

cavalier.speed_up(10)
cavalier.current_speed
cavalier.brake(5)
cavalier.current_speed
cavalier.turn_off
cavalier.current_speed
cavalier.color = "red"
puts cavalier.color
puts cavalier.year
cavalier.spray_paint("sliver")
MyCar.gas_mileage(15, 180)
puts cavalier
cavalier.age
puts MyCar.ancestors
puts MyTruck.ancestors
puts Vehicle.ancestors
