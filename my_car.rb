class MyCar

  attr_accessor :color
  attr_reader :year

  def self.gas_mileage(gallons, miles)
    puts "Car gets #{miles/gallons} miles per gallon of gas"
  end

  def initialize(color, model, year)
    @color = color
    @model = model
    @year = year
    @current_speed = 0
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

  def spray_paint(color)
    self.color = color
    puts "The car is painted #{color} now."
  end

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
