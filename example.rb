
require 'pry'
require 'mystery'

# tracer = Mystery.new(path: "foo.rb")

tracer_explicit = Mystery.new(
  path: "example.rb",
  method: :awesome,
  event_names: ['call'],
  variables: [:x]
)

class Foo
  def awesome(x)
    puts "called Foo.awesome!"
    500 +x
  end
end

puts 'starting the trace!'
tracer_explicit.start!
f = Foo.new
f.awesome(100)
f.awesome(200)
f.awesome(300)
f.awesome(700)
puts 'stopping the trace!'
tracer_explicit.stop!
puts '------------------'
puts f.awesome(480)


# binding.pry
