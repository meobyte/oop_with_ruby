1 Ben is right because the class has ```attr_reader :balance```

2 change ```quantity``` to ```@quantity```

3 It allows ```quantity``` to be altered publically.

4
```ruby
class Greeting
  def greet(message)
    puts message
  end
end

class Hello < Greeting
  def hi
    greet("Hello")
  end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end
```

5
```ruby
class KrispyKreme
  attr_reader :filling_type, :glazing

  def initialize(filling_type, glazing)
    @filling_type = filling_type
    @glazing = glazing
  end

  def to_s
    filling_string = filling_type ? filling_type : "Plain"
    glazing_string = glazing ? "with #{glazing}" : ''
    "#{filling_string} #{glazing_string}"
  end
end
```

6 no difference

7 change ```self.light_information``` to ```self.information```